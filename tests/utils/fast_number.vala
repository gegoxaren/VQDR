using GLib;

using Utils;
using VQDR.Expression;

void fast_number_test () {
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "new/raw", () => {
    FastNumber f1;
    
    
    f1 = FastNumber (1);
    if (f1.raw_number != 1000) {
      Test.fail ();
      Test.message ("Sanity1: Wrong value.");
      Test.message ("expected: 1000, got: " + f1.raw_number.to_string ());
    }
    
    f1 = FastNumber (10);
    if (f1.raw_number != 10000) {
      Test.fail ();
      Test.message ("Sanity2: Wrong value.");
      Test.message ("expected: 10000, got: " + f1.raw_number.to_string ());
    }

    f1 = FastNumber.from_string ("1.5");
    if (f1.raw_number != 1500) {
      Test.fail ();
      Test.message ("Sanity3: Wrong value.");
      Test.message ("expected: 1500, got: " + f1.raw_number.to_string ());
    }
    
    
    f1 = FastNumber.from_string ("10.5");
    if (f1.raw_number != 10500) {
      Test.fail ();
      Test.message ("Sanity4: Wrong value.");
      Test.message ("expected: 10500, got: " + f1.raw_number.to_string ());
    }
    
    
    f1 = FastNumber.from_string ("10.5");
    if (f1.raw_number != 10500) {
      Test.fail ();
      Test.message ("Sanity4: Wrong value.");
      Test.message ("expected: 10500, got: " + f1.raw_number.to_string ());
    }
    
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "add", () => {
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
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "subtract", () => {
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

  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "divide", () => {
    var expected_val = 669;
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
    if (out_val != expected_val) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
      Test.message (@"Expeted: $expected_val, got: $out_val.");
      Test.message (@"Raw value: $(f3.raw_number)");
    }
  });

  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "divide2", () => {
    var expected_val = 4;
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
    if (out_val != expected_val) {
      Test.fail ();
      Test.message ("The added numbers do not match the expected value");
      Test.message (@"Expeted: $expected_val, got: $out_val.");
      Test.message (@"Raw value: $(f3.raw_number)");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "multiply", () => {
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
  
  
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number1", () => {
    var expected_val = 1000;
    var val = FastNumber.from_string ("1");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    for (int i = 2; i <= 25; i = i + 3) {
      val = FastNumber.from_string (i.to_string ());
    
      if ((expected_val * i) != val.raw_number) {
        Test.fail ();
        Test.message ("The raw numbers does not match the exected value.");
        Test.message (@"expected $expected_val, got $raw");
      }
    }
    
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "to_string1", () => {
    var expected = "7.999";
    var f1 = FastNumber.from_string (expected);
    var result = f1.to_string (true);
    
    if (expected != result) {
      Test.fail ();
      Test.message (@"Wrong value: Expected $expected, Got: $result");
    }
    
    expected = "7.099";
    f1 = FastNumber.from_string (expected);
    result = f1.to_string (true);
    
    if (expected != result) {
      Test.fail ();
      Test.message (@"Wrong value: Expected $expected, Got: $result");
    }
    
    expected = "7.009";
    f1 = FastNumber.from_string (expected);
    result = f1.to_string (true);
    
    if (expected != result) {
      Test.fail ();
      Test.message (@"Wrong value: Expected $expected, Got: $result");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number2", () => {
    var expected_val = 1128;
    var val = FastNumber.from_string ("1.128");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    expected_val = 5128;
    val = FastNumber.from_string ("5.128");
    
    raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
    expected_val = 7128;
    val = FastNumber.from_string ("7.128");
    
    raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
    
  });
  
  
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number3", () => {
    var expected_val = 15128;
    var val = FastNumber.from_string ("15.128");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number4", () => {
    var expected_val = 20128;
    var val = FastNumber.from_string ("20.128");
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number5", () => {
    var expected_val = 222128;
    var val = FastNumber.from_string ("222.128");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $val");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number6", () => {
    var expected_val = 128;
    var val = FastNumber.from_string ("0.128");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $raw");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number7", () => {
    var expected_val = 160;
    var val = FastNumber.from_string ("0.16");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $raw");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "parse_raw_number8", () => {
    var expected_val = 800;
    var val = FastNumber.from_string ("0.8");
    
    var raw = val.raw_number;
    if (expected_val != raw) {
      Test.fail ();
      Test.message ("The raw numbers does not match the exected value.");
      Test.message (@"expected $expected_val, got $raw");
    }
  });
  
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "float", () => {
    var expected_val = 10.128;
    var f1 = FastNumber.from_float (expected_val);
    var flt = f1.to_float ();
    if (expected_val != flt) {
      Test.fail ();
      var raw = f1.raw_number;
      Test.message ("The float was not the correct value.");
      Test.message (@"Expected $expected_val, get $flt, Internal value: $raw ");
    }
  });
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "divide/decimal1", () => {
      var expected_val = FastNumber.from_string ("1.5");
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
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "divide/decimal2", () => {
      var expected_val = FastNumber.from_string ("0.25");
      var f1 = FastNumber (1);
      var f2 = FastNumber (4);
      
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
  
  Test.add_func (UTIL_TEST_FAST_NUMBER_PREFIX + "divide/decimal3", () => {
      var expected_val = FastNumber.from_string ("0.09");
      var f1 = FastNumber (1);
      var f2 = FastNumber (11);
      
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
