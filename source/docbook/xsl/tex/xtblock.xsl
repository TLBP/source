<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xtblock.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp<xsl:if test=" $
     ******************************************************************** -->
<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "
  (literallayout) or (screen) or (programlisting) or (synopsis)">
<!ENTITY listing "
  (itemizedlist) or (orderedlist) or (variablelist) or (glosslist)
  or (calloutlist) or (procedure)">
<!ENTITY notes "
 (note) or (warning) or (caution) or (tip) or (important)">
<!ENTITY uplisting "
  (ancestor::itemizedlist) or (ancestor::orderedlist) or
  (ancestor::variablelist) or (ancestor::glosslist) or
  (ancestor::answer) or (ancestor::footnote) or (ancestor::procedure)">
<!ENTITY upsection "
  name(..) = 'partintro' or name(..) = 'chapter' or name(..) = 'appendix' or
  name(..) = 'sect1'     or name(..) = 'sect2'   or name(..) = 'sect3'    or
  name(..) = 'sect4'     or name(..) = 'sect5'">

<!ENTITY refsections "
  (ancestor::refsect1) or (ancestor::refsect2) or (ancestor::refsect3) or (ancestor::refsynopsisdiv)">
<!ENTITY upnotes "
 (ancestor::note) or (ancestor::warning) or (ancestor::caution) or
 (ancestor::tip) or (ancestor::important)">
<!ENTITY blocks "
  &notes; or &listing; or &verbatim; or (table) or (informaltable) or (example) or
  (blockquote)  or (mediaobject) or (figure) or (qandaset) or (funcsynopsis)">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template match="formalpara">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;{\bfseries ', $caption, '}')"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="para[not (@role='only.html')]|simpara" name="para">
