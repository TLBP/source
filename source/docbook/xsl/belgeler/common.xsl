<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
      docbooc/xsl/belgeler/common.xsl
     ********************************************************************-->
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

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  exclude-result-prefixes="xlink exsl d l"
  version="1.0">

<!-- özelleştirilmiş xslt betikleri -->
<xsl:import href="arsiv.xsl"/>
<xsl:import href="multindex.xsl"/>
<xsl:import href="reftoc.xsl"/>
<xsl:import href="index-lists.xsl"/>
<xsl:import href="tlbp-qandaset.xsl"/>

<!-- özelleştirilmiş parametreler -->
<xsl:param name="VERSION">-special(derived from DocBook XSL v1.79.1 for Turkish Linux Documentation Project by Nilgün Belma Bugüner - nilgun (at) tlbp.gen.tr)</xsl:param>
<xsl:param name="chunker.output.encoding">UTF-8</xsl:param>
<!-- hata ayıklama/geliştirme için "yes" sunumda "no" olmalı" -->
<xsl:param name="chunker.output.indent">yes</xsl:param>
<xsl:param name="l10n.xml" select="document('y11e.xml')"/>
<xsl:param name="refentry.generate.name">0</xsl:param>
<xsl:param name="refentry.generate.title">1</xsl:param>
<!-- eskiler -->
<xsl:param name="chunk.sections">1</xsl:param>
<xsl:param name="chunk.first.sections">1</xsl:param>
<xsl:param name="chunk.section.depth">1</xsl:param>
<xsl:param name="toc.section.depth">2</xsl:param>
<xsl:param name="toc.list.type">dl</xsl:param>
<xsl:param name="root.filename"/>
<xsl:param name="use.id.as.filename">1</xsl:param>
<xsl:param name="html.stylesheet">belgeler.css</xsl:param>
<xsl:param name="admon.graphics.path">images/xsl/</xsl:param>
<xsl:param name="callout.graphics.path">images/xsl/callouts/</xsl:param>
<xsl:param name="navig.graphics.path">images/xsl/</xsl:param>
<xsl:param name="html.root.dir">../../htdocs/</xsl:param>
<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  toc,title
article   toc,title
book      toc,title,figure,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title,refpurpose
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
</xsl:param>

<xsl:template name="user.head.content">
 <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</xsl:template>

<xsl:template match="d:email">
  <xsl:variable name="addr">
    <xsl:call-template name="nospam">
      <xsl:with-param name="p" select="text()"/>
    </xsl:call-template>
  </xsl:variable>

  <span class="email">
   <xsl:text>&lt;</xsl:text>
   <xsl:value-of select="$addr"/>
   <xsl:text>&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template name="nospam">
  <xsl:param name="p"></xsl:param>

  <xsl:variable name="q" select="normalize-space($p)"/>
  <xsl:choose>
    <xsl:when test="contains($p,'@')">
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="$q"/>
        <xsl:with-param name="target" select="'@'"/>
        <xsl:with-param name="replace" select="' (at) '"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$q"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode"/>
<xsl:template match="d:revhistory/d:title" mode="titlepage.mode"/>

<xsl:template match="d:revhistory" mode="titlepage.mode">
  <xsl:variable name="numcols">
    <xsl:choose>
      <xsl:when test="//d:authorinitials">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="revhistory">
  <xsl:choose>
    <xsl:when test="(d:title)">
      <div class="formaltitle">
        <xsl:value-of select="d:title"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="formaltitle">
        <xsl:text>Sürüm Bilgileri</xsl:text>
      </div>
    </xsl:otherwise>
  </xsl:choose>

  <table width="100%" cellpadding="0" cellspacing="5" border="0" class="{name(.)}">
    <xsl:apply-templates mode="titlepage.mode">
      <xsl:with-param name="numcols" select="$numcols"/>
    </xsl:apply-templates>
  </table>
 </div>
</xsl:template>

<xsl:template match="d:legalnotice/d:title" mode="titlepage.mode">
  <div class="legalnotice-title"><strong xmlns:xslo="http://www.w3.org/1999/XSL/Transform"><xsl:apply-templates/></strong></div>
</xsl:template>

<xsl:template match="d:abstract" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="$abstract.notitle.enabled = 0">
      <xsl:call-template name="formal.object.heading">
        <xsl:with-param name="title">
          <xsl:apply-templates select="." mode="title.markup"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="titlepage.mode"/>
    <!--xsl:call-template name="process.footnotes"/-->
  </div>
</xsl:template>

