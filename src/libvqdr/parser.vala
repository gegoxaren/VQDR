using VQDR.Expression;

namespace VQDR {
  public errordomain ParserError {
    NOT_READY,
    INVALID_DATA;
  }

  enum CharType {
    NULL = 0,
    DIGIT,
    UOP,
    OP,
    ALPHA,
    DOT,
    POP,
    PCL,
    COM,
    UNKNOWN;
   
   
  /**
   * Determine character type.
   * @param ch Character to be checked.
   * @return The character type.
   */
    CharType from_char (char ch) {
      switch (ch) {
        case '0': case '1':
        case '2': case '3':
        case '4': case '5':
        case '6': case '7':
        case '8': case '9':
          return DIGIT;
        case '+': case '-':
          return UOP;
        case '*': case '/':
          return OP;
        case '.':
          return DOT;
        case '(':
          return POP;
        case ')':
          return PCL;
        case ',':
          return COM;
        case ' ': case 0:
          return NULL;
        default:
          if ((ch >= 'a' && ch <= 'z') || (ch>= 'A' && ch <= 'Z' )) {
            return ALPHA;
          }
        assert_not_reached ();
      }
    }
  }

  public string parser_error_to_string (ParserError e) {
    switch (e.code) {
      case (ParserError.NOT_READY):
        return "NOT READY";
      case (ParserError.INVALID_DATA):
        return "INVALID_DATA";
      default:
        assert_not_reached ();
    }
  }

  class Parser {
    private class Lexer {
      private bool ready = false;
      private string? data = null;
      private size_t data_size = 0;
      private Array<Token> tokens = null;
      private char cur_char = 0;
      private int32 index = -1;

      public Lexer (string data) {
        assert (data.length != 0);
        this.data = data;
        this.data_size = data.length;
        this.cur_char = data[0];
        this.index = 0;
        tokens = new Array<Token> ();

      }

      public void lex () throws ParserError {
        while (this.index <= this.data_size) {
          
        }
        this.ready = true;
      }

      private void advance () {
        if (this.index < this.data_size && this.cur_char != '\0') {
          this.index++;
          this.cur_char = this.data[this.index];
        } else {
          assert_not_reached ();
        }
      }
      

      public Array<Token>? get_tokens () throws ParserError {
        if (!ready) {
          throw (new ParserError.NOT_READY ("Lexer is not ready." +
                                            "Needs to run Lexer.lex() first."));
        }

        return tokens;
      }
    }
  }
}
