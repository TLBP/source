<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:d="http://docbook.org/ns/docbook"
 xmlns:exsl="http://exslt.org/common"
 xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0"
 xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
 xmlns:xl="http://www.w3.org/1999/xlink"
 exclude-result-prefixes="d exsl cf suwl xl"
 version="1.0">

 <xsl:template match="d:index">

  <xsl:call-template name="id.warning"/>

  <xsl:if test="count(*)&gt;0 or $generate.index != '0'">
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:call-template name="index.titlepage"/>
      <xsl:choose>
       <xsl:when test="d:indexdiv">
         <xsl:apply-templates/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:apply-templates select="*[not(self::d:indexentry)]"/>
         <xsl:if test="d:indexentry">
           <dl>
             <xsl:apply-templates select="d:indexentry"/>
           </dl>
         </xsl:if>
       </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="count(d:indexentry) = 0 and count(d:indexdiv) = 0">
        <xsl:choose>
          <xsl:when test="@condition = 'multi-index'">
            <xsl:call-template name="generate-multi-index">
              <xsl:with-param name="target" select="@xml:id"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@condition = 'items'">
            <xsl:call-template name="generate-item-index">
              <xsl:with-param name="target" select="@xml:id"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@condition = 'abstracts'">
            <xsl:call-template name="generate-abstract-index"/>
          </xsl:when>
          <xsl:when test="@condition = 'tips'">
            <xsl:call-template name="generate-tip-index"/>
          </xsl:when>
          <xsl:when test="@condition = 'examples'">
            <xsl:call-template name="generate-example-index"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:if>

      <xsl:if test="not(parent::d:article)">
        <xsl:call-template name="process.footnotes"/>
      </xsl:if>

    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:param name="onechunk" select="0"/>
<xsl:param name="refentry.separator" select="0"/>
<xsl:param name="chunk.fast" select="1"/>

<xsl:key name="genid" match="*" use="generate-id()"/>

<xsl:variable name="chunks" select="exsl:node-set($chunk.hierarchy)//cf:div"/>

<!-- ==================================================================== -->

<xsl:variable name="chunk.hierarchy">
  <xsl:if test="$chunk.fast != 0">
    <xsl:choose>
      <!-- Do we need to fix namespace? -->
      <xsl:when test="$exsl.node.set.available != 0 and                      namespace-uri(/*) != 'http://docbook.org/ns/docbook'">
        <xsl:if test="$chunk.quietly = 0">
          <xsl:message>Computing chunks......</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="find.chunks" select="exsl:node-set($with.namespace)"/>
      </xsl:when>
      <xsl:when test="$exsl.node.set.available != 0">
        <xsl:if test="$chunk.quietly = 0">
          <xsl:message>Computing chunks...</xsl:message>
        </xsl:if>
        <xsl:apply-templates select="/*" mode="find.chunks"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$chunk.quietly = 0">
          <xsl:message>
            <xsl:text>Fast chunking requires exsl:node-set(). </xsl:text>
            <xsl:text>Using "slow" chunking.</xsl:text>
          </xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:variable>

