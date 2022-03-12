<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:doc="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="d doc date"
                version='1.0'>

<xsl:template match="d:refentry">
  <xsl:variable name="r">
   <xsl:value-of select="d:refmeta/d:refmiscinfo/d:remark"/>
  </xsl:variable>
  <xsl:variable name="r1">
   <xsl:call-template name="string.replace">
     <xsl:with-param name="string" select="$r"/>
     <xsl:with-param name="target" select="'.\\'"/>
     <xsl:with-param name="replace" select="'.\'"/>
   </xsl:call-template>
  </xsl:variable>
<xsl:text>.\" https://github.com/TLBP - </xsl:text><xsl:value-of select="date:date-time()"/>
<xsl:value-of select="substring($r1, 1, string-length($r1) - 4)"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template name="linkme">

  <xsl:variable name="dizge">
    <xsl:value-of select="d:refname"/>
  </xsl:variable>

  <xsl:variable name="thisbase">
    <xsl:choose>
      <xsl:when test="contains($dizge, ' ')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$dizge"/>
          <xsl:with-param name="target" select="' '"/>
          <xsl:with-param name="replace" select="'_'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dizge"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dizge2">
    <xsl:value-of select="../d:refmeta/d:refentrytitle"/>
  </xsl:variable>

  <xsl:variable name="mainbase">
    <xsl:choose>
      <xsl:when test="contains($dizge2, ' ')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$dizge2"/>
          <xsl:with-param name="target" select="'_'"/>
          <xsl:with-param name="replace" select="' '"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dizge2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ext">
    <xsl:value-of select="../d:refmeta/d:manvolnum"/>
  </xsl:variable>

  <doc:document href="{concat('tr/man', $ext, '/', $thisbase, '.', $ext)}" omit-xml-declaration="yes">
    <xsl:value-of select="concat('.so ', $mainbase, '.', $ext, '.gz&#10;')"/>
  </doc:document>
</xsl:template>

</xsl:stylesheet>
