<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id:xttoc.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY allcases "'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY sortcases "'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'">

<!ENTITY refname 'concat(refname/@sortas, refname, manvolnum)'>

]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:key name="ref-letter"
         match="refnamediv"
         use="translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="refname"
         match="refnamediv"
         use="&refname;"/>

<xsl:key name="manvolnum"
         match="refnamediv"
         use="../refmeta/manvolnum"/>

<xsl:template name="toc">
<!-- \dottedtocline {girinti} {başlık dizgesi} {sayfano}
\dottedtocline{0em}{1. Giriş}{3}
\dottedtocline{1em}{1.1. Giriş}{3}
\dottedtocline{2em}{1.1.1. Giriş}{3}
\dottedtocline{3em}{1.1.1.1. Giriş}{3}
-->
  <xsl:choose>
    <xsl:when test="name(.) = 'set'">
      <xsl:call-template name="set.toc"/>
    </xsl:when>
    <xsl:when test="name(.) = 'book'">
      <xsl:call-template name="book.toc"/>
    </xsl:when>
    <xsl:when test="name(.) = 'part'">
      <xsl:call-template name="part.toc"/>
    </xsl:when>
    <xsl:otherwise><!-- article -->
      <xsl:call-template name="component.toc"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="set.toc">
  <xsl:variable name="nodes" select="book"/>
  <xsl:if test="$nodes">
<xsl:text>
\secttwo[Kitaplar]
</xsl:text>
    <xsl:apply-templates select="$nodes" mode="toc">
      <xsl:with-param name="owner" select="'set.toc'"/>
      <xsl:with-param name="object" select="."/>
      <xsl:with-param name="level" select="'1'"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="book.toc">
  <xsl:variable name="nodes" select="part|reference
                                    |preface|chapter|appendix
                                    |article
                                    |bibliography|glossary|index"/>
  <xsl:if test="$nodes">
<xsl:text>
\secttwo[İçindekiler]
</xsl:text>
    <xsl:apply-templates select="$nodes" mode="toc">
      <xsl:with-param name="owner" select="'book.toc'"/>
      <xsl:with-param name="object" select="."/>
      <xsl:with-param name="level" select="'1'"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="part.toc">
  <xsl:variable name="nodes" select="preface|chapter|article
                                    |appendix|bibliography|glossary|index"/>
  <xsl:if test="$nodes">
<xsl:text>
\secttwo[Konu Başlıkları]
</xsl:text>
    <xsl:apply-templates select="$nodes" mode="toc">
      <xsl:with-param name="owner" select="'part.toc'"/>
      <xsl:with-param name="object" select="."/>
      <xsl:with-param name="level" select="'1'"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:variable name="nodes" select="preface|simplesect|section|sect1
                                    |bibliography|glossary|index
                                    |appendix"/>
  <xsl:if test="$nodes">
<xsl:text>
\secttwo[Konu Başlıkları]
</xsl:text>
    <xsl:apply-templates select="$nodes" mode="toc">
      <xsl:with-param name="owner" select="'component.toc'"/>
      <xsl:with-param name="object" select="."/>
      <xsl:with-param name="level" select="'1'"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="subtoc">
  <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>

  <xsl:variable name="subtoc"><!--alt gruplama -->
    <xsl:if test="name(.) != $node.toclimit and name(.) != $node.proclevel">
      <xsl:apply-templates mode="toc" select="$nodes">
        <xsl:with-param name="owner" select="$owner"/>
        <xsl:with-param name="object" select="$object"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="is.innerURL">
    <xsl:choose>
      <xsl:when test="$node.proclevel != ''">
