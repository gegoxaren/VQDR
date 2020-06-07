namespace VQDR.Expression {
  
  public abstract class ValueToken : Token {
    protected ValueToken (int position) {
      base (position);
    }
  }
  
  public static ValueToken? init_constant_token (long val, int position) {
    //return new ConstantValueToken (val, position);
    return null;
  }
  
  public static ValueToken? init_variable_token (string name, int position) {
    //return new VariableValueToken (name, position);
    return null;
  }
  
  public static long parse_raw_value (string str) {
    long ret_val = 0;
    int i_of_dot = str.index_of_char ('.');
    if (i_of_dot >= 0) {
    
      // Get the decimal value from the string, if such a thing exists.
      if ((str.length - 1 > i_of_dot)) {
        ret_val = long.parse ((str + "000").substring (i_of_dot + 1));
        
      }
      
      // Normalise the digits.
      while (ret_val > Token.VALUES_PRECISION_FACTOR) {
        ret_val = ret_val / 10;
      }
      
      // Add intiger value
      ret_val = ret_val + (long.parse ("0" + str.substring (0, i_of_dot)) * Token.VALUES_PRECISION_FACTOR);
    } else {
      ret_val = long.parse (str) * Token.VALUES_PRECISION_FACTOR;
    }
    return ret_val;
  }
  
  
}
