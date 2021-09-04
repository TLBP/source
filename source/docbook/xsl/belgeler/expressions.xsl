<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: expressions-html.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ********************************************************************
-->
<!-- Copyright ©  2004  Nilgün Belma Bugüner <nilgun@belgeler·gen·tr> -->
<!-- This program is free software; you can redistribute it and/or modify -->
<!-- it under the terms of the GNU General Public License as published by -->
<!-- the Free Software Foundation; either version 2 of the License, or -->
<!-- (at your option) any later version.-->
<!--  -->
<!-- This program is distributed in the hope that it will be useful,-->
<!-- but WITHOUT ANY WARRANTY; without even the implied warranty of -->
<!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the -->
<!-- GNU General Public License for more details.-->
<!-- -->
<!-- You should have received a copy of the GNU General Public License -->
<!-- along with this program; if not, write to the Free Software -->
<!-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA -->
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY sep '" "'>


]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
<xsl:variable name="fracchar" select="'&#x2500;'"/>

<xsl:template name="chararray">
  <xsl:param name="char" select="' '"/>
  <xsl:param name="len" select="2"/>
  <xsl:param name="str" select="''"/>
  <xsl:choose>
    <xsl:when test="string-length($str) &lt; $len">
        <xsl:call-template name="chararray">
          <xsl:with-param name="char" select="$char"/>
          <xsl:with-param name="len" select="$len"/>
          <xsl:with-param name="str" select="concat($str, $char)"/>
        </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="expr">
  <xsl:choose>
    <xsl:when test="(./*/frac)">
      <table cellpadding="0" cellspacing="0" border="0" class="hexpr">
        <tr align="char" char="&#x200b;"><xsl:apply-templates/></tr>
      </table>
    </xsl:when>
    <xsl:otherwise>
      <table cellpadding="0" cellspacing="0" border="0" class="expr">
        <tr align="char" char="&#x200b;"><xsl:apply-templates/></tr>
      </table>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="num|var|varnum">
  <td valign="middle" align="center">
    <span class="{name(.)}">
      <xsl:apply-templates/>          
    <xsl:if test="@super">
      <span id="varsup" class="subsup">
        <xsl:value-of select="@super"/>
      </span>
    </xsl:if>
    <xsl:if test="@subs">
      <span id="varsub" class="subsup">
        <xsl:value-of select="@subs"/>
      </span>
    </xsl:if>
    </span>
  </td>
</xsl:template>

<xsl:template match="nom|denom">
  <table cellpadding="0" cellspacing="0" border="0">
    <tr><xsl:apply-templates/></tr>
  </table>
</xsl:template>

