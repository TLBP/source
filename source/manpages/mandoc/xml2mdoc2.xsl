<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "name(..) ='literallayout'
                or name(../..) ='literallayout'
                or name(..) ='screen'
                or name(../..) ='screen'
                or name(..) ='synopsis'
                or name(../..) ='synopsis'
                or name(..) ='programlisting'
                or name(../..) ='programlisting'">

<!ENTITY indented "name(..) = 'glossdef'
                or name(..) = 'listitem'
                or name(..) = 'caution'
                or name(..) = 'note'
                or name(..) = 'warning'
                or name(..) = 'important'
                or name(..) = 'tip'
                or name(..) = 'blockquote'
                or name(..) = 'formalpara'">
<!ENTITY allcases  "'aâbcçdefgğhıiîjklmnoöôpqrsştuüûvwxyzAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
<!ENTITY uppercases "'AÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
]>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:t="http://tlbp.gen.tr/ns/tlbp"
  extension-element-prefixes="d xlink t"
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
    <xsl:when test="contains($string, '&#10; ') and not (&verbatim;)">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat(substring-before($string,'&#10; '),
                            '&#10;', substring-after($string,'&#10; '))"/>
      </xsl:call-template>
    </xsl:when>
<!-- Buradaki herşey text() düğümü içinde kaldığından \ öncelemek için en iyi yer burası. &#8203; yazdırılabilir karakter değildir. -->
    <xsl:when test="contains($string, '\')">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat(substring-before($string,'\'),
                            '&#8203;', substring-after($string,'\'))"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="escape">
<!-- &#8203; yazdırılabilir karakter değildir. -->
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
     <xsl:when test="contains($string, '&#8203;')">
      <xsl:call-template name="escape">
        <xsl:with-param name="string" select="concat(substring-before($string,'&#8203;'),
                            '\\', substring-after($string,'&#8203;'))"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:title"/>

<xsl:template match="d:refsect2/d:title">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('.Ss &#34;', normalize-space($p), '&#34;')"/>
</xsl:template>

<xsl:template match="d:refsect1/d:title">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('.Sh &#34;', translate(normalize-space($p), &allcases;, &uppercases;), '&#34;')"/>
</xsl:template>

<xsl:template match="text()">
<xsl:variable name="p">
  <xsl:call-template name="trimleft">
   <xsl:with-param name="string">
     <xsl:value-of select="."/>
   </xsl:with-param>
  </xsl:call-template>
</xsl:variable>
  <xsl:call-template name="escape">
   <xsl:with-param name="string">
     <xsl:value-of select="$p"/>
   </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:refnamediv">
  <xsl:if test="not (preceding-sibling::d:refnamediv)">
    <xsl:value-of select="'.Sh İSİM'"/>
  </xsl:if>
  <xsl:if test="(preceding-sibling::d:refnamediv)">
    <xsl:value-of select="'.br'"/>
    <xsl:call-template name="linkme"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refname">
  <xsl:value-of select="concat('.Nm ',., '&#10;')"/>
</xsl:template>

<xsl:template match="d:refpurpose">
  <xsl:value-of select="concat('.Nd ',.)"/>
</xsl:template>

<xsl:template match="d:refsynopsisdiv">
  <xsl:variable name="title">
   <xsl:choose>
     <xsl:when test="./d:title">
       <xsl:value-of select="concat('.Sh ',./d:title)"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="'.Sh KULLANIM'"/>
     </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$title"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsect1|d:refsect2">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:refsect3">
<xsl:text>.Sy </xsl:text><xsl:value-of select="d:title"/>
<xsl:text>
.Bd -ragged -offset nnnn -compact</xsl:text>
<xsl:apply-templates/>
<xsl:text>
.Ed</xsl:text>
</xsl:template>

<xsl:template match="d:cmdsynopsis">
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.Bd -ragged -offset nnnn -compact'"/>
  </xsl:if>
  <xsl:if test="(@userlevel)">
<xsl:text>.RS </xsl:text><xsl:value-of select="@userlevel"/>
<xsl:text>
</xsl:text>
  </xsl:if>

  <xsl:apply-templates/><!--
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test= "contains($p, '.br')">
    <xsl:variable name="p1">
     <xsl:call-template name="string.replace">
       <xsl:with-param name="string" select="normalize-space($p)"/>
       <xsl:with-param name="target" select="' .br '"/>
       <xsl:with-param name="replace" select="'&#10;.br&#10;'"/>
     </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('&#10;', $p1, '&#10;')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="concat('&#10;', normalize-space($p), '&#10;')"/>
   </xsl:otherwise>
  </xsl:choose>
  -->
  <xsl:if test="(following-sibling::d:cmdsynopsis)">
   <xsl:value-of select="'.br'"/>
  </xsl:if>
  <xsl:if test="not (following-sibling::d:cmdsynopsis)">
  <xsl:if test="(@userlevel)">
<xsl:text>
.RE </xsl:text><xsl:value-of select="count(preceding-sibling::d:cmdsynopsis)"/>
  </xsl:if>
    <xsl:if test="(&indented;)">
      <xsl:value-of select="'&#10;.Ed'"/>
    </xsl:if>
  </xsl:if>
  <xsl:value-of select="'&#10;.El'"/>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:command">
<xsl:value-of select="concat('&#10;.Bl -tag -width ',., ' -compact')"/>
<xsl:value-of select="concat('&#10;.It Nm ',.)"/>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:arg">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="repeat">
   <xsl:if test="@rep = 'repeat'">
     <xsl:value-of select="'&#10;.Ar ...'"/>
   </xsl:if>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@choice = 'plain'">
      <xsl:value-of select="concat('.', normalize-space(substring-after($content, ' ')), $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('&#10;.Op ', normalize-space($content), $repeat)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:group/d:arg">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="repeat">
   <xsl:if test="@rep = 'repeat'">
     <xsl:value-of select="'...'"/>
   </xsl:if>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@choice = 'plain'">
      <xsl:value-of select="concat(substring-after($content, ' '), $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($content, $repeat)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::d:arg">
    <xsl:value-of select="'| Ns '"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:arg/d:arg">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="repeat">
   <xsl:if test="@rep = 'repeat'">
     <xsl:value-of select="'...'"/>
   </xsl:if>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@choice = 'plain'">
      <xsl:value-of select="concat(substring-after($content, ' '), $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(' Ns Op ', $content, $repeat)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::d:arg">
    <xsl:value-of select="'| Ns '"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:group">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:arg/d:option">
  <xsl:value-of select="concat(' Fl ', substring-after(., '-'))"/>
</xsl:template>

<xsl:template match="d:arg/d:replaceable">
  <xsl:value-of select="concat(' Ar ', .)"/>
</xsl:template>

<xsl:template match="d:para[@userlevel]|d:simpara[@userlevel]">
  <xsl:choose>
   <xsl:when test="&indented;">
    <xsl:value-of select="concat('&#10;.RS ', 7 + @userlevel, '&#10;')"/>
   </xsl:when>
   <xsl:otherwise>
   <xsl:value-of select="concat('&#10;.RS ', @userlevel, '&#10;')"/>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:choose>
   <xsl:when test="name(following-sibling::*[1]) = 'simpara' and @userlevel">
    <xsl:value-of select="normalize-space($p)"/>
   </xsl:when>
   <xsl:when test="name(following-sibling::*[1]) = 'simpara'">
    <xsl:value-of select="normalize-space($p)"/>
    <xsl:value-of select="'&#10;.br'"/>
   </xsl:when>
   <xsl:when test="following-sibling::*">
    <xsl:value-of select="normalize-space($p)"/>
    <xsl:value-of select="'&#10;.sp'"/>
   </xsl:when>
   <xsl:otherwise>
   <xsl:value-of select="normalize-space($p)"/>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:value-of select="'&#10;.RE'"/>
  <xsl:if test="&indented;">
  <!-- rsync.1 -itemize-changes seçeneğinin açıklamasına özel -->
   <xsl:if test="name(following-sibling::*[1]) = 'para' or name(following-sibling::*[@userlevel][1]) != 'simpara'">
    <xsl:if test="following-sibling::*">
     <xsl:value-of select="'&#10;.IP'"/>
    </xsl:if>
   </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="d:para[not (@userlevel)]|d:simpara[not (@userlevel)]">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:choose>
   <xsl:when test="name(following-sibling::*[1]) = 'simpara'">
    <xsl:value-of select="normalize-space($p)"/>
    <xsl:value-of select="'&#10;.br'"/>
   </xsl:when>
   <xsl:when test="following-sibling::*">
    <xsl:value-of select="normalize-space($p)"/>
    <xsl:value-of select="'&#10;.sp'"/>
   </xsl:when>
   <xsl:otherwise>
   <xsl:value-of select="normalize-space($p)"/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:formalpara/d:title">
  <xsl:value-of select="'.TP&#10;'"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:formalpara">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:blockquote">
  <xsl:if test="(&indented;)">
    <xsl:value-of select="concat('&#10;.RS ', ../@userlevel)"/>
  </xsl:if>
  <xsl:text>.IP</xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="(&indented;)">
<xsl:text>.RE
.IP</xsl:text>
  </xsl:if>
  <xsl:if test="(following-sibling::d:para) or (following-sibling::d:simpara)">
   <xsl:value-of select="'&#10;.PP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:literallayout|d:screen|d:synopsis|d:programlisting">
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.IP&#10;.RS&#10;'"/>
  </xsl:if>
  <xsl:choose><!-- girinti öntanımlı 7'dir -->
   <xsl:when test="(@userlevel)">
     <xsl:value-of select="concat('.RS ', @userlevel, '&#10;')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="'.RS 7&#10;'"/>
   </xsl:otherwise>
  </xsl:choose>
<xsl:text>.nf
</xsl:text>
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
  <xsl:variable name="p2">
    <xsl:choose>
      <xsl:when test="contains($p1, '&#10;&#10;')">
       <xsl:call-template name="string.replace">
         <xsl:with-param name="string" select="$p1"/>
         <xsl:with-param name="target" select="'&#10;&#10;'"/>
         <xsl:with-param name="replace" select="'&#10;\&amp;&#10;'"/>
       </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="p3">
    <xsl:choose>
      <xsl:when test="contains($p2, '&#10;.')">
       <xsl:call-template name="string.replace">
         <xsl:with-param name="string" select="$p2"/>
         <xsl:with-param name="target" select="'&#10;.'"/>
         <xsl:with-param name="replace" select="'&#10;\&amp;.'"/>
       </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p3"/>
  <xsl:if test="substring($p, string-length($p), 1)!='&#10;'">
<xsl:text>
</xsl:text>
  </xsl:if>
<xsl:text>.fi
.RE</xsl:text>
  <xsl:if test="(following-sibling::d:para) or (following-sibling::d:simpara)">
   <xsl:value-of select="'&#10;.sp'"/>
  </xsl:if>
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RE&#10;.IP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:glosslist|d:variablelist">
  <xsl:if test="./d:title">
   <xsl:value-of select="concat('.Ss &#34;', normalize-space(./d:title), '&#34;&#10;')"/>
  </xsl:if>
  <!-- girinti öntanımlı 7'dir -->
  <xsl:variable name="dw" select="'apropos'"/>
  <xsl:variable name="width">
   <xsl:choose>
    <xsl:when test="(@userlevel)">
      <xsl:value-of select="substring($dw, 1, @userlevel-2)"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="'nn'"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="concat('&#10;.Bl -tag -width ', $width, ' -compact')"/>
  <xsl:apply-templates/>
  <xsl:value-of select="'&#10;.El'"/>
  <!--
  <xsl:choose>
    <xsl:when test="(&indented;)">
<xsl:text>
.RS</xsl:text><xsl:apply-templates/>
<xsl:text>
.RE
.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="((following-sibling::d:para) or (following-sibling::d:simpara)) and not (&indented;)">
   <xsl:value-of select="'&#10;.PP'"/>
  </xsl:if>
  -->
</xsl:template>

<xsl:template match="d:itemizedlist|d:orderedlist">
  <xsl:variable name="indent">
   <xsl:choose>
     <xsl:when test="(&indented;) and @userlevel">
       <xsl:value-of select="@userlevel + 7"/>
     </xsl:when>
     <xsl:when test="@userlevel">
       <xsl:value-of select="@userlevel"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>10</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(&indented;)">
      <xsl:value-of select="concat('.RS ', $indent)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:when test="@userlevel">
      <xsl:value-of select="concat('.RS ', $indent)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="((following-sibling::d:para) or (following-sibling::d:simpara)) and not (&indented;)">
   <xsl:value-of select="'&#10;.PP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:varlistentry|d:glossentry">
  <xsl:apply-templates/>
  <xsl:value-of select="'&#10;.Pp'"/>
</xsl:template>

<xsl:template match="d:glossterm|d:term">
  <xsl:choose>
    <xsl:when test="./d:glossterm">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:variable name="content">
       <xsl:apply-templates/>
     </xsl:variable>
     <xsl:value-of select="concat('&#10;.It ', normalize-space($content))"/>
    </xsl:otherwise>
  </xsl:choose>
  <!--
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:choose>
    <xsl:when test="../d:glossterm">
      <xsl:text>\p </xsl:text>
    </xsl:when>
    <xsl:when test="name(following-sibling::*)='glossterm' or name(following-sibling::*)='term'">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
  -->
  <!--xsl:if test="name(following-sibling::*)='glossterm' or name(following-sibling::*)='term'">
<xsl:text>, </xsl:text>
  </xsl:if-->
</xsl:template>

<xsl:template match="d:glossdef|d:varlistentry/d:listitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:itemizedlist/d:listitem">
  <xsl:choose>
    <xsl:when test="../@mark='disc'">
<xsl:text>
.IP o 3.3</xsl:text>
    </xsl:when>
    <xsl:when test="../@mark='square'">
<xsl:text>
.IP ⁕ 3.3</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>
.IP \(bu 3.3</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem">
  <xsl:variable name="ip">
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
     <xsl:number from="d:orderedlist" count="d:listitem" format="1"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="../@userlevel">
      <xsl:value-of select="concat('.IP ', $ip, ' ', ../@userlevel)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('.IP ', $ip, ' 4')"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:warning|d:caution|d:note|d:important|d:tip">
  <xsl:param name="etiket"><xsl:value-of select="d:title"/></xsl:param>
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RS'"/>
  </xsl:if>
  <xsl:variable name="indt"><!-- prehistoric -->
    <xsl:value-of select="../../*[last()-1]/@userlevel"/>
  </xsl:variable>
<xsl:text>
.TP </xsl:text><xsl:value-of select="@userlevel"/>
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
<xsl:text>\fB</xsl:text><xsl:value-of select="$etiket"/><xsl:text>\fR</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates/>
  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
  <xsl:if test="((following-sibling::d:para) or (following-sibling::d:simpara)) and not (&indented;)">
   <xsl:value-of select="'&#10;.PP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:uri">
  <xsl:variable name="ext">
    <xsl:value-of select="substring-before(substring-after(@xlink:href,'man'), '-')"/>
  </xsl:variable>
  <xsl:variable name="base">
    <xsl:value-of select="substring-after(@xlink:href, concat('man', $ext, '-'))"/>
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
      <xsl:value-of select="concat('\fB', $base, '\fR(', $ext, ')')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:xref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]/d:title"/>
  <xsl:value-of select="concat('\fB', $target,'\fR')"/>
</xsl:template>

<xsl:template match="d:acronym|d:classname|d:function|d:literal|d:productname|d:prompt|d:statement|d:symbol|d:type">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:application|d:code|d:command|d:constant|d:emphasis|d:envar|d:filename|d:keyword|d:option|d:parameter|d:replaceable|d:userinput|d:quote|d:small|d:varname|d:wordasword">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="name(.)='application' or
                    name(.)='command' or
                    name(.)='code' or
                    name(.)='constant' or
                    name(.)='envar' or
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
    <xsl:otherwise><!-- italic -->
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

<xsl:template match="d:link[@xlink:href]">
  <xsl:choose>
    <xsl:when test="count(child::node())=0">
     <xsl:value-of select="@xlink:href"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="concat('&lt;', @xlink:href, '&gt;: ')"/>
     <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:link[@linkend]">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="$p"/>
</xsl:template>

<xsl:template match="d:sbr">
<xsl:text>
.br
</xsl:text>
</xsl:template>

</xsl:stylesheet>
