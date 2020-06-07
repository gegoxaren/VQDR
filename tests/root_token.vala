using VQDR.Expression;

void root_token_test () {
  Test.add_func ("/VQDR/Expression/TokenRoot/construction", () => {
    RootToken t = new RootToken ();
    assert (t != null);
  });
  
  Test.add_func ("/VQDR/Expression/TokenRoot/priority", () => {
     RootToken t = new RootToken ();
     assert (t.priority == 0);
  });
}
