<?xml version="1.0" encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: autodict.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->
<!-- Copyright ©  2004  Nilgün Belma Bugüner <nilgun@superonline.com> -->
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

<!ENTITY lowercase "'abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY allcases "'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY sortcases "'ABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZ'">

<!ENTITY english 'concat(english/@sortas, english[not(@sortas)])'>
<!ENTITY turkish 'concat(turkish/@sortas, turkish[not(@sortas)])'>

<!ENTITY sep '" "'>

<!ENTITY section.t  '(ancestor-or-self::set
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
                     |ancestor-or-self::index)[last()]'>


]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:key name="en-letter"
         match="dicterm"
         use="translate(substring(&english;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="tr-letter"
         match="dicterm"
         use="translate(substring(&turkish;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="english"
         match="dicterm"
         use="&english;"/>

<xsl:key name="turkish"
         match="dicterm"
         use="&turkish;"/>

<xsl:template name="generate-tr-dict">
  <xsl:variable name="others" select="key('turkish',&turkish;)[not(contains(&allcases;,
                                             substring(&turkish;, 1, 1)))]"/>
  <div class="dict">
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
  <xsl:variable name="others" select="key('english',&english;)[not(contains(&allcases;,
                                             substring(&english;, 1, 1)))]"/>
  <div class="dict">
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

<xsl:template name="alphabetical-dict-tr">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('tr-letter', $letter)) > 0">
      <div class="dictdiv">
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
          <xsl:apply-templates select="key('tr-letter', $letter)[count(.|key('turkish', &turkish;)[1]) = 1]"
                               mode="dict-tr">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:sort select="translate(&turkish;,&allcases;,&sortcases;)"/>
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

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('en-letter', $letter)) > 0">
      <div class="dictdiv">
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
          <xsl:apply-templates select="key('en-letter', $letter)[count(.|key('english', &english;)[1]) = 1]"
                               mode="dict-en">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:sort select="translate(&english;,&allcases;,&sortcases;)"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-dict">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="dicterm" mode="dict-tr">
  <xsl:param name="is.first" select="0"/>
  <xsl:variable name="key" select="&turkish;"/>
  <xsl:variable name="refs" select="key('turkish', $key)"/>
  <dt>
    <xsl:apply-templates mode="alphabetic-dict-tr"/>
    <xsl:for-each select="$refs">
      <xsl:if test="position()>1">
        <xsl:text>,   </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="." mode="dict-tr-english"/>
      <xsl:apply-templates select="." mode="dict-reference-b"/>
    </xsl:for-each>
  </dt>
</xsl:template>

<xsl:template match="dicterm" mode="dict-en">
  <xsl:param name="is.first" select="0"/>
  <xsl:variable name="key" select="&english;"/>
  <xsl:variable name="refs" select="key('english', $key)"/>
  <dt>
    <xsl:apply-templates mode="alphabetic-dict"/>

    <xsl:for-each select="$refs">
      <xsl:if test="position()>1">
        <xsl:text>,   </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="." mode="dict-en-turkish"/>
      <xsl:apply-templates select="." mode="dict-reference-b"/>
    </xsl:for-each>
  </dt>
</xsl:template>

<xsl:template match="*" mode="alphabetic-dict-tr"/>
<xsl:template match="*" mode="alphabetic-dict"/>

<xsl:template match="turkish" mode="alphabetic-dict-tr">
  <a name="{.}"/><span class="dict">
    <xsl:apply-templates/><xsl:text>:   </xsl:text>
  </span>
</xsl:template>

<xsl:template match="english" mode="alphabetic-dict">
  <a name="{.}"/><span class="dict">
    <xsl:apply-templates/><xsl:text>:   </xsl:text>
  </span>
</xsl:template>

<xsl:template match="dicterm" mode="dict-tr-english">
  <xsl:value-of select="english"/>
</xsl:template>

<xsl:template match="dicterm" mode="dict-en-turkish">
  <xsl:value-of select="turkish"/>
</xsl:template>

<xsl:template match="dicterm" mode="dict-reference-b">
  <xsl:text disable-output-escaping="yes">&lt;!-- </xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="&section.t;"/>
    </xsl:call-template>
  <xsl:text disable-output-escaping="yes"> --></xsl:text>
</xsl:template>
</xsl:stylesheet>
