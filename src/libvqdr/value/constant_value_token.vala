namespace VQDR.Expression {
  public class ConstantValueToken : ValueToken {
    
    construct {
      this.priority = PRIO_VALUE;
    }
    
    public ConstantValueToken (long val, int position) {
      base (position);
      this.result_value.number = val;
      this.result_min_value.number = val;
      this.result_max_value.number = val;
      
      print("bobobo: %li \n", result_value.number);
    }
    
    protected override void evaluate_self (Context instance) throws GLib.Error {
      this.result_string = this.result_value.to_string ();
    }
    
  }
}
