namespace VQDR.Expression {
  
  class DivideOperatorToken : OperatorToken {
    
    construct {
      mandatory_num_child = 2;
      priority = PRIO_MULTIPLICATIVE;
    }
    
    public DivideOperatorToken (int position) {
      base (position);
    }
    
    public override void evaluate_self (Context instance) throws GLib.Error {
      Token r_child = get_right_child (),
            l_child = get_left_child ();
             
      l_child.evaluate (instance);
      r_child.evaluate (instance);
      
      // Division by zero is not somthing we want to do.
      // Black holes are bad.
      if (l_child.result_value.number == 0) {
        throw new VQDR.Common.MathError.DIVIDE_BY_ZERO
        ("(DivideOperationToken) The left value is less than zero.");
      }
      
      var sb = new GLib.StringBuilder ("(");
      
      // We check the precidence of the token, and inclose the value if
      // it has a lower precidence than multiply, if it is, we enclose it in a
      // praranthesis.
      if (l_child.priority > 0 && l_child.priority < priority) {
        sb.append ("(").append (l_child.result_string).append (")");
        //l_child.result_string = "(" + l_child.result_string + ")";
      } else {
        sb.append (l_child.result_string);
      }
      
      sb.append ("*");
      
      // We do the same with the othre child.
      if (r_child.priority > 0 && r_child.priority < priority) {
        sb.append ("(").append (r_child.result_string).append (")");
        //r_child.result_string = "(" + r_child.result_string + ")";
      } else {
        sb.append (r_child.result_string);
      }
      
      sb.append (")");
      
      result_value = l_child.result_value.divide (l_child.result_value);
      result_max_value = l_child.result_max_value.divide (l_child.result_max_value);
      reorder_max_min_values ();
      result_string = sb.str;
       
    }
    
  }
  
  
}
