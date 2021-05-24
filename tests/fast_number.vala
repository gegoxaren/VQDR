using GLib;

using VQDR.Common.Utils;
using VQDR.Common;
using VQDR.Expression;

void fast_number_test () {
  Test.add_func ("/Common/Utils/FastNumber/add", () => {
    var f1 = new FastNumber (1337);
    var f2 = new FastNumber (1333);
    var f3 = f1.add (f2);
    if (f3.number != 2670) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/subtract", () => {
    var f1 = new FastNumber (1337);
    var f2 = new FastNumber (1333);
    var f3 = f1.subtract (f2);
    if (f3.number != 4) {
      Test.fail ();
      Test.message ("The subtracted numbers do not match the expected value");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/divide", () => {
    var f1 = new FastNumber (1338);
    var f2 = new FastNumber (4);
    FastNumber f3 = null;
    try {
      f3 = f1.divide (f2);
    } catch {}
    Utils.print_ln ("f3.number: %i", f3.number);
    /*if (f3.number != 669) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
    }*/
  });
  Test.add_func ("/Common/Utils/FastNumber/multiply", () => {
    
  });
}
