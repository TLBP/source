<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
<!-- ********************************************************************
     $Id: xmldict.xsl,v 1.4 2002/12/20 23:33:03 nilgun Exp $
     ******************************************************************** -->
<!-- sözcük tanımlarının biçemlenmesi -->
<xsl:variable name="seealso">Ayrıca bakınız:</xsl:variable>
<xsl:variable name="seedesc">Bakınız:</xsl:variable>
<xsl:variable name="synon">Eş anlamlılar:</xsl:variable>
<xsl:variable name="anton">Karşıt anlamlılar:</xsl:variable>
<xsl:variable name="context">Kapsam: </xsl:variable>
<xsl:variable name="sample">Örnek: </xsl:variable>

<xsl:template match="wordinfo">
  <table width="100%"  border="0" cellpadding="5" cellspacing="0">
    <xsl:attribute name="bgcolor">
      <xsl:choose>
        <xsl:when test="name(..) != 'sect1'">
          <xsl:text>white</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>#ffffee</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="@label">
      <tr><td>
        <b style="font-size: 120%"><xsl:value-of select="@label"/></b>
      </td></tr>
    </xsl:if>
    <tr><td>
      <xsl:apply-templates/>
    </td></tr>
  </table>
<!--xsl:message>
<xsl:text>nilgün: </xsl:text>
<xsl:value-of select="translate('nilgün',&lowercase;,&uppercase;)"/>
</xsl:message-->

</xsl:template>

<xsl:template match="context">
  <b><xsl:value-of select="$context"/></b><xsl:value-of select="."/><br/>
</xsl:template>

<xsl:template match="descrlist">
    <ul><xsl:apply-templates select="descr"/></ul><p/>
</xsl:template>

<xsl:template match="descr">
 <li/>
 <span>
  <xsl:attribute name="title">
    <xsl:value-of select="pubdate"/>
  </xsl:attribute>
  <i><xsl:choose>
   <xsl:when test="kind='isim'"><xsl:text>İsim</xsl:text></xsl:when>
   <xsl:when test="kind='fiil'"><xsl:text>Fiil</xsl:text></xsl:when>
   <xsl:when test="kind='kslt'"><xsl:text>Kısaltma</xsl:text></xsl:when>
   <xsl:when test="kind='sıf'"><xsl:text>Sıfat</xsl:text></xsl:when>
   <xsl:otherwise><xsl:value-of select="kind"/></xsl:otherwise>
  </xsl:choose></i>
  <xsl:text> - </xsl:text>
  <!--
  <xsl:apply-templates/>
 </span>
  -->
  <xsl:apply-templates select="para[1]" mode="xmldict"/>
 </span>

  <xsl:apply-templates select="para[position()>1]" mode="xmldict"/>
  <xsl:apply-templates select="refer"/>
</xsl:template>
<xsl:template match="kind|pubdate|title"/>

<xsl:template match="para[1]" mode="xmldict">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="para[position()>1]" mode="xmldict">
  <br/><br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="see-also">
  <b><xsl:value-of select="$seealso"/></b>
  <br/><xsl:text>       </xsl:text>
  <xsl:apply-templates mode="xmldict"/><p/>
</xsl:template>

<xsl:template match="see-desc">
  <b><xsl:value-of select="$seedesc"/></b>
  <xsl:apply-templates mode="xmldict"/><p/>
</xsl:template>

<xsl:template match="synonym">
  <b><xsl:value-of select="$synon"/></b>
  <xsl:apply-templates mode="xmldict"/><p/>
</xsl:template>

<xsl:template match="antonym">
  <b><xsl:value-of select="$anton"/></b>
  <xsl:apply-templates mode="xmldict"/><p/>
</xsl:template>

