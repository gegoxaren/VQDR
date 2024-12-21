using Posix;


/*
 * Public Domain.
 */
[CCode (cname = "V", cprefix = "v_")]
namespace Utils {
  
  /**
   * This is a cheap logger, do not use for production code,
   * it is only for targets where GLib is not available.
   *
   * Use GLib's logging capabilities instead.
   */
  [CCode (cname = "VLogger", cprefix = "v_logger_")]
  public class Logger {
    private const string STR_ERROR = "[ERROR]: ";
    private const string STR_INFO = "[INFO]: ";
    private unowned FILE out_file;
    
    private static Logger logger = null;
    
    [CCode (cname = "v_logger_new")]
    public Logger (FILE out_file) {
      this.out_file = out_file;
    }
    
    [CCode (cname = "v_logger_get_default")]
    public static Logger get_default () {
      if (logger == null) {
         Logger.logger = new Logger (Posix.stdout);
      }
      return logger;
    }
    
    public static void set_default (Logger logger) {
      Logger.logger = logger;
    }
    
    [CCode (cname = "v_logger_err")]
    public void error (string str, ...) {
      out_file.printf (STR_ERROR);
      out_file.printf (str, va_list());
    }
    
    [CCode (cname = "v_logger_info")]
    public void info (string str, ...) {
      out_file.printf (STR_INFO);
      out_file.printf (str, va_list());
    }
    
    [CCode (cname = "v_logger_free_default")]
    public static void free_default () {
      Posix.free(Logger.logger);
    }
  }
}
