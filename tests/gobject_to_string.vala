using VQDR.Common.Utils;
using VQDR.Expression;

class MyTestClass : GLib.Object {
   public int prop_int {get; set;}
   public string prop_string {get; set;}
   public bool prop_bool {get; set;}
   
}

int main (string[] args) {
  
  var v1 = GLib.Object.new (typeof (MyTestClass),
                                   prop_int: 1337,
                                   prop_string: "string",
                                   prop_bool: true);
  
  print (object_to_string (v1));
  
  return 0;
}
