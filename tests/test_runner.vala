using GLib;


static int main (string[] args) {
  Test.init (ref args);
  
  d6_test ();
  root_token_test ();
  test_value_token ();
  
  return Test.run ();
}
