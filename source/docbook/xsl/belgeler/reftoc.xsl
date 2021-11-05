<?xml version="1.0" encoding="UTF-8"?>
<!-- ********************************************************************
      docbooc/xsl/belgeler/reftoc.xsl
     ******************************************************************** -->
<!--
   Copyright © 2002-2021 Nilgün Belma Bugüner <nilgun@tlbp·gen·tr>
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.

   You should have received a copy of the GNU Affero General Public License
   along with this program. If not, see &lt;https://www.gnu.org/licenses/&gt;.
-->
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY allcases "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY sortcases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">

<!ENTITY refname 'concat(refname/@sortas, refname, manvolnum)'>

]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:d="http://docbook.org/ns/docbook"
 exclude-result-prefixes="d" version='1.0'>

<xsl:key name="ref-letter"
         match="d:refnamediv"
         use="translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="refname"
         match="d:refnamediv"
         use="&refname;"/>

<xsl:key name="manvolnum"
         match="d:refnamediv"
         use="../d:refmeta/d:manvolnum"/>

<xsl:template name="refentry.toc">
  <xsl:param name="volnum" select="none"/>
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('manvolnum', $volnum)[translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)=$letter]) > 0">
      <div class="reftoc">
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
          <xsl:apply-templates select="key('manvolnum', $volnum)[translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)=$letter]"
                               mode="reftoc">
            <xsl:sort select="translate(&refname;,&allcases;,&sortcases;)"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="refentry.toc">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
      <xsl:with-param name="volnum" select="$volnum"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refnamediv" mode="reftoc">
  <xsl:apply-templates mode="reftoc"/>
</xsl:template>

<xsl:template match="d:refname" mode="reftoc">
  <xsl:variable name="pos" select="position()"/>
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title"/>
  </xsl:variable>
  <dt>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:copy-of select="$title"/>
    </a>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="../refpurpose[position() = $pos]"/>
  </dt>
</xsl:template>

<xsl:template match="*" mode="reftoc"/>

</xsl:stylesheet>
