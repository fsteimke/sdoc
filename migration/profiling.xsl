<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd"
  xpath-default-namespace="http://docbook.org/ns/docbook" version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc><xd:p>SUSE uses <xd:i>@os, @arch</xd:i> and <xd:i>@condition</xd:i></xd:p> for
      profiling</xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:param name="profile-os">sles</xsl:param>
  <xsl:param name="profile-arch">x86_64;zseries;power;aarch64</xsl:param>
  <xsl:param name="profile-condition">suse-product</xsl:param>

  <xd:doc>
    <xd:desc>
      <xd:p>Check elements with <xd:b>effectivity attribute(s)</xd:b> against corresponding
        parameters</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="*[@os | @arch | @condition]" as="element()?" priority="10">
    <xsl:variable name="os" as="xs:boolean"
      select="tokenize(@os, ';') = tokenize($profile-os, ';') or not(@os)"/>
    <xsl:variable name="arch" as="xs:boolean"
      select="tokenize(@arch, ';') = tokenize($profile-arch, ';') or not(@arch)"/>
    <xsl:variable name="condition" as="xs:boolean"
      select="tokenize(@condition, ';') = tokenize($profile-condition, ';') or not(@condition)"/>
    <xsl:if test="$os and $arch and $condition">
      <xsl:copy copy-namespaces="no">
        <!-- we need the @arch attribute in para elements that survived profiling to set markers -->
        <xsl:apply-templates select="@* except (@os | @condition), node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
