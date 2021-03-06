<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                version="1.0"
                exclude-result-prefixes="doc">

<xsl:import href="docbook.xsl"/>
<xsl:import href="chunk-common.xsl"/>

<!-- ==================================================================== -->

<xsl:template name="process-chunk-element">
  <xsl:choose>
    <xsl:when test="$chunk.first.sections = 0">
      <xsl:call-template name="chunk-first-section-with-parent"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="chunk-all-sections"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process-chunk">
  <xsl:param name="prev" select="."/>
  <xsl:param name="next" select="."/>

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
      <xsl:with-param name="base.dir" select="$base.dir"/>
      <xsl:with-param name="base.name" select="$chunkfn"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="content">
      <xsl:call-template name="chunk-element-content">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="chunk-first-section-with-parent">
  <!-- These xpath expressions are really hairy. The trick is to pick sections -->
  <!-- that are not first children and are not the children of first children -->

  <xsl:variable name="ischunk.next">
    <xsl:if test="self::article">
      <xsl:choose>
        <xsl:when test="following::appendix[1]">
          <xsl:call-template name="chunk">
            <xsl:with-param name="node" select="following::appendix[1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="following::bibliography[1]">
          <xsl:call-template name="chunk">
            <xsl:with-param name="node" select="following::bibliography[1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="following::glossary[1]">
          <xsl:call-template name="chunk">
            <xsl:with-param name="node" select="following::glossary[1]"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="ischunk.prev">
    <xsl:choose>
      <xsl:when test="preceding::appendix[1]">
        <xsl:call-template name="chunk">
          <xsl:with-param name="node" select="preceding::appendix[1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="preceding::bibliography[1]">
        <xsl:call-template name="chunk">
          <xsl:with-param name="node" select="preceding::bibliography[1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="preceding::glossary[1]">
        <xsl:call-template name="chunk">
          <xsl:with-param name="node" select="preceding::glossary[1]"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="prev"
    select="(preceding::book[1]
             |preceding::preface[1]
             |preceding::chapter[1]
             |preceding::appendix[$ischunk.prev>0][1]
             |preceding::part[1]
             |preceding::reference[1]
             |preceding::refentry[1]
             |preceding::colophon[1]

             |preceding::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |preceding::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |preceding::sect2[@chunkthis]

             |preceding::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |preceding::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])][1]

             |preceding::article[1]
             |preceding::bibliography[$ischunk.prev>0][1]
             |preceding::glossary[$ischunk.prev>0][1]
             |preceding::index[1]
             |preceding::setindex[1]
             |preceding::dictionary[1]
             |ancestor::set
             |ancestor::book[1]
             |ancestor::preface[1]
             |ancestor::chapter[1]
             |ancestor::appendix[$ischunk.prev>0][1]

             |ancestor::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |ancestor::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]
             |ancestor::sect2[@chunkthis]

             |ancestor::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |ancestor::section[$chunk.section.depth &gt; count(ancestor::section)
                                and not(ancestor::section[not(preceding-sibling::section)])][1]

             |ancestor::part[1]
             |ancestor::reference[1]
             |ancestor::article[1])[last()]"/>

  <xsl:variable name="next"
    select="(following::book[1]
             |following::preface[1]
             |following::chapter[1]
             |following::appendix[$ischunk.next>0][1]
             |following::part[1]
             |following::reference[1]
             |following::refentry[1]
             |following::colophon[1]

             |following::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |following::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |following::sect2[@chunkthis]

             |following::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |following::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])][1]

             |following::bibliography[$ischunk.next>0][1]
             |following::glossary[$ischunk.next>0][1]
             |following::index[1]
             |following::article[1]
             |following::setindex[1]
             |following::dictionary[1]
             |descendant::book[1]
             |descendant::preface[1]
             |descendant::chapter[1]
             |descendant::appendix[$ischunk.next>0][1]
             |descendant::article[1]
             |descendant::bibliography[$ischunk.next>0][1]
             |descendant::glossary[$ischunk.next>0][1]
             |descendant::index[1]
             |descendant::colophon[1]
             |descendant::setindex[1]
             |descendant::dictionary[1]
             |descendant::part[1]
             |descendant::reference[1]
             |descendant::refentry[1]

             |descendant::sect1[$chunk.section.depth &gt; 0
                               and preceding-sibling::sect1][1]

             |descendant::sect2[$chunk.section.depth &gt; 1
                               and preceding-sibling::sect2
                               and parent::sect1[preceding-sibling::sect1]][1]

             |descendant::sect2[@chunkthis]

             |descendant::sect3[$chunk.section.depth &gt; 2
                               and preceding-sibling::sect3
                               and parent::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::sect4[$chunk.section.depth &gt; 3
                               and preceding-sibling::sect4
                               and parent::sect3[preceding-sibling::sect2]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::sect5[$chunk.section.depth &gt; 4
                               and preceding-sibling::sect5
                               and parent::sect4[preceding-sibling::sect4]
                               and ancestor::sect3[preceding-sibling::sect3]
                               and ancestor::sect2[preceding-sibling::sect2]
                               and ancestor::sect1[preceding-sibling::sect1]][1]

             |descendant::section[$chunk.section.depth &gt; count(ancestor::section)
                                 and preceding-sibling::section
                                 and not(ancestor::section[not(preceding-sibling::section)])])[1]
"/>

  <xsl:call-template name="process-chunk">
    <xsl:with-param name="prev" select="$prev"/>
    <xsl:with-param name="next" select="$next"/>
  </xsl:call-template>
  <!--
  <xsl:message>
   <xsl:value-of select="$prev/@id"/>; <xsl:value-of select="$next/@id"/>
  </xsl:message>
  -->
</xsl:template>

<xsl:template name="chunk-all-sections">
  <xsl:variable name="prev"
    select="(preceding::book[1]
             |preceding::preface[1]
             |preceding::chapter[1]
             |preceding::appendix[1]
             |preceding::part[1]
             |preceding::reference[1]
             |preceding::refentry[1]
             |preceding::colophon[1]

             |preceding::sect1[$chunk.section.depth &gt; 0][1]
             |preceding::sect2[$chunk.section.depth &gt; 1][1]
             |preceding::sect3[$chunk.section.depth &gt; 2][1]
             |preceding::sect4[$chunk.section.depth &gt; 3][1]
             |preceding::sect5[$chunk.section.depth &gt; 4][1]
             |preceding::section[$chunk.section.depth &gt; count(ancestor::section)][1]

             |preceding::sect2[@chunkthis]

             |preceding::article[1]
             |preceding::bibliography[1]
             |preceding::glossary[1]
             |preceding::index[1]
             |preceding::setindex[1]
             |preceding::dictionary[1]
             |ancestor::set
             |ancestor::book[1]
             |ancestor::preface[1]
             |ancestor::chapter[1]
             |ancestor::appendix[1]
             |ancestor::part[1]
             |ancestor::reference[1]
             |ancestor::article[1]
             |ancestor::sect1[$chunk.section.depth &gt; 0][1]
             |ancestor::sect2[$chunk.section.depth &gt; 1][1]
             |ancestor::sect2[@chunkthis]
             |ancestor::sect3[$chunk.section.depth &gt; 2][1]
             |ancestor::sect4[$chunk.section.depth &gt; 3][1]
             |ancestor::sect5[$chunk.section.depth &gt; 4][1]
             |ancestor::section[$chunk.section.depth &gt; count(ancestor::section)][1])[last()]"/>


  <xsl:variable name="next"
    select="(following::book[1]
             |following::preface[1]
             |following::chapter[1]
             |following::appendix[1]
             |following::part[1]
             |following::reference[1]
             |following::refentry[1]
             |following::colophon[1]

             |following::sect1[$chunk.section.depth &gt; 0][1]
             |following::sect2[$chunk.section.depth &gt; 1][1]
             |following::sect3[$chunk.section.depth &gt; 2][1]
             |following::sect4[$chunk.section.depth &gt; 3][1]
             |following::sect5[$chunk.section.depth &gt; 4][1]
             |following::section[$chunk.section.depth &gt; count(ancestor::section)][1]

             |following::sect2[@chunkthis]

             |following::bibliography[1]
             |following::glossary[1]
             |following::index[1]
             |following::article[1]
             |following::setindex[1]
             |following::dictionary[1]
             |descendant::book[1]
             |descendant::preface[1]
             |descendant::chapter[1]
             |descendant::appendix[1]
             |descendant::article[1]
             |descendant::bibliography[1]
             |descendant::glossary[1]
             |descendant::index[1]
             |descendant::colophon[1]
             |descendant::setindex[1]
             |descendant::dictionary[1]
             |descendant::part[1]
             |descendant::reference[1]
             |descendant::refentry[1]

             |descendant::sect1[$chunk.section.depth &gt; 0][1]
             |descendant::sect2[$chunk.section.depth &gt; 1][1]
             |descendant::sect2[@chunkthis]
             |descendant::sect3[$chunk.section.depth &gt; 2][1]
             |descendant::sect4[$chunk.section.depth &gt; 3][1]
             |descendant::sect5[$chunk.section.depth &gt; 4][1]
             |descendant::section[$chunk.section.depth
                                  &gt; count(ancestor::section)][1])[1]"/>

  <xsl:call-template name="process-chunk">
    <xsl:with-param name="prev" select="$prev"/>
    <xsl:with-param name="next" select="$next"/>
  </xsl:call-template>
