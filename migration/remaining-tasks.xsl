<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
  xpath-default-namespace="http://docbook.org/ns/docbook" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="3.0">
  
  <xsl:mode on-no-match="shallow-copy"/>

  <xd:doc>
    <xd:desc>
      <xd:p>Remove @xml:base Attribute. If it indicates a new file, add a PI:</xd:p>
      <xd:ul>
        <xd:li><xd:b>file: </xd:b>If it represents a file which will be written and included</xd:li>
        <xd:li><xd:b>include: </xd:b>If it represents a file which will only be included, since it
          was already written before (e. g. "Documentation conventions")</xd:li>
      </xd:ul>
    </xd:desc>
  </xd:doc>
  <xsl:template match="*[@xml:base]" as="node()+">
    <xsl:variable name="base" as="xs:string" select="tokenize(@xml:base, '/')[last()]"/>
    <xsl:variable name="instruction" as="xs:string?">
      <xsl:choose>
        <xsl:when test="exists(preceding::*[tokenize(@xml:base, '/')[last()] eq $base])">
          <xsl:sequence select="'include'"/>
        </xsl:when>
        <xsl:when test="not($base eq tokenize(parent::*/@xml:base, '/')[last()])">
          <xsl:sequence select="'file'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* except @xml:base"/>
      <xsl:if test="$instruction">
        <xsl:processing-instruction name="{$instruction}" select="tokenize(@xml:base, '/')[last()]"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="phrase[not(@*)]" as="node()*">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

</xsl:stylesheet>
