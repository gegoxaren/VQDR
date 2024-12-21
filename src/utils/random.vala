/*
 * The contests of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  
  /**
   * At the moment this just wraps the GLib Rand things.
   * 
   * This also provides a static version of the methods.
   */
  [CCode (cname = "VRandom", cprefix = "v_random_")]
  public class Random {
    
    private static GLib.Once<Utils.Random> _instance;
    
    private GLib.Rand rand;
    
    [CCode (cname = "v_random_new")]
    private Random () {
      this.rand = new GLib.Rand ();
    }
    
    [CCode (cname = "v_random_get_instance")]
    public static Random get_instance () {
      return _instance.once (() => {
        return new Random ();
      });
    }
    
    /* **** Instance versions *** */
    [CCode (cname = "v_random_get_double")]
    public double get_double () {
      return rand.next_double ();
    }
    
    [CCode (cname = "v_random_get_range")]
    public double get_double_range (double begin, double end) {
      return rand.double_range (begin, end);
    }
    
    [CCode (cname = "v_random_get_int")]
    public int32 get_int () {
      return (int32) rand.next_int ();
    }
    
    [CCode (cname = "v_random_get_int_range")]
    public int32 get_int_range (int32 begin, int32 end) {
      return rand.int_range ((int32) begin, (int32) end);
    }
    
    [CCode (cname = "v_random_seed")]
    public void seed (int32 seed) {
      rand.set_seed (seed.abs());
    }
    
    
    /* **** Static versions *** */
    [CCode (cname = "v_random_get_static_int")]
    public static int32 get_static_int () {
      Random r = Random.get_instance ();
      return r.get_int ();
    }
    
    [CCode (cname = "v_random_get_static_double")]
    public static double get_static_double () {
      Random r = Random.get_instance ();
      return r.get_double ();
    }
    
    [CCode (cname = "v_random_get_static_int_range")]
    public static int32 get_static_int_range (int32 begin, int32 end) {
      Random r = Random.get_instance ();
      return r.get_int_range (begin, end);
    }
    
    [CCode (cname = "v_random_get_static_double_range")]
    public static double get_static_double_range (double begin, double end) {
      Random r = Random.get_instance ();
      return r.get_double_range (begin, end);
    }
    
  }
  
}

