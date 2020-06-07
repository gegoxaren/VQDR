namespace VQDR.Expression {
  
  /**
   * Implementers of this interface can be unary.
   */
  public interface UnaryOperator {
    
    /**
     * Defines weather the ipmelementer is unary or not.
     * 
     * If set to @true, the token that implements this is unary.
     * 
     * If set to @false, the token is not unary.
     */
    public abstract bool is_unary {public get; public set;}
  }
}