<!--xsl:message><xsl:text>proclevel: </xsl:text><xsl:value-of select="$proclevel"/><xsl:text> this: </xsl:text><xsl:value-of select="(ancestor-or-self::book) and $proclevel = 'book'"/></xsl:message-->
        <xsl:if test="not (((ancestor-or-self::book) and $node.proclevel = 'book') or
                ((ancestor-or-self::part) and $node.proclevel = 'part') or
                ((ancestor-or-self::reference) and $node.proclevel = 'reference') or
                ((ancestor-or-self::article) and $node.proclevel = 'article')) and (ancestor-or-self::*[@id=$mainid])">
          <xsl:text>yes</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="(ancestor-or-self::*[@id=$mainid])">
          <xsl:text>yes</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="adres">
    <xsl:call-template name="href.target">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="ownerobject" select="$object"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="title1">
    <xsl:if test="$level = 1"><xsl:text>\bfseries </xsl:text></xsl:if>
    <xsl:apply-templates select="." mode="label.markup"/>
    <xsl:if test="(ancestor::book/@id = 'aik') and name(.) = 'article' and (articleinfo/titleabbrev)">
      <xsl:value-of select="articleinfo/titleabbrev"/>
      <xsl:text> -</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="." mode="xref-to"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:variable name="tit">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat('&#10;', $title1)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="substring($tit,2)"/>
  </xsl:variable>
  <xsl:variable name="toclevel">
    <xsl:call-template name="tocline.indent">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="lnend">
    <xsl:value-of select="@id"/>
  </xsl:variable>
  <xsl:variable name="fname">
    <xsl:call-template name="texize">
      <xsl:with-param name="t" select="@id"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="is.pdf">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="./processing-instruction('dbpdf')"/>
      <xsl:with-param name="attribute">pdf</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$is.pdf = 'no'">
      <xsl:value-of select="concat('&#10;\dottedtocline', $toclevel, '{', $title, '~}{sadece HTML}')"/>
    </xsl:when>
    <xsl:when test="not (@id)">
      <!-- ID'si yoksa bizim çocuklardan biri-->
      <xsl:variable name="pdata">
        <xsl:call-template name="object.id"/>
      </xsl:variable>
      <xsl:value-of select="concat('&#10;\dottedtocline', $toclevel, '{\innerURL{\hyperlink{', $pdata, '}{', $title, '~}}}{\pageref*{', $pdata, '}}')"/>
    </xsl:when>
    <xsl:when test="$is.innerURL = 'yes'">
    <!-- bizim çocuklardan biri-->
      <xsl:value-of select="concat('&#10;\dottedtocline', $toclevel, '{\innerURL{\hyperlink{', $lnend, '}{', $title, '~}}}{\pageref*{', @id, '}}')"/>
    </xsl:when>
    <xsl:otherwise><!-- başka belge-->
      <xsl:value-of select="concat('&#10;\dottedtocline', $toclevel, '{\URLtext{\href{', $adres, '}{', $title, '~}}}{', $fname, '.pdf}')"/>
      <xsl:if test="(./*/abstract) and name($object) != name(.)
                    and (name($object) = 'book' or name($object) = 'set' or name($object) = 'part')">
        <xsl:variable name="p2">
          <xsl:apply-templates select="./*/abstract/para[1]" mode="subtoc.titleabbrev"/>
        </xsl:variable>
        <xsl:value-of select="concat('&#10;\enhanceindent\indentedpar{\addvspace{-6pt}', $p2, '}\reduceindent')"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="is.outernode">
    <xsl:call-template name="is_outernode"/>
  </xsl:variable>
  <xsl:copy-of select="$subtoc"/>
  <!--xsl:choose>
    <xsl:when test="name($object) = 'book' and
                (name($nodes)='part' or
                 name($nodes)='preface' or
                 name($nodes)='article' or
                 name($nodes)='chapter' or
                 name($nodes)='appendix' or
                 name($nodes)='reference')">
      <xsl:copy-of select="$subtoc"/>
    </xsl:when>
    <xsl:when test="name($object) != 'set' and
                    name($object) != 'book' and
                    name($object) != 'part' and
                    (name($nodes) = 'sect1' or
                     name($nodes) = 'sect2' or
                     name($nodes) = 'sect3')">
      <xsl:copy-of select="$subtoc"/>
    </xsl:when>
  </xsl:choose-->
</xsl:template>

<xsl:template match="*" mode="subtoc.titleabbrev"/>

<xsl:template match="titleabbrev" mode="subtoc.titleabbrev">
  <xsl:text>  -  </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="abstract/para[1]" mode="subtoc.titleabbrev">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="book|setindex" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="nodes" select="part|reference
                                          |preface|chapter|appendix
                                          |article
                                          |bibliography|glossary|index"/>
    </xsl:call-template>
 </xsl:template>

