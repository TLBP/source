<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "name(..) =literallayout'
                or name(../..) ='literallayout'
                or name(..) ='screen'
                or name(../..) ='screen'
                or name(..) ='synopsis'
                or name(../..) ='synopsis'
                or name(..) ='programlisting'
                or name(../..) ='programlisting'">

<!ENTITY indented "name(..) = 'glossdef'
                or name(..) = 'listitem'
                or name(../..) = 'caution'
                or name(../..) = 'note'
                or name(../..) = 'warning'
                or name(../..) = 'important'
                or name(../..) = 'tip'
                or name(../..) = 'blockquote'">
<!ENTITY allcases  "'aâbcçdefgğhıiîjklmnoöôpqrsştuüûvwxyzAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
<!ENTITY uppercases "'AÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  extension-element-prefixes="d xlink"
  version='1.0'>

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:template name="string.replace">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="replace"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),$replace)"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="substring-after($string,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replace" select="$replace"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trimleft">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string, '&#10; ')">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat(substring-before($string,'&#10; '),
                            '&#10;', substring-after($string,'&#10; '))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*">
  <!--xsl:message>
    <xsl:text>
İşlemsiz etiket: </xsl:text><xsl:value-of select="name(.)"/>

  </xsl:message-->
</xsl:template>
<xsl:template match="title"/>

<xsl:template match="text()">
  <xsl:call-template name="trimleft">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="title">
  <xsl:variable name="string">
   <xsl:value-of select="normalize-space(d:title)"/>
  </xsl:variable>
  <xsl:value-of select="translate($string, &allcases;, &uppercases;)"/>
</xsl:template>

<xsl:template match="d:refmeta">
  <xsl:variable name="p">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="d:refentrytitle"/>
    <xsl:text>" </xsl:text>
    <xsl:value-of select="d:manvolnum"/>
    <xsl:text> "</xsl:text>
    <xsl:value-of select="d:refmiscinfo[@otherclass='date']"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:refmiscinfo[@otherclass='domain']"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="d:refmiscinfo[@otherclass='header']"/>
    <xsl:text>"</xsl:text>
  </xsl:variable>
<xsl:text>
.TH </xsl:text><xsl:value-of select="normalize-space($p)"/>
<xsl:text>
.nh
.PD 0</xsl:text>
</xsl:template>

<xsl:template match="d:refnamediv">
  <xsl:if test="position() > 1">
<xsl:text>
.br</xsl:text>
    <xsl:call-template name="linkme"/>
  </xsl:if>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
<xsl:text>
</xsl:text>
  <xsl:value-of select="normalize-space($content)"/>
</xsl:template>

<xsl:template match="d:refnamediv[1]">
<xsl:text>
.SH İSİM</xsl:text>
<xsl:variable name="content">
<xsl:apply-templates/>
</xsl:variable>
<xsl:text>
</xsl:text>
<xsl:value-of select="normalize-space($content)"/>
</xsl:template>

<xsl:template match="d:refname">
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:text> - </xsl:text>
</xsl:template>

<xsl:template match="d:refpurpose">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsynopsisdiv">
<xsl:text>
.SH KULLANIM</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsect1">
<xsl:text>
.SH </xsl:text><xsl:value-of select="d:title"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsect2">
<xsl:text>
.SS </xsl:text><xsl:value-of select="d:title"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsect3">
<xsl:text>
.B </xsl:text><xsl:value-of select="d:title"/>
<xsl:text>
.RS 4</xsl:text>
<xsl:apply-templates/>
<xsl:text>
.RE</xsl:text>
</xsl:template>

<xsl:template match="d:literallayout|d:screen|d:synopsis|d:programlisting">
  <xsl:if test="(&indented;)">
<xsl:text>
.IP
.RS</xsl:text>
  </xsl:if>
  <xsl:if test="@indent and @indent > 0">
<xsl:text>
.RS </xsl:text><xsl:value-of select="@indent"/>
  </xsl:if>
