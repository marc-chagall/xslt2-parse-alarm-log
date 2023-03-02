# xslt2-parse-alarm-log
Using XSLT2 to parse an XML clinical audit log file. This requires Saxon-HE 10.5J from Saxonica and Java 

To execute:

java -cp c:\saxon\SaxonHE10-5J\saxon-he-10.5.jar net.sf.saxon.Transform -t -s:"c:\saxon\XSLT parse\test.xml" -xsl:"c:\saxon\XSLT parse\parseXSLT2-en.xslt" -o:"c:\saxon\XSLT parse\test.csv"
