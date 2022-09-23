<?xml version="1.0" encoding="utf-8"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.
Bu dosyanın içeriğini bu dosyanın dışında çalıştıramıyorum.
Bu nedenle dosyayı yerinde hack etmekten başka çare kalmadı -->
<xsl:stylesheet exclude-result-prefixes="d"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook"
xmlns="http://www.w3.org/1999/xhtml" version="1.0">

<!-- ********************************************************************
     $Id: refentry.xsl 9962 2015-04-30 17:35:04Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<xsl:template match="d:reference">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="reference.titlepage"/>

    <xsl:variable name="toc.params">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="make.lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
       <xsl:variable name="nodes.plus" select="d:refenry"/>

       <div class="toc">
         <div class="toc-title">İçindekiler</div>
         <div class="letters">
             <xsl:call-template name="refentry.toc.letters">
               <xsl:with-param name="volnum" select="d:info/d:volumenum"/>
               <xsl:with-param name="letternum" select="0"/>
             </xsl:call-template>
           </div>
           <xsl:call-template name="refentry.toc">
             <xsl:with-param name="volnum" select="d:info/d:volumenum"/>
             <xsl:with-param name="letternum" select="0"/>
           </xsl:call-template>
       </div>
       </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:reference" mode="division.number">
  <xsl:value-of select="concat(d:info/d:volumenum, ' ')"/>
</xsl:template>

<xsl:template match="d:reference/d:docinfo"/>
<xsl:template match="d:reference/d:referenceinfo"/>
<xsl:template match="d:reference/d:title"/>
<xsl:template match="d:reference/d:subtitle"/>
<xsl:template match="d:reference/d:titleabbrev"/>

<!-- ==================================================================== -->

<xsl:template name="refentry.title">
  <xsl:param name="node" select="."/>
  <xsl:variable name="refmeta" select="$node//d:refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//d:refentrytitle"/>
  <xsl:variable name="refnamediv" select="$node//d:refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//d:refname"/>
  <xsl:variable name="refdesc" select="$refnamediv//d:refdescriptor"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="title"/>
      </xsl:when>
      <xsl:when test="$refdesc">
	<xsl:apply-templates select="$refdesc[1]" mode="title"/>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="title"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>

  <h1 class="title">
    <xsl:copy-of select="$title"/>
  </h1>
</xsl:template>

<xsl:template match="d:refentry">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:if test="$refentry.separator != 0 and preceding-sibling::d:refentry">
      <div class="refentry.separator">
        <hr/>
      </div>
    </xsl:if>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="refentry.header"/>
    <xsl:call-template name="refentry.titlepage"/>
    <xsl:apply-templates/>
    <xsl:apply-templates select="d:refmeta" mode="refentry.footer"/>
    <xsl:call-template name="process.footnotes"/>
    <xsl:call-template name="refentry.footer"/>
   </div>
</xsl:template>

<xsl:template match="d:refentry/d:docinfo|d:refentry/d:refentryinfo"/>
<xsl:template match="d:refentry/d:info|d:refmeta"/>

<xsl:template match="d:refentrytitle|d:refname|d:refdescriptor" mode="title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refmeta" mode="refentry.footer">
 <xsl:apply-templates  mode="refentry.footer"/>
</xsl:template>

<xsl:template match="d:refmiscinfo"/>
<xsl:template match="d:legalnotice|d:legalnotice/d:title"/>
<xsl:template match="d:legalnotice/d:screen"  mode="refentry.footer">
 <pre><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="d:legalnotice" mode="refentry.footer">
  <div class="refnotice">
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="title.markup"/>
    </xsl:variable>

    <div class="legalnotice-title">
      <xsl:copy-of select="$title"/>
    </div>
    <div class="reflegal">
     <xsl:apply-templates  mode="refentry.footer"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="*" mode="refentry.footer"/>

<xsl:template match="d:sectdesc|d:source|d:refmiscinfo/d:date"/>
<xsl:template match="d:manvolnum"/>
<xsl:template match="d:refentrytitle"/>

<xsl:template match="d:refnamediv">
  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>

    <xsl:choose>
      <xsl:when test="preceding-sibling::d:refnamediv">
	<!-- no title on secondary refnamedivs! -->
      </xsl:when>
      <xsl:when test="$refentry.generate.name != 0">
        <h2>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'RefName'"/>
          </xsl:call-template>
        </h2>
      </xsl:when>
      <xsl:when test="$refentry.generate.title != 0">
        <h2>
          <xsl:choose>
            <xsl:when test="../d:refmeta/d:refentrytitle">
              <xsl:apply-templates select="../d:refmeta/d:refentrytitle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="d:refname[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </h2>
      </xsl:when>
    </xsl:choose>

    <p>
      <xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="d:refname">
  <xsl:if test="not(preceding-sibling::d:refdescriptor)">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::d:refname">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refpurpose">
  <xsl:if test="node()">
    <xsl:text> </xsl:text>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">em-dash</xsl:with-param>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>

<!-- This handles repurpose in TOC line to turn off any nested links -->
<xsl:template match="d:refpurpose" mode="no.anchor.mode">
  <xsl:if test="node()">
    <xsl:text> </xsl:text>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">em-dash</xsl:with-param>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="no.anchor.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refdescriptor">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refclass">
  <xsl:if test="$refclass.suppress = 0">
  <strong xmlns:xslo="http://www.w3.org/1999/XSL/Transform">
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </strong>
  </xsl:if>
</xsl:template>

<xsl:template match="d:refsynopsisdiv">
  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <h2>
      <xsl:choose>
        <xsl:when test="d:refsynopsisdiv/d:title|d:title">
          <xsl:apply-templates select="(d:refsynopsisdiv/d:title|d:title)[1]" mode="titlepage.mode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:refsynopsisdivinfo"/>

<xsl:template match="d:refsynopsisdiv/d:title">
</xsl:template>

<xsl:template match="d:refsynopsisdiv/d:title" mode="titlepage.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsection|d:refsect1|d:refsect2|d:refsect3">
  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <!-- pick up info title -->
    <xsl:apply-templates select="(d:title|d:info/d:title)[1]"/>
    <xsl:apply-templates select="node()[not(self::d:title) and not(self::d:info)]"/>
  </div>
</xsl:template>

<xsl:template match="d:refsection/d:title|d:refsection/d:info/d:title">
  <!-- the ID is output in the block.object call for refsect1 -->
  <xsl:variable name="level" select="count(ancestor-or-self::d:refsection)"/>
  <xsl:variable name="refsynopsisdiv">
    <xsl:text>0</xsl:text>
    <xsl:if test="ancestor::d:refsynopsisdiv">1</xsl:if>
  </xsl:variable>
  <xsl:variable name="hlevel">
    <xsl:choose>
      <xsl:when test="$level+$refsynopsisdiv &gt; 5">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$level+1+$refsynopsisdiv"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="d:refsect1/d:title|d:refsect1/d:info/d:title">
  <!-- the ID is output in the block.object call for refsect1 -->
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="d:refsect2/d:title|d:refsect2/d:info/d:title">
  <!-- the ID is output in the block.object call for refsect2 -->
  <h3>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="d:refsect3/d:title|d:refsect3/d:info/d:title">
  <!-- the ID is output in the block.object call for refsect3 -->
  <h4>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="d:refsectioninfo|d:refsection/d:info"/>
<xsl:template match="d:refsect1info|d:refsect1/d:info"/>
<xsl:template match="d:refsect2info|d:refsect2/d:info"/>
<xsl:template match="d:refsect3info|d:refsect3/d:info"/>


<!-- ==================================================================== -->

</xsl:stylesheet>
