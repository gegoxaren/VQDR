using VQDR.Expression;

public abstract class VQDR.Expression.AbstractPoolToken : FunctionToken {
  protected static Dice stadard_dice = new Dice.singel (10);

  protected AbstractPoolToken () {
    base ();
  }

  protected override void evaluate_self (Context instance) throws GLib.Error {
    int roll_res = 0;
    int pool_size = 0;
    int successes = 0;

    this.result_value.number = 0;

    StringBuilder strbldr = new StringBuilder ();
    strbldr.append (SYM_BEGIN);

    init_sequence (instance);

    pool_size = get_pool_size (instance);
    if (pool_size > MAX_TOKEN_ITERATIONS) {
        throw new Common.ParamError.OUT_OF_BOUNDS
          (@"$(this.get_type ().name ()) Pool index: $(get_pool_size (instance))");
    }

    bool is_roll_again;
    int total_roll_number = 0;
    // XXX
    for (int i = 1; i <= pool_size; i++) {
      is_roll_again = false;
      do {
        if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
          if (is_roll_again) {
            strbldr.append (SYM_EXPLODE);
          } else if (i > 1) {
            strbldr.append (SYM_SEP);
          }
        }

        roll_res = get_roll (instance);

        successes = count_successes (instance, roll_res);

        if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
          strbldr.append (roll_res.to_string ());
        }

        /*
         * place a Success mark for every roll that successeeded.
         */
        for (var j = 0; j < successes; j++) {
          if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
            strbldr.append (SYM_SUCCESS);
          }
        }

        /*
         * place a Failure mark for every failed roll.
         */
        for (var j = 0; j > successes; j--) {
          if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
            strbldr.append (SYM_FAILURE);
          }
        }

        this.result_value.number += successes;
        
        total_roll_number++;
        if (total_roll_number > MAX_TOKEN_ITERATIONS) {
          throw new Common.LoopError.TO_LONG 
            (@"$(get_function_name (this.get_type ())): Loop took more than $MAX_TOKEN_ITERATIONS to complete.");
        }
        is_roll_again = true;
      } while (roll_again (instance, roll_res, i));

      end_sequence (instance);
      if (get_max_pool_size (instance) < 1) {
        result_max_value.number = 1;
      } else {
        result_max_value.number = get_max_pool_size (instance);
      }

      if (strbldr.len < MAX_TOKEN_STRING_LENGTH) {
        strbldr.append (SYM_END);
        result_string = strbldr.str;
      } else {
        result_string = SYM_TRUNK_BEGIN + result_value.number.to_string () + SYM_TRUNK_END;
      }

    } // end for loop

  }

  /**
   * Tell if another roll is required.
   *
   * @param instance         the instance of the context to run in.
   * @param roll_result      the result to be evaluated.
   * @param pool_roll_number the number of rolls according to the pool size (zero base)
   *
   * @return ''true'' if another roll is required, ''false'' otherwise.
   */
  protected virtual bool roll_again (Context instance, int roll_result, int pool_roll_number) {
    return false;
  }

  /**
   * Used to initalize a specific values.
   */
  protected abstract void init_sequence (Context instance);

  /**
   * Return the pool size, or the number of rolls to performe.
   */
  protected abstract int get_pool_size (Context instance);

  /**
   * Returns the index of the parameter that contains the pool_size.
   */
  protected abstract int get_pool_index ();


  /**
   * Perform a roll and return the result.
   */
  protected abstract int get_roll (Context instance) throws GLib.Error;

  /**
   * Count the number of successes obtained with this roll.
   * (can be negative)
   *
   * @return the number of Successes for this roll.
   */
  protected abstract int count_successes (Context instance, int roll_result) throws GLib.Error;

  /**
   * Used to evetually performe controls after the pool rolls.
   */
  protected virtual void end_sequence (Context instance) throws GLib.Error {
    // NOOP
  }

  /**
   * Returns the maximum size of the pool.
   *
   * This should be equal to ''get_pool_size ()'', but the implementation is
   * allowed to specify any pool size.
   *
   * @return the maximum pool size.
   */
  protected virtual long get_max_pool_size (Context instance) throws GLib.Error {
    return get_pool_size (instance);
  }

}
