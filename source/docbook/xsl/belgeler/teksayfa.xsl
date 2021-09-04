<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: belgeler-teksayfa-html.xsl,v 1.4 2002/09/30 18:00:32 nilgun Exp $
     ********************************************************************

    Copyright ©  2005  Nilgün Belma Bugüner <nilgun@belgeler·gen·tr>
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-->

<?xml-stylesheet type="text/css" href="../belgeler.css"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:import href="../html/docbook.xsl"/>
<!-- özelleştirilmiş xslt betikleri -->
<xsl:import href="arsiv.xsl"/>
<xsl:import href="autodict.xsl"/>
<xsl:import href="common.xsl"/>
<xsl:import href="expressions.xsl"/>
<xsl:import href="multindex.xsl"/>
<xsl:import href="reftoc.xsl"/>
<xsl:import href="xmldict.xsl"/>

<!-- özelleştirilmiş parametreler -->
<xsl:param name="chunk.sections" select="'0'"/>
<xsl:param name="chunk.section.depth" select="0"/>
<xsl:param name="toc.section.depth">0</xsl:param>
<xsl:param name="nochunk.article.children" select="'1'"/>
<xsl:param name="section.autolabel" select="0"/>
<xsl:param name="root.filename"/>
<xsl:param name="use.id.as.filename" select="'1'"/>
<xsl:param name="html.stylesheet" select="'../belgeler.css'"/>
<xsl:param name="admon.graphics.path">../images/xsl/</xsl:param>
<xsl:param name="callout.graphics.path">../images/xsl/callouts/</xsl:param>
<xsl:param name="navig.graphics.path">../images/xsl/</xsl:param>

</xsl:stylesheet>