<xsl:template match="d:literallayout">
  <div class="para">
    <pre class="literallayout">
      <xsl:apply-templates/>
    </pre>
  </div>
</xsl:template>

<xsl:template match="d:revhistory/d:revision" mode="titlepage.mode">
  <xsl:param name="numcols" select="'3'"/>
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate" select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <tr>
    <td align="{$direction.align.start}">
      <xsl:if test="$revnumber">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Revision'"/>
        </xsl:call-template>
        <xsl:call-template name="gentext.space"/>
        <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
      </xsl:if>
    </td>
    <td align="{$direction.align.start}">
      <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
    </td>
    <xsl:choose>
      <xsl:when test="$revauthor">
        <td align="{$direction.align.start}">
          <xsl:for-each select="$revauthor">
            <xsl:apply-templates select="." mode="titlepage.mode"/>
            <xsl:if test="position() != last()">
             <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:when>
      <xsl:when test="$numcols &gt; 2">
        <td>&#160;</td>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </tr>
  <xsl:if test="$revremark">
    <tr>
      <td align="{$direction.align.start}" colspan="{$numcols}">
        <xsl:apply-templates select="$revremark[1]" mode="titlepage.mode"/>
      </td>
    </tr>
  </xsl:if>
  <xsl:if test="position() != last()">
   <tr>
     <td align="{$direction.align.start}" colspan="{$numcols}">
       &#160;
     </td>
   </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="d:literallayout[@role='error']">
  <div class="para">
    <pre class="errorlayout">
      <xsl:apply-templates/>
    </pre>
  </div>
</xsl:template>

<xsl:template match="d:programlisting|d:screen|d:synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="summary">
    <xsl:choose>
      <xsl:when test="name(.) = 'programlisting'">
        <xsl:text>Dosya Dökümü</xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'screen'">
        <xsl:text>Konsol Görüntüsü</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Kullanım Sözdizimi</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="align">
    <xsl:choose>
      <xsl:when test="name(.) = 'synopsis'">
        <xsl:text>left</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>right</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@xml:id">
    <a href="{$xml:id}"/>
  </xsl:if>

  <div class="para"><div align="{$align}">
    <xsl:choose>
      <xsl:when test="@linenumbering = 'numbered'">

        <xsl:variable name="rtf">
          <xsl:apply-templates/>
        </xsl:variable>

        <table width="95%" cellpadding="0" cellspacing="1" style="border:1px dotted #999999" summary="{$summary}">
          <tr><td width="12pt" valign="top">
            <pre class="screennumbers">
              <xsl:call-template name="numbered.lines">
                <xsl:with-param name="rtf" select="$rtf"/>
              </xsl:call-template>
            </pre>
            <xsl:text> </xsl:text>
          </td>
          <td width="*" valign="top">
            <pre class="screenlines">
              <xsl:apply-templates/>
            </pre>
            <xsl:text> </xsl:text>
          </td></tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
    </xsl:otherwise>
  </xsl:choose>
  </div></div>
</xsl:template>

<xsl:template name="numbered.lines">
  <xsl:param name="rtf"></xsl:param>
  <xsl:param name="num" select="0"/>

  <xsl:if test="contains($rtf,'&#10;')">
    <xsl:if test="$num>0">
      <xsl:value-of select="$num"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="numbered.lines">
      <xsl:with-param name="rtf" select="substring-after($rtf,'&#10;')"/>
      <xsl:with-param name="num" select="$num + 1"/>
    </xsl:call-template>

  </xsl:if>
</xsl:template>

<!-- Yazar ve sürüm bilgileri alanında standart olarak bulunmayan
     ayrıntıları yazalım -->
<xsl:variable name="authorlabel">Yazan: </xsl:variable>
<xsl:variable name="translatorlabel">Çeviren: </xsl:variable>
<xsl:variable name="updatelabel">Güncelleyen: </xsl:variable>
<xsl:variable name="legallabel">Yasal Uyarı: </xsl:variable>
<xsl:variable name="preplabel">Hazırlayan: </xsl:variable>
<xsl:variable name="compilelabel">Derleyen: </xsl:variable>
<xsl:variable name="editorlabel">Düzenleyen: </xsl:variable>

