<?xml version="1.0" encoding="utf-8"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml" version="1.0">

<xsl:template name="set.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes" select="d:book|d:setindex|d:set"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="division.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes" select="d:part|d:reference                                          |d:preface|d:chapter|d:appendix|d:article|d:bibliography|d:glossary|d:index|d:bridgehead[$bridgehead.in.toc != 0]"/>

  </xsl:call-template>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes" select="d:section|d:sect1
                    |d:simplesect[$simplesect.in.toc != 0]|d:refentry
                    |d:article|d:bibliography|d:glossary|d:appendix|d:index
                    |d:bridgehead[not(@renderas) and $bridgehead.in.toc != 0]
                    |.//d:bridgehead[@renderas='sect1' and $bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="section.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes" select="d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                                 |d:refentry|d:bridgehead[$bridgehead.in.toc != 0]"/>

  </xsl:call-template>
</xsl:template>

<xsl:template name="subtoc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>

  <xsl:variable name="nodes.plus" select="$nodes | d:qandaset"/>

  <xsl:variable name="subtoc">
    <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:choose>
        <xsl:when test="$qanda.in.toc != 0">
          <xsl:apply-templates mode="toc" select="$nodes.plus">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="toc" select="$nodes">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:variable>

  <xsl:variable name="subtoc.list">
    <xsl:choose>
      <xsl:when test="$toc.dd.type = ''">
        <xsl:copy-of select="$subtoc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$toc.dd.type}" namespace="http://www.w3.org/1999/xhtml">
          <xsl:copy-of select="$subtoc"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$toc.listitem.type}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="name(.)='book'">
       <xsl:number from="d:set" count="d:book" format="1. "/>
       <xsl:value-of select="' Kitap - '"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$label"/>
        <xsl:if test="$label != ''">
          <xsl:value-of select="$autotoc.label.separator"/>
       </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="(./*/d:titleprefix) and name($toc-context) != name(.)">
      <xsl:value-of select="./*/d:titleprefix"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <a>
     <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="context" select="$toc-context"/>
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
    </xsl:attribute>
      <xsl:apply-templates select="." mode="title.markup"/>
    </a>
  </xsl:element>

    <xsl:variable name="role" select="''"/>

    <xsl:apply-templates mode="subtoc.titleabbrev"/>

    <xsl:if test="(./*/d:abstract) and name($toc-context) != name(.)
                 and (name($toc-context) = 'book' or name($toc-context) = 'set' or name($toc-context) = 'part')">
     <xsl:if test="(./*/d:titleabbrev)">
       <xsl:text>  -  </xsl:text>
       <xsl:value-of select="./*/d:titleabbrev"/>
     </xsl:if>
    </xsl:if>

    <xsl:if test="(./*/d:abstract) and name($toc-context) != name(.)
                  and (name($toc-context) = 'book' or name($toc-context) = 'set' or name($toc-context) = 'part')">
     <dd>
      <div class="para">
       <xsl:apply-templates select="./*/d:abstract/d:para[1]" mode="subtoc.titleabbrev"/>
      </div>
     </dd>
    </xsl:if>

  <xsl:choose>
    <xsl:when test="$chunk.sections=0">
      <xsl:copy-of select="$subtoc.list"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$role='abstracts'">
          <xsl:if test="($nodes/*/d:abstract)">
            <xsl:copy-of select="$subtoc.list"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$role='tips'">
          <xsl:if test="($nodes/d:caution) or ($nodes/d:important) or
                        ($nodes/d:note) or ($nodes/d:tip) or ($nodes/d:warning)">
            <xsl:copy-of select="$subtoc.list"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="name($toc-context) = 'set' and
                        name($nodes) = 'book'">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
        <xsl:when test="name($toc-context) = 'book' and
                    (name($nodes)='part' or
                    name($nodes)='preface' or
                    name($nodes)='article' or
                    name($nodes)='chapter' or
                    name($nodes)='appendix' or
                    name($nodes)='reference')">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
        <xsl:when test="name($toc-context) != 'set' and
                        name($toc-context) != 'book' and
                        not (name($toc-context) = 'part' and
                        not ($toc-context[@userlevel='longtoc'])) and
                        (name($nodes) = 'sect1' or
                          name($nodes) = 'sect2' or
                          name($nodes) = 'sect3')">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:reference" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($reference.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::d:part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::d:part"
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::d:part"
                               mode="intralabel.punctuation">
            <xsl:with-param name="object" select="."/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$reference.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::d:part">
          <xsl:number from="d:part" count="d:reference" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="d:info/d:volumenum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
