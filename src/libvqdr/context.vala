using Gee;
using Vee;

namespace VQDR.Expression {
  /**
   * This is just a glorified key-value store. It is only used to provide
   * a mapping between variable-names and a Variable instance.
   */
  public class Context : GLib.Object{
    private bool changed;
    private Gee.TreeMap<string, Variable?> values;
    
    
    construct {
      changed = false;
      values = new Gee.TreeMap<string, Variable?>
                              (Vee.str_cmp, null);
    }
    
    public Context () {
    }
    
    public void set_value (string name, 
                           int32 min_val,
                           int32 max_val,
                           int32 current_val) {
      set_variable (name, Variable (min_val, max_val, current_val));
    }
    
    public Variable get_variable (string name) throws ArgError {
      throw_name (name);
      return values.@get (name.down ());
    }

    public void set_variable (string name, Variable? variable) {
      string new_name = name.down ();
      
    if (!(values.has_key (new_name)) ||
          !(values.get(new_name).equals(variable))) {
          
          values.set (new_name, variable);
          changed = true;
      }
    }
    
    private void throw_name (string name) throws ArgError {
      if (! (values.has_key (name.down ()))) {
         throw new ArgError.INVALID_ARGUMENT ("Name \"" +
                                               name.down () +
                                               "\" not defined.");
       }
    }
    
    public FastNumber get_value (string name) throws ArgError {
      throw_name (name);
      return values.@get (name.down ()).current_val;
    }
    
    public FastNumber get_min_value (string name) throws ArgError {
      throw_name (name);
      return values.@get (name.down ()).min_val;
    }
    
    public FastNumber get_max_value (string name) throws ArgError {
      throw_name (name);
      return values.@get (name.down ()).max_val;
    }

    public FastNumber get_current_value (string name) throws ArgError {
      throw_name (name);
      return values.@get (name.down ()).current_val;
    }
    
    public bool has_name (string name) {
      return values.has_key (name.down ());
    }
    
    protected void reset () {
      changed = false;
    }
    
  }
}
