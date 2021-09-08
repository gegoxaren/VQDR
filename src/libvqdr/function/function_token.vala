using Gee;

using VQDR.Expression;
using VQDR.Common;

namespace VQDR.Expression {
  public abstract class FunctionToken : Token {
    protected FunctionToken () {
      base (0);
    }
    
    // We only store the type, as that is what is important.
    private static Gee.HashMap<string, Type?> _allowed_functions;
    
    protected const long UNDEFINED = long.MIN + 1; //+1 so that I can still use Long.MIN_VALUE.
    /** Right arrow */
    protected const string CH_RARR = "\u2192";
    /** Left arrow */
    protected const string CH_LARR = "\u2190";
    /** Round up open bracket */
    protected const string CH_RUP_OP = "\u2308";
    /** Round up closed bracket */
    protected const string CH_RUP_CL = "\u2309";
    /** Round down open bracket */
    protected const string CH_RDN_OP = "\u230a";
    /** Round down closed bracket */
    protected const string CH_RDN_CL = "\u230b";
    /** Absolute open bracket */
    protected const string CH_ABS_OP = "|";
    /** Absolute closed bracket */
    protected const string CH_ABS_CL = "|";
    /** Greater than */
    protected const string CH_GT = ">";
    /** Lower than */
    protected const string CH_LT = "<";
    /** Equal */
    protected const string CH_EQUAL = "=";

    /** Begin of a complex result */
    protected const string SYM_BEGIN = "[";
    /** End of a complex result */
    protected const string SYM_END = "]";
    /** Begin of a complex result, alternative */
    protected const string SYM_BEGIN_ALT = "{";
    /** End of a complex result, alternative */
    protected const string SYM_END_ALT = "}";
    /** Separator for different roll result */
    protected const string SYM_SEP = ",";
    /** Separator for different value of same roll */
    protected const string SYM_SEP_SAME = ":";
    /** Separator for  overall (fumble, critical, botch, glitch) */
    protected const string SYM_SEP_ = "\u2261"; //"=" (with 3 lines)
    /** Denotes a success */
    protected const string SYM_SUCCESS = "!";
    /** Denotes a failure */
    protected const string SYM_FAILURE = "*";
    /** Denotes an extra result */
    protected const string SYM_EXTRA = "!";
    /** Denotes a selected result */
    protected const string SYM_SELECTED = "!";
    /** Separator for exploding rolls */
    protected const string SYM_EXPLODE = "\u00bb"; //">>"

    /** Truncated output: ellipsis */
    protected const string SYM_TRUNK_PART_ELLIPSIS = "\u2026"; //"..."
    /** Truncated output: equal */
    protected const string SYM_TRUNK_PART_EQUAL = CH_EQUAL; //"="
    /** Truncated output: begin */
    protected const string SYM_TRUNK_BEGIN = SYM_BEGIN + SYM_TRUNK_PART_ELLIPSIS + SYM_TRUNK_PART_EQUAL; //"[...="
    /** Truncated output: end */
    protected const string SYM_TRUNK_END = SYM_END; //"]"
    
    construct {
      _allowed_functions = new Gee.HashMap<string, Type?> ();
      this.priority = Prio.FUNCTION;
    }
    
    /**
     * Ititialise the right functon token by it's name.
     * 
     * @param token Token of the Function.
     * @param position Token position.
     * @return An instance representing the function, or @c null if not found.
     */
    public static FunctionToken? init_token (string token, int position) {
      FunctionToken? retval = null;
      
      // We get the token type.
      Type? t = _allowed_functions.@get (token.down ());
      
      if (t != null) {
          // Construct a new instance of the token.
          retval = (FunctionToken) GLib.Object.@new (t, null, null);
          
      }
      
      return retval;
    }
    
    /**
     * Add a FunctionToken Type to the list of allowed functions.
     * 
     * Note: The Type must be derived from FunctionToken, as there is an
     *        assert that chkecks.
     */
    public static void add_function (string token, Type t) {
      assert (t.is_a (typeof (FunctionToken)) == true);
      _allowed_functions.@set (token, t);
    }
    
    public static string get_function_name (Type t) {
      assert (t.is_a (typeof (FunctionToken)) == true);
      string ret_val = null;
      
      _allowed_functions.map_iterator ().@foreach ((k,v) => {
        if (v == t) {
          ret_val = k;
          return false;
        }
        return true;
      });
      
      return ret_val;
    }
    
    protected FastNumber get_optional_child_raw_result (Context instance,
                                                  int index,
                                                  long default_result)
                                                  throws GLib.Error {
     Token? tmp_roll = get_child (index);
    
     if (tmp_roll != null) {
         tmp_roll.evaluate (instance);
         return tmp_roll.result_value;
     } else {
       return FastNumber.raw (default_result);
     }
    }
    
    
    
  }
}
