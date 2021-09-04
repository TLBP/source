<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
                xmlns:xverb="com.nwalsh.xalan.Verbatim"
                xmlns:lxslt="http://xml.apache.org/xslt"
                exclude-result-prefixes="sverb xverb lxslt"
                version='1.0'>

<!-- ********************************************************************
     $Id: callout.xsl,v 1.1.1.1 2002/09/06 16:47:34 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<lxslt:component prefix="xverb"
                 functions="insertCallouts"/>

<xsl:template match="programlistingco|screenco">
  <xsl:variable name="verbatim" select="programlisting|screen"/>

  <xsl:choose>
    <xsl:when test="$use.extensions != '0'
                    and $callouts.extension != '0'">
      <xsl:variable name="rtf">
        <xsl:apply-templates select="$verbatim">
          <xsl:with-param name="suppress-numbers" select="'1'"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:variable name="rtf-with-callouts">
        <xsl:choose>
          <xsl:when test="function-available('sverb:insertCallouts')">
            <xsl:copy-of select="sverb:insertCallouts(areaspec,$rtf)"/>
          </xsl:when>
          <xsl:when test="function-available('xverb:insertCallouts')">
            <xsl:copy-of select="xverb:insertCallouts(areaspec,$rtf)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>No insertCallouts function is available.</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$verbatim/@linenumbering = 'numbered'
                        and $linenumbering.extension != '0'">
          <div class="{name(.)}">
            <xsl:call-template name="number.rtf.lines">
              <xsl:with-param name="rtf" select="$rtf-with-callouts"/>
              <xsl:with-param name="pi.context"
                              select="programlisting|screen"/>
            </xsl:call-template>
            <xsl:apply-templates select="calloutlist"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="{name(.)}">
            <xsl:copy-of select="$rtf-with-callouts"/>
            <xsl:apply-templates select="calloutlist"/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <div class="{name(.)}">
        <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="areaspec|areaset|area">
</xsl:template>

<xsl:template match="areaset" mode="conumber">
  <xsl:number count="area|areaset" format="1"/>
</xsl:template>

<xsl:template match="area" mode="conumber">
  <xsl:number count="area|areaset" format="1"/>
</xsl:template>

<xsl:template match="co">
  <xsl:call-template name="anchor"/>
  <xsl:apply-templates select="." mode="callout-bug">
    <xsl:with-param name="owner" select="name(.)"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="co" mode="callout-bug">
  <xsl:param name="owner" select="''"/>
  <xsl:call-template name="callout-bug">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="conum">
      <xsl:number count="co" format="1"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="callout-bug">
  <xsl:param name="conum" select='1'/>
  <xsl:param name="owner" select="''"/>

  <xsl:variable name="this">
    <xsl:apply-templates mode="chunk-filename" select="."/>
  </xsl:variable>

  <xsl:variable name="this.pref">
    <xsl:call-template name="dir.prefix">
      <xsl:with-param name="target" select="$this"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="graphics.path">
    <xsl:value-of select="concat(substring-after($this.pref, '../../'),$callout.graphics.path)"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $conum &lt;= $callout.graphics.number.limit">
      <xsl:choose>
        <xsl:when test="$owner = 'co'">
          <b style='background: transparent url("{$graphics.path}{$conum}{$callout.graphics.extension}") no-repeat left 40%;'><xsl:text>  </xsl:text></b>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$graphics.path}{$conum}{$callout.graphics.extension}"
              alt="{$conum}" border="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $conum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$conum = 1">&#10102;</xsl:when>
            <xsl:when test="$conum = 2">&#10103;</xsl:when>
            <xsl:when test="$conum = 3">&#10104;</xsl:when>
            <xsl:when test="$conum = 4">&#10105;</xsl:when>
            <xsl:when test="$conum = 5">&#10106;</xsl:when>
            <xsl:when test="$conum = 6">&#10107;</xsl:when>
            <xsl:when test="$conum = 7">&#10108;</xsl:when>
            <xsl:when test="$conum = 8">&#10109;</xsl:when>
            <xsl:when test="$conum = 9">&#10110;</xsl:when>
            <xsl:when test="$conum = 10">&#10111;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$conum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
