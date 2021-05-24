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
          //break;
        case "-":
          return new SubtractOperatorToken (position);
          //break;
        case "*":
          return new MultiplyOperatorToken (position);
          //break;
        case "/":
          return new DivideOperatorToken (position);
          //break;
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
