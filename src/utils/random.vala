/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
namespace Utils {
  
  /**
   * At the moment this just wraps the GLib Rand things.
   * 
   * This also provides a static version of the methods.
   */
  public class Random {
    
    private static Random? _instance = null;
    
    private GLib.Rand rand;
    
    private Random () {
      this.rand = new GLib.Rand ();
    }
    
    public static Random get_instance () {
      if (_instance == null) {
       _instance = new Random ();
      }
      return _instance;
    }
    
    /* **** Instance versions *** */
    public double get_double () {
      return rand.next_double ();
    }
    
    public double get_double_range (double begin, double end) {
      return rand.double_range (begin, end);
    }
    
    public int32 get_int () {
      return (int32) rand.next_int ();
    }
    
    public int32 get_int_range (int32 begin, int32 end) {
      return rand.int_range ((int32) begin, (int32) end);
    }
    
    public void seed (int32 seed) {
      rand.set_seed ((uint32) seed);
    }
    
    
    /* **** Static versions *** */
      public static int32 get_static_int () {
      Random r = Random.get_instance ();
      return r.get_int ();
    }
    
    public static double get_static_double () {
      Random r = Random.get_instance ();
      return r.get_double ();
    }
    
    public static int32 get_static_int_range (int32 begin, int32 end) {
      Random r = Random.get_instance ();
      return r.get_int_range (begin, end);
    }
    
    public static double get_static_double_range (double begin, double end) {
      Random r = Random.get_instance ();
      return r.get_double_range (begin, end);
    }
    
  }
  
}

