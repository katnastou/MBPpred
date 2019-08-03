package preds.predcl;

import java.lang.*;
import java.io.*;

public class PredClass {

	public PredClass () {}

	private int style;

	public void setStyle(int i)
	{
		style=i;
	}
	
	private String seq;
  
	//spyrop 24.03.03
	private String fastaInput;
	private String output;
	private String hasError;
		
	//Bean's setProperty
	public void setFastaInput( String __fastaInput ) {
		seq = __fastaInput;
	}

	//Bean's getProperty
	public String getOutput() {
		output = performAction();
		return output;
	}

	public String getHasError () {
		if ( hasError!=null)
			System.out.println("PredClass.class: "+hasError);
		return hasError;
	}
			
	
	String AA = "ACDEFGHIKLMNPQRSTVWY  ";
  	String AAGroup[] = {
           "AVLIFWDEQMHK",  // a-helix 
           "VLIFWYTCQM",    // B-sheet
           "GPDNSCKWYQTRE", // B-turn
           "CVILMFYWAP",    // Hydrophobic
           "DEHKRSTNQ",     // Polar
           "HRKDE",         // Charged
           "HRK",           // Charged positive
           "DE",            // Charged negative
           "HFWY",          // Aromatic
           "VLIA"};         // Aliphatic

 
 // values computed from Swissprot 35 (69113 sequences)
 double freqOfAA[] =     {0.0757, 0.0168, 0.0529, 0.0634, 0.0408,
 0.0683, 0.0223, 0.0578, 0.0595, 0.0939, 0.0235, 0.0450, 0.0491, 0.0400,	 0.0515, 0.0715, 0.0570, 0.0655, 0.0124, 0.0318};