<xsl:template name="process-chunk-element">
  <xsl:choose>
    <xsl:when test="$chunk.fast != 0 and $exsl.node.set.available != 0">
      <xsl:variable name="genid" select="generate-id()"/>

      <xsl:variable name="div" select="$chunks[@id=$genid or @xml:id=$genid]"/>

      <xsl:variable name="prevdiv" select="($div/preceding-sibling::cf:div|$div/preceding::cf:div|$div/parent::cf:div)[last()]"/>
      <xsl:variable name="prev" select="key('genid', ($prevdiv/@id|$prevdiv/@xml:id)[1])"/>

      <xsl:variable name="nextdiv" select="($div/following-sibling::cf:div|$div/following::cf:div|$div/cf:div)[1]"/>
      <xsl:variable name="next" select="key('genid', ($nextdiv/@id|$nextdiv/@xml:id)[1])"/>

      <xsl:choose>
        <xsl:when test="$onechunk != 0 and parent::*">
          <xsl:apply-imports/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="process-chunk">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process-chunk">
  <xsl:param name="prev" select="."/>
  <xsl:param name="next" select="."/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:variable name="chunkfn">
    <xsl:if test="$ischunk='1'">
      <xsl:apply-templates mode="chunk-filename" select="."/>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="$ischunk='0'">
    <xsl:message>
      <xsl:text>Error </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text> is not a chunk!</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="filename">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
      <xsl:with-param name="base.name" select="$chunkfn"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="content">
      <xsl:call-template name="chunk-element-content">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="make.lots">
  <xsl:param name="toc.params" select="''"/>
  <xsl:param name="toc"/>

  <xsl:variable name="lots">
    <xsl:if test="contains($toc.params, 'toc')">
      <xsl:copy-of select="$toc"/>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'figure')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'figure'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'figure'"/>
                <xsl:with-param name="nodes" select=".//d:figure"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'figure'"/>
            <xsl:with-param name="nodes" select=".//d:figure"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'table')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'table'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'table'"/>
                <xsl:with-param name="nodes" select=".//d:table[not(@tocentry = 0)]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'table'"/>
            <xsl:with-param name="nodes" select=".//d:table[not(@tocentry = 0)]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'example')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'example'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'example'"/>
                <xsl:with-param name="nodes" select=".//d:example"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'example'"/>
            <xsl:with-param name="nodes" select=".//d:example"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'equation')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'equation'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'equation'"/>
                <xsl:with-param name="nodes" select=".//d:equation[d:title or d:info/d:title]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'equation'"/>
            <xsl:with-param name="nodes" select=".//d:equation[d:title or d:info/d:title]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="contains($toc.params, 'procedure')">
      <xsl:choose>
        <xsl:when test="$chunk.separate.lots != '0'">
          <xsl:call-template name="make.lot.chunk">
            <xsl:with-param name="type" select="'procedure'"/>
            <xsl:with-param name="lot">
              <xsl:call-template name="list.of.titles">
                <xsl:with-param name="titles" select="'procedure'"/>
                <xsl:with-param name="nodes" select=".//d:procedure[d:title]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.titles">
            <xsl:with-param name="titles" select="'procedure'"/>
            <xsl:with-param name="nodes" select=".//d:procedure[d:title]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="string($lots) != ''">
    <xsl:choose>
      <xsl:when test="$chunk.tocs.and.lots != 0 and not(parent::*)">
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename">
            <xsl:call-template name="make-relative-filename">
              <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
              <xsl:with-param name="base.name">
                <xsl:call-template name="dbhtml-dir"/>
                <xsl:value-of select="$chunked.filename.prefix"/>
                <xsl:apply-templates select="." mode="recursive-chunk-filename">
                  <xsl:with-param name="recursive" select="true()"/>
                </xsl:apply-templates>
                <xsl:text>-toc</xsl:text>
                <xsl:value-of select="$html.ext"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="content">
            <xsl:call-template name="chunk-element-content">
              <xsl:with-param name="prev" select="/d:foo"/>
              <xsl:with-param name="next" select="/d:foo"/>
              <xsl:with-param name="nav.context" select="'toc'"/>
              <xsl:with-param name="content">
                <xsl:if test="$chunk.tocs.and.lots.has.title != 0">
                  <h1>
                    <xsl:apply-templates select="." mode="object.title.markup"/>
                  </h1>
                </xsl:if>
                <xsl:copy-of select="$lots"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="quiet" select="$chunk.quietly"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$lots"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="make.lot.chunk">
  <xsl:param name="type" select="''"/>
  <xsl:param name="lot"/>

  <xsl:if test="string($lot) != ''">
    <xsl:variable name="filename">
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
        <xsl:with-param name="base.name">
          <xsl:call-template name="dbhtml-dir"/>
          <xsl:value-of select="$type"/>
          <xsl:text>-toc</xsl:text>
          <xsl:value-of select="$html.ext"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="href">
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.dir" select="''"/>
        <xsl:with-param name="base.name">
          <xsl:call-template name="dbhtml-dir"/>
          <xsl:value-of select="$type"/>
          <xsl:text>-toc</xsl:text>
          <xsl:value-of select="$html.ext"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="content">
        <xsl:call-template name="chunk-element-content">
          <xsl:with-param name="prev" select="/d:foo"/>
          <xsl:with-param name="next" select="/d:foo"/>
          <xsl:with-param name="nav.context" select="'toc'"/>
          <xsl:with-param name="content">
            <xsl:copy-of select="$lot"/>
           </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
    </xsl:call-template>
    <!-- And output a link to this file -->
    <div>
      <xsl:attribute name="class">
        <xsl:text>ListofTitles</xsl:text>
      </xsl:attribute>
      <a href="{$href}">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">
            <xsl:choose>
              <xsl:when test="$type='table'">ListofTables</xsl:when>
              <xsl:when test="$type='figure'">ListofFigures</xsl:when>
              <xsl:when test="$type='equation'">ListofEquations</xsl:when>
              <xsl:when test="$type='example'">ListofExamples</xsl:when>
              <xsl:when test="$type='procedure'">ListofProcedures</xsl:when>
              <xsl:otherwise>ListofUnknown</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </a>
    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="in.other.chunk">
  <xsl:param name="chunk" select="."/>
  <xsl:param name="node" select="."/>

  <xsl:variable name="is.chunk">
    <xsl:call-template name="chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$chunk = $node">0</xsl:when>
    <xsl:when test="$is.chunk = 1">1</xsl:when>
    <xsl:when test="count($node) = 0">0</xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="in.other.chunk">
        <xsl:with-param name="chunk" select="$chunk"/>
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="count.footnotes.in.this.chunk">
  <xsl:param name="node" select="."/>
  <xsl:param name="footnotes" select="$node//d:footnote"/>
  <xsl:param name="count" select="0"/>

  <xsl:variable name="in.other.chunk">
    <xsl:call-template name="in.other.chunk">
      <xsl:with-param name="chunk" select="$node"/>
      <xsl:with-param name="node" select="$footnotes[1]"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($footnotes) = 0">
      <xsl:value-of select="$count"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$in.other.chunk != 0">
          <xsl:call-template name="count.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$footnotes[1]/ancestor::d:table                         |$footnotes[1]/ancestor::d:informaltable">
          <xsl:call-template name="count.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="count.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.footnotes.in.this.chunk">
  <xsl:param name="node" select="."/>
  <xsl:param name="footnotes" select="$node//d:footnote"/>

  <xsl:variable name="in.other.chunk">
    <xsl:call-template name="in.other.chunk">
      <xsl:with-param name="chunk" select="$node"/>
      <xsl:with-param name="node" select="$footnotes[1]"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($footnotes) = 0">
      <!-- nop -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$in.other.chunk != 0">
          <xsl:call-template name="process.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$footnotes[1]/ancestor::d:table                         |$footnotes[1]/ancestor::d:informaltable">
          <xsl:call-template name="process.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$footnotes[1]" mode="process.footnote.mode"/>
          <xsl:call-template name="process.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes" select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.footnotes">
  <xsl:variable name="footnotes" select=".//d:footnote"/>
  <xsl:variable name="fcount">
    <xsl:call-template name="count.footnotes.in.this.chunk">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="footnotes" select="$footnotes"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$fcount &gt; 0">
    <div class="footnotes">
      <xsl:call-template name="footnotes.attributes"/>
      <br/>
      <hr>
        <xsl:choose>
          <xsl:when test="$make.clean.html != 0">
            <xsl:attribute name="class">footnote-hr</xsl:attribute>
          </xsl:when>
          <xsl:when test="$css.decoration != 0">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('width:100; text-align:',                                             $direction.align.start,                                             ';',          'margin-', $direction.align.start, ': 0')"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="width">100</xsl:attribute>
            <xsl:attribute name="align"><xsl:value-of select="$direction.align.start"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </hr>
      <xsl:call-template name="process.footnotes.in.this.chunk">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="footnotes" select="$footnotes"/>
      </xsl:call-template>
    </div>
  </xsl:if>

  <xsl:if test="$annotation.support != 0 and //d:annotation">
    <div class="annotation-list">
      <div class="annotation-nocss">
        <p>The following annotations are from this essay. You are seeing
        them here because your browser doesn&#8217;t support the user-interface
        techniques used to make them appear as &#8216;popups&#8217; on modern browsers.</p>
      </div>

      <xsl:apply-templates select="//d:annotation" mode="annotation-popup"/>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="process.chunk.footnotes">
  <xsl:variable name="is.chunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>
  <xsl:if test="$is.chunk = 1">
    <xsl:call-template name="process.footnotes"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <!-- returns 1 if $node is a chunk -->

  <!-- ==================================================================== -->
  <!-- What's a chunk?

       The root element
       appendix
       article
       bibliography  in article or part or book
       book
       chapter
       colophon
       glossary      in article or part or book
       index         in article or part or book
       part
       preface
       refentry
       reference
       sect{1,2,3,4,5}  if position()>1 && depth < chunk.section.depth
       section          if position()>1 && depth < chunk.section.depth
       set
       setindex
       topic
                                                                            -->
  <!-- ==================================================================== -->
