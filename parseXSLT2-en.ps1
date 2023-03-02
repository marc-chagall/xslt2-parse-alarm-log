# ----------------------- Variables -----------------------
# change the folders according to the location of your files 
$Input_folder = "C:\Saxon\XSLT parse\"
$Output_folder = "C:\Saxon\XSLT parse\" 

# The xslt template is normally in the same folder as this script 
$XSLTfilename = "C:\Saxon\XSLT parse\parseXSLT2-en.xslt"

# ------------------------- Do ----------------------------
Get-ChildItem -Recurse $Input_folder -filter *.xml |
ForEach-Object { 
    try {
        
        # output file name same but with .csv instead of .xml
        $outputCSV = $Output_folder + $_.basename + ".csv" 
        
        # output log name same but with .log
        $outputLOG = $Output_folder + $_.basename + ".log" 
        
        java -cp c:\saxon\SaxonHE10-5J\saxon-he-10.5.jar net.sf.saxon.Transform -t -s:$_ -xsl:$XSLTfilename -o:$outputCSV *> $outputLOG
        
        $_ | Rename-Item -NewName {[io.path]::ChangeExtension($_.Name, "processed")}

} catch {

    throw } 

} 

# ---------------------- optional step --------------------
# makes a very large file, remove comment to execute if needed
# combines all .csv files in the current folder into one output

# Get-Content .\AuditData*.csv | Out-File .\Combined.csv

