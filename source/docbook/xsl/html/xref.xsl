<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<!-- ********************************************************************
     $Id: xref.xsl,v 1.6 2003/07/19 09:25:07 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="anchor">
  <xsl:call-template name="anchor"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xref" name="xref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="refelem" select="local-name($target)"/>

  <xsl:call-template name="anchor"/>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:call-template name="olink">
        <xsl:with-param name="localinfo" select="@linkend"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="xref.xreflabel">
          <xsl:with-param name="target" select="$target"/>
        </xsl:call-template>
      </a>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="check.id.unique">
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>

      <xsl:variable name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$target"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="@endterm">
          <xsl:variable name="etargets" select="key('id',@endterm)"/>
          <xsl:variable name="etarget" select="$etargets[1]"/>
          <xsl:choose>
            <xsl:when test="count($etarget) = 0">
              <xsl:message>
                <xsl:value-of select="count($etargets)"/>
                <xsl:text>Endterm points to nonexistent ID: </xsl:text>
                <xsl:value-of select="@endterm"/>
              </xsl:message>
              <a href="{$href}">
                <xsl:text>???</xsl:text>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$href}">
                <xsl:apply-templates select="$etarget" mode="endterm"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <xsl:apply-templates select="$target" mode="xref-to-prefix"/>
          <xsl:variable name="titletext">
            <xsl:apply-templates select="$target" mode="xref-to"/>
          </xsl:variable>

          <a href="{$href}" class="xref">
            <xsl:attribute name="title">
              <xsl:apply-templates select="$target" mode="xref-title"/>
            </xsl:attribute>
            <xsl:value-of select="normalize-space($titletext)"/>
          </a>
          <xsl:apply-templates select="$target" mode="xref-to-suffix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="endterm">
  <!-- Process the children of the endterm element -->
  <xsl:apply-templates select="child::node()"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="xref-to-prefix"/>
<xsl:template match="*" mode="xref-to-suffix"/>

<xsl:template match="*" mode="xref-to">
  <xsl:param name="target" select="."/>
  <xsl:param name="refelem" select="local-name($target)"/>

  <xsl:message>
    <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
    <xsl:value-of select="$refelem"/>
    <xsl:text>", ("</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>")</xsl:text>
  </xsl:message>
  <xsl:text>???</xsl:text>
</xsl:template>

<xsl:template match="author" mode="xref-to">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="authorgroup" mode="xref-to">
  <xsl:call-template name="person.name.list"/>
</xsl:template>

<xsl:template match="figure" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="example" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="table" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="equation" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="procedure" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="cmdsynopsis" mode="xref-to">
  <xsl:apply-templates select="(.//command)[1]" mode="xref"/>
</xsl:template>

<xsl:template match="funcsynopsis" mode="xref-to">
  <xsl:apply-templates select="(.//function)[1]" mode="xref"/>
</xsl:template>

<xsl:template match="dedication" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="preface" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="chapter" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="article" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>