<!--
  <xsl:message>
    <xsl:text>chunk: </xsl:text>
    <xsl:value-of select="name($node)"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$node/@xml:id"/>
    <xsl:text>)</xsl:text>
    <xsl:text> s2c: </xsl:text>
    <xsl:value-of select="count($node/child::d:sect2)"/>
    <xsl:text> pi: </xsl:text>
    <xsl:value-of select="($node/parent::d:sect1/processing-instruction('dbhtml'))"/>
    <xsl:text> csd: </xsl:text>
    <xsl:value-of select="$chunk.section.depth"/>
    <xsl:text> cfs: </xsl:text>
    <xsl:value-of select="$chunk.first.sections"/>
    <xsl:text> ps: </xsl:text>
    <xsl:value-of select="count($node/parent::d:section)"/>
    <xsl:text> prs: </xsl:text>
    <xsl:value-of select="count($node/preceding-sibling::d:section)"/>
  </xsl:message>
-->
  <xsl:choose>
	  <xsl:when test="$node/parent::*/processing-instruction('dbhtml')[normalize-space(.) = 'stop-chunking']">0</xsl:when>
    <xsl:when test="not($node/parent::*)">1</xsl:when>

    <xsl:when test="local-name($node) = 'sect1'                     and $chunk.section.depth &gt;= 1                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:sect1) &gt; 0)">
      <xsl:text>1</xsl:text>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect2' and normalize-space($node/parent::d:sect1/processing-instruction('dbhtml')) = 'chunkthis' and not (@userlevel)">1</xsl:when>
    <xsl:when test="local-name($node) = 'sect2'                     and  $chunk.section.depth &gt;= 2                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:sect2) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect3'                     and $chunk.section.depth &gt;= 3                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:sect3) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect4'                     and $chunk.section.depth &gt;= 4                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:sect4) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect5'                     and $chunk.section.depth &gt;= 5                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:sect5) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'section'                     and $chunk.section.depth &gt;= count($node/ancestor::d:section)+1                     and ($chunk.first.sections != 0                          or count($node/preceding-sibling::d:section) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="local-name($node)='preface'">1</xsl:when>
    <xsl:when test="local-name($node)='chapter'">1</xsl:when>
    <xsl:when test="local-name($node)='appendix'">1</xsl:when>
    <xsl:when test="local-name($node)='article'">1</xsl:when>
    <xsl:when test="local-name($node)='topic'">1</xsl:when>
    <xsl:when test="local-name($node)='part'">1</xsl:when>
    <xsl:when test="local-name($node)='reference'">1</xsl:when>
    <xsl:when test="local-name($node)='refentry'">1</xsl:when>
    <xsl:when test="local-name($node)='index' and ($generate.index != 0 or count($node/*) &gt; 0)                     and (local-name($node/parent::*) = 'article'                     or local-name($node/parent::*) = 'book'                     or local-name($node/parent::*) = 'part'                     )">1</xsl:when>
    <xsl:when test="local-name($node)='bibliography'                     and (local-name($node/parent::*) = 'article'                     or local-name($node/parent::*) = 'book'                     or local-name($node/parent::*) = 'part'                     )">1</xsl:when>
    <xsl:when test="local-name($node)='glossary'                     and (local-name($node/parent::*) = 'article'                     or local-name($node/parent::*) = 'book'                     or local-name($node/parent::*) = 'part'                     )">1</xsl:when>
    <xsl:when test="local-name($node)='colophon'">1</xsl:when>
    <xsl:when test="local-name($node)='book'">1</xsl:when>
    <xsl:when test="local-name($node)='set'">1</xsl:when>
    <xsl:when test="local-name($node)='setindex'">1</xsl:when>
    <xsl:when test="local-name($node)='dictionary'">1</xsl:when>
    <xsl:when test="local-name($node)='legalnotice'                     and $generate.legalnotice.link != 0">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="html.head">
  <xsl:param name="prev" select="/d:foo"/>
  <xsl:param name="next" select="/d:foo"/>
  <xsl:variable name="this" select="."/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <head>
    <xsl:call-template name="system.head.content"/>
    <xsl:call-template name="head.content"/>

    <!-- home link not valid in HTML5 -->
    <xsl:if test="$home and $div.element != 'section'">
      <link rel="home">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$home"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="$home" mode="object.title.markup.textonly"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <!-- up link not valid in HTML5 -->
    <xsl:if test="$up and $div.element != 'section'">
      <link rel="up">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$up"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="$up" mode="object.title.markup.textonly"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:if test="$prev">
      <link rel="prev">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$prev"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="$prev" mode="object.title.markup.textonly"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:if test="$next">
      <link rel="next">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$next"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="$next" mode="object.title.markup.textonly"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:if test="$html.extra.head.links != 0">
      <xsl:for-each select="//d:part                             |//d:reference                             |//d:preface                             |//d:chapter                             |//d:article                             |//d:refentry                             |//d:appendix[not(parent::d:article)]|d:appendix                             |//d:glossary[not(parent::d:article)]|d:glossary                             |//d:index[not(parent::d:article)]|d:index|d:dictionary">
        <link rel="{local-name(.)}">
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="$this"/>
              <xsl:with-param name="object" select="."/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
          </xsl:attribute>
        </link>
      </xsl:for-each>

      <xsl:for-each select="d:section|d:sect1|d:refsection|d:refsect1">
        <link>
          <xsl:attribute name="rel">
            <xsl:choose>
              <xsl:when test="local-name($this) = 'section'                               or local-name($this) = 'refsection'">
                <xsl:value-of select="'subsection'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'section'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="$this"/>
              <xsl:with-param name="object" select="."/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
          </xsl:attribute>
        </link>
      </xsl:for-each>

      <xsl:for-each select="d:sect2|d:sect3|d:sect4|d:sect5|d:refsect2|d:refsect3">
        <link rel="subsection">
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="$this"/>
              <xsl:with-param name="object" select="."/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
          </xsl:attribute>
        </link>
      </xsl:for-each>
    </xsl:if>

    <!-- * if we have a legalnotice and user wants it output as a -->
    <!-- * separate page and $html.head.legalnotice.link.types is -->
    <!-- * non-empty, we generate a link or links for each value in -->
    <!-- * $html.head.legalnotice.link.types -->
    <xsl:if test="//d:legalnotice                   and not($generate.legalnotice.link = 0)                   and not($html.head.legalnotice.link.types = '')">
      <xsl:call-template name="make.legalnotice.head.links"/>
    </xsl:if>

    <xsl:call-template name="user.head.content"/>
  </head>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="header.navigation">
  <xsl:param name="prev" select="/d:foo"/>
  <xsl:param name="next" select="/d:foo"/>
  <xsl:param name="nav.context"/>

  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:variable name="row1" select="$navig.showtitles != 0"/>
  <xsl:variable name="row2" select="count($prev) &gt; 0                                     or (count($up) &gt; 0                                          and generate-id($up) != generate-id($home)                                         and $navig.showtitles != 0)                                     or count($next) &gt; 0"/>

  <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
    <div class="navbar">
     <div class="dropdown" style="width:33%">
      <xsl:variable name="href">
       <xsl:choose>
        <xsl:when test="name(.)!='set' and name(.)!='book' and count($prev)&gt;0">
         <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$prev"/>
         </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">
       <xsl:choose>
        <xsl:when test="name(.)!='set' and name(.)!='book' and count($prev)&gt;0">
         <xsl:text>Önceki</xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>&#160;&#160;</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </button>
      <xsl:if test="name(.)!='set' and name(.)!='book' and count($prev)&gt;0">
       <div class="dropdown-content">
         <xsl:apply-templates select="$prev" mode="object.title.markup"/>
       </div>
      </xsl:if>
     </div>

     <div class="dropdown" style="width:34%">
      <button class="dropbtn">Yukarı</button>
      <div class="dropdown-content">
       <button type="button" class="dropbtn" onclick="window.location.assign('/index.html')">Baş Sayfa</button>
       <xsl:if test="@xml:id!='index'">
        <button type="button" class="dropbtn" onclick="window.location.assign('/KiTAPLIK/index.html')">Kitaplık</button>
       </xsl:if>
       <xsl:if test="ancestor::d:book and generate-id($up) != generate-id(ancestor::d:book)">
         <xsl:variable name="href">
           <xsl:call-template name="href.target">
             <xsl:with-param name="object" select="ancestor::d:book"/>
           </xsl:call-template>
         </xsl:variable>
         <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">Ana Başlık</button>
        </xsl:if>

       <xsl:if test="count($up)&gt;0 and generate-id($up) != generate-id($home)">
         <xsl:variable name="href">
           <xsl:call-template name="href.target">
             <xsl:with-param name="object" select="$up"/>
           </xsl:call-template>
         </xsl:variable>
        <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">Üst Başlık</button>
       </xsl:if>
      </div>
     </div>

     <div class="dropdown" style="width:33%">
      <xsl:variable name="href">
       <xsl:choose>
        <xsl:when test="name($next)!='set' and name($next)!='book' and count($next)&gt;0">
         <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$next"/>
         </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">
       <xsl:choose>
        <xsl:when test="name($next)!='set' and name($next)!='book' and count($next)&gt;0">
         <xsl:text>Sonraki</xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>&#160;&#160;</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </button>
      <xsl:if test="name($next)!='set' and name($next)!='book' and count($next)&gt;0">
       <div class="dropdown-content">
         <xsl:apply-templates select="$next" mode="object.title.markup"/>
       </div>
      </xsl:if>
     </div>
    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->
