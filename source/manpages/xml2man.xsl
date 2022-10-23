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
  extension-element-prefixes="d xlink"
  version='1.0'>

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:template match="d:dicterm|d:english|d:turkish"/>

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
    <xsl:value-of select="'&#10;.SH İSİM'"/>
  </xsl:if>
  <xsl:if test="preceding-sibling::d:refnamediv">
   <xsl:value-of select="'.br'"/>
  </xsl:if>
  <xsl:if test="normalize-space(../d:refmeta/d:refentrytitle) !=  normalize-space(d:refname)">
    <xsl:call-template name="linkme"/>
  </xsl:if>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;', normalize-space($content))"/>
  <xsl:if test="not (following-sibling::d:refnamediv)">
    <xsl:value-of select="'&#10;.sp'"/>
  </xsl:if>
  <xsl:message>
   <xsl:number from="d:book" count="d:refnamediv" level="any"/>
   <xsl:value-of select="concat(' ', d:refname, '.', ../d:refmeta/d:manvolnum, ' yazılıyor.&#10;')"/>
  </xsl:message>
</xsl:template>

<xsl:template match="d:refname">
  <xsl:variable name="name">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="desc">
    <xsl:value-of select="../d:refpurpose"/>
  </xsl:variable>
  <xsl:value-of select="concat($name, ' - ', $desc)"/>
</xsl:template>

<xsl:template match="d:refpurpose|d:refmiscinfo|d:manvolnum|d:refentrytitle|d:legalnotice"/>

<xsl:template match="d:refsynopsisdiv">
  <xsl:variable name="title">
   <xsl:choose>
     <xsl:when test="./d:title">
       <xsl:value-of select="concat('&#10;.SH ',./d:title)"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="'&#10;.SH KULLANIM'"/>
     </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$title"/>
  <xsl:apply-templates/>
  <xsl:value-of select="'&#10;.sp'"/>
</xsl:template>

<xsl:template match="d:refsect1">
 <xsl:value-of select="concat('&#10;.SH &#34;', translate(normalize-space(./d:title), &allcases;, &uppercases;), '&#34;')"/>
 <xsl:apply-templates/><xsl:text>
.sp</xsl:text>
</xsl:template>

<xsl:template match="d:refsect2">
 <xsl:value-of select="concat('&#10;.SS &#34;', normalize-space(./d:title), '&#34;')"/>
 <xsl:apply-templates/><xsl:text>
.sp</xsl:text>
</xsl:template>

<xsl:template match="d:refsect3">
<xsl:text>
.B </xsl:text><xsl:value-of select="d:title"/>
<xsl:text>
.RS 4</xsl:text>
<xsl:apply-templates/>
<xsl:text>
.RE 1</xsl:text>
</xsl:template>

<xsl:template match="d:cmdsynopsis">
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RS 4'"/>
  </xsl:if>
  <xsl:if test="(@userlevel)">
<xsl:text>&#10;.RS </xsl:text><xsl:value-of select="@userlevel"/>
<xsl:text>
</xsl:text>
  </xsl:if>
  <xsl:variable name="cmd">
    <xsl:value-of select="normalize-space(./d:command)"/>
  </xsl:variable>

  <xsl:value-of select="concat('&#10;.IP \fB',$cmd,'\fR ', string-length($cmd)+1, '&#10;')"/>

  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:value-of select="normalize-space($content)"/>

  <xsl:if test="(&indented;) and name(following-sibling::*[1])=''">
   <xsl:value-of select="'&#10;.sp'"/>
  </xsl:if>
  <xsl:if test="name(following-sibling::*[1])!='cmdsynopsis'">
   <xsl:value-of select="'&#10;.sp&#10;.PP'"/>
  </xsl:if>
  <xsl:if test="(@userlevel)">
<xsl:text>
.RE</xsl:text>
   <xsl:if test="not (&indented;)">
     <xsl:value-of select="'&#10;.IP'"/>
   </xsl:if>
  </xsl:if>

 <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RE&#10;.IP'"/>
 </xsl:if>
