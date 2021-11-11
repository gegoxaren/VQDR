/* dice.vala
 *
 * Copyright 2021 Gustav Hartvigsson <unknown@domain.org>
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

using GLib;

/**
 * A Simple Represetation of a dice.
 */
public class VQDR.Expression.Dice {
  public int times { get; set; }
  public int faces { get; set; }
  public int modifier { get; set; }
  
  
  public Dice (int times = 1, int faces = 6, int modifier = 0) {
    this.times = times;
    this.faces = faces;
    this.modifier = modifier;
  }
  
  public Dice.singel (int faces) {
    this.times = 1;
    this.faces = faces;
    this.modifier = 0;
  }
  
  public int roll () {
    if (faces <= 0) {
      return modifier;
    }
    
    if (times <= 0) {
        return modifier;
    }
    
    if (faces == 1) {
      return times + modifier;
    }
    
    int retval = modifier;
    for (size_t i = 1; i <= times; i++) {
      int r = (VQDR.Common.Random.get_static_int () % faces).abs ();
      
      retval += r;
    }
    
    return retval;
  }
  
  public string to_string () {
    if ((times == 0) && (faces == 0)) {
      return "0";
    }
    
    StringBuilder retval = new StringBuilder ();
    
    if (times > 0) {
      retval.append (times.to_string ()).append_c ('d').append (faces.to_string ());
    }
    if (modifier > 0) {
        retval.append_c ('+').append (modifier.to_string ());
    } else if (modifier < 0) {
        retval.append (modifier.to_string ());
    }
    
    return retval.str;
  }
  
}