<xsl:text>
.nf</xsl:text>
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($p, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p1"/>
  <xsl:variable name="pn">
    <xsl:value-of select="substring($p, string-length($p), 1)"/>
  </xsl:variable>
  <xsl:if test="$pn!='&#10;'">
<xsl:text>
</xsl:text>
  </xsl:if>
<xsl:text>.fi
</xsl:text>
  <xsl:if test="@indent and @indent > 0">
<xsl:text>
.RE</xsl:text>
  </xsl:if>
  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
</xsl:template>
<!--
<xsl:template match="synopsis">
  <xsl:text>&#10;.nf</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>>&#10;.fi</xsl:text>
</xsl:template>
-->
<xsl:template match="d:para">
  <xsl:if test="name(..)='glossdef' and (preceding-sibling::d:para/child::d:glosslist)">
<xsl:text>
.IP </xsl:text><xsl:value-of select="../../@userlevel"/>
  </xsl:if>
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="pr">
    <xsl:choose>
      <xsl:when test="not(starts-with($p, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="trimleft">
    <xsl:with-param name="string" select="$pr"/>
  </xsl:call-template>
  <xsl:if test="not (@condition) or @condition != 'nospace'">
<xsl:text>
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:uri">
  <xsl:variable name="ext">
    <xsl:value-of select="substring-before(substring-after(@xlink:href,'tr-man'), '-')"/>
  </xsl:variable>
  <xsl:variable name="base">
    <xsl:value-of select="substring-after(@xlink:href, concat('tr-man', $ext, '-'))"/>
  </xsl:variable>
  <xsl:variable name="statement">
    <xsl:value-of select="."/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$statement !=''">
      <xsl:value-of select="concat('\fB', $statement, '\fR [', $base, '(', $ext, ')]')"/>
    </xsl:when>
    <xsl:when test="(@xreflabel)">
      <xsl:value-of select="concat('\fB', @xreflabel, '\fR [', $base, '(', $ext, ')]')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('\fB', $base, '(', $ext, ')\fR')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:xref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]/d:title"/>
  <xsl:value-of select="concat('\fB', $target,'\fR')"/>
</xsl:template>

<xsl:template match="d:glosslist|d:variablelist">
<!--xsl:message>
<xsl:value-of select="name(..)"/>
</xsl:message-->
  <xsl:choose>
    <xsl:when test="(&indented;)">
<xsl:text>
.RS 6</xsl:text>
      <!--xsl:if test="not (d:term or d:glossterm)">
        <xsl:value-of select="../../../../@userlevel"/>
      </xsl:if-->
      <xsl:apply-templates/>
<xsl:text>
.RE
.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:itemizedlist|d:orderedlist">
  <xsl:choose>
    <xsl:when test="(&indented;)">
      <xsl:value-of select="concat('.RS ', ../../../../@userlevel)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossentry">
  <xsl:variable name="p">
    <xsl:number from="d:glosslist" count="d:glossentry" format="1"/>
  </xsl:variable>
  <xsl:variable name="pos" select="$p - 1"/>
  <xsl:choose>
    <xsl:when test="not (d:glossterm) and not (ancestor::d:glossdef or ancestor::d:listitem)">
      <xsl:value-of select="concat('&#10;.IP ', ../@userlevel)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (../d:glossentry[$pos]/d:glossdef)">
        <xsl:text>&#10;.br&#10;.ns</xsl:text>
      </xsl:if>
      <xsl:variable name="terms">
        <xsl:apply-templates select="d:glossterm"/>
      </xsl:variable>
      <xsl:value-of select="concat('&#10;.TP ', ../@userlevel, '&#10;', normalize-space($terms))"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="d:glossdef"/>
  <xsl:if test="count(../d:glossentry)&lt;$p+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="d:varlistentry">
  <xsl:variable name="p">
    <xsl:number from="d:variablelist" count="d:varlistentry" format="1"/>
  </xsl:variable>
  <xsl:variable name="pos" select="$p - 1"/>
  <xsl:choose>
    <xsl:when test="not (d:term) and not (ancestor::d:glossdef or ancestor::d:listitem)">
      <xsl:value-of select="concat('.IP ', ../@userlevel, '&#10;')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (../d:varlistentry[$pos]/d:listitem)">
        <xsl:text>&#10;.br&#10;.ns</xsl:text>
      </xsl:if>
      <xsl:variable name="terms">
        <xsl:apply-templates select="d:term"/>
      </xsl:variable>
      <xsl:value-of select="concat('&#10;.TP ', ../@userlevel, '&#10;', normalize-space($terms))"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="d:listitem"/>
  <xsl:if test="count(../d:varlistentry)&lt;$p+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="d:glossterm">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
<xsl:value-of select="normalize-space($content)"/>
  <xsl:if test="name(following-sibling::*)='glossterm'">
<xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:term">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
<xsl:value-of select="normalize-space($content)"/>
  <xsl:if test="name(following-sibling::*)='term'">
<xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:glossdef|d:varlistentry/d:listitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:itemizedlist/d:listitem">
  <xsl:variable name="pos">
    <xsl:number from="d:orderedlist" count="d:listitem" format="1"/>
  </xsl:variable>
  <xsl:variable name="p">
<xsl:text>
.IP </xsl:text>
    <xsl:choose>
      <xsl:when test="../@mark='disc'">
<xsl:text>\fBo\fR </xsl:text>
      </xsl:when>
      <xsl:when test="../@mark='square'">
<xsl:text>\fB-\fR </xsl:text>
      </xsl:when>
      <xsl:otherwise>
<xsl:text>\fB·\fR </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="../@userlevel"/>
  </xsl:variable>
  <xsl:value-of select="$p"/>
  <xsl:variable name="pp">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($pp, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $pp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p1"/>
  <xsl:if test="count(../d:listitem)&lt;$pos+1">
<xsl:text>
.PP</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem">
  <xsl:variable name="pos">
    <xsl:number from="d:orderedlist" count="d:listitem" format="1"/>
  </xsl:variable>
  <xsl:variable name="p">
<xsl:text>
.IP </xsl:text>
    <xsl:choose>
      <xsl:when test="../@numeration='arabic'">
<xsl:number from="d:orderedlist" count="d:listitem" format="1."/>
      </xsl:when>
      <xsl:when test="../@numeration='loweralpha'">
<xsl:number from="d:orderedlist" count="d:listitem" format="a."/>
      </xsl:when>
      <xsl:when test="../@numeration='lowerroman'">
<xsl:number from="d:orderedlist" count="d:listitem" format="i."/>
      </xsl:when>
      <xsl:when test="../@numeration='upperalpha'">
<xsl:number from="d:orderedlist" count="d:listitem" format="A."/>
      </xsl:when>
      <xsl:when test="../@numeration='upperroman'">
<xsl:number from="d:orderedlist" count="d:listitem" format="I."/>
      </xsl:when>
      <xsl:otherwise>
<xsl:number from="d:orderedlist" count="d:listitem" format="1."/>
      </xsl:otherwise>
    </xsl:choose>
<xsl:text> </xsl:text><xsl:value-of select="../@userlevel"/>
  </xsl:variable>
  <xsl:value-of select="$p"/>
  <xsl:variable name="pp">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($pp, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $pp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<xsl:value-of select="$p1"/>
  <xsl:if test="count(../d:listitem)&lt;$pos+1">
<xsl:text>
.PP</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:acronym|d:classname|d:function|d:literal|d:productname|d:prompt|d:statement|d:symbol|d:type">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:application|d:command|d:constant|d:emphasis|d:envar|d:filename|d:keyword|d:option|d:replaceable|d:userinput|d:quote|d:small|d:varname|d:wordasword">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="name(.)='application' or
                    name(.)='envar' or
                    name(.)='command' or
                    name(.)='constant' or
                    name(.)='keyword' or
                    name(.)='option' or
                    name(.)='userinput' or
                    (name(.)='emphasis' and @role='bold')">
<xsl:value-of select="concat('\fB', $p, '\fR')"/>
    </xsl:when>
    <xsl:when test="name(.)='quote'">
<xsl:text>"</xsl:text>
<xsl:value-of select="$p"/>
<xsl:text>"</xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='small'">
<xsl:value-of select="concat('\s-1', $p, '\s0')"/>
    </xsl:when>
    <xsl:otherwise>
<xsl:value-of select="concat('\fI', $p, '\fR')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:email">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="concat('&lt;', $p, '>')"/>
    <xsl:with-param name="target" select="'@'"/>
    <xsl:with-param name="replace" select="' (at) '"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:blockquote">
  <xsl:if test="(&indented;)">
    <xsl:value-of select="concat('&#10;.RS ', ../../../../@userlevel)"/>
  </xsl:if>
<xsl:text>
.IP</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
.PP</xsl:text>
  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
</xsl:template>
<xsl:template match="d:link">
  <xsl:choose>
    <xsl:when test="count(child::node())=0">
<xsl:value-of select="@xlink:href"/>
    </xsl:when>
    <xsl:otherwise>
<xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="d:sbr">
<xsl:text>
.br
</xsl:text>
</xsl:template>
<xsl:template match="d:warning|d:caution|d:note|d:important|d:tip">
  <xsl:param name="etiket"><xsl:value-of select="d:title"/></xsl:param>
  <xsl:if test="(&indented;)">
<xsl:value-of select="concat('&#10;.RS ', ../../../../@userlevel)"/>
  </xsl:if>
  <xsl:variable name="intd">
    <xsl:value-of select="../../*[last()-1]/@userlevel"/>
  </xsl:variable>
<xsl:text>
.br
.ns
.TP</xsl:text><xsl:value-of select="$intd"/>
<xsl:text>
</xsl:text>
  <xsl:choose>
    <xsl:when test="$etiket='' and name(.) = 'warning'">
<xsl:text>\fBUyarı:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'caution'">
<xsl:text>\fBDikkat:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'note'">
<xsl:text>\fBBilgi:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'important'">
<xsl:text>\fBÖnemli:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'tip'">
<xsl:text>\fBİpucu:\fR</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>\fB</xsl:text><xsl:value-of select="$etiket"/><xsl:text>:\fR</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
<xsl:text>
.PP</xsl:text>
  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