</xsl:template>

<xsl:template match="d:cmdsynopsis/d:command"/>

<xsl:template match="d:cmdsynopsis/d:arg|d:cmdsynopsis/d:group">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="repeat">
   <xsl:if test="@rep = 'repeat'">
    <xsl:text>...</xsl:text>
   </xsl:if>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@choice = 'plain'">
      <xsl:value-of select="concat($content, $repeat)"/>
    </xsl:when>
    <xsl:when test="@choice = 'req'">
      <xsl:value-of select="concat('{', $content, '}', $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('[', $content, ']', $repeat)"/>
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
      <xsl:value-of select="concat($content, $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('[', $content, ']', $repeat)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::d:arg">
    <xsl:value-of select="'|'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:arg/d:arg|d:arg/d:group">
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
      <xsl:value-of select="concat($content, $repeat)"/>
    </xsl:when>
    <xsl:when test="@choice = 'req'">
      <xsl:value-of select="concat('{', $content, '}', $repeat)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('[', $content, ']', $repeat)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:arg/d:option">
  <xsl:value-of select="concat('\fB',., '\fR')"/>
</xsl:template>

<xsl:template match="d:arg/d:replaceable">
  <xsl:value-of select="concat('\fI',., '\fR')"/>
</xsl:template>

<xsl:template match="d:funcsynopsis">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::*">
   <xsl:value-of select="'&#10;.sp&#10;.PP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:funcsynopsisinfo">
<xsl:text>.nf
</xsl:text>
  <xsl:apply-templates/>
<xsl:text>.fi
.sp
</xsl:text>
</xsl:template>

<xsl:template match="d:funcprototype">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="following-sibling::*">
    <xsl:value-of select="$p"/>
    <xsl:value-of select="'&#10;.sp'"/>
   </xsl:when>
   <xsl:otherwise>
   <xsl:value-of select="$p"/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:funcdef">
  <xsl:variable name="len">
    <xsl:value-of select="string-length(.) + 1"/>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;.IP &#34;',$content,'&#34; ', $len, '&#10;')"/>
</xsl:template>

<xsl:template match="d:funcdef/d:function">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('\fB',$content,'\fR')"/>
</xsl:template>