<xsl:template match="wordde[1]|worden[1]|wordfr[1]|wordtr[1]" mode="xmldict">
  <br/><xsl:text>       </xsl:text>
  <xsl:choose>
    <xsl:when test="name(.)='wordde'">
      <xsl:text>Almanca: </xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='worden'">
      <xsl:text>İngilizce: </xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='wordfr'">
      <xsl:text>Fransızca: </xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='wordtr'">
      <xsl:text>Türkçe: </xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="name(.)='wordtr'">
      <xsl:call-template name="xref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@linkend"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="name(following-sibling::*)=name(.)"><xsl:text>,  </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="wordde|worden|wordfr|wordtr" mode="xmldict">
  <xsl:choose>
    <xsl:when test="name(.)='wordtr'">
      <xsl:call-template name="xref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@linkend"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="name(following-sibling::*)=name(.)"><xsl:text>,  </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="indexterm[substring(@scope,1,4)='entr'][1]
                     |indexterm[substring(@scope,1,4)='detr'][1]
                     |indexterm[substring(@scope,1,4)='frtr'][1]" mode="xmldict">
  <xsl:variable name="lang" select="substring(@scope,1,4)"/>
  <br/><xsl:text>       </xsl:text>
  <xsl:choose>
    <xsl:when test="$lang='detr'">
      <xsl:text>Almanca: </xsl:text>
      <xsl:value-of select="primary"/>
    </xsl:when>
    <xsl:when test="$lang='entr'">
      <xsl:text>İngilizce: </xsl:text>
      <xsl:call-template name="indexterm.href">
        <xsl:with-param name="a.target" select="@scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$lang='frtr'">
      <xsl:text>Fransızca: </xsl:text>
      <xsl:value-of select="primary"/>
    </xsl:when>
  </xsl:choose>
  <xsl:if test="(substring(@scope,1,4)='entr' and following-sibling::*[substring(@scope,1,4)='entr'])
                or (substring(@scope,1,4)='detr' and following-sibling::*[substring(@scope,1,4)='detr'])
                or (substring(@scope,1,4)='frtr' and following-sibling::*[substring(@scope,1,4)='frtr'])">
    <xsl:text>,  </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="xmldict">
  <xsl:variable name="lang" select="substring(@scope,1,4)"/>
  <xsl:choose>
    <xsl:when test="$lang='entr'">
      <xsl:call-template name="indexterm.href">
        <xsl:with-param name="a.target" select="@scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="primary"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="name(following-sibling::*)=name(.)"><xsl:text>,  </xsl:text></xsl:if>
</xsl:template>

<xsl:template name="indexterm.href">
  <xsl:param name="a.target" select="@scope"/>
  <xsl:variable name="targets" select="key('id',$a.target)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:choose>
    <xsl:when test="count($targets)=1">
      <a xmlns="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="href">
          <xsl:text>../</xsl:text>
          <xsl:value-of select="@scope"/>
          <xsl:text>.html#</xsl:text>
          <xsl:value-of select="primary"/>
        </xsl:attribute>
        <xsl:value-of select="primary"/>
      </a>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="primary"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="refer">
  <xsl:variable name="symbol"><xsl:value-of select="."/></xsl:variable>
  <xsl:text> </xsl:text>
  <tt>
  <xsl:text>[</xsl:text>
  <xsl:choose>
    <xsl:when test="$symbol='foldoc'">
     <a href="http://foldoc.doc.ic.ac.uk/foldoc/Dictionary.gz">Foldoc</a>
    </xsl:when>
    <xsl:when test="$symbol='wn'">
     <a href="ftp://clarity.princeton.edu/pub/wordnet/wn1.6unix.tar.gz">WordNet</a>
    </xsl:when>
    <xsl:when test="$symbol='sankur'">
     <a href="http://www.busim.ee.boun.edu.tr/dictionary/index.html">bsd</a>
    </xsl:when>
    <xsl:when test="$symbol='kadifeli'">
     <a href="http://www.kadifeli.com/cgi-bin/compdict.pl">Kadifeli</a>
    </xsl:when>
    <xsl:when test="$symbol='gnu-tr'">
     <a href="http://gnu-tr.sourceforge.net/sozluk.php">gnu-tr</a>
    </xsl:when>
    <xsl:when test="$symbol='tbd'">
     <a href="http://www.tbd.org.tr/sozluk.html">TBD</a>
    </xsl:when>
    <xsl:when test="$symbol='tbd-eski'">
     <a href="http://www.tbd.org.tr/sozluk.html">TBD-eski</a>
    </xsl:when>
    <xsl:when test="$symbol='tdk'">
     <xsl:text>TDK</xsl:text>
    </xsl:when>
    <xsl:when test="$symbol='redhouse'">
     <a href="http://www.redhouse.com.tr">Red House</a>
    </xsl:when>
    <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
   </xsl:choose>
   <xsl:text>]</xsl:text>
   </tt><br/>
</xsl:template>

<xsl:template match="sample">
  <dl>
  <dt><strong>Örnek: </strong></dt>
  <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="msgid">
    <dd><tt><xsl:apply-templates/></tt></dd>
</xsl:template>

<xsl:template match="msgstr">
    <dd><xsl:apply-templates/></dd>
</xsl:template>

</xsl:stylesheet>
