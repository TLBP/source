<?xml version="1.0" encoding="utf-8"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook"
xmlns:doc="http://nwalsh.com/xsl/documentation/1.0" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="doc d" version="1.0">

<!-- ********************************************************************
     $Id: qandaset.xsl 9354 2012-05-12 23:29:36Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:qandaset">
  <xsl:variable name="title" select="(d:blockinfo/d:title|d:info/d:title|d:title)[1]"/>
  <xsl:variable name="preamble" select="*[local-name(.) != 'title'                                           and local-name(.) != 'titleabbrev'                                           and local-name(.) != 'qandadiv'                                           and local-name(.) != 'qandaentry']"/>
  <xsl:variable name="toc">
    <xsl:call-template name="pi.dbhtml_toc"/>
  </xsl:variable>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="$title"/>
    <xsl:if test="not($title)">
      <!-- andhor is output on title if there is one -->
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="((contains($toc.params, 'toc') and $toc != '0') or $toc = '1')                   and not(ancestor::d:answer and not($qanda.nested.in.toc=0))">
      <xsl:call-template name="process.qanda.toc"/>
    </xsl:if>
    <xsl:apply-templates select="$preamble"/>
    <xsl:call-template name="process.qandaset"/>
  </div>
</xsl:template>

<xsl:template match="d:qandaset/d:blockinfo/d:title|                      d:qandaset/d:info/d:title|                      d:qandaset/d:title">
  <xsl:variable name="qalevel">
    <xsl:call-template name="qanda.section.level"/>
  </xsl:variable>
  <xsl:element name="h{string(number($qalevel)+1)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="class.attribute"/>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:qandaset/d:blockinfo|d:qandaset/d:info">
  <!-- what should this template really do? -->
  <xsl:apply-templates select="d:legalnotice" mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:qandadiv">
  <xsl:variable name="preamble" select="*[local-name(.) != 'title'                                           and local-name(.) != 'titleabbrev'                                           and local-name(.) != 'qandadiv'                                           and local-name(.) != 'qandaentry']"/>

  <xsl:if test="d:blockinfo/d:title|d:info/d:title|d:title">
    <tr class="qandadiv">
      <td align="{$direction.align.start}" valign="top" colspan="2">
        <xsl:apply-templates select="(d:blockinfo/d:title|d:info/d:title|d:title)[1]"/>
      </td>
    </tr>
  </xsl:if>

  <xsl:variable name="toc">
    <xsl:call-template name="pi.dbhtml_toc"/>
  </xsl:variable>

  <xsl:variable name="toc.params">
    <xsl:call-template name="find.path.params">
      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="(contains($toc.params, 'toc') and $toc != '0') or $toc = '1'">
    <tr class="toc">
      <td align="{$direction.align.start}" valign="top" colspan="2">
        <xsl:call-template name="process.qanda.toc"/>
      </td>
    </tr>
  </xsl:if>
  <xsl:if test="$preamble">
    <tr class="toc">
      <td align="{$direction.align.start}" valign="top" colspan="2">
        <xsl:apply-templates select="$preamble"/>
      </td>
    </tr>
  </xsl:if>
  <xsl:apply-templates select="d:qandadiv|d:qandaentry"/>
</xsl:template>

<xsl:template match="d:qandadiv/d:blockinfo/d:title|                      d:qandadiv/d:info/d:title|                      d:qandadiv/d:title">
  <xsl:variable name="qalevel">
    <xsl:call-template name="qandadiv.section.level"/>
  </xsl:variable>

  <xsl:element name="h{string(number($qalevel)+1)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="class.attribute"/>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="parent::d:qandadiv" mode="label.markup"/>
    <xsl:if test="$qandadiv.autolabel != 0">
      <xsl:apply-templates select="." mode="intralabel.punctuation"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:qandaentry">
  <li>
   <dl>
    <xsl:apply-templates/>
   </dl>
  </li>
</xsl:template>

<xsl:template match="d:question">
  <xsl:variable name="deflabel">
    <xsl:apply-templates select="." mode="qanda.defaultlabel"/>
  </xsl:variable>

  <dt class="question">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <!-- capture the id of the  quandaentry -->
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$deflabel = 'none' and not(d:label)">
        <strong xmlns:xslo="http://www.w3.org/1999/XSL/Transform"><xsl:apply-templates select="*[local-name(.) != 'label']"/></strong>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[local-name(.) != 'label']"/>
      </xsl:otherwise>
    </xsl:choose>
  </dt>
