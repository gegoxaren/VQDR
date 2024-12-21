using Vee;
using GLib;

void named_vector_test () {
  Test.add_func (VEE_TEST_NAMED_VECTOR_PREFIX + "new", () => {
    var nv = new NamedVector<int> ("Hello,", 13, "world", 37, "!!", 69);
    if (nv == null) {
      Test.fail ();
      Test.message ("`new NamedVector ()` returned a null.");
    }
  });

  Test.add_func (VEE_TEST_NAMED_VECTOR_PREFIX + "sanity", () => {
    var nv = new NamedVector<int> ("A", 1, "B", 2, "C", 3);
    
    var tmp_name = nv.names[0];
    if (tmp_name != "A") {
      Test.message ("Gotten value (%s) did not match the" +
                      " expected value (A)", nv.names[0]);
    }

    tmp_name = nv.names[1];
    if (tmp_name != "B") {
      Test.message ("Gotten value (%s) did not match the" +
                      " expected value (B)", nv.names[0]);
    }
 
    tmp_name = nv.names[2];
    if (tmp_name != "C") {
      Test.message ("Gotten value (%s) did not match the" +
                      " expected value (C)", nv.names[0]);
    }

  });

  Test.add_func (VEE_TEST_NAMED_VECTOR_PREFIX + "foreach", () => {
    var nv = new NamedVector<int> ("A", 1, "B", 2, "C", 3);

    nv.foreach ((name, val) => {
      message ("%s has the value: %i \n", name, val);
      return true;
    });
  });
}
