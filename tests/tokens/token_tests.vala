using GLib;

int main (string[] args) {
  Test.init (ref args);

  test_t_v_c ();

  return Test.run ();
}
