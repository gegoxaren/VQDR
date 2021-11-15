using VQDR.Expression;
using Utils;

public class VQDR.Expression.RollAndKeepFunctionToken : FunctionToken {
  private const int INDEX_ROLL = 1;
  private const int INDEX_POOL = 1;
  private const int INDEX_KEEP = 2;

  private const int MAX_POOL_SIZE = 50;

  private long[] roll_values  = null; // = new long[MAX_POOL_SIZE];
  private bool[] valid_values = null; // = new bool[MAX_POOL_SIZE];

  construct {
    mandatory_num_child = 2;
    optional_num_child = 1;
  }

  protected override void evaluate_self (VQDR.Expression.Context instance) throws GLib.Error {
    Token? roll;
    long  pool_size;
    long keep_size;
    
    roll = get_child (INDEX_ROLL);
    try {
      get_child (INDEX_POOL).evaluate (instance);
    } catch (Error e) {
      stderr.printf ("Error: %s, Error Domain: %s\n",
                     e.message, e.domain.to_string ());
      GLib.assert_not_reached ();
    }
    pool_size = get_child (INDEX_POOL).result_value.to_int ();

    if (pool_size > MAX_POOL_SIZE) {
      throw new ParamError.OUT_OF_BOUNDS
        (@"($(get_function_name (this.get_type ()))) Max value $MAX_POOL_SIZE, got $pool_size");
    }

    if (pool_size < 0) {
      pool_size = 0;
    }

    {
      Token? keep_child = get_child (INDEX_KEEP);
      if (keep_child != null) {
        keep_child.evaluate (instance);
        keep_size = keep_child.result_value.to_int ();
      } else {
        keep_size = pool_size;
      }
    }

    if (keep_size > pool_size) {
      keep_size = pool_size;
    }

    /* */

    long roll_result;
    long min_keep = long.MAX;
    int min_keep_index = 0;
    
    if (roll_values == null || roll_values.length < pool_size) {
      roll_values  = new long[pool_size];
      valid_values = new bool[pool_size];
    }

    for (int i = 0; i < pool_size; i++) {
      roll.evaluate (instance);
      roll_result = roll.result_value.raw_number;
      
      roll_values[i] = roll_result;
      valid_values[i] = true;

      if (i < keep_size) {
        // simply keep and detect the minium kept value
        if (min_keep > roll_result) {
          min_keep = roll_result;
          min_keep_index = i;
        }
      } else {
        // Chose what to do.
        if (roll_result >= min_keep) {
          // Discard the Minimum value
          valid_values[min_keep_index] = false;

          // Search for new Minimum value
          min_keep = long.MAX;
          min_keep_index = 0;

          for (int j = 0; j <= i; j++) {
            if (valid_values[j]) {
              if (min_keep > roll_values[j]) {
                min_keep = roll_values[j];
                min_keep_index = j;
              }
            }
          }
        } else {
          valid_values[i] = false;
        }
      }
    } // end for loop

    StringBuilder strbldr = new StringBuilder ();
    strbldr.append (SYM_BEGIN);
    
    FastNumber tmp_fstnmbr;

    for (int i = 0; i < pool_size; i++) {
      if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
        //we don't start with a seperator mark.
        if (i > 0) {
          strbldr.append (SYM_SEP);
        }
        // We don't want to deal with the conertion directly.
        // FIXME: Convert everything to FastNumbers instead of using "raw" values?
        tmp_fstnmbr = FastNumber.raw (roll_values[i]);
        strbldr.append (tmp_fstnmbr.to_string ());
        
        if (valid_values[i] && keep_size != pool_size) {
          strbldr.append (SYM_SELECTED);
        }
      }
      if (valid_values[i]) {
        tmp_fstnmbr = FastNumber.raw (roll_values[i]);
        result_value.add (tmp_fstnmbr);
      }
    }
    
    result_max_value = roll.result_max_value.multiply (FastNumber(keep_size));
    result_min_value = roll.result_min_value.multiply (FastNumber(keep_size));

    if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
      strbldr.append (SYM_END);
      result_string = strbldr.str;
    } else {
      result_string = SYM_TRUNK_BEGIN + result_value.to_string () + SYM_TRUNK_END;
    }
  }
  
}
/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:expandtab */ 