<!-- no footer naviation now; header navigation is fixed on page. -->
<xsl:template name="footer.navigation"/><!--
  <xsl:param name="prev" select="/d:foo"/>
  <xsl:param name="next" select="/d:foo"/>
  <xsl:param name="nav.context"/>

  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:variable name="row1" select="count($prev) &gt; 0                                     or count($up) &gt; 0                                     or count($next) &gt; 0"/>

  <xsl:variable name="row2" select="($prev and $navig.showtitles != 0)                                     or (generate-id($home) != generate-id(.)                                         or $nav.context = 'toc')                                     or ($chunk.tocs.and.lots != 0                                         and $nav.context != 'toc')                                     or ($next and $navig.showtitles != 0)"/>

  <xsl:if test="$suppress.navigation = '0' and $suppress.footer.navigation = '0'">
    <div class="footbar navbar">
     <div class="dropup" style="width:33%">
      <xsl:variable name="href">
       <xsl:choose>
        <xsl:when test="count($prev)&gt;0">
         <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$prev"/>
         </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>#</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">
       <xsl:choose>
        <xsl:when test="count($prev)&gt;0">
         <xsl:text>Önceki</xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>&#160;&#160;</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </button>
      <xsl:if test="count($prev)&gt;0">
       <div class="dropup-content">
         <xsl:apply-templates select="$prev" mode="object.title.markup"/>
       </div>
      </xsl:if>
     </div>
     <div class="dropup" style="width:34%">
      <button class="dropbtn">Yukarı</button>
      <div class="dropup-content">
       <button type="button" class="dropbtn" onclick="window.location.assign('/index.xhtml')">Baş Sayfa</button>
       <button type="button" class="dropbtn" onclick="window.location.assign('/kitaplik/index.xhtml')">Kitaplık</button>
       <xsl:if test="$home != . or $nav.context = 'toc'">
        <xsl:variable name="href">
         <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$home"/>
         </xsl:call-template>
        </xsl:variable>
        <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">Ana Başlık</button>
        </xsl:if>
       <xsl:if test="count($up)&gt;0 and generate-id($up) != generate-id($home)">
         <xsl:variable name="href">
           <xsl:call-template name="href.target">
             <xsl:with-param name="object" select="$up"/>
           </xsl:call-template>
         </xsl:variable>
        <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">Üst Başlık</button>
       </xsl:if>
      </div>
     </div>
     <div class="dropup" style="width:33%">
      <xsl:variable name="href">
       <xsl:choose>
        <xsl:when test="count($next)&gt;0">
         <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$next"/>
         </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <button type="button" class="dropbtn" onclick="window.location.assign('{$href}')">
       <xsl:choose>
        <xsl:when test="count($next)&gt;0">
         <xsl:text>Sonraki</xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:text>&#160;&#160;</xsl:text>
        </xsl:otherwise>
       </xsl:choose>
      </button>
      <xsl:if test="count($next)&gt;0">
       <div class="dropup-content">
         <xsl:apply-templates select="$next" mode="object.title.markup"/>
       </div>
      </xsl:if>
     </div>
    </div>
  </xsl:if>
