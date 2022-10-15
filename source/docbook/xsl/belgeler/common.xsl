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
<!DOCTYPE xsl:stylesheet [
<!ENTITY allcases  "'aâbcçdefgğhıiîjklmnoöôpqrsştuüûvwxyzAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
<!ENTITY uppercases "'AÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
<!ENTITY allasciicases  "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY asciiuppercases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  xmlns:t="http://tlbp.gen.tr/ns/tlbp"
  exclude-result-prefixes="d exsl xlink l t"
  version="1.0">

<!-- özelleştirilmiş xslt betikleri -->
<!--xsl:import href="arsiv.xsl"/-->
<xsl:import href="multindex.xsl"/>
<xsl:import href="index-lists.xsl"/>
<xsl:import href="tlbp-qandaset.xsl"/>
<xsl:import href="reftoc.xsl"/>
<xsl:import href="maketoc.xsl"/>
<!-- rastgele id üretimi durduruldu. Gereksiz güncellemeler yaratıyor.
Açmak gerekirse tlbp-chunk-common.xsl içinde href.target.uri template
içinde 820.satırda "and $object/@xml:id" koşulunu ve (tlbp) reftoc.xsl
içinde id.attribute template içinde xsl:if test="$node/@xml:id" içeren
satırı ve kapatıcısını silmek yeterlidir. Ancak,
bunu yapmak yerine xml:id'lerle değişmez id'ler oluşturmak daha iyidir. -->
<!-- özelleştirilmiş değiştirgeler -->
<xsl:param name="html.ext">.html</xsl:param>
<xsl:param name="VERSION">-special (derived from DocBook XSL v1.79.1 for Turkish Linux Documentation Project by Nilgün Belma Bugüner - nilgun (at) tlbp.org.tr)</xsl:param>
<xsl:param name="chunker.output.encoding">UTF-8</xsl:param>
<!-- hata ayıklama/geliştirme için "yes" sunumda "no" olmalı" -->
<xsl:param name="chunker.output.indent">yes</xsl:param>
<xsl:param name="l10n.xml" select="document('y11e.xml')"/>
<xsl:param name="refentry.generate.name">1</xsl:param>
<xsl:param name="refentry.generate.title">1</xsl:param>
<xsl:param name="chunk.base.dir">../htdocs/kitaplik/</xsl:param>
<xsl:param name="docbook.css.link">0</xsl:param>
<xsl:param name="callout.list.table">0</xsl:param>
<xsl:param name="chapter.autolabel">1</xsl:param>
<xsl:param name="section.autolabel">1</xsl:param>
<xsl:param name="section.label.includes.component.label">1</xsl:param>
<!-- eskiler -->
<xsl:param name="chunk.sections">1</xsl:param>
<xsl:param name="chunk.first.sections">1</xsl:param>
<xsl:param name="chunk.section.depth">1</xsl:param>
<xsl:param name="toc.section.depth">1</xsl:param>
<xsl:param name="toc.max.depth">1</xsl:param>
<xsl:param name="toc.list.type">dl</xsl:param>
<xsl:param name="root.filename"/>
<xsl:param name="use.id.as.filename">1</xsl:param>
<xsl:param name="admon.graphics.path">images/xsl/</xsl:param>
<xsl:param name="callout.graphics.path">images/xsl/callouts/</xsl:param>
<xsl:param name="navig.graphics.path">images/xsl/</xsl:param>
<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title
book      toc,title
chapter   toc,title
part      toc,title
preface   nop
qandadiv  nop
qandaset  nop
reference toc,title
sect1     nop
sect2     nop
sect3     nop
sect4     nop
sect5     nop
section   nop
set       toc,title
</xsl:param>
<!-- sözlük yapılandırılınca silinecek -->
<xsl:template match="d:dicterm|d:english|d:turkish"/>

<xsl:template name="user.head.content">
 <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
 <meta name="viewport" content="width=device-width, initial-scale=1.0" />
 <link rel="stylesheet" type="text/css" href="/style/belgeler.css"/>
 <link rel="stylesheet" type="text/css" href="/style/nav.css"/>
</xsl:template>

<xsl:template name="root.attributes">
 <xsl:attribute name="lang">tr</xsl:attribute>
 <xsl:attribute name="xml:lang">tr</xsl:attribute>
</xsl:template>

<!-- Belgelerdeki tüm eposta adresleri kaldırıldı (Şubat 2022) -->
<xsl:template match="d:email">
 <xsl:value-of select="concat('&lt;',.,'&gt;')"/>
</xsl:template>

<xsl:template match="d:struct">
 <xsl:call-template name="inline.monoseq"/>
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

  <table width="100%" cellpadding="0" cellspacing="0" border="0" class="{name(.)}">
    <xsl:apply-templates mode="titlepage.mode">
      <xsl:with-param name="numcols" select="$numcols"/>
    </xsl:apply-templates>
  </table>
 </div>
</xsl:template>

<xsl:template match="d:indexterm">
  <!-- this one must have a name, even if it doesn't have an ID -->
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <span id="{$id}" class="indexterm"/>
</xsl:template>

<xsl:template match="d:blockquote">
  <div class="{name(.)}">
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <blockquote>
      <xsl:call-template name="common.html.attributes"/>
      <xsl:apply-templates select="child::*[local-name(.)!='attribution']"/>
      <xsl:apply-templates select="d:attribution"/>
     </blockquote>
  </div>
</xsl:template>

<xsl:template match="d:attribution">
  <div>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template name="nongraphical.admonition">
  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="$admon.style != '' and $make.clean.html = 0">
      <xsl:attribute name="style">
        <xsl:value-of select="$admon.style"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$admon.textlabel != 0 or d:title or d:info/d:title">
      <h3 class="title">
        <xsl:call-template name="anchor"/>
        <xsl:apply-templates select="." mode="object.title.markup"/>
      </h3>
    </xsl:if>
    <div class="admon-contents">
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<xsl:template match="d:revhistory/d:revision" mode="titlepage.mode">
  <xsl:param name="numcols" select="'3'"/>
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate" select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <tr>
    <td style="line-height: 1rem;" align="{$direction.align.start}">
      <xsl:if test="$revnumber">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Revision'"/>
        </xsl:call-template>
        <xsl:call-template name="gentext.space"/>
        <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
      </xsl:if>
    </td>
    <td style="line-height: 1rem;" align="{$direction.align.start}">
      <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
    </td>
    <xsl:choose>
      <xsl:when test="$revauthor">
        <td style="line-height: 1rem;" align="{$direction.align.start}">
          <xsl:for-each select="$revauthor">
            <xsl:apply-templates select="." mode="titlepage.mode"/>
            <xsl:if test="position() != last()">
             <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:when>
      <xsl:when test="$numcols &gt; 2">
        <td></td>
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
    <xsl:if test="position() != last()">
     <tr>
       <td class="revremark-blank" align="{$direction.align.start}" colspan="{$numcols}"> </td>
     </tr>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:cmdsynopsis">
  <xsl:if test="position()=1">
    <br/>
  </xsl:if>
  <table>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <tr>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="1"/>
      </xsl:call-template>
      <td class="cmdsynopsis">
        <xsl:apply-templates select="*[position()=1]"/>
      </td>
      <td class="cmdsynopsis">
        <xsl:apply-templates select="*[position()>1]"/>
      </td>
   </tr>
  </table>
</xsl:template>

<xsl:template match="d:literallayout[@role='error']">
  <div class="para">
    <pre class="errorlayout">
      <xsl:apply-templates/>
    </pre>
  </div>
</xsl:template>

<xsl:template match="d:glossterm/d:glossterm[position()>1]">
  <br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:glossterm/d:glossterm[position()=1]">
  <xsl:apply-templates/>
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
      <xsl:value-of select="$translatorlabel"/>
    </xsl:when>
    <xsl:when test="@role='prep'">
      <xsl:value-of select="$preplabel"/>
    </xsl:when>
    <xsl:when test="@role='compile'">
      <xsl:value-of select="$compilelabel"/>
    </xsl:when>
    <xsl:when test="@role='editor'">
      <xsl:value-of select="$editorlabel"/>
    </xsl:when>
    <xsl:when test="@role='update'">
      <xsl:value-of select="$updatelabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$authorlabel"/>
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
    <xsl:when test="(@role='warn')">
      <em class="warn"><xsl:apply-templates/></em>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:keyword">
  <xsl:call-template name="inline.boldseq"/>
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

<!-- Kılavuz sayfalarına özel aralarında paragraf boşluğu olmayan paragraflar -->
<xsl:template match="d:simpara[name(..) = 'refsect1']">
  <xsl:if test="name(preceding-sibling::*[1]) != 'simpara'">
   <p/>
  </xsl:if>
  <div class="simpara">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:simpara[name(..) != 'refsect1' and
                               name(..) != 'revdescription']">
  <div class="simpara">
    <xsl:apply-templates/>
  </div>
  <xsl:if test="name(following-sibling::*[1]) != 'simpara'">
   <p/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:simpara[name(..) = 'revdescription']">
  <div class="simpara">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template name="paragraph">
  <xsl:param name="class" select="''"/>
  <xsl:param name="content"/>

  <xsl:variable name="p">
    <p>
      <xsl:call-template name="id.attribute"/>
      <xsl:choose>
        <xsl:when test="$class != ''">
          <xsl:call-template name="common.html.attributes">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:when><!--
        <xsl:when test="d:link">
          <xsl:attribute name="class">linkedpara</xsl:attribute>
        </xsl:when> -->
        <xsl:otherwise>
          <xsl:call-template name="common.html.attributes">
            <xsl:with-param name="class" select="''"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="d:footnote">
       <xsl:for-each select="d:footnote">
        <span class="notfoot">
         <xsl:call-template name="id.attribute">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="conditional" select="0"/>
         </xsl:call-template>
        </span>
       </xsl:for-each>
      </xsl:if>

      <xsl:copy-of select="$content"/>
    </p>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$html.cleanup != 0">
      <xsl:call-template name="unwrap.p">
        <xsl:with-param name="p" select="$p"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$p"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This template generates just the footnote marker inline.
The footnote text is handled in name="process.footnote".
The footnote marker gets an id of @id, while the
footnote text gets an id of #ftn.@id. They cross link to each other. -->
<xsl:template match="d:footnote">
  <xsl:variable name="name">
    <xsl:call-template name="object.id">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:text>#ftn.</xsl:text>
    <xsl:value-of select="$name"/>
  </xsl:variable>

  <a href="{$href}">
    <xsl:apply-templates select="." mode="class.attribute"/>
    <xsl:if test="$generate.id.attributes = 0">
      <xsl:attribute name="id">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
    </xsl:if>

    <sup>
      <xsl:apply-templates select="." mode="class.attribute"/>
      <xsl:if test="not(parent::d:para)">
       <xsl:call-template name="id.attribute">
         <xsl:with-param name="conditional" select="0"/>
       </xsl:call-template>
      </xsl:if>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="." mode="footnote.number"/>
      <xsl:text>]</xsl:text>
    </sup>
  </a>
