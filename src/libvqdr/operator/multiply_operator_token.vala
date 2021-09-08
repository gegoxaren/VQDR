namespace VQDR.Expression {
  
  class MultiplyOperatorToken : OperatorToken {
    
    construct {
      mandatory_num_child = 2;
      priority = Prio.MULTIPLICATIVE;
    }
    
    public MultiplyOperatorToken (int position) {
      base (position);
    }
    
    public override void evaluate_self (Context instance) throws GLib.Error {
      Token r_child = get_right_child (),
            l_child = get_left_child ();
             
      l_child.evaluate (instance);
      r_child.evaluate (instance);
      
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
      
      result_value = l_child.result_value.multiply (l_child.result_value);
      result_max_value = l_child.result_max_value.multiply (l_child.result_max_value);
      result_min_value = l_child.result_min_value.multiply (l_child.result_min_value);
      reorder_max_min_values ();
      result_string = sb.str;
       
    }
    
  }
  
  
}
