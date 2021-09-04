<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY allcases "'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY sortcases "'ABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZ'">

<!ENTITY primary   'concat(primary/@sortas, primary[not(@sortas)], see/@sortas, see[not(@sortas)])'>
<!ENTITY secondary 'concat(secondary/@sortas, secondary[not(@sortas)])'>
<!ENTITY tertiary  'concat(tertiary/@sortas, tertiary[not(@sortas)])'>
<!ENTITY fourth  'concat(fourth/@sortas, fourth[not(@sortas)])'>

<!ENTITY section   '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::partintro
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2
                     |ancestor-or-self::sect3
                     |ancestor-or-self::sect4
                     |ancestor-or-self::sect5
                     |ancestor-or-self::refsect1
                     |ancestor-or-self::refsect2
                     |ancestor-or-self::refsect3
                     |ancestor-or-self::simplesect
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary
                     |ancestor-or-self::indexterm
                     |ancestor-or-self::index)[last()]'>

<!ENTITY section.t  '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::partintro
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2
                     |ancestor-or-self::sect3
                     |ancestor-or-self::sect4
                     |ancestor-or-self::sect5
                     |ancestor-or-self::refsect1
                     |ancestor-or-self::refsect2
                     |ancestor-or-self::refsect3
                     |ancestor-or-self::simplesect
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary
                     |ancestor-or-self::index)[last()]'>

<!ENTITY section.id 'generate-id(&section;)'>
<!ENTITY section.t.id 'generate-id(&section.t;)'>
<!ENTITY sep '" "'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- ==================================================================== -->
<!-- Jeni Tennison gets all the credit for what follows.
     I think I understand it :-) Anyway, I've hacked it a bit, so the
     bugs are mine. -->
<xsl:key name="term"
         match="indexterm"
         use="@scope"/>

<xsl:key name="letter"
         match="indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="primary"
         match="indexterm"
         use="&primary;"/>

<xsl:key name="secondary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<xsl:key name="fourth"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;)"/>

<xsl:key name="primary-section"
         match="indexterm[not(secondary) and not(see)]"
         use="concat(&primary;, &sep;, &section.id;)"/>

<xsl:key name="secondary-section"
         match="indexterm[not(tertiary) and not(see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &section.id;)"/>

<xsl:key name="tertiary-section"
         match="indexterm[not(fourth) and not(see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &section.id;)"/>

<xsl:key name="fourth-section"
         match="indexterm[not(see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, &section.id;)"/>

<xsl:key name="see-also"
         match="indexterm[seealso]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;, &sep;, seealso)"/>

<xsl:key name="sections" match="*[@id]" use="@id"/>

<xsl:template name="generate-index">
  <xsl:param name="target"></xsl:param>
  <xsl:variable name="others"
    select="key('term', $target)[not(contains(&allcases;, substring(&primary;, 1, 1)))]"/>

  <xsl:if test="$others">
<xsl:text>
\secttwo[Semboller]
\enhanceindent</xsl:text>
    <xsl:choose>
        <xsl:when test="count($others) > 1">
          <xsl:apply-templates select="$others[count(.|key('primary', &primary;)[1]) = 1]"
                                mode="index-primary">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:sort select="&primary;"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$others" mode="index-primary">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
<xsl:text>
\reduceindent</xsl:text>
  </xsl:if>
  <xsl:call-template name="alphabetical-index">
    <xsl:with-param name="target" select="$target"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="alphabetical-index">
  <xsl:param name="target"></xsl:param>
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>

    <xsl:if test="count(key('letter', $letter)[@scope=$target]) > 0">
<!--
      <xsl:message>
        <xsl:value-of select="$letter"/>,
        <xsl:value-of select="count(key('letter', $letter)[@scope=$target])"/>
        <xsl:value-of select="key('letter', $letter)[@scope=$target]/ancestor::*[(@id)][1]/@id"/>
      </xsl:message>
-->
<xsl:text>
\secttwo[</xsl:text><xsl:value-of select="$letter"/><xsl:text>]
\enhanceindent</xsl:text>
      <xsl:choose>
        <xsl:when test="count(key('letter', $letter)[@scope=$target]) > 1">
          <xsl:apply-templates select="key('letter', $letter)[@scope=$target][count(.|key('primary', &primary;)[1]) = 1]"
                                mode="index-primary">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:sort select="translate(&primary;,&allcases;,&sortcases;)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="key('letter', $letter)[@scope=$target]"
                                mode="index-primary">
            <xsl:with-param name="is.first" select="1"/>
            <xsl:with-param name="target" select="$target"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