<!-- role='only.html' durumu sadece gfdl içermesi gereken belgelerdeki bağı
     içeren paragraf ile ilgilidir. -->
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="&blocks;">
      <xsl:if test="(&verbatim;)">
        <xsl:choose>
          <xsl:when test="(ancestor::itemizedlist or ancestor::orderedlist
                      or ancestor::answer or ancestor::step or ancestor::callout
                      or (ancestor::footnote))
                          and not (preceding-sibling::para)">
            <xsl:text>{</xsl:text>
          </xsl:when>
          <!--xsl:when test="(ancestor::variablelist or ancestor::glosslist)">
            <xsl:if test="(preceding-sibling::para)">
              <xsl:text> \addvspace{-6pt}</xsl:text>
            </xsl:if>
            <xsl:text>&#10;\vspace{-12pt}\indentedpar{</xsl:text>
          </xsl:when-->
          <xsl:when test="(&refsections;) and not (preceding::para)">
            <xsl:text>\vspace{-6pt}</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="((screen) or (programlisting)) and (ancestor::funcdescr)">
        <xsl:text>\vspace{6pt}</xsl:text>
      </xsl:if>
      <xsl:if test="(literallayout) and (ancestor::funcdescr) and not (&uplisting;)">
        <xsl:text>\vspace{-6pt}</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="(&verbatim;) and (ancestor::funcdescr) and not (&uplisting;)">
        <xsl:text>\vspace{-6pt}</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="p2">
        <xsl:if test="(&uplisting;) and (preceding-sibling::para/literallayout)">
          <xsl:text>\addvspace{-6pt}</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="name(..)='entry'">
          <xsl:call-template name="string.replace">
            <xsl:with-param name="string">
              <xsl:call-template name="string.replace">
                <xsl:with-param name="string" select="$p2"/>
                <xsl:with-param name="target" select="' '"/>
                <xsl:with-param name="replace" select="'ĞĞĞĞ'"/>
              </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="target" select="'ĞĞĞĞ'"/>
            <xsl:with-param name="replace" select="' \strut '"/>
          </xsl:call-template>
          <xsl:if test="(following-sibling::*)">
            <xsl:text>\strut\vskip6pt</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="name(..)='blockquote'">
          <xsl:value-of select="concat('&#10;\quotedpar{', $p2, '}')"/>
        </xsl:when>
        <xsl:when test="(name(../..) = 'itemizedlist'
                      or name(../..) = 'orderedlist'
                      or name(..) = 'step'
                      or name(..) = 'callout'
                      or name(..) = 'footnote') and (. = ../*[1])">
       <!-- (ancestor::itemizedlist or ancestor::orderedlist
                      or ancestor::step or ancestor::callout)
                      and not (preceding-sibling::para)"-->
          <xsl:value-of select="concat('{', $p2, '}')"/>
        </xsl:when>
        <xsl:when test="(&upnotes;) and not (ancestor::refentry)">
          <xsl:value-of select="concat('&#10;\indentedpar{\textcolor{warncolor}{', $p2, '}}')"/>
        </xsl:when>
        <xsl:when test="&uplisting; or (ancestor::calloutlist)">
          <xsl:if test="not (preceding-sibling::para) and (ancestor::glosslist[not (../*[1])])">
            <xsl:text>\vspace{-12pt}</xsl:text>
          </xsl:if>
          <xsl:value-of select="concat('&#10;\indentedpar{', $p2, '}')"/>
          <!--xsl:if test="not (following-sibling::para) and name(..) != 'footnote'">
            <xsl:text>\vspace{-6pt}</xsl:text>
          </xsl:if-->
        </xsl:when>
        <xsl:when test="(ancestor::funcdescr)">
          <xsl:if test="not (preceding-sibling::para)">
            <xsl:text>\vspace{-9pt}</xsl:text>
          </xsl:if>
          <xsl:value-of select="concat('&#10;\indentedpar{', $p2, '}')"/>
          <xsl:if test="not (following-sibling::para)">
            <xsl:text>\vspace{-6pt}</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="&refsections; or (ancestor::legalnotice)">
          <xsl:value-of select="concat('&#10;\indentedpar{', $p2, '}')"/>
        </xsl:when>
        <xsl:when test="name(..)='caption'
                     or name(..)='answer'
                     or name(..)='question'">
          <xsl:value-of select="$p2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('&#10;\par{', $p2, '}\par&#10;')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure">
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;\figure{{\bfseries ', $title, '}}')"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="mediaobject|inlinemediaobject">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="imageobject">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="imagedata|graphic">
  <!--xsl:variable name="fit">
    <xsl:if test="(@scalefit)">
      <xsl:text>width=\textwidth, keepaspectratio</xsl:text>
    </xsl:if>
  </xsl:variable-->
  <xsl:variable name="figtype">
    <xsl:choose>
      <xsl:when test="(ancestor::inlinemediaobject) or @scale = '1'">
        <xsl:text>&#10;\optmfigbox{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;\normfigbox{</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains(@fileref, '.gif')">
      <xsl:value-of select="concat($figtype, $imgprefix, $mainid, '/',
                                    substring-before(@fileref, '.gif'),
                                    '.eps}')"/>
    </xsl:when>
    <xsl:when test="contains(@fileref, '.jpg')">
      <xsl:value-of select="concat($figtype, $imgprefix, $mainid, '/',
                                    substring-before(@fileref, '.jpg'),
                                    '.eps}')"/>
    </xsl:when>
          <xsl:when test="contains(@fileref, '.jpeg')">
      <xsl:value-of select="concat($figtype, $imgprefix, $mainid, '/',
                                    substring-before(@fileref, '.jpeg'),
                                    '.eps}')"/>
    </xsl:when>
    <xsl:when test="contains(@fileref, '.png')">
      <xsl:value-of select="concat($figtype, $imgprefix, $mainid, '/',
                                    substring-before(@fileref, '.png'),
                                    '.eps}')"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="mediaobject/caption|inlinemediaobject/caption">
  <xsl:text>&#10;\indentedpar{\strut\hfill </xsl:text>
  <xsl:apply-templates/><xsl:text>\hfill\strut}</xsl:text>
</xsl:template>

<xsl:template match="literallayout|programlisting|screen|synopsis">
<xsl:param name="indentspc" select="'~~~~~~~'"/>
<xsl:if test="(((ancestor::itemizedlist) or
                (ancestor::orderedlist) or
                (ancestor::answer) or
                (ancestor::footnote)) and
                name(..)='para' and
                not (../preceding-sibling::para))">
  <xsl:text>}</xsl:text>
</xsl:if>
  <xsl:variable name="p2">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p11">
    <xsl:choose>
      <xsl:when test="not(starts-with($p2, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test=" not(starts-with(substring($p11, string-length($p11), 1), '&#10;'))">
        <xsl:value-of select="concat($p11, '&#10;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p11"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="p">
    <xsl:choose>
      <xsl:when test="(@indent)">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p1"/>
          <xsl:with-param name="target" select="'&#10;'"/>
          <xsl:with-param name="replace" select="concat('&lt;/verb>&lt;verb>', substring($indentspc,1,@indent))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="(ancestor::refentry) and
          ((preceding-sibling::title) or count(preceding-sibling::*) = 0)">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p1"/>
          <xsl:with-param name="target" select="'&#10;'"/>
          <xsl:with-param name="replace" select="'&lt;/verb>&lt;verb>'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p1"/>
          <xsl:with-param name="target" select="'&#10;'"/>
          <xsl:with-param name="replace" select="concat('&lt;/verb>&lt;verb>', substring($indentspc,1,4))"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
<xsl:if test="name(..) = 'term' or name(..) = 'glossterm'
              or (ancestor::legalnotice)">
  <xsl:text>\reduceindent</xsl:text>
</xsl:if>
<xsl:if test="name(..)!='para' and not (&uplisting;)"><!-- and not (starts-with(name(..), 'refsect') and ../*[2] = node())"-->
<xsl:text>\vspace{-6pt}</xsl:text>
</xsl:if>
  <xsl:choose>
    <xsl:when test="(ancestor::qandaentry)">
<xsl:text>\small</xsl:text>
    </xsl:when>
    <xsl:when test="(&uplisting;) and name(..)='para'">
      <xsl:if test="not (../preceding-sibling::para)">
        <xsl:text>\vspace{6pt}</xsl:text>
      </xsl:if>
      <xsl:text>\small</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>
\vskip2pt\leavevmode\small</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="(@indent)">
      <xsl:value-of select="substring(substring($p, 8), 1, string-length(substring($p, 8)) - (6 + @indent))"/>
    </xsl:when>
    <xsl:when test="((ancestor::refentry) and
          ((preceding-sibling::title) or count(preceding-sibling::*) = 0)) or (ancestor::row)">
      <xsl:value-of select="substring(substring($p, 8), 1, string-length(substring($p, 8)) - 6)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring(substring($p, 8), 1, string-length(substring($p, 8)) - 10)"/>
    </xsl:otherwise>
  </xsl:choose>

<xsl:text>\normalsize\vskip.1pt
</xsl:text>
<xsl:if test="name(..) = 'term' or name(..) = 'glossterm'
              or (ancestor::legalnotice)">
  <xsl:text>\enhanceindent</xsl:text>
</xsl:if>

</xsl:template>

<xsl:template match="literallayout[(ancestor::entry)]|
                     screen[not (ancestor::refentry)]|
                     programlisting[not (ancestor::refentry)]|
                     synopsis[not (ancestor::refentry)]">
<xsl:if test="((ancestor::itemizedlist) or (ancestor::orderedlist) or
  (ancestor::answer) or (ancestor::footnote)) and name(..)='para' and not (../preceding-sibling::para)">
  <xsl:text>}</xsl:text>
</xsl:if>
  <xsl:variable name="color">
    <xsl:choose>
      <xsl:when test="name(.) = 'synopsis'">
        <xsl:text>SynopsColor</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ScreenColor</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="p2">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($p2, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="p">
    <xsl:choose>
      <xsl:when test=" not(starts-with(substring($p1, string-length($p1), 1), '&#10;'))">
        <xsl:value-of select="concat($p1, '&#10;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="@linenumbering = 'numbered'">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p"/>
          <xsl:with-param name="target" select="'&#10;'"/>
          <xsl:with-param name="replace" select="concat('&lt;/scrd>&lt;scrd>', $color, '}{')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p"/>
          <xsl:with-param name="target" select="'&#10;'"/>
          <xsl:with-param name="replace" select="concat('&lt;/scrn>&lt;scrn>', $color, '}{')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="(ancestor::entry) and
                     not (../preceding-sibling::para)">
      <xsl:text>&#10;\vspace{-12pt}\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="(ancestor::entry) and
                     (../preceding-sibling::para)">
      <xsl:text>&#10;\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="(ancestor::procedure) or (ancestor::qandaentry)">
      <xsl:text>&#10;\vspace{6pt}\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="(&uplisting;) and name(..) = 'para' and (.. = ../../*[1])">
      <xsl:text>&#10;\vskip12pt\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="(&uplisting;) and name(..) != 'para' and (. = ../*[1])">
      <xsl:text>&#10;\vskip12pt\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="&uplisting; or &upnotes; or (ancestor::calloutlist)
                    or (ancestor::funcdescr)">
      <xsl:text>&#10;\vskip6pt\fscline</xsl:text>
    </xsl:when>
    <xsl:when test="(ancestor::abstract)">
<xsl:text>
\global\indentwdt12pt
\enhanceindent
\vskip6pt\fscline</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>
\global\indentwdt0pt
\global\indentedwdt\linewidth
\global\scrwdt\indentedwdt
\vskip2pt\leavevmode\fscline</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="substring(substring($content, 8), 1, string-length(substring($content, 8)) - 19)"/>
  <xsl:choose>
    <xsl:when test="(ancestor::entry)">
<xsl:text>\lscline\vskip2pt\offinterlineskip</xsl:text>
    </xsl:when>
    <xsl:when test="&upnotes; or ((ancestor::footnote) and not (../following-sibling::para))">
<xsl:text>\lscline</xsl:text>
    </xsl:when>
    <xsl:when test="&uplisting;">
      <xsl:text> \lscline\vspace{-6pt}</xsl:text>
    </xsl:when>
    <xsl:when test="(ancestor::abstract)">
<xsl:text>\lscline\reduceindent</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>\lscline
</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="blockquote">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="example">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:if test="(&upsection;) and (. = ../*[2])">
    <xsl:text>\vspace{-12pt}</xsl:text>
  </xsl:if>
  <xsl:if test="(&uplisting; or &upnotes;)">
    <xsl:text>\indentedpar{</xsl:text>
  </xsl:if>
<xsl:text>
\example{</xsl:text>
  <xsl:if test="(title)">
    <xsl:value-of select="concat('{\bfseries ', $caption, '}')"/>
  </xsl:if>
<xsl:text>}</xsl:text>
  <xsl:if test="(&uplisting; or &upnotes;)">
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="caution|important|note|tip|warning">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:variable name="img">
    <xsl:choose>
      <xsl:when test="name(.)='note'">note.eps</xsl:when>
      <xsl:when test="name(.)='warning'">warning.eps</xsl:when>
      <xsl:when test="name(.)='caution'">caution.eps</xsl:when>
      <xsl:when test="name(.)='tip'">tip.eps</xsl:when>
      <xsl:when test="name(.)='important'">important.eps</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="(title)">
        <xsl:value-of select="$caption"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="name(.)='note'">Bilgi</xsl:when>
          <xsl:when test="name(.)='warning'">Uyarı</xsl:when>
          <xsl:when test="name(.)='caution'">Dikkat</xsl:when>
          <xsl:when test="name(.)='tip'">İpucu</xsl:when>
          <xsl:when test="name(.)='important'">Önemli</xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
<xsl:text>
\enhanceindent
\notetitle{</xsl:text>
<xsl:value-of select="concat($iconprefix, $img, '}{', $title, '}')"/>
<xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="attribution">
  <xsl:text>&#10;\quotedpar{\strut\hfill -- -- </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="funcsynopsis">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:variable name="content">
    <xsl:apply-templates select="funcprototype|funcdeflist/funcprototype"/>
  </xsl:variable>
<!--xsl:text>\rightline{</xsl:text><xsl:value-of select="funcprototype/@role"/><xsl:text>} -->
<xsl:text>
\vskip.1pt\funcsynopsis{</xsl:text><xsl:value-of select="$content"/><xsl:text>}</xsl:text>
  <xsl:apply-templates select="funcdescr"/>
</xsl:template>

<xsl:template match="funcdescr">
<xsl:text>
\par\enhanceindent</xsl:text>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="funcprototype">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="(parameters)">
<xsl:text>\end{tabular}
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="funcdef">
<xsl:text>\boxwdt\linewidth\advance\boxwdt by-6pt \hbox to\boxwdt{\small{\tt </xsl:text><xsl:apply-templates/>
<xsl:if test="not (ancestor::funcprototype/parameters)">
  <xsl:text>}\hfill </xsl:text><xsl:value-of select="../@role|../../@role"/><xsl:text>}</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="funcdef/command
                    |funcdef/userinput
                    |funcdef/function">
  <xsl:choose>
    <xsl:when test="(ancestor::funcprototype/parameters)">
<xsl:text>}\hfill </xsl:text><xsl:value-of select="ancestor::funcprototype/@role"/><xsl:text>}
\vspace{-6pt}\begin{tabular}{lll}
\tuserinput{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
<xsl:text>\tuserinput{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="parameters">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="parameters/parameter">
  <xsl:apply-templates/><xsl:text>\\&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcprototype/paramdef">
  <xsl:variable name="p2">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:if test="$p2 != ''">
    <xsl:variable name="lside.len">
      <xsl:value-of select="string-length(normalize-space(../funcdef))"/>
    </xsl:variable>
    <xsl:variable name="spcstr">
      <xsl:call-template name="make.spcstr">
        <xsl:with-param name="length" select="$lside.len"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="p11">
      <xsl:choose>
        <xsl:when test="not(starts-with($p2, '&#10;'))">
          <xsl:value-of select="concat('&#10;', $p2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$p2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="p1">
      <xsl:choose>
        <xsl:when test=" not(starts-with(substring($p11, string-length($p11), 1), '&#10;'))">
          <xsl:value-of select="concat($p11, '&#10;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$p11"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="p">
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="$p1"/>
        <xsl:with-param name="target" select="'&#10;'"/>
        <xsl:with-param name="replace" select="concat('&lt;/verb>&lt;verb>', $spcstr)"/>
      </xsl:call-template>
    </xsl:variable>
<xsl:text>
\vspace{-12.6pt}\small</xsl:text>
    <xsl:value-of select="substring(substring($p, 8), 1, string-length(substring($p, 8)) - (6 + $lside.len))"/>
<xsl:text>\normalsize\vskip.1pt
</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="parameter/paramdef|paramdesc">
    <xsl:variable name="content">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:variable name="content1">
    <xsl:call-template name="string.replace">
      <xsl:with-param name="string" select="$content"/>
      <xsl:with-param name="target" select="'  '"/>
      <xsl:with-param name="replace" select="' ~'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('&lt;m/>{\small\tt ', $content1, '}')"/>
</xsl:template>

<xsl:template match="paramdef/emphasis">
<xsl:text>\replaceable{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>