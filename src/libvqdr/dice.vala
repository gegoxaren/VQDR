using GLib;

namespace VQDR.Expression {
  
  /**
   * A Simple Represetation of a dice.
   */
  public class Dice {
    public int times { get; set; }
    public int faces { get; set; }
    public int modifier { get; set; }
    
    
    public Dice (int times = 1, int faces = 6, int modifier = 0) {
      this.times = times;
      this.faces = faces;
      this.modifier = modifier;
    }
    
    public int roll () {
      if (faces <= 0) {
        return modifier;
      }
      
      if (times <= 0) {
          return modifier;
      }
      
      if (faces == 1) {
        return times + modifier;
      }
      
      int retval = modifier;
      for (size_t i = 1; i <= times; i++) {
        int r = (VQDR.Common.Random.get_static_int () % faces).abs ();
        retval += r;
        
      }
      
      return retval;
    }
    
    public string to_string () {
      if ((times == 0) && (faces == 0)) {
        return "0";
      }
      
      StringBuilder retval = new StringBuilder ();
      
      if (times > 0) {
        retval.append (times.to_string ()).append_c ('d').append (faces.to_string ());
      }
      if (modifier > 0) {
          retval.append_c ('+').append (modifier.to_string ());
      } else if (modifier < 0) {
          retval.append (modifier.to_string ());
      }
      
      return (string) retval.data;
    }
    
  }
}
