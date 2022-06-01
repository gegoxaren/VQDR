/* dice_operator_token.vala
 *
 * Copyright 2021 Gustav Hartvigsson
 *
 * This file is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

using Utils;

namespace VQDR.Expression {
  public class DiceOperatorToken : OperatorToken, UnaryOperator {
    
    public DiceOperatorToken (int32 position) {
      base (position);
    }
    
    public override bool is_unary {public get;public set; default = false;}
    
    public override void evaluate_self (Context instance) throws GLib.Error {
      Dice dice;
      
      int32 l_result;
      int64 l_max_result;
      int64 l_min_result;
      
      var r_child = get_left_child ();
      var l_child = get_right_child ();
      
      if (! is_unary) {
        l_child.evaluate (instance);
        l_result = (int32) l_child.result_value.number;
        l_max_result = l_child.result_max_value.number;
        l_min_result = l_child.result_min_value.number;
      } else {
        l_result = 1;
        /* In the original code the values were set to something strange.
         * This was dueto the normalisation of the values. We use FastNumber
         * to do the grunt work, so we don't need to worry about this.
         */ 
        l_max_result = 1;
        l_min_result =  1;
      }
      
      dice = new Dice (l_result, (int32) r_child.result_value.number);
      result_value = FastNumber (dice.roll ());
      
      /* Max Result: The max of the dice faces multiplied my the max of the
       * dice numbers.
       */
      // This was very complicated for no reason in the original code...
      result_max_value = FastNumber (l_max_result * 
                                     r_child.result_max_value.number);
      /* Min Result: The min of the dice faces multiplied my the max of the
       * dice numbers.
       */
      // This was very complicated for no reason in the original code...
      result_max_value = FastNumber (l_min_result * 
                                     r_child.result_min_value.number);
      
      result_string = "[" + result_value.to_string () + "]";
    }
    
  }
}
