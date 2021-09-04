<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xtlists.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->
<!DOCTYPE xsl:stylesheet [
<!ENTITY uplisting "
  (ancestor::itemizedlist) or (ancestor::orderedlist) or
  (ancestor::variablelist) or (ancestor::glosslist)">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template match="itemizedlist|orderedlist">
  <xsl:variable name="start">
    <xsl:choose>
      <xsl:when test="(@start)">
        <xsl:value-of select="@start"/>
      </xsl:when>
      <xsl:when test="@continuation = 'continues'">
        <xsl:value-of select="count(preceding::orderedlist[1]//listitem) + 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="itemsymbol">
    <xsl:choose>
      <xsl:when test="name(.)='itemizedlist'">
        <xsl:call-template name="list.itemsymbol"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="list.numeration"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
<xsl:text>
\enhanceindent </xsl:text>
  <xsl:choose>
    <xsl:when test="(title)">
<xsl:text>
\vspace{12pt}\centerline{\bfseries </xsl:text><xsl:value-of select="$caption"/><xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="listitem">
    <xsl:with-param name="symbol" select="$itemsymbol"/>
    <xsl:with-param name="prevnum" select="$start"/>
  </xsl:apply-templates>
<xsl:text>
\reduceindent
</xsl:text>
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <xsl:param name="symbol" select="'disc'"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="(para) or (simpara)">
      <xsl:value-of select="concat('&#10;\itempar{\lbl', $symbol, '}')"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('&#10;\vspace{-3pt}\itempar{\lbl', $symbol, '}{')"/>
      <xsl:apply-templates/><xsl:text>}</xsl:text>
      <xsl:if test="(following-sibling::listitem)">
        <xsl:text>\vspace{-6pt}</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="next.itemsymbol">
  <xsl:param name="itemsymbol" select="'default'"/>
  <xsl:choose>
    <!-- Change this list if you want to change the order of symbols -->
    <xsl:when test="$itemsymbol = 'disc'">circle</xsl:when>
    <xsl:when test="$itemsymbol = 'circle'">square</xsl:when>
    <xsl:otherwise>disc</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="list.itemsymbol">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="$node/@mark">
      <xsl:value-of select="$node/@mark"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::itemizedlist">
          <xsl:call-template name="next.itemsymbol">
            <xsl:with-param name="itemsymbol">
              <xsl:call-template name="list.itemsymbol">
                <xsl:with-param name="node" select="$node/ancestor::itemizedlist[1]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="next.itemsymbol"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="orderedlist/listitem">
  <xsl:param name="symbol" select="'default'"/>
  <xsl:param name="prevnum" select="1"/>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:variable name="num">
    <xsl:number from="orderedlist" count="listitem" format="1"/>
  </xsl:variable>
  <xsl:variable name="reelnum">
    <xsl:value-of select="$prevnum + $num - 1"/>
  </xsl:variable>
  <xsl:variable name="label">
    <xsl:choose>
      <xsl:when test="$symbol='arabic'">
        <xsl:number value="$reelnum" format="1."/>
      </xsl:when>
      <xsl:when test="$symbol='loweralpha'">
        <xsl:number value="$reelnum" format="a."/>
      </xsl:when>
      <xsl:when test="$symbol='lowerroman'">
        <xsl:number value="$reelnum" format="i."/>
      </xsl:when>
      <xsl:when test="$symbol='upperalpha'">
        <xsl:number value="$reelnum" format="A."/>
      </xsl:when>
      <xsl:when test="$symbol='upperroman'">
        <xsl:number value="$reelnum" format="I."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number value="$reelnum" format="1."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(para)">
      <xsl:value-of select="concat('&#10;\itempar{', $label, '}')"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('&#10;\vspace{-3pt}\itempar{', $label, '}{')"/>
      <xsl:apply-templates/><xsl:text>}</xsl:text>
      <xsl:if test="(following-sibling::listitem)">
        <xsl:text>\vspace{-6pt}</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="next.numeration">
  <xsl:param name="numeration" select="'default'"/>
  <xsl:choose>
    <!-- Change this list if you want to change the order of numerations -->
    <xsl:when test="$numeration = 'arabic'">loweralpha</xsl:when>
    <xsl:when test="$numeration = 'loweralpha'">lowerroman</xsl:when>
    <xsl:when test="$numeration = 'lowerroman'">upperalpha</xsl:when>
    <xsl:when test="$numeration = 'upperalpha'">upperroman</xsl:when>
    <xsl:when test="$numeration = 'upperroman'">arabic</xsl:when>
    <xsl:otherwise>arabic</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="list.numeration">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="$node/@numeration">
      <xsl:value-of select="$node/@numeration"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::orderedlist">
          <xsl:call-template name="next.numeration">
            <xsl:with-param name="numeration">
              <xsl:call-template name="list.numeration">
                <xsl:with-param name="node" select="$node/ancestor::orderedlist[1]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="next.numeration"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="variablelist|glosslist">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
