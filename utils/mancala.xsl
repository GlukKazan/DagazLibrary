<?xml version="1.0"?> 

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:output method="text" encoding="utf-8"/>
  
  <xsl:template match="/games">digraph graphname {
<xsl:for-each select="game">
    <xsl:variable name="q">"</xsl:variable>
    <xsl:variable name="name" select="name[1]"/>
    <xsl:for-each select="parent|related">
       <xsl:text>    </xsl:text>
       <xsl:value-of select="$q"/>
       <xsl:value-of select="text()"/> 
       <xsl:value-of select="$q"/> -> <xsl:value-of select="$q"/>
       <xsl:value-of select="$name"/>
       <xsl:value-of select="$q"/>
       <xsl:choose>
          <xsl:when test="name() = 'related'">[style=dotted]</xsl:when>
       </xsl:choose>;
</xsl:for-each>
</xsl:for-each>}
</xsl:template>

</xsl:stylesheet>
