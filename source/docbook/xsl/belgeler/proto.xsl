<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
      docbooc/xsl/belgeler/proto.xsl
     ********************************************************************-->
<!--
   Copyright © 2023 Nilgün Belma Bugüner < //github.com/nilgun >
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:d="http://docbook.org/ns/docbook"
 xmlns="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="d" version='1.0'>

<!-- işlev, değişken gibi özelliklere bağlantıların anahtarı,
çalışması için indexterm'lerin id'si olmalı ve primary alanı hedefin adını içermeli. -->
<xsl:key name="primary"
         match="d:indexterm"
         use="d:primary"/>

<!-- İç bağlantılar şimdilik yalnızca glibc içeriğini gösteriyor. -->
<xsl:template match="d:constant|d:function|d:operator|d:statement|d:type|d:varname">
 <xsl:variable name="target" select="key('primary', .)"/>

 <xsl:choose>
  <xsl:when test="name($target[1])!='' and
                  substring-before($target[1]/@xml:id, '-')='glibc'">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="inline.boldmonoseq"/>
    </a>
  </xsl:when>
  <xsl:otherwise>
   <xsl:choose>
    <xsl:when test="name(.) = 'type' or name(.) = 'varname'">
     <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:call-template name="inline.boldmonoseq"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="d:csynopsis">
 <xsl:param name="prototype">
  <xsl:choose>
   <xsl:when test="d:csproto/@type='işlev'">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;işlev</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='makro'">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;makro</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='sonda'">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;sonda</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='ayar'">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;ayar&#160;</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='ortam'">
    <xsl:text>&#160;&#160;ortam&#160;değ</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='sabit'">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;sabit</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='değişken'">
    <xsl:text>&#160;&#160;&#160;değişken</xsl:text>
   </xsl:when>
   <xsl:when test="d:csproto/@type='veri türü'">
    <xsl:text>&#160;&#160;veri&#160;türü</xsl:text>
   </xsl:when>
   <xsl:otherwise><!-- veri yapısı -->
    <xsl:value-of select="d:csproto/@type"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:param>
  <div class="csynopsis">
   <div class="cstype">
    <xsl:value-of select="$prototype"/>
   </div>
   <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:csproto[1]">
  <div class="csproto">
   <table border="0" class="csprototab" style="cellspacing: 0; cellpadding: 0;">
   <xsl:if test="../d:header">
    <xsl:for-each select="(../d:header)">
     <tr>
      <td colspan="2">
       <code>#include &lt;</code>
        <xsl:apply-templates select="." mode="ansi-tabular"/>
       <code>&gt;</code>
      </td>
     </tr>
    </xsl:for-each>
   </xsl:if>
   <tr>
     <td style="vertical-align: text-top;">
       <xsl:apply-templates select="d:csname" mode="ansi-tabular"/>
     </td>
     <td style="vertical-align: text-top;">
      <xsl:for-each select="(d:void|d:varargs|d:csparam|d:synopsis)">
       <xsl:apply-templates select="." mode="ansi-tabular"/>
      </xsl:for-each>
     </td>
    </tr>
   </table>
  </div>
</xsl:template>


<xsl:template match="d:csproto">
  <div class="csproto-other">
   <table border="0" class="csprototab" style="cellspacing: 0; cellpadding: 0;">
   <xsl:if test="../d:header and not (preceding-sibling::d:csproto)">
    <tr>
     <td colspan="2">
      <code>#include &lt;</code>
       <xsl:apply-templates select="../d:header" mode="ansi-tabular"/>
      <code>&gt;</code>
     </td>
    </tr>
   </xsl:if>
   <tr>
     <td style="vertical-align: text-top;">
       <xsl:apply-templates select="d:csname" mode="ansi-tabular"/>
     </td>
     <td style="vertical-align: text-top;">
      <xsl:for-each select="(d:void|d:varargs|d:csparam|d:synopsis)">
       <xsl:apply-templates select="." mode="ansi-tabular"/>
      </xsl:for-each>
     </td>
    </tr>
   </table>
  </div>
</xsl:template>

<xsl:template match="d:void" mode="ansi-tabular">
  <code>void</code>
</xsl:template>

<xsl:template match="d:csparam" mode="ansi-tabular">
  <xsl:if test="not (preceding-sibling::d:csparam)">
    <strong><code>(</code></strong>
  </xsl:if>
  <xsl:apply-templates mode="ansi-tabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <strong><code>, </code></strong>
    </xsl:when>
    <xsl:when test="../@varargs">
      <strong><code>, …)</code></strong>
    </xsl:when>
    <xsl:otherwise>
      <strong><code>)</code></strong>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:varargs" mode="ansi-tabular">
  <strong><xsl:text>…</xsl:text>
    <xsl:choose>
      <xsl:when test="following-sibling::*">
	<xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<code>)</code>
      </xsl:otherwise>
    </xsl:choose></strong>
</xsl:template>

<xsl:template match="d:function|d:parameter|d:varname" mode="ansi-tabular">
  <xsl:choose>
    <xsl:when test="preceding-sibling::d:ptr">
     <strong class="type">*</strong>
    </xsl:when>
    <xsl:when test="preceding-sibling::d:pptr">
     <strong class="type">**</strong>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>&#160;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <strong>
   <code>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:apply-templates/>
   </code>
  </strong>
</xsl:template>

<xsl:template match="d:type|d:ptr|d:pptr" mode="ansi-tabular">
  <code class="type">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::d:function
                 |following-sibling::d:parameter
                 |following-sibling::d:varname">
     <xsl:text>&#160;</xsl:text>
    </xsl:if>
  </code>
</xsl:template>

<xsl:template match="d:synopsis" mode="ansi-tabular">
    <code>(<xsl:apply-templates/>)</code>
</xsl:template>

<xsl:template match="d:code" mode="ansi-tabular">
    <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="d:conceptlist">
  <div class="safety">
   <a class="xref" href="glibc-POSIX.html#glibc-POSIX-Safety-Concepts">
    <xsl:value-of select="'Evresel Güvenilirlik:'"/>
  </a>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:concept">
  <xsl:value-of select="' | '"/>
   <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:header"/>

<xsl:template match="d:header" mode="ansi-tabular">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:structname">
 <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>


</xsl:stylesheet>