<xsl:template match="d:paramdef">
  <xsl:if test="not (preceding-sibling::d:paramdef)">
    <xsl:text>(</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
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

<xsl:template match="d:formalpara/d:title|d:example/d:title">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:formalpara|d:example">
  <xsl:if test="(&indented;)">
    <xsl:value-of select="'&#10;.RS 4'"/>
  </xsl:if>

  <xsl:variable name="title">
    <xsl:apply-templates select="d:title"/>
  </xsl:variable>
  <xsl:variable name="num">
    <xsl:number from="d:refentry" count="d:example" format="1: "/>
  </xsl:variable>

  <xsl:choose>
   <xsl:when test="name(.) = 'formalpara'">
    <xsl:value-of select="concat('&#10;.IP &#34;',$title, '&#34; 4&#10;')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="concat('&#10;.IP &#34;Örnek ', $num, $title, '&#34; 4&#10;')"/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="./*[name(.)!='title']"/>

  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:blockquote">
  <xsl:if test="(&indented;)">
    <xsl:value-of select="'&#10;.RS 4&#10;'"/>
  </xsl:if>
  <xsl:text>.RS 4&#10;</xsl:text>
  <xsl:apply-templates/>
<xsl:text>.sp
.RE</xsl:text>
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RE&#10;.IP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:literallayout|d:screen|d:synopsis|d:programlisting">
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RS 4&#10;'"/>
  </xsl:if>
  <xsl:choose><!-- girinti öntanımlı 7'dir -->
   <xsl:when test="(@userlevel)">
     <xsl:value-of select="concat('.RS ', @userlevel, '&#10;')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="'.RS 4&#10;'"/>
   </xsl:otherwise>
  </xsl:choose>
<xsl:text>.nf
</xsl:text>
<xsl:call-template name="verbatim">
  <xsl:with-param name="p">
   <xsl:apply-templates/>
  </xsl:with-param>
</xsl:call-template>
<xsl:text>.fi
.sp
.RE</xsl:text>
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RE&#10;.IP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:screen[name(../..) = 'refmeta']">
 <xsl:call-template name="verbatim">
   <xsl:with-param name="p">
    <xsl:apply-templates/>
   </xsl:with-param>
 </xsl:call-template>
</xsl:template>

<xsl:template name="verbatim">
 <xsl:param name="p"></xsl:param>
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
</xsl:template>

<xsl:template match="d:glosslist|d:variablelist">
  <xsl:choose>
    <xsl:when test="(&indented;)">
<xsl:text>
.RS</xsl:text>
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
 <xsl:if test="not (@spacing)">
   <xsl:value-of select="'&#10;.PD 1'"/>
 </xsl:if>

  <xsl:variable name="indent">
   <xsl:choose>
     <xsl:when test="(&indented;) and @userlevel">
       <xsl:value-of select="@userlevel + 4"/>
     </xsl:when>
     <xsl:when test="@userlevel">
       <xsl:value-of select="@userlevel"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>5</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(&indented;)">
      <xsl:value-of select="concat('&#10;.RS ', $indent)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.sp&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:when test="@userlevel">
      <xsl:value-of select="concat('&#10;.RS ', $indent)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.sp&#10;.RE</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'&#10;.RS 1'"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.sp&#10;.RE</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
 <xsl:if test="not (@spacing)">
   <xsl:value-of select="'&#10;.PD 0'"/>
 </xsl:if>
</xsl:template>

<xsl:template match="d:varlistentry|d:glossentry">
  <xsl:if test="name(preceding-sibling::*[1])= 'title' ">
   <xsl:variable name="title">
     <xsl:value-of select="../d:title"/>
   </xsl:variable>
   <xsl:value-of select="concat('.SS &#34;', normalize-space($title), '&#34;&#10;')"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="../@termlength">
      <xsl:value-of select="concat('.TP ', ../@termlength, '&#10;')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'.TP 4&#10;'"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="terms">
    <xsl:apply-templates select="d:term|d:glossterm"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($terms)"/>

  <xsl:apply-templates select="d:listitem|d:glossdef"/>
  <xsl:value-of select="'&#10;.sp'"/>
  <xsl:if test="not (&indented;) and name(following-sibling::*[1])=''">
   <xsl:value-of select="'&#10;.PP'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:term|d:glossterm">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:choose>
   <xsl:when test="name(.) = 'glossterm' and name (..) = 'glossterm'
             and name(following-sibling::*)='glossterm'">
      <xsl:text>\p </xsl:text>
    </xsl:when>
    <xsl:when test="name(following-sibling::*)='glossterm' or name(following-sibling::*)='term'">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossdef|d:varlistentry/d:listitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:itemizedlist/d:listitem">
  <xsl:choose>
    <xsl:when test="../@mark='disc'">
<xsl:text>
.IP \(ci 3</xsl:text>
    </xsl:when>
    <xsl:when test="../@mark='square'">
<xsl:text>
.IP \(sq 3</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>
.IP \(bu 3</xsl:text>
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
     <xsl:number from="d:orderedlist" count="d:listitem" format="1."/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="../@userlevel">
      <xsl:value-of select="concat('.IP ', $ip, ' ', ../@userlevel)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('.IP ', $ip, ' ',string-length($ip)+1)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:warning|d:caution|d:note|d:important|d:tip">
  <xsl:param name="etiket"><xsl:value-of select="d:title"/></xsl:param>
  <xsl:if test="(&indented;)">
   <xsl:value-of select="'&#10;.RS 4'"/>
  </xsl:if>
<xsl:text>
.TP 4</xsl:text>
<xsl:text>
</xsl:text>
  <xsl:choose>
    <xsl:when test="$etiket='' and name(.) = 'warning'">
<xsl:text>\fBUyarı:\fR&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'caution'">
<xsl:text>\fBDikkat:\fR&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'note'">
<xsl:text>\fBBilgi:\fR&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'important'">
<xsl:text>\fBÖnemli:\fR&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'tip'">
<xsl:text>\fBİpucu:\fR&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>\fB</xsl:text><xsl:value-of select="$etiket"/><xsl:text>\fR&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:value-of select="'&#10;.sp'"/>
  <xsl:if test="(&indented;)">
<xsl:text>
.RE
.IP</xsl:text>
  </xsl:if>
  <xsl:if test="not (&indented;)">
<xsl:text>
.PP</xsl:text>
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

<xsl:template match="d:acronym|d:classname|d:literal|d:productname|d:prompt|d:statement|d:symbol|d:tag|d:type">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:application|d:code|d:command|d:constant|d:emphasis|d:envar|d:filename|d:function|d:keyword|d:option|d:parameter|d:replaceable|d:structname|d:structfield|d:userinput|d:quote|d:small|d:type|d:varname|d:wordasword">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="name(.)='application' or
                    name(.)='command' or
                    name(.)='code' or
                    name(.)='constant' or
                    name(.)='envar' or
                    name(.)='function' or
                    name(.)='keyword' or
                    name(.)='option' or
                    (name(.)='systemitem' and @class='username') or                                      name(.)='userinput' or
                    ((name(.)='emphasis' or
                    name(.)='type') and @role='bold')
">
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

<xsl:template match="d:informaltable|d:table">

  <xsl:if test="name(.)='table' and (./d:title)">
<xsl:text>
.B </xsl:text><xsl:value-of select="d:title"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="(&indented;)">
<xsl:text>
.RS
.TS
tab(:);</xsl:text>
      <xsl:apply-templates/>
<xsl:text>
.TE
.RE
.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>
.TS
</xsl:text>
  <xsl:choose>
    <xsl:when test="@colwidth = '0'">
     <xsl:text>tab(:);</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>tab(:) allbox;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
      <xsl:apply-templates/>
<xsl:text>
.TE
.sp</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:tgroup">
 <xsl:variable name="cols">
  <xsl:apply-templates select="d:colspec"/>
 </xsl:variable>
  <xsl:value-of select="normalize-space($cols)"/>
  <xsl:value-of select="'&#10;'"/>
  <xsl:apply-templates select="*[name(.)!='colspec']"/>
</xsl:template>

<xsl:template match="d:colspec">
  <xsl:choose>
    <xsl:when test="contains(@colwidth, '*') and not (preceding-sibling::d:colspec)">
     <xsl:text>l1</xsl:text>
    </xsl:when>
    <xsl:when test="contains(@colwidth, '*') and not (following-sibling::d:colspec)">
     <xsl:text>1l</xsl:text>
    </xsl:when>
    <xsl:when test="contains(@colwidth, '*') and preceding-sibling::d:colspec">
     <xsl:text>1l1</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="concat('lw', @colwidth)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::d:colspec">
   <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="not (following-sibling::d:colspec)">
   <xsl:value-of select="'.'"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:thead">
 <xsl:variable name="cols">
  <xsl:apply-templates/>
 </xsl:variable>
  <xsl:value-of select="normalize-space($cols)"/>
  <xsl:value-of select="'&#10;'"/>
</xsl:template>

<xsl:template match="d:tbody">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:row">
  <xsl:choose>
   <xsl:when test="name(..) = 'tbody'">
    <xsl:text>T{</xsl:text>
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:entry">
  <xsl:choose>
   <xsl:when test="name(../..) = 'thead'">
    <xsl:choose>
     <xsl:when test="not (preceding-sibling::d:entry)">
      <xsl:text>\fB</xsl:text><xsl:apply-templates/><xsl:text>\fR</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>:\fB</xsl:text><xsl:apply-templates/><xsl:text>\fR</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
    <xsl:text>&#10;T}</xsl:text>
     <xsl:choose>
      <xsl:when test="not (following-sibling::d:entry)">
       <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>:T{</xsl:text>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