<xsl:template match="d:author" mode="titlepage.mode">
  <!--xsl:if test="not (preceding-sibling::d:author)">
    <div style="padding:12px;"/>
  </xsl:if-->
  <div class="{name(.)}">
  <xsl:choose>
    <xsl:when test="@role='translator'">
      <i style="color:#999999;"><xsl:value-of select="$translatorlabel"/></i>
    </xsl:when>
    <xsl:when test="@role='prep'">
      <i style="color:#999999;"><xsl:value-of select="$preplabel"/></i>
    </xsl:when>
    <xsl:when test="@role='compile'">
      <i style="color:#999999;"><xsl:value-of select="$compilelabel"/></i>
    </xsl:when>
    <xsl:when test="@role='editor'">
      <i style="color:#999999;"><xsl:value-of select="$editorlabel"/></i>
    </xsl:when>
    <xsl:when test="@role='update'">
      <i style="color:#999999;"><xsl:value-of select="$updatelabel"/></i>
    </xsl:when>
    <xsl:otherwise>
      <i style="color:#999999;"><xsl:value-of select="$authorlabel"/></i>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="person.name"/>
  </div>
  <div><dl>
    <xsl:apply-templates mode="titlepage.mode" select="./d:affiliation"/>
    <xsl:apply-templates mode="titlepage.mode" select="./d:contrib"/>
  </dl></div>
</xsl:template>

<xsl:template match="d:address" mode="titlepage.mode">
  <dd><xsl:apply-templates mode="titlepage.mode"/></dd>
</xsl:template>

<xsl:template match="d:small">
  <small><xsl:apply-templates/></small>
</xsl:template>

<xsl:template match="d:big">
  <big><xsl:apply-templates/></big>
</xsl:template>
<!-- Custom 'emphasis' template to allow 'role="strong"' to
     also produce a bold item. -->
<xsl:template match="d:emphasis">
  <xsl:choose>
    <xsl:when test="(@role='strong') or (@role='bold') or (@remap='bf')">
      <xsl:call-template name="inline.boldseq"/>
    </xsl:when>
    <xsl:when test="(@role='input')">
      <tt class="empinput"><xsl:apply-templates/></tt>
    </xsl:when>
    <xsl:when test="(@role='output')">
      <tt class="empoutput"><xsl:apply-templates/></tt>
    </xsl:when>
    <xsl:when test="(@role='element')">
      <span class="element"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="string.replace">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="replace"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),$replace)"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="normalize-space(substring-after($string,$target))"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replace" select="$replace"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:formalpara/d:title">
  <br/><b><xsl:apply-templates/></b><br/>
</xsl:template>

<xsl:template match="d:funcsynopsis">
  <xsl:apply-templates/><div style="padding:5px"/>
</xsl:template>

<xsl:template match="d:funcsynopsisinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:funcdeflist">
  <div class="tablo">
    <div class="satir">
      <div class="solsutun">
      <table cellpadding="5" cellspacing="0" border="0" class="funcinline">
        <xsl:apply-templates/>
      </table>
      </div>
      <div class="sagsutun">
        <xsl:value-of select="@role"/>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template match="d:funcprototype">
  <xsl:if test="(@id)">
    <a><xsl:attribute name="name">
        <xsl:value-of select="@id"/>
    </xsl:attribute></a>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="name(..)!='funcdeflist'">
      <div class="tablo">
        <div class="satir">
          <div class="solsutun">
          <table cellpadding="5" cellspacing="0" border="0" class="funcinline">
            <tr><xsl:apply-templates/></tr>
          </table>
          </div>
          <div class="sagsutun">
            <xsl:value-of select="@role"/>
          </div>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <tr><xsl:apply-templates/></tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="d:funcdef">
<td valign="top" align="right" class="tt" nowrap="nowrap"><tt><xsl:apply-templates/></tt></td>
</xsl:template>

<xsl:template match="funcprototype/paramdef">
<td valign="top"><pre class="paramdef"><xsl:apply-templates/></pre></td>
</xsl:template>

<xsl:template match="parameters">
<td valign="top">
<table cellpadding="0" cellspacing="0" border="0" class="funcinline">
  <xsl:apply-templates/>
</table>
</td>
</xsl:template>

<xsl:template match="parameters/parameter">
  <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="parameter/paramdef|paramdesc">
<td valign="top" class="paramdef"><pre class="paramdef"><xsl:apply-templates/></pre></td>
</xsl:template>

<xsl:template match="d:funcdescr">
<dl><dd><xsl:apply-templates/></dd></dl>
</xsl:template>

