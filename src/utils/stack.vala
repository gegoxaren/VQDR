/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  [CCode (cname = "VStack", cprefix = "v_stack_")]
  public class Stack <T> {
    private static int step_size = 11;
    private T[] stack;
    private int pntr;
    public size_t elements {get {return pntr + 1;}}
    private size_t size;
    
    [CCode (has_target = true)]
    public delegate bool ForEachFunc<V> (V item);

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
    
    public T peek_n (size_t n) requires (n >= 0)  {
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

    /**
     * Applies func to each item in the stack, popping the stack content. 
     * (Consumes the list)
     *
     * Adding items into the list is a violation.
     */
    public void foreach_pop (ForEachFunc<T> func) {
      while (this.elements < 0) {
         var i = elements;
         func (pop ());
         // Make sure the user does not put anpthing back into the stacstackk.
         assert (elements < i);
      }
    }

    /**
     * Applies func to each item in the stack, peeking the staks content.
     *
     * Changing the number of items in the list is a violation.
     */
    public void foreach_peek (ForEachFunc<T> func) {
      for (var i = this.pntr; i >= 0; i--) {
        var k = this.elements;
        func (this.stack[i]);
        assert (k == this.elements);
      }
    }
  }
}
