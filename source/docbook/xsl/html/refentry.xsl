<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: refentry.xsl,v 1.2 2003/05/12 20:59:02 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="reference">
  <div class="{name(.)}">
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="reference.titlepage"/>
    <xsl:if test="not(partintro) and $generate.reference.toc != '0'">
      <xsl:call-template name="refentry.toc">
        <xsl:with-param name="volnum">
          <xsl:value-of select="refnum"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="reference" mode="division.number">
  <xsl:number from="book" count="reference" format="I."/>
</xsl:template>

<xsl:template match="reference/refnum"/>
<xsl:template match="reference/docinfo"></xsl:template>
<xsl:template match="reference/referenceinfo"></xsl:template>
<xsl:template match="reference/title"></xsl:template>
<xsl:template match="reference/subtitle"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="refentry.title">
  <xsl:param name="node" select="."/>
  <xsl:variable name="refmeta" select="$node//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select="$node//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="title"/>
      </xsl:when>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="title"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1 class="title">
    <xsl:copy-of select="$title"/>
  </h1>
</xsl:template>

<xsl:template match="refentry">
  <div class="{name(.)}">
    <xsl:if test="$refentry.generate.title != 0">
      <h2><xsl:apply-templates select="refnamediv[1]/refname"/></h2>
    </xsl:if>
    <xsl:if test="$refentry.separator != 0 and preceding-sibling::refentry">
      <div class="refentry.separator">
        <hr/>
      </div>
    </xsl:if>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="refentry.header"/>
    <dl><xsl:apply-templates/></dl>
    <xsl:call-template name="process.footnotes"/>
    <xsl:call-template name="refentry.footer"/>
  </div>
</xsl:template>

<xsl:template match="refentry/docinfo|refentry/refentryinfo"></xsl:template>

<xsl:template match="refentrytitle|refname" mode="title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refmeta">
</xsl:template>

<xsl:template match="manvolnum">
  <xsl:if test="$refentry.xref.manvolnum != 0 and not(@role)">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="refmiscinfo">
</xsl:template>

<xsl:template match="refentrytitle">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="refnamediv">
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="refnamediv[1]">
  <xsl:call-template name="anchor"/>
  <dt class="head3">
    <xsl:if test="$refentry.generate.name != 0">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefName'"/>
      </xsl:call-template>
    </xsl:if>
  </dt>
  <dd><!--p/--><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="refname">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:text> </xsl:text>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">em-dash</xsl:with-param>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
  <br/>
</xsl:template>

<xsl:template match="refdescriptor">
  <!-- todo: finish this -->
</xsl:template>

<xsl:template match="refclass">
  <div class="para">
    <b>
      <xsl:if test="@role">
        <xsl:value-of select="@role"/>
        <xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </b>
  </div>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:call-template name="anchor"/>
    <dd><div class="para"/></dd>
    <dt class="head3">
      <xsl:choose>
        <xsl:when test="refsynopsisdiv/title|title">
          <xsl:value-of select="title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
  </dt>
  <dd><div class="para">
    <xsl:apply-templates/>
  </div></dd>
</xsl:template>

<xsl:template match="refsynopsisdivinfo"></xsl:template>

<xsl:template match="refsynopsisdiv/title"/>


<xsl:template match="refsect1">
  <dt class="head3"><xsl:value-of select="title"/>
  <xsl:call-template name="anchor"/></dt>
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="refsect2">
  <dl><dt class="head4"><xsl:value-of select="title"/>
  <xsl:call-template name="anchor"/></dt>
  <dd><xsl:apply-templates/></dd></dl>
</xsl:template>

<xsl:template match="refsect3">
  <dl><dt class="head5"><xsl:value-of select="title"/>
  <xsl:call-template name="anchor"/></dt>
  <dd><xsl:apply-templates/></dd></dl>
</xsl:template>

<xsl:template match="refsect1/title"/>
<xsl:template match="refsect2/title"/>
<xsl:template match="refsect3/title"/>

<xsl:template match="refsect1info"></xsl:template>
<xsl:template match="refsect2info"></xsl:template>
<xsl:template match="refsect3info"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="refsection">
  <xsl:call-template name="anchor"/>
  <div class="{name(.)}">
    <dd><xsl:apply-templates/></dd>
  </div>
</xsl:template>

<xsl:template name="refentry.header">
<div class="refentry-header">
  <table cellspacing="3" cellpadding="3" width="100%" border="0">
    <tr>
      <td class="mheadfoot" align="left" width="25%">
        <b><xsl:value-of select="./refmeta/refentrytitle"/>
        <xsl:apply-templates select="./refmeta/manvolnum"/></b>
      </td>
      <td class="mheadfoot" align="center" width="50%">
        <xsl:if test="(./refmeta/refmiscinfo[@class='header'])">
          <b><xsl:value-of select="./refmeta/refmiscinfo[@class='header']"/></b>
        </xsl:if>
        <xsl:text> </xsl:text>
      </td>
      <td class="mheadfoot" align="right" width="25%">
        <b><xsl:value-of select="./refmeta/refentrytitle"/>
        <xsl:apply-templates select="./refmeta/manvolnum"/></b>
      </td>
    </tr>
  </table>
</div>
</xsl:template>

<xsl:template name="refentry.footer">
<div class="refentry-header">
  <table cellspacing="3" cellpadding="3" width="100%" border="0">
    <tr>
      <td class="mheadfoot" align="left" width="30%">
        <xsl:if test="(./refmeta/refmiscinfo[@class='domain'])">
          <b><xsl:value-of select="./refmeta/refmiscinfo[@class='domain']"/></b>
        </xsl:if>
      </td>
      <td class="mheadfoot" align="center" width="40%">
        <xsl:if test="(./refmeta/refmiscinfo[@class='date'])">
        <b><xsl:value-of select="./refmeta/refmiscinfo[@class='date']"/></b>
        </xsl:if>
      </td>
      <td class="mheadfoot" align="right" width="30%">
        <b><xsl:value-of select="./refmeta/refentrytitle"/>
        <xsl:apply-templates select="./refmeta/manvolnum"/></b>
      </td>
    </tr>
  </table>
</div>
</xsl:template>

<xsl:template match="remark"/>

</xsl:stylesheet>
