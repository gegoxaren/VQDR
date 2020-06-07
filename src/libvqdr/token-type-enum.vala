namespace VQDR.Expression {
  
  enum TokenType {
    ROOT = -1,
    NONE = 0,
    
    CONSTANT,
    VARIABLE,
    
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    
    DICE,
    
    
    ABS,
    
    BRANCH,
    
    ROUND_UP,
    ROUND_DOWN,
    
    POOL,
    
    ROLL_AND_KEEP,
  }
  
}
