<!DOCTYPE HTML>
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="style/icon1.ico" />
<title>MBPpred - Manual</title>
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
<!--    
	<tr>
		<td background="style/snow.png" align="right">
			<!-- Comment out Press <a href="manual.pdf"><u>here</u></a> to download the manual.
			<a href="manual.pdf">
				<input type="button" class="fill large youtubered" value="Download Manual" />
			</a>
		</td>
	</tr>    
-->
    <tr>
		<td height="900" valign="middle" background="style/snow.png" align="center">
			<div class="main2">
					<!-- old body -->
			<div>
				<p>
					<h1>Usage</h1>
				<hr>
				</p>
			</div>
			<p>
			MBPpred is freely available through <a href="http://aias.biol.uoa.gr/MBPpred">http://bioinformatics.biol.uoa.gr/MBPpred</a>.
			</p>
			<br>
			<div>
				<p>
					<h1>Input</h1>
					<hr>
				</p>
			</div>
			<p>
				You can submit your sequences using the textbox, or the upload button. <br><br>
				The textbox submission is completed in two steps (Figure 1).
			</p>
			<p>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step 1:</strong>
				The input sequence must be in <u>FASTA format</u>. You can upload up to ~100,000 sequences. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For predictions in larger datasets users are encouraged to contact gtsaousis
				<img
					border="0"
					width="11"
					height="12"
					src="style/papaki.gif"
					alt="style/papaki.gif"
				/>
				biol.uoa.gr
			</p>
			<p>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step 2: </strong>
				The prediction is performed by pressing the <u>Submit query</u> button.
			</p>
			<br>
			<p>
				<img border="0" src="style/manual_1.png"/>
			</p>
			<p>
				<strong>Figure 1.</strong>
				The input page for running MPBpred. The textbox submission is completed in two steps, as described above.
			</p>
			<p><br></p>
			<p>
				You can upload a file with our sequences in two steps (Figure 2).
			</p>
			<p>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step 1:</strong>
				By pressing <u>Browse</u> a file selection window pops up.
			</p>
			<p>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step 2: </strong>
				A window pops up for file selection. The sequences in the input file must be in <u>FASTA format</u>. The file size cannot exceed 40 MBs (~100,000 sequences).
			</p>
			<p>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Step 3: </strong>
				The prediction is performed by pressing the <u>Upload & Submit</u> button.
			</p>
			<p>
				<img border="0" src="style/manual_2_1.png"/>
			</p>
			<p>
				<img border="0" src="style/manual_4.png"/>
			</p>
			<p>
				<img border="0" src="style/manual_2_2.png"/>
			</p>
			<p>
				<strong>Figure 2.</strong>
				The input page for running MPBpred. The upload file submission is completed in three steps, as described above.
			</p>
			<p><br></p>
			<p>
				After the user presses the <u>Submit</u> button a window pops up, informing that your request has been submitted.<br>
				Press <u>ok</u> in order to continue with the prediction.
			</p>
			<p>
				<img border="0" src="style/manual_3.png"/>
			</p>
			<p>
				<strong>Figure 3.</strong>
				The pop window after submission.
			</p>
			<p><br><br></p>
			<div>
				<p>
					<h1>Output & Download results</h1>
					<hr>
				</p>
			</div>
			<p>
				In the results page of MBPpred the user can gather information about the submission and download the files with the results: 
			</p>
			<p>
				<img border="0" src="style/manual_5.png"/>
			</p>
			<p>
				<strong>Figure 4. </strong>
				The results page after the submission of 6867 test sequences.
			</p>
			<br>
			<p>
				<br>
				<h2>Submission Information</h2>
			</p>
			<p>
					In the results page the user can gather information regarding their submission. The user can get the Job ID, the Job Submission Date and Time, the Total Number of Submitted Protein Sequences, the Number of Membrane Binding Proteins and the number of those that are Peripheral and Transmembrane.
			</p>
			<br>
			<p>
				<img border="0" src="style/manual_6_1.png"/>
			</p>
			<p>
				<strong>Figure 5. </strong>
				The submission information produced by MBPpred for a user query.
			</p>
			<br>
			<p>
				<h2>Download results</h2>
			</p>
			<p>
				MBPpred produces six files that a user can download. The final results file contains information about Membrane Binding Proteins found in the set of sequences the user has provided. The same information are given in a tab delimited format in the Tab Delimited File. The HMMER output file is the raw HMMER file, and the List of MBPs, Peripheral MBPs and Transmembrane MBPs files contain lists of all Membrane Binding, Peripheral and Transmembrane Membrane Binding Proteins accordingly.
				<br>
			</p>
			<p>
				<img border="0" src="style/manual_6.png"/>
			</p>
			<p>
				<strong>Figure 6. </strong>
				The downloadable results files that are produced after an MBPpred submission.
			</p>
			<p><br></p>
			<p>
				The user can <strong>download</strong> MBPpred prediction results in a <u>text file</u> as shown in Figure 6 by pressing the "<u>Final Results File</u>" button on the results page.
			</p>
			<p>
				In the final results file the user can gather information regarding the MBPs predicted. The first line of the file contains the <b>ID</b> that the user has provided during the submission <font color="#000080">(blue underline)</font>. The second line contains the <b>domains</b>, their <b>position</b> and their <b>score</b> <font color="#008000">(green underline)</font>. The third line (shown wrapped here for a better illustration) contains the <b>sequence</b> of the protein <font color="#9966CC">(purple underline)</font>. The fourth line gives information about the <b>sequence length</b> <font color="#C00000">(red underline)</font> and in the fifth line the <b>position</b> that this protein has in relation to the membrane plane - peripheral or transmembrane <font color="#FFCC00">(orange underline)</font>. Each entry in the file is separated by other entries with '<b>//</b>'.
			</p>
			<br>
			<p>
				<img border="1" src="style/manual_7.png"/>
			</p>
			<p>
				<strong>Figure 7. </strong>
				The final text output file of MBPpred. Here is the example of the Diacylglycerol kinase theta from <em>Homo sapiens</em>. 
			</p>
			<br>
			<p>
				<u>Note</u>
				that the text output file is maintained in the server for one week and can be accessed through the provided link (using a <u>unique</u> serial number for
				each submission, e.g. <font color="blue">1430043645</font>). All submissions and results are kept confidential and deleted after one week.
			</p>
			<p>
				Below is an example of the provided link:
				<a href ="http://aias.biol.uoa.gr/MBPpred/TMP_FILES/1430043645_finaloutput.txt" target="_blank">http://bioinformatics.biol.uoa.gr/MBPpred/results/<font color="blue">1430043645</font>_finaloutput.txt</a>
			</p>
			</table>
      <p><br></p>
		</td>
	</tr>
 


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
