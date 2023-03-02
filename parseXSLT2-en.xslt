<!-- 
Test execution using command prompt 
java -cp c:\saxon\SaxonHE10-5J\saxon-he-10.5.jar net.sf.saxon.Transform -t -s:"c:\saxon\XSLT parse\test.xml" -xsl:"c:\saxon\XSLT parse\testparsexslt2.xslt" -o:"c:\saxon\XSLT parse\test.csv"

using Saxon-HE 10.5J from Saxonica
requires java 
--> 
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/">
  <xsl:text>logdatetime;bed;actionlog;equipment;user;actiontype;severity;alarm;measure;compare;limit</xsl:text>
    <xsl:text>&#13;&#10;</xsl:text>
    <xsl:for-each select="ExportedAuditDataTable/Row">
      <xsl:text></xsl:text>
      <xsl:value-of select="@Date"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Bed_x0020_Label"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="normalize-space(translate(translate(@Action, '✱', '*'),'₂', '2'))"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Device_x0020_Name"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Clinical_x0020_User"/>
      <xsl:text>;</xsl:text>
	  <xsl:choose>
         <xsl:when test="contains(@Action, 'Generated')">Alarm generated</xsl:when>
         <xsl:when test="contains(@Action, 'Ended')">Alarm ended</xsl:when>
		 <xsl:when test="contains(@Action, 'sound played')">Alarm sound played</xsl:when>
		 <xsl:when test="contains(@Action, 'sound stopped')">Alarm sound stopped</xsl:when>
		 <xsl:otherwise><xsl:value-of select="@Action_x0020_Type"/></xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>;</xsl:text>
	  <xsl:choose>
	     <xsl:when test="contains(@Action, '✱✱✱') and contains(@Action, 'Generated')">Red</xsl:when>
         <xsl:when test="contains(@Action, '✱✱') and contains(@Action, 'Generated')">Yellow</xsl:when>
         <xsl:when test="contains(@Action, '✱') and contains(@Action, 'Generated')">Short Yellow</xsl:when>
         <xsl:when test="contains(@Action, '!!!') and contains(@Action, 'Generated')">Red INOP</xsl:when>
		 <xsl:when test="contains(@Action, '!!') and contains(@Action, 'Generated')">Yellow INOP</xsl:when>
		 <xsl:when test="not(contains(@Action, '!')) and not(contains(@Action,'✱')) and contains(@Action, 'Generated')">INOP</xsl:when>
		 <xsl:when test="contains(@Action, 'sound played') and contains(@Action, 'Red')">Red</xsl:when>
		 <xsl:when test="contains(@Action, 'sound played') and contains(@Action, 'Yellow')">Yellow</xsl:when>
		 <xsl:when test="contains(@Action, 'sound played') and contains(@Action, 'INOP')">INOP</xsl:when>
		 <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
	  <xsl:text>;</xsl:text>
	  <xsl:analyze-string select="normalize-space(@Action)" regex="([✱!]*[A-Za-z₂ ]+)([0-9.:,]*)\s*([&gt;]?[&lt;]?)\s*([0-9.,]*).*Generated .*" >
   		 <xsl:matching-substring> 
			  <xsl:value-of select="translate(translate(regex-group(1), '✱', '*'), '₂', '2')"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(2)"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(3)"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(4)"/>
		 </xsl:matching-substring>
	  </xsl:analyze-string>
      <xsl:analyze-string select="normalize-space(@Action)" regex="([✱!]*[A-Za-z₂ ]+)([0-9.:,]*)\s*([&gt;]?[&lt;]?)\s*([0-9.,]*).*Ended.*" >
   		 <xsl:matching-substring> 
			  <xsl:value-of select="translate(translate(regex-group(1), '✱', '*'), '₂', '2')"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(2)"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(3)"/>
			  <xsl:text>;</xsl:text>
			  <xsl:value-of select="regex-group(4)"/>
		 </xsl:matching-substring>
	  </xsl:analyze-string>
	  <xsl:text>&#13;&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>