 // value when we proceed all the TM sequences in SP35 (excluding non ended TM)
 double freqOfAAInTM[] = {0.1047, 0.0202, 0.0081, 0.0083, 0.0912,
 0.0791, 0.0088, 0.1204, 0.0064, 0.1732, 0.0353, 0.0175, 0.0293, 0.0109, 0.0064, 0.0576, 0.0501, 0.1150, 0.0222, 0.0342};

double table1[] = { 1.06902,   0.989605,    1.04213,   0.922376,
0.793477,    1.30621,    1.43313,    1.36232,    1.49283,    1.52134,   0.617683,   0.657246,   0.698084,   0.787419,   0.740837,    0.63555,   0.791247,   0.807838,   0.873563,    1.05287,
0.749396,   0.664802,   0.628002,   0.795278,     1.1542,   0.101321,   0.138839,   0.215786,   0.168232,   0.154133,   
0.69983,   0.639244,   0.610494,   0.644839,    0.92809,   0.0984046,  0.146449,   0.185811,   0.125418,   0.140082,   
1.21061,    1.35475,    1.24021,   0.993785,   0.396258,    2.59287,    2.33389,    2.16701,    2.20977,    2.05875,   
1.0399,    1.03483,   0.976442,    1.04985,   0.865299,   0.937955,    1.10824,     1.1364,    1.22088,    1.13827,   
0.992616,   0.996372,   0.993689,    1.09724,    1.42722,   0.300467,   0.379877,   0.628835,   0.556401,   0.442653,   
0.996274,    1.05736,     1.0528,   0.827607,   0.301093,    2.71576,    2.18674,    2.11153,    2.10811,    2.19085,   
0.999763,   0.970133,   0.941309,    1.11062,    1.59539,   0.086673,   0.123156,   0.173749,   0.116908,   0.118923,   
1.01348,    1.06762,    1.09744,   0.891112,   0.534479,    2.02294,    1.90231,     1.7696,    1.66832,     1.9093,   
1.42454,    1.08239,      1.091,    1.12543,   0.729484,     1.6408,    1.58593,    1.81188,    1.53805,    1.48856,   
0.937446,   0.986294,   0.996174,    1.11994,    1.44267,   0.276898,   0.374594,   0.426187,   0.352914,   0.417679,   
0.925405,   0.902998,   0.914081,   0.909022,   0.936969,   0.514622,   0.514863,   0.601597,   0.600634,   0.563049,   
0.901526,   0.902744,   0.882041,   0.890566,      1.213,   0.178418,   0.257275,   0.362316,   0.268844,   0.319081,   
1.31799,    1.28724,    1.29549,    1.69623,    2.38123,   0.153249,   0.125999,   0.170248,   0.157748,   0.163248,   
0.987555,   0.992227,   0.967736,    1.00898,    1.19654,   0.409588,   0.700746,   0.716698,   0.780183,   0.720726,   
1.00485,    1.10271,     1.0757,    1.14897,    1.22712,    0.65175,       0.80384,   0.862949,   0.944639,     1.0053,   
0.931682,    0.93327,   0.959481,   0.788117,   0.419177,    1.99204,    1.75872,    1.66202,    1.75157,    1.78374,   
1.66315,    1.84874,    1.77081,    1.83336,    1.04485,    2.87411,    2.51318,    2.10098,    2.09176,    1.45397,   
1.14929,    1.17764,    1.46939,     1.3367,    1.14338,    1.37371,     1.42096,    1.37568,    1.45718,    1.02841   };
 
double table2[] = {
    1.52134,    1.49283,    1.36232,    1.43313,    1.30621,   0.793477,   0.922376,    1.04213,   0.989605,    1.06902,   
    1.05287,   0.873563,   0.807838,   0.791247,    0.63555,   0.740837,   0.787419,   0.698084,   0.657246,   0.617683,   
   0.154133,   0.168232,   0.215786,   0.138839,   0.101321,     1.1542,   0.795278,   0.628002,   0.664802,   0.749396,   
   0.140082,   0.125418,   0.185811,   0.146449,   0.0984046,   0.92809,   0.644839,   0.610494,   0.639244,    0.69983,   
    2.05875,    2.20977,    2.16701,    2.33389,    2.59287,   0.396258,   0.993785,    1.24021,    1.35475,    1.21061,   
    1.13827,    1.22088,     1.1364,    1.10824,   0.937955,   0.865299,    1.04985,   0.976442,    1.03483,     1.0399,   
   0.442653,   0.556401,   0.628835,   0.379877,   0.300467,    1.42722,    1.09724,   0.993689,   0.996372,   0.992616,   
    2.19085,    2.10811,    2.11153,    2.18674,    2.71576,   0.301093,   0.827607,     1.0528,    1.05736,   0.996274,   
   0.118923,   0.116908,   0.173749,   0.123156,   0.086673,    1.59539,    1.11062,   0.941309,   0.970133,   0.999763,   
     1.9093,    1.66832,     1.7696,    1.90231,    2.02294,   0.534479,   0.891112,    1.09744,    1.06762,    1.01348,   
    1.48856,    1.53805,    1.81188,    1.58593,     1.6408,   0.729484,    1.12543,      1.091,    1.08239,    1.42454,   
   0.417679,   0.352914,   0.426187,   0.374594,   0.276898,    1.44267,    1.11994,   0.996174,   0.986294,   0.937446,   
   0.563049,   0.600634,   0.601597,   0.514863,   0.514622,   0.936969,   0.909022,   0.914081,   0.902998,   0.925405,   
   0.319081,   0.268844,   0.362316,   0.257275,   0.178418,      1.213,   0.890566,   0.882041,   0.902744,   0.901526,   
   0.163248,   0.157748,   0.170248,   0.125999,   0.153249,    2.38123,    1.69623,    1.29549,    1.28724,    1.31799,   
   0.720726,   0.780183,   0.716698,   0.700746,   0.409588,    1.19654,    1.00898,   0.967736,   0.992227,   0.987555,   
     1.0053,   0.944639,   0.862949,    0.80384,    0.65175,    1.22712,    1.14897,     1.0757,    1.10271,    1.00485,   
    1.78374,    1.75157,    1.66202,    1.75872,    1.99204,   0.419177,   0.788117,   0.959481,    0.93327,   0.931682,   
    1.45397,    2.09176,    2.10098,    2.51318,    2.87411,    1.04485,    1.83336,    1.77081,    1.84874,    1.66315,   
    1.02841,    1.45718,    1.37568,    1.42096,    1.37371,    1.14338,     1.3367,    1.46939,    1.17764,    1.14929   

};

int nbInputFile = 0;
int fileName[] = {0};
char outputFormat = 'C';
boolean showObservedTM = false;
boolean includeSPInfo = true;
boolean call_CoPreTHi = false;
boolean clearForm = false;
char seqName[];
String seqData;
double period[];
 double intensity[];
int  iNeurons  = 30;

int  countAA[] = {0}; // 31 will contains the total number for each 20 amino acids and 10 groups of AA in th sequence

int TMInSwiss[] = {0};//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
int TM[] = {0};//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
double startInd[] = {0};//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
double endInd[] = {0};//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
double hydroInd[] = {0};//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
int nbAA;

// variables used by FT in the procedure countPeriodicities
char asel[];    /* 26asel is the array of selected letters */
double value[];  /*26 value is the array of the weight of the letters */
double fsqmin;     /* fsqmin is the cutoff */
double minPeriod, maxPeriod;

int count = 0;
int totalSeq = 0;
int totalMembrane = 0;
int totalFibrous = 0;
int totalGlobular = 0;
int totalMixed = 0;

public int max_length = 50000;