<!--
  <xsl:message>
   <xsl:value-of select="$prev/@id"/>; <xsl:value-of select="$next/@id"/>
  </xsl:message>
-->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$rootid != ''">
      <xsl:choose>
        <xsl:when test="count(key('id',$rootid)) = 0">
          <xsl:message terminate="yes">
            <xsl:text>ID '</xsl:text>
            <xsl:value-of select="$rootid"/>
            <xsl:text>' not found in document.</xsl:text>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="key('id',$rootid)"/>
          <xsl:if test="$tex.math.in.alt != ''">
            <xsl:apply-templates select="key('id',$rootid)" mode="collect.tex.math"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="/" mode="process.root"/>
      <xsl:if test="$tex.math.in.alt != ''">
        <xsl:apply-templates select="/" mode="collect.tex.math"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="process.root">
  <xsl:param name="owner.id" select="@id"/>

  <xsl:variable name="node" select="document('../../../belgeler.xml')//*[@id=$owner.id]"/>

  <xsl:choose>
    <xsl:when test="($node)">
      <xsl:apply-templates select="$node"/>
    </xsl:when><xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="set|book|part|preface|chapter
                     |article
                     |reference|refentry
                     |book/appendix
                     |book/glossary
                     |book/bibliography
                     |part/appendix
                     |colophon">

  <xsl:call-template name="process-chunk-element"/>
