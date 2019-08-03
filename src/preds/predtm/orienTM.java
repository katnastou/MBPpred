package preds.predtm;

class orienTM
{

int length;
int transmems;
int[] from;
int[] to;

int[] sequence;

public orienTM( String seqData, int ts, int[] f,  int[] t )
{
   
final String R_STRING="GAVLIFPSTCMWYNQDEKRHBZX";
final int RESIDUES=23;


sequence=new int[10000];

length=0;
int spec=0;
		
   transmems=ts;
   from=f;

   to=t;



   
  int res=seqData.length();//mhkos

		for( int j=0; j<res; j++ )
		{
			sequence[length]=
				R_STRING.indexOf( seqData.charAt( j ) );
			
					
		//	  strrchr( R_STRING, *(seqn->GetSequenceData()+j)) - 		R_STRING;
			  
			if( sequence[length]>=0 && sequence[length]<RESIDUES )
			{
				length++;
			}
		}

//
/*
			for( int i=1; i<=transmems; i++ )
			{
			  if( ( to[i]<=from[i] )||( i>1 && from[i]<=to[i-1] ) )
			  {	
	
			     ready=-1;
			     break;
			  }
			}	

		if( ready<1 )
		{
				System.out.println( " *** ERROR" );
			
		}
		*/

  }
  
  public double topol()
  {
	final int MTRANS=25;
   int start, end, len;
   double count;
   double score;
   double[][] sc=new double[MTRANS+2][2];
   double t_score=0;
   double t_count=0;
   int flag=-1;
   OTMarray arr=new OTMarray();
   for( int i=1; i<=transmems+1; i++ )
   {
		flag*=-1;
		if( ( i==1 && from[1]==1 )||( i==transmems+1 && to[transmems]==length ) )
		{
			sc[i][0]=sc[i][1]=0;
			continue;
		}
		start=( ( i==1 )? 1: to[i-1]+1 );
		end=( ( i==transmems+1 )? length: from[i]-1 );
		len=( ( ( end-start+1 )/2>20 )? 20: ( end-start+1 )/2 );
		score=0;
		count=0;
		
		for( int j=start; j<start+len; j++ )
		{
			score+=arr.unspec[ sequence[j-1] ][ j-start+1 ][ 0 ][ (( i==1 )? 0:1 ) ];
			count++;
		}
		t_score+=score*flag;
		t_count+=count;
		
		sc[i][0]=100*score/count;
		score=0;
		count=0;
		
		for( int j=end; j>end-len; j-- )
		{
			score+=arr.unspec[ sequence[j-1] ][ end-j+1 ][ 1 ][ (( i==transmems+1 )? 2:1 ) ];
			count++;
		}
		
		sc[i][1]=100*score/count;
		t_score+=score*flag;
		t_count+=count;
   }

	//System.out.println( 100*t_score/t_count  );

   return( 100*t_score/t_count  );
}

}

