<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

 <xsl:include href="xml2mdoc2.xsl"/>
 <xsl:include href="xml2mdoc.xsl"/>

 <xsl:output method="text"
             encoding="UTF-8"
             omit-xml-declaration="yes"
             standalone="yes"
             indent="no"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>
</xsl:stylesheet>
