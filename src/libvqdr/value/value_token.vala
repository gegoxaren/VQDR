namespace VQDR.Expression {
  
  public abstract class ValueToken : Token {
    protected ValueToken (int32 position) {
      base (position);
    }
    
    public static ValueToken? init_constant_token (long val, int32 position) {
      return new ConstantValueToken (val, position);
    }
    
    public static ValueToken? init_variable_token (string name,
                                                   int32 position) {
      return new VariableValueToken (name, position);
    }
    
    public static ValueToken? init_value_token (Value p1, int32 position) {
      switch (p1.type ()){
        case (Type.STRING):
          return init_variable_token (p1.get_string (), position);
        case (Type.LONG):
          return new ConstantValueToken (p1.get_long (), position);
      }
      return null;
    }
  }
  
}
