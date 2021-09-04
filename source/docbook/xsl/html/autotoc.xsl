<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: autotoc.xsl,v 1.9 2003/07/19 09:25:07 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:variable name="toc.listitem.type">
  <xsl:choose>
    <xsl:when test="$toc.list.type = 'dl'">dt</xsl:when>
    <xsl:otherwise>li</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- this is just hack because dl and ul aren't completely isomorphic -->
<xsl:variable name="toc.dd.type">
  <xsl:choose>
    <xsl:when test="$toc.list.type = 'dl'">dd</xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template name="set.toc">
  <xsl:variable name="toc.title">
    <div class="formaltitle"><b>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">TableofContents</xsl:with-param>
        </xsl:call-template>
    </b></div>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$manual.toc != ''">
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>
      <xsl:variable name="toc" select="document($manual.toc, .)"/>
      <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
      <xsl:if test="$tocentry and $tocentry/*">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}">
            <xsl:call-template name="manual-toc">
              <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
            </xsl:call-template>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="nodes" select="book|setindex|dictionary"/>

      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="object" select="."/>
              <xsl:with-param name="owner" select="'set.toc'"/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="division.toc">
  <xsl:if test="$generate.division.toc != 0 and
                not ($chunk.sections=0 and name(.)!=name(/*[1]))">
    <xsl:variable name="toc.title">
      <div class="formaltitle"><b>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">TableofContents</xsl:with-param>
        </xsl:call-template>
      </b></div>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$manual.toc != ''">
        <xsl:variable name="id">
          <xsl:call-template name="object.id"/>
        </xsl:variable>
        <xsl:variable name="toc" select="document($manual.toc, .)"/>
        <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
        <xsl:if test="$tocentry and $tocentry/*">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:call-template name="manual-toc">
                <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
              </xsl:call-template>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:when test="name(.)='part' and (./article) and not (./chapter)">
        <xsl:variable name="nodes" select="article"/>
        <xsl:if test="$nodes">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:apply-templates select="$nodes" mode="toc">
                <xsl:with-param name="owner" select="'division.toc'"/>
                <xsl:with-param name="object" select="."/>
              </xsl:apply-templates>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="nodes" select="part|reference
                                           |preface|chapter|appendix
                                           |article
                                           |bibliography|glossary|index
                                           |bridgehead"/>
        <xsl:if test="$nodes">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:apply-templates select="$nodes" mode="toc">
                <xsl:with-param name="owner" select="'division.toc'"/>
                <xsl:with-param name="object" select="."/>
              </xsl:apply-templates>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:if test="$generate.component.toc != 0 and
                not ($chunk.sections=0 and name(.)!=name(/*[1]))
                or @role='autotoc'">
    <xsl:variable name="toc.title">
      <div class="formaltitle"><b>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">TableofContents</xsl:with-param>
        </xsl:call-template>
      </b></div>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$manual.toc != ''">
        <xsl:variable name="id">
          <xsl:call-template name="object.id"/>
        </xsl:variable>
        <xsl:variable name="toc" select="document($manual.toc, .)"/>
        <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
        <xsl:if test="$tocentry and $tocentry/*">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:call-template name="manual-toc">
                <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
              </xsl:call-template>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="nodes" select="simplesect|section|sect1|refentry
                                           |article|bibliography|glossary|index
                                           |appendix|bridgehead[not(@renderas)]
                                           |.//bridgehead[@renderas='sect1']"/>
        <xsl:if test="$nodes">
          <div class="toc">
            <xsl:copy-of select="$toc.title"/>
            <xsl:element name="{$toc.list.type}">
              <xsl:apply-templates select="$nodes" mode="toc">
                <xsl:with-param name="owner" select="'component.toc'"/>
                <xsl:with-param name="object" select="."/>
              </xsl:apply-templates>
            </xsl:element>
          </div>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="section.toc">
  <xsl:if test="not ($chunk.sections=0 and name(.)!=name(/*[1]))">
  <xsl:variable name="toc.title">
    <div class="formaltitle"><b>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">TableofContents</xsl:with-param>
      </xsl:call-template>
    </b></div>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$manual.toc != ''">
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>
      <xsl:variable name="toc" select="document($manual.toc, .)"/>
      <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
      <xsl:if test="$tocentry and $tocentry/*">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}">
            <xsl:call-template name="manual-toc">
              <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
            </xsl:call-template>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="nodes"
                    select="simplesect|section|sect1|sect2|sect3|sect4|sect5|refentry
                            |bridgehead"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="owner" select="'section.toc'"/>
              <xsl:with-param name="object" select="."/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="subtoc">
  <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>

  <xsl:variable name="subtoc">
    <xsl:element name="{$toc.list.type}">
      <xsl:apply-templates mode="toc" select="$nodes">
        <xsl:with-param name="owner" select="$owner"/>
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="role" select="$role"/>
      </xsl:apply-templates>
    </xsl:element>
      <!--xsl:message><xsl:value-of select="name(.)"/></xsl:message-->
  </xsl:variable>

  <xsl:variable name="subtoc.list">
    <xsl:choose>
      <xsl:when test="$toc.dd.type = ''">
        <xsl:copy-of select="$subtoc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$toc.dd.type}">
          <xsl:copy-of select="$subtoc"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$toc.listitem.type}">
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="name(.)='book'">
        <xsl:value-of select="$label"/><xsl:text>. Kitap - </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$label"/>
        <xsl:if test="$label != ''">
          <xsl:value-of select="$autotoc.label.separator"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="(./*/titleprefix) and name($object) != name(.)">
      <xsl:value-of select="./*/titleprefix"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="owner" select="$owner"/>
          <xsl:with-param name="ownerobject" select="$object"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="title.markup"/>
      <!--xsl:message>
        <xsl:value-of select="$object/@id"/>;this <xsl:value-of select="@id"/>;target
      </xsl:message-->
    </a>
    <xsl:if test="$role != 'abstracts' and $role != 'tips'">
      <xsl:apply-templates mode="subtoc.titleabbrev"/>
      <xsl:if test="(./*/abstract) and name($object) != name(.)
                    and (name($object) = 'book' or name($object) = 'set' or name($object) = 'part')">
        <xsl:if test="(./*/titleabbrev)">
          <xsl:text>  -  </xsl:text>
          <xsl:value-of select="./*/titleabbrev"/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:element>

  <xsl:choose>
    <xsl:when test="$role = 'abstracts'">
      <xsl:if test="(./*/abstract)">
        <dd>
          <xsl:apply-templates select="./*/abstract" mode="subtoc.abstracts"/>
        </dd>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$role = 'tips'">
      <xsl:if test="(./caution) or (./important) or
                    (./note) or (./tip) or (./warning)">
        <dd>
          <xsl:apply-templates select="./caution|./important|./note|./tip|./warning"/>
        </dd>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="(./*/abstract) and name($object) != name(.)
                    and (name($object) = 'book' or name($object) = 'set' or name($object) = 'part')">
        <dd><div class="para">
          <xsl:apply-templates select="./*/abstract/para[1]" mode="subtoc.titleabbrev"/>
        </div></dd>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$chunk.sections=0">
      <xsl:copy-of select="$subtoc.list"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$role='abstracts'">
          <xsl:if test="($nodes/*/abstract)">
            <xsl:copy-of select="$subtoc.list"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$role='tips'">
          <xsl:if test="($nodes/caution) or ($nodes/important) or
                        ($nodes/note) or ($nodes/tip) or ($nodes/warning)">
            <xsl:copy-of select="$subtoc.list"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="name($object) = 'set' and
                        name($nodes) = 'book'">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
        <xsl:when test="name($object) = 'book' and
                    (name($nodes)='part' or
                    name($nodes)='preface' or
                    name($nodes)='article' or
                    name($nodes)='chapter' or
                    name($nodes)='appendix' or
                    name($nodes)='reference')">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
        <xsl:when test="name($object) != 'set' and
                        name($object) != 'book' and
                        not (name($object) = 'part' and not ($object[@userlevel='longtoc'])) and
                        (name($nodes) = 'sect1' or
                          name($nodes) = 'sect2' or
                          name($nodes) = 'sect3')">
          <xsl:copy-of select="$subtoc.list"/>
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="book|setindex" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="nodes" select="part|reference
                                          |preface|chapter|appendix
                                          |article
                                          |bibliography|glossary|index
                                          |bridgehead"/>
    </xsl:call-template>
 </xsl:template>

<xsl:template match="part|reference" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="appendix|chapter|article
                                         |index|glossary|bibliography
                                         |preface|reference|refentry
                                         |bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="appendix|index|section|sect1|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:if test="not (@status) or @status != 'outtoc'">
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="nodes" select="section|sect1|bridgehead"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="sect1" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect2|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect2" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect3|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect3" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect4|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect4" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect5|bridgehead"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect5|simplesect" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:variable name="toodeep">
    <xsl:choose>
      <!-- if the depth is less than 2, we're already deep enough -->
      <xsl:when test="$toc.section.depth &lt; 2">yes</xsl:when>
      <!-- if the current section has n-1 section ancestors -->
      <!-- then we've already reached depth n -->
      <xsl:when test="ancestor::section[position()=$toc.section.depth - 1]">
        <xsl:text>yes</xsl:text>
      </xsl:when>
      <!-- otherwise, keep going -->
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$toodeep = 'no'">
      <xsl:call-template name="subtoc">
        <xsl:with-param name="owner" select="$owner"/>
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="nodes" select="section|bridgehead"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="subtoc">
        <xsl:with-param name="owner" select="$owner"/>
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="nodes" select="section|bridgehead"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="bridgehead" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:if test="$bridgehead.in.toc != 0">
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="bibliography|glossary" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="index|dictionary" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <!-- If the index tag is empty, don't point at it from the TOC -->
  <xsl:if test="not (@status) or @status != 'outtoc'">
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="refentry" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="role" select="''"/>
  <xsl:variable name="refmeta" select=".//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>

  <xsl:apply-templates select="refnamediv/refname" mode="belgeler">
    <xsl:with-param name="owner" select="$owner"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refnamediv/refname" mode="belgeler">
  <xsl:param name="owner" select="''"/>

  <xsl:variable name="pos" select="position()"/>

  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="title"/>
  </xsl:variable>

  <xsl:element name="{$toc.listitem.type}">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="../.."/>
          <xsl:with-param name="owner" select="$owner"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:copy-of select="$title"/>
    </a>
    <xsl:if test="$annotate.toc != 0">
      <xsl:text> - </xsl:text>
      <xsl:value-of select="../refpurpose[position() = $pos]"/>
    </xsl:if>
  </xsl:element>
</xsl:template>

<xsl:template match="title" mode="toc">
  <xsl:param name="owner" select="''"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select=".."/>
        <xsl:with-param name="owner" select="$owner"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template name="manual-toc">
  <xsl:param name="tocentry"/>

  <!-- be careful, we don't want to change the current document to the other tree! -->

  <xsl:if test="$tocentry">
    <xsl:variable name="node" select="key('id', $tocentry/@linkend)"/>

    <xsl:element name="{$toc.listitem.type}">
      <xsl:variable name="label">
        <xsl:apply-templates select="$node" mode="label.markup"/>
      </xsl:variable>
      <xsl:copy-of select="$label"/>
      <xsl:if test="$label != ''">
        <xsl:value-of select="$autotoc.label.separator"/>
      </xsl:if>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="target.href">
            <xsl:with-param name="object" select="$node"/>
            <xsl:with-param name="owner" select="manual.toc"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$node" mode="title.markup"/>
      </a>
    </xsl:element>

    <xsl:if test="$tocentry/*">
      <xsl:element name="{$toc.list.type}">
        <xsl:call-template name="manual-toc">
          <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>

    <xsl:if test="$tocentry/following-sibling::*">
      <xsl:call-template name="manual-toc">
        <xsl:with-param name="tocentry" select="$tocentry/following-sibling::*[1]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