<xsl:template match="d:superset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:uri[(ancestor::d:refentry) and not (child::node())]">
  <xsl:variable name="targets" select="key('xml:id',@xlink:href)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:variable name="name">
    <xsl:value-of select="."/>
  </xsl:variable>

  <xsl:variable name="volnum">
    <xsl:value-of select="substring-before(substring-after(@xlink:href, 'man'), '-')"/>
  </xsl:variable>

  <xsl:variable name="im">
    <xsl:value-of select="concat('man', $volnum, '-')"/>
  </xsl:variable>

  <xsl:variable name="fname">
    <xsl:value-of select="substring-after(@xlink:href, $im)"/>
  </xsl:variable>

  <tt>
    <!-- Bu özel kullanım biçimi için bak: crypt.3 ve analyze.7 -->
    <xsl:choose>
      <xsl:when test="count($target) = 0 and (@xreflabel)">
        <b><xsl:value-of select="@xreflabel"/></b>
        <xsl:value-of select="concat('[', $fname, '(', $volnum, ')]')"/>
      </xsl:when>
      <xsl:when test="count($target) = 0 and not (@xreflabel)">
        <b><xsl:value-of select="concat($fname, '(', $volnum, ')')"/></b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="adres">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="(@xreflabel)">
            <b><xsl:value-of select="@xreflabel"/></b>
            <xsl:text>[</xsl:text>
            <a href="{$adres}">
              <xsl:value-of select="concat($fname, '(', $volnum, ')')"/>
            </a>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$adres}">
              <b><xsl:value-of select="concat($fname, '(', $volnum, ')')"/></b>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </tt>
</xsl:template>

<xsl:template match="d:simplelist[not (ancestor::d:refentry)]">
  <div>
   <ul>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates mode="tlbp"/>
   </ul>
  </div>
</xsl:template>

<xsl:template match="d:member" mode="tlbp">
    <li>
     <xsl:call-template name="common.html.attributes"/>
     <xsl:call-template name="id.attribute"/>
     <xsl:apply-templates/>
    </li>
</xsl:template>

<xsl:template match="*" mode="subtoc.titleabbrev"/>

<xsl:template match="d:titleabbrev" mode="subtoc.titleabbrev">
  <xsl:text>  -  </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:abstract/d:para[1]" mode="subtoc.titleabbrev">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:rfcmaybe|d:rfcmust|d:rfcshould">
  <span class="{name(.)}">
    <xsl:apply-templates/>
    <xsl:if test="not (@unsigned)">
      <xsl:choose>
        <xsl:when test="name(.) = 'rfcmaybe'">
          <xsl:text> *SEÇİMLİK*</xsl:text>
        </xsl:when>
        <xsl:when test="name(.) = 'rfcmust'">
          <xsl:text> *ZORUNLU*</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> *ÖNERİ*</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="*" mode="w3crec.titlepage.mode"/>

<xsl:template match="cover" mode="titlepage.mode">
  <dl>
    <xsl:if test="(title)">
      <dt><b><xsl:value-of select="title"/></b></dt>
    </xsl:if>
    <dd class="coverage">
      <div class="cover">
        <xsl:apply-templates/>
      </div>
  </dd></dl>
</xsl:template>

<xsl:template match="article-w3cinfo" mode="w3crec.titlepage.mode">
  <xsl:apply-templates select="*[not (self::abstract)]" mode="w3crec.titlepage.mode"/>
  <xsl:apply-templates select="abstract" mode="w3crec.titlepage.mode"/>
</xsl:template>

<xsl:template match="title" mode="w3crec.titlepage.mode">
  <xsl:variable name="pos">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="titlecnt">
    <xsl:value-of select="count(../title)"/>
  </xsl:variable>
  <xsl:if test="$pos = '1'">
    <xsl:text disable-output-escaping="yes">&lt;div class="head1"></xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="$titlecnt > $pos">
    <br />
  </xsl:if>
  <xsl:if test="$pos = $titlecnt">
    <xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="subtitle" mode="w3crec.titlepage.mode">
  <div class="head2">
    <i><xsl:apply-templates/></i>
  </div>
</xsl:template>

<xsl:template match="abstract" mode="w3crec.titlepage.mode">
  <div class="head3">Abstract</div><dl>
  <dd><xsl:apply-templates/></dd></dl>
</xsl:template>

<xsl:template match="cover" mode="w3crec.titlepage.mode">
  <xsl:apply-templates/>
  <xsl:if test="position() = last()">
    <hr/>
  </xsl:if>
</xsl:template>

<xsl:template match="para[@role='w3clegal']">
  <div class="para w3clegal">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="module">
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="article-w3cinfo|atomEntry|cover|dicterm|english|
subtitle|turkish|titleabbrev"/>

</xsl:stylesheet>
