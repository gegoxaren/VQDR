using GLib;

int main (string[] args) {
  Test.init (ref args);
  
  Test.message ("------------ Common tests ------------");
  
  //gobject_to_string_test ();
  fast_number_test ();
  
  return Test.run ();
}
