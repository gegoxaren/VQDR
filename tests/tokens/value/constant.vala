using GLib;
using VQDR.Expression;
void test_t_v_c () {
  Test.add_func (T_V_C_PREFIX + "/Sanity", () => {
    var val1 = (long) Test.rand_int ();
    var val2 = (int) Test.rand_int ();
    var cv = new ConstantValueToken (val1, val2); 
    
    try {
      cv.evaluate (new Context ());
    } catch (GLib.Error e) {
      Test.fail ();
      Test.message ("Could not evaluate Constant value token.\n");
    }
    if (cv.result_string != val1.to_string ()) {
      Test.fail ();
      Test.message (@"Expected value: $val1, Got: $(cv.result_string).\n");
    }
    
    return;
  });

}
