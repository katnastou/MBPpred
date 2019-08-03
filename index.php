<!DOCTYPE HTML>
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="style/icon1.ico" />
<title>MBPpred - Home Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="style/styles.css">
</head>

<body background="style/stressed_linen.png" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td height="180" background="style/shattered.png"> 
			<div align="center"> 
				<table align="center" width="90%">
					<tr>
					<td align="left">
						<img src="style/header.png" align="center" height="150px">
					</td>
					
					<td align="right">
						<img src="style/header2.png" align="center" height="150px">
					</td>
					</tr>
				</table>
			</div>
		</td>
	</tr> 
  
	<tr> 
		<td height="50" valign="center" background="style/grey_wash_wall.png">
			<table width="90%" height="10" border="0" align="center">
				<td valign="center">
					<table class="nav" width="100%">
						<tr class="nav_cell">
							<td class="nav_cell" align="center">
							<a href="/MBPpred/index.php">
							<input type="button" class="fill large" value="Home"/>
							</a>
							</td>
                        
							<td class="nav_cell" align="center">
							<a href="/MBPpred/search.php">
							<input type="button" class="fill large" value="Submit" />
							</a>
							</td>
                        
							<td class="nav_cell" align="center">
							<a href="/MBPpred/manual.php">
							<input type="button" class="fill large" value="Manual" />
							</a>
							</td>
							<!--
							<td class="nav_cell" align="center">
							<a href="/MBPpred/about.php">
							<input type="button" class="fill large" value="About"/>
							</a>
							</td>
							-->
							<td class="nav_cell" align="center">
							<a href="/MBPpred/contact.php">
							<input type="button" class="fill large" value="Contact" />
							</a>
							</td>
						</tr>
					<table>
				</td>
			</table>
		</td>
	</tr>
    
	<tr>
		<td height="600" valign="top" valign="middle" background="style/snow.png">
		<br><br>
        
		<h1 align="center">
			<b>MBPpred</b>: Prediction of Membrane lipid-Binding Proteins using profile Hidden Markov Models</h1>
			<br>
        
		<table width="90%" border="0" align="center" cellpadding="2" cellspacing="0" class="description">
 			<tr align="left" valign="middle">
                <td>
					<p align="justify">
					&nbsp;&nbsp;A large number of modular domains that exhibit specific lipid-binding properties are present in many membrane proteins involved in trafficking and signal transduction. These membrane lipid-binding domains are present in eukaryotic peripheral membrane and transmembrane proteins. During the last decade computational methods that identify such proteins have been developed, but the current predictors identify only a fraction of these proteins. 
					<br><br>
					&nbsp;&nbsp;Here we report a profile Hidden Markov Model based method capable of predicting membrane binding proteins (MBPs). <strong>MBPpred</strong> can identify MBPs that contain all the membrane binding domains that have been described to date and furthermore can separate proteins based on their relative position in the membrane plane.
					<br><br>
					&nbsp;&nbsp; After an extensive literature search we were able to identify 18 domains (<i>Annexin, ANTH, BAR, C1, C2, ENTH, Discoidin, FERM, FYVE, Gla, GRAM, IMD, KA1, PH, PX, Tubby, PTB, GOLPH3</i>) that are associated with binding to membrane lipids.  For each of these domains we isolated at least one characteristic <b>pHMM</b> from <b>Pfam</b>.  Subsequently, we created a pHMM library containing the 40 pHHMs that were isolated from Pfam. The proteins that are detected from our method, are further classified - based on their interaction with the membrane plane - into <b>transmembrane</b> and <b>peripheral</b> membrane proteins with the use of an algorithm, developed in our lab, <b>PredClass</b>.
					</p>
				</td>
			</tr>
 		</table> 
		
				<table width="60%" border="0" align="center"  cellpadding="2" cellspacing="0" class="paper"> 
				<br><br><br>
			<tr>                    
				<td>
				<p align="center">				
                <b>Supplementary Data</b> after the application of MBPpred in <i>407 eukaryotic reference proteomes</i> can be found <a href="/MBPpred/supplement.tar.gz" download>here</a> <br><br>
				Current Version of MBPpred: <b>v1.0</b>
				</p>
                </td>
            </tr>                   
		</table>
		<br><br>
		<table width="60%" border="0" align="center" cellpadding="2" cellspacing="0" class="paper"> 
			<tr>                    
				<td>            
                Katerina C. Nastou, Georgios N. Tsaousis, Nikos C. Papandreou and Stavros J. Hamodrakas<br>
				<a href="http://www.sciencedirect.com/science/article/pii/S1570963916300577" target="_blank">MBPpred: Proteome-wide detection of membrane lipid-binding proteins using profile Hidden Markov Models</a><div style="font-style: italic;">Biochimica et Biophysica Acta (BBA) - Proteins and Proteomics doi:10.1016/j.bbapap.2016.03.015</div>
                </td>
            </tr>                   
		</table>
		<br>

	<tr>
		<td height="50" bgcolor="#DEDEDE" align="left">
			<table class="footer_class" border="0">
				<tr>
					<td>
					<img src="style/athena.png" alt="ath" width="53.75" height="69.5">						            
					</td>
					<td>
					<a href="http://en.uoa.gr">University of Athens</a>
					<br>
					<a href="http://en.biol.uoa.gr">Faculty of Biology</a>
					<br>
					<a href="http://biophysics.biol.uoa.gr">Biophysics & Bioinformatics Laboratory</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>

</body>
</html>
