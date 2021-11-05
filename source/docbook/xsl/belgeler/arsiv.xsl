<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:d="http://docbook.org/ns/docbook"
 exclude-result-prefixes="d" version='1.0'>
<!--
   Copyright © 2002-2021 Nilgün Belma Bugüner <nilgun@tlbp·gen·tr>
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.

   You should have received a copy of the GNU Affero General Public License
   along with this program. If not, see &lt;https://www.gnu.org/licenses/&gt;.
-->

<!-- html dosyalar bölümlere göre ayrı dosyalara ayrılarak oluşturulsun -->
<xsl:template match="d:div">
  <xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