</xsl:template> -->

<!-- ==================================================================== -->

<xsl:template name="navig.content">
    <xsl:param name="direction" select="d:next"/>
    <xsl:variable name="navtext">
        <xsl:choose>
            <xsl:when test="$direction = 'prev'">
                <xsl:call-template name="gentext.nav.prev"/>
            </xsl:when>
            <xsl:when test="$direction = 'next'">
                <xsl:call-template name="gentext.nav.next"/>
            </xsl:when>
            <xsl:when test="$direction = 'up'">
                <xsl:call-template name="gentext.nav.up"/>
            </xsl:when>
            <xsl:when test="$direction = 'home'">
                <xsl:call-template name="gentext.nav.home"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>xxx</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$navig.graphics != 0">
            <img>
                <xsl:attribute name="src">
                    <xsl:value-of select="$navig.graphics.path"/>
                    <xsl:value-of select="$direction"/>
                    <xsl:value-of select="$navig.graphics.extension"/>
                </xsl:attribute>
                <xsl:attribute name="alt">
                    <xsl:value-of select="$navtext"/>
                </xsl:attribute>
            </img>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$navtext"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- * The following template assumes that the first legalnotice -->
<!-- * instance found in a document applies to the contents of the -->
<!-- * entire document. It generates an HTML link in each chunk, back -->
<!-- * to the file containing the contents of the first legalnotice. -->
<!-- * -->
<!-- * Actually, it may generate multiple link instances in each chunk, -->
<!-- * because it walks through the space-separated list of link -->
<!-- * types specified in the $html.head.legalnotice.link.types param, -->
<!-- * popping off link types and generating links for them until it -->
<!-- * depletes the list. -->

<xsl:template name="make.legalnotice.head.links">
  <!-- * the following ID is used as part of the legalnotice filename; -->
  <!-- * we need it in order to construct the filename for use in the -->
  <!-- * value of the href attribute on the link -->

  <xsl:param name="ln-node" select="(//d:legalnotice)[1]"/>

  <xsl:param name="linktype">
    <xsl:choose>
      <xsl:when test="contains($html.head.legalnotice.link.types, ' ')">
        <xsl:value-of select="normalize-space(                     substring-before($html.head.legalnotice.link.types, ' '))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$html.head.legalnotice.link.types"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="remaining.linktypes" select="concat(               normalize-space(               substring-after($html.head.legalnotice.link.types, ' ')),' ')"/>
  <xsl:if test="not($linktype = '')">

    <!-- Compute name of legalnotice file (see titlepage.xsl) -->
    <xsl:variable name="file">
      <xsl:call-template name="ln.or.rh.filename">
	<xsl:with-param name="node" select="$ln-node"/>
      </xsl:call-template>
    </xsl:variable>

    <link rel="{$linktype}">
      <xsl:attribute name="href">
        <xsl:value-of select="$file"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="(//d:legalnotice)[1]" mode="object.title.markup.textonly"/>
      </xsl:attribute>
    </link>
    <xsl:call-template name="make.legalnotice.head.links">
      <!-- * pop the next value off the list of link types -->
      <xsl:with-param name="linktype" select="substring-before($remaining.linktypes, ' ')"/>
      <!-- * remove the link type from the list of remaining link types -->
      <xsl:with-param name="remaining.linktypes" select="substring-after($remaining.linktypes, ' ')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template name="generate.manifest">
  <xsl:param name="node" select="/"/>
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:value-of select="$chunk.base.dir"/>
      </xsl:if>
      <xsl:value-of select="$manifest"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:apply-templates select="$node" mode="enumerate-files"/>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbhtml-dir">
  <xsl:param name="context" select="."/>
  <!-- directories are now inherited from previous levels -->
  <xsl:variable name="ppath">
    <xsl:if test="$context/parent::*">
      <xsl:call-template name="dbhtml-dir">
        <xsl:with-param name="context" select="$context/parent::*"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="path">
    <xsl:call-template name="pi.dbhtml_dir">
      <xsl:with-param name="node" select="$context"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$path = ''">
      <xsl:if test="$ppath != ''">
        <xsl:value-of select="$ppath"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$ppath != ''">
        <xsl:value-of select="$ppath"/>
        <xsl:if test="substring($ppath, string-length($ppath), 1) != '/'">
          <xsl:text>/</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="$path"/>
      <xsl:text>/</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="check.id.unique">
  <xsl:param name="linkend"></xsl:param>
  <xsl:if test="$linkend != ''">
    <xsl:variable name="targets" select="key('id',$linkend)"/>
    <xsl:variable name="target" select="$targets[1]"/>

