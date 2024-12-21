namespace VQDR {
  public errordomain ArgError {
    INVALID_ARGUMENT,
    INDEX_OUT_OF_BOUNDS;
  }
  
  public errordomain OperandError {
    MISSING_OPERAND;
  }
  
  public errordomain ParseError {
    INVALID_CHARECTER,
    NOT_READY,
    ALLREADY_PARSED,
    INVALID_DATA;
  }
  
  public errordomain EvaluationError {
    MISSING_TOKEN,
    INVALID_TOKEN;
  }
  
  public errordomain ParamError {
    OUT_OF_BOUNDS;
  }

  
  public errordomain  LoopError {
    TO_LONG,
    INFINITE;
  }
}
