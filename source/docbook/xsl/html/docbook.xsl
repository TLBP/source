<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<xsl:output method="xml"
            encoding="UTF-8"
            indent="no"/>

<!-- ********************************************************************
     $Id: docbook.xsl,v 1.3 2003/07/19 09:25:07 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:include href="../VERSION"/>
<xsl:include href="param.xsl"/>
<xsl:include href="../lib/lib.xsl"/>
<xsl:include href="../common/l10n.xsl"/>
<xsl:include href="../common/common.xsl"/>
<xsl:include href="../common/labels.xsl"/>
<xsl:include href="../common/titles.xsl"/>
<xsl:include href="../common/subtitles.xsl"/>
<xsl:include href="../common/gentext.xsl"/>
<xsl:include href="autotoc.xsl"/>
<!--xsl:include href="autoidx.xsl"/-->
<xsl:include href="lists.xsl"/>
<xsl:include href="callout.xsl"/>
<xsl:include href="verbatim.xsl"/>
<xsl:include href="graphics.xsl"/>
<xsl:include href="xref.xsl"/>
<xsl:include href="formal.xsl"/>
<xsl:include href="table.xsl"/>
<xsl:include href="sections.xsl"/>
<xsl:include href="inline.xsl"/>
<xsl:include href="footnote.xsl"/>
<xsl:include href="html.xsl"/>
<xsl:include href="info.xsl"/>
<xsl:include href="keywords.xsl"/>
<xsl:include href="division.xsl"/>
<xsl:include href="toc.xsl"/>
<xsl:include href="index.xsl"/>
<xsl:include href="refentry.xsl"/>
<xsl:include href="math.xsl"/>
<xsl:include href="admon.xsl"/>
<xsl:include href="component.xsl"/>
<xsl:include href="biblio.xsl"/>
<xsl:include href="glossary.xsl"/>
<xsl:include href="block.xsl"/>
<xsl:include href="qandaset.xsl"/>
<xsl:include href="synop.xsl"/>
<xsl:include href="titlepage.xsl"/>
<xsl:include href="titlepage.templates.xsl"/>
<xsl:include href="pi.xsl"/>
<xsl:include href="ebnf.xsl"/>
<xsl:include href="chunker.xsl"/>
<xsl:include href="html-rtf.xsl"/>

<!-- ==================================================================== -->

<xsl:key name="id" match="*" use="@id"/>

<!-- ==================================================================== -->

<xsl:template match="*">
  <xsl:message>
    <xsl:text>No template matches </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>.</xsl:text>
  </xsl:message>

  <font color="red">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
  </font>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template name="body.attributes">
  <xsl:attribute name="bgcolor">white</xsl:attribute>
  <xsl:attribute name="text">black</xsl:attribute>
  <xsl:attribute name="link">#0000FF</xsl:attribute>
  <xsl:attribute name="vlink">#840084</xsl:attribute>
  <xsl:attribute name="alink">#0000FF</xsl:attribute>
</xsl:template>

<xsl:template name="head.content">
  <xsl:param name="node" select="."/>

  <title>
    <xsl:apply-templates select="$node" mode="object.title.markup.textonly"/>
  </title>
  <xsl:choose>
    <xsl:when test="$chunk.sections=0">
      <xsl:if test="$html.stylesheet">
        <link rel="stylesheet"
              href="{$html.stylesheet}"
              type="{$html.stylesheet.type}"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>

      <xsl:variable name="dir">
        <xsl:call-template name="dbhtml-dir"/>
      </xsl:variable>

      <xsl:variable name="this.pref">
        <xsl:call-template name="dir.prefix">
          <xsl:with-param name="target" select="$dir"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="icon.path">
        <xsl:value-of select="concat($this.pref, 'images/belgeler-logo.png')"/>
      </xsl:variable>

      <link rel="icon"
            type="image/png"
            href="{$icon.path}"/>

      <xsl:variable name="ss.path">
        <xsl:value-of select="concat($this.pref, $html.stylesheet)"/>
      </xsl:variable>

  <xsl:variable name="this.path">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="."/>
    </xsl:call-template>
  </xsl:variable>
<!--
<xsl:message>
  <xsl:value-of select="$dir"/>;
  <xsl:value-of select="$this.pref"/>;
  <xsl:value-of select="$ss.path"/>;
  <xsl:value-of select="$this.path"/>;
</xsl:message>
-->
      <xsl:if test="$html.stylesheet">
        <link rel="stylesheet"
              href="{$ss.path}"
              type="{$html.stylesheet.type}"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$link.mailto.url != ''">
    <link rev="made"
          href="{$link.mailto.url}"/>
  </xsl:if>

  <xsl:if test="$html.base != ''">
    <base href="{$html.base}"/>
  </xsl:if>

  <meta name="generator" content="DocBook XSL Stylesheets V{$VERSION}"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />


  <xsl:apply-templates select="." mode="head.keywords.content"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="head.keywords.content">
  <xsl:apply-templates select="chapterinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="appendixinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="prefaceinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="bookinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="setinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="articleinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="artheader/keywordset" mode="html.header"/>
  <xsl:apply-templates select="sect1info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="sect2info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="sect3info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="sect4info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="sect5info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="refsect1info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="refsect2info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="refsect3info/keywordset" mode="html.header"/>
  <xsl:apply-templates select="bibliographyinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="glossaryinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="indexinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="refentryinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="partinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="referenceinfo/keywordset" mode="html.header"/>
  <xsl:apply-templates select="docinfo/keywordset" mode="html.header"/>

  <xsl:if test="$inherit.keywords != 0
                and parent::*">
    <xsl:apply-templates select="parent::*" mode="head.keywords.content"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.header.navigation">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.header.content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.footer.content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.footer.navigation">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template match="/">
  <xsl:variable name="content">
    <xsl:call-template name="oldroot"/>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:value-of select="/*[1]/@id"/>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="concat($filename, '.html')"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>

</xsl:template>

<xsl:template name="oldroot">
  <xsl:choose>
    <xsl:when test="$rootid != ''">
      <xsl:choose>
        <xsl:when test="count(key('id',$rootid)) = 0">
          <xsl:message terminate="yes">
            <xsl:text>ID '</xsl:text>
            <xsl:value-of select="$rootid"/>
            <xsl:text>' not found in document.</xsl:text>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
          <xsl:if test="$tex.math.in.alt != ''">
            <xsl:apply-templates select="key('id',$rootid)" mode="collect.tex.math"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="/" mode="process.root"/>
      <xsl:if test="$tex.math.in.alt != ''">
        <xsl:apply-templates select="/" mode="collect.tex.math"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="process.root">
  <xsl:variable name="doc" select="self::*"/>

  <html>
  <head>
    <xsl:call-template name="head.content">
      <xsl:with-param name="node" select="$doc"/>
    </xsl:call-template>
    <xsl:call-template name="user.head.content">
      <xsl:with-param name="node" select="$doc"/>
    </xsl:call-template>
  </head>
  <body>
    <xsl:call-template name="body.attributes"/>
    <xsl:call-template name="user.header.content">
      <xsl:with-param name="node" select="$doc"/>
    </xsl:call-template>
    <xsl:apply-templates select="."/>
    <xsl:call-template name="user.footer.content">
      <xsl:with-param name="node" select="$doc"/>
    </xsl:call-template>
  </body>
  </html>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <xsl:text>0</xsl:text>
</xsl:template>

<xsl:template name="href.target">
  <xsl:param name="object" select="."/>
  <xsl:text>#</xsl:text>
  <xsl:call-template name="object.id">
    <xsl:with-param name="object" select="$object"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
