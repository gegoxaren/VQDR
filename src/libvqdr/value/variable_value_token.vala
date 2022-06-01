namespace VQDR.Expression {
  
  public class VariableValueToken : ValueToken {
    
    protected string name;
    
    construct {
      this.priority = Prio.VALUE;
    }
    
    public VariableValueToken (string name, int32 position) {
      base (position);
      this.name = name;
    }
    
    
    public override void evaluate_self (Context instance) throws GLib.Error {
      // in the original code there was a check to see if the intance
      // was null, this is not needed here as we don't allow null for that
      // value.
      try {
        result_value = instance.get_value (name);
        result_string = "[" + name + ":" + result_value.to_string () + "]";
      } catch (GLib.Error? e) {
        result_value.number = 0;
        result_min_value.number = 0;
        result_max_value.number = 0;
        result_string = "";
        
        GLib.Error? err = null;
        GLib.Error.propagate (out err, e);
        throw e;
      }
    }
    
  }
  
}
