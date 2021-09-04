<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: glossary.xsl,v 1.2 2003/05/12 20:59:01 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="glossary">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <div id="{$id}" class="{name(.)}">
    <xsl:call-template name="glossary.titlepage"/>

    <xsl:choose>
      <xsl:when test="glossdiv">
        <xsl:apply-templates select="(glossdiv[1]/preceding-sibling::*)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="(glossentry[1]/preceding-sibling::*)"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="glossdiv">
        <xsl:apply-templates select="glossdiv"/>
      </xsl:when>
      <xsl:when test="glosslist">
        <xsl:apply-templates select="glosslist"/>
      </xsl:when>
      <xsl:otherwise>
        <dl>
          <xsl:apply-templates select="glossentry"/>
        </dl>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="glossary/glossaryinfo"></xsl:template>
<xsl:template match="glossary/title"></xsl:template>
<xsl:template match="glossary/subtitle"></xsl:template>
<xsl:template match="glossary/titleabbrev"></xsl:template>

<xsl:template match="glossary/title" mode="component.title.mode">
  <div class="head2">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="glossary/subtitle" mode="component.title.mode">
  <div class="head3">
    <i><xsl:apply-templates/></i>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="glosslist">
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="glossdiv">
  <div class="{name(.)}">
    <xsl:apply-templates select="(glossentry[1]/preceding-sibling::*)"/>

    <dl>
      <xsl:apply-templates select="glossentry"/>
    </dl>
  </div>
</xsl:template>

<xsl:template match="glossdiv/title">
  <h3 class="{name(.)}">
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<!-- ==================================================================== -->

<!--
GlossEntry ::=
  GlossTerm, Acronym?, Abbrev?,
  (IndexTerm)*,
  RevHistory?,
  (GlossSee | GlossDef+)
-->

<xsl:template match="glossentry">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glossentry/glossterm">
  <dt><span class="glossterm">
    <xsl:if test="(@vendor)">
      <xsl:attribute name="title">
        <xsl:value-of select="@vendor"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="(@id)">
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="(../acronym)">
         <xsl:attribute name="title">
           <xsl:value-of select="."/>
         </xsl:attribute>
         <xsl:value-of select="../acronym"/>
      </xsl:when>
      <xsl:when test="(../abbrev)">
         <xsl:attribute name="title">
           <xsl:value-of select="."/>
         </xsl:attribute>
         <xsl:value-of select="../abbrev"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </span></dt>
</xsl:template>

<xsl:template match="glossentry/acronym"/>
<xsl:template match="glossentry/abbrev"/>

<xsl:template match="glossentry/revhistory">
</xsl:template>

<xsl:template match="glossentry/glosssee">
  <xsl:variable name="otherterm" select="@otherterm"/>
  <xsl:variable name="targets" select="//node()[@id=$otherterm]"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <dd>
    <div class="para">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'glossary'"/>
        <xsl:with-param name="name" select="'see'"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="@otherterm">
          <a href="#{@otherterm}">
            <xsl:apply-templates select="$target" mode="xref"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
    </div>
  </dd>
</xsl:template>

<xsl:template match="glossentry/glossdef">
  <dd class="halfpara">
    <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
    <xsl:if test="glossseealso">
      <div class="para">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'glossary'"/>
          <xsl:with-param name="name" select="'seealso'"/>
        </xsl:call-template>
        <xsl:apply-templates select="glossseealso"/>
      </div>
    </xsl:if>
  </dd>
</xsl:template>

<xsl:template match="glossseealso">
  <xsl:variable name="otherterm" select="@otherterm"/>
  <xsl:variable name="targets" select="//node()[@id=$otherterm]"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <xsl:when test="@otherterm">
      <a href="#{@otherterm}">
        <xsl:apply-templates select="$target" mode="xref"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="position() = last()">
      <xsl:text>.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>, </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="glossentry" mode="xref">
  <xsl:apply-templates select="./glossterm[1]" mode="xref"/>
</xsl:template>

<xsl:template match="glossterm" mode="xref">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- Glossary collection -->

<xsl:template match="glossary[@role='auto']" priority="2">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:variable name="terms" select="//glossterm[not(parent::glossdef)]|//firstterm"/>
  <xsl:variable name="collection" select="document($glossary.collection, .)"/>

  <xsl:if test="$glossary.collection = ''">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary </xsl:text>
      <xsl:text>without a glossary.collection file.</xsl:text>
    </xsl:message>
  </xsl:if>

  <div id="{$id}" class="{name(.)}">
    <xsl:call-template name="glossary.titlepage"/>

    <xsl:choose>
      <xsl:when test="glossdiv and $collection//glossdiv">
        <xsl:for-each select="$collection//glossdiv">
          <!-- first see if there are any in this div -->
          <xsl:variable name="exist.test">
            <xsl:for-each select="glossentry">
              <xsl:variable name="cterm" select="glossterm"/>
              <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
                <xsl:value-of select="glossterm"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>

          <xsl:if test="$exist.test != ''">
            <xsl:apply-templates select="." mode="auto-glossary">
              <xsl:with-param name="terms" select="$terms"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <dl>
          <xsl:for-each select="$collection//glossentry">
            <xsl:variable name="cterm" select="glossterm"/>
            <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
              <xsl:apply-templates select="." mode="auto-glossary"/>
            </xsl:if>
          </xsl:for-each>
        </dl>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="*" mode="auto-glossary">
  <!-- pop back out to the default mode for most elements -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="glossdiv" mode="auto-glossary">
  <xsl:param name="terms" select="."/>

  <div class="{name(.)}">
    <xsl:apply-templates select="(glossentry[1]/preceding-sibling::*)"/>

    <dl>
      <xsl:for-each select="glossentry">
        <xsl:variable name="cterm" select="glossterm"/>
        <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
          <xsl:apply-templates select="." mode="auto-glossary"/>
        </xsl:if>
      </xsl:for-each>
    </dl>
  </div>
</xsl:template>

<xsl:template match="glossentry" mode="auto-glossary">
  <xsl:apply-templates mode="auto-glossary"/>
</xsl:template>

<xsl:template match="glossentry/glossterm[1]" priority="2" mode="auto-glossary">
  <xsl:variable name="id">
    <xsl:text>gl.</xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <dt>
    <a name="{$id}"/>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
