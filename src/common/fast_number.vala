/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
using GLib;

namespace VQDR.Common {
  
  /**
   * Fast Numbers are a decimal representation of numbers in the form of
   * a normal integer value. All internal numbers are multiples of 1000, so the
   * there is room for two three decimal points.
   * 
   * Maths done on these numbers are done using standard integer operations, and
   * not floating point maths.
   * 
   * The decimal part of the FastNumber has a maximum of 3 decimals.
   * 
   * How the value is divided internally is as follows:
   * {{{
   *  (base 10) [0 0 0 0 0 .... 0 | 0 0 0  ]
   *            [non-decial part  | decimal]
   * }}}
   *
   * Due to how some things work here, we can't reliably use the decimal part
   * that referents a value less than 0.1. That is, like 5.05 will not work
   * reliably.
   */
  public struct FastNumber {
    /* FIXME
     *
     * The limitations in the comment above is something
     * that needs to be fixed.
     *
     * Look into a different representation?
     *
     * Perhaps only use  raw_number ?
     *
     * Perhaps ripping out the things that are not needed?
     *
     * Implement BCD?
     */
    
    /** Precision used to output values */
    public const int PRECISION_DIGITS = 2;
    
    /** Precision factor used to evaluate output */
    public const int PRECISION_FACTOR = 100;
    
    public const int MUL_FACTOR = PRECISION_FACTOR * 10;
    
    public long raw_number;
    
    public long number {
      public get {return (this.raw_number / MUL_FACTOR);}
      public set {this.raw_number = (MUL_FACTOR * value);}
    }
    
    /**
     * Due to implementation details, and how the numbers are normalised,
     * this value might be wrong.
     */
    public long decimal {
      public get {return mask_and_normalize_decimal (raw_number);}
      public set {set_decimal_of_number (ref raw_number, value);}
    }
    
    public double float_rep {
      public get {
        long dec = this.decimal;
        long nbr = this.number;
        // debug (@"(float_ret_get) Float str: $nbr.$dec");
        return double.parse (@"$nbr.$dec");
      } public set {
        // debug (@"(float_ret_set) set float: $value");
        this.raw_number = parse_raw_number (value.to_string ());
      }
    }
    
    /**
     * Initialises a FastNumber.
     *
     * Note: Due to implementation details, you can't pass a decimal part that
     *       is less than .1, as we are normalising decimal values to the
     *       correct place.
     * 
     * @param number   The number that are to be set as the none-decimal part of
     *                 the number. Defaults to 0.
     * 
     * @param decimal  The decimal part of the number. Defaults to 0.
     */
    public FastNumber (long number = 0, int decimal = 0) {
      if (! (number == 0))  this.number = number;
      if (! (decimal == 0)) this.decimal = decimal;
    }
    
    /**
     * Do a deep copy of a FastNumber.
     */
    public FastNumber.copy (FastNumber other) {
      this.raw_number = other.raw_number;
    }
    
    /**
     * Initialises a FastNumber from a string.
     * 
     * Can be a decimal representation.
     */
    public FastNumber.from_string (string str) {
      this.raw_number = parse_raw_number (str);
    }
    
    /**
     * Initialises a FastNumber from a double floating point value.
     * 
     * Due to how floating point numbers works this may not be the exact value
     * you expect it to be.
     */
    public FastNumber.from_float (double f) {
      this.raw_number = parse_raw_number (f.to_string ());
    }
    
    /**
     * Initialises a FastNumber with the internal representation of that number.
     */
    public FastNumber.raw (long raw) {
      this.raw_number = raw;
    }
    
    /**
     * Sets the value of this FastNumber from a string, 
     */
    public void set_from_string (string str) {
      this.raw_number = parse_raw_number (str);
    }
    
    /**
     * Add this to an other FastNumber.
     * 
     * {{{
     * var f1 = FastNumber (3);   // f1 = 3
     * var f2 = FastNumber (2);   // f2 = 2
     * var f3 = f1.add (f2);      // f3 = 5
     * }}}
     * 
     * @return a newly initialised FastNumber.
     * 
     * @param other The other fast number you want to add to this value.
     */
    public FastNumber add (FastNumber? other) {
      if (other == null) {
        return  FastNumber.copy (this);
      }
      
      var v = FastNumber ();
      v.raw_number = (this.raw_number + other.raw_number);
      return v;
    }
    
    /**
     * Add this to an other FastNumber.
     * 
     * {{{
     * var f1 = FastNumber (3);   // f1 = 3
     * var f2 = FastNumber (2);   // f2 = 2
     * var f3 = f1.subtract (f2); // f3 = 1
     * }}}
     * 
     * @return a newly initialised FastNumber.
     * 
     * @param other  The other fast number you want to subtract from this 
     *               FastNumber.
     */
    public FastNumber subtract (FastNumber? other) {
      if (other == null) {
        return  FastNumber.copy (this);
      }
      
      var v = FastNumber ();
      v.raw_number = (this.raw_number - other.raw_number);
      return v;
    }
    
    /**
     * Multiply this FastNumber with another FastNumber.
     * 
     * {{{
     * var f1 = FastNumber (3);   // f1 = 3
     * var f2 = FastNumber (2);   // f2 = 2
     * var f3 = f1.multiply (f2); // f3 = 6
     * }}}
     * 
     * @return a newly initialised FastNumber.
     * 
     * @param other The value you want to multiply this value with.
     */
    public FastNumber multiply (FastNumber? other) {
      if (other == null || other.raw_number == 0 || this.raw_number == 0) {
        return  FastNumber ();
      }
      
      var ret = FastNumber ();
      ret.raw_number = ((this.raw_number * other.raw_number) / MUL_FACTOR);
      return ret;
    }
    
