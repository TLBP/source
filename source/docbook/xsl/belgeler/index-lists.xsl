<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [

<!-- Bir title'ı olanlar -->
<!ENTITY section    '(ancestor-or-self::set
                     |ancestor-or-self::book
                     |ancestor-or-self::part
                     |ancestor-or-self::reference
                     |ancestor-or-self::chapter
                     |ancestor-or-self::appendix
                     |ancestor-or-self::preface
                     |ancestor-or-self::section
                     |ancestor-or-self::sect1
                     |ancestor-or-self::sect2[(@chunkthis)]
                     |ancestor-or-self::bibliography
                     |ancestor-or-self::glossary)[last()]'>

<!ENTITY section.id 'generate-id(&section;)'>

]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:key name="item"
         match="itemizedlist"
         use="@role"/>

<xsl:template name="generate-item-index">
  <xsl:param name="target"></xsl:param>
  <xsl:variable name="subjects" select="key('item', $target)"/>
  <!--xsl:message>
    <xsl:value-of select="$target"/>;<xsl:value-of select="count($subjects)"/>
  </xsl:message-->
  <xsl:apply-templates select="$subjects" mode="index-list">
    <xsl:with-param name="target" select="$target"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="itemizedlist" mode="index-list">
  <xsl:param name="target"/>
  <xsl:if test="@role = $target">
    <!--xsl:variable name="targets" select="key('id',@role)"/>
    <xsl:variable name="this" select="$targets[1]"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="&section;" mode="title.markup"/>
    </xsl:variable>

    <xsl:variable name="sect.url">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select="&section;"/>
        <xsl:with-param name="ownerobject" select="$this"/>
        <xsl:with-param name="owner" select="'indexterm'"/>
      </xsl:call-template>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$sect.url"/>
      </xsl:attribute>
      <xsl:value-of select="$title"/>
    </a-->
    <xsl:apply-templates select="."/>
  </xsl:if>
</xsl:template>

<xsl:template name="generate-abstract-index">
  <xsl:choose>
    <xsl:when test="name(..)='book' or name(..)='part' or name(..)='reference'">
      <xsl:variable name="nodes" select="../part|../reference|../preface|../chapter
                                           |../article|../bibliography|../glossary
                                           |../bridgehead"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:element name="dt">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="owner" select="'division.toc'"/>
              <xsl:with-param name="object" select=".."/>
              <xsl:with-param name="role" select="'abstracts'"/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <!-- Bundan sonrakiler lazım olursa yazılacak -->
    <xsl:when test="name(..)='chapter' or name(..)='article'">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="role" select="'abstracts'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="section.toc">
        <xsl:with-param name="role" select="'abstracts'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate-tip-index">
  <xsl:choose>
    <xsl:when test="name(..)='book' or name(..)='part' or name(..)='reference'">
      <xsl:variable name="nodes" select="../part|../reference|../preface|../chapter
                                           |../article|../bibliography|../glossary
                                           |../bridgehead"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:element name="dt">
            <xsl:apply-templates select="$nodes" mode="toc">
              <xsl:with-param name="owner" select="'division.toc'"/>
              <xsl:with-param name="object" select=".."/>
              <xsl:with-param name="role" select="'tips'"/>
            </xsl:apply-templates>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
    <!-- Bundan sonrakiler lazım olursa yazılacak -->
    <xsl:when test="name(..)='chapter' or name(..)='article'">
      <xsl:call-template name="component.toc">
        <xsl:with-param name="role" select="'tips'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="section.toc">
        <xsl:with-param name="role" select="'tips'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate-example-index">
  <xsl:variable name="subjects" select="..//example"/>
  <!--xsl:message>
    <xsl:value-of select="$target"/>;<xsl:value-of select="count($subjects)"/>
  </xsl:message-->
  <dl>
    <xsl:apply-templates select="$subjects" mode="index-list">
      <xsl:with-param name="ownerobject" select="."/>
    </xsl:apply-templates>
  </dl>
</xsl:template>

<xsl:template match="example" mode="index-list">
  <xsl:param name="this"/>
  <xsl:variable name="sect.url">
    <xsl:call-template name="href.target">
      <xsl:with-param name="object" select="&section;"/>
      <xsl:with-param name="ownerobject" select="$this"/>
      <xsl:with-param name="owner" select="'indexterm'"/>
    </xsl:call-template>
  </xsl:variable>
  <dt><a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat($sect.url, '#')"/>
      <xsl:call-template name="example.id"/>
    </xsl:attribute>
    <xsl:apply-templates select="." mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </a></dt>
</xsl:template>

<xsl:template match="*" mode="subtoc.abstracts"/>

<xsl:template match="abstract" mode="subtoc.abstracts">
  <xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>