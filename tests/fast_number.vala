using GLib;

using VQDR.Common.Utils;
using VQDR.Common;
using VQDR.Expression;

void fast_number_test () {
  Test.add_func ("/Common/Utils/FastNumber/add", () => {
    var f1 = FastNumber (1337);
    var f2 = FastNumber (1333);
    var f3 = f1.add (f2);
    if (f3.number != 2670) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/subtract", () => {
    var f1 = FastNumber (1337);
    var f2 = FastNumber (1333);
    var f3 = f1.subtract (f2);
    if (f3.number != 4) {
      Test.fail ();
      Test.message ("The subtracted numbers do not match the expected value");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/divide", () => {
    var f1 = FastNumber (1338);
    var f2 = FastNumber (2);
    FastNumber f3 = {0};
    try {
      f3 = f1.divide (f2);
      Utils.print_ln ("f3.number: %i", f3.number);
    } catch (Error e) {
      Utils.print_ln ("Error: %s\n", e.message);
    }
    if (f3.number != 669) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/divide2", () => {
    var f1 = FastNumber (4444);
    var f2 = FastNumber (1111);
    FastNumber f3 = {0};
    try {
      f3 = f1.divide (f2);
      Utils.print_ln ("f3.number: %i", f3.number);
    } catch (Error e) {
      Utils.print_ln ("Error: %s\n", e.message);
    }
    if (f3.number != 4) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/multiply", () => {
    var expected_val = 4444;
    var f1 = FastNumber (1111);
    var f2 = FastNumber (4);
    var f3 = f1.multiply (f2);
    if (f3.number != expected_val) {
      Test.fail ();
      Test.message ("The multiplied numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $f3.number");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number1", () => {
    var expected_val = 1000;
    var val = FastNumber.parse_raw_number ("1");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    for (int i = 2; i <= 25; i = i + 3) {
      val = FastNumber.parse_raw_number (i.to_string ());
    
      if ((expected_val * i) != val) {
        Test.fail ();
        Test.message ("The raw numbers does not match the exected value.");
        Test.message (@"expected $expected_val, got $val");
      }
    }
    
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number2", () => {
    var expected_val = 1128;
    var val = FastNumber.parse_raw_number ("1.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    expected_val = 5128;
    val = FastNumber.parse_raw_number ("5.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    expected_val = 7128;
    val = FastNumber.parse_raw_number ("7.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
  });
  
  Test.add_func ("/Common/Utils/parse_raw_number3", () => {
    var expected_val = 15128;
    var val = FastNumber.parse_raw_number ("15.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/parse_raw_number4", () => {
    var expected_val = 10128;
    var val = FastNumber.parse_raw_number ("10.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/parse_raw_number5", () => {
    var expected_val = 20128;
    var val = FastNumber.parse_raw_number ("20.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/float", () => {
    var expected_val = 10.128;
    var f1 = FastNumber.from_float (expected_val);
    var flt = f1.float_rep;
    if (expected_val != flt) {
      Test.fail ();
      var raw = f1.raw_number;
      Test.message ("The float was not the correct value.");
      Test.message (@"Expected $expected_val, get $flt, Internal value: $raw ");
    }
  });
}