    /**
     * Divide this FastNumbers with another FastNumber.
     * 
     * {{{
     * var f1 = FastNumber (6);   // f1 = 6
     * var f2 = FastNumber (2);   // f2 = 2
     * var f3 = f1.multiply (f2); // f3 = 3
     * }}}
     * 
     * @return a newly initialised FastNumber.
     * 
     * @param other The value you want to multiply this value with.
     */
    public FastNumber divide (FastNumber other) throws MathError {
      if (other.raw_number == 0) {
        throw new MathError.DIVIDE_BY_ZERO ("trying to divide by zero");
      }
      var ret =  FastNumber ();
      ret.raw_number = ((this.raw_number * MUL_FACTOR) / other.raw_number);
      return ret;
    }
    
    [CCode (cname = "vqdr_common_fast_number_compare")]
    public long compare (FastNumber other) {
      return this.raw_number - other.raw_number;
    }
    
    /**
     * Round up this FastNumber and returns a new FastNumber.
     * 
     * @return a rounded up FastNumber.
     */
    public FastNumber round_up () {
      FastNumber ret;
      long decimal = raw_number % PRECISION_FACTOR;
      if (decimal > 0) {
        ret = FastNumber.raw (raw_number + PRECISION_FACTOR - decimal);
      } else {
        ret = FastNumber.raw (raw_number - decimal);
      }
      return ret;
    }
    
    /**
     * Round up this FastNumber and returns a new FastNumber.
     * 
     * @return a rounded down FastNumber.
     */
    public FastNumber round_down () {
      FastNumber ret;
      long decimal = raw_number % PRECISION_FACTOR;
      if (decimal < 0) {
        // Is this ever reached?
        ret = FastNumber.raw (raw_number - PRECISION_FACTOR - decimal);
      } else {
        ret = FastNumber.raw (raw_number - decimal);
      }
      return ret;
    }
    
    /**
     * FastNumber to string.
     * 
     * @return a string
     * 
     * @param decimal whether to return the decimal portion of the number in 
     *                the string. Default = false.
     */
    public string to_string (bool decimal = false) {
      if (decimal) {
        // FIXME: This will fail with decimal part less than 0.1..?
        return @"$number.$decimal";
      } else {
        return number.to_string ();
      }
    } 
    
    /**
     * Check if two FastNumbers are equal.
     * 
     * @return true if this is equal to the other.
     * @return false if this is not equal to the other.
     */
    public bool equals (FastNumber other) {
      return (this.raw_number == other.raw_number);
    }
    
    // ***** STATIC FUNCTIONS ****//
    public static long parse_raw_number (string str) {
      long ret_val = 0;
      int i_of_dot = str.index_of_char ('.');
      if (i_of_dot >= 0) {
        
        // debug (@"str: $str");
        // Get the decimal number from the string, if such a thing exists.
        if ((str.length - 1 > i_of_dot)) {
          ret_val = long.parse ((str + "000").substring (i_of_dot + 1));
        }
        
        // debug (@"(parse_raw_number) i_of_dot: $i_of_dot, ret_val (decimal): $ret_val\n");
        
        // Normalise the digits.
        while (ret_val > MUL_FACTOR) {
          ret_val = ret_val / 10;
          // debug (@"(parse_raw_number) retval (loop): $ret_val");
        }
        
        // debug (@"ret_val (normalised): $ret_val\n");
        
        // get intiger number
        ret_val = ret_val + (long.parse (str.substring (0, i_of_dot))
                            * MUL_FACTOR);
        
        // debug (@"(parse_raw_number) ret_val (finished): $ret_val\n");
        
      } else {
        ret_val = long.parse (str) * MUL_FACTOR;
      }
      return ret_val;
    }
    
    public static long mask_and_normalize_decimal (long number) {
      // debug (@"(mask_and_normalize_decimal) number: $number");
      long mask = number / MUL_FACTOR;
      // debug (@"(mask_and_normalize_decimal) mask(1): $mask");
      mask = mask * MUL_FACTOR;
      // debug (@"(mask_and_normalize_decimal) mask(2): $mask");
      long ret = number - mask;
      // normalise
      // This is a rathor expensive operation.
      if (ret != 0) {
        while ((ret % 10) == 0) {
          ret = ret / 10;
        }
      }
      // debug (@"(mask_and_normalize_decimal) ret: $ret");
      return ret;
    }
    
    public static void set_decimal_of_number (ref long number, long decimal) {
      // debug (@"(set_decimal_of_number) number(0): $number, decimal(0): $decimal");
      long masked = number / MUL_FACTOR;
      // debug (@"(set_decimal_of_number) masked(1): $masked");
      masked = masked * MUL_FACTOR;
      // debug (@"(set_decimal_of_number) masked(2): $masked");
      
      // Normalise digits
      if (decimal != 0) {
        while (decimal < PRECISION_FACTOR) {
          decimal = decimal * 10;
          // debug (@"(set_decimal_of_number) loop, decimal: $decimal");
        }
      }
      
      number = masked + decimal;
      // debug (@"(set_decimal_of_number) number(1): $number");
      
    }
      
    [CCode (cname = "vqdr_common_fast_number_compare")]
    public static extern long static_compare (FastNumber a, FastNumber b);
  }
}
