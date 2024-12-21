using Vee;
using GLib;

void stack_test () {
  Test.add_func (VEE_TEST_STACK_PREFIX + "new", () => {
    var stk = new Stack<int> ();
    if (stk == null) {
      Test.fail ();
      Test.message ("Could not create stack");
    }

    if (stk.is_empty () == false) {
      Test.fail ();
      Test.message ("The newly created Stack" +
                    " has the reports it's not empty.");
    }
    
  });

  Test.add_func (VEE_TEST_STACK_PREFIX + "push_pop", () => {
    var stk = new Stack<int> ();
    stk.push (1337);
    if (stk.is_empty ()) {
      Test.fail ();
      Test.message ("Stack reports that it's empty, " +
                    "when it shouln't be.");
    }

    stk.pop ();
     
    if (stk.is_empty () == false) {
      Test.fail ();
      Test.message ("Stack reports that it's not empty," +
                    " when it's only value has been popped.");
    }
    
  });


  Test.add_func (VEE_TEST_STACK_PREFIX + "value", () => {
    var stk = new Stack<int> ();
    
    stk.push (1337);

    if (stk.peek () != 1337) {
      Test.fail ();
      Test.message ("Peeked value did not match expected value.");
    }

    if (stk.pop () != 1337) {
      Test.fail ();
      Test.message ("Popped value does not match expected value.");
    }
    
    foreach (var i in new Range (0, 10000) ) {
      stk.push (i);
    }
    
    foreach (var i in new Range (10000, 0)) {
      int got_val = stk.pop ();
      if (i != got_val) {
         Test.fail ();
         Test.message ("Wrong value: Experted %i, get %i.",
                       i, got_val);
      }
    }

  });
}
