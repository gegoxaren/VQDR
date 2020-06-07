using VQDR.Expression;

void
test_value_token () {
  GLib.Test.add_func ("/VQDR/Exprossion/Token/Value/sanity", () => {
    var ctx = new Context ();
    
    if (ctx == null) {
      GLib.Test.message ("Context was null.");
      GLib.Test.fail ();
      GLib.assert_not_reached ();
    }
    
    if (!(ctx.get_type ().is_a (typeof (Context)))) {
      GLib.Test.message ("Context is not the right type.");
      GLib.Test.fail ();
      GLib.assert_not_reached ();
    }
    
    var v1 = new ConstantValueToken (13,37);
    var v2 = new VariableValueToken ("my-val", 13);
    
    #if 0
    // This should work, but it does not... It is a vala parsing bug...
    // I think...
    bool value_test = ((v1 is typeof (ConstantValueToken)) ||
                       (v1 is typeof (ValueToken)) ||
                       (v1 is typeof (Token)));
    
    #endif
    
    Type t1 = v1.get_type ();
    if (!(t1.is_a (typeof (ConstantValueToken))) ||
        !(t1.is_a (typeof (ValueToken))) ||
        !(t1.is_a (typeof (Token)))) {
      GLib.Test.message ("The ConstastValueToken is not the corret type.");
      GLib.Test.fail ();
      GLib.assert_not_reached ();
    }
    
   Type t2 = v2.get_type ();
    if (!(t2.is_a (typeof (VariableValueToken))) ||
        !(t2.is_a (typeof (ValueToken))) ||
        !(t2.is_a (typeof (Token)))) {
      GLib.Test.message ("The VariableValueToken is not the corret type.");
      GLib.Test.fail ();
      GLib.assert_not_reached ();
    }
    
    
  });
  
  GLib.Test.add_func ("/VQDR/Exprossion/Token/Value/Constant", () => {
    try {
      long in_val = 12;
      
      var ctx = new Context ();
      
      var v1 = new ConstantValueToken (in_val, 1);
      
      var root_t = new RootToken (v1);
      
      root_t.evaluate (ctx);
      
      long out_val = root_t.result_value;
      
      if (out_val != in_val) {
        GLib.Test.message ("The values do not match");
        GLib.Test.fail ();
      }
    } catch (GLib.Error? e) {
       GLib.Test.message ("An error occured: domain: %s, message: %s", e.domain.to_string (), e.message);
       GLib.Test.fail ();
    }
  });
  
  GLib.Test.add_func ("/VQDR/Exprossion/Token/Value/ConstantLoop", () => {
    
    
    try {
      var ctx = new Context ();
      
      for (int i = 0; i <= 10000; i++ ) {
        var v1 = new ConstantValueToken (i, 1);
        
        var root_t = new RootToken (v1);
        
        root_t.evaluate (ctx);
        
        long out_val = root_t.result_value;
        
        if (out_val != i) {
          GLib.Test.message ("The values do not match");
          GLib.Test.fail ();
        }
      }
    } catch (GLib.Error? e) {
       GLib.Test.message ("An error occured: domain: %s, message: %s", e.domain.to_string (), e.message);
       GLib.Test.fail ();
    }
  });
  
  GLib.Test.add_func ("/VQDR/Exprossion/Token/Value/Varuable", () => {
    try {
      var ctx = new Context ();
      ctx.set_value ("a", 0, 0, 13);
      ctx.set_value ("not a", 0, 0, 37);
      
      // Context variable santy check.
      if ((ctx.get_value ("a") != 13) || (ctx.get_value ("not a") != 37)) {
          GLib.Test.message ("The values do not match");
          
          GLib.Test.fail ();
      }
      
      var v1 = new VariableValueToken ("a", 1);
      var v2 = new VariableValueToken ("not a", 1);
      
    } catch (GLib.Error? e) {
       GLib.Test.message ("An error occured: domain: %s, message: %s", e.domain.to_string (), e.message);
       GLib.Test.fail ();
    }
  });
  
  
}
