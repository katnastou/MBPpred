package preds.predtm;

import java.util.Vector;
import java.lang.Integer;

public class predTM {

	private int style;

	public void setStyle( int i)
	{
		style = i;
	}
	
	private String seq;
	public predTM () {}
 	
	//----spyrop 23.03.03
	
	private String fastaInput;
	private String output;
	private String hasError;
	//Bean's setProperty
	public void setFastaInput ( String __fastaInput) {
		seq = __fastaInput;
		
	}
	//Bean's getProperty
	public String getOutput () {
	
		output = performAction();
		return output;
		
	}

	public String getHasError () {
		if ( hasError!=null)
			System.out.println("predTM.class: "+hasError);
		return hasError;
	}



  private String performAction () {
	
	int newLine = seq.indexOf('\n');
	String name = seq.substring(seq.indexOf(">")+1,seq.indexOf("\n"));  
	  StringBuffer res = new StringBuffer();
	seq = seq.substring(newLine+1).replaceAll(" ","");

	

	final String legal="ARNDCQEGHILKMFPSTWYVX";
	int len=seq.length();
	StringBuffer sn=new StringBuffer( len );
	
	for( int i=0; i<len; i++ )
	{

		char cc=seq.charAt(i);
		if( legal.indexOf( cc )>-1 )
			sn.append( cc );
		else
			sn.append( 'X' );

	}
	seq=sn.toString();

	predtmr predtmr1 = new predtmr();
	Vector TM=predtmr1.ComputeIndicators( seq );
	int transmems =TM.size()/2;
	if ( transmems < 1 ) {
		if (style==0)
			return "\n\t<SEQ>"+"\n\t\t<NAME>"+name+"</NAME>"+"\n\t</SEQ>";	
		else
			;//
	}
	
	if (transmems>0)
	{
		
	int[] from=new int[transmems+1];
	int[] to=new int[transmems+1];
	int count=1;
       for (int i=0; i<TM.size(); i+=2 ){
       		from[count]=( (Integer)TM.elementAt(i) ).intValue();
		to[count]=( (Integer)TM.elementAt(i+1) ).intValue();
		count++;
       }
	
	
	orienTM ori1=new orienTM( seq, transmems, from, to );
		
			
	double top=ori1.topol();
	
	if (style==0)
	{
		res.append("\n\t<SEQ>"); //<RESULTS> original
		res.append("\n\t\t<NAME>");
		res.append(name);
		res.append("</NAME>");
	}
	else
	{
	//res.append("\n>"+name);
	}
	for( int i=1; i<=transmems; i++ )
	{	
		if (style==0)
		{
		res.append("\n\t\t<TMBEGN>"+from[i]+"</TMBEGN>");
		res.append("\n\t\t<TMFINSH>"+to[i]+"</TMFINSH>");
		res.append("\n\t\t<TMTOPOLOGY>"+( (top>0)?"INWARDS":"OUTWARDS" )+"</TMTOPOLOGY>" );
		}
		else
		{
		res.append("\n"+from[i]+"\t"+to[i]+"\t"+( (top>0)?"INWARDS":"OUTWARDS" ));
		}

		
		top*=-1;
	}
	if (style==0)
	{
	res.append("\n\t</SEQ>");
	}
	}
	return res.toString();	
  }
}
