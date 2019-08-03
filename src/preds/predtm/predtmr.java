package preds.predtm;

import java.lang.String;
import java.lang.Integer;
import java.util.Vector;



public class predtmr {

  public String AA;

  public double freqOfAA[];

  public double freqOfAAInTM[];

  public double table1[][];
  public double table2[][];

  //public Vector vec;
  public String seqdata;


  public double hydroCutoff;
  public double startInd[];
  public int TM[];
  public double endInd[];
  public double hydroInd[];
  //public String namefile;
  //public FileWriter fileout;

  public Vector result;

  public predtmr() {
  
  	result=new Vector();
  }
  
  

   public Vector ComputeIndicators(String s){
    int i;
    int j;
    double freqOfAA[] =  {0.0757, 0.0168, 0.0529, 0.0634, 0.0408, 0.0683, 0.0223, 0.0578, 0.0595, 0.0939, 0.0235, 0.0450, 0.0491, 0.0400, 0.0515, 0.0715, 0.0570, 0.0655, 0.0124, 0.0318};

    double freqOfAAInTM[] = {0.1047, 0.0202, 0.0081, 0.0083, 0.0912, 0.0791, 0.0088, 0.1204, 0.0064, 0.1732, 0.0353, 0.0175, 0.0293, 0.0109, 0.0064, 0.0576, 0.0501, 0.1150, 0.0222, 0.0342};

    double table1 [][] ={
                       { 1.06902,   0.989605,    1.04213,   0.922376,   0.793477,    1.30621,    1.43313,    1.36232,    1.49283,    1.52134},
                       {0.617683,   0.657246,   0.698084,   0.787419,   0.740837,    0.63555,   0.791247,   0.807838,   0.873563,    1.05287},
                       {0.749396,   0.664802,   0.628002,   0.795278,     1.1542,   0.101321,   0.138839,   0.215786,   0.168232,   0.154133},
                       {0.69983,   0.639244,   0.610494,   0.644839,    0.92809,   0.0984046,  0.146449,   0.185811,   0.125418,   0.140082},
                       {1.21061,    1.35475,    1.24021,   0.993785,   0.396258,    2.59287,    2.33389,    2.16701,    2.20977,    2.05875},
                       {1.0399,    1.03483,   0.976442,    1.04985,   0.865299,   0.937955,    1.10824,     1.1364,    1.22088,    1.13827},
                       {0.992616,   0.996372,   0.993689,    1.09724,    1.42722,   0.300467,   0.379877,   0.628835,   0.556401,   0.442653},
                       {0.996274,    1.05736,     1.0528,   0.827607,   0.301093,    2.71576,    2.18674,    2.11153,    2.10811,    2.19085},
                       {0.999763,   0.970133,   0.941309,    1.11062,    1.59539,   0.086673,   0.123156,   0.173749,   0.116908,   0.118923},
                       {1.01348,    1.06762,    1.09744,   0.891112,   0.534479,    2.02294,    1.90231,     1.7696,    1.66832,     1.9093},
                       {1.42454,    1.08239,      1.091,    1.12543,   0.729484,     1.6408,    1.58593,    1.81188,    1.53805,    1.48856},
                       {0.937446,   0.986294,   0.996174,    1.11994,    1.44267,   0.276898,   0.374594,   0.426187,   0.352914,   0.417679},
                       {0.925405,   0.902998,   0.914081,   0.909022,   0.936969,   0.514622,   0.514863,   0.601597,   0.600634,   0.563049},
                       {0.901526,   0.902744,   0.882041,   0.890566,      1.213,   0.178418,   0.257275,   0.362316,   0.268844,   0.319081},
                       {1.31799,    1.28724,    1.29549,    1.69623,    2.38123,   0.153249,   0.125999,   0.170248,   0.157748,   0.163248},
                       {0.987555,   0.992227,   0.967736,    1.00898,    1.19654,   0.409588,   0.700746,   0.716698,   0.780183,   0.720726},
                       {1.00485,    1.10271,     1.0757,    1.14897,    1.22712,    0.65175,    0.80384,   0.862949,   0.944639,     1.0053},
                       {0.931682,    0.93327,   0.959481,   0.788117,   0.419177,    1.99204,    1.75872,    1.66202,    1.75157,    1.78374},
                       {1.66315,    1.84874,    1.77081,    1.83336,    1.04485,    2.87411,    2.51318,    2.10098,    2.09176,    1.45397},
                       {1.14929,    1.17764,    1.46939,     1.3367,    1.14338,    1.37371,    1.42096,    1.37568,    1.45718,    1.02841}
                      };

    double table2[][] = {
                          {1.52134,    1.49283,    1.36232,    1.43313,    1.30621,   0.793477,   0.922376,    1.04213,   0.989605,    1.06902},
                          {1.05287,   0.873563,   0.807838,   0.791247,    0.63555,   0.740837,   0.787419,   0.698084,   0.657246,   0.617683},
                          {0.154133,   0.168232,   0.215786,   0.138839,   0.101321,     1.1542,   0.795278,   0.628002,   0.664802,   0.749396},
                          {0.140082,   0.125418,   0.185811,   0.146449,   0.0984046,   0.92809,   0.644839,   0.610494,   0.639244,    0.69983},
                          {2.05875,    2.20977,    2.16701,    2.33389,    2.59287,   0.396258,   0.993785,    1.24021,    1.35475,    1.21061},
                          {1.13827,    1.22088,     1.1364,    1.10824,   0.937955,   0.865299,    1.04985,   0.976442,    1.03483,     1.0399},
                          {0.442653,   0.556401,   0.628835,   0.379877,   0.300467,    1.42722,    1.09724,   0.993689,   0.996372,   0.992616},
                          {2.19085,    2.10811,    2.11153,    2.18674,    2.71576,   0.301093,   0.827607,     1.0528,    1.05736,   0.996274},
                          {0.118923,   0.116908,   0.173749,   0.123156,   0.086673,    1.59539,    1.11062,   0.941309,   0.970133,   0.999763},
                          {1.9093,    1.66832,     1.7696,    1.90231,    2.02294,   0.534479,   0.891112,    1.09744,    1.06762,    1.01348},
                          {1.48856,    1.53805,    1.81188,    1.58593,     1.6408,   0.729484,    1.12543,      1.091,    1.08239,    1.42454},
                          {0.417679,   0.352914,   0.426187,   0.374594,   0.276898,    1.44267,    1.11994,   0.996174,   0.986294,   0.937446},
                          {0.563049,   0.600634,   0.601597,   0.514863,   0.514622,   0.936969,   0.909022,   0.914081,   0.902998,   0.925405},
                          {0.319081,   0.268844,   0.362316,   0.257275,   0.178418,      1.213,   0.890566,   0.882041,   0.902744,   0.901526},
                          {0.163248,   0.157748,   0.170248,   0.125999,   0.153249,    2.38123,    1.69623,    1.29549,    1.28724,    1.31799},
                          {0.720726,   0.780183,   0.716698,   0.700746,   0.409588,    1.19654,    1.00898,   0.967736,   0.992227,   0.987555},
                          {1.0053,   0.944639,   0.862949,    0.80384,    0.65175,    1.22712,    1.14897,     1.0757,    1.10271,    1.00485},
                          {1.78374,    1.75157,    1.66202,    1.75872,    1.99204,   0.419177,   0.788117,   0.959481,    0.93327,   0.931682},
                          {1.45397,    2.09176,    2.10098,    2.51318,    2.87411,    1.04485,    1.83336,    1.77081,    1.84874,    1.66315},
                          {1.02841,    1.45718,    1.37568,    1.42096,    1.37371,    1.14338,     1.3367,    1.46939,    1.17764,    1.14929}
                        };
    String AA = new String("ACDEFGHIKLMNPQRSTVWYX");
    hydroInd = new double[10000];
    startInd = new double[10000];
    endInd = new double[10000];

    for (i = 0 ; i < 5 ; i++ ) 
    {
	    int xx = AA.indexOf(s.charAt(i));
            hydroInd[i] = ( xx<20 )? freqOfAAInTM[xx]/freqOfAA[xx] : 1;
    }
        for (i = 0 ; i < s.length() - 10 ; i++ ) {
            double indice1 = 1;
            for (j = 0 ; j < 10 ; j++ ) {
		    int xx=AA.indexOf(s.charAt(i+j));
		    if( xx<20 )
                	indice1 *= table1[xx][j];
            }
            double indice2 = 1;
            for (j = 0 ; j < 10 ; j++ ) {
		     int xx=AA.indexOf(s.charAt(i+j));
                	if( xx<20 )
		     		indice2 *= table2[xx][j];
            }
            double indice3 = 1;

	    int xx = AA.indexOf(s.charAt(i+5));
            indice3 = ( xx<20  )? freqOfAAInTM[xx]/freqOfAA[xx] :1;

            startInd[i+5] = indice1;
            endInd[i+5] = indice2;
            hydroInd[i+5] = indice3;
        }
        for (i = s.length()-5 ; i < s.length() ; i++ ) {
            	int xx = AA.indexOf(s.charAt(i));
		hydroInd[i] = ( xx<20  )? freqOfAAInTM[AA.indexOf(s.charAt(i))]/freqOfAA[AA.indexOf(s.charAt(i))] : 1;
       }
       MarkTM(s);
       this.WriteResult(s);
    return result;
  }

