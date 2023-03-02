<!-- 
Test execution using command prompt 
java -cp c:\saxon\SaxonHE10-5J\saxon-he-10.5.jar net.sf.saxon.Transform -t -s:"c:\saxon\XSLT parse\test.xml" -xsl:"c:\saxon\XSLT parse\testparsexslt2.xslt" -o:"c:\saxon\XSLT parse\test.csv"

using Saxon-HE 10.5J from Saxonica
requires java 
--> 
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="text" version="2.0" encoding="UTF-8" indent="no"/>
  <xsl:template match="/">
  <xsl:text>logdatetime;bed;actionlog;equipment;user;actiontype;severity;alarm;measure;compare;limit</xsl:text>
    <xsl:text>&#13;&#10;</xsl:text>
    <xsl:for-each select="ExportedAuditDataTable/Row">
      <xsl:text></xsl:text>
      <xsl:value-of select="@Datum"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Bettname"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="normalize-space(translate(translate(@Aktion, '✱', '*'),'₂', '2'))"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Geräte-Name"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="@Klinischer_x0020_Benutzer"/>
      <xsl:text>;</xsl:text>
	  <xsl:choose>
         <xsl:when test="contains(@Aktion, 'generiert')">Alarm generated</xsl:when>
         <xsl:when test="contains(@Aktion, 'beendet.') and matches(@Aktionsart, '.* Alarm')">Alarm ended</xsl:when>
		 <xsl:when test="matches(@Aktion, 'Ton.*wurde beendet.')">Alarm sound ended</xsl:when>
		 <xsl:when test="contains(@Aktion, 'ertönt')">Alarm sound played</xsl:when>
		 <xsl:otherwise><xsl:value-of select="@Aktionsart"/></xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>;</xsl:text>
	  <xsl:choose>
	     <xsl:when test="contains(@Aktion, '✱✱✱') and contains(@Aktion, 'generiert')">Red</xsl:when>
         <xsl:when test="contains(@Aktion, '✱✱') and contains(@Aktion, 'generiert')">Yellow</xsl:when>
         <xsl:when test="contains(@Aktion, '✱') and contains(@Aktion, 'generiert')">Short Yellow</xsl:when>
         <xsl:when test="contains(@Aktion, '!!!') and contains(@Aktion, 'generiert')">Red INOP</xsl:when>
		 <xsl:when test="contains(@Aktion, '!!') and contains(@Aktion, 'generiert')">Yellow INOP</xsl:when>
		 <xsl:when test="not(contains(@Aktion, '!')) and not(contains(@Aktion,'✱')) and contains(@Aktion, 'generiert')">INOP</xsl:when>
		 <xsl:when test="contains(@Aktion, 'ertönt') and contains(@Aktion, 'rot')">Red</xsl:when>
		 <xsl:when test="contains(@Aktion, 'ertönt') and contains(@Aktion, 'gelb')">Yellow</xsl:when>
		 <xsl:when test="contains(@Aktion, 'ertönt') and contains(@Aktion, 'techn')">Yellow</xsl:when>
		 <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
	  <xsl:text>;</xsl:text>
	  <xsl:choose>
		<xsl:when test="contains(@Aktion, 'generiert') and matches(@Aktionsart, '.*[&gt;]?[&lt;]?.*')">
	    <!-- explanation of regex 
				 zero or more * or !   [✱!]*
				 optional space  *\s?
				 at least one char [A-Za-z]+
				 followed by one or more char [A-Za-z₂äöüÄÖÜß -]+
				 followed by none or one number [₂0-9]?
				 followed by one or more char [A-Za-z₂äöüÄÖÜß -]+
		-->
		  <xsl:analyze-string select="normalize-space(@Aktion)" 
				regex="([✱!]*\s?[A-Za-z]+[A-Za-z₂äöüÄÖÜß -]+[₂0-9]?)\s+(\d*[:,]*\d*)\s*([&gt;]?[&lt;]?)\s*(\d*[:,]*\d*).*generiert um.*" >
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
		</xsl:when>
		<xsl:when test="contains(@Aktion, 'beendet.') and matches(@Aktionsart, '.* Alarm')">
		  <xsl:analyze-string select="normalize-space(@Aktion)" regex="([✱!]*[A-Za-z2₂äöüÄÖÜß ]+)\s+([0-9:,]*)\s*([&gt;]?[&lt;]?)\s*([0-9:,]*).*beendet.*" >
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
		</xsl:when>
		<xsl:when test="contains(@Aktion, 'generiert') and NOT(matches(@Aktionsart, '.* Alarm'))">
		  <!-- simply all the alarms that don't have < or > --> 
		  <xsl:analyze-string select="normalize-space(@Aktion)" regex="(.*)\s*generiert*" >
			  <xsl:matching-substring> 
				<xsl:text> </xsl:text>
				<xsl:text>;</xsl:text>
				<xsl:value-of select="regex-group(1)"/>
				<xsl:text>;</xsl:text>
				<xsl:value-of select="regex-group(3)"/>
				<xsl:text>;</xsl:text>
				<xsl:value-of select="regex-group(4)"/>
			  </xsl:matching-substring>
		  </xsl:analyze-string>
		</xsl:when>
	  </xsl:choose>
	  <xsl:text>&#13;&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>