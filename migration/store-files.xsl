<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:f="http://docbook.org/ns/docbook/functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
  xpath-default-namespace="http://docbook.org/ns/docbook" version="3.0">

  <xsl:param name="output-directory" as="xs:string"/>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:output name="xml" method="xml" indent="false"/>

  <xsl:function name="f:href-absolute" as="xs:string">
    <xsl:param name="filename" as="xs:string"/>
    <xsl:sequence select="string-join(($output-directory, $filename), '/')"/>
  </xsl:function>

  <xsl:template match="*[processing-instruction('file')]" as="element()">
    <xsl:variable name="filename" as="xs:string"
      select="normalize-space(processing-instruction('file'))"/>
    <xsl:variable name="href-absolute" as="xs:string" select="f:href-absolute($filename)"/>
    <xsl:try>
      <xsl:result-document href="{$href-absolute}" format="xml">
        <xsl:copy>
          <xsl:apply-templates select="@*, * | comment()"/>
        </xsl:copy>
      </xsl:result-document>
      <xsl:element name="xi:include">
        <xsl:attribute name="href" select="$filename"/>
      </xsl:element>
      <xsl:catch>
        <xsl:message select="'Can''t write and incluce ' || $href-absolute || ': ' || $err:description"/>
        <xsl:copy>
          <xsl:apply-templates select="@*, *"/>
        </xsl:copy>
      </xsl:catch>
    </xsl:try>
  </xsl:template>
  
  <xsl:template match="*[processing-instruction('include')]" as="element(xi:include)">
    <xsl:element name="xi:include">
      <xsl:attribute name="href" select="normalize-space(processing-instruction('include'))"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
