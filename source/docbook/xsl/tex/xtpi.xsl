<?xml version='1.0'?>
<!-- ********************************************************************
     $Id:xtpi.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:template name="pi-attribute">
  <xsl:param name="pis" select="processing-instruction('')"/>
  <xsl:param name="attribute">filename</xsl:param>
  <xsl:param name="count">1</xsl:param>
<!-- Bir processing-instruction'ın belirtilen özniteliğinin değeri ile döner. -->

  <xsl:choose>
    <xsl:when test="$count>count($pis)">
      <!-- not found -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pi">
        <xsl:value-of select="$pis[$count]"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($pi,concat($attribute, '='))">
          <xsl:variable name="rest" select="substring-after($pi,concat($attribute,'='))"/>
          <xsl:variable name="quote" select="substring($rest,1,1)"/>
          <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$pis"/>
            <xsl:with-param name="attribute" select="$attribute"/>
            <xsl:with-param name="count" select="$count + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction()">
</xsl:template>

<xsl:template match="processing-instruction('dbhtml')">
  <xsl:processing-instruction name="dbhtml">
    <xsl:value-of select="."/>
  </xsl:processing-instruction>
</xsl:template>

<xsl:template match="processing-instruction('dbpdf')">
  <xsl:processing-instruction name="dbpdf">
    <xsl:value-of select="."/>
  </xsl:processing-instruction>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbpdf-level">
  <xsl:param name="pis" select="./processing-instruction('dbpdf')"/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">level</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbhtml-attribute">
  <xsl:param name="pis" select="processing-instruction('dbhtml')"/>
  <xsl:param name="attribute">filename</xsl:param>

  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute" select="$attribute"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-filename">
  <xsl:param name="pis" select="./processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">filename</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir">
  <xsl:param name="pis" select="processing-instruction('')"/>
    <xsl:choose>
      <xsl:when test="$pis[1] != ''">
        <xsl:call-template name="dbhtml-attribute">
          <xsl:with-param name="pis" select="$pis"/>
          <xsl:with-param name="attribute">dir</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="./processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir1"/>
          </xsl:when>
          <xsl:when test="../processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir2"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::article/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.article"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::part/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.part"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::book/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.book"/>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="dbhtml-dir1">
  <xsl:param name="pis" select="./processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir2">
  <xsl:param name="pis" select="../processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.book">
  <xsl:param name="pis" select="ancestor-or-self::book/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.part">
  <xsl:param name="pis" select="ancestor-or-self::part/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.article">
  <xsl:param name="pis" select="ancestor-or-self::article/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>