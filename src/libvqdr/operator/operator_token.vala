using VQDR.Common;

namespace VQDR.Expression {
  public abstract class OperatorToken : Token {
    
    protected OperatorToken (int position) {
      base (position);
    }
    
    public static OperatorToken? init_token (string name,
                                             int position)
                                             throws ParseError {
      switch (name) {
        case "+": 
          return new AddOperatorToken (position);
        case "-":
          return new SubtractOperatorToken (position);
        case "*":
          return new MultiplyOperatorToken (position);
        case "/":
          return new DivideOperatorToken (position);
        case "d":
        case "w":
        case "t":
          //return new DiceOperatiorToken (position);
        break;
      }
      throw new ParseError.INVALID_CHARECTER (@"Could not decode $name," +
                                              " it is not a valid operation.");
    }
    
  }
}
