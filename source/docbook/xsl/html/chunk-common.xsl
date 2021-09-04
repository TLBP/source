<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version="1.0">


<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <!-- returns 1 if $node is a chunk -->

  <!-- ==================================================================== -->
  <!-- What's a chunk?

       The root element
       appendix
       article
       bibliography  in article or book
       book
       chapter
       colophon
       glossary      in article or book
       index         in article or book
       part
       preface
       refentry
       reference
       sect{1,2,3,4,5}  if position()>1 && depth < chunk.section.depth
       section          if position()>1 && depth < chunk.section.depth
       set
       setindex
                                                                            -->
  <!-- ==================================================================== -->

<!--
  <xsl:message>
    <xsl:text>chunk: </xsl:text>
    <xsl:value-of select="name($node)"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$node/@id"/>
    <xsl:text>)</xsl:text>
    <xsl:text> csd: </xsl:text>
    <xsl:value-of select="$chunk.section.depth"/>
    <xsl:text> cfs: </xsl:text>
    <xsl:value-of select="$chunk.first.sections"/>
    <xsl:text> ps: </xsl:text>
    <xsl:value-of select="count($node/parent::section)"/>
    <xsl:text> prs: </xsl:text>
    <xsl:value-of select="count($node/preceding-sibling::section)"/>
  </xsl:message>
