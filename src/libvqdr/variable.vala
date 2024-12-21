using Utils;
namespace VQDR.Expression {
  /**
   * Represents a variable.
   */
  public struct Variable {
    public FastNumber min_val;
    public FastNumber max_val;
    public FastNumber current_val;
    
    public Variable (int32 min = 0, int32 max = 0, uint32 current = 0) {
      this.max_val.number = max;
      this.min_val.number = min;
      this.current_val.number = current;
    }
    
    [CCode (cname = "vqdr_expression_variable_copy")]
    public Variable.copy (Variable other) {
      this.max_val.copy (other.max_val);
      this.min_val.copy (other.min_val);
      this.current_val.copy (other.current_val);
    }
    
    public int64 compare (Variable other) {
      if (! this.current_val.equals (other.current_val)) {
        return this.current_val.compare (other.current_val);
      } else if (! this.max_val.equals (other.max_val)) {
        return this.max_val.compare (other.max_val);
      } else if (! this.min_val.equals (other.min_val)) {
        return this.min_val.compare (other.min_val);
      }
      return 0;
    }
    
    /**
     * Compares two Variables.
     * 
     * This is the same as @c compare. It is an alias to the same C function.
     */
    [CCode (cname = "vqdr_expression_variable_equals")]
    public static extern int32 static_compare (Variable a, Variable b);
    
    /**
     * Is this instance equal to the other?
     */
    public bool equals (Variable other) {
      return !(bool) this.compare (other);
    }
    
    public bool equals_values (int32 min, int32 max, int32 current) {
      return (this.current_val.number == current) &&
             (this.max_val.number == max) &&
             (this.min_val.number == min);
    }
    
    
    
    public string to_string () {
      StringBuilder s = new StringBuilder ();
      s.append("(Variable: ");
      s.append_printf ("(max_val: %s, ", max_val.to_string (true));
      s.append_printf ("min_val: %s, ", max_val.to_string (true));
      s.append_printf ("current_val: %s)", current_val.to_string (true));
      s.append(")");
      return s.str;
    }
  }
}
