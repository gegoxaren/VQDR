namespace VQDR.Expression {
  
  class AddOperatorToken : OperatorToken, UnaryOperator {
    
    public override bool is_unary {get; set; default = false;}
    
    public override Token.Prio priority {protected get {
      if (is_unary) {
        return Prio.UNARY;
      } else {
        return Prio.ADDICTIVE;
      }
    } protected construct set {}} // set_priority will have no effect.
    
    construct {
      mandatory_num_child = 2;
      
    }
    
    public AddOperatorToken (int32 position) {
      base (position);
    }
    
    public override void evaluate_self (Context instance) throws GLib.Error {
      Token r_child = get_right_child (),
            l_child = get_left_child ();
       
      if (r_child == null || l_child == null) {
          var sb = new StringBuilder ("(AddOperationToken) Missing ");
          if (l_child == null && r_child == null) {
            sb.append ("both left and right ");
          } else if (r_child == null) {
            sb.append ("left "); 
          } else {
            sb.append ("right ");
          }
          sb.append ("tokens.");
          throw new Utils.EvaluationError.MISSING_TOKEN (sb.str);
        }
       
      if (is_unary) {
        l_child.evaluate (instance);
        r_child.evaluate (instance);
        
        result_value = l_child.result_value.add (l_child.result_value);
        result_max_value = l_child.result_max_value.add (l_child.result_max_value);
        result_min_value = l_child.result_min_value.add (l_child.result_min_value);
        reorder_max_min_values ();
        result_string = l_child.result_string + "+" + l_child.result_string;
      }
    }
    
  }
  
  
}