</xsl:template>

<xsl:template match="article/appendix|article/bibliography|article/glossary">
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk = 0">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-chunk-element"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sect1|sect2|sect3|sect4|sect5|section">
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not(parent::*)">
      <xsl:call-template name="process-chunk-element"/>
    </xsl:when>
    <xsl:when test="$ischunk = 0">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-chunk-element"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dictionary|setindex
                     |book/index
                     |part/index
                     |article/index">
  <!-- some implementations use completely empty index tags to indicate -->
  <!-- where an automatically generated index should be inserted. so -->
  <!-- if the index is completely empty, skip it. -->
  <xsl:if test="count(*)>0 or $generate.index != '0'">
    <xsl:call-template name="process-chunk-element"/>
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

<!--
  <xsl:message>
    <xsl:text>in.other.chunk: </xsl:text>
    <xsl:value-of select="name($chunk)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="name($node)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$chunk = $node"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$is.chunk"/>
  </xsl:message>
-->

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
  <xsl:param name="footnotes" select="$node//footnote"/>
  <xsl:param name="count" select="0"/>

<!--
  <xsl:message>
    <xsl:text>count.footnotes.in.this.chunk: </xsl:text>
    <xsl:value-of select="name($node)"/>
  </xsl:message>
-->

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
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$footnotes[1]/ancestor::table
                        |$footnotes[1]/ancestor::informaltable">
          <xsl:call-template name="count.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="count.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
            <xsl:with-param name="count" select="$count + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.footnotes.in.this.chunk">
  <xsl:param name="node" select="."/>
  <xsl:param name="footnotes" select="$node//footnote"/>

<!--
  <xsl:message>process.footnotes.in.this.chunk</xsl:message>
-->

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
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$footnotes[1]/ancestor::table
                        |$footnotes[1]/ancestor::informaltable">
          <xsl:call-template name="process.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$footnotes[1]"
                               mode="process.footnote.mode"/>
          <xsl:call-template name="process.footnotes.in.this.chunk">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="footnotes"
                            select="$footnotes[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.footnotes">
  <xsl:variable name="footnotes" select=".//footnote"/>
  <xsl:variable name="fcount">
    <xsl:call-template name="count.footnotes.in.this.chunk">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="footnotes" select="$footnotes"/>
    </xsl:call-template>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:value-of select="name(.)"/>
    <xsl:text> fcount: </xsl:text>
    <xsl:value-of select="$fcount"/>
  </xsl:message>
-->

  <!-- Only bother to do this if there's at least one non-table footnote -->
  <xsl:if test="$fcount &gt; 0">
    <div class="footnotes">
      <br/>
      <hr width="100" align="left"/>
      <xsl:call-template name="process.footnotes.in.this.chunk">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="footnotes" select="$footnotes"/>
      </xsl:call-template>
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

</xsl:stylesheet>