<xsl:text>
\reduceindent</xsl:text>
    </xsl:if>

    <xsl:call-template name="alphabetical-index">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-primary">
  <xsl:param name="is.first" select="0"/>
  <xsl:param name="target"/>

  <xsl:if test="@scope = $target">
    <xsl:variable name="key" select="&primary;"/>
    <xsl:variable name="refs" select="key('primary', $key)[@scope = $target]"/>
    <xsl:variable name="desctitle">
      <xsl:apply-templates mode="alphabetic-index"/>

      <xsl:for-each select="$refs">
        <xsl:if test="not (./secondary) and not (see)">
          <xsl:if test="position()=1">
            <xsl:text>\dotfill </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
        <xsl:if test="not (primary)">
          <xsl:if test="position()=1">
            <xsl:text> - Bakınız\dotfill </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat('&#10;\descrtitle{', $desctitle, '}')"/>

    <xsl:if test="$refs/secondary">
      <xsl:text>&#10;\enhanceindent</xsl:text>
        <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[1]) = 1]"
                            mode="index-secondary">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&secondary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      <xsl:text>&#10;\reduceindent</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="alphabetic-index"/>
<xsl:template match="*" mode="alphabetic-index-s"/>
<xsl:template match="*" mode="alphabetic-index-t"/>
<xsl:template match="*" mode="alphabetic-index-f"/>

<xsl:template match="primary|see" mode="alphabetic-index">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="secondary" mode="alphabetic-index-s">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="tertiary" mode="alphabetic-index-t">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="fourth" mode="alphabetic-index-f">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary">
  <xsl:param name="target"/>
  <xsl:if test="@scope = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
    <xsl:variable name="refs" select="key('secondary', $key)"/>
    <xsl:variable name="desctitle">
      <xsl:apply-templates mode="alphabetic-index-s"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./tertiary)">
          <xsl:if test="position()=1">
            <xsl:text>\dotfill </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
   </xsl:variable>
    <xsl:value-of select="concat('&#10;\descrtitle{', $desctitle, '}')"/>

    <xsl:if test="$refs/tertiary">
      <xsl:text>&#10;\enhanceindent</xsl:text>
      <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[1]) = 1]"
                            mode="index-tertiary">
        <xsl:with-param name="target" select="$target"/>
        <xsl:sort select="translate(&tertiary;,&allcases;,&sortcases;)"/>
      </xsl:apply-templates>
      <xsl:text>&#10;\reduceindent</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
  <xsl:param name="target"/>
  <xsl:if test="@scope = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
    <xsl:variable name="refs" select="key('tertiary', $key)"/>
    <xsl:variable name="desctitle">
      <xsl:apply-templates mode="alphabetic-index-t"/>
      <xsl:for-each select="$refs">
        <xsl:if test="not (./fourth)">
          <xsl:if test="position()=1">
            <xsl:text>\dotfill </xsl:text>
          </xsl:if>
          <xsl:if test="position()>1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="." mode="reference-b"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat('&#10;\descrtitle{', $desctitle, '}')"/>

    <xsl:if test="$refs/fourth">
      <xsl:text>&#10;\enhanceindent</xsl:text>
        <xsl:apply-templates select="$refs[fourth and count(.|key('fourth', concat($key, &sep;, &fourth;))[1]) = 1]"
                              mode="index-fourth">
          <xsl:with-param name="target" select="$target"/>
          <xsl:sort select="translate(&fourth;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      <xsl:text>&#10;\reduceindent</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-fourth">
  <xsl:param name="target"/>
  <xsl:if test="@scope = $target">
    <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &fourth;)"/>
    <xsl:variable name="refs" select="key('fourth', $key)"/>
    <xsl:variable name="desctitle">
      <xsl:apply-templates mode="alphabetic-index-f"/>
      <xsl:for-each select="$refs">
        <xsl:if test="position()=1">
          <xsl:text>\dotfill </xsl:text>
        </xsl:if>
        <xsl:if test="position()>1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="." mode="reference-b"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat('&#10;\descrtitle{', $desctitle, '}')"/>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="reference-b">
  <xsl:variable name="label">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:value-of select="concat('\innerURL{\hyperlink{', $label, '}{\pageref*{', $label, '}}}')"/>
</xsl:template>

</xsl:stylesheet>
