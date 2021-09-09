namespace VQDR.Expression {
  
  public abstract class ValueToken : Token {
    protected ValueToken (int position) {
      base (position);
    }
  }
  
  public static ValueToken? init_constant_token (long val, int position) {
    return new ConstantValueToken (val, position);
  }
  
  public static ValueToken? init_variable_token (string name, int position) {
    return new VariableValueToken (name, position);
  }
  
  
  
}
