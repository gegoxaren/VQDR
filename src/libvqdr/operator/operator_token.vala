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
          //return new AddOperatiorToken (position);
        break;
        case "-":
          //return new SubtractOperatiorTokes (position);
        break;
        case "*":
          //return new MultiplyOperatiorToken (position);
        break;
        case "/":
          //return new DevideOperatiorToken (position);
        break;
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
