<!DOCTYPE HTML>
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="style/icon1.ico" />
<title>MBPpred - Results</title>
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
	<td height="500" valign="middle" align="center" background="style/snow.png">
		<div class="main2">
        	<!-- old body -->
            <?php
				set_time_limit(300); //Set the number of seconds a script is allowed to run. If this is reached, the script returns a fatal error
				$addition = time(); //pairnei to time stamp pou einai monadiko gia na ginei h onomasia twn arxeiwn
				$target = "results/"; 
				$target = $target . basename( $_FILES['uploaded']['name']) ; 
				$ok=1; 
				//This is our size condition 
				if ($uploaded_size > 52000000) { #an to arxeio einai megalutero apo 30mb den to shkwnei (ligo megalytero apo to mege8os ou an8rwpinou proteomatos)
					echo  "<table border=\"0\" align=\"center\"><tr><td>Your file is too large. To perform a large scale search please submit ". 
							"your request to gtsaousis<img src=\"style/papaki.gif\">biol.uoa.gr</td></tr></table>";
					$ok=0;
					exit;
				} 
				//Here we check that $ok was not set to 0 by an error 
				if ($ok==0) { 
					echo  "<table border=\"0\" align=\"center\"><tr><td>Sorry your file was not uploaded</td></tr></table>"; 
				} 
				//If everything is ok we try to upload it 
				else { 
					if(move_uploaded_file($_FILES['uploaded']['tmp_name'], $target)) { 
//						echo "<br>The file ".basename( $_FILES['uploaded']['name']). " has been uploaded<br>";
//						echo filesize($target);
					} 
					else { 
					echo  "<table border=\"0\" align=\"center\"><tr><td>Sorry, there was a problem uploading your file.</td></tr></table>";
					} 
				}

			if($ok==1){
				ob_flush(); 
				flush();
				sleep(1);
				$input_file = "results/INPUT_".$addition.".fasta";
				copy($target, $input_file);
				$hmmer_out = "results/".$addition."_hmmeroutput.txt";
                $res_file = "results/".$addition."_finaloutput.txt";
				$tab_res = "results/".$addition."_finaltab.txt";
//				$neg_res = "results/".$addition."_negres.txt";
				$pos_list = "results/".$addition."_poslist.txt";
//				$neg_list = "results/".$addition."_neglist.txt";
				$per_list = "results/".$addition."_peripherallist.txt";
				$tm_list =  "results/".$addition."_tmlist.txt";
                chmod($input_file,0777); // sto input file dinontai ola ta dikaiwmata gia olous tous xrhstes
                $counter=0; 
                $metrisi = 1;
				$metrisi = shell_exec("grep -c '^>' $input_file 2>&1");  // metraei posa fasta exei to query
//				echo "<p>$metrisi</p>";

               if ( $metrisi == 0 ) { // an den einai se morfopoihsh fasta to query vgainei error               
//					echo "<br><br><br><br>".$metrisi."<br>\n";
					echo  "<table border=\"0\" align=\"center\"><tr><td style=\"font-family:Verdana,Arial,Helvetica,sans-serif;font-size: 13px;\"><div align=\"center\">You did not submit any FASTA sequences.</div></td></tr><br>".
							"<tr><td style=\"font-family:Verdana,Arial,Helvetica,sans-serif;font-size: 13px;\">Please go <a href=\"/MBPpred/search.php\">back</a> and enter ".
							"<a target=\"_blank\" href = \"http://en.wikipedia.org/wiki/FASTA_format\">FASTA</a> formatted sequences.</td></tr></table>";
					exit;
                }

                elseif ( $metrisi > 100000 ) { // an o xrhsths dwsei panw apo 100000 fasta den ton afhnei na tre3ei to query
					echo "<table border=\"0\" align=\"center\"><tr><td style=\"font-family:Verdana,Arial,Helvetica,sans-serif;font-size: 13px;\"><div align=\"center\">You submitted <b>".$metrisi."</b> sequences.</div></td></tr><br>";
					echo  "<tr><td style=\"font-family:Verdana,Arial,Helvetica,sans-serif;font-size: 13px;\">Sequence limit is <b>1</b> FASTA-formatted sequence. ".
							"To perform a large scale search please submit ". 
							"your request to gtsaousis<img src=\"style/papaki.gif\">biol.uoa.gr</td></tr></table>";
					exit;
                }

               else {
//		 			echo "<p>$metrisi</p>";	
					date_default_timezone_set('UTC');		
					ob_flush(); //sends an application-initiated buffer
					flush();	// send the current content to the webserver			
					$query = shell_exec ("perl MBPred.pl $input_file $addition" ); // kalei to ektelesimo perl arxeio
					sleep (1); //xronos se sec
					$mydate=date('l jS \of F Y, G:i:s');
					$megethos = filesize($res_file); 
					$mbpsnum = shell_exec("grep -c '//' $res_file 2>&1");  // metraei poses eggrafes exei to res_file
					$pernum = shell_exec("grep -c '^>' $per_list 2>&1");
					$tmnum = shell_exec("grep -c '^>' $tm_list 2>&1");
//					$notmbpsnum = shell_exec("wc -l < $neg_list 2>&1");  // metraei poses grammes exei to neg_list
					echo "<table border=\"0\" align=\"center\"><tr><td><div align=\"center\"><h1><u><b>Final Results</u></b></h1></div></td></tr>";
//					echo "<tr><td><div align=\"center\"><p><br></p></div></td></tr>";
					echo "<ul><tr><td><li><div align=\"left\">Job ID: <b>".$addition."</b></div></li>";
					echo "<li><div align=\"left\">Job Submitted on: <b>".$mydate." (UTC/GMT)</b></div></li>";
					echo "<li><div align=\"left\">Total Number of Protein Sequences: <b>".$metrisi."</b></div></li>";
					echo "<li><div align=\"left\">Total Number of Membrane Binding Proteins: <b>".$mbpsnum."</b></div></li>";
					echo "<li><div align=\"left\">Total Number of Peripheral Membrane Binding Proteins: <b>".$pernum."</b></div></li>";
					echo "<li><div align=\"left\">Total Number of Transmembrane Membrane Binding Proteins: <b>".$tmnum."</b></div></li>";
//					echo "<li><div align=\"left\">Total Number of Non-Membrane Binding Proteins: <b>".$notmbpsnum."</b></div></li></td></tr></ul>";
					?>
					<tr><td><div align="center"><p><br></p></div></td></tr>
					</table>
					<hr>
					<table border="0" align="center">
					<tr><td><div align="center"><p><br></p></div></td></tr>
					<?php
					if ($mbpsnum != 0){
//					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href ='".$input_file."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"Input Sequence File\" /></a></div></td></tr>";
					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href ='".$res_file."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"Final Results File\" /></a></div></td>";
					echo "<td><div align=\"center\"><a target=\"_blank\" href ='".$pos_list."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"List of MBPs\" /></a></div></td></tr>";
					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href ='".$per_list."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"Peripheral MBPs\" /></a></div></td>";
					echo "<td><div align=\"center\"><a target=\"_blank\" href ='".$tm_list."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"Transmembrane MBPs\" /></a></div></td></tr>";
					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href ='".$tab_res."' download ><input type=\"button\" class=\"fill medium dynblue\" value=\"Tab-delimited file\" /></a></div></td>";
					echo "<td><div align=\"center\"><a target=\"_blank\" href ='".$hmmer_out."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"HMMER Output File\" /></a></div></td></tr>";
//					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href ='".$neg_res."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"Non-MBPs\" /></a></div></td></tr>";
//					echo "<td><div align=\"center\"><a target=\"_blank\" href ='".$neg_list."' ><input type=\"button\" class=\"fill medium dynblue\" value=\"List of non-MBPs\" /></a></div></td></tr>";
					echo "</table>";
					echo "<table border=\"0\" align=\"center\">";
					echo "<tr><td><div align=\"center\"><p><br><br></p></div></td></tr>";
					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href =\"/MBPpred/index.php\"><input type=\"button\" class=\"fill medium\" value=\"Home Page\" /></a></div></td></tr>";
					echo "</table>";
					}
					else{
					echo "<tr><td><div align=\"center\"><h1><u><b>No Membrane Binding Proteins Found</u></b></h1></div></td></tr>";
					echo "<tr><td><div align=\"center\"><p><br><br></p></div></td></tr>";
					echo "<tr><td><div align=\"center\"><a target=\"_blank\" href =\"/MBPpred/index.php\"><input type=\"button\" class=\"fill medium\" value=\"Home Page\" /></a></div></td></tr>";
					echo "</table>";
					}	
					}
				}
?>
	      <!-- old body -->
		</div>
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
