<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id:xtref.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://exslt.org/common"
                extension-element-prefixes="doc"
                version='1.0'>

<xsl:template match="refnamediv">
<xsl:text>
\enhanceindent\vspace{-12pt}
\indentedpar{</xsl:text>
  <xsl:apply-templates/>
<xsl:text>}
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="refnamediv[1]">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'refentry'"><xsl:text>\refsectone</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;', $makro, '{İSİM}')"/>
<xsl:text>
\enhanceindent\vspace{-6pt}
\indentedpar{</xsl:text>
  <xsl:apply-templates/>
<xsl:text>}
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="refname">
  <xsl:apply-templates/>
  <xsl:text> &lt;i/> </xsl:text>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'refentry'"><xsl:text>\refsectone</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates mode="titlemode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>KULLANIM</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;', $makro, '{', normalize-space($title),'}')"/>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="refsect1">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'refentry'"><xsl:text>\refsectone</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;', $makro, '{', normalize-space($content),'}')"/>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:if test="./*[2] != ((literallayout) or (screen) or (programlisting) or (synopsis))"><xsl:text>\vspace{-9pt}</xsl:text></xsl:if>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="refsect2">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'refentry'"><xsl:text>\refsecttwo</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;', $makro, '{', normalize-space($content),'}')"/>
<xsl:if test="./*[2] != ((literallayout) or (screen) or (programlisting) or (synopsis))"><xsl:text>\vspace{-9pt}</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect3">
  <xsl:variable name="makro">
    <xsl:choose>
      <xsl:when test="name($mainnode) = 'refentry'"><xsl:text>\refsectthree</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;', $makro, '{', normalize-space($content),'}')"/>
<xsl:if test="./*[2] != ((literallayout) or (screen) or (programlisting) or (synopsis))"><xsl:text>\vspace{-9pt}</xsl:text></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="remark" mode="man-ozel">
  <xsl:variable name="p0">
    <xsl:call-template name="texize">
      <xsl:with-param name="t">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string">
            <xsl:value-of select="."/>
          </xsl:with-param>
          <xsl:with-param name="target" select="'.\&#34;'"/>
          <xsl:with-param name="replace" select="''"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="$p0"/>
    <xsl:with-param name="target" select="'&#10;'"/>
    <xsl:with-param name="replace" select="'\hfil\break '"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>