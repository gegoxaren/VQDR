namespace VQDR.Common {
  
  /**
   * Fast Numbers are a decimal representanion of numbers in the folm of 
   * a normal integer value. All internal nummbers are multiples of 1000, so the
   * there is room for two three decimal ponts.
   * 
   * Math done on these numbers are done using standard integer operations, and
   * not floating point math.
   */
  public class FastNumber {
    public const long MUL_FACTOR = 1000;
    
    protected long real_raw_number;
    public long raw_number { public get {return real_raw_number;}
                             private set {real_raw_number = value;}
    }
    
    public long number {
      public get {return (this.real_raw_number / MUL_FACTOR);}
      public set {this.real_raw_number = (MUL_FACTOR * value);}
    }
    
    public long decimal {
      public get {return mask_and_normalize_decimal (real_raw_number);}
      public set {set_decimal_of_number (ref real_raw_number, value);}
    }
    
    public FastNumber (long val = 0) {
      this.number = val;
    }
    
    public FastNumber.copy (FastNumber other) {
      this.real_raw_number = other.real_raw_number;
    }
    
    public FastNumber.from_string (string str) {
      this.real_raw_number = parse_raw_number (str);
    }
    
    private static long parse_raw_number (string str) {
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
    
    
    public FastNumber add (FastNumber? other) {
      if (other == null) {
        return new FastNumber.copy (this);
      }
      
      var v = new FastNumber ();
      v.raw_number = (this.real_raw_number + other.real_raw_number);
      return v;
    }
    
    public FastNumber subtract (FastNumber? other) {
      if (other == null) {
        return new FastNumber.copy (this);
      }
      
      var v = new FastNumber ();
      v.raw_number = (this.real_raw_number - other.real_raw_number);
      return v;
    }
    
    public FastNumber multiply (FastNumber? other) {
      if (other == null || other.real_raw_number == 0) {
        return new FastNumber ();
      }
      
      var ret = new FastNumber ();
      ret.raw_number = ((this.real_raw_number * other.real_raw_number) / MUL_FACTOR);
      return ret;
    }
    
    public FastNumber divide (FastNumber? other) throws MathError {
      if (other.real_raw_number == 0) {
        throw new MathError.DIVIDE_BY_ZERO
                                      ("FantNumber - trying to divide by zero");
      }
      var ret = new FastNumber ();
      ret.raw_number = ((this.real_raw_number * MUL_FACTOR) / other.real_raw_number);
      return ret;
    }
    
    private static long mask_and_normalize_decimal (long number) {
      var mask = number / MUL_FACTOR;
      mask = mask * MUL_FACTOR;
      return number - mask;
    }
    
    private static void set_decimal_of_number (ref long number, long decimal) {
      var masked = number / MUL_FACTOR;
      masked = masked * MUL_FACTOR;
      number = masked + decimal;
    }
  }
}
