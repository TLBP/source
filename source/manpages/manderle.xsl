<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!-- DİKKAT: Bunlar ASCII (Komut isimleri dönüşümü için) -->
<!ENTITY allcases  "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY uppercases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:doc="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="d doc date"
                version='1.0'>

<xsl:include href="xml2man.xsl"/>

<xsl:template match="/">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:book">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:reference">
   <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refentry">
 <xsl:variable name="ext">
  <xsl:value-of select="d:refmeta/d:manvolnum"/>
 </xsl:variable>
 <xsl:variable name="name">
  <xsl:value-of select="normalize-space(d:refmeta/d:refentrytitle)"/>
 </xsl:variable>
 <doc:document href="{concat('man', $ext, '/', $name, '.', $ext)}"
             method="text"
             encoding="UTF-8"
             omit-xml-declaration="yes"
             standalone="yes"
             indent="no">
<xsl:text>.ig
 * Bu kılavuz sayfası Türkçe Linux Belgelendirme Projesi (TLBP) tarafından
 * XML belgelerden derlenmiş olup manpages-tr paketinin parçasıdır:
 * https://github.com/TLBP/manpages-tr
 *
</xsl:text>
<xsl:if test="d:refmeta/d:legalnotice">
 <xsl:call-template name="verbatim">
   <xsl:with-param name="p">
    <xsl:apply-templates select="d:refmeta/d:legalnotice/d:screen"/>
   </xsl:with-param>
 </xsl:call-template>
</xsl:if>
<xsl:text>..
.\" Derlenme zamanı: </xsl:text>
  <xsl:value-of select="date:date-time()"/>
  <xsl:variable name="p">
    <xsl:text>.TH "</xsl:text>
    <xsl:value-of select="translate(normalize-space(d:refmeta/d:refentrytitle), &allcases;, &uppercases;)"/>
    <xsl:text>" </xsl:text>
    <xsl:value-of select="d:refmeta/d:manvolnum"/>
    <xsl:text> "</xsl:text>
    <xsl:value-of select="d:refmeta/d:refmiscinfo/d:date"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:refmeta/d:refmiscinfo/d:source"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:refmeta/d:refmiscinfo/d:sectdesc"/>
    <xsl:text>"</xsl:text>
  </xsl:variable>
<xsl:value-of select="concat('&#10;', normalize-space($p))"/>
<xsl:text>
.\" Sözcükleri ilgisiz yerlerden bölme (disable hyphenation)
.nh
.\" Sözcükleri yayma, sadece sola yanaştır (disable justification)
.ad l
.PD 0</xsl:text>
  <xsl:apply-templates/>
 </doc:document>
</xsl:template>

<xsl:template match="d:info|d:refname/d:refmiscinfo"/>

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

  <doc:document href="{concat($thisbase, '.', $ext)}"
             method="text"
             encoding="UTF-8"
             omit-xml-declaration="yes"
             standalone="yes"
             indent="no">
    <xsl:value-of select="concat('.so ', $mainbase, '.', $ext, '.gz&#10;')"/>
  </doc:document>
</xsl:template>



</xsl:stylesheet>
