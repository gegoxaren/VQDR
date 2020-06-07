namespace VQDR.Expression {
  public class ConstantValueToken : ValueToken {
    
    construct {
      this.priority = PRIO_VALUE;
    }
    
    public ConstantValueToken (long value, int position) {
      base (position);
      this.result_value = value;
      this.result_min_value = value;
      this.result_max_value = value;
    }
    
    protected override void evaluate_self (Context instance) throws GLib.Error {
      this.result_string = this.result_value.to_string ();
    }
    
  }
}
