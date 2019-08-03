package preds;

public class MassPreds
{
	private static int style;
	private static boolean predtm;
	private static boolean predcl;
	private static boolean ready;	

	public static void main (String[] args)
	{
		style=1;
		predtm=false;
		predcl=false;
		ready=false;


		if ( args.length>1)
		{
			String filename = args[1];
			java.io.File file = new java.io.File(filename);
			if (!file.exists())
			{
				System.err.println("File \'"+filename+"\' not found.");
				System.exit(0);
			}
			String regex = args[0].toUpperCase();
                       	java.util.regex.Pattern switches=null;
                        java.util.regex.Matcher matcherT=switches.compile("T").matcher(regex);
                        java.util.regex.Matcher matcherC=switches.compile("C").matcher(regex);
                        java.util.regex.Matcher matcherH=switches.compile("H").matcher(regex);
                        java.util.regex.Matcher matcherX=switches.compile("X").matcher(regex);
                                                                                                                                             
			if (matcherX.find())
			{
				style = 0;
			}
                        if (matcherH.find())
                        {
				usage();
                                
                        }
		   
			
			
			if (matcherT.find())
                        {
				predtm=true;
				ready = true;
				
                                
                        }
                        if (matcherC.find())
                        {
				predcl=true;
				ready=true;
			
                                
                        }

			if (ready==true)
			{
				massPredAll( file );
			}
			
					
		}
		else
		{
			usage();
		}
	System.out.println();
	}
	
	public static void usage()
	{
			System.err.println("Usage: MassPreds -tc[x] fastaFilename\n\tt\tpredtm\n\tc\tpredcl\n\tx\txml output");
			System.err.println("Output at stdout, Error at stderr.");
			System.exit(0);
	}

	public static void massPredAll (java.io.File __file)
	{
		java.util.Vector vec = splitFastas(__file);
		String clres = "MEMBRANE";	
		if (style==0)
			System.out.println("<RESULTS>");
			
		if (vec!=null)
		{
		
			preds.predtm.predTM tm = new preds.predtm.predTM();
			preds.predcl.PredClass cl = new preds.predcl.PredClass();
			
			for (int i=0;i<=vec.size()-1;i++)
			{
			if (style==1)
			{
				int index1 = vec.get(i).toString().indexOf("\n");
				if (i>0)
					System.out.print("\n");
				System.out.print(vec.get(i).toString().substring(0,index1));
			}
			if (predcl == true)
			{
				if (style==0)
					System.out.print("\n<PREDCL>");
				
				cl.setStyle(style);
				cl.setFastaInput(vec.get(i).toString());
				String res= cl.getOutput();
				clres = res;
				System.out.print(res);
				
				if (style==0)
					System.out.print("</PREDCL>");
								
			}
			if (predtm == true && clres.trim().startsWith("MEM"))
			{
				if (style==0)
					System.out.print("\n<PREDTM>");
				tm.setStyle(style);
				tm.setFastaInput(vec.get(i).toString());
				String res= tm.getOutput();
				System.out.print(res);
				if (style==0)
					System.out.println("</PREDTM>");
				
			}
			}
			
		}
		if (style==0)
			System.out.println("</RESULTS>");

	}
	
	/*public static void massPredCL (java.io.File __file)
	{
		
		java.util.Vector vec = splitFastas(__file);
		if (vec!=null)
		{
			predcl.PredClass cl = new predcl.PredClass();
			cl.setStyle(style);
			if (style==0)
				System.out.print("<PREDCL>");
			for (int i=0;i<=vec.size()-1;i++)
			{
				cl.setFastaInput(vec.get(i).toString());
				String res= cl.getOutput();
				massPredTM

		}
	}
	
	public static void massPredTM (java.io.File __file)
	{
		
		java.util.Vector vec = splitFastas(__file);
		if (vec!=null)
		{
			predtm.predTM tm = new predtm.predTM();
			tm.setStyle(style);
			if (style==0)
				System.out.print("<PREDTM>");
			for (int i=0;i<=vec.size()-1;i++)
			{
				tm.setFastaInput(vec.get(i).toString());
				String res= tm.getOutput();
				System.out.print(res);
			}
			if (style==0)
				System.out.println("\n</PREDTM>");
		}

	}
	
	public static void massPredCL (java.io.File __file)
	{
		
		java.util.Vector vec = splitFastas(__file);
		if (vec!=null)
		{
			predcl.PredClass cl = new predcl.PredClass();
			cl.setStyle(style);
			if (style==0)
				System.out.print("<PREDCL>");
			for (int i=0;i<=vec.size()-1;i++)
			{
				cl.setFastaInput(vec.get(i).toString());
				String res= cl.getOutput();
				System.out.print(res);
			}
			if (style==0)
				System.out.println("\n</PREDCL>");
		}

	}
	*/
	public static java.util.Vector splitFastas(java.io.File __file)
	{
		java.util.Vector vec=null;
		//java.util.Vector names=null;
		
	   try{	
		java.io.RandomAccessFile input = new java.io.RandomAccessFile(__file, "r");
		vec = new java.util.Vector();
		StringBuffer buf = new StringBuffer();
		int index=0;
		while (input.getFilePointer()!=input.length())
		{
			String line = input.readLine().trim();
			if (line.charAt(0)=='>')
			{
				
				if (index>0)
				{
					vec.add(buf.toString());
					buf.setLength(0);
				}
				index++;
				
			}
			buf.append(line+"\n");

		}
		vec.add(buf.toString());
	     }
	     catch(java.io.IOException e)
	     {
		     e.printStackTrace();
		    return null; 
	     }
		return vec;
		
	}






}