 public boolean ComputeIndicators()
 {
        int i;
        int j;
        hydroInd = new double[max_length];
        TMInSwiss = new int[max_length];
        TM = new int[max_length];
        startInd = new double[max_length];
        endInd = new double[max_length];
        hydroInd= new double[max_length];
        countAA = new int[31];
        asel = new char[26];
        value= new double[26];
       
	
        for ( i = 0 ; i < 5 ; i++ )
        {
            int p = AA.indexOf(seqData.charAt(i));
            if (p!=-1)
                hydroInd[i] = freqOfAAInTM[p]/freqOfAA[p];
            else hydroInd[i] = 0;
        }
        for (i = 0 ; i < seqData.length() - 10 ; i++ )
        {
            double indice1 = 1;
            for ( j = 0 ; j < 10 ; j++ )
            {

                int p = AA.indexOf(seqData.charAt(i+j));
                if (p!=-1)
                    indice1 *= table1[ p*10+j];
            }
            double indice2 = 1;
            for (j = 0 ; j < 10 ; j++ )
            {
                int p = AA.indexOf(seqData.charAt(i+j));
                if (p!=-1)
                    indice2 *= table1[p*10+j];
            }
            double indice3 = 1;
             int p = AA.indexOf(seqData.charAt(i+5));
             if (p!=-1)
                indice3 = freqOfAAInTM[p]/freqOfAA[p];

            startInd[i+5] = indice1;
            endInd[i+5] = indice2;
            hydroInd[i+5] = indice3;
        }
        for (i = seqData.length()-5 ; i < seqData.length() ; i++ ) {
            int p = AA.indexOf(seqData.charAt(i));
             if (p!=-1)
                hydroInd[i] = freqOfAAInTM[p]/freqOfAA[p];
       }

    // count the residues in the sequence

    int totalCount = seqData.length();
    for ( i = 1 ; i < totalCount ; i++ ) {
        int p = AA.indexOf(seqData.charAt(i));
        if (p!=-1)
        {
            countAA[ p ] +=1;
        }
        else countAA[20] += 1; // Unknown residue
        for ( j = 0 ; j < 10 ; j++ ) {
            if (AAGroup[j].indexOf(seqData.charAt(i))!=-1)
                countAA[21+j] += 1;
        }
    }
    return true;
}

boolean MarkTM(int seqType) {
    if (seqType != 1) return true; // this is not a transmembrane protein
    int bestStr[]  = new int[max_length];
    int endIndx[] = new int[max_length];
    double bestMiddle [] = new double[max_length];

    for (int i = 0 ; i < nbAA ; i++ ) {
        double startStr = 0;
        double middleStr = 0;
        double totalTM = 0;
        int nbAAInTM = 0;
        // test if it is a good start
        startStr = (double) Math.sqrt(startInd[i]/endInd[i]);
        if (startStr>startInd[i]) startStr = (double) startInd[i];
        startStr *= startInd[i];
        startStr = (double) Math.sqrt(startStr);

        for (int j = i ; j < i+40 ; j++ ) {
            middleStr += (double) Math.log(hydroInd[j]);
            totalTM += hydroInd[j];
            nbAAInTM++;
            double endStr = Math.sqrt(endInd[j+1]/startInd[j+1]);
            if (endStr>endInd[j+1]) endStr = endInd[j+1];
            endStr *= endInd[j+1];
            endStr = Math.sqrt(endStr);
            int length = j-i+1;
            double normMiddle = Math.exp(middleStr*10/length);
            double lengthPenalty = Math.exp(Math.abs(j-i+1-21));
            double totStr = startStr + normMiddle + endStr - lengthPenalty;
            if (startStr < 1) continue;
            if (endStr < 1) continue;
            if (normMiddle < 1) continue;
            if (totStr >  bestStr[i]) {
                bestStr[i] = (int) totStr;
                endIndx[i] = j;
                bestMiddle[i] = normMiddle;

            }
        }
    }

    // select the TM part
    
    int imax = -1;
    int nbPredictedTM = 0;
    while (true) {
        imax = -1;
        for (int i = 0 ; i < nbAA ; i++ ) {
            if (TM[i] > 0) continue;
            if (bestMiddle[i]<7.5) continue;
            // get the TM mark
            if ((imax == -1) || (bestStr[i]>bestStr[imax])) {
                if (TM[endIndx[i]] == 0) imax = i;
            }
        }
        if (imax == -1) {
            if ((seqType == 1) && (nbPredictedTM==0)) {
                                // we know that there is at least one transmembrane region
                                // so we don't use a cutoff to detect at least one TM region
                for (int i = 0 ; i < nbAA ; i++ ) {
                    if (TM[i] > 0) continue;
                    if (bestMiddle[i]<=0) continue;
                    // get the TM mark
                    if ((imax == -1) || (bestStr[i]>bestStr[imax])) {
                        if (TM[endIndx[i]] == 0) imax = i;
                    }
                }
            }
        }
        if (imax == -1) break;
        nbPredictedTM++;
        for (int i = imax ; i <= endIndx[imax] ; i++ ) {
                TM[i] = 1;
            }
    }
    return true;
}

public int classifySequence() {

    // prepare the data for the neural network
    // and write it in a file called 'dataM.tst'
    NeuralFirst dataM = new NeuralFirst();
    NeuralSecond dataF = new NeuralSecond();
    NeuralThird dataG = new NeuralThird();

    nbAA = seqData.length();
    // print the lines
    double result;
    int nbAAInTM = 0;

    for (int i = 0 ; i < (nbAA-iNeurons) ; i++ ) {
	double max = hydroInd[i];
	double min = hydroInd[i];	
      for (int j = 0 ; j < iNeurons ; j++ ) {
          dataM.AddData (hydroInd[i+j]);
	    if (min > hydroInd[i+j]) 
	    {
		min = hydroInd[i+j];
	    } 
	    else
	     if (max < hydroInd[i+j]) 
	     {
		 max = hydroInd[i+j];
	     } 
	   /*System.out.println(min+" " + max);*/
      }

      for (int j = 0 ; j < iNeurons ; j++ ) {
            if  (TMInSwiss[i+j] > 0) nbAAInTM++;
      }
      if (nbAAInTM >=10) dataM.AddData (1);
      else dataM.AddData (0);

      result = dataM.CalcValue(min,max-min);
      //System.out.println ("result1 :" + result);
      if (result < 0.9) {
            nbAAInTM = 0;
          }
          else
            nbAAInTM++;

          if (nbAAInTM >= 3) {
            // System.out.println(" i " + i);
             return 1;
          }
          dataM.reset();
    }


     // if the sequece is not a TM one, execute the second NN
    // to detect if the protein belong to the fibrous class
    int i;
    // write the header
    int totalCount = seqData.length();
 
    double min = -500000;
    double max = 500000;
    for ( i = 0 ; i < 31 ; i++ ) {
        double freq;
        if (i < 21) { ///////?????????????
            asel[1] = AA.charAt(i);
            asel[2] = ' ';
            value[1] = 1.0;
            freq = (double)countAA[i]/totalCount;
        }
        else {
            for (int j=0; j<AAGroup[i-21].length() ; j++ ) {
                asel[j+1] = AAGroup[i-21].charAt(j);
                value[j+1] = 1.0;
                asel[j+2] = ' ';
            }
            freq = (double)countAA[i]/totalCount/AAGroup[i-21].length();
        }
        if (i == 20) continue;  // unknown residue
        fsqmin    = 1;
        minPeriod = 3;
        maxPeriod = 20;
        period = new double[1000];
        intensity = new double[1000];
        int nbPeriod = (int)CountPeriodicities();

        // identify the biggest intensity
        double bigIntensity = 0;
        for (int j = 0 ; j < nbPeriod-1 ; j++ ) {
            if (intensity[j] > bigIntensity) bigIntensity = intensity[j];
        }

        // print the frequency and the biggest intentity found
        if (min>freq*10) min = freq*10;
        if (min>bigIntensity) min = bigIntensity;
        if (max<freq*10) max = freq*10;
        if (max<bigIntensity) max = bigIntensity;
        dataF.AddData(freq*10);
        dataG.AddData(freq*10);
        dataF.AddData(bigIntensity);
        dataG.AddData(bigIntensity);
    }
    double predict = dataF.CalcValue(min,max-min);
  //  System.out.println("result 2: "+predict);
    if (predict >= 0.5) return 2; // Fibrous protein detected

    // if the sequence is not a TM one neither a Fibrous one,
    // we execute the third NN to detect if the protein belong to
    // the Globular class


    predict = dataG.CalcValue();
    //   System.out.println("result 3: "+predict);
 
    if (predict >= 0.5) return 3; // Globular protein detected

    return 4; // mixed protein if nothing else is detected
    
}

//double CountPeriodicities( double* period, double* intensity) {
double CountPeriodicities( ) {
    int kf1, kf2; /* kf1 & kf2 are the orders of the fourier transform */
     int nres;         /* nres is the length of string we are interested in */
    int nres1, nres2; /* nres1 & nres2 identifie the part of the sequence */
    int anin;
    double anin1;
    int nfold;        /* nfold contains the power of 2 of the sequence */
//    double fac;
//    char* sfix; /* sfix will point on the sequence */
    char seq[] = new char[20000];
    double fseq[]= new double[20000];
//    char selseq[20000];
    double vseq[]= new double[20000];
    double anseq[]= new double[20000];
    double scale;
    int nsel;
    int nnorm; /* nnorm is the min */
    int annorm;
    int kb1;
    int kb2;
    double v1;
    double v2;
    double vav1;
    double vav2;
    double vrms;
    int inv;
    double frms;
//    int ilast;
//    int iwrite;
//    double theta;
    int ix2;
    double a,b,r;
//    double fint2[20000];
//    double pper2[20000];

    int ns = seqData.length();
    nres1=1;
    nres2=ns-1;
    nfold = 4096;

    /* transformation of the parameters */
   kf1 =  (int) Math.ceil(nfold / maxPeriod);
    kf2 = (int) (nfold / minPeriod);
    nres = nres2 - nres1 + 1;

    anin = nfold;
    anin1 = anin - 1;
//    fac = anin / 360;
  
    for ( int i = 0 ; i < seqData.length() ; i++ ) seq[i+1] = seqData.charAt(i);
    for ( int i = 1 ; i <= nres ; i++ ) {
        fseq[i] = 0;
//        selseq[i]='.';
    }

    scale = 0;
    nsel = 1;
    while ( asel[nsel]!= ' '  ) nsel++;//\x0
    for ( int j = 1 ; j <= nres ; j++ ) {
        char as = seq[j];
        for ( int i=1 ; i <= nsel ; i++ ) {
            if ( as == asel[i] ) {
                fseq[j] = value[i];
//                selseq[j] = as;
                break;
            }
        }
    }
    nnorm = ( nfold < nres ? nfold : nres );
    for ( int j=1 ; j <= nfold ; j++ ) {
        vseq[j] = 0;
        anseq[j] = 0;
    }

    kb1 = 1;
    kb2 = 0;
    do {
        int kbx = kb1;
        int kby = ( (kb2+nfold) < ns ? kb2+nfold : ns ) - 1;
        for ( int j = kbx ; j <= kby ; j++ ) {
            int j1 = j - kb2;
            vseq[j1] = vseq[j1] + fseq[j];
            anseq[j1] = anseq[j1] + 1;
        }

        kb1 = kb1 + nfold;
        kb2 = kb2 + nfold;
    } while ( kb1 < nres );

    if ( nfold >= nres ) {
        for ( int j = 1 ; j <= nfold ; j++ ) {
            anseq[j] = 1;
        }
    }

    annorm = nnorm;
    v1 = 0;
    v2 = 0;
    for ( int i = 1 ; i <= nnorm ; i++ ) {
        double vs = vseq[i] / anseq[i];
        fseq[i] = vs;
        v1 = v1 + vs;
        v2 = v2 + vs*vs;
    }
  
    vav1 = v1 / annorm;
    vav2 = v2 / annorm;
    vrms =  Math.sqrt(vav2-vav1*vav1);
  
    for (int  j = 1 ; j <= nnorm ; j++ ) {
        fseq[j] = ( fseq[j] - vav1 ) / vrms;
    }

  double tr[] = new double[4097];//={0}; /* the real part of the data */
  double ti[]= new double[4097]; /* the imaginary part of the data */

   for ( int j = 1 ; j <= nnorm ; j++ ) {
        tr[j] = fseq[j];
    }

    inv = 2;

    four_trans( nfold, inv, tr, ti );

    frms =  Math.sqrt( annorm / anin1 );
    scale = 1 / ( frms * Math.sqrt( anin ) );
  
    kf1 = kf1 + 1;
    kf2 = kf2 + 1;
 
    /* here is the initialisation of SINGUL, NUMSIM, CUT, ISHORT */

//    ilast = 0;
//    iwrite = 1;
  
//    theta = 0;
   ix2 = 0;

    int memok1 = 0;   // memorize the index
    int nbPeriod = -1; // number of periodicities found
    for ( int k=kf1 ; k <= kf2 ; k++ ) {
	int k1;
        int ak;
        double ak1;
//        double orign;
        double per;
        double fint;
        a = tr[k];
        b = ti[k];
        r =  Math.sqrt( a*a + b*b );
//        if ( r != 0 ) theta = 180 * atan2( b, a ) / M_PI;
//        else theta = 0;

        ak = k - 1;
        ak1 = ak;
//        orign = -theta * fac / ak1 + 1;
        per = anin / ak1;
        a = a * scale;
        b = b * scale;
        r = r * scale;
        fint = r*r;
        k1 = k - 1;
//        ilast = iwrite;
        ix2 = ix2 + 1;
//        fint2[ix2] = fint;
//        pper2[ix2] = per;
        if ( fint >= fsqmin )
        {
            if (memok1 == k1-1) // no gap, this is the same maximum
            {
                if ( fint > intensity[nbPeriod]) { // if a bigger intensity is found
                    period[nbPeriod] = per;
                    intensity[nbPeriod] = fint;
                }
            }
            else
            {
                nbPeriod += 1; // This is the beginning of a new maximum
                period[nbPeriod] = per;
                intensity[nbPeriod] = fint;
            }
            memok1 = k1; // memorize the current index
        }
    }
    return nbPeriod+1; // return the number of periods found
}

int four_trans(int it, int inv, double tr[], double ti[])
{
    double ur[] = new double[16];//16
    double ui[] = new double[16];
    double nbr = Math.PI;
    int i, j, k;
    int to;
    double um;
    int io;
    int ii;
    int i1;
    int i3;

    /* initialization of the ur and ui arrays */
    for( i=1 ; i<=15 ; i++ ) {
        nbr = nbr / 2;
        ur[i] =  Math.cos( nbr );
        ui[i] =  Math.sin( nbr );
    }

    /* check that it is a power of 2 */
   to = 2;
    for ( i=2 ; i <= 16 ; i++) {
        to = to*2;
        if ( to > it ) return -1;
        if ( to == it ) break;
    }
    if ( to != it ) return -1;

    if ( inv == 1 ) um = -1;
    else um = 1;

    io = i;
    ii = io;
    i1 = it / 2;
    i3 = 1;

    do {
         k = 0; //int
        int i2 = i1 * 2;
         j = 0; //int
        do {
            double wr = 1;
            double wi = 0;
            int kk = k;
            int jo = io;
            int kk1 = 0;
            while ( kk != 0 ) {
                double ws;
                do {
                    jo = jo - 1;
                    kk1 = kk;
                    kk = kk / 2;
                } while ( kk1 == kk * 2 );
                ws = wr * ur[jo] - wi*ui[jo];
                wi = wr * ui[jo] + wi*ur[jo];
                wr = ws;
            }

            wi = wi * um;
            j = 0;
  
            do {
                int l = j * i2 + k;
                int l1 = l + i1;
                double zr = tr[l+1] + tr[l1+1];
                double zi = ti[l+1] + ti[l1+1];
                double z = wr*(tr[l+1] - tr[l1+1]) - wi*(ti[l+1] - ti[l1+1]);
                ti[l1+1] = wr*(ti[l+1] - ti[l1+1]) + wi*(tr[l+1] - tr[l1+1]);
                tr[l+1]  = zr;
                tr[l1+1] = z;
                ti[l+1] = zi;
                j += 1;
            } while ( j < i3 );
  
            k += 1;
        } while ( k < i1 );

        i3 = i3 * 2;
        io -= 1;
        i1 = i1 / 2;
    } while ( i1 > 0 );

    j = 1;
  
    if ( inv == 1 ) um = 1 / it;
    else um = 1;


    k = 0;
    do {
        int j1 = j;
        k = 0;
        for ( i = 1 ; i <= ii ; i++ ) {
            int j2 = j1 / 2;
            k = 2 * ( k - j2 ) + j1;
            j1 = j2;
        }

        if ( k == j ) {
            tr[j+1] = tr[j+1]*um;
            ti[j+1] = ti[j+1]*um;  
        }
        else if ( k > j ) {
            double zr = tr[j+1];
            double zi = ti[j+1];
            tr[j+1] = tr[k+1]*um;
            ti[j+1] = ti[k+1]*um;
            tr[k+1] = zr*um;
            ti[k+1] = zi*um;
        }

        j += 1;
    } while ( j - it + 1 < 0 );

    tr[1] = tr[1]*um;
    ti[1] = ti[1]*um;
    tr[it] = tr[it]*um;
    ti[it] = ti[it]*um;

    return 1;
}

//boolean rating(double& Qa, double& Ca, double& SM)
boolean rating(double Qa, double Ca, double SM) {
    double goodPred = 0;     // w
    double goodNonPred = 0;  // x
    double missedPred = 0;   // y
    double wrongPred = 0;    // z

    int inPredTM = 0;
    int inObsTM = 0;

    // to compute the correlation factor M & C
    // from the paper :
    // "Prediction of transmembrane a-helices in prokaryotic membrane proteins:
    // the dense alignment surface method"
    int nbObsTM = 0;  // number of experimental TM segments
    int nbExpM = 0;  // number of experimental TM segment that overlap with prediction
    int nbPredTM = 0; // number of predicted TM segments
    int nbPredM = 0; // number of predicted TM segment that overlap with experimental

    int expMatch = 0;
    int predMatch = 0;
    int total = 0;
    for (int i = 0 ; i < nbAA ; i++ ) {
        if ((TM[i] == 1) && (TMInSwiss[i] == 1)) goodPred++;
        if ((TM[i] == 0) && (TMInSwiss[i] == 0)) goodNonPred++;
        if ((TM[i] == 0) && (TMInSwiss[i] == 1)) missedPred++;
        if ((TM[i] == 1) && (TMInSwiss[i] == 0)) wrongPred++;

        if ((inObsTM == 0) && (TMInSwiss[i] == 1) ) {
            nbObsTM++;
            inObsTM = 1;
            expMatch = 0;
        }
        if ((inPredTM == 0) && (TM[i] == 1) ) {
            nbPredTM++;
            inPredTM = 1;
            predMatch = 0;
        }
        if ((inObsTM == 1) && (expMatch == 0) && (TM[i] == 1)) {
            expMatch = 1;
            nbExpM++;
        }

        if ((inPredTM == 1) && (predMatch == 0) && (TMInSwiss[i] == 1)) {
            predMatch = 1;
            nbPredM++;
        }

        if ((inObsTM == 1) && (TMInSwiss[i] == 0) ) inObsTM = 0;
        if ((inPredTM == 1) && (TM[i] == 0) ) inPredTM = 0;

        total++;
    }
    if (nbObsTM == 0) return false;

    double pa = 100 * goodPred / (goodPred + missedPred);
    double pna = 100 * goodNonPred / (goodNonPred + wrongPred);
    Qa = (pa + pna)/2;
    double S = (goodPred+missedPred)/total;
    double P = (goodPred+wrongPred)/total;
    if ((P==0) || (S==0)) Ca = 0;
    else Ca = ((goodPred / total) - (P * S)) / Math.sqrt(P * S * (1 - P) * ( 1 - S ));

    double M = (nbObsTM == 0) ? 0 : nbExpM/nbObsTM;
    double C = (nbPredTM == 0) ? 0 : nbPredM/nbPredTM;
    SM =  Math.sqrt(M*C);
    return true;
}

public String performAction()
{
   //PredClass Test = new PredClass();
   
	
	int newLine = seq.indexOf('\n');
	String name = seq.substring(seq.indexOf(">")+1,seq.indexOf("\n"));  
	seq = seq.substring(newLine+1).replaceAll(" ","");

	seqData = seq;

   ComputeIndicators();
   int result = classifySequence();
   String res=null;
   if (result == 1) res="MEMBRANE PROTEIN";
   else
     if (result == 2) res= "FIBROUS PROTEIN";
      else
        if (result == 3) res= "GLOBULAR PROTEIN";
         else
            if (result == 4) res= "MIXED PROTEIN";
  
  if (res!=null)
  {
	  if (style==0)
		   return ("\n\t<SEQ>"+"\n\t\t<NAME>"+name+"</NAME>"+"\n\t\t<CLASS>"+res+"</CLASS>"+"\n\t</SEQ>");
  	  else
		  return ("\t"+res);
  }
   else
	  return "ERROR";
}


     public void setInput ( String s) {
	        String legal="ARNDCQEGHILKMFPSTWYV";
        	int len=s.length();
        	StringBuffer sn=new StringBuffer( len );
        	for( int i=0; i<len; i++ )
        	{
                	char cc=s.charAt(i);
                	if( legal.indexOf( cc )>-1 )
                        	sn.append( cc );
        	}
        	seq=sn.toString();


     }



}
