namespace Utils {
  [CCode (cname = "VStack", cprefix = "v_stack_")]
  public class Stack <T> {
    private static int step_size = 11;
    private T[] stack;
    private int pntr;
    public size_t elements {get {return pntr + 1;}}
    private size_t size;
    
    public Stack (size_t size = 23) {
      this.stack = new T[size];
      this.pntr = -1;
      this.size = size;
    }

    public void push (T val) {
      this.pntr++;
      this.stack[this.pntr] = val;
      if (this.pntr + 1 >= this.size) {
        this.stack.resize (this.stack.length + Stack.step_size);
      }
    }

    public T pop () {
      if (this.pntr < 0) {
        info ("Tryinng to pop value from empty Stack:\n" +
                 "\treturning NULL.");
        return null;
      }
      T ret_val = this.stack[this.pntr];
      this.stack[this.pntr] = null;
      this.pntr--;
      return ret_val;
    }

    public bool is_empty () {
      return (this.pntr == -1);
    }

    public T peek () {
      return peek_n (0);
    }
    
    public T peek_n (size_t n) {
      if (this.pntr < 0) {
        info ("Trying to peek a value from empty Stack:\n" +
                 "\tReturning NULL.");
        return null;
      }
      if ((this.pntr - n) <= 0) {
        return stack[0];
      }
      return this.stack[this.pntr - n];
    }
  }
}
