using VQDR.Expression;

namespace VQDR {
  public errordomain ParserError {
    NOT_READY,
    INVALID_DATA;
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
      private Array<Token> tokens = null;

      public Lexer (string data) {
        assert (data.length != 0);
        this.data = data;
        tokens = new Array<Token> ();
      }

      public void lex () throws ParserError {
        
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
