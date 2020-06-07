using VQDR.Expression;
using VQDR.Common.Utils;

int main (string[] args) {
    
    Dice d = new Dice ();
    
    d.roll ();
    
    print_ln (d.to_string ());
    
    print_ln ("foo bar baz %d, %f", 1, 13.37);
    
    return 0;
}
