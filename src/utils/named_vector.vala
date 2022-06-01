namespace Utils {
  public class NamedVector<T> {
    public T[] values;
    public string[] names;

    public delegate bool ForeachFunc<V> (string name, V val);

    public NamedVector (string n1, T v1,...) {
      // allocate temporary buffer
      var T_buf = new T[50];
      var N_buf = new string[50];
      T_buf[0] = v1;
      N_buf[0] = n1;
      var list = va_list ();
      
      var tmp_name = list.arg<string?> ();
      var tmp_val = list.arg<T?> ();
      size_t i = 1;

      while (tmp_name != null && tmp_val != null) {
        T_buf[i] = tmp_val; N_buf[i] = tmp_name;
        i++;
        tmp_name = list.arg<string?> ();
        tmp_val = list.arg<T?> ();
      }
      values = new T[i];
      names = new string[i];
      for (var j = 0; j < i; j++) {
        values[j] = T_buf[j];
        names[j] = N_buf[j];
      }

      assert (this.names != null);
      assert (this.values != null);
    }

    public Pair @get (int i) {
      var ret_val = new Pair<string, T> (this.names[i], this.values[i]);
      return ret_val;
    } 

    public void @foreach (ForeachFunc<T> funk) {
      for (var i = 0; i < values.length; i++) {
        if (!funk (names[i], values[i])) {
          break;
        }
      }
    }
  }
}
