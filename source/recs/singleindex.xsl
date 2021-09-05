<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'@abcçdefgğhıijklmnoöpqrsştuüvwxyz'">
<!ENTITY uppercase "'@ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY allcases  "'@abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ'">
<!ENTITY sortcases "'@ABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZABCCDEFGGHIIJKLMNOOPQRSSTUUVWXYZ'">

<!ENTITY primary   'concat(primary/@sortas, primary)'>
<!ENTITY secondary 'concat(secondary/@sortas, secondary)'>
<!ENTITY tertiary  'concat(tertiary/@sortas, tertiary)'>

<!-- Ayrı bir dosya oluşturabilenler -->
<!ENTITY section   '(ancestor-or-self::spec
                     |ancestor-or-self::div1
                     |ancestor-or-self::inform-div1
                     |ancestor-or-self::index)[last()]'>

<!-- Bir head'i olanlar -->
<!ENTITY section.t  '(ancestor-or-self::spec
                     |ancestor-or-self::div1
                     |ancestor-or-self::inform-div1
                     |ancestor-or-self::div2
                     |ancestor-or-self::div3
                     |ancestor-or-self::div4
                     |ancestor-or-self::div5
                     |ancestor-or-self::index)[last()]'>

<!ENTITY sep '" "'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml" version="1.0">

<!-- ==================================================================== -->

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

<xsl:key name="sections" match="*[@id]" use="@id"/>


<xsl:template name="generate-index">
  <xsl:variable name="others"
    select="//indexterm[not(contains(&allcases;,
                                      substring(&primary;, 1, 1)))]"/>
  <div class="letter-index">
    <center>
      <xsl:text>|&#160;</xsl:text>
      <xsl:call-template name="letter-index"/>
    </center>
  </div>
  <div class="index">
    <xsl:if test="$others">
      <div class="indexdiv">
        <h3>Semboller</h3>
        <dl>
          <xsl:apply-templates select="$others[count(.|key('primary',
                                       &primary;)[1]) = 1]"
                               mode="index-primary">

            <xsl:with-param name="is.first" select="1"/>
            <xsl:sort select="&primary;"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>
    <xsl:call-template name="alphabetical-index"/>
  </div>
</xsl:template>

<xsl:template name="letter-index">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>
    <xsl:variable name="harftekiler" select="//indexterm[translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)=$letter]"/>

    <xsl:if test="count($harftekiler) > 0">
      <a href="#idx-letter{$letternum}">
        <span class="indexletter">
          <xsl:value-of select="$letter"/>
        </span>
      </a>
      <xsl:text>&#160;|&#160;</xsl:text>
    </xsl:if>
    <xsl:if test="$letternum = 15">
      <br /><xsl:text>|&#160;</xsl:text>
    </xsl:if>

    <xsl:call-template name="letter-index">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="alphabetical-index">
  <xsl:param name="letternum" select="0"/>

  <xsl:if test="string-length(&uppercase;) > $letternum">
    <xsl:variable name="letter"
                select="substring(&uppercase;,$letternum + 1,1)"/>
    <xsl:variable name="harftekiler" select="//indexterm[translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)=$letter]"/>

    <xsl:if test="count($harftekiler) > 0">
      <div class="indexdiv">
        <a id="idx-letter{$letternum}" name="idx-letter{$letternum}"/>
        <h3><xsl:value-of select="$letter"/></h3>
        <dl>
<!--xsl:message>
<xsl:value-of select="$letter"/>; <xsl:value-of select="count($burdakiler)"/>; <xsl:value-of select="count($harftekiler)"/>;
</xsl:message-->
              <xsl:apply-templates select="$harftekiler[count(.|key('primary', &primary;)[1]) = 1]"
                                      mode="index-primary">
                <xsl:with-param name="is.first" select="1"/>
                <xsl:sort select="translate(&primary;,&allcases;,&sortcases;)"/>
              </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:call-template name="alphabetical-index">
      <xsl:with-param name="letternum" select="$letternum + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="indexterm" mode="index-primary">
  <xsl:param name="is.first" select="0"/>
  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)"/>

  <dt class="primary">
    <xsl:apply-templates mode="alphabetic-index"/>

    <xsl:for-each select="$refs[not(./secondary)]">
      <xsl:text>,  </xsl:text>
      <xsl:apply-templates select="." mode="reference-b">
        <xsl:with-param name="posnum" select="position()"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </dt>
  <xsl:if test="$refs/secondary">
    <dd class="indexterm">
      <dl>
        <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat(&primary;, &sep;, &secondary;))[1]) = 1]"
                             mode="index-secondary">
          <xsl:sort select="translate(&secondary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template name="incr">
  <xsl:param name="posnum" select="0"/>
  <xsl:value-of select="$posnum + 1"/>
</xsl:template>

<xsl:template match="*" mode="alphabetic-index"/>
<xsl:template match="*" mode="alphabetic-index-s"/>
<xsl:template match="*" mode="alphabetic-index-t"/>
<xsl:template match="*" mode="alphabetic-index-f"/>

<xsl:template match="primary" mode="alphabetic-index">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="secondary" mode="alphabetic-index-s">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="tertiary" mode="alphabetic-index-t">
  <span class="indexterm">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary">
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)"/>
  <dt class="secondary">
    <xsl:apply-templates mode="alphabetic-index-s"/>
    <xsl:for-each select="$refs[not (./tertiary)]">
      <xsl:text>,  </xsl:text>
      <xsl:apply-templates select="." mode="reference-b">
        <xsl:with-param name="posnum" select="position()"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </dt>
  <xsl:if test="$refs/tertiary">
    <dd class="indexterm">
      <dl>
        <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[1]) = 1]"
                             mode="index-tertiary">
          <xsl:sort select="translate(&tertiary;,&allcases;,&sortcases;)"/>
        </xsl:apply-templates>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)"/>
  <dt class="tertiary">
    <xsl:apply-templates mode="alphabetic-index-t"/>
    <xsl:for-each select="$refs">
      <xsl:text>,  </xsl:text>
      <xsl:apply-templates select="." mode="reference-b">
        <xsl:with-param name="posnum" select="position()"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </dt>
</xsl:template>

<xsl:template match="indexterm" mode="reference-b">
  <xsl:param name="posnum" select="1"/>

  <xsl:variable name="basename">
    <xsl:call-template name="fname.target"/>
  </xsl:variable>

  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat($basename, '#')"/>
      <xsl:call-template name="indexterm.id"/>
    </xsl:attribute>
    <xsl:value-of select="$posnum"/>
  </a>
</xsl:template>

</xsl:stylesheet>
