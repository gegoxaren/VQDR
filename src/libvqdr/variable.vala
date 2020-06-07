namespace VQDR.Expression {
  
  
  /**
   * Represents a variable.
   */
  public struct Variable {
    public int min_val;
    public int max_val;
    public int current_val;
    
    public Variable (int min = 0, int max = 0, int current = 0) {
      this.max_val = max;
      this.min_val = min;
      this.current_val = current;
    }
    
    [CCode (cname = "vqdr_expression_variable_copy")]
    public Variable.copy (Variable other) {
      this.max_val = other.max_val;
      this.min_val = other.min_val;
      this.current_val = other.current_val;
    }
    
    public int compare (Variable other) {
      
      if (this.current_val > other.current_val) {
        return -1;
      } else if (this.current_val < other.current_val) {
        return 1;
      } else {
        if (this.max_val > other.max_val) {
          return -1;
        } else if (this.max_val < other.max_val) {
          return 1;
        } else {
          if (this.min_val > other.min_val) {
            return -1;
          } else if (this.min_val < other.min_val) {
            return 1;
          } // End min_val comp.
        } // End max_val comp
      } // End current_val Comp
      return 0; // They are exacly the same.
    }
    
    /**
     * Compares two Variables.
     * 
     * This is the same as @c compare. It is an alias to the same C function.
     */
    [CCode (cname = "vqdr_expression_variable_equals")]
    public static extern int static_compare (Variable a, Variable b);
    
    /**
     * Is this instance equal to the other?
     */
    public bool equals (Variable other) {
      return equals_values (other.min_val, other.max_val, other.current_val);
    }
    
    public bool equals_values (int min, int max, int current) {
      return (max == this.max_val) &&
             (min == this.min_val) &&
             (current == this.current_val);
    }
    
    
    
    public string to_string () {
      StringBuilder s = new StringBuilder ();
      s.append("(Variable: ");
      s.append_printf ("(max_val: %i, ", max_val);
      s.append_printf ("min_val: %i, ", max_val);
      s.append_printf ("current_val: %i)", current_val);
      s.append(")");
      return s.str;
    }
  }
}
