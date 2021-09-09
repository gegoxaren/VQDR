using VQDR.Expression;

public class VQDR.Expression.RoundDownFunctionToken : FunctionToken {
  public RoundDownFunctionToken () {  base ();  }
  construct {
    mandatory_num_child = 1;
  }
  
  public override void evaluate_self (Context instance) throws GLib.Error {
    Token param = get_child (1);
    
    param.evaluate_self (instance);
    
    result_value = param.result_value.round_down ();
    result_max_value = param.result_max_value.round_down ();
    result_min_value = param.result_min_value.round_down ();
    
    result_string = CH_RND_OP + param.result_string + CH_RND_CL;
  }
  
}
