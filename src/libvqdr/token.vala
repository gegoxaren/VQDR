using VQDR.Common;
using GLib;

namespace VQDR.Expression {
  
  public abstract class Token : GLib.Object {
    /** Precision used to perform evaluation */
    public const int VALUES_PRECISION_DIGITS = 3;
    /** Precision factor used to convert raw values to actual ones */
    public const int VALUES_PRECISION_FACTOR = 1000;
    //public static int VALUES_PRECISION_FACTOR = (int)Math.pow(10, VALUES_PRECISION_DIGITS);
    
    /** Precision used to output values */
    public const int VALUES_OUTPUT_PRECISION_DIGITS = 2;
    /** Precision factor used to evaluate output */
    public const int VALUES_OUTPUT_PRECISION_FACTOR = 100;
    //public static int VALUES_OUTPUT_PRECISION_FACTOR = (int)Math.pow(10, VALUES_OUTPUT_PRECISION_DIGITS);
    
    
    /** Max size of a single token */
    public const int MAX_TOKEN_STRING_LENGTH = 64;
    /** Max size of an expression */
    public const int MAX_TOTAL_STRING_LENGTH = 200;

    /** Max iteration number for a token (function) */
    public const int MAX_TOKEN_ITERATIONS = 500;
    /** Max iteration number for the expression */
    public const int MAX_TOTAL_ITERATIONS = 5000;

    /* ************************************* */
    /* Operator precedence and associativity */
    /* ************************************* */
    /** Priority for assignment "=" operator */
    public const int PRIO_ASSIGNMENT = 0;
    /** Priority for conditional OR "||" operator */
    public const int PRIO_CONDITIONAL_OR = 2;
    /** Priority for conditional AND "&&" operator */
    public const int PRIO_CONDITIONAL_AND = 3;
    /** Priority for equality "==" and "!=" operators */
    public const int PRIO_EQUALITY = 4;
    /** Priority for comparison ">", "<", ">=", etc operators */
    public const int PRIO_COMPARISON = 5;
    /** Priority for addictive "+" and "-" operators */
    public const int PRIO_ADDICTIVE = 6;
    /** Priority for multiplicative "*" and "/" operators */
    public const int PRIO_MULTIPLICATIVE = 7;
    /** Priority for unary "+" and "-" and "!" operators */
    public const int PRIO_UNARY = 8;
    /** Priority for label assignment ":" operator */
    public const int PRIO_LABEL = 9;
    /** Priority for dice "d" operator */
    public const int PRIO_DICE = 10;
    /** Priority for functions */
    public const int PRIO_FUNCTION = 11;
    /** Priority for values */
    public const int PRIO_VALUE = 12;

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
    
    
    public long result_value {public get; protected set; default = 0;}
    public long result_max_value {public get; protected set; default = 0;}
    public long result_min_value {public get; protected set; default = 0;}
    public string result_string {public get; protected set; default = "";}
    
    construct {
      // Valgrind says there is a memory leak here... But it's actually
      // GObject's constructor that is leaking.
      children = new Token[max_num_child];
      next_child = 0;
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
      if (result_max_value < result_min_value) {
        long tmp = result_max_value;
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
    
    /* *********** IGNORE THE MESS I HAVE CREATED FRO MY SELF *************** */
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