<xsl:template match="part|reference" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="level" select="$level"/>
    <xsl:with-param name="nodes" select="appendix|chapter|article
                                         |index|glossary|bibliography
                                         |preface|reference|refentry"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="appendix|index|section|sect1"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:if test="not (@status) or @status != 'outtoc'">
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="nodes" select="section|sect1"/>
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="sect1" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect2"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect2" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect3"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect3" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect4"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect4" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="nodes" select="sect5"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sect5|simplesect" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bibliography|glossary" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="owner" select="$owner"/>
    <xsl:with-param name="object" select="$object"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="level" select="$level"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="index|dictionary" mode="toc">
  <xsl:param name="owner" select="''"/>
  <xsl:param name="object" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="level" select="'1'"/>
  <!-- If the index tag is empty, don't point at it from the TOC -->
  <xsl:if test="not (@status) or @status != 'outtoc'">
    <xsl:call-template name="subtoc">
      <xsl:with-param name="owner" select="$owner"/>
      <xsl:with-param name="object" select="$object"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="refentry.toc">
  <xsl:param name="volnum" select="none"/>
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('manvolnum', $volnum)[translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)=$letter]) > 0">
      <xsl:value-of select="concat('&#10;\sectone[', $letter, ']')"/>
      <xsl:apply-templates select="key('manvolnum', $volnum)[translate(substring(&refname;, 1, 1),&lowercase;,&uppercase;)=$letter]"
                               mode="reftoc">
        <xsl:sort select="translate(&refname;,&allcases;,&sortcases;)"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:call-template name="refentry.toc">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
      <xsl:with-param name="volnum" select="$volnum"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="refnamediv" mode="reftoc">
  <xsl:apply-templates mode="reftoc"/>
</xsl:template>

<xsl:template match="refname" mode="reftoc">
  <xsl:variable name="pos"><xsl:number/></xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="texize">
      <xsl:with-param name="t" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="adres">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="../.."/>
      <xsl:with-param name="ownerobject" select="ancestor::book"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fname">
    <xsl:call-template name="texize">
      <xsl:with-param name="t" select="substring($adres, 13)"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;\dottedtocline{0em}{\URLtext{\href{', $adres, '}{', $title, '~}}}{', $fname, '}')"/>
<xsl:text>
\enhanceindent\indentedpar{\addvspace{-9pt}</xsl:text>
  <xsl:call-template name="texize">
    <xsl:with-param name="t">
      <xsl:value-of select="../refpurpose[position() = $pos]"/>
    </xsl:with-param>
  </xsl:call-template>
<xsl:text>}\vspace{-6pt}\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="*" mode="reftoc"/>

<!-- ==================================================================== -->

<xsl:template name="tocline.indent">
  <xsl:param name="level" select="'1'"/>
  <xsl:choose>
    <xsl:when test="$level = '1'">
      <xsl:text>{0em}</xsl:text>
    </xsl:when>
    <xsl:when test="$level = '2'">
      <xsl:text>{1.25em}</xsl:text>
    </xsl:when>
    <xsl:when test="$level = '3'">
      <xsl:text>{2.5em}</xsl:text>
    </xsl:when>
    <xsl:when test="$level = '4'">
      <xsl:text>{3.75em}</xsl:text>
    </xsl:when>
    <xsl:when test="$level = '5'">
      <xsl:text>{5em}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>{6.25em}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template match="*" mode="label.markup"/>

<xsl:template match="book" mode="label.markup">
   <xsl:number level="any" count="book" format="1."/><xsl:text>Kitap - </xsl:text>
</xsl:template>

<xsl:template match="part" mode="label.markup">
   <xsl:number format="I."/>
</xsl:template>

<xsl:template match="reference" mode="label.markup">
  <xsl:number from="book" count="reference" format="I." level="any"/>
</xsl:template>

<xsl:template match="article|chapter|
                     appendix|bibliography|glossary|
                     sect1|sect2|sect3|sect4|sect5"
               mode="label.markup">
  <xsl:if test="(ancestor-or-self::chapter)">
    <xsl:number count="chapter|article" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::article[@id!=$mainid])">
    <xsl:number count="chapter|article" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::appendix[name(..)='article']) or
                (ancestor-or-self::bibliography[name(..)='article']) or
                (ancestor-or-self::glossary[name(..)='article'])">
    <xsl:number from="article"
                count="appendix|bibliography|glossary"
                format="A." level="any"/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::appendix[name(..)='book']) or
                (ancestor-or-self::bibliography[name(..)='book']) or
                (ancestor-or-self::glossary[name(..)='book'])">
    <xsl:number from="book"
                count="appendix|bibliography|glossary"
                format="A." level="any"/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::sect1)">
    <xsl:number count="sect1" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::sect2)">
    <xsl:number count="sect2" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::sect3)">
    <xsl:number count="sect3" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::sect4)">
    <xsl:number count="sect4" format="1."/>
  </xsl:if>
  <xsl:if test="(ancestor-or-self::sect5)">
    <xsl:number count="sect5" format="1."/>
  </xsl:if><xsl:text> </xsl:text>
</xsl:template>

</xsl:stylesheet>