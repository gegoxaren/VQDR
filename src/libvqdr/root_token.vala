namespace VQDR.Expression {
  
  public class RootToken : Token {
    
    construct {
      this.priority = Prio.ASSIGNMENT;
      this.mandatory_num_child = 1;
      this.optional_num_child = 0;
    }
    
    public RootToken (Token? root = null) {
      base (0);
      this.set_child (1, root);
    }
    
    protected override void evaluate_self (Context instance) throws GLib.Error {
      Token? child = get_child (1);
      child.evaluate (instance);
      this.result_value = child.result_value;
      this.result_max_value = child.result_max_value;
      this.result_min_value = child.result_min_value;
      this.result_string = child.result_string;
      
    }
    
  }
  
}
