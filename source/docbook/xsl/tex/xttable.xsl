<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xtblock.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->
<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "(literallayout) or (screen) or (programlisting) or (synopsis)">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template name="string.repeat">
  <xsl:param name="string" select="''"/>
  <xsl:param name="substring" select="''"/>
  <xsl:param name="count" select="0"/>
  <xsl:choose>
    <xsl:when test="$count > 0">
      <xsl:value-of select="concat($string, $substring)"/>
      <xsl:call-template name="string.repeat">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="substring" select="$substring"/>
        <xsl:with-param name="count" select="$count - 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="table|informaltable">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
<xsl:text>
\vspace{9pt minus 3pt}</xsl:text>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
  <xsl:if test="(title)">
<xsl:text>\centerline{\bfseries </xsl:text><xsl:value-of select="$caption"/><xsl:text>}\addvspace{6pt minus 2pt}</xsl:text>
  </xsl:if>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:variable name="colcount">
    <xsl:value-of select="tgroup/@cols"/>
  </xsl:variable>
    <xsl:choose>
      <xsl:when test="(tgroup/colspec[1][@colwidth &lt; 1])">
        <xsl:variable name="cols" select="tgroup//colspec"/>
        <xsl:text>&#10;\cols</xsl:text>
        <xsl:apply-templates select="$cols" mode="colwdts"/>
      </xsl:when>
      <xsl:when test="$colcount=2">
<xsl:text>&#10;\cols(0.5)(0.5)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=3">
<xsl:text>&#10;\cols(0.333)(0.334)(0.333)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=4">
<xsl:text>&#10;\cols(0.25)(0.25)(0.25)(0.25)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=5">
<xsl:text>&#10;\cols(0.2)(0.2)(0.2)(0.2)(0.2)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=6">
<xsl:text>&#10;\cols(0.1666)(0.1667)(0.1666)(0.1667)(0.1667)(0.1667)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=7">
<xsl:text>&#10;\cols(0.1428)(0.1429)(0.1428)(0.1429)(0.1428)(0.1429)(0.1429)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=8">
<xsl:text>&#10;\cols(0.125)(0.125)(0.125)(0.125)(0.125)(0.125)(0.125)(0.125)</xsl:text>
      </xsl:when>
      <xsl:when test="$colcount=9">
<xsl:text>&#10;\cols(0.1111)(0.1111)(0.1111)(0.1111)(0.1112)(0.1111)(0.1111)(0.1111)(0.1111)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- çıkarsa bakarız-->
      </xsl:otherwise>
    </xsl:choose>
  <xsl:apply-templates>
    <xsl:with-param name="colcount" select="$colcount"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*"  mode="colwdts"/>

<xsl:template match="colspec"  mode="colwdts">
  <xsl:value-of select="concat('(', @colwidth, ')')"/>
</xsl:template>

<xsl:template match="tgroup|thead|tbody">
  <xsl:param name="colcount" select="''"/>

  <xsl:apply-templates>
    <xsl:with-param name="colcount" select="$colcount"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="row">
  <xsl:param name="colcount" select="''"/>

<!-- multicols ve multirows durumlarına karşımıza çıkınca bakacağız
    (multicols için ilgili colwdt'i genişletip, sütun sayısını azaltarak)
    (multirows için ilgili sütuna innercell/cellline ile satır ekleyerek)-->
  <xsl:variable name="pos">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="name(..) = 'thead'">
        <xsl:text>\headrow</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\bodyrow</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="name(..)='tbody' and not (following-sibling::row)">
      <xsl:text>&#10;\ocolline{1}&#10;</xsl:text>
      <xsl:value-of select="$type"/><xsl:value-of select="$content"/>
      <xsl:text>&#10;\lcolline{1}\addvspace{4pt minus 2pt}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;\ocolline{1}&#10;</xsl:text>
      <xsl:value-of select="$type"/><xsl:value-of select="$content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="entry">

  <xsl:variable name="left">
    <xsl:if test="@align = 'center' or @align = 'right'">
      <xsl:text>\hfill </xsl:text>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="right">
    <xsl:if test="(not (@align) or @align != 'right') and not (&verbatim;)">
      <xsl:text>\hfill</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="strut">
    <xsl:if test="not (&verbatim;)">
      <xsl:text>\strut</xsl:text>
    </xsl:if>
  </xsl:variable>
  <!-- kaşlı ayracı kaldırma, metnin içinde köşeli ayraç olabilir -->
  <xsl:value-of select="concat('[{\strut ', $left, $content, $right, $strut, '}]')"/>
</xsl:template>

</xsl:stylesheet>
