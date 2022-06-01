/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace  Utils {
  [CCode (cname = "VPair", cprefix = "v_pair_")]
  public class Pair<T1, T2> {
    public T1 v1;
    public T2 v2;

    public Pair (T1 v1, T2 v2) {
      this.v1 = v1;
      this.v2 = v2;
    }
  }
}
