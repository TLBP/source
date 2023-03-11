<?xml version="1.0" encoding="UTF-8"?>
<!-- ********************************************************************
     docbooc/xsl/belgeler/autodict.xsl
     ******************************************************************** -->
<!-- Copyright ©  2004-2023  Nilgün Belma Bugüner <https://github.com/nilgun> -->
<!-- This program is free software; you can redistribute it and/or modify -->
<!-- it under the terms of the GNU General Public License as published by -->
<!-- the Free Software Foundation; either version 2 of the License, or -->
<!-- (at your option) any later version.-->
<!--  -->
<!-- This program is distributed in the hope that it will be useful,-->
<!-- but WITHOUT ANY WARRANTY; without even the implied warranty of -->
<!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the -->
<!-- GNU General Public License for more details.-->
<!-- -->
<!-- You should have received a copy of the GNU General Public License -->
<!-- along with this program; if not, write to the Free Software -->
<!-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA -->
<!DOCTYPE xsl:stylesheet [

<!ENTITY en-allcases  "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY en-sortcases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">

<!ENTITY tr-allcases "'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY tr-sortcases "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">

<!ENTITY english 'concat(d:english/@sortas, d:english[not(@sortas)])'>
<!ENTITY turkish 'concat(d:turkish/@sortas, d:turkish[not(@sortas)])'>

<!ENTITY sep '" "'>

<!ENTITY section.t  '(ancestor-or-self::d:set
                     |ancestor-or-self::d:book
                     |ancestor-or-self::d:part
                     |ancestor-or-self::d:reference
                     |ancestor-or-self::d:chapter
                     |ancestor-or-self::d:appendix
                     |ancestor-or-self::d:preface
                     |ancestor-or-self::d:article
                     |ancestor-or-self::d:sect1
                     |ancestor-or-self::d:refentry
                     |ancestor-or-self::d:bibliography
                     |ancestor-or-self::d:glossary
                     |ancestor-or-self::d:index
                     |ancestor-or-self::d:sect2[normalize-space(parent::d:sect1/processing-instruction("dbhtml")) = "chunkthis"][not(@userlevel)])[last()]'>

]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

<xsl:key name="en-letter"
         match="d:dicterm"
         use="translate(substring(&english;, 1, 1), &en-allcases;, &en-sortcases;)"/>

<xsl:key name="tr-letter"
         match="d:dicterm"
         use="translate(substring(&turkish;, 1, 1),&tr-allcases;, &tr-sortcases;)"/>

<xsl:key name="english"
         match="d:dicterm"
         use="&english;"/>

<xsl:key name="turkish"
         match="d:dicterm"
         use="&turkish;"/>

<xsl:template name="generate-tr-dict">
  <xsl:variable name="others" select="key('turkish',&turkish;)[not(contains(&tr-allcases;, substring(&turkish;, 1, 1)))]"/>
  <div class="dict">
    <div class="letters">
      <xsl:call-template name="dict.letters">
        <xsl:with-param name="target" select="'tr-letter'"/>
        <xsl:with-param name="case" select="&tr-allcases;"/>
        <xsl:with-param name="letternum" select="0"/>
      </xsl:call-template>
    </div>
    <xsl:if test="$others">
      <div class="dictdiv">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </h3>
        <dl>
          <xsl:apply-templates select="$others[count(.|key('turkish',
                                       &turkish;)[1]) = 1]"
                               mode="dict-tr">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:sort select="&turkish;"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>
    <xsl:call-template name="alphabetical-dict-tr"/>
  </div>
</xsl:template>

<xsl:template name="generate-en-dict">
  <xsl:variable name="others" select="key('english',&english;) [not(contains(&en-allcases;, substring(&english;, 1, 1)))]"/>
  <div class="dict">
    <div class="letters">
      <xsl:call-template name="dict.letters">
        <xsl:with-param name="target" select="'en-letter'"/>
        <xsl:with-param name="case" select="&en-allcases;"/>
        <xsl:with-param name="letternum" select="0"/>
      </xsl:call-template>
    </div>
    <xsl:if test="$others">
      <div class="dictdiv">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </h3>
        <dl>
          <xsl:apply-templates select="$others[count(.|key('english',
                                       &english;)[1]) = 1]"
                               mode="dict-en">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:sort select="&english;"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>
    <xsl:call-template name="alphabetical-dict"/>
  </div>
</xsl:template>

