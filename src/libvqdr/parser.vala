using Utils;

namespace VQDR.Expression {

  public enum CharType {
    INVALID = 0,
    NULL = 1,
    DIGIT,
    UOP,
    OP,
    ALPHA,
    DOT,
    POP,
    PCL,
    COM,
    UNKNOWN,
    _NUM_VAL;

    public string to_string () {
      // We add one as we have an invalid case.
      static_assert (CharType._NUM_VAL == 10 + 1);
      switch (this) {
        case (NULL): 
          return "NULL";
        case (DIGIT):
          return "DIGIT";
        case (UOP):
          return "UOP";
        case (OP):
          return "OP";
        case (ALPHA):
          return "ALPHA";
        case (DOT):
          return "DOT";
        case (POP):
          return "POP";
        case (PCL):
          return "PLC";
        case (COM):
          return "COM";
        case (UNKNOWN):
          return "UNKNOWN";
        default:
          assert_not_reached ();
      }
    }

  /**
   * Determine character type.
   * @param ch Character to be checked.
   * @return The character type.
   */
    public static CharType from_char (char ch) {
      switch (ch) {
        case '0': case '1':
        case '2': case '3':
        case '4': case '5':
        case '6': case '7':
        case '8': case '9':
          return DIGIT;
        case '+': case '-':
          return UOP;
        case '*': case '/':
          return OP;
        case '.':
          return DOT;
        case '(':
          return POP;
        case ')':
          return PCL;
        case ',':
          return COM;
        case ' ': case 0:
          return NULL;
        default:
          if ((ch >= 'a' && ch <= 'z') || (ch>= 'A' && ch <= 'Z' )) {
            return ALPHA;
          }
          return UNKNOWN;
      }
    }
  }

  public class Parser {
    private static string[] EMPTY_VAR_KEYS = new string[0];
    private Context context = null;
    /** Contains the used variable names. */
    private string[] variable_keys;
    /** contains the used variables and their last value. */
    private HashTable<string, Variable?> variable_cache; 
    /** Will contain the Root of the token tree.
     * Asumes that there it has no parents.*/
    private Token root_token;
    private Token root;
    private bool parsed = false;
    private bool evaluated_once;
    private string internal_experisson;
    public string expression {
      get {return internal_experisson;}
      set {internal_experisson = value;
           expression_size = value.length;
           reset ();}
    }
    private size_t expression_size = 0;
    private char cur_char = 0;
    private int32 index = -1;

    private FastNumber result_value;
    private FastNumber result_max_value;
    private FastNumber result_min_value;

    private string result_string;
    private Error? error;


    public Parser (string expression) {
      this.expression = expression;
      this.expression_size = expression.length;
      this.cur_char = expression[0];
      this.index = 0;
    }

    public Parser.empty () {
      expression = "";
    }

    public void reset () {
      root_token = null;
      root = null;
      parsed = false;
      evaluated_once = false;
      result_value = FastNumber (0);
      result_min_value = FastNumber (0);
      result_max_value = FastNumber (0);
      result_string = "";
      variable_cache.remove_all ();
      variable_keys = EMPTY_VAR_KEYS;
      error = null;
      index = 0;
    }

    /**
     * Parse the expersson string.
     */
    public void parse () throws ParseError {
      if (parsed) {
        throw new ParseError.ALLREADY_PARSED 
              ("Data has allparsed been parsed.");
      }


      while (this.index <= this.expression_size) {
        switch (CharType.from_char (this.cur_char)) {
          case CharType.NULL:
            this.parse_advance ();
            break;
          default:
            assert_not_reached ();
        }
      }
      this.parsed = true;
    } // end parse ()

    /*
     * advance the parser. 
     */
    private void parse_advance () {
      if (this.index < this.expression_size && this.cur_char != '\0') {
        this.index++;
        this.cur_char = this.expression[this.index];
      }
    }

    protected bool valid_bounds () {
      if (!evaluated_once) {
        return false;
      }

      if (context != null) {
        try {
          foreach (var key in variable_keys) {
            if (!context.has_name (key) ||
                !variable_cache.get (key).equals (context.get_variable (key))) {
              return false;
            }
          }
        } catch (Error e) {
          err_print_ln ("Something went wrong: (%: %)", e.domain, e.message);
          assert_not_reached ();
        }
      }
      return true;
    }

    protected void set_variable_cach_values () {
      if (context != null) {
        try {
          foreach (var key in variable_keys) {
            variable_cache.insert (key, Variable.copy
                                   (context.get_variable (key)));
          }
        } catch (Error e) {
          err_print_ln ("Something went wrong: (%: %)", e.domain, e.message);
          assert_not_reached ();
        }
      }
    }

    protected void set_error (Error e) {
      expression = "";

      result_string = "Error";

      set_variable_cach_values ();

      error = e;
    }

    protected void set_result (Token root_token) {
      // evaluate = true;
      evaluated_once = true;

      result_value = root_token.result_value;
      result_max_value = root_token.result_max_value;
      result_min_value = root_token.result_min_value;
      result_string = root_token.result_string;

      set_variable_cach_values ();

      error = null;
    }

    protected void evaluate () throws Error {
      try {
        parse ();

        if (root_token == null) {
          root_token = new RootToken (root);
        }

        root_token.evaluate (context);

        set_result (root_token);
      } catch (Error e) {
        set_error (e);
        throw e;
      }
    }

    /**
     * Add a note (operator) to the stack after popping it's parameters.
     * @param operand_stack stack
     * @param operator operator.
     */
    protected void add_node (Stack<Token> operand_stack,
                             Token operator) throws Error {
      if (operator is FunctionToken) {
        FunctionToken funk = (FunctionToken) operator;
        int32 param_num = funk.next_child_num;
        for (var i = 0; i < param_num; i++) {
          Token param_child = operand_stack.pop ();
          funk.set_child (param_num - 1, param_child);

          operand_stack.push (funk);
        }
      } else if (operator is UnaryOperator &&
                 ((UnaryOperator) operator).is_unary) {
        if (operand_stack.elements < 1) {
          throw new OperandError.MISSING_OPERAND
                    (@"Missing operand. Position: $(operator.position)");
        }
      } else {
        if (operand_stack.elements < 2) {
          throw new OperandError.MISSING_OPERAND
                    (@"Missing operand. Position: $(operator.position)");
        }
        operator.set_right_child (operand_stack.pop ());
        operator.set_left_child (operand_stack.pop ());
        operand_stack.push (operator);
      }
    }
  } // end of Parser class
}
