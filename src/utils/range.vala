/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  [CCode (cname = "VRangeIterator", cprefix = "v_range_iterator_")]
  public class RangeIterator {
    private Range range;
    private int current;
    public RangeIterator (Range range) {
      this.range = range;
      this.current = this.range.start;
    }
     public int get () {
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

  [CCode (cname = "VRange", cprefix = "v_range_")]
  public class Range {
    public bool reverse {get; private set;}
    public int start {get; private set;}
    public int end {get; private set;}

    public Range (int start, int end) {
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
