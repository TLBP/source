<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id: pi.xsl,v 1.4 2003/07/19 09:25:07 nilgun Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template match="processing-instruction()">
</xsl:template>

<xsl:template match="processing-instruction('dbhtml')">
  <xsl:if test="$using.chunker">
    <xsl:processing-instruction name="dbhtml">
      <xsl:value-of select="."/>
    </xsl:processing-instruction>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbhtml-attribute">
  <xsl:param name="pis" select="processing-instruction('dbhtml')"/>
  <xsl:param name="attribute">filename</xsl:param>

  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute" select="$attribute"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-filename">
  <xsl:param name="pis" select="./processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">filename</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir">
  <xsl:param name="pis" select="processing-instruction('')"/>
    <xsl:choose>
      <xsl:when test="$pis[1] != ''">
        <xsl:call-template name="dbhtml-attribute">
          <xsl:with-param name="pis" select="$pis"/>
          <xsl:with-param name="attribute">dir</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="./processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir1"/>
          </xsl:when>
          <xsl:when test="../processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir2"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::article/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.article"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::chapter/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.chapter"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::part/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.part"/>
          </xsl:when>
          <xsl:when test="ancestor-or-self::book/processing-instruction('dbhtml')">
            <xsl:call-template name="dbhtml-dir.book"/>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="dbhtml-dir1">
  <xsl:param name="pis" select="./processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir2">
  <xsl:param name="pis" select="../processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.book">
  <xsl:param name="pis" select="ancestor-or-self::book/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.part">
  <xsl:param name="pis" select="ancestor-or-self::part/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.chapter">
  <xsl:param name="pis" select="ancestor-or-self::chapter/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dbhtml-dir.article">
  <xsl:param name="pis" select="ancestor-or-self::article/processing-instruction('dbhtml')"/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute">dir</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="process.cmdsynopsis.list">
  <xsl:param name="cmdsynopses"/><!-- empty node list by default -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($cmdsynopses)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cmdsyn" select="$cmdsynopses[$count]"/>

       <dt>
       <a>
         <xsl:attribute name="href">
           <xsl:call-template name="object.id">
             <xsl:with-param name="object" select="$cmdsyn"/>
           </xsl:call-template>
         </xsl:attribute>

         <xsl:choose>
           <xsl:when test="$cmdsyn/@xreflabel">
             <xsl:call-template name="xref.xreflabel">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:call-template>
           </xsl:when>
           <xsl:otherwise>
             <xsl:apply-templates select="$cmdsyn" mode="xref-to">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:apply-templates>
           </xsl:otherwise>
         </xsl:choose>
       </a>
       </dt>

        <xsl:call-template name="process.cmdsynopsis.list">
          <xsl:with-param name="cmdsynopses" select="$cmdsynopses"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction('dbcmdlist')">
  <xsl:variable name="cmdsynopses" select="..//cmdsynopsis"/>

  <xsl:if test="count($cmdsynopses)&lt;1">
    <xsl:message><xsl:text>No cmdsynopsis elements matched dbcmdlist PI, perhaps it's nested too deep?</xsl:text>
    </xsl:message>
  </xsl:if>

  <dl>
    <xsl:call-template name="process.cmdsynopsis.list">
      <xsl:with-param name="cmdsynopses" select="$cmdsynopses"/>
    </xsl:call-template>
  </dl>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="process.funcsynopsis.list">
  <xsl:param name="funcsynopses"/><!-- empty node list by default -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($funcsynopses)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cmdsyn" select="$funcsynopses[$count]"/>

       <dt>
       <a>
         <xsl:attribute name="href">
           <xsl:call-template name="object.id">
             <xsl:with-param name="object" select="$cmdsyn"/>
           </xsl:call-template>
         </xsl:attribute>

         <xsl:choose>
           <xsl:when test="$cmdsyn/@xreflabel">
             <xsl:call-template name="xref.xreflabel">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:call-template>
           </xsl:when>
           <xsl:otherwise>
              <xsl:apply-templates select="$cmdsyn" mode="xref-to">
                <xsl:with-param name="target" select="$cmdsyn"/>
              </xsl:apply-templates>
           </xsl:otherwise>
         </xsl:choose>
       </a>
       </dt>

        <xsl:call-template name="process.funcsynopsis.list">
          <xsl:with-param name="funcsynopses" select="$funcsynopses"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction('dbfunclist')">
  <xsl:variable name="funcsynopses" select="..//funcsynopsis"/>

  <xsl:if test="count($funcsynopses)&lt;1">
    <xsl:message><xsl:text>No funcsynopsis elements matched dbfunclist PI, perhaps it's nested too deep?</xsl:text>
    </xsl:message>
  </xsl:if>

  <dl>
    <xsl:call-template name="process.funcsynopsis.list">
      <xsl:with-param name="funcsynopses" select="$funcsynopses"/>
    </xsl:call-template>
  </dl>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