<xsl:text>
\enhanceindent\vskip.1pt</xsl:text>
  <xsl:if test="(title)">
<xsl:text>
\vspace{12pt}\descrtitle{\bfseries </xsl:text><xsl:value-of select="$caption"/><xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent\addvspace{6pt minus 2pt}</xsl:text>
<!--
  <xsl:if test=".//ulink">
    <xsl:variable name="ulinks" select=".//ulink"/>
    <xsl:variable name="ucontent">
      <xsl:apply-templates select="$ulinks" mode="footlinks"/>
    </xsl:variable>
    <xsl:if test="$ucontent!=''">
    <xsl:value-of select="concat('&#10;&#10;\footnoterule', $ucontent)"/>
    </xsl:if>
  </xsl:if>
-->
</xsl:template>

<xsl:template match="glossentry">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
<xsl:apply-templates select="indexterm"/>
<xsl:choose>
  <xsl:when test="(acronym)">
    <xsl:if test="glossterm">
<xsl:text>
\descrtitle{</xsl:text>
      <xsl:apply-templates select="acronym"/>
      <xsl:text>}\enhanceindent\descrtitle{</xsl:text>
      <xsl:apply-templates select="glossterm"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="glossdef"/>
    <xsl:text>\reduceindent</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="glossterm">
<xsl:text>
\descrtitle{</xsl:text>
      <xsl:apply-templates select="glossterm"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="glossdef"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="term">
  <xsl:if test="(@id)">
    <xsl:value-of select="concat('&#10;\hypertarget{', @id, '}{}\label{', @id, '}')"/>
  </xsl:if>
<xsl:text>
\descrtitle{\userinput{</xsl:text>
  <xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="term[ancestor::refentry]">
  <xsl:if test="(@id)">
    <xsl:value-of select="concat('&#10;\hypertarget{', @id, '}{}\label{', @id, '}')"/>
  </xsl:if>
<xsl:text>
\descrtitle{</xsl:text>
  <xsl:apply-templates/>
<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="glossterm">
  <xsl:if test="(@id)">
    <xsl:value-of select="concat('&#10;\hypertarget{', @id, '}{}\label{', @id, '}')"/>
  </xsl:if>
<xsl:text> \vskip-6pt
</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glossterm[1]">
  <xsl:if test="(@id)">
    <xsl:value-of select="concat('&#10;\hypertarget{', @id, '}{}\label{', @id, '}')"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="varlistentry/listitem|glossdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="procedure">
  <xsl:variable name="itemsymbol">
    <xsl:call-template name="list.numeration"/>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:value-of select="concat('&#10;\procedure{{\bfseries ', $title, '}}')"/>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="symbol" select="substring($procedure.step.numeration.formats,1,1)"/>
  </xsl:apply-templates>
<xsl:text>
\reduceindent</xsl:text>
</xsl:template>

<xsl:template match="step">
  <xsl:param name="symbol" select="'1'"/>
  <xsl:variable name="label">
    <xsl:choose>
      <xsl:when test="ancestor::substeps">
        <xsl:choose>
          <xsl:when test="$symbol='1'">
            <xsl:number from="substeps" count="step" format="1."/>
          </xsl:when>
          <xsl:when test="$symbol='a'">
            <xsl:number from="substeps" count="step" format="a."/>
          </xsl:when>
          <xsl:when test="$symbol='i'">
            <xsl:number from="substeps" count="step" format="i."/>
          </xsl:when>
          <xsl:when test="$symbol='A'">
            <xsl:number from="substeps" count="step" format="A."/>
          </xsl:when>
          <xsl:when test="$symbol='I'">
            <xsl:number from="substeps" count="step" format="I."/>
          </xsl:when>
        </xsl:choose>
       </xsl:when>
       <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$symbol='1'">
            <xsl:number from="procedure" count="step" format="1."/>
          </xsl:when>
          <xsl:when test="$symbol='a'">
            <xsl:number from="procedure" count="step" format="a."/>
          </xsl:when>
          <xsl:when test="$symbol='i'">
            <xsl:number from="procedure" count="step" format="i."/>
          </xsl:when>
          <xsl:when test="$symbol='A'">
            <xsl:number from="procedure" count="step" format="A."/>
          </xsl:when>
          <xsl:when test="$symbol='I'">
            <xsl:number from="procedure" count="step" format="I."/>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
     </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(name(./*[1]) = 'para')">
      <xsl:value-of select="concat('&#10;\itempar{', $label, '}')"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="(name(./*[1]) = 'substeps')">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('&#10;\itempar{', $label, '}{')"/>
      <xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="substeps">
  <xsl:variable name="itemsymbol">
    <xsl:call-template name="procedure.step.numeration"/>
  </xsl:variable>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="symbol" select="$itemsymbol"/>
  </xsl:apply-templates>
<xsl:text>
\reduceindent</xsl:text>
</xsl:template>

<xsl:param name="procedure.step.numeration.formats" select="'1aiAI'"/>

<xsl:template name="procedure.step.numeration">
  <xsl:param name="context" select="."/>
  <xsl:variable name="format.length"
                select="string-length($procedure.step.numeration.formats)"/>
  <xsl:choose>
    <xsl:when test="local-name($context) = 'substeps'">
      <xsl:variable name="ssdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="sstype" select="($ssdepth mod $format.length)+2"/>
      <xsl:choose>
        <xsl:when test="$sstype &gt; $format.length">
          <xsl:value-of select="substring($procedure.step.numeration.formats,1,1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($procedure.step.numeration.formats,$sstype,1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name($context) = 'step'">
      <xsl:variable name="sdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="stype" select="($sdepth mod $format.length)+1"/>
      <xsl:value-of select="substring($procedure.step.numeration.formats,$stype,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected context in procedure.step.numeration: </xsl:text>
        <xsl:value-of select="local-name($context)"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="step" mode="number">
  <xsl:param name="rest" select="''"/>
  <xsl:param name="recursive" select="1"/>
  <xsl:variable name="format">
    <xsl:call-template name="procedure.step.numeration"/>
  </xsl:variable>
  <xsl:variable name="num">
    <xsl:number count="step" format="{$format}"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$recursive != 0 and ancestor::step">
      <xsl:apply-templates select="ancestor::step[1]" mode="number">
        <xsl:with-param name="rest" select="concat('.', $num, $rest)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($num, $rest)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="qandaset">
<xsl:apply-templates select="indexterm"/>
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(title)">
<xsl:text>
\vspace{12pt}\centerline{\bfseries </xsl:text><xsl:value-of select="$caption"/><xsl:text>}</xsl:text>
  </xsl:if>
<xsl:text>
\enhanceindent</xsl:text>
  <xsl:variable name="questions" select=".//question"/>
  <xsl:apply-templates select="$questions" mode="toc"/>
<xsl:text>
\addvspace{12pt}\hrule
</xsl:text>
<xsl:apply-templates/>
<xsl:text>
\reduceindent\addvspace{6pt minus 2pt}</xsl:text>
</xsl:template>

<xsl:template match="qandaentry">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="question">
  <xsl:variable name="qanum">
    <xsl:call-template name="object.num"/>
  </xsl:variable>
  <xsl:call-template name="anchor">
    <xsl:with-param name="oid" select="concat('qanda', $qanum)"/>
  </xsl:call-template>
  <xsl:call-template name="anchor.label">
    <xsl:with-param name="oid" select="concat('qanda', $qanum)"/>
  </xsl:call-template>
  <xsl:value-of select="concat('&#10;\descrtitle{\userinput{', $qanum, '}\boldface{')"/>
  <xsl:apply-templates/>
<xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="answer">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="question" mode="toc">
  <xsl:variable name="qanum">
    <xsl:call-template name="object.num"/>
  </xsl:variable>
  <xsl:variable name="objid">
    <xsl:call-template name="anchor.id">
      <xsl:with-param name="oid" select="concat('qanda', $qanum)"/>
    </xsl:call-template>
  </xsl:variable>
<xsl:value-of select="concat('&#10;\descrtitle{\userinput{', $qanum, '}\URLtext{\hyperlink{', $objid, '}{\boldface{')"/>
  <xsl:apply-templates/>
<xsl:text>}}}}</xsl:text>
</xsl:template>

<xsl:template name="object.num">
  <xsl:param name="object" select="."/>
  <xsl:variable name="objnum">
    <xsl:if test="($object/ancestor-or-self::chapter)">
      <xsl:number from="belge" count="chapter" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::sect1)">
      <xsl:number from="belge" count="sect1" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::sect2)">
      <xsl:number from="belge" count="sect2" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::sect3)">
      <xsl:number from="belge" count="sect3" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::sect4)">
      <xsl:number from="belge" count="sect4" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::sect5)">
      <xsl:number from="belge" count="sect5" format="1."/>
    </xsl:if><!--xsl:if test="($object/ancestor-or-self::qandaset)">
      <xsl:number from="belge" count="qandaset" format="1."/>
    </xsl:if><xsl:if test="($object/ancestor-or-self::qandadiv)">
      <xsl:number from="belge" count="qandadiv" format="1."/>
    </xsl:if--><xsl:if test="($object/ancestor-or-self::qandaentry)">
      <xsl:number from="belge" count="qandaentry" format="1."/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:variable>
  <xsl:value-of select="$objnum"/>
</xsl:template>

<xsl:template match="calloutlist">
  <xsl:variable name="caption">
    <xsl:apply-templates mode="titlemode"/>
  </xsl:variable>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
  </xsl:if>
<xsl:text>
\enhanceindent</xsl:text>
    <xsl:if test="(title)">
<xsl:text>
\vspace{12pt}\centerline{\bfseries </xsl:text><xsl:value-of select="$caption"/><xsl:text>}</xsl:text>
    </xsl:if>
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:apply-templates/>
<xsl:text>
\reduceindent</xsl:text>
</xsl:template>

<xsl:template match="callout">
  <xsl:variable name="targets" select="key('id',@arearefs)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="conum">
    <xsl:apply-templates select="$target" mode="conum"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="(para)">
      <xsl:value-of select="concat('&#10;\itempar{\hyperlink{', @arearefs, '}{\URLtext{\conum{', $conum, '}}}}')"/>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('&#10;\itempar{\hyperlink{', @arearefs, '}{\URLtext{\conum{', $conum, '}}}}{')"/>
      <xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="bibliodiv">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:if test="(title)">
<xsl:text>
\vspace{12pt}{\large\bfseries </xsl:text>
<xsl:number/><xsl:text>. </xsl:text>
<xsl:apply-templates mode="titlemode"/>
<xsl:text>}\vskip.1pt\enhanceindent</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="(title)">
    <xsl:text>\reduceindent</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed">
  <xsl:if test="(@id)">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="anchor.label"/>
  </xsl:if>
  <xsl:variable name="abbr">
    <xsl:choose>
      <xsl:when test="(abbrev)">
        <xsl:apply-templates select="abbrev"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[</xsl:text>
        <xsl:if test="(ancestor::bibliodiv)">
          <xsl:number from="belge" count="bibliodiv" format="1."/>
        </xsl:if>
        <xsl:number/>
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="&uplisting;">
      <xsl:value-of select="$abbr"/>
      <xsl:text>\\</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\vskip.1pt\enhanceindent\descrtitle{</xsl:text>
      <xsl:value-of select="$abbr"/>
      <xsl:text>}\indentedpar{</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="*[not (self::abstract)]" mode="biblio"/>
  <xsl:choose>
    <xsl:when test="(abstract)">
      <xsl:text>}</xsl:text>
      <xsl:apply-templates select="abstract" mode="biblio"/>
      <xsl:if test="not (&uplisting;)">
        <xsl:text>\reduceindent</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (&uplisting;)">
        <xsl:text>}\reduceindent</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="author" mode="biblio">
  <xsl:text>\boldface{</xsl:text>
  <xsl:call-template name="person.name"/>
  <xsl:text>} \tmonospace{--\strut--} </xsl:text>
</xsl:template>

<xsl:template match="copyright" mode="biblio">
  <xsl:text>Telif Hakkı © </xsl:text>
  <xsl:apply-templates select="year" mode="copyright"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="holder" mode="copyright"/>
  <xsl:text> \tmonospace{--\strut--} </xsl:text>
</xsl:template>

<xsl:template match="edition|isbn|pagenums|publishername|releaseinfo" mode="biblio">
  <xsl:apply-templates/>
  <xsl:text> \tmonospace{--\strut--} </xsl:text>
</xsl:template>

<xsl:template match="pubdate" mode="biblio">
  <xsl:call-template name="texize"/>
</xsl:template>

<xsl:template match="abstract" mode="biblio">
  <xsl:text>\begin{indenteditem}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{indenteditem}</xsl:text>
</xsl:template>

<xsl:template match="publisher" mode="biblio">
  <xsl:apply-templates mode="biblio"/>
</xsl:template>

<xsl:template match="title" mode="biblio">
  <xsl:text>\iboldface{</xsl:text>
  <xsl:call-template name="texize"/>
  <xsl:text>} \tmonospace{--\strut--} </xsl:text>
</xsl:template>

</xsl:stylesheet>
