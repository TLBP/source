<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- ********************************************************************
     $Id: content-tree.xsl,v 1.4 2003/07/19 09:25:04 nilgun Exp $
     ********************************************************************-->

<!-- Copyright ©  2002  Nilgün Belma Bugüner <nilgun@superonline.com> -->
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

<xsl:output method="html"
            encoding="utf-8"
            indent="no"/>
<xsl:include href="../common/common.xsl"/>
<xsl:include href="../common/titles.xsl"/>
<xsl:include href="../html/chunk-common.xsl"/>
<xsl:include href="../lib/lib.xsl"/>
<xsl:include href="../html/pi.xsl"/>
<xsl:variable name="chunk.section.depth" select="5"/>
<xsl:variable name="chunk.first.sections" select="1"/>
<xsl:variable name="use.id.as.filename" select="1"/>
<xsl:variable name="html.ext" select="html"/>
<xsl:variable name="nochunk.article.children" select="0"/>

<!-- Betiğin başlangıcı -->
<xsl:template name="href-target">
  <xsl:param name="object" select="."/>

  <xsl:choose>
    <xsl:when test="name($object)='book' or
                  name($object)='part' or
                  name($object)='chapter' or
                  name($object)='article' or
                  name($object)='appendix' or
                  name($object)='bibliography' or
                  name($object)='colophon' or
                  name($object)='glossary' or
                  name($object)='index' or
                  name($object)='preface' or
                  name($object)='refentry' or
                  name($object)='reference' or
                  name($object)='setindex' or
                  name($object)='sect1' or
                  (name($object)='sect2' and (@chunkthis))or
                  name($object)='section'">
      <xsl:value-of select="$object/@id"/>
      <xsl:text>.html</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pageurl">
       <xsl:choose>
        <xsl:when test="($object/ancestor::section)">
          <xsl:value-of select="$object/ancestor::section/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::sect1)">
          <xsl:value-of select="$object/ancestor::sect1/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::setindex)">
          <xsl:value-of select="$object/ancestor::setindex/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::refentry)">
          <xsl:value-of select="$object/ancestor::refentry/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::appendix)">
          <xsl:value-of select="$object/ancestor::appendix/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::preface)">
          <xsl:value-of select="$object/ancestor::preface/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::index)">
          <xsl:value-of select="$object/ancestor::index/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::bibliography)">
          <xsl:value-of select="$object/ancestor::bibliography/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::colophon)">
          <xsl:value-of select="$object/ancestor::colophon/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::glossary)">
          <xsl:value-of select="$object/ancestor::glossary/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::article)">
          <xsl:value-of select="$object/ancestor::article/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::chapter)">
          <xsl:value-of select="$object/ancestor::chapter/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::part)">
          <xsl:value-of select="$object/ancestor::part/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::reference)">
          <xsl:value-of select="$object/ancestor::reference/@id"/>
        </xsl:when>
        <xsl:when test="($object/ancestor::book)">
          <xsl:value-of select="$object/ancestor::book/@id"/>
        </xsl:when>
       </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$pageurl"/>
      <xsl:text>.html#</xsl:text>
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="set">
  <html><head>
  <!--meta http-equiv="expires" content="now"/-->
  <meta name="Author" content="Nilgün Belma Bugüner"/>
  <title>Linux Kitaplığı</title>
  <link rel="stylesheet" href="ctree.css" type="text/css"/>
  <script type="text/javascript" src="ctree.js"/>
  </head><body>
  <table cool="" width="1001" showgridx="" showgridy="" gridx="16" gridy="16" border="0" cellpadding="0" cellspacing="0">
    <tr><td width="1000">
      <ul>
        <li class="first" id="container">
          <img id="tochead" src="../images/plus.png" onclick='fnFlash(this)'/>
          <div class="tocText" onclick="toggleH(this); viewPage('../KiTAPLIK/index.html');" title="Linux Kitaplığı">Linux Kitaplığı</div>
          <xsl:variable name="nodes" select="book|setindex"/>
          <xsl:if test="$nodes">
            <ul class="tocItemHide">
              <xsl:apply-templates select="$nodes" mode="toc"/>
            </ul>
          </xsl:if>
        </li>
      </ul>
      </td><td width="1"><spacer type="block" width="1"/></td>
    </tr>
    <tr height="1" cntrlrow="">
      <td width="1000" height="1"><spacer type="block" width="1000" height="1"/></td>
      <td width="1" height="1"><spacer type="block" width="1" height="1"/></td>
    </tr>
  </table></body></html>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="subtoc">
  <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>

  <xsl:variable name="subtoc">
    <ul class="tocItemHide">
      <xsl:apply-templates select="$nodes" mode="toc"/>
    </ul>
  </xsl:variable>

  <xsl:variable name="subtoc.list">
    <xsl:copy-of select="$subtoc"/>
  </xsl:variable>

  <xsl:variable name="pageurl">
    <xsl:call-template name="href-target"/>
  </xsl:variable>

  <xsl:variable name="subtree.exist">
    <xsl:choose>
      <xsl:when test="count(descendant::book)>0 or
                     count(descendant::part)>0 or
                     count(descendant::chapter)>0 or
                     count(descendant::article)>0 or
                     count(descendant::appendix)>0 or
                     count(descendant::bibliography)>0 or
                     count(descendant::colophon)>0 or
                     count(descendant::glossary)>0 or
                     count(descendant::index)>0 or
                     count(descendant::preface)>0 or
                     count(descendant::refentry)>0 or
                     count(descendant::reference)>0 or
                     count(descendant::setindex)>0 or
                     count(descendant::sect1)>0 or
                     count(descendant::section)>0 or
                     count(descendant::sect2)>0 or
                     count(descendant::sect3)>0 or
                     count(descendant::sect4)>0 or
                     count(descendant::sect5)>0 or
                     count(descendant::simplesect)>0">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  <li>
    <img id="tochead" onclick="fnFlash(this)">
      <xsl:attribute name="src">
       <xsl:choose>
         <xsl:when test="$subtree.exist>0">
           <xsl:text>../images/plus.png</xsl:text>
         </xsl:when>
         <xsl:otherwise>
           <xsl:text>../images/null.png</xsl:text>
         </xsl:otherwise>
       </xsl:choose>
      </xsl:attribute>
    </img>
    <xsl:variable name="dir">
      <xsl:call-template name="dbhtml-dir"/>
    </xsl:variable>
    <div class="tocText">
      <xsl:attribute name="onclick">
        <xsl:text>toggleH(this); viewPage('</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$pageurl"/>
        <xsl:text>');</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="." mode="title.markup"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="title.markup"/>
      <!--
      <xsl:text> - </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$pageurl"/>
      -->
    </div>

    <xsl:if test="count($nodes)&gt;0">
      <xsl:copy-of select="$subtoc.list"/>
    </xsl:if>

  </li>

</xsl:template>

<xsl:template match="book|setindex" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="part|reference
                                         |preface|chapter|appendix
                                         |article
                                         |bibliography|glossary|index
                                         |refentry
                                         |bridgehead|sect1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="part|reference" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="appendix|chapter|article
                                         |index|glossary|bibliography
                                         |preface|reference|refentry
                                         |bridgehead|sect1|section"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="appendix|section|sect1|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="simplesect|section|sect1|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect1" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="sect2|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect2" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="sect3|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect3" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="sect4|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect4" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="sect5|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bibliography|glossary|sect5|simplesect" mode="toc">
  <xsl:call-template name="subtoc"/>
</xsl:template>

<xsl:template match="section" mode="toc">
  <xsl:call-template name="subtoc">
    <xsl:with-param name="nodes" select="bridgehead|simplesect"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bridgehead" mode="toc">
  <xsl:call-template name="subtoc"/>
</xsl:template>

<xsl:template match="index" mode="toc">
  <!-- If the index tag is empty, don't point at it from the TOC -->
  <xsl:if test="* or $generate.index">
    <xsl:call-template name="subtoc"/>
  </xsl:if>
</xsl:template>

<xsl:template match="refentry" mode="toc">
  <xsl:apply-templates select="refnamediv/refname" mode="belgeler"/>
</xsl:template>

<xsl:template match="refnamediv/refname" mode="belgeler">
  <xsl:variable name="pos" select="position()"/>

  <xsl:variable name="dir">
    <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="ancestor-or-self::reference/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pageurl">
    <xsl:call-template name="href-target">
      <xsl:with-param name="object" select="../.."/>
    </xsl:call-template>
  </xsl:variable>

  <li>
    <img id="tochead" onclick="fnFlash(this)">
      <xsl:attribute name="src">
        <xsl:text>../images/null.png</xsl:text>
      </xsl:attribute>
    </img>
    <div class="tocText">
      <xsl:attribute name="onclick">
        <xsl:text>toggleH(this); viewPage('</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$pageurl"/>
        <xsl:text>');</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="../refpurpose[position() = $pos]"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="title."/>
<!--
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$dir"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$pageurl"/>
-->
    </div>
  </li>
</xsl:template>

<xsl:template match="title" mode="toc">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href-target">
        <xsl:with-param name="object" select=".."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>


<xsl:template match="book"/>

</xsl:stylesheet>

