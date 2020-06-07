namespace VQDR.Common {
  
  /**
   * Fast Numbers are a decimal representanion of numbers in the folm of 
   * a normal integer value. All internal nummbers are multiples of 1000, so the
   * there is room for two three decimal ponts.
   * 
   * Math done on these numbers are done using standard integer operations, and
   * not floating point math.
   */
  class FastNumber {
    public const long MUL_FACTOR = 1000;
    
    public long raw_number { public get; private set; }
    
    public long number {
      get {return raw_number / MUL_FACTOR;}
      set {raw_number = number * MUL_FACTOR;}
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
      
      var v = new FastNumber (this.raw_number + other.raw_number);
      
      return v;
    }
    
    public FastNumber subtract (FastNumber? other) {
      if (other == null) {
        return new FastNumber.copy (this);
      }
      
      var v = new FastNumber (this.raw_number - other.raw_number);
      
      return v;
    }
    
    public FastNumber multiply (FastNumber? other) {
      if (other == null || other.raw_value == 0) {
        return new FastNumber ();
      }
      
      return new FastNumber ((this.raw_number * other.raw_number) / MUL_FACTOR);
    }
    
    public FastNumber divide (FastNumber? other) throws MathError {
      if (other.raw_number == 0) {
        throw new MathError.DIVIDE_BY_ZERO
                                      ("FantNumber - trying to divide by zero");
      }
      
      return new FastNumber ((this.raw_number * MUL_FACTOR) / other.raw_number);
    }
    
  }
  
}