 private boolean MarkTM(String s) {

    int i;
    double hydroCutoff = 7.5;
    TM = new int[10000];
    int bestStr[] = new int [10000];
    int endIndx[] = new int [10000];
//    int bestStart[10000] = {0};
    double bestMiddle[] = new double[10000];
//    int bestEnd[10000] = {0};
//    int bestLen[10000] = {0};

    for (i = 0 ; i < s.length(); i++ ) {
        double startStr = 0;
        double middleStr = 0;
        double totalTM = 0;
        int nbAAInTM = 0;
        // test if it is a good start
        startStr = java.lang.Math.sqrt(startInd[i]/endInd[i]);
        if (startStr>startInd[i]) startStr = startInd[i];
        startStr *= startInd[i];
        startStr = java.lang.Math.sqrt(startStr);

        for (int j = i ; j < i+40 ; j++ ) {
            middleStr += java.lang.Math.log(hydroInd[j]);
            totalTM += hydroInd[j];
            nbAAInTM++;
            double endStr = java.lang.Math.sqrt(endInd[j+1]/startInd[j+1]);
            if (endStr>endInd[j+1]) endStr = endInd[j+1];
            endStr *= endInd[j+1];
            endStr = java.lang.Math.sqrt(endStr);
            int length = j-i+1;
            double normMiddle = java.lang.Math.exp(middleStr*10/length);
            double lengthPenalty = java.lang.Math.exp(java.lang.Math.abs(j-i+1-21));
            double totStr = startStr + normMiddle + endStr - lengthPenalty;
            if (startStr < 1) continue;
            if (endStr < 1) continue;
            if (normMiddle < 1) continue;
            if (totStr >  bestStr[i]) {
                Double TotStr = new Double(totStr);
                bestStr[i] = TotStr.intValue();
                endIndx[i] = j;
//                bestStart[i] = startStr;
                bestMiddle[i] = normMiddle;
//                bestEnd[i] = endStr;
//                bestLen[i] = lengthPenalty;
            }
        }
    }

    // select the TM part

    int imax = -1;
    while (true) {
        imax = -1;
        for (i = 0 ; i < s.length() ; i++ ) {
            if (TM[i] > 0) continue;
//            if (bestStr[i] <10) continue;
            if (bestMiddle[i]<hydroCutoff) continue;
//            if ((bestMiddle[i]<7.5) && (bestStr[i] < 30)) continue;
//            if (bestMiddle[i]<3.5) continue;
            // get the TM mark
            if ((imax == -1) || (bestStr[i]>bestStr[imax])) {
                if (TM[endIndx[i]] == 0) imax = i;
            }
        }
        if (imax == -1) break;
        for (i = imax ; i <= endIndx[imax] ; i++ ) {
                TM[i] = 1;
            }
    }

    return true;
  }

  public void WriteResult(String s) {

        int i;

      try {
      // count the number of predicted transmembrane regions
        int nbTM = 0;
        if (TM[0] == 1 ) nbTM++;
        for (i = 1 ; i < s.length() ; i++ ) {
            if ( (TM[i-1] == 0) && (TM[i] == 1) ) nbTM++;
        }

        // print the detail of predicted transmembrane regions
        int inTM = 0;
        for (i = 0 ; i < s.length()  ; i++ ) {
            if ((inTM==0) && (TM[i]==1)) {
                //System.out.println("(" + new Integer(i+1).toString()+"-");
                //fileout.write("(" + new Integer(i+1).toString()+"-");
                result.add( new Integer(i+1) ); //
		inTM = 1;
                nbTM--;
            }
            else if ((inTM==1) && (TM[i+1]==0)) {
		result.add( new Integer(i+1) );
                inTM = 0;
            }
        }
      }
      catch (Exception e) {e.printStackTrace();}
  }
}

