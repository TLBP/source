<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
<!-- ********************************************************************
     $Id: belgeler-arsiv-html.xsl,v 1.2 2002/09/30 18:00:32 nilgun Exp $
     ******************************************************************** -->

<!-- Copyright ©  2002  Nilgün Belma Bugüner <nilgun@superonline.com> -->
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

<!-- html dosyalar bölümlere göre ayrı dosyalara ayrılarak oluşturulsun -->
<xsl:template match="div">
  <xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