<!-- Bulamadığı id'ler için hata vermesin. Biz onları nasılsa tamamlarız.
     Zaten, bulunamayan id'ler için bağ oluşturmuyoruz.
    <xsl:if test="count($targets)=0">
      <xsl:message>
        <xsl:text>Error: no ID for constraint linkend: </xsl:text>
        <xsl:value-of select="concat('&quot;', $linkend, '&quot;')"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
    </xsl:if>
-->
    <!-- Bu hata önemli!  -->
    <xsl:if test="count($targets)>1">
      <xsl:message>
        <xsl:text>Warning: multiple "IDs" for constraint linkend: </xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="id.attribute">
  <xsl:param name="node" select="."/>
  <xsl:param name="conditional" select="1"/>
  <xsl:if test="$node/@xml:id">
   <xsl:attribute name="id">
     <xsl:call-template name="object.id">
       <xsl:with-param name="object" select="$node"/>
     </xsl:call-template>
   </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="href.target.uri">
  <xsl:param name="object" select="."/>
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk">
      <xsl:with-param name="node" select="$object"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:apply-templates mode="chunk-filename" select="$object"/>

  <xsl:if test="$ischunk='0' and $object/@xml:id">
    <xsl:text>#</xsl:text>
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$object"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="href.target">
  <xsl:param name="context" select="."/>
  <xsl:param name="object" select="."/>
  <xsl:param name="toc-context" select="."/>
  <!-- * If $toc-context contains some node other than the current node, -->
  <!-- * it means we're processing a link in a TOC. In that case, to -->
  <!-- * ensure the link will work correctly, we need to take a look at -->
  <!-- * where the file containing the TOC will get written, and where -->
  <!-- * the file that's being linked to will get written. -->
  <xsl:variable name="toc-output-dir">
    <xsl:if test="not($toc-context = .)">
      <!-- * Get the $toc-context node and all its ancestors, look down -->
      <!-- * through them to find the last/closest node to the -->
      <!-- * toc-context node that has a "dbhtml dir" PI, and get the -->
      <!-- * directory name from that. That's the name of the directory -->
      <!-- * to which the current toc output file will get written. -->
      <xsl:call-template name="dbhtml-dir">
        <xsl:with-param name="context" select="$toc-context/ancestor-or-self::*[processing-instruction('dbhtml')[contains(.,'dir')]][last()]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="linked-file-output-dir">
    <xsl:if test="not($toc-context = .)">
      <!-- * Get the current node and all its ancestors, look down -->
      <!-- * through them to find the last/closest node to the current -->
      <!-- * node that has a "dbhtml dir" PI, and get the directory name -->
      <!-- * from that.  That's the name of the directory to which the -->
      <!-- * file that's being linked to will get written. -->
      <xsl:call-template name="dbhtml-dir">
        <xsl:with-param name="context" select="ancestor-or-self::*[processing-instruction('dbhtml')[contains(.,'dir')]][last()]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="href.to.uri">
    <xsl:call-template name="href.target.uri">
      <xsl:with-param name="object" select="$object"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href.from.uri">
    <xsl:choose>
      <xsl:when test="not($toc-context = .)">
        <xsl:call-template name="href.target.uri">
          <xsl:with-param name="object" select="$toc-context"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="href.target.uri">
          <xsl:with-param name="object" select="$context"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- * <xsl:message>toc-context: <xsl:value-of select="local-name($toc-context)"/></xsl:message> -->
  <!-- * <xsl:message>node: <xsl:value-of select="local-name(.)"/></xsl:message> -->
  <!-- * <xsl:message>context: <xsl:value-of select="local-name($context)"/></xsl:message> -->
  <!-- * <xsl:message>object: <xsl:value-of select="local-name($object)"/></xsl:message> -->
  <!-- * <xsl:message>toc-output-dir: <xsl:value-of select="$toc-output-dir"/></xsl:message> -->
  <!-- * <xsl:message>linked-file-output-dir: <xsl:value-of select="$linked-file-output-dir"/></xsl:message> -->
  <!-- * <xsl:message>href.to.uri: <xsl:value-of select="$href.to.uri"/></xsl:message> -->
  <!-- * <xsl:message>href.from.uri: <xsl:value-of select="$href.from.uri"/></xsl:message> -->
  <xsl:variable name="href.to">
    <xsl:choose>
      <!-- * 2007-07-19, MikeSmith: Added the following conditional to -->
      <!-- * deal with a problem case for links in TOCs. It checks to see -->
      <!-- * if the output dir that a TOC will get written to is -->
      <!-- * different from the output dir of the file being linked to. -->
      <!-- * If it is different, we do not call trim.common.uri.paths. -->
      <!-- *  -->
      <!-- * Reason why I added that conditional is: I ran into a bug for -->
      <!-- * this case: -->
      <!-- *  -->
      <!-- * 1. we are chunking into separate dirs -->
      <!-- *  -->
      <!-- * 2. output for the TOC is written to current dir, but the file -->
      <!-- *    being linked to is written to some subdir "foo". -->
      <!-- *  -->
      <!-- * For that case, links to that file in that TOC did not show -->
      <!-- * the correct path - they omitted the "foo". -->
      <!-- *  -->
      <!-- * The cause of that problem was that the trim.common.uri.paths -->
      <!-- * template[1] was being called under all conditions. But it's -->
      <!-- * apparent that we don't want to call trim.common.uri.paths in -->
      <!-- * the case where a linked file is being written to a different -->
      <!-- * directory than the TOC that contains the link, because doing -->
      <!-- * so will cause a necessary (not redundant) directory-name -->
      <!-- * part of the link to get inadvertently trimmed, resulting in -->
      <!-- * a broken link to that file. Thus, added the conditional. -->
      <!-- *  -->
      <!-- * [1] The purpose of the trim.common.uri.paths template is to -->
      <!-- * prevent cases where, if we didn't call it, we end up with -->
      <!-- * unnecessary, redundant directory names getting output; for -->
      <!-- * example, "foo/foo/refname.html". -->
      <xsl:when test="not($toc-output-dir = $linked-file-output-dir)">
        <xsl:value-of select="$href.to.uri"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim.common.uri.paths">
          <xsl:with-param name="uriA" select="$href.to.uri"/>
          <xsl:with-param name="uriB" select="$href.from.uri"/>
          <xsl:with-param name="return" select="'A'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="href.from">
    <xsl:call-template name="trim.common.uri.paths">
      <xsl:with-param name="uriA" select="$href.to.uri"/>
      <xsl:with-param name="uriB" select="$href.from.uri"/>
      <xsl:with-param name="return" select="'B'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="depth">
    <xsl:call-template name="count.uri.path.depth">
      <xsl:with-param name="filename" select="$href.from"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:call-template name="copy-string">
      <xsl:with-param name="string" select="'../'"/>
      <xsl:with-param name="count" select="$depth"/>
    </xsl:call-template>
    <xsl:value-of select="$href.to"/>
  </xsl:variable>
  <!--
  <xsl:message>
    <xsl:text>In </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="$href.from"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$depth"/>
    <xsl:text>) </xsl:text>
    <xsl:value-of select="name($object)"/>
    <xsl:text> href=</xsl:text>
    <xsl:value-of select="$href"/>
  </xsl:message>
  -->
  <xsl:value-of select="$href"/>
