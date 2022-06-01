namespace Utils {

  public class RangeIterator {
    private Range range;
    private int32 current;
    public RangeIterator (Range range) {
      this.range = range;
      this.current = this.range.start;
    }
     public int32 get () {
       return this.current;
     }

    public bool next () {
      if (!this.range.reverse) {
        if (this.current <= this.range.end) {
          this.current++;
          return true;
        }
      } else {
        if (this.current >= this.range.end){
          this.current--;
        }
      }
      return false;
    }

    public bool has_next () {
      return (this.current < this.range.end);
    }
  }


  public class Range {
    public bool reverse {get; private set;}
    public int32 start {get; private set;}
    public int32 end {get; private set;}

    public Range (int32 start, int32 end) {
      if (start <= end) {
        this.reverse = false;
      } else {
        this.reverse = true;
      }
      this.start = start;
      this.end = end;
    }

    public Type element_type () {
      return typeof (int);
    }
     
    public RangeIterator iterator () {
      return new RangeIterator (this);
    }
  }
}