</xsl:template>

<xsl:template match="*" mode="qanda.defaultlabel">
  <xsl:choose>
    <xsl:when test="ancestor-or-self::*[@defaultlabel]">
      <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]                             /@defaultlabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$qanda.defaultlabel"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:question" mode="qanda.label">
  <xsl:variable name="deflabel">
    <xsl:apply-templates select="." mode="qanda.defaultlabel"/>
  </xsl:variable>
  <xsl:apply-templates select="." mode="label.markup"/>
  <xsl:if test="contains($deflabel, 'number') and not(d:label)">
    <xsl:apply-templates select="." mode="intralabel.punctuation"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:answer">
  <xsl:variable name="deflabel">
    <xsl:apply-templates select="." mode="qanda.defaultlabel"/>
  </xsl:variable>

  <dd>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates select="*[local-name(.) != 'label'         and local-name(.) != 'qandaentry']"/>
    <!-- * handle nested answer/qandaentry instances -->
    <!-- * (bug 1509043 from Daniel Leidert) -->
    <xsl:if test="descendant::d:question">
      <xsl:call-template name="process.qandaset"/>
    </xsl:if>
  </dd>
</xsl:template>

<xsl:template match="d:answer" mode="qanda.label">
  <xsl:apply-templates select="." mode="label.markup"/>
</xsl:template>

<xsl:template match="d:label">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="process.qanda.toc">
  <!-- * if user wants nested qandaset and qandaentry in main Qandaset TOC, -->
  <!-- * then don't also include the nested stuff in the sub TOCs -->
  <ol class="qandatoc">
    <xsl:apply-templates select="d:qandadiv" mode="qandatoc.mode"/>
    <xsl:apply-templates select="d:qandaset|d:qandaentry" mode="qandatoc.mode"/>
  </ol>
</xsl:template>

<xsl:template match="d:qandadiv" mode="qandatoc.mode">
  <dt><xsl:apply-templates select="d:title" mode="qandatoc.mode"/></dt>
  <dd><xsl:call-template name="process.qanda.toc"/></dd>
</xsl:template>

<xsl:template match="d:qandadiv/d:blockinfo/d:title|                      d:qandadiv/d:info/d:title|                      d:qandadiv/d:title" mode="qandatoc.mode">
  <xsl:variable name="qalevel">
    <xsl:call-template name="qandadiv.section.level"/>
  </xsl:variable>
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="parent::*"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="div.label">
    <xsl:apply-templates select="parent::d:qandadiv" mode="label.markup"/>
  </xsl:variable>
  <xsl:if test="string-length($div.label) != 0">
    <xsl:copy-of select="$div.label"/>
    <xsl:value-of select="$autotoc.label.separator"/>
  </xsl:if>
  <xsl:text> </xsl:text>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select="parent::*"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="d:qandaset" mode="qandatoc.mode">
  <xsl:for-each select="d:qandaentry">
    <xsl:apply-templates select="." mode="qandatoc.mode"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="d:qandaentry" mode="qandatoc.mode">
  <xsl:apply-templates select="d:question" mode="qandatoc.mode"/>
</xsl:template>

<xsl:template match="d:question" mode="qandatoc.mode">
  <xsl:variable name="firstch">
    <!-- Use a titleabbrev or title if available -->
    <xsl:choose>
      <xsl:when test="../d:blockinfo/d:titleabbrev">
        <xsl:apply-templates select="../d:blockinfo/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:blockinfo/d:title">
        <xsl:apply-templates select="../d:blockinfo/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:titleabbrev">
        <xsl:apply-templates select="../d:info/d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:titleabbrev">
        <xsl:apply-templates select="../d:titleabbrev[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:info/d:title">
        <xsl:apply-templates select="../d:info/d:title[1]/node()"/>
      </xsl:when>
      <xsl:when test="../d:title">
        <xsl:apply-templates select="../d:title[1]/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="(*[local-name(.)!='label'])[1]/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]                               /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:value-of select="$firstch"/>
    </a>
  </li>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="process.qandaset">
  <ol class="qandaset">
   <xsl:apply-templates select="d:qandaentry|d:qandadiv"/>
  </ol>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="no.wrapper.mode">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
