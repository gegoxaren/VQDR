/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */

namespace  Vee {
  [Compact]
  public class Pair<T1, T2> {
    public T1 v1;
    public T2 v2;
    public unowned FreeFunc v1_free_func;
    public unowned FreeFunc v2_free_func;
    [CCode (cname = "v_pair_new")]
    public Pair (T1 v1, T2 v2) {
      this.v1 = v1;
      this.v2 = v2;
    }
    
    public Pair.with_free_func (T1 v1, T2 v2,
                               FreeFunc v1_free_func,
                               FreeFunc v2_free_func) {
      this.v1 = v1;
      this.v2 = v2;
      this.v1_free_func = v1_free_func;
      this.v2_free_func = v2_free_func;
    }
    
    
    ~Pair () {
      if (this.v1_free_func != null) {
        this.v1_free_func (v1);
      }
      if (this.v2_free_func != null) {
        this.v2_free_func (v2);
      }
    }
  }
}
