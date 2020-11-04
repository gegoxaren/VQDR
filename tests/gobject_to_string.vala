using GLib;

using VQDR.Common.Utils;
using VQDR.Expression;

class MyTestClass : GLib.Object {
   public int prop_int {get; set;}
   public string prop_string {get; set;}
   public bool prop_bool {get; set;}
}

class MyTestClassString : GLib.Object {
   public string prop_string {get; set;}
}

class MyTestClassInt : GLib.Object {
   public int prop_int {get; set;}
}

class MyTestClassBool : GLib.Object {
   public bool prop_bool {get; set;}
}

class MyTestClassVariant : GLib.Object {
   public GLib.Variant prop_var {get; set;}
}


void gobject_to_string_test () {
  
  Test.add_func ("/Common/Utils/gobject_to_string_int", () => {
    var v1 = GLib.Object.new (typeof (MyTestClassInt),
                                     prop_int: 1337);
    string got_string = object_to_string (v1);
    
    debug (got_string);
    
    string expected = "(MyTestClassInt):\n\t(gint) prop-int: 1337\n";
    
    debug (expected);
    
    if (expected != got_string) {
      Test.fail ();
      Test.message ("The output sting does not match the expected string.");
    }
  });
  
  Test.add_func ("/Common/Utils/gobject_to_string_string", () => {
    var v1 = GLib.Object.new (typeof (MyTestClassString),
                                     prop_string: "string");
    
    string got_string = object_to_string (v1);
    
    debug (got_string);
    
    string expected = "(MyTestClassString):\n\t(gchararray) prop-string: string\n";
    
    debug (expected);
    
    if (expected != got_string) {
      Test.fail ();
      Test.message ("The output sting does not match the expected string.");
    }
  });
  
  Test.add_func ("/Common/Utils/gobject_to_string_bool", () => {
    var v1 = GLib.Object.new (typeof (MyTestClassBool),
                                     prop_bool: true);
    
    string got_string = object_to_string (v1);
    
    debug (got_string);
    
    string expected = "(MyTestClassBool):\n\t(gboolean) prop-bool: true\n";
    
    debug (expected);
    
    if (expected != got_string) {
      Test.fail ();
      Test.message ("The output sting does not match the expected string.");
    }
  });
  
  Test.add_func ("/Common/Utils/gobject_to_string_variant", () => {
    var my_var = new Variant ("(ssibb)", "aa", "bb", 10, false, true);
    var v1 = GLib.Object.new (typeof (MyTestClassVariant),
                                     prop_var: my_var);
    
    string got_string = object_to_string (v1);
    
    debug (got_string);
    
    string expected = 
"(MyTestClassVariant):
\t(GVariant) prop-var: (ssibb)
\t(
\t\t((s): 'aa')
\t\t((s): 'bb')
\t\t((i): 10)
\t\t((b): false)
\t\t((b): true)
\t)
";
    
    debug (expected);
    
    if (str_cmp (expected, got_string) != 0) {
      Test.fail ();
      Test.message ("The output sting does not match the expected string.");
    }
  });
  
}
