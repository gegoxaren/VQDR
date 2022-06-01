/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
using GLib;

namespace Utils {
  
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
   */
  public struct FastNumber {
    
    /** Precision used to output values */
    public const int32 PRECISION_DIGITS = 2;
    
    /** Precision factor used to evaluate output */
    public const int32 PRECISION_FACTOR = 100;
    
    public const int32 MUL_FACTOR = PRECISION_FACTOR * 10;
    
    public int64 raw_number;
    
    public int64 leading_zeros;
    
    /* XXX
     * I'm not happy using getters/setters in this struct...
     * But I tink it'll have to do for simplicity.
     */
    public int64 number {
      public get {return (this.raw_number / MUL_FACTOR);}
      public set {
        this.raw_number = (MUL_FACTOR * value);
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
    public FastNumber (int64 number = 0) {
      if (number != 0) {
        this.raw_number = (number * MUL_FACTOR);
      } else {
        this.raw_number = 0;
      }
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
      parse_raw_number (str);
    }
    /**
     * Initialises a FastNumber with the internal representation of that number.
     */
    public FastNumber.raw (int64 raw) {
      this.raw_number = raw;
    }
    
    public FastNumber.from_float (double float_number) {
      // XXX Do we need a faster way of doing this?
      parse_raw_number (float_number.to_string ()); 
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
    public int64 compare (FastNumber other) {
      return this.raw_number - other.raw_number;
    }
    
    /**
     * Round up this FastNumber and returns a new FastNumber.
     * 
     * @return a rounded up FastNumber.
     */
    public FastNumber round_up () {
      FastNumber ret;
      int64 decimal = raw_number % PRECISION_FACTOR;
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
      int64 decimal = raw_number % PRECISION_FACTOR;
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
      string ret_val = null;
      if (!decimal) {
        ret_val = (this.raw_number / MUL_FACTOR).to_string ();
      } else {
        // Copy stuff so we don't accidentality stomp them.
        int64 _raw_number = this.raw_number;
        
        int64 _integer_part = (_raw_number / MUL_FACTOR);
        int64 _decimal_part = (_raw_number - (_integer_part * MUL_FACTOR));
        
        var strbldr = new GLib.StringBuilder ();
        
        // normalise the decimal part.
        // (XXX This is rather expensive, is there a better way of doing this?).
        if (_decimal_part != 0) {
          while ((_decimal_part % 10) == 0) {
            _decimal_part = _decimal_part / 10;
          }
        }
        
        strbldr.append (_integer_part.to_string ())
               .append_c ('.');
        
        
        for ( var i = this.leading_zeros ; i > 0 ; i--) {
          strbldr.append_c ('0');
        }
        
        strbldr.append (_decimal_part.to_string ());
        
        ret_val = strbldr.str;
      }
      return ret_val;
    }
    
    public double to_float () {
      // XXX This probobly needs to something faster?
      return double.parse (this.to_string (true));
    }
    
    public int64 to_int () {
       return (this.raw_number / MUL_FACTOR);
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
    
    
    [CCode (cname = "vqdr_common_fast_number_compare")]
    public static extern int64 static_compare (FastNumber a, FastNumber b);
    
    private void parse_raw_number (string str) {
      //debug (@"(parse_raw_number) str: $str");
      int64 ret_val = 0;
      int i_of_dot = str.index_of_char ('.');
      if (i_of_dot >= 0) {
        // Get the decimal number from the string, if such a thing exists.
        if ((str.length - 1 > i_of_dot)) {
          var intr_str = (str + "000").substring (i_of_dot + 1);
          // count leading zeros.
          long i;
          for (i = 0; intr_str.@get (i) == '0'; i++){}
          this.leading_zeros = i;
          // remove leading zeros
          intr_str = intr_str.substring (i);
          //debug (@"(parse_raw_number) Intermediate string: $intr_str");
          ret_val = int64.parse (intr_str);
        }
        
        // debug (@"(parse_raw_number) i_of_dot: $i_of_dot, ret_val (decimal): $ret_val\n");
        
        // Normalise the digits.
        while (ret_val > MUL_FACTOR) {
          ret_val = ret_val / 10;
          // debug (@"(parse_raw_number) retval (loop): $ret_val");
        }
        
        for (var i = leading_zeros; i > 0; i--) {
          ret_val = ret_val / 10;
          // debug (@"(parse_raw_number) retval (loop2): $ret_val");
        }
        
        // debug (@"ret_val (normalised): $ret_val\n");
        
        // get integer number
        ret_val = ret_val + (int64.parse (str.substring (0, i_of_dot))
                            * MUL_FACTOR);
        
      } else {
        ret_val = (int64.parse (str) * MUL_FACTOR);
      }
      //debug (@"(parse_raw_number) ret_val (finished): $ret_val\n");
      this.raw_number = ret_val;
    }
  }
}
