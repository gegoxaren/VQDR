using GLib;

int main (string[] args) {
  Test.init (ref args);
  
  Test.message ("------------ LibVee tests ------------");
  
  //gobject_to_string_test ();
  fast_number_test ();

  stack_test ();

  named_vector_test ();
  
  return Test.run ();
}
