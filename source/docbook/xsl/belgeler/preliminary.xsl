<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="d exsl"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
xmlns="http://www.w3.org/1999/xhtml" version="1.0">
<!--chunktoc.sxl
<xsl:template match="d:preliminary" mode="preliminary">
  <xsl:call-template name="process-chunk"/>
</xsl:template>
 -->
 <!-- components.xsl -->
<xsl:template match="d:preliminary" mode="preliminary">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="preliminary.titlepage"/>
    <xsl:apply-templates/>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:preliminary/d:title|d:preliminary/d:info/d:title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::d:preliminary[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:preliminary/d:subtitle|d:preliminary/d:info/d:subtitle" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.subtitle">
    <xsl:with-param name="node" select="ancestor::d:preliminary[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:preliminary"/> <!-- see mode="preliminary" -->
<xsl:template match="d:preliminary/d:title"/>
<xsl:template match="d:preliminary/d:subtitle"/>
<xsl:template match="d:preliminary/d:titleabbrev"/>

<!-- ==================================================================== -->
<!--titlepage.xsl-->
<xsl:attribute-set name="preliminary.titlepage.recto.style"/>
<xsl:attribute-set name="preliminary.titlepage.verso.style"/>

<!--titlepge-templates.xsl -->
<xsl:template name="preliminary.titlepage.recto">
  <div xsl:use-attribute-sets="preliminary.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:preliminary[1]"/>
</xsl:call-template></div>
  <xsl:choose>
    <xsl:when test="d:preliminaryinfo/d:subtitle">
      <xsl:apply-templates mode="preliminary.titlepage.recto.auto.mode" select="d:preliminaryinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:docinfo/d:subtitle">
      <xsl:apply-templates mode="preliminary.titlepage.recto.auto.mode" select="d:docinfo/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="preliminary.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="preliminary.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="preliminary.titlepage.verso">
</xsl:template>

<xsl:template name="preliminary.titlepage.separator">
</xsl:template>

<xsl:template name="preliminary.titlepage.before.recto">
</xsl:template>

<xsl:template name="preliminary.titlepage.before.verso">
</xsl:template>

<xsl:template name="preliminary.titlepage">
  <div class="titlepage">
    <xsl:variable name="recto.content">
      <xsl:call-template name="preliminary.titlepage.before.recto"/>
      <xsl:call-template name="preliminary.titlepage.recto"/>
    </xsl:variable>
    <xsl:variable name="recto.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <xsl:value-of select="count(exsl:node-set($recto.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($recto.content) != '') or ($recto.elements.count &gt; 0)">
      <div><xsl:copy-of select="$recto.content"/></div>
    </xsl:if>
    <xsl:variable name="verso.content">
      <xsl:call-template name="preliminary.titlepage.before.verso"/>
      <xsl:call-template name="preliminary.titlepage.verso"/>
    </xsl:variable>
    <xsl:variable name="verso.elements.count">
      <xsl:choose>
        <xsl:when test="function-available('exsl:node-set')"><xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:when test="contains(system-property('xsl:vendor'), 'Apache Software Foundation')">
          <xsl:value-of select="count(exsl:node-set($verso.content)/*)"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(normalize-space($verso.content) != '') or ($verso.elements.count &gt; 0)">
      <div><xsl:copy-of select="$verso.content"/></div>
    </xsl:if>
    <xsl:call-template name="preliminary.titlepage.separator"/>
  </div>
</xsl:template>

<xsl:template match="*" mode="preliminary.titlepage.recto.mode">
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="preliminary.titlepage.verso.mode">
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subtitle" mode="preliminary.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="preliminary.titlepage.recto.style">
<xsl:apply-templates select="." mode="preliminary.titlepage.recto.mode"/>
</div>
</xsl:template>

<!-- common/label.xsl -->
<xsl:template match="d:preliminary" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<!-- common/subtitle.xsl -->
<xsl:template match="d:preliminary" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates select="(d:subtitle|d:info/d:subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- common/title.xsl -->
<xsl:template match="d:preliminary" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="d:title|d:info/d:title">
      <xsl:apply-templates select="(d:title|d:info/d:title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Preliminary'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
