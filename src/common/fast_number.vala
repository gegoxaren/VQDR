/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */

namespace VQDR.Common {
  
  /**
   * Fast Numbers are a decimal representanion of numbers in the folm of 
   * a normal integer value. All internal nummbers are multiples of 1000, so the
   * there is room for two three decimal ponts.
   * 
   * Math done on these numbers are done using standard integer operations, and
   * not floating point math.
   */
  public struct FastNumber {
    public const long MUL_FACTOR = 1000;
    
    /** Precision used to output values */
    public const int PRECISION_DIGITS = 2;
    /** Precision factor used to evaluate output */
    public const int PRECISION_FACTOR = 100;
    
    public long raw_number;
    
    public long number {
      public get {return (this.raw_number / MUL_FACTOR);}
      public set {this.raw_number = (MUL_FACTOR * value);}
    }
    
    public long decimal {
      public get {return mask_and_normalize_decimal (raw_number);}
      public set {set_decimal_of_number (ref raw_number, value);}
    }
    
    public FastNumber (long val = 0) {
      this.number = val;
    }
    
    public FastNumber.copy (FastNumber other) {
      this.raw_number = other.raw_number;
    }
    
    public FastNumber.from_string (string str) {
      this.raw_number = parse_raw_number (str);
    }
    
    public FastNumber.raw (long raw) {
      this.raw_number = raw;
    }
    
    public void set_from_string (string str) {
      this.raw_number = parse_raw_number (str);
    }
    
    public FastNumber add (FastNumber? other) {
      if (other == null) {
        return  FastNumber.copy (this);
      }
      
      var v =  FastNumber ();
      v.raw_number = (this.raw_number + other.raw_number);
      return v;
    }
    
    public FastNumber subtract (FastNumber? other) {
      if (other == null) {
        return  FastNumber.copy (this);
      }
      
      var v =  FastNumber ();
      v.raw_number = (this.raw_number - other.raw_number);
      return v;
    }
    
    public FastNumber multiply (FastNumber? other) {
      if (other == null || other.raw_number == 0) {
        return  FastNumber ();
      }
      
      var ret =  FastNumber ();
      ret.raw_number = ((this.raw_number * other.raw_number) / MUL_FACTOR);
      return ret;
    }
    
    public FastNumber divide (FastNumber other) throws MathError {
      if (other.raw_number == 0) {
        throw new MathError.DIVIDE_BY_ZERO
                                      ("FantNumber - trying to divide by zero");
      }
      var ret =  FastNumber ();
      ret.raw_number = ((this.raw_number * MUL_FACTOR) / other.raw_number);
      return ret;
    }
    
    [CCode (cname = "vqdr_common_fast_number_compare")]
    public long compare (FastNumber other) {
      return this.raw_number - other.raw_number;
    }
    
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
    
    public string to_string (bool decimal = false) {
      if (decimal) {
        return number.to_string () + "." + decimal.to_string ();
      } else {
        return number.to_string ();
      }
    } 
    
    // ***** STATIC FUNCTIONS ****//
    public static long parse_raw_number (string str) {
      long ret_val = 0;
      int i_of_dot = str.index_of_char ('.');
      if (i_of_dot >= 0) {
      
        // Get the decimal number from the string, if such a thing exists.
        if ((str.length - 1 > i_of_dot)) {
          ret_val = long.parse ((str + "000").substring (i_of_dot + 1));
        }
        
        // Normalise the digits.
        while (ret_val > MUL_FACTOR) {
          ret_val = ret_val / 10;
        }
        
        // Add intiger number
        ret_val = ret_val + (long.parse ("0" + str.substring (0, i_of_dot))
                            * MUL_FACTOR);
      } else {
        ret_val = long.parse (str) * MUL_FACTOR;
      }
      return ret_val;
    }
    
    public static long mask_and_normalize_decimal (long number) {
      var mask = number / MUL_FACTOR;
      mask = mask * MUL_FACTOR;
      return number - mask;
    }
    
    public static void set_decimal_of_number (ref long number, long decimal) {
      var masked = number / MUL_FACTOR;
      masked = masked * MUL_FACTOR;
      number = masked + decimal;
    }
    
    [CCode (cname = "vqdr_common_fast_number_compare")]
    public static extern long static_compare (FastNumber a, FastNumber b);
  }
}
