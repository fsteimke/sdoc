<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:f="http://docbook.org/ns/docbook/function" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:err="http://www.w3.org/2005/xqt-errors"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs math"
  version="3.0">
 
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:key name="k_id" match="*" use="@xml:id"/>
  
  <xd:doc>
    <xd:desc>
      <xd:p>The element where $xref points to</xd:p>
    </xd:desc>
    <xd:param name="xref">a cross reference</xd:param>
    <xd:return>the crossref target element</xd:return>
  </xd:doc>
  <xsl:function name="f:xref-target" as="element()?">
    <xsl:param name="xref" as="element(xref)"/>
    <xsl:variable name="refid" as="xs:string" select="
      if ($xref/@linkend) then
      $xref/@linkend
      else
      substring-after($xref/@xlink:href, '#')"/>
    
    <xsl:sequence select="key('k_id', $refid, root($xref))"/>
  </xsl:function>
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>Set mark at start and end of para elements which apply to particular architecture</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="para[@arch]" as="element(para)">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <phrase role="arch-start">
        <xsl:value-of select="@arch || '&#x202f;▶'"/>
      </phrase>
      <xsl:apply-templates select="node()"/>
      <phrase role="arch-end">
        <xsl:text>◀</xsl:text>
      </phrase>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>See <xd:a href="https://github.com/docbook/xslTNG/issues/648">xslTNG Stylesheets Issue
          648</xd:a></xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="imagedata/@width[ends-with(., '%')]" as="attribute(width)">
    <xsl:try>
      <xsl:variable name="m" as="xs:nonNegativeInteger" select="replace(.,'(\d+)%', '$1') => xs:nonNegativeInteger()"/>
      <xsl:attribute name="width" select="floor($m * 0.92) || '%'"/>
      <xsl:catch>
        <xsl:sequence select="."/>
      </xsl:catch>
    </xsl:try>
  </xsl:template>
  
  
</xsl:stylesheet>