<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: xtinline.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ******************************************************************** -->

<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "
  (ancestor::literallayout) or (ancestor::screen) or
  (ancestor::programlisting) or (ancestor::synopsis) or
  (ancestor::paramdef)">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template match="anchor">
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="anchor.label"/>
</xsl:template>

<xsl:template match="abbrev">
  <xsl:text>[</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="acronym
                    |classname
                    |constant
                    |computeroutput
                    |envar
                    |filename
                    |function
                    |literal
                    |productname
                    |prompt
                    |sgmltag
                    |systemitem
                    |statement
                    |structfield
                    |structname
                    |symbol|type">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\monospace{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="name(..) = 'title'">
          <xsl:text>\tuserinput{</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>\tmonospace{</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="acronym[(../glossentry)]">
  <xsl:text>\userinput{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="citation">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="concat('[', normalize-space($p), ']')"/>
</xsl:template>

<xsl:template match="option">
  <xsl:variable name="p0">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p">
    <xsl:choose>
      <xsl:when test="contains($p0, '&lt;i/>&lt;i/>')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p0"/>
          <xsl:with-param name="target" select="'&lt;i/>&lt;i/>'"/>
          <xsl:with-param name="replace" select="'--\strut--'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($p0, '&lt;i/>')">
        <xsl:call-template name="string.replace">
          <xsl:with-param name="string" select="$p0"/>
          <xsl:with-param name="target" select="'&lt;i/>'"/>
          <xsl:with-param name="replace" select="'--'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="ancestor::refentry">
      <xsl:value-of select="concat('\tuserinput{', $p, '}')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('\tmonospace{', $p, '}')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="application
                    |command
                    |userinput">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\userinput{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\tuserinput{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="emphasis
                    |citetitle
                    |firstterm
                    |para/glossterm
                    |lineannotation">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\italics{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\italics{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="emphasis[@role='bold']">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\boldface{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\boldface{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="parameter
                    |replaceable
                    |varname
                    |emphasis[&verbatim;]">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\replaceable{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\treplaceable{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="emphasis[@role='input']">
  <xsl:text>\boldface{\textcolor{linkcolor}{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="emphasis[@role='output']">
<xsl:text>\boldface{\textcolor{rplcolor}{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template match="guibutton">
  <xsl:text>\boldface{[</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>]}</xsl:text>
</xsl:template>

<xsl:template match="keycap|keycode">
  <xsl:text>&lt;\boldface{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}></xsl:text>
</xsl:template>

<xsl:template match="keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">~--~</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>--</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="*">
    <xsl:if test="position()>1"><xsl:value-of select="$joinchar"/></xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="menuchoice">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="guimenu">
  <xsl:text>\boldface{[</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>]} -> </xsl:text>
</xsl:template>

<xsl:template match="guimenuitem">
  <xsl:text>\boldface{[</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>]}</xsl:text>
</xsl:template>

<xsl:template match="quote">
  <xsl:text>``</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>''</xsl:text>
</xsl:template>

<xsl:template match="small">
  <xsl:text>\smallface{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="big">
  <xsl:text>\bigface{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="subscript">
  <xsl:text>\subscript{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="superscript">
  <xsl:text>\superscript{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="trademark">
  <xsl:apply-templates/><xsl:text>\superscript{TM}</xsl:text>
</xsl:template>

<xsl:template match="wordasword">
   <xsl:choose>
    <xsl:when test="&verbatim;">
      <xsl:text>\wordasword{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\wordasword{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sbr">
  <xsl:text>\strut\hfil\break </xsl:text>
</xsl:template>

<xsl:template match="sbr[ancestor::attribution]">
  <xsl:text>\\\strut\hfill </xsl:text>
</xsl:template>

<xsl:template match="co" mode="conum">
  <xsl:number count="co" format="1"/>
</xsl:template>

<xsl:template match="co">
  <xsl:variable name="conum">
    <xsl:number count="co" format="1"/>
  </xsl:variable>
  <xsl:value-of select="concat('\hypertarget{', @id, '}{}\conum{', $conum, '}')"/>
</xsl:template>

<xsl:template match="email">
  <xsl:variable name="adres">
    <xsl:call-template name="texize"/>
  </xsl:variable>
  <xsl:text>\othermail{</xsl:text>
  <xsl:call-template name="nospam">
    <xsl:with-param name="p" select="$adres"/>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="footnote">
  <xsl:variable name="objid">
    <xsl:call-template name="fn.id"/>
  </xsl:variable>
  <xsl:value-of select="concat('\backnote{', $objid, '}')"/>
</xsl:template>

<xsl:template match="footnoteref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="objid">
    <xsl:call-template name="fn.id">
      <xsl:with-param name="object" select="$target"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('\backnoteref{', $objid, '}')"/>
</xsl:template>

<xsl:template match="indexterm">
  <xsl:variable name="objid">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;\hypertarget{', $objid,'}{}\label{', $objid,'}')"/>
</xsl:template>

<xsl:template match="rfcmaybe|rfcmust|rfcshould">
    <xsl:apply-templates/>
    <xsl:if test="not (@unsigned)">
      <xsl:choose>
        <xsl:when test="name(.) = 'rfcmaybe'">
          <xsl:text> *SEÇİMLİK*</xsl:text>
        </xsl:when>
        <xsl:when test="name(.) = 'rfcmust'">
          <xsl:text> *ZORUNLU*</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> *ÖNERİ*</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>