<xsl:template match="frac">
  <xsl:variable name="nomtxt">
    <xsl:apply-templates select="nom"/>
  </xsl:variable>
  <xsl:variable name="denomtxt">
    <xsl:apply-templates select="denom"/>
  </xsl:variable>
  <xsl:variable name="divline">
    <xsl:choose>
      <xsl:when test="string-length($nomtxt) > string-length($denomtxt)">
        <xsl:call-template name="chararray">
          <xsl:with-param name="char" select="$fracchar"/>
          <xsl:with-param name="len" select="string-length(normalize-space($nomtxt))"/>
        </xsl:call-template>
       </xsl:when>
       <xsl:when test="string-length(normalize-space($nomtxt)) > 2">
        <xsl:call-template name="chararray">
          <xsl:with-param name="char" select="$fracchar"/>
          <xsl:with-param name="len" select="string-length(normalize-space($nomtxt))"/>
        </xsl:call-template>
       </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="chararray">
          <xsl:with-param name="char" select="$fracchar"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="(../mainop)">
      <td valign="middle" align="center">
        <table cellpadding="0" cellspacing="0" border="0">
          <tr><td id="tdnom" align="center"><xsl:apply-templates select="nom"/></td></tr>
          <tr><td id="blok"><span class="divline">&#x200b;<xsl:value-of select="$divline"/></span></td></tr>
          <tr><td id="tddenom" align="center"><xsl:apply-templates select="denom"/></td></tr>
        </table>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <td valign="middle" align="center">
        <table cellpadding="0" cellspacing="0" border="0">
          <tr><td id="tdnom" align="center"><xsl:apply-templates select="nom"/></td></tr>
          <tr><td><span class="divline"><xsl:value-of select="$divline"/></span></td></tr>
          <tr><td id="tddenom" align="center"><xsl:apply-templates select="denom"/></td></tr>
        </table>
      </td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="abs|brace|bracket|par">
  <xsl:variable name="str">
    <xsl:choose>
      <xsl:when test="name(.) = 'abs'">
        <xsl:text>&#x23b8;&#x23b8;&#x23b8;&#x23b9;&#x23b9;&#x23b9;</xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'brace'">
         <xsl:text>&#x23a7;&#x23a8;&#x23a9;&#x23ab;&#x23ac;&#x23ad;</xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'bracket'">
         <xsl:text>&#x23a1;&#x23a2;&#x23a3;&#x23a4;&#x23a5;&#x23a6;</xsl:text>
      </xsl:when>
      <xsl:when test="name(.) = 'par'">
         <xsl:text>&#x239b;&#x239c;&#x239d;&#x239e;&#x239f;&#x23a0;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="chars">
   <xsl:choose>
      <xsl:when test="name(.) = 'abs'"><xsl:text>&#x23b8;&#x23b9;</xsl:text></xsl:when>
      <xsl:when test="name(.) = 'brace'"><xsl:text>{}</xsl:text></xsl:when>
      <xsl:when test="name(.) = 'bracket'"><xsl:text>[]</xsl:text></xsl:when>
      <xsl:when test="name(.) = 'par'"><xsl:text>()</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="frac/frac">
    </xsl:when>
    <xsl:when test="frac">
      <td valign="middle" align="center">
       <table cellpadding="0" cellspacing="0" border="0">
        <tr><td><span id="pardown" class="bigop"><xsl:value-of select="substring($str, 1, 1)"/></span></td></tr>
        <tr><td><span class="bigop"><xsl:value-of select="substring($str, 2, 1)"/></span></td></tr>
        <tr><td><span id="parup" class="bigop"><xsl:value-of select="substring($str, 3, 1)"/></span></td></tr>
      </table></td>
      <xsl:apply-templates/>
      <td valign="middle" align="center">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr><td><span id="pardown" class="bigop"><xsl:value-of select="substring($str, 4, 1)"/></span> </td></tr>
        <tr><td><span  class="bigop"><xsl:value-of select="substring($str, 5, 1)"/></span></td></tr>
        <tr><td><span id="parup" class="bigop"><xsl:value-of select="substring($str, 6, 1)"/></span></td></tr>
       </table></td>
       <xsl:if test="@subs or @super">
        <td align="left">
        <table cellpadding="0" cellspacing="0" border="0">
        <tr><td><xsl:if test="@super"><span id="sup" class="subsup"><xsl:value-of select="@super"/></span></xsl:if></td></tr>
        <tr><td></td></tr>
        <tr><td><xsl:if test="@subs"><span id="sub" class="subsup"><xsl:value-of select="@subs"/></span></xsl:if></td></tr>
        </table></td>      
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <td valign="middle" align="center" class="op">
        <span id="parlft" class="{name(.)}">
          <xsl:value-of select="substring($chars, 1, 1)"/><xsl:text>&#x200a;</xsl:text>
        </span>
      </td><td valign="middle" align="center">
        <xsl:apply-templates/>
      </td><td valign="middle" align="center" class="op">
        <span id="parrgt" class="{name(.)}">
          <xsl:text>&#x200a;</xsl:text><xsl:value-of select="substring($chars, 2, 1)"/>
        </span>
      </td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template  match="sqr">  
  <xsl:variable name="content">
    <xsl:apply-templates select="*[not (name(.) = 'sup')]"/>
  </xsl:variable>
  <xsl:variable name="sqrline">
    <xsl:call-template name="chararray">
      <xsl:with-param name="char" select="'&#x23ba;'"/>
      <xsl:with-param name="len" select="string-length(normalize-space($content))+1"/>
    </xsl:call-template>
  </xsl:variable>  
  <xsl:choose>
    <xsl:when test="(frac)">
    </xsl:when>
    <xsl:otherwise>
     <td valign="middle"><div id="sqrdiv">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td>
            <xsl:if test="@super">
              <span id="sqrsup" class="subsup">
                <xsl:text>  &#x200a;</xsl:text>
              </span>
            </xsl:if>
            <span id="sqropup"><xsl:text>&#x23b9;</xsl:text></span></td>
          <td id="sqrline"><xsl:value-of select="$sqrline"/></td>
        </tr>
        <tr>
          <td>
            <xsl:if test="@super">
              <span id="sqrsup" class="subsup">
                <xsl:value-of select="@super"/>
              </span>
            </xsl:if>
            <span id="sqrop"><xsl:text>&#x23b7;</xsl:text></span>
          </td>
          <td id="sqrtxt"><table cellpadding="0" cellspacing="0" border="0">
            <tr><xsl:copy-of select="$content"/></tr></table>
          </td>
        </tr>
      </table></div></td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template  match="func">
  <td valign="middle" align="center" class="op"><i>&#x0192;</i>(</td>
  <td valign="middle" align="center"><xsl:apply-templates/></td>
  <td valign="middle" align="center" class="op">)</td>
</xsl:template>

<xsl:template match="delta|eq|ge|gt|le|lt|minus|ne|plus|comma">
  <xsl:variable name="char">
      <xsl:choose>
        <xsl:when test="name(.) = 'delta'"><xsl:text>&#x2206;&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'eq'"><xsl:text>&#xa0;=&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'ge'"><xsl:text>&#xa0;≥&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'gt'"><xsl:text>&#xa0;>&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'le'"><xsl:text>&#xa0;≤&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'lt'"><xsl:text>&#xa0;&lt;&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'minus'"><xsl:text>&#xa0;–&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'ne'"><xsl:text>&#xa0;≠&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'plus'"><xsl:text>&#xa0;+&#xa0;</xsl:text></xsl:when>
        <xsl:when test="name(.) = 'comma'"><xsl:text>,&#xa0;</xsl:text></xsl:when>
     </xsl:choose>
  </xsl:variable>
  <td><span class="{name(.)}"><xsl:value-of select="$char"/></span></td>
</xsl:template>

<xsl:template  match="mainop">
  <xsl:variable name="char">
      <xsl:choose>
        <xsl:when test="@op = 'eq'"><xsl:text>&#x200b;&#xa0;=&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'ge'"><xsl:text>&#x200b;&#xa0;≥&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'gt'"><xsl:text>&#x200b;&#xa0;>&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'le'"><xsl:text>&#x200b;&#xa0;≤&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'lt'"><xsl:text>&#x200b;&#xa0;&lt;&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'ne'"><xsl:text>&#x200b;&#xa0;≠&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'plus'"><xsl:text>&#x200b;&#xa0;+&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'comma'"><xsl:text>&#x200b;,&#xa0;</xsl:text></xsl:when>
        <xsl:when test="@op = 'mult'"><xsl:text>&#x200b;&#xa0;*&#xa0;</xsl:text></xsl:when>
     </xsl:choose>
  </xsl:variable>
  <td><span class="{@op}"><xsl:value-of select="$char"/></span></td>
</xsl:template>


</xsl:stylesheet>