<xsl:template name="dict.letters">
  <xsl:param name="target"/>
  <xsl:param name="case"/>
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length($case) > $letternum">
   <xsl:variable name="letter" select="substring($case,$letternum + 1,1)"/>
    <xsl:if test="count(key($target, $letter)) > 0">
     <a>
      <xsl:attribute name="href">
       <xsl:value-of select="concat('#', @xml:id, '-ltr-',$letter)"/>
      </xsl:attribute>
      <xsl:value-of select="concat('&#160;',$letter, '&#160;')"/>
     </a><xsl:text>&#160;&#160;&#160;</xsl:text>
    </xsl:if>

    <xsl:call-template name="dict.letters">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="case" select="$case"/>
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="alphabetical-dict-tr">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&tr-allcases;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&tr-allcases;,$letternum + 1,1)"/>

    <xsl:if test="count(key('tr-letter', $letter)) > 0">
      <div class="dictdiv">
        <xsl:attribute name="id">
         <xsl:value-of select="concat(@xml:id, '-ltr-',$letter)"/>
        </xsl:attribute>
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
          <xsl:apply-templates select="key('tr-letter', $letter)[count(.|key('turkish', &turkish;)[1]) = 1]"
                               mode="dict-tr">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="node" select="."/>
            <xsl:sort select="translate(&turkish;,&tr-allcases;, &tr-sortcases;)"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-dict-tr">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="alphabetical-dict">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&en-allcases;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&en-allcases;,$letternum + 1,1)"/>

    <xsl:if test="count(key('en-letter', $letter)) > 0">
      <div class="dictdiv">
        <xsl:attribute name="id">
         <xsl:value-of select="concat(@xml:id, '-ltr-',$letter)"/>
        </xsl:attribute>
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
          <xsl:apply-templates select="key('en-letter', $letter)[count(.|key('english', &english;)[1]) = 1]"
                               mode="dict-en">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="node" select="."/>
            <xsl:sort select="translate(&english;,&en-allcases;,&en-sortcases;)"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-dict">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="d:dicterm" mode="dict-tr">
  <xsl:param name="is.first" select="0"/>
  <xsl:param name="node"/>
  <xsl:variable name="key" select="&turkish;"/>
  <xsl:variable name="refs" select="key('turkish', $key)"/>
  <dt>
    <xsl:apply-templates mode="alphabetic-dict-tr"/>
    <xsl:for-each select="$refs">
      <xsl:if test="position()>1">
        <xsl:text>,   </xsl:text>
      </xsl:if>
      <span><!--
        <xsl:attribute name="title">
          <xsl:call-template name="href.target">
            <xsl:with-param name="toc-context" select="$node"/>
            <xsl:with-param name="context" select="&section.t;"/>
          </xsl:call-template>
        </xsl:attribute>-->
        <xsl:value-of select="d:english"/>
      </span>   
    </xsl:for-each>
  </dt><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="d:dicterm" mode="dict-en">
  <xsl:param name="is.first" select="0"/>
  <xsl:param name="node"/>
  <xsl:variable name="key" select="&english;"/>
  <xsl:variable name="refs" select="key('english', $key)"/>
  <dt>
    <xsl:apply-templates mode="alphabetic-dict"/>

    <xsl:for-each select="$refs">
      <xsl:if test="position()>1">
        <xsl:text>,   </xsl:text>
      </xsl:if>
      <span>
        <xsl:attribute name="title">
          <xsl:call-template name="href.target">
            <xsl:with-param name="toc-context" select="$node"/>
            <xsl:with-param name="context" select="&section.t;"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:value-of select="d:turkish"/>
      </span>   
    </xsl:for-each>
  </dt><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="*" mode="alphabetic-dict-tr"/>
<xsl:template match="*" mode="alphabetic-dict"/>

<xsl:template match="d:turkish" mode="alphabetic-dict-tr">
  <span class="dict">
    <xsl:apply-templates/><xsl:text>:   </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:english" mode="alphabetic-dict">
  <span class="dict">
    <xsl:apply-templates/><xsl:text>:   </xsl:text>
  </span>
</xsl:template>

<xsl:template match="d:dictionary/d:title|d:dictionary/d:subtitle"/>

<xsl:template match="d:dictionary/d:title" mode="component.title.mode">
  <h2 class="title">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="d:dictionary/d:subtitle" mode="component.title.mode">
  <h3>
    <i><xsl:apply-templates/></i>
  </h3>
</xsl:template>

<xsl:template name="dictionary.titlepage.recto">
  <div xsl:use-attribute-sets="dictionary.titlepage.recto.style">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:dictionary[1]"/>
</xsl:call-template></div>
  <xsl:choose>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="dictionary.titlepage.recto.auto.mode" select="d:info/d:subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="dictionary.titlepage.recto.auto.mode" select="d:subtitle"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="dictionary.titlepage.verso">
</xsl:template>

<xsl:template name="dictionary.titlepage.separator">
</xsl:template>

<xsl:template name="dictionary.titlepage.before.recto">
</xsl:template>

<xsl:template name="dictionary.titlepage.before.verso">
</xsl:template>

<xsl:template name="dictionary.titlepage">
  <div class="titlepage">
    <xsl:call-template name="dictionary.titlepage.before.recto"/>
    <xsl:call-template name="dictionary.titlepage.recto"/>
    <xsl:call-template name="dictionary.titlepage.before.verso"/>
    <xsl:call-template name="dictionary.titlepage.verso"/>
    <xsl:call-template name="dictionary.titlepage.separator"/>
  </div>
</xsl:template>

<xsl:template match="*" mode="dictionary.titlepage.recto.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="*" mode="dictionary.titlepage.verso.mode">
  <!-- if an element isn't found in this mode, -->
  <!-- try the generic titlepage.mode -->
  <xsl:apply-templates select="." mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="subtitle" mode="dictionary.titlepage.recto.auto.mode">
<div xsl:use-attribute-sets="dictionary.titlepage.recto.style">
<xsl:apply-templates select="." mode="dictionary.titlepage.recto.mode"/>
</div>
</xsl:template>


</xsl:stylesheet>
