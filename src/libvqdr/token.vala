using VQDR.Common;
using GLib;

namespace VQDR.Expression {
  
  public abstract class Token : GLib.Object {
    
    //public static int VALUES_OUTPUT_PRECISION_FACTOR = (int)Math.pow(10, VALUES_OUTPUT_PRECISION_DIGITS);
    
    
    /** Max size of a single token */
    public const int MAX_TOKEN_STRING_LENGTH = 64;
    /** Max size of an expression */
    public const int MAX_TOTAL_STRING_LENGTH = 200;

    /** Max iteration number for a token (function) */
    public const int MAX_TOKEN_ITERATIONS = 500;
    /** Max iteration number for the expression */
    public const int MAX_TOTAL_ITERATIONS = 5000;
    
    
    /** Operator precedence and associativity
     * 
     * higher number is higher priority, and is to be done befroe those
     * with lower number.
     */
    enum Prio {
      /** Priority for assignment "=" operator */
      ASSIGNMENT = 0,
      /** Priority for conditional OR "||" operator */
      CONDITIONAL_OR,
      /** Priority for conditional AND "&&" operator */
      CONDITIONAL_AND,
      /** Priority for equality "==" and "!=" operators */
      EQUALITY,
      /** Priority for comparison ">", "<", ">=", etc operators */
      COMPARISON,
      /** Priority for addictive "+" and "-" operators */
      ADDICTIVE,
      /** Priority for multiplicative "*" and "/" operators */
      MULTIPLICATIVE,
      /** Priority for unary "+" and "-" and "!" operators */
      UNARY,
      /** Priority for label assignment ":" operator */
      LABEL,
      /** Priority for dice "d" operator */
      DICE,
      /** Priority for functions */
      FUNCTION,
      /** Priority for values */
      VALUE;
      
      /** get the name of the priority */
      string to_string () {
        switch (this) {
          case ASSIGNMENT:
            return "prio: assigment";
          case CONDITIONAL_OR:
            return "prio: conditonal or";
          case CONDITIONAL_AND:
            return "prio: conidonal and";
          case EQUALITY:
            return "prio: equality";
          case MULTIPLICATIVE:
            return "prio: multiplicative";
          case UNARY:
            return "prio: unary";
          case LABEL:
            return "prio: label";
          case DICE:
            return "prio: dice";
          case FUNCTION:
            return "prio: function";
          case VALUE:
            return "prio: value";
          default:
            assert_not_reached ();
        }
      }
    }

    /** Generation to use to get the root with {@link #getParent} */
    protected const int ROOT_GENERATION = int.MAX;
    
    /* ********************************************************************** */
    
    /**
     * tells weather the token is right associative or not.
     */
    public bool right_assosiative {get;set; default = false;}
    
    
    private int real_priority;
    
    /** The parent token of this token*/
    protected unowned Token? parent {protected get; protected set;}
    
    public virtual int priority {public get {
      return __get_priority ();
     } protected construct set {
       __set_priority (value);
     }}
    
    /** Starting position of the token in the expression */
    protected int position;
    
    /** The index of the next child */
    private int next_child;
    
    /** 
     * The optional that this child represents.
     * 
     * 
     */
    public int optional_num_child {public get; protected construct set;}
    
    /** The mandatory number of child this token can have */
    public int mandatory_num_child {public get; protected construct set;}
    
    /** 
     * The maximum number of chidren 
     * 
     * This is calculated at runtime as
     * ''optional_num_child + mandatory_num_child''.
     * 
     * Can not be set.
     */
    public int max_num_child {get {
      return optional_num_child + mandatory_num_child;
     }}
     
    /** all children of this token */
    private (unowned Token?)[] children;
    
    /*
     * These values should have a protected setter, but I could not get it to
     * work. So we will have to live with this.
     */
    public FastNumber result_value;
    public FastNumber result_max_value;
    public FastNumber result_min_value;
    public string result_string {public get; protected set; default = "";}
    
    construct {
      children = new Token[max_num_child];
      next_child = 0;
      
      result_value = FastNumber ();
      result_max_value = FastNumber ();
      result_min_value = FastNumber ();
    }
    
    
    protected Token (int position) {
      this.position = position;
    }
    
    /**
     * Reorders result_min_value and result_max_value, so that
     * result_max varue is the bigger of the two, and
     * result_min_value is the smaller.
     */
    protected void reorder_max_min_values () {
      if (result_max_value.compare (result_min_value) <= 0) {
        FastNumber tmp = result_max_value;
        result_max_value = result_min_value;
        result_min_value = tmp;
      }
    }
    
    /**
     * Get a child token to this token.
     * 
     * Child positions are between 1 and max_num_child.
     * 
     * and index of 0 is illegal.
     */
    public unowned Token? get_child (int index) requires (index > 0 && index <= max_num_child) {
      
      return children[index -1 ];
    }
    
    
    /**
     * Set a child token to this this token.
     * 
     * Child positions are between 1 and max_num_child.
     * 
     * and index of 0 is illegal.
     */
    public void set_child (int index, Token? child) requires (index > 0 && index <= max_num_child) {
      
      children[index - 1] = child;
      
      if (children[index - 1] != null) {
        children[index -1].parent = this;
        
      }
    }
    
    /**
     * is functionally equal to get_child (1);
     */
    public Token get_left_child () {
      return get_child (1);
    }
    
    /**
     * is functionally equal to get_child (2);
     */
    public Token get_right_child () {
      return get_child (2);
    }
    
    /**
     * is functionally equal to set_child (1, token);
     */
    public void set_left_child (Token token)  {
      set_child (1, token);
    }
    
    /**
     * is functionally equal to set_child (2, token);
     */
    public void set_right_child (Token token)  {
      set_child (2, token);
    }
    
    public void evaluate (Context instance) throws GLib.Error {
      evaluate_self (instance);
    }
    
    /**
     * Evalutates current token tree.
     * 
     * This Method must evaluate the token subtree, and assign proper values to
     * the following properties:
     * 
     *  * result_value
     *  * result_max_value
     *  * result_min_value
     *  * result_string
     * 
     * @param instance The context to be used valfor this tree.
     * @throws GLib.Error an error if an error has orrured in the evaluation of the tree.
     */
    protected abstract void evaluate_self (Context instance) throws GLib.Error;
    
    /* *********** IGNORE THE MESS I HAVE CREATED FOR MY SELF *************** */
    /** IGNORE ME */
    protected void __set_priority (int prio) {
      real_priority = prio;
    }
    
    /** IGNORE ME*/
    protected int __get_priority () {
      return real_priority;
    }
    
    
  }
  
}
