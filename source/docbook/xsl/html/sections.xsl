<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: sections.xsl,v 1.4 2003/07/18 23:45:24 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="section">
  <xsl:variable name="depth" select="count(ancestor::section)+1"/>

  <div class="{name(.)}">
    <xsl:call-template name="section.titlepage"/>
    <xsl:if test="($generate.section.toc != '0'
                   and $depth &lt;= $generate.section.toc.level)
                  or refentry or @role='autotoc'">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </div>
</xsl:template>

<xsl:template name="section.title">
  <!-- the context node should be the title of a section when called -->
  <xsl:variable name="section" select="(ancestor::section
                                        |ancestor::simplesect
                                        |ancestor::sect1
                                        |ancestor::sect2
                                        |ancestor::sect3
                                        |ancestor::sect4
                                        |ancestor::sect5)[last()]"/>
  <xsl:text> </xsl:text>
  <xsl:variable name="level">
    <xsl:call-template name="section.level">
      <xsl:with-param name="node" select="$section"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="section.heading">
    <xsl:with-param name="section" select=".."/>
    <xsl:with-param name="level" select="$level"/>
    <xsl:with-param name="title">
      <xsl:apply-templates select="$section" mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect1">
  <div class="{name(.)}">
    <xsl:call-template name="sect1.titlepage"/>
    <dl><dd>
    <xsl:if test="($generate.section.toc != '0'
                   and $generate.section.toc.level &gt;= 1)
                  or refentry or ./sect2[@chunkthis]">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="process.chunk.footnotes"/>
  </dd></dl></div>
</xsl:template>

<xsl:template match="sect1/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect2">
    <xsl:call-template name="sect2.titlepage"/>
    <dl><dd>
    <xsl:if test="($generate.section.toc != '0'
                   and $generate.section.toc.level &gt;= 2)
                  or refentry">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="(@chunkthis)">
      <xsl:call-template name="process.chunk.footnotes"/>
    </xsl:if>
  </dd></dl>
</xsl:template>

<xsl:template match="sect2/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect3">
    <xsl:call-template name="sect3.titlepage"/>
    <dl><dd>
    <xsl:if test="($generate.section.toc != '0'
                   and $generate.section.toc.level &gt;= 3)
                  or refentry">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
  </dd></dl>
</xsl:template>

<xsl:template match="sect3/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect4">
    <xsl:call-template name="sect4.titlepage"/>
    <xsl:if test="($generate.section.toc != '0'
                   and $generate.section.toc.level &gt;= 4)
                  or refentry">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect4/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect5">
    <xsl:call-template name="sect5.titlepage"/>
    <xsl:if test="($generate.section.toc != '0'
                   and $generate.section.toc.level &gt;= 5)
                  or refentry">
      <xsl:call-template name="section.toc"/>
    </xsl:if>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect5/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="simplesect">
  <div class="{name(.)}">
    <xsl:call-template name="simplesect.titlepage"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="simplesect/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="section/title"></xsl:template>
<xsl:template match="section/titleabbrev"></xsl:template>
<xsl:template match="section/subtitle"></xsl:template>
<xsl:template match="sectioninfo"></xsl:template>

<xsl:template match="sect1/title"></xsl:template>
<xsl:template match="sect1/titleabbrev"></xsl:template>
<xsl:template match="sect1/subtitle"></xsl:template>
<xsl:template match="sect1info"></xsl:template>

<xsl:template match="sect2/title"></xsl:template>
<xsl:template match="sect2/subtitle"></xsl:template>
<xsl:template match="sect2/titleabbrev"></xsl:template>
<xsl:template match="sect2info"></xsl:template>

<xsl:template match="sect3/title"></xsl:template>
<xsl:template match="sect3/subtitle"></xsl:template>
<xsl:template match="sect3/subtitle"></xsl:template>
<xsl:template match="sect3info"></xsl:template>

<xsl:template match="sect4/title"></xsl:template>
<xsl:template match="sect4/subtitle"></xsl:template>
<xsl:template match="sect4/subtitle"></xsl:template>
<xsl:template match="sect4info"></xsl:template>

<xsl:template match="sect5/title"></xsl:template>
<xsl:template match="sect5/subtitle"></xsl:template>
<xsl:template match="sect5/subtitle"></xsl:template>
<xsl:template match="sect5info"></xsl:template>

<xsl:template match="simplesect/title"></xsl:template>
<xsl:template match="simplesect/titleabbrev"></xsl:template>
<xsl:template match="simplesect/subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="'1'"/>
  <xsl:param name="title"/>

  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="head{$level}">
  <!--xsl:element name="h{$level}">
    <xsl:attribute name="class">title</xsl:attribute-->
    <xsl:if test="$css.decoration != '0'">
      <xsl:if test="$level&lt;3">
        <xsl:attribute name="style">clear: both</xsl:attribute>
      </xsl:if>
    </xsl:if>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$section"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:copy-of select="$title"/>
  <!--/xsl:element-->
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="bridgehead">
  <xsl:variable name="container"
                select="(ancestor::appendix
                        |ancestor::article
                        |ancestor::bibliography
                        |ancestor::chapter
                        |ancestor::glossary
                        |ancestor::glossdiv
                        |ancestor::index
                        |ancestor::partintro
                        |ancestor::preface
                        |ancestor::refsect1
                        |ancestor::refsect2
                        |ancestor::refsect3
                        |ancestor::sect1
                        |ancestor::sect2
                        |ancestor::sect3
                        |ancestor::sect4
                        |ancestor::sect5
                        |ancestor::section
                        |ancestor::setindex
                        |ancestor::simplesect)[last()]"/>

  <xsl:variable name="clevel">
    <xsl:choose>
      <xsl:when test="local-name($container) = 'appendix'
                      or local-name($container) = 'chapter'
                      or local-name($container) = 'article'
                      or local-name($container) = 'bibliography'
                      or local-name($container) = 'glossary'
                      or local-name($container) = 'index'
                      or local-name($container) = 'partintro'
                      or local-name($container) = 'preface'
                      or local-name($container) = 'setindex'">2</xsl:when>
      <xsl:when test="local-name($container) = 'glossdiv'">
        <xsl:value-of select="count(ancestor::glossdiv)+2"/>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect1'
                      or local-name($container) = 'sect2'
                      or local-name($container) = 'sect3'
                      or local-name($container) = 'sect4'
                      or local-name($container) = 'sect5'
                      or local-name($container) = 'refsect1'
                      or local-name($container) = 'refsect2'
                      or local-name($container) = 'refsect3'
                      or local-name($container) = 'section'
                      or local-name($container) = 'simplesect'">
        <xsl:variable name="slevel">
          <xsl:call-template name="section.level">
            <xsl:with-param name="node" select="$container"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$slevel + 1"/>
      </xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="level">
    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">2</xsl:when>
      <xsl:when test="@renderas = 'sect2'">3</xsl:when>
      <xsl:when test="@renderas = 'sect3'">4</xsl:when>
      <xsl:when test="@renderas = 'sect4'">5</xsl:when>
      <xsl:when test="@renderas = 'sect5'">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$clevel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="head{$level}">
  <!--xsl:element name="h{$level}"-->
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  <!--/xsl:element-->
  </div>
</xsl:template>

</xsl:stylesheet>

