using VQDR.Expression;
using GLib;

void d6_test () {
   
    Test.add_func ("/VQDR/Expression/Dice/d6/to_string1", () => {
      Dice d = new Dice ();
      if (!(d.to_string () == "1d6")) {
        Test.fail ();
        Test.message ("The string does not match the expected value.");
      }
    });
    
    Test.add_func ("/VQDR/Expression/Dice/d6/to_string2", () => {
      Dice d = new Dice (5,6);
      if (!(d.to_string () == "5d6")) {
        Test.fail ();
        Test.message ("The string does not match the expected value.");
      }
    });
    
    Test.add_func ("/VQDR/Expression/Dice/d6/to_string3", () => {
      Dice d = new Dice (1,6,4);
      if (!(d.to_string () == "1d6+4")) {
        Test.fail ();
        Test.message ("The string does not match the expected value.");
      }
    });
    
    Test.add_func ("/VQDR/Expression/Dice/d6/to_string4", () => {
      Dice d = new Dice (1,6,-4);
      if (!(d.to_string () == "1d6-4")) {
        Test.fail ();
        Test.message ("The string does not match the expected value.");
      }
    });
    
    Test.add_func ("/VQDR/Expression/Dice/d6/roll_count", () => {
      Dice d = new Dice ();
      int count[7] = {0};
      int rolls = 1000000;
      for (size_t i = 0; i < rolls; i++) {
        int r = d.roll ();
        
        count[r] += 1;
      }
      int total = 0;
      for (int i = 0; i < 6; i++) {
        total += count[i];
      }
      
      if (!(total == rolls)) {
        Test.fail ();
        Test.message ("Rolles do not add up.");
      }
    });
    
    Test.add_func ("/VQDR/Expression/Dice/d6/roll_probability", () => {
      Dice d = new Dice ();
      int count[7] = {0};
      int rolls = 1000000;
      for (size_t i = 0; i < rolls; i++) {
        int r = d.roll ();
        
        count[r] += 1;
      }
      for (int i = 0; i < 6; i++) {
        print ("------------\n");
        print ("count for %d : %\n", i + 1, count[i] );
        double procentile = ((double )count[i] / rolls) * 100;
        if ((procentile < 15) || (procentile > 17)) {
          // The value sholud be aronud 16 %
          Test.message ("Procentile of D6 is off. Expected close to 16 %% got %f", procentile);
          Test.fail ();
        }
        print ("chance for %d : %f %%\n", i, procentile );
      }
    
    });
}
