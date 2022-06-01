namespace VQDR.Expression {
  public class ConstantValueToken : ValueToken {
    
    construct {
      this.priority = Prio.VALUE;
      mandatory_num_child = 0;
    }
    
    public ConstantValueToken (int64 val, int position) {
      base (position);
      this.result_value.number = val;
      this.result_min_value.number = val;
      this.result_max_value.number = val;
    }
    
    protected override void evaluate_self (Context instance) throws GLib.Error {
      this.result_string = this.result_value.to_string ();
    }
    
  }
}