<xsl:template match="appendix" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="bibliography" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="xref-to-prefix">
  <xsl:text>[</xsl:text>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="xref-to-suffix">
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="xref-to">
  <!-- handles both biblioentry and bibliomixed -->
  <xsl:choose>
    <xsl:when test="string(.) = ''">
      <xsl:variable name="bib" select="document($bibliography.collection)"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="entry" select="$bib/bibliography/*[@id=$id][1]"/>
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:choose>
            <xsl:when test="local-name($entry/*[1]) = 'abbrev'">
              <xsl:apply-templates select="$entry/*[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No bibliography entry: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> found in </xsl:text>
            <xsl:value-of select="$bibliography.collection"/>
          </xsl:message>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="local-name(*[1]) = 'abbrev'">
          <xsl:apply-templates select="*[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossary" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="index" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="listitem" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="section|simplesect
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="bridgehead" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="qandaset" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="qandadiv" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="qandaentry" mode="xref-to">
  <xsl:apply-templates select="question[1]" mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="question" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="answer" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="part" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="reference" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="refentry" mode="xref-to">
  <xsl:choose>
    <xsl:when test="refmeta/refentrytitle">
      <xsl:apply-templates select="refmeta/refentrytitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="refnamediv/refname[1]"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="refmeta/manvolnum"/>
</xsl:template>

<xsl:template match="step" mode="xref-to">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="number"/>
</xsl:template>

<xsl:template match="glossentry" mode="xref-to">
  <xsl:apply-templates select="glossterm[1]" mode="xref-to"/>
</xsl:template>

<xsl:template match="glossentry/glossterm|bridgehead" mode="xref-to">
  <!-- to avoid the comma that will be generated if there are several terms -->
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="varlistentry" mode="xref-to">
  <xsl:apply-templates select="term[1]" mode="xref-to"/>
</xsl:template>

<xsl:template match="varlistentry/term" mode="xref-to">
  <!-- to avoid the comma that will be generated if there are several terms -->
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="co" mode="xref-to">
  <xsl:apply-templates select="." mode="callout-bug"/>
</xsl:template>

<xsl:template match="book" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="xref-title">
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="author" mode="xref-title">
  <xsl:variable name="title">
    <xsl:call-template name="person.name"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="authorgroup" mode="xref-title">
  <xsl:variable name="title">
    <xsl:call-template name="person.name.list"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="cmdsynopsis" mode="xref-title">
  <xsl:variable name="title">
    <xsl:apply-templates select="(.//command)[1]" mode="xref"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="funcsynopsis" mode="xref-title">
  <xsl:variable name="title">
    <xsl:apply-templates select="(.//function)[1]" mode="xref"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="xref-title">
  <!-- handles both biblioentry and bibliomixed -->
  <xsl:variable name="title">
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test="local-name(*[1]) = 'abbrev'">
        <xsl:apply-templates select="*[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]</xsl:text>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<xsl:template match="step" mode="xref-title">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="number"/>
</xsl:template>

<xsl:template match="glossentry" mode="xref-title">
  <xsl:apply-templates select="glossterm[1]" mode="xref-title"/>
</xsl:template>

<xsl:template match="term|glossterm|bridgehead" mode="xref-title">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="question" mode="xref-title">
  <xsl:apply-templates select="para[1]"/>
</xsl:template>

<xsl:template match="co" mode="xref-title">
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="callout-bug"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="link" name="link">
  <xsl:param name="a.target"/>
  <xsl:param name="linkend" select="@linkend"/>

  <xsl:variable name="targets" select="key('id',$linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <xsl:when test="count($targets)=1">
      <xsl:call-template name="check.id.unique">
        <xsl:with-param name="linkend" select="$linkend"/>
      </xsl:call-template>
      <a class="link">
        <xsl:if test="@id">
          <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        </xsl:if>

        <xsl:if test="$a.target">
          <xsl:attribute name="target"><xsl:value-of select="$a.target"/></xsl:attribute>
        </xsl:if>

        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>

        <!-- FIXME: is there a better way to tell what elements have a title? -->
        <xsl:if test="local-name($target) = 'book'
                      or local-name($target) = 'set'
                      or local-name($target) = 'chapter'
                      or local-name($target) = 'preface'
                      or local-name($target) = 'appendix'
                      or local-name($target) = 'article'
                      or local-name($target) = 'bibliography'
                      or local-name($target) = 'glossary'
                      or local-name($target) = 'index'
                      or local-name($target) = 'part'
                      or local-name($target) = 'refentry'
                      or local-name($target) = 'reference'
                      or local-name($target) = 'example'
                      or local-name($target) = 'equation'
                      or local-name($target) = 'table'
                      or local-name($target) = 'figure'
                      or local-name($target) = 'simplesect'
                      or starts-with(local-name($target),'sect')
                      or starts-with(local-name($target),'refsect')">
          <xsl:attribute name="title">
            <xsl:apply-templates select="$target"
                                mode="object.title.markup.textonly"/>
          </xsl:attribute>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="count(child::node()) &gt; 0">
            <!-- If it has content, use it -->
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <!-- else look for an endterm -->
            <xsl:choose>
              <xsl:when test="@endterm">
                <xsl:variable name="etargets" select="key('id',@endterm)"/>
                <xsl:variable name="etarget" select="$etargets[1]"/>
                <xsl:choose>
                  <xsl:when test="count($etarget) = 0">
                    <xsl:message>
                      <xsl:value-of select="count($etargets)"/>
                      <xsl:text>Endterm points to nonexistent ID: </xsl:text>
                      <xsl:value-of select="@endterm"/>
                    </xsl:message>
                    <xsl:text>???</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:apply-templates select="$etarget" mode="endterm"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <xsl:otherwise>
                <xsl:message>
                  <xsl:text>Link element has no content and no Endterm. </xsl:text>
                  <xsl:text>Nothing to show in the link to </xsl:text>
                  <xsl:value-of select="$target"/>
                </xsl:message>
                <xsl:text>???</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="(ancestor::refentry)">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="olink">
            <xsl:with-param name="localinfo" select="$linkend"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ulink" name="ulink">
  <a class="ulink">
    <xsl:if test="@id">
      <xsl:attribute name="name">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:variable name="p">
      <xsl:value-of select="@url"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="contains($p,'mailto:')">
        <xsl:variable name="addr">
          <xsl:call-template name="nospam">
            <xsl:with-param name="p" select="substring-after($p,'mailto:')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="href">mailto:<xsl:value-of select="$addr"/></xsl:attribute>
        <xsl:choose>
          <xsl:when test="count(child::node())=0">
            <xsl:value-of select="$addr"/>
          </xsl:when>
          <xsl:when test="contains(text(),'@')">
            <xsl:value-of select="$addr"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
        <xsl:if test="$ulink.target != ''">
          <xsl:attribute name="target">
            <xsl:value-of select="$ulink.target"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="count(child::node())=0">
            <xsl:value-of select="@url"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="olink" name="olink">
  <xsl:param name="localinfo" select="@localinfo"/>

  <xsl:variable name="belgeler.file" select="unparsed-entity-uri('belgeler')"/>
  <xsl:variable name="tefrika.file" select="unparsed-entity-uri('tefrika')"/>

  <xsl:choose><xsl:when test="$belgeler.file != ''">
    <xsl:if test="$localinfo != ''">
      <xsl:call-template name="anchor"/>
      <xsl:variable name="belgeler-file"
                  select="concat('../../../../../', $belgeler.file)"/>
      <xsl:variable name="tefrika-file"
                  select="concat('../../../../../', $tefrika.file)"/>
      <xsl:variable name="node" select="//*[@id=$localinfo]"/>

      <xsl:choose>
        <xsl:when test="/*[1]/setinfo/title='Linux Kitaplığı'">
          <xsl:call-template name="olink.target">
            <xsl:with-param name="node" select="document($tefrika-file)//*[@id=$localinfo]"/>
            <xsl:with-param name="localinfo" select="$localinfo"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="olink.target">
            <xsl:with-param name="node" select="document($belgeler-file)//*[@id=$localinfo]"/>
            <xsl:with-param name="localinfo" select="$localinfo"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:when><xsl:otherwise>
    <xsl:message>
      <xsl:text>*******************Link to nonexistent id: </xsl:text>
      <xsl:value-of select="$localinfo"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:otherwise></xsl:choose>

</xsl:template>

<xsl:template name="olink.target">
  <xsl:param name="node" select="."/>
  <xsl:param name="localinfo"/>

  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="local-name($node) = 'set'
                or local-name($node) = 'book'
                or local-name($node) = 'chapter'
                or local-name($node) = 'preface'
                or local-name($node) = 'appendix'
                or local-name($node) = 'article'
                or local-name($node) = 'bibliography'
                or local-name($node) = 'glossary'
                or local-name($node) = 'index'
                or local-name($node) = 'part'
                or local-name($node) = 'refentry'
                or local-name($node) = 'reference'
                or local-name($node) = 'example'
                or local-name($node) = 'equation'
                or local-name($node) = 'table'
                or local-name($node) = 'figure'
                or local-name($node) = 'simplesect'
                or starts-with(local-name($node),'sect')
                or starts-with(local-name($node),'refsect')">

      <xsl:variable name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$node"/>
        </xsl:call-template>
      </xsl:variable>


      <a href="{$href}">
        <xsl:choose>
          <xsl:when test="$content !=''">
            <xsl:value-of select="$content"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates
            select="$node" mode="object.title.markup.textonly"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>*******************Link to nonexistent id: </xsl:text>
        <xsl:value-of select="$localinfo"/>
      </xsl:message>
      <xsl:choose>
        <xsl:when test="$content !=''">
          <xsl:value-of select="$content"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>???</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="xref.xreflabel">
  <!-- called to process an xreflabel...you might use this to make  -->
  <!-- xreflabels come out in the right font for different targets, -->
  <!-- for example. -->
  <xsl:param name="target" select="."/>
  <xsl:value-of select="$target/@xreflabel"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="title" mode="xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="command" mode="xref">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="function" mode="xref">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="*" mode="pagenumber.markup">
  <xsl:message>
    <xsl:text>Page numbers make no sense in HTML! (Don't use %p in templates)</xsl:text>
  </xsl:message>
</xsl:template>

</xsl:stylesheet>
