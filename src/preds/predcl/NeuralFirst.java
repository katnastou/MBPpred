package preds.predcl;

import java.lang.*;
import java.io.*;
import java.math.*;

public class NeuralFirst {

  double wts[]={-18.897,0.56661,
0.999257,1.02327,1.15201,1.4974,1.72798,
1.72811,1.95561,1.9412,1.94155,1.2468,1.06773,1.01842,0.730279,0.56031,0.217043,-0.158099,-0.503131,-0.560378,-0.253816,-0.0485585,-0.46315,-0.724343,-0.832377,-0.622809,-0.795356,-0.654167,-0.370943,-0.417923,-0.146533,
-10.6273,0.0168708,-0.0891725,-0.0872674,-0.0886922,-0.145068,-0.136029,-0.124707,-0.139415,-0.121739,-0.0804838,0.0479443,0.02773,0.00119809,0.0505143,0.131709,0.223281,0.351996,0.45442,0.492862,0.504985,0.56618,0.7429,0.861414,0.838582,0.715484,0.70052,0.590777,0.4787,0.392304,0.278785,3.40077,6.85188,11.3827
};

  double data[];
  int i;
  /**
   * Constructor
   */
  public NeuralFirst() {
    data = new double[31];
    i=0;
  }

  public void reset()
  {
     i = 0;
  }
  public void AddData(double elem){
     data[i] = elem;
     i++;
  }

  public double CalcValue(double min,double dis){
     double result1 = wts[0];
     double result2 = wts[31];
     	
     for (int j = 1;j<31; j++)
     {
        double datatm = data[j-1];// -min)/dis - 0.5 ;  
//        System.out.println("datam " + datatm);
        //datatm = 1/(1+Math.exp(-datatm));	
        result1 = result1 + datatm *wts[j] ;
        result2 = result2 + datatm * wts[31+j];
     }
     result1 = 1/(1+Math.exp(-result1))-0.5 ;
     result2 = 1/(1+Math.exp(-result2))-0.5 ;
     double result = wts[62] + result1 * wts[63] + result2 * wts[64];
    return 1/(1+Math.exp(-result));	
  }
  
}
 
