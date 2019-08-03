<!DOCTYPE HTML>
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="style/icon1.ico" />
<title>MBPpred - Submit</title>
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
		<td height="500" valign="top" valign="middle" align="left" background="style/snow.png">
			<table class="searches">
				<tr>
					<td class="searches_cell" align="left" style="padding-left:20px">
						<br>Paste your sequence(s) in 
						<a href="http://www.ncbi.nlm.nih.gov/blast/fasta.shtml" target="_blank">FASTA</a> format in the field provided below<br>
						<a href="test.txt" target="_blank" style="text-color:blue"><u>Example Sequences in FASTA format</u></a><br>
					</td>
				</tr>
				<form enctype="multipart/form-data" method="post" action="results.php">
					<tr>
						<td class="searches_cell" style="padding-left:20px">    		
							<input type="hidden" name="MAX_FILE_SIZE" value="1000000"/>
								<textarea name="textarea_search" cols="1500" rows="40" wrap="soft"></textarea>
						</td>
					</tr>				
					<tr>
						<td class="searches_cell" style="padding-left:20px">
							<div align="center" style="font-family:Verdana, Arial, Helvetica, sans-serif;">
								<br>
								<input type="submit" value="Submit query"/>
								<input type="reset" value="Clear fields">
							</div>
						</td>
					</tr>
					</form>
				<!-- file upload -->
				<tr>
				<td class="searches_cell" style="padding-left:20px">
						<br>
						Or upload a file with your sequences (maximum file size 40Mb):<br>
						<form enctype="multipart/form-data" action="upload.php" method="POST">
							<input name="uploaded" type="file" />
							<input type="submit" value="Upload & Submit"/>
						</form> 
					</td>
				</tr>
				<!-- file upload -->
					<tr>
						<td align="left" style="padding-left:20px">
							<u><b><br>Note</b></u> : </b>
							Only the first 20 characters of the header of your fasta files will be used by this program.<br> 
                    		Make sure these are unique amongst the sequences you have provided.
                	</td>
				</tr>
				<tr>
                	<td align="left" style="padding-left:20px">
                    	<i>All submitted data are kept confidential and are deleted upon one week after submission.</i>              
                	</td>
            		</tr>
				
			</table>
	    </td>
	  </tr>
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
