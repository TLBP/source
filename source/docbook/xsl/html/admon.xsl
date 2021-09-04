<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY section   '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::partintro
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2
                     |ancestor-or-self::sect3
                     |ancestor-or-self::sect4
                     |ancestor-or-self::sect5
                     |ancestor-or-self::refsect1
                     |ancestor-or-self::refsect2
                     |ancestor-or-self::refsect3
                     |ancestor-or-self::simplesect
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary
                     |ancestor-or-self::indexterm
                     |ancestor-or-self::index)[last()]'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: admon.xsl,v 1.1.1.1 2002/09/06 16:47:31 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template name="admon.graphic.width">
  <xsl:param name="node" select="."/>
  <xsl:text>25</xsl:text>
</xsl:template>

<xsl:template match="note|important|warning|caution|tip">
  <xsl:choose>
    <xsl:when test="$admon.graphics != 0">
      <xsl:call-template name="graphical.admonition"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="nongraphical.admonition"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>

  <xsl:variable name="this">
     <xsl:apply-templates mode="chunk-filename" select="&section;"/>
   </xsl:variable>

  <xsl:choose>
    <xsl:when test="$chunk.sections=0">
      <xsl:value-of select="$admon.graphics.path"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="this.pref">
        <xsl:call-template name="dir.prefix">
          <xsl:with-param name="target" select="$this"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select="concat(substring-after($this.pref, '../../'),$admon.graphics.path)"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="name($node)='note'">note</xsl:when>
    <xsl:when test="name($node)='warning'">warning</xsl:when>
    <xsl:when test="name($node)='caution'">caution</xsl:when>
    <xsl:when test="name($node)='tip'">tip</xsl:when>
    <xsl:when test="name($node)='important'">important</xsl:when>
    <xsl:otherwise>note</xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$admon.graphics.extension"/>
</xsl:template>

<xsl:template name="graphical.admonition">
  <div class="note">
  <table border="0">
    <tr>
      <td rowspan="2" align="center" valign="top">
        <xsl:attribute name="width">
          <xsl:call-template name="admon.graphic.width"/>
        </xsl:attribute>
        <img alt="">
          <xsl:attribute name="src">
            <xsl:call-template name="admon.graphic"/>
          </xsl:attribute>
        </img>
      </td>
      <th class="admon">
        <xsl:call-template name="anchor"/>
        <xsl:apply-templates select="." mode="object.title.markup"/>
      </th>
    </tr>
    <tr>
      <td align="left" valign="top" class="admon">
        <xsl:apply-templates/>
      </td>
    </tr>
  </table>
  </div>
</xsl:template>

<xsl:template name="nongraphical.admonition">
  <div class="blockquote">
    <div class="head3">
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates select="." mode="object.title.markup"/>
    </div>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="note/title"></xsl:template>
<xsl:template match="important/title"></xsl:template>
<xsl:template match="warning/title"></xsl:template>
<xsl:template match="caution/title"></xsl:template>
<xsl:template match="tip/title"></xsl:template>

</xsl:stylesheet>
