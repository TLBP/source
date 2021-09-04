<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xtxref.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->
<!DOCTYPE xsl:stylesheet [
<!ENTITY uplisting "
  (ancestor::itemizedlist) or (ancestor::orderedlist) or
  (ancestor::variablelist) or (ancestor::glosslist)">
<!ENTITY upnotes "
 (ancestor::note) or (ancestor::warning) or (ancestor::caution) or
 (ancestor::tip) or (ancestor::important)">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<!--xsl:template name="id.replace">
  <xsl:param name="id"></xsl:param>
  <xsl:value-of select="$id"/>
</xsl:template-->

<xsl:template name="anchor">
  <xsl:param name="oid" select="@id"/>
  <xsl:variable name="objid">
    <xsl:call-template name="anchor.id">
      <xsl:with-param name="oid" select="$oid"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;\hypertarget{', $objid,'}{}')"/>
</xsl:template>

<xsl:template name="anchor.label">
  <xsl:param name="oid" select="@id"/>
  <xsl:variable name="objid">
    <xsl:call-template name="anchor.id">
      <xsl:with-param name="oid" select="$oid"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('\label{', $objid,'}')"/>
</xsl:template>

<xsl:template name="anchor.id">
  <xsl:param name="oid" select="@id"/>
  <xsl:variable name="objid">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="not (@id) and $oid != ''">
      <xsl:value-of select="$oid"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$objid"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="link">
  <xsl:variable name="caption">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="xref">
    <xsl:with-param name="docname" select="normalize-space($caption)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="link[(ancestor::refentry) and not (child::node())]">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:variable name="name">
    <xsl:value-of select="."/>
  </xsl:variable>

  <xsl:variable name="volnum">
    <xsl:value-of select="substring-before(substring-after(@linkend, 'man'), '-')"/>
  </xsl:variable>

  <xsl:variable name="im">
    <xsl:value-of select="concat('man', $volnum, '-')"/>
  </xsl:variable>

  <xsl:variable name="fname">
    <xsl:call-template name="texize">
      <xsl:with-param name="t"  select="substring-after(@linkend, $im)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($target) = 0 and (@xreflabel)">
      <xsl:value-of select="concat('\tuserinput{', @xreflabel, '}~[\tmonospace{', $fname, '(', $volnum, ')}]')"/>
    </xsl:when>
    <xsl:when test="count($target) = 0 and not (@xreflabel)">
      <xsl:value-of select="concat('\tuserinput{', $fname, '(', $volnum, ')}')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="adres">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="$target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="(@xreflabel)">
          <xsl:value-of select="concat('\tuserinput{', @xreflabel, '}~[\URLtext{\href{', $adres, '}{{\tt ', $fname, '(', $volnum, ')}}}]')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('\URLtext{\href{', $adres, '}{\tt\boldface{', $fname, '(', $volnum, ')}}}')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="xref" name="xref">
  <xsl:param name="docname" select="''"/>
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:message>
        <xsl:text>*******************Link to nonexistent id: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
      <xsl:if test="$docname != ''">
        <xsl:value-of select="$docname"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="is.innerURL">
        <xsl:call-template name="is_innerURL"/>
      </xsl:variable>
      <xsl:variable name="title0">
        <xsl:choose>
          <xsl:when test="$docname != ''">
            <xsl:value-of select="$docname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$target" mode="xref-to"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="title">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$title0"/>
          <xsl:with-param name="target" select="' '"/>
          <xsl:with-param name="replace" select="' '"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$is.innerURL = 'yes'
                        and name($target) = 'biblioentry'">
          <xsl:value-of select="concat('\innerURL{\hyperlink{', @linkend, '}{', normalize-space($title), '}}')"/>
        </xsl:when>
        <xsl:when test="$is.innerURL = 'yes'
                        and name($target) != 'biblioentry'">
          <xsl:value-of select="concat('\innerURL{\hyperlink{', @linkend, '}{', normalize-space($title), '}} (sayfa: \pageref*{', @linkend, '})')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="adres">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="ftmark">
            <xsl:call-template name="link.id"/>
          </xsl:variable>
          <xsl:value-of select="concat('\URLtext{\href{', $adres, '}{', normalize-space($title), '}}')"/>
          <xsl:if test="not (ancestor::refentry)">
            <xsl:value-of select="concat('\URLtext{\otherbacknote{', $ftmark, '}}')"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="is_innerURL">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:choose>
    <xsl:when test="$node.proclevel != ''">
  <xsl:if test="not
    ((($target/ancestor-or-self::book) and $node.proclevel = 'book') or
    (($target/ancestor-or-self::part) and $node.proclevel = 'part') or
    (($target/ancestor-or-self::reference) and $node.proclevel = 'reference') or
    (($target/ancestor-or-self::article) and $node.proclevel = 'article') or
    (($target/ancestor-or-self::refentry) and $node.proclevel = 'refentry')) and ($target/ancestor-or-self::*[@id=$mainid])">
        <xsl:text>yes</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="($target/ancestor-or-self::*[@id=$mainid])">
        <xsl:text>yes</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="xref-to"/>
<xsl:template match="*" mode="subtitle"/>

<xsl:template match="*[(title)]" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[(subtitle)]" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[(@xreflabel)]" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="@xreflabel"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bridgehead|term|glossterm" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="glossentry" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="glossterm[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="varlistentry" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="term[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="question" mode="xref-to">
  <xsl:variable name="qanum">
    <xsl:call-template name="object.num"/>
  </xsl:variable>
  <xsl:value-of select="concat('Soru ', $qanum)"/>
</xsl:template>

<xsl:template match="set" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle|setinfo/subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="set" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title|setinfo/title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="book" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle|bookinfo/subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="book" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title|bookinfo/title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="part" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle|partinfo/subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="part" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title|partinfo/title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="reference" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle|referenceinfo/subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="reference" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title|referenceinfo/title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article" mode="subtitle">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="subtitle|articleinfo/subtitle"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article" mode="xref-to">
  <xsl:call-template name="texize">
    <xsl:with-param name="t" select="title|articleinfo/title"/>
  </xsl:call-template>
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

  <xsl:variable name="target">
    <xsl:apply-templates mode="chunk-filename" select="$object"/>
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
  <xsl:variable name="result">
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
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($result, 'tr-man')">
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="$result"/>
        <xsl:with-param name="target" select="'tr-man'"/>
        <xsl:with-param name="replace" select="'man'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$result"/>
    </xsl:otherwise>
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
<!-- ==================================================================== -->
<xsl:template name="chunk">
  <xsl:param name="node" select="."/>
  <!-- returns 1 if $node is a chunk -->
  <!-- What's a chunk?
      PDF dosyası olabilen bir elemandır. -->

  <xsl:choose>
    <!--xsl:when test="not($node/parent::*)">1</xsl:when-->
    <xsl:when test="name($node)='article'">1</xsl:when>
    <xsl:when test="name($node)='part' and
                 (ancestor::book[@id='apps'])">1</xsl:when>
    <xsl:when test="name($node)='refentry'">1</xsl:when>
    <xsl:when test="name($node)='book'">1</xsl:when>
    <xsl:when test="name($node)='set'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

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
      <xsl:when test="@id">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="@id"/>
          <xsl:with-param name="target" select="'.'"/>
          <xsl:with-param name="replace" select="'-'"/>
        </xsl:call-template>
        <!--xsl:value-of select="@id"/--><xsl:text>.pdf</xsl:text>
        <xsl:if test="$ischunk!='0' and contains(@id, '.')">
          <xsl:message>
            <xsl:value-of select="@id"/><xsl:text>.pdf</xsl:text>
          </xsl:message>
        </xsl:if>
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
        <xsl:text>.pdf</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='book'">
      <xsl:text>bk</xsl:text>
      <xsl:number level="any" format="01"/>
      <xsl:if test="not($recursive)">
        <xsl:text>.pdf</xsl:text>
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
        <xsl:text>.pdf</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:when test="name(.)='part' and
                 (ancestor::book[@id='apps'])">
      <xsl:if test="/set">
        <xsl:apply-templates mode="chunk-filename" select="parent::*">
          <xsl:with-param name="recursive" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>pt</xsl:text>
      <xsl:number level="any" format="01" from="book"/>
      <xsl:if test="not($recursive)">
        <xsl:text>.pdf</xsl:text>
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
        <xsl:text>.pdf</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>chunk-filename-error-</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:number level="any" format="01" from="set"/>
      <xsl:if test="not($recursive)">
       <xsl:text>.pdf</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ulink">
  <xsl:choose>
    <xsl:when test="contains(@url,'mailto:')">
      <xsl:variable name="addr">
        <xsl:call-template name="nospam">
          <xsl:with-param name="p" select="substring-after(@url,'mailto:')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="$addr"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
          <xsl:value-of select="concat(' \othermail{', $addr, '} ')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="@url = 'fdl.html'">
      <xsl:text>\innerURL{\hyperlink{gfdl}{GNU Free Documentation License}} (sayfa: \pageref*{gfdl})</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="adres">
        <xsl:call-template name="url.texize"/>
      </xsl:variable>
      <xsl:variable name="ftmark">
        <xsl:call-template name="link.id"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="concat('\URL{', $adres, '}')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="content1">
            <xsl:apply-templates/>
          </xsl:variable>
          <xsl:variable name="content">
            <xsl:call-template name="string.replace">
              <xsl:with-param name="string" select="$content1"/>
              <xsl:with-param name="target" select="' '"/>
              <xsl:with-param name="replace" select="' '"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="ftaddr">
            <xsl:choose>
              <xsl:when test="string-length($adres)>88 and contains(substring($adres,70), '-')">
                <xsl:variable name="hypless">
                  <xsl:value-of select="substring-before(substring($adres,70), '-')"/>
                </xsl:variable>
                <xsl:value-of select="concat('\url{', substring($adres,1, 69+string-length($hypless)), '-\ ', substring-after(substring($adres,70), '-'), '}')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('\URL{',$adres, '}')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="&uplisting; or &upnotes;">
              <xsl:value-of select="concat('\URLtext{\href{', $adres, '}{', $content, '}}\otherbacknote{', $ftmark, '}')"/>
            </xsl:when>
            <xsl:when test="(ancestor::footnote) or (ancestor::refentry)">
              <xsl:value-of select="concat('\URLtext{\href{', $adres, '}{', $content, '}} (', $ftaddr, ')')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('\URLtext{\href{', $adres, '}{', $content, '}}\otherbacknote{', $ftmark, '}')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