</xsl:template>

<xsl:template match="d:formalpara">
  <dl><dt><xsl:apply-templates select="d:title"/></dt>
  <dd><xsl:apply-templates select="./*[name(.)!='title']"/></dd></dl>
</xsl:template>

<xsl:template match="d:formalpara/d:title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:funcsynopsis">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:funcsynopsisinfo">
  <xsl:variable name="rtf">
    <xsl:apply-templates/>
  </xsl:variable>
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="make-verbatim">
      <xsl:with-param name="rtf" select="$rtf"/>
    </xsl:call-template>
  </div>
</xsl:template>

<xsl:template match="d:funcprototype">
  <xsl:if test="(@xml:id)">
    <a><xsl:attribute name="name">
        <xsl:value-of select="@xml:id"/>
    </xsl:attribute></a>
  </xsl:if>
  <div class="funcprototype">
   <code><xsl:apply-templates/></code>
  </div>
</xsl:template>


<xsl:template match="d:funcdef">
  <xsl:apply-templates select="." mode="common.html.attributes"/>
  <xsl:call-template name="id.attribute"/>
  <xsl:apply-templates mode="ansi-nontabular"/>
  <xsl:text>(</xsl:text>
</xsl:template>

<xsl:template match="d:paramdef">
  <xsl:apply-templates mode="ansi-nontabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
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

<xsl:template name="refentry.header">
 <xsl:choose>
  <xsl:when test="d:info/t:pageinfo">
  <xsl:variable name="name">
    <xsl:value-of select="concat(translate(normalize-space(d:info/t:pageinfo/t:name/text()), &allasciicases;, &asciiuppercases;),'(', d:info/t:pageinfo/t:volnum/text() ,')')"/>
  </xsl:variable>
<div class="refentry-header">
  <table cellspacing="3" cellpadding="3" width="100%" border="0">
    <tr>
      <td class="mheadfoot" align="left" width="25%">
        <xsl:value-of select="$name"/>
      </td>
      <td class="mheadfoot" align="center" width="50%">
        <xsl:if test="(d:info/t:pageinfo/t:section)">
          <xsl:value-of select="d:info/t:pageinfo/t:section"/>
        </xsl:if>
        <xsl:text> </xsl:text>
      </td>
      <td class="mheadfoot" align="right" width="25%">
        <xsl:value-of select="$name"/>
      </td>
    </tr>
  </table>
</div><p/>
  </xsl:when>
  <xsl:otherwise>
  <xsl:variable name="name">
   <xsl:value-of select="concat(translate(normalize-space(d:refmeta/d:refentrytitle), &allasciicases;, &asciiuppercases;),'(', d:refmeta/d:manvolnum ,')')"/>
  </xsl:variable>
<div class="refentry-header">
  <table cellspacing="3" cellpadding="3" width="100%" border="0">
    <tr>
      <td class="mheadfoot" align="left" width="25%">
        <xsl:value-of select="$name"/>
      </td>
      <td class="mheadfoot" align="center" width="50%">
        <xsl:if test="(d:refmeta/d:refmiscinfo/d:sectdesc)">
          <xsl:value-of select="d:refmeta/d:refmiscinfo/d:sectdesc"/>
        </xsl:if>
        <xsl:text> </xsl:text>
      </td>
      <td class="mheadfoot" align="right" width="25%">
        <xsl:value-of select="$name"/>
      </td>
    </tr>
  </table>
</div><p/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="refentry.footer">
 <xsl:choose>
  <xsl:when test="not (d:info/t:pageinfo)">
   <div class="refentry-footer">
     <table cellspacing="3" cellpadding="3" width="100%" border="0">
       <tr>
         <td class="mheadfoot" align="left" width="30%">
           <xsl:if test="(d:refmeta/d:refmiscinfo/d:source)">
             <xsl:value-of select="d:refmeta/d:refmiscinfo/d:source"/>
           </xsl:if>
         </td>
         <td class="mheadfoot" align="center" width="40%">
           <xsl:if test="(d:refmeta/d:refmiscinfo/d:date)">
           <xsl:value-of select="d:refmeta/d:refmiscinfo/d:date"/>
           </xsl:if>
         </td>
         <td class="mheadfoot" align="right" width="30%">
           <xsl:value-of select="concat(translate(normalize-space(d:refmeta/d:refentrytitle), &allasciicases;, &asciiuppercases;),'(', d:refmeta/d:manvolnum ,')')"/>
         </td>
       </tr>
     </table>
   </div>
  </xsl:when>
  <xsl:otherwise>
<div class="refentry-footer">
  <table cellspacing="3" cellpadding="3" width="100%" border="0">
    <tr>
      <td class="mheadfoot" align="left" width="30%">
        <xsl:if test="(d:info/t:pageinfo/t:source)">
          <xsl:value-of select="d:info/t:pageinfo/t:source"/>
        </xsl:if>
      </td>
      <td class="mheadfoot" align="center" width="40%">
        <xsl:if test="(d:info/t:pageinfo/t:date)">
        <xsl:value-of select="d:info/t:pageinfo/t:date"/>
        </xsl:if>
      </td>
      <td class="mheadfoot" align="right" width="30%">
        <xsl:value-of select="concat(translate(normalize-space(d:info/t:pageinfo/t:name/text()), &allasciicases;, &asciiuppercases;),'(', d:info/t:pageinfo/t:volnum/text() ,')')"/>
      </td>
    </tr>
  </table>
</div>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="d:legalnotice/d:title" mode="titlepage.mode"/>

<xsl:template match="d:legalnotice" mode="titlepage.mode">
  <div class="dropnotice">
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="title.markup"/>
    </xsl:variable>

    <div class="legalnotice-title">
     <a style="text-decoration: underline"><xsl:copy-of select="$title"/></a>
    </div>
    <div class="droplegal">
     <xsl:apply-templates mode="titlepage.mode"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="d:uri[(ancestor::d:refentry) and not (child::node())]">
  <xsl:param name="xlink.targets" select="key('id',@xlink:href)"/>
  <xsl:param name="target" select="$xlink.targets[1]"/>

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
        <b><xsl:value-of select="$fname"/></b>
        <xsl:value-of select="concat('(', $volnum, ')')"/>
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
              <xsl:value-of select="$fname"/>
            </a>
            <xsl:value-of select="concat('(', $volnum, ')')"/>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$adres}">
              <b><xsl:value-of select="$fname"/></b>
            </a>
            <xsl:value-of select="concat('(', $volnum, ')')"/>
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

<xsl:template match="d:structname">
 <code><xsl:call-template name="inline.boldseq"/></code>
</xsl:template>

<xsl:template match="d:optional|d:structfield">
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="article-w3cinfo|atomEntry|cover|dicterm|english|
subtitle|turkish|titleabbrev"/>

</xsl:stylesheet>
