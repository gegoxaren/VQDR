namespace VQDR.Common.Utils {
  public int str_cmp (string a, string b) {
    return a.collate (b);
  }
  
  public void print_ln (string str, ...) {
    var va = va_list ();
    
    // Reallocate the string as it is not owned by the function.
    var tmp = str + "\n";
    
    // Hopefully this does not create any memony leaks. :-)
    print (tmp.vprintf (va));
  }
  
  public string object_to_string (GLib.Object obj) {
    GLib.ObjectClass real_obj = (GLib.ObjectClass) obj.get_type ().class_ref ();
    
    var str_builder = new GLib.StringBuilder ();
    
    
    str_builder.append ("(")
               .append (obj.get_type().name ())
               .append ("):\n");
    
    foreach (GLib.ParamSpec ps in real_obj.list_properties ()) {
      
      if (ps.value_type == 0 || ps.value_type == GLib.Type.INVALID) {
        continue;
      }
      
      var prop_name = ps.get_name ();
      
      Value prop_val = GLib.Value (ps.value_type);
      
      if (prop_val.type () == GLib.Type.INVALID || prop_val.type () == 0) {
        continue;
      }
      
      obj.get_property (prop_name, ref prop_val);
      
      
      str_builder.append ("\t (")
                 .append (prop_val.type_name ())
                 .append (") ")
                 .append (prop_name)
                 .append (": ");
      
      
      switch (prop_val.type ()) {
        case (GLib.Type.STRING):
          if (prop_val.get_string () == null) {
            str_builder.append ("(null string)");
          } else {
            str_builder.append (prop_val.get_string ());
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
          // Probobly needs better handling, but this will do.
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
        case (GLib.Type.OBJECT):
          str_builder.append_printf ("%llX", (((long)((pointer)prop_val.get_object ()))));
        break;
        case (GLib.Type.PARAM):
          var spsc = prop_val.get_param ();
          str_builder.append ("name: ")
                     .append (spsc.name)
                     .append (" type: ")
                     .append (spsc.value_type.name ());
        break;
        case (GLib.Type.POINTER):
          str_builder.append_printf ("%llX", (((long)prop_val.get_pointer ())));
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
          GLib.Variant v = prop_val.get_variant ();
          str_builder.append ("(\n")
                     .append (v.print (true))
                     .append ("\n)");
        break;
      }
      str_builder.append ("\n");
      
    }
    
    return str_builder.str;
  }
  
}