-->

  <xsl:choose>
    <xsl:when test="not($node/parent::*)">1</xsl:when>

    <xsl:when test="local-name($node) = 'sect1'
                    and $chunk.section.depth &gt;= 1
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect1) &gt; 0)">
      <xsl:text>1</xsl:text>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect2'
                    and $chunk.section.depth &gt;= 2
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect2) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect2'
                    and ($node/@chunkthis)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="local-name($node) = 'sect3'
                    and $chunk.section.depth &gt;= 3
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect3) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect4'
                    and $chunk.section.depth &gt;= 4
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect4) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'sect5'
                    and $chunk.section.depth &gt;= 5
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::sect5) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node) = 'section'
                    and $chunk.section.depth &gt;= count(ancestor::section)+1
                    and ($chunk.first.sections != 0
                         or count($node/preceding-sibling::section) &gt; 0)">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="$node/parent::*"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="name($node)='preface'">1</xsl:when>
    <xsl:when test="name($node)='chapter'">1</xsl:when>
    <xsl:when test="name($node)='appendix'
                    and (not (name($node/parent::*) = 'article' and $nochunk.article.children > 0))">1</xsl:when>
    <xsl:when test="name($node)='article'">1</xsl:when>
    <xsl:when test="name($node)='part'">1</xsl:when>
    <xsl:when test="name($node)='reference'">1</xsl:when>
    <xsl:when test="name($node)='refentry'">1</xsl:when>
    <xsl:when test="name($node)='index'
                    and (name($node/parent::*) = 'article'
                         or name($node/parent::*) = 'part'
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='bibliography'
                    and ((name($node/parent::*) = 'article' and $nochunk.article.children = 0)
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='glossary'
                    and ((name($node/parent::*) = 'article' and $nochunk.article.children = 0)
                         or name($node/parent::*) = 'book')">1</xsl:when>
    <xsl:when test="name($node)='colophon'">1</xsl:when>
    <xsl:when test="name($node)='dictionary'">1</xsl:when>
    <xsl:when test="name($node)='book'">1</xsl:when>
    <xsl:when test="name($node)='set'">1</xsl:when>
    <xsl:when test="name($node)='setindex'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="chunk-filename">
  <xsl:param name="recursive" select="false()"/>

  <!-- returns the filename of a chunk -->
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:value-of select="local-name(.)"/>
    <xsl:if test="@id">
      <xsl:text> [</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$ischunk"/>
  </xsl:message>
-->

  <xsl:variable name="dbhtml-filename">
    <xsl:call-template name="dbhtml-filename"/>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$dbhtml-filename != ''">
        <xsl:value-of select="$dbhtml-filename"/>
      </xsl:when>
      <!-- if this is the root element, use the root.filename -->
      <xsl:when test="not(parent::*) and $root.filename != ''">
        <xsl:value-of select="$root.filename"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <!-- if there's no dbhtml filename, and if we're to use IDs as -->
      <!-- filenames, then use the ID to generate the filename. -->
      <xsl:when test="@id and $use.id.as.filename != 0">
        <xsl:value-of select="@id"/>
        <xsl:value-of select="$html.ext"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dir">
    <xsl:call-template name="dbhtml-dir"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk='0'">
      <!-- if called on something that isn't a chunk, walk up... -->
      <xsl:choose>
        <xsl:when test="count(parent::*)>0">
          <xsl:apply-templates mode="chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="$recursive"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- unless there is no up, in which case return "" -->
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not($recursive) and $filename != ''">
      <!-- if this chunk has an explicit name, use it -->
      <xsl:if test="$dir != ''">
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <xsl:when test="name(.)='set'">
      <xsl:value-of select="$root.filename"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='book'">
      <xsl:text>bk</xsl:text>
      <xsl:number level="any" format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='article'">
      <xsl:if test="/set">
        <!-- in a set, make sure we inherit the right book info... -->
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>ar</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='preface'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>pr</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='chapter'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>ch</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='appendix'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>ap</xsl:text>
      <xsl:number level="any" format="a" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='part'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>pt</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='reference'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>rn</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='refentry'">
      <xsl:if test="parent::reference">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>re</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='colophon'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>co</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="local-name(.) = 'sect1'
                    or local-name(.) = 'sect2'
                    or local-name(.) = 'sect3'
                    or local-name(.) = 'sect4'
                    or local-name(.) = 'sect5'
                    or local-name(.) = 'section'">

      <xsl:apply-templates mode="chunk-filename" select="parent::*">
        <xsl:with-param name="recursive" select="true()"/>
      </xsl:apply-templates>
      <xsl:text>s</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='sect1' or name(.)='section'">
      <xsl:apply-templates mode="chunk-filename" select="parent::*">
        <xsl:with-param name="recursive" select="true()"/>
      </xsl:apply-templates>
      <xsl:text>s</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='bibliography'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>bi</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='glossary'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>go</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='index'">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>ix</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='dictionary'">
      <xsl:text>si</xsl:text>
      <xsl:number level="any" format="i" from="set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text>chunk-filename-error-</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:number level="any" format="01" from="set"/>
      <xsl:if test="not($recursive)">
        <xsl:value-of select="$html.ext"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="href.target">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="ownerobject" select="."/>

  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk">
      <xsl:with-param name="node" select="$object"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="this">
    <xsl:apply-templates mode="chunk-filename" select="$ownerobject"/>
  </xsl:variable>

  <xsl:variable name="targetfname">
    <xsl:apply-templates mode="chunk-filename" select="$object"/>
  </xsl:variable>

  <xsl:variable name="target">
    <xsl:choose>
      <xsl:when test="contains($targetfname, 'tr-man')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$targetfname"/>
          <xsl:with-param name="target" select="'tr-man'"/>
          <xsl:with-param name="replace" select="'man'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$targetfname"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$ischunk='0'">
      <xsl:text>#</xsl:text>
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="this.pref">
    <xsl:call-template name="dir.prefix">
      <xsl:with-param name="target" select="$this"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="target.pref">
    <xsl:call-template name="dir.prefix">
      <xsl:with-param name="target" select="$target"/>
    </xsl:call-template>
  </xsl:variable>
<!--
<xsl:if test="($object[@id='tr-man1-md5sum'])">

    <xsl:message>
      <xsl:value-of select="$this"/>;this <xsl:value-of select="$target"/>;target
      <xsl:value-of select="$this.pref"/>;this.pref <xsl:value-of select="$target.pref"/>;target.pref
    </xsl:message>
</xsl:if>
-->
  <xsl:choose>
    <xsl:when test="$owner = 'indexterm' or
                    $owner = 'set.toc' or
                    $owner = 'division.toc' or
                    $owner = 'component.toc'">
      <xsl:choose>
        <xsl:when test="$this.pref='../../../'">
          <xsl:value-of select="concat('../', $target)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$target"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="$this.pref='../../../'">
      <xsl:value-of select="concat('../', $target)"/>
    </xsl:when>

    <xsl:when test="$this.pref='../../'">
      <xsl:value-of select="$target"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<xsl:template name="dir.prefix">
  <xsl:param name="target"/>
  <xsl:param name="target.prefix"/>

  <xsl:choose>
    <xsl:when test="substring-after($target,'/') != ''">
      <xsl:call-template name="dir.prefix">
        <xsl:with-param name="target" select="substring-after($target,'/')"/>
        <xsl:with-param name="target.prefix">
          <xsl:value-of select="concat($target.prefix, '../')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$target.prefix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="dir.dnm.prefix">
  <xsl:param name="target"/>
  <xsl:param name="target.prefix"/>

  <xsl:choose>
    <xsl:when test="substring-before($target,'/') = '..'">
      <xsl:call-template name="dir.prefix">
        <xsl:with-param name="target" select="substring-after($target,'/')"/>
        <xsl:with-param name="target.prefix">
          <xsl:value-of select="concat($target.prefix, '../')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$target.prefix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="html.head">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:variable name="this">
    <xsl:apply-templates mode="chunk-filename" select="."/>
  </xsl:variable>

    <xsl:call-template name="head.content"/>
    <xsl:call-template name="user.head.content"/>

    <xsl:if test="$home">
      <link rel="home">
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$home"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="$home"
                               mode="object.title.markup.textonly"/>
        </xsl:attribute>
      </link>
    </xsl:if>

    <xsl:if test="$up">
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
      <link rel="previous">
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
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="header.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:if test="$suppress.navigation = '0'">
    <table width="100%" summary="Gezinme Çubuğu" cellpadding="1" cellspacing="0" style="border:1px dotted #999999">
      <tr><td>
        <table width="100%" cellpadding="3" cellspacing="0" border="0">
        <xsl:if test="$navig.showtitles != 0">
          <tr>
            <th colspan="3" align="center">
              <xsl:apply-templates select="." mode="object.title.markup"/>
            </th>
          </tr>
        </xsl:if>
          <tr>
            <td width="20%" align="left">
            <xsl:if test="name(.)!='book'">
              <xsl:if test="count($prev)>0">
                <a accesskey="p">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$prev"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'prev'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
              <xsl:text>&#160;</xsl:text>
              </xsl:if>
            </td>
            <th width="60%" align="center">
              <xsl:choose>
                <xsl:when test="count($up) > 0 and $up != $home and $navig.showtitles != 0">
                  <xsl:apply-templates select="$up" mode="object.title.markup"/>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </th>
            <td width="20%" align="right">
              <xsl:text>&#160;</xsl:text>
              <xsl:if test="count($next)>0">
                <a accesskey="n">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$next"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'next'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
            </td>
          </tr>
        </table>
      </td></tr>
    </table>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="footer.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

  <xsl:if test="$suppress.navigation = '0'">
    <!--
    <img width="1" height="1" border="0">
      <xsl:variable name="this">
        <xsl:apply-templates mode="chunk-filename" select="."/>
      </xsl:variable>
      <xsl:attribute name="src">
        <xsl:text>status.php?page=</xsl:text><xsl:value-of select="$this"/>
      </xsl:attribute>
    </img>
    -->
    <div class="eop"/>
    <table width="100%" summary="Gezinme Çubuğu" cellpadding="1" cellspacing="0" style="border:1px dotted #999999">
      <tr><td>
        <table width="100%" cellpadding="3" cellspacing="0" border="0">
          <tr>
            <td width="40%" align="left">
            <xsl:if test="name(.)!='book'">
              <xsl:if test="count($prev)>0">
                <a accesskey="p">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$prev"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'prev'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
              <xsl:text>&#160;</xsl:text>
            </xsl:if>
            </td>
            <td width="20%" align="center">
              <xsl:choose>
                <xsl:when test="count($up)>0">
                  <a accesskey="u">
                    <xsl:attribute name="href">
                      <xsl:call-template name="href.target">
                        <xsl:with-param name="object" select="$up"/>
                      </xsl:call-template>
                    </xsl:attribute>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'up'"/>
                    </xsl:call-template>
                  </a>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </td>
            <td width="40%" align="right">
              <xsl:text>&#160;</xsl:text>
              <xsl:if test="count($next)>0">
                <a accesskey="n">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$next"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:call-template name="navig.content">
                    <xsl:with-param name="direction" select="'next'"/>
                  </xsl:call-template>
                </a>
              </xsl:if>
            </td>
          </tr>
          <tr>
            <td width="40%" align="left" valign="top">
        <xsl:if test="$navig.showtitles != 0">
            <xsl:if test="name(.)!='book'">
              <xsl:apply-templates select="$prev" mode="object.title.markup"/>
            </xsl:if>
        </xsl:if>
              <xsl:text>&#160;</xsl:text>
            </td>
            <td width="20%" align="center">
              <xsl:choose>
                <xsl:when test="$home != .">
                  <a accesskey="h">
                    <xsl:attribute name="href">
                      <xsl:call-template name="href.target">
                        <xsl:with-param name="object" select="$home"/>
                      </xsl:call-template>
                    </xsl:attribute>
                    <xsl:call-template name="navig.content">
                      <xsl:with-param name="direction" select="'home'"/>
                    </xsl:call-template>
                  </a>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </td>
            <td width="40%" align="right" valign="top">
              <xsl:text>&#160;</xsl:text>
              <xsl:if test="$navig.showtitles != 0">
                <xsl:apply-templates select="$next" mode="object.title.markup"/>
              </xsl:if>
            </td>
          </tr>
          <tr>
            <td colspan="3" align="center">
              Bir <a href="http://www.belgeler.org/">Linux Kitaplığı</a> Sayfası
            </td>
          </tr>
        </table>
      </td></tr>
    </table>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="navig.content">
    <xsl:param name="direction" select="next"/>
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

<xsl:template match="processing-instruction('dbhtml')">
  <!-- nop -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="chunk-element-content">
  <xsl:param name="prev"></xsl:param>
  <xsl:param name="next"></xsl:param>

  <xsl:variable name="home" select="/*[1]"/>

  <xsl:variable name="next.path">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="$next"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="trletters"
    select="translate($next.path,'ıİğĞüÜşŞçÇöÖüÜîÎâÂôÔûÛ ','#######################')"/>

  <xsl:if test="$trletters != $next.path">
    <xsl:message>
    <xsl:text>#####################</xsl:text>
    <xsl:value-of select="$trletters"/>; <xsl:text>İstenmeyen karakter içeriyor!</xsl:text>
    </xsl:message>
  </xsl:if>

  <!--
  <xsl:variable name="this.path">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="ancestor-or-self::book"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="this.file">
    <xsl:call-template name="filename-basename">
      <xsl:with-param name="filename" select="$this.path"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="thislastpage"
    select="not(starts-with($next.path,substring-before($this.path,$this.file)))
    and $this.file != 'index.html'"/>
  -->

  <html><head>
    <meta name="date">
      <xsl:attribute name="content">
        <xsl:value-of select="date:date-time()"/>
      </xsl:attribute>
    </meta>
    <xsl:choose>
      <xsl:when test="$next=''">       <!--"$thislastpage"-->
        <xsl:call-template name="html.head">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$home"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="(self::book)">
        <xsl:call-template name="html.head">
          <xsl:with-param name="prev" select="$home"/>
          <xsl:with-param name="next" select="$next"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="html.head">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    </head><body>
      <xsl:call-template name="body.attributes"/>
      <xsl:call-template name="user.header.navigation"/>
      <xsl:choose>
        <xsl:when test="$next=''">       <!--"$thislastpage"-->
          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$home"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(self::book)">
          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$home"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="user.header.content"/>

      <xsl:apply-imports/>

      <xsl:call-template name="user.footer.content"/>

      <xsl:choose>
        <xsl:when test="$next=''">       <!--"$thislastpage"-->
          <xsl:call-template name="footer.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$home"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="(self::book)">
          <xsl:call-template name="footer.navigation">
            <xsl:with-param name="prev" select="$home"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="footer.navigation">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="user.footer.navigation"/>
    </body>
  </html>

</xsl:template>

<xsl:template name="link.target.filename">
  <xsl:param name="this"></xsl:param>
  <xsl:param name="targetfile"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($targetfile, '/')">
      <xsl:text>../</xsl:text>
      <xsl:value-of select="$targetfile"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="contains($this, '/')">
          <xsl:text>../</xsl:text>
          <xsl:value-of select="$targetfile"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$targetfile"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
