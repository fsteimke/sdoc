<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs math"
  version="3.0">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  
  
  <xsl:template match="textobject"/>
  
  <xsl:template match="tgroup/colspec/@colwidth[matches(.,'%$')]" as="attribute(colwidth)">
    <xsl:attribute name="colwidth" select="replace(.,'%','*')"/>
  </xsl:template>
  
</xsl:stylesheet>