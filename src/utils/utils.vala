/*
 * The contects of this file is in the Public Domain.
 *
 * Created by Gustav Hartivgsson.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  // int32 is missinng the abs method. This will have to do for the time being.
  // BUG: https://gitlab.gnome.org/GNOME/vala/-/issues/1328
  static int32 int32_abs (int32 N) { return ((N < 0) ? ( -N ) : (N)); }

  [CCode (cname = "v_str_cmp")]
  public int str_cmp (string a, string b) {
    return a.collate (b);
  }
  
  [CCode (cname = "v_print_ln")]
  public void print_ln (string str, ...) {
    var va = va_list ();
    var tmp = str + "\n";
    stdout.vprintf (tmp, va);
  }

  [CCode (cname = "v_err_print_ln")]
  public void err_print_ln (string str, ...) {
    var va = va_list ();
    var tmp = str + "\n";
    stderr.vprintf (tmp, va);
  }

  [CCode (cname = "v_object_to_string")]
  public string object_to_string (GLib.Object obj) {
     StringBuilder strbldr = new StringBuilder ();
     internal_object_to_string (obj, ref strbldr);
     return strbldr.str;
  }

  string collect_string (string[] segments) {
    if (segments.length == 0) {
      return "";
    }
    if (segments.length == 1) {
      return segments[0];
    }
    StringBuilder strbldr = new StringBuilder ();
    foreach (var segment in segments) {
      strbldr.append (segment);
    }
    return strbldr.str;
  }

  [CCode (cname = "v_internal_object_to_string")]
  internal unowned StringBuilder internal_object_to_string (GLib.Object obj,
                                                  ref StringBuilder str_builder,
                                                  int32 nesting = 0) {
    GLib.ObjectClass obj_class =
      (GLib.ObjectClass) obj.get_type ().class_ref ();
    
    for (var i = 0; i < nesting; i++) {
     str_builder.append ("\t");
    }
    
    str_builder.append ("((")
               .append (obj.get_type().name ())
               .append_printf (")->(%p):\n", obj);
    
    foreach (GLib.ParamSpec ps in obj_class.list_properties ()) {
      
      if (ps.value_type == 0 || ps.value_type == GLib.Type.INVALID) {
        continue;
      }
      
      var prop_name = ps.get_name ();
      
      Value prop_val = GLib.Value (ps.value_type);
      
      if (prop_val.type () == GLib.Type.INVALID || prop_val.type () == 0) {
        continue;
      }

      obj.get_property (prop_name, ref prop_val);
      
      for (var i = 0; i < nesting; i++) {
        str_builder.append ("\t");
      }

      str_builder.append ("\t(")
                 .append (prop_val.type_name ())
                 .append (") ")
                 .append (prop_name)
                 .append (":");


      
      
      switch (prop_val.type ()) {
        case (GLib.Type.STRING):
          if (prop_val.dup_string () == null) {
            str_builder.append ("(null)");
          } else {
            str_builder.append (prop_val.dup_string ());
          }
        break;
        case (GLib.Type.INT):
          str_builder.append (prop_val.get_int ().to_string ());
        break;
        case (GLib.Type.BOOLEAN):
          str_builder.append (prop_val.get_boolean ().to_string ());
        break;
        case (GLib.Type.CHAR):
          var v = prop_val.get_schar ();
          str_builder.append_c (v)
                     .append (" (")
                     .append_printf ("%hhx", v);
          str_builder.append (")");
        break;
        case (GLib.Type.DOUBLE):
          str_builder.append (prop_val.get_double ().to_string ());
        break;
        case (GLib.Type.ENUM):
          str_builder.append (prop_val.get_enum ().to_string ());
        break;
        case (GLib.Type.FLAGS):
          // TODO: Probobly needs better handling, but this will do.
          str_builder.append (prop_val.get_flags ().to_string ());
        break;
        case (GLib.Type.FLOAT):
          str_builder.append (prop_val.get_float ().to_string ());
        break;
        case (GLib.Type.INT64):
          str_builder.append (prop_val.get_int64 ().to_string ());
        break;
        case (GLib.Type.LONG):
          str_builder.append (prop_val.get_long ().to_string ());
        break;
        case (GLib.Type.POINTER):
          str_builder.append ("(")
                     .append_printf ("%p", prop_val.get_pointer ());
          str_builder.append (")");
        break;
        case (GLib.Type.BOXED):
          str_builder.append ("(")
                     .append_printf ("%p", prop_val.get_boxed ());
          str_builder.append (")");
        break;
        case (GLib.Type.UCHAR):
          var v = prop_val.get_uchar ();
          str_builder.append_c ((char) v)
                     .append (" (")
                     .append_printf ("%hhx", v);
          str_builder.append (")");
        break;
        case (GLib.Type.UINT):
          str_builder.append (prop_val.get_uint ().to_string ());
        break;
        case (GLib.Type.UINT64):
          str_builder.append (prop_val.get_uint64 ().to_string ());
        break;
        case (GLib.Type.ULONG):
          str_builder.append (prop_val.get_ulong ().to_string ());
        break;
        case (GLib.Type.VARIANT):
          GLib.Variant v = prop_val.dup_variant ();
          GLib.Variant? tv = null;
          unowned string ts1 = v.get_type_string ();
          str_builder.append ("")
                     .append (ts1)
                     .append ("\n\t(\n");
          GLib.VariantIter iter = v.iterator ();
          tv = iter.next_value ();
          while (tv != null) {
            unowned string ts2 = tv.get_type_string ();
            string tp = tv.print (true);
            str_builder.append ("\t\t((")
                       .append (ts2)
                       .append ("): ")
                       .append (tp)
                       .append (")\n");
            tv = iter.next_value ();
          }
          
        break;

      }
      if (prop_val.type ().is_a (typeof (GLib.Object))) {
        var new_nesting = nesting + 1;
        GLib.Object? dup_obj = prop_val.dup_object ();
        str_builder.append_printf ("->(%p):\n", dup_obj);
        internal_object_to_string (dup_obj, ref str_builder, new_nesting);
      }

      str_builder.append ("\n");
    }
    for (var i = 0; i < nesting; i++) {
      str_builder.append ("\t");
    }
    str_builder.append (")\n");
    return str_builder;
  }
  
}
