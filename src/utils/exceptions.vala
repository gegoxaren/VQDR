[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  [CCode (cname = "VArgError", cprefix = "V_ARG_ERROR_")]
  public errordomain ArgError {
    INVALID_ARGUMENT,
    INDEX_OUT_OF_BOUNDS;
  }
  [CCode (cname = "VMathError", cprefix = "V_MATH_ERROR_")]
  public errordomain MathError {
    DIVIDE_BY_ZERO;
  }
  [CCode (cname = "VOperandError", cprefix = "V_OPERAND_ERROR_")]
  public errordomain OperandError {
    MISSING_OPERAND;
  }
  [CCode (cname = "VParserError", cprefix = "V_PARSER_ERROR_")]
  public errordomain ParseError {
    INVALID_CHARECTER,
    NOT_READY,
    ALLREADY_PARSED,
    INVALID_DATA;
  }
  [CCode (cname = "VEvaluationError", cprefix = "V_EVALIUATION_ERROR_")]
  public errordomain EvaluationError {
    MISSING_TOKEN,
    INVALID_TOKEN;
  }
  [CCode (cname = "VParamError", cprefix = "V_PARAM_ERROR_")]
  public errordomain ParamError {
    OUT_OF_BOUNDS;
  }

  [CCode (cname = "VLoopError", cprefix = "V_LOOP_ERROR_")]
  public errordomain  LoopError {
    TO_LONG,
    INFINITE;
  }
  
}
