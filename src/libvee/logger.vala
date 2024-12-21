using Posix;


/*
 * Public Domain.
 */

namespace Vee {
  
  /**
   * This is a cheap logger, do not use for production code,
   * it is only for targets where GLib is not available.
   *
   * Use GLib's logging capabilities instead.
   */
  public class Logger {
    private const string STR_ERROR = "[ERROR]: ";
    private const string STR_INFO = "[INFO]: ";
    private unowned FILE out_file;
    
    private static Logger logger = null;
    
    public Logger (FILE out_file) {
      this.out_file = out_file;
    }
    
    public static Logger get_default () {
      if (logger == null) {
         Logger.logger = new Logger (Posix.stdout);
      }
      return logger;
    }
    
    public static void set_default (Logger logger) {
      Logger.logger = logger;
    }
    
    public void error (string str, ...) {
      out_file.printf (STR_ERROR);
      out_file.printf (str, va_list());
    }
    
    public void info (string str, ...) {
      out_file.printf (STR_INFO);
      out_file.printf (str, va_list());
    }
    
    public static void free_default () {
      Posix.free(Logger.logger);
    }
  }
}