</xsl:template>

<!-- Returns the complete olink href value if found -->
<!-- Must take into account any dbhtml dir of the chunk containing the olink -->
<xsl:template name="make.olink.href">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="target.database"/>

  <xsl:if test="$olink.key != ''">
    <xsl:variable name="target.href">
      <xsl:for-each select="$target.database">
        <xsl:value-of select="key('targetptr-key', $olink.key)[1]/@href"/>
      </xsl:for-each>
    </xsl:variable>

    <!-- an olink starting point may be in a subdirectory, so need
         the "from" reference point to compute a relative path -->

    <xsl:variable name="from.href">
      <xsl:call-template name="olink.from.uri">
        <xsl:with-param name="target.database" select="$target.database"/>
        <xsl:with-param name="object" select="."/>
        <xsl:with-param name="object.targetdoc" select="$current.docid"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- If the from.href has directory path, then must "../" upward
         to document level -->
    <xsl:variable name="upward.from.path">
      <xsl:call-template name="upward.path">
        <xsl:with-param name="path" select="$from.href"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="targetdoc">
      <xsl:value-of select="substring-before($olink.key, '/')"/>
    </xsl:variable>

    <!-- Does the target database use a sitemap? -->
    <xsl:variable name="use.sitemap">
      <xsl:choose>
        <xsl:when test="$target.database//sitemap">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <!-- Get the baseuri for this targetptr -->
    <xsl:variable name="baseuri">
      <xsl:choose>
        <!-- Does the database use a sitemap? -->
        <xsl:when test="$use.sitemap != 0">
          <xsl:choose>
            <!-- Was current.docid parameter set? -->
            <xsl:when test="$current.docid != ''">
              <!-- Was it found in the database? -->
              <xsl:variable name="currentdoc.key">
                <xsl:for-each select="$target.database">
                  <xsl:value-of select="key('targetdoc-key',                                         $current.docid)[1]/@targetdoc"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$currentdoc.key != ''">
                  <xsl:for-each select="$target.database">
                    <xsl:call-template name="targetpath">
                      <xsl:with-param name="dirnode" select="key('targetdoc-key', $current.docid)[1]/parent::dir"/>
                      <xsl:with-param name="targetdoc" select="$targetdoc"/>
                    </xsl:call-template>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="olink.error">
                    <xsl:with-param name="message">
                      <xsl:text>cannot compute relative </xsl:text>
                      <xsl:text>sitemap path because $current.docid '</xsl:text>
                      <xsl:value-of select="$current.docid"/>
                      <xsl:text>' not found in target database.</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="olink.error">
                <xsl:with-param name="message">
                  <xsl:text>cannot compute relative </xsl:text>
                  <xsl:text>sitemap path without $current.docid parameter</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <!-- In either case, add baseuri from its document entry-->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database">
              <xsl:value-of select="key('targetdoc-key', $targetdoc)[1]/@baseuri"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''">
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:when>
        <!-- No database sitemap in use -->
        <xsl:otherwise>
          <!-- Just use any baseuri from its document entry -->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database">
              <xsl:value-of select="key('targetdoc-key', $targetdoc)[1]/@baseuri"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''">
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Is this olink to be active? -->
    <xsl:variable name="active.olink">
      <xsl:choose>
        <xsl:when test="$activate.external.olinks = 0">
          <xsl:choose>
            <xsl:when test="$current.docid = ''">1</xsl:when>
            <xsl:when test="$targetdoc = ''">1</xsl:when>
            <xsl:when test="$targetdoc = $current.docid">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$active.olink != 0">
      <!-- Form the href information -->
      <xsl:if test="not(contains($baseuri, ':'))">
        <!-- if not an absolute uri, add upward path from olink chunk -->
        <xsl:value-of select="$upward.from.path"/>
      </xsl:if>

      <xsl:if test="$baseuri != ''">
        <xsl:value-of select="$baseuri"/>
        <xsl:if test="substring($target.href,1,1) != '#'">
          <!--xsl:text>/</xsl:text-->
        </xsl:if>
      </xsl:if>
      <!-- optionally turn off frag for PDF references -->
      <xsl:if test="not($insert.olink.pdf.frag = 0 and             translate(substring($baseuri, string-length($baseuri) - 3),                       'PDF', 'pdf') = '.pdf'             and starts-with($target.href, '#') )">
        <xsl:value-of select="$target.href"/>
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Computes "../" to reach top -->
<xsl:template name="upward.path">
  <xsl:param name="path" select="''"/>
  <xsl:choose>
    <!-- Don't bother with absolute uris -->
    <xsl:when test="contains($path, ':')"/>
    <xsl:when test="starts-with($path, '/')"/>
    <xsl:when test="contains($path, '/')">
      <xsl:text>../</xsl:text>
      <xsl:call-template name="upward.path">
        <xsl:with-param name="path" select="substring-after($path, '/')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="simple.xlink">
  <xsl:param name="node" select="."/>
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:param name="linkend" select="$node/@linkend"/>
  <xsl:param name="xhref" select="$node/@xl:href"/>

  <!-- check for nested links, which are undefined in the output -->
  <xsl:if test="($linkend or $xhref) and $node/ancestor::*[@xl:href or @linkend]">
    <xsl:message>
      <xsl:text>WARNING: nested link may be undefined in output: </xsl:text>
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name($node)"/>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <xsl:when test="$linkend">
          <xsl:text>@linkend = '</xsl:text>
          <xsl:value-of select="$linkend"/>
          <xsl:text>'&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="$xhref">
          <xsl:text>@xl:href = '</xsl:text>
          <xsl:value-of select="$xhref"/>
          <xsl:text>'&gt;</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text> nested inside parent element </xsl:text>
      <xsl:value-of select="name($node/parent::*)"/>
    </xsl:message>
  </xsl:if>

  <!-- Support for @xl:show -->
  <xsl:variable name="target.show">
    <xsl:choose>
      <xsl:when test="$node/@xl:show = 'new'">_blank</xsl:when>
      <xsl:when test="$node/@xl:show = 'replace'">_top</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="link">
    <xsl:choose>
      <xsl:when test="$xhref and
                      (not($node/@xl:type) or
                      $node/@xl:type='simple')">

        <!-- Is it a local idref or a uri? -->
        <xsl:variable name="is.idref">
          <xsl:choose>
            <!-- if the href starts with # and does not contain an "(" -->
            <!-- or if the href starts with #xpointer(id(, it's just an ID -->
            <xsl:when test="starts-with($xhref,'#')
                      and (not(contains($xhref,'('))
                      or starts-with($xhref,                                        '#xpointer(id('))">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Is it an olink ? -->
        <xsl:variable name="is.olink">
          <xsl:choose>
            <!-- If xl:role="http://docbook.org/xlink/role/olink" -->
            <!-- and if the href contains # -->
            <xsl:when test="contains($xhref,'#') and                  @xl:role = $xolink.role">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$is.olink = 1">
            <xsl:call-template name="olink">
              <xsl:with-param name="content" select="$content"/>
            </xsl:call-template>
          </xsl:when>

          <xsl:when test="$is.idref = 1">

            <xsl:variable name="idref">
              <xsl:call-template name="xpointer.idref">
                <xsl:with-param name="xpointer" select="$xhref"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="targets" select="key('id',$idref)"/>
            <xsl:variable name="target" select="$targets[1]"/>

            <xsl:call-template name="check.id.unique">
              <xsl:with-param name="linkend" select="$idref"/>
            </xsl:call-template>

            <xsl:choose>
              <xsl:when test="count($target) = 0">
                <xsl:message>
                  <xsl:text>XLink to nonexistent id: </xsl:text>
                  <xsl:value-of select="$idref"/>
                </xsl:message>
                <xsl:copy-of select="$content"/>
              </xsl:when>

              <xsl:otherwise>
                <a>
                  <xsl:apply-templates select="." mode="common.html.attributes"/>
                  <!-- id attribute goes on the element calling
                  simple.xlink, not on the anchor element, so
                  this is commented out:
                  <xsl:call-template name="id.attribute"/>
                  -->

                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$target"/>
                    </xsl:call-template>
                  </xsl:attribute>

                  <xsl:choose>
                    <xsl:when test="$node/@xl:title">
                      <xsl:attribute name="title">
                        <xsl:value-of select="$node/@xl:title"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="$target" mode="html.title.attribute"/>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:if test="$target.show !=''">
                    <xsl:attribute name="target">
                      <xsl:value-of select="$target.show"/>
                    </xsl:attribute>
                  </xsl:if>

                  <xsl:copy-of select="$content"/>

                </a>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- otherwise it's a URI -->
          <xsl:otherwise>
            <a>
              <xsl:apply-templates select="." mode="common.html.attributes"/>
              <xsl:call-template name="id.attribute"/>
              <xsl:attribute name="href">
                <xsl:value-of select="$xhref"/>
              </xsl:attribute>
              <xsl:if test="$node/@xl:title">
                <xsl:attribute name="title">
                  <xsl:value-of select="$node/@xl:title"/>
                </xsl:attribute>
              </xsl:if>

              <!-- For URIs, use @xl:show if defined, otherwise use ulink.target -->
              <xsl:choose>
                <xsl:when test="$target.show !=''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$target.show"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:when test="$ulink.target !=''">
                  <xsl:attribute name="target">
                    <xsl:value-of select="$ulink.target"/>
                  </xsl:attribute>
                </xsl:when>
              </xsl:choose>

              <xsl:copy-of select="$content"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$linkend">
        <xsl:variable name="targets" select="key('id',$linkend)"/>
        <xsl:variable name="target" select="$targets[1]"/>

        <xsl:call-template name="check.id.unique">
          <xsl:with-param name="linkend" select="$linkend"/>
        </xsl:call-template>

        <xsl:choose>
         <xsl:when test="count($target)>0">
          <a>
          <xsl:apply-templates select="." mode="common.html.attributes"/>
          <xsl:call-template name="id.attribute"/>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:attribute>

          <xsl:apply-templates select="$target" mode="html.title.attribute"/>

          <xsl:copy-of select="$content"/>

          </a>
         </xsl:when>
         <xsl:otherwise>
          <xsl:copy-of select="$content"/>
         </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
