using VQDR.Expression;
using VQDR.Common;

int main (string[] args) {
    
    Dice d = new Dice ();
    
    d.roll ();
    
    Utils.print_ln (d.to_string ());
    
    Utils.print_ln ("foo bar baz %d, %f", 1, 13.37);
    
    FastNumber n = new FastNumber (111);
    FastNumber n1 = new FastNumber (11);
    FastNumber m = n.divide (n1);
    
    Utils.print_ln ("%li", m.number);
    
    return 0;
}
