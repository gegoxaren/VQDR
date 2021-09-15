using GLib;

using VQDR.Common.Utils;
using VQDR.Common;
using VQDR.Expression;

void fast_number_test () {
  Test.add_func ("/Common/Utils/FastNumber/new/raw", () => {
    FastNumber f1;
    
    
    f1 = FastNumber (1);
    if (f1.raw_number != 1000) {
      Test.fail ();
      Test.message ("Sanity1: Wrong value.");
      Test.message ("expected: 1000, got: " + f1.raw_number.to_string ());
    }
    
    if (f1.decimal != 0) {
      Test.fail ();
      Test.message ("Sanity1 - Decimal: Wrong value.");
      Test.message ("Expected value: 0, got:" + f1.decimal.to_string ());
    }
    
    f1 = FastNumber (10);
    if (f1.raw_number != 10000) {
      Test.fail ();
      Test.message ("Sanity2: Wrong value.");
      Test.message ("expected: 10000, got: " + f1.raw_number.to_string ());
    }
    
    if (f1.decimal != 0) {
      Test.fail ();
      Test.message ("Sanity2 - Decimal: Wrong value.");
      Test.message ("Expected value: 0, got:" + f1.decimal.to_string ());
    }
    
    f1 = FastNumber (1, 5);
    if (f1.raw_number != 1500) {
      Test.fail ();
      Test.message ("Sanity3: Wrong value.");
      Test.message ("expected: 1500, got: " + f1.raw_number.to_string ());
    }
    
    
    if (f1.decimal != 5) {
      Test.fail ();
      Test.message ("Sanity3 - Decimal: Wrong value.");
      Test.message ("Expected value: 0, got:" + f1.decimal.to_string ());
    }
    
    
    f1 = FastNumber (10, 5);
    if (f1.raw_number != 10500) {
      Test.fail ();
      Test.message ("Sanity4: Wrong value.");
      Test.message ("expected: 10500, got: " + f1.raw_number.to_string ());
    }
    
    if (f1.decimal != 5) {
      Test.fail ();
      Test.message ("Sanity4 - Decimal: Wrong value.");
      Test.message ("Expected value: 5, got:" + f1.decimal.to_string ());
    }
    
    f1 = FastNumber (10, 5);
    if (f1.raw_number != 10500) {
      Test.fail ();
      Test.message ("Sanity4: Wrong value.");
      Test.message ("expected: 10500, got: " + f1.raw_number.to_string ());
    }
    
    if (f1.decimal != 5) {
      Test.fail ();
      Test.message ("Sanity4 - Decimal: Wrong value.");
      Test.message ("Expected value: 5, got:" + f1.decimal.to_string ());
    }
    
  });
  
  Test.add_func ("/Common/Utils/FastNumber/add", () => {
    var expected_val = 2670;
    var f1 = FastNumber (1337);
    var f2 = FastNumber (1333);
    var f3 = f1.add (f2);
    var out_num = f3.number;
    if (out_num != expected_val) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
      Test.message (@"Expected: $expected_val, got: $out_num.");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/subtract", () => {
    var expected_val = 4;
    var f1 = FastNumber (1337);
    var f2 = FastNumber (1333);
    var f3 = f1.subtract (f2);
    var out_val = f3.number;
    if (out_val != 4) {
      Test.fail ();
      Test.message ("The subtracted numbers do not match the expected value");
      Test.message (@"Expeted: $expected_val, got: $out_val.");
    }
  });
  Test.add_func ("/Common/Utils/FastNumber/divide", () => {
    var expected_val = 0;
    var f1 = FastNumber (1338);
    var f2 = FastNumber (2);
    FastNumber f3 = {0};
    try {
      f3 = f1.divide (f2);
      Utils.print_ln ("f3.number: %i", f3.number);
    } catch (Error e) {
      Utils.print_ln ("Error: %s\n", e.message);
    }
    var out_val = f3.number;
    if (out_val != 669) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
      Test.message (@"Expeted: $expected_val, got: $out_val.");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/divide2", () => {
    var expected_val = 0;
    var f1 = FastNumber (4444);
    var f2 = FastNumber (1111);
    FastNumber f3 = {0};
    try {
      f3 = f1.divide (f2);
      Utils.print_ln ("f3.number: %i", f3.number);
    } catch (Error e) {
      Utils.print_ln ("Error: %s\n", e.message);
    }
    var out_val = f3.number;
    if (out_val != 4) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
      Test.message (@"Expeted: $expected_val, got: $out_val.");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/multiply", () => {
    var expected_val = 4444;
    var f1 = FastNumber (1111);
    var f2 = FastNumber (4);
    var f3 = f1.multiply (f2);
    var out_val = f3.number;
    if (out_val != expected_val) {
      Test.fail ();
      Test.message ("The multiplied numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $out_val");
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
  
  /*
   * All decimls that have to be converted to float must be
   * divicable by two. in these tests, or we will get rounding errors
   * when converting to floating point preresentation.
   */
  
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
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number3", () => {
    var expected_val = 15128;
    var val = FastNumber.parse_raw_number ("15.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number4", () => {
    var expected_val = 20128;
    var val = FastNumber.parse_raw_number ("20.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number5", () => {
    var expected_val = 222128;
    var val = FastNumber.parse_raw_number ("222.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number6", () => {
    var expected_val = 128;
    var val = FastNumber.parse_raw_number ("0.128");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number7", () => {
    var expected_val = 160;
    var val = FastNumber.parse_raw_number ("0.16");
    
    if (expected_val != val) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func ("/Common/Utils/FastNumber/parse_raw_number8", () => {
    var expected_val = 800;
    var val = FastNumber.parse_raw_number ("0.8");
    
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
  
  Test.add_func ("/Common/Utils/FastNumber/divide/decimal1", () => {
      var expected_val = FastNumber (1, 5);
      var f1 = FastNumber (3);
      var f2 = FastNumber (2);
      
      var out_val = FastNumber (0);
      try {
       out_val = f1.divide (f2);
      } catch (GLib.Error e) {
          Test.fail ();
          Test.message ("Divide by Zero Error");
      }
      if (out_val.equals (expected_val) == false) {
        Test.fail ();
        var raw_expected = expected_val.raw_number;
        var raw_got = out_val.raw_number;
        Test.message ("Expected value did not match the got value");
        Test.message (@"Exected internal value: $raw_expected,\n" +
                      @"Internel value got: $raw_got .");
      }
  });
  
}
