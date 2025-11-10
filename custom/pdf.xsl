<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:f="http://docbook.org/ns/docbook/functions" xmlns:db="http://docbook.org/ns/docbook"
  xmlns:m="http://docbook.org/ns/docbook/modes"
  xmlns:mp="http://docbook.org/ns/docbook/modes/private" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:tp="http://docbook.org/ns/docbook/templates/private"
  xpath-default-namespace="http://docbook.org/ns/docbook" exclude-result-prefixes="#all"
  version="3.0">

  <xsl:import href="https://www.xoev.de/docbook-tng/resources/driver/pdf.xsl"/>

  <xsl:include href="driver-common.xsl"/>
  <xsl:param name="nominal-page-width" select="'170mm'"/>

  <!-- SUSE Book Titlepage (overrides $XSLTNG/resources/driver/pdf.xsl) ======================= -->
  <xsl:param name="logo-left">
    <img src="../custom/suselogo.png" style="opacity:0.33"/>
  </xsl:param>
  <xsl:param name="logo-right">
    <p class="DEMO">Experimental version for testing purpose only!</p>
  </xsl:param>

  <xsl:template match="book" mode="m:generate-titlepage" as="element()+">
    <div class="recto">
      <table class="logos">
        <colgroup>
          <col class="logo left"/>
          <col class="logo right"/>
        </colgroup>

        <tr>
          <td>
            <xsl:sequence select="$logo-left"/>
          </td>
          <td>
            <xsl:sequence select="$logo-right"/>
          </td>
        </tr>
      </table>
      <div class="recto-body">
        <p class="DEMO">My private, inofficial Version of:</p>
        <xsl:apply-templates mode="m:titlepage" select="
            info/productname,
            info/title">
          <xsl:with-param name="page" select="'recto'"/>
        </xsl:apply-templates>
      </div>
    </div>
    <div class="verso">
      <div class="verso-body">
        <xsl:apply-templates mode="m:titlepage" select="
            info/title,
            info/productname,
            info/abstract"/>
        <xsl:call-template name="tp:migration-text-1"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="productname" mode="m:titlepage">
    <xsl:variable name="content" as="xs:string"
      select="normalize-space(. || ' ' || ../productnumber)"/>
    <p>
      <span class="productname">
        <xsl:value-of select="$content"/>
      </span>
    </p>
  </xsl:template>

  <!-- SUSE TOCs in PDF have a unique style, realized as a table ============================== -->
  <xsl:template name="tp:toc">
    <xsl:param name="persistent" as="xs:boolean" tunnel="yes"/>
    <xsl:param name="root-element" as="element()" tunnel="yes"/>

    <xsl:if test="$root-element/self::book">
      <h1>
        <xsl:attribute name="class" select="string-join(('toc', local-name($root-element)), ' ')"/>
        <xsl:text>Contents</xsl:text>
      </h1>
    </xsl:if>

    <table>
      <xsl:attribute name="class" select="string-join(('list-of-titles', local-name($root-element)), ' ')"/>
      <xsl:apply-templates mode="m:toc-entry">
        <xsl:with-param name="persistent" select="$persistent" tunnel="yes"/>
        <xsl:with-param name="root-element" select="$root-element" tunnel="yes"/>
      </xsl:apply-templates>
    </table>

  </xsl:template>

  <xsl:template match="part" mode="m:toc-entry">
    <tr class="toc-entry part">
      <td class="number">
        <p>
          <xsl:apply-templates select="." mode="m:headline-number">
            <xsl:with-param name="purpose" select="'lot'"/>
          </xsl:apply-templates>
        </p>
      </td>
      <td class="title">
        <p>
          <a href="#{f:id(.)}">
            <xsl:apply-templates select="." mode="m:headline-title">
              <xsl:with-param name="purpose" select="'lot'"/>
            </xsl:apply-templates>
          </a>
        </p>
      </td>
    </tr>
    <xsl:apply-templates mode="m:toc-entry" select="preface | chapter | appendix"/>
  </xsl:template>

  <xsl:template match="preface | chapter | appendix" mode="m:toc-entry">
    <xsl:param name="root-element" as="element()" tunnel="yes"/>
    <tr>
      <xsl:attribute name="class" select="string-join(('toc-entry', local-name(.)), ' ')"/>
      
        <td class="number">
          <p><xsl:apply-templates select="." mode="m:headline-number">
            <xsl:with-param name="purpose" select="'lot'"/>
          </xsl:apply-templates></p>
        </td>
        <td class="title">
          <p><a href="#{f:id(.)}">
            <xsl:apply-templates select="." mode="m:headline-title">
              <xsl:with-param name="purpose" select="'lot'"/>
            </xsl:apply-templates>
          </a></p>
        </td>
      
    </tr>
    <xsl:if test="$root-element/self::book">
      <xsl:apply-templates select="sect1" mode="m:toc-entry">
        <xsl:with-param name="purpose" select="'lot'"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sect1" mode="m:toc-entry">
    <tr class="toc-entry sect1">
      <td class="number">
        <p>
          <xsl:apply-templates select="." mode="m:headline-number">
            <xsl:with-param name="purpose" select="'lot'"/>
          </xsl:apply-templates>
        </p>
      </td>
      <td class="title">
        <p>
          <a href="#{f:id(.)}">
            <xsl:apply-templates select="." mode="m:headline-title">
              <xsl:with-param name="purpose" select="'lot'"/>
            </xsl:apply-templates>
          </a>
        </p>
        <p class="toc-entry sect2">
          <xsl:for-each select="sect2">
            <span>
              <a href="#{f:id(.)}">
                <xsl:apply-templates select="." mode="m:headline-title">
                  <xsl:with-param name="purpose" select="'lot'"/>
                </xsl:apply-templates>
              </a>
            </span>
            <xsl:if test="position() lt last()">
              <span class="sep">
                <xsl:text>•</xsl:text>
              </span>
            </xsl:if>
          </xsl:for-each>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="tp:migration-text-1">
    <div class="INFO1">
      <p>File generated at <xsl:value-of
          select="current-dateTime() => format-dateTime('[Y]-[M]-[D] [H]:[m]')"/></p>
      <p>This is my own, <b>experimental version</b> of a Document from SUSE company. The only
        purpose of this document is the test of an alternative publishing mechanism. <b>Errors in
          the publishing mechanism may lead to wrong content.You can find the original version of
          this document at <a href="https://documentation.suse.com"
        >documentation.suse.com</a>.</b></p>
      <p>The books and articles exist as XML sources, conformant to the DocBook standard. SUSE
        publishes them with the DocBook XSLT 1.0 Stylesheets, which generate XSL-FO, and Apache FOP,
        which in turn generates PDF.</p>
      <p>This version is based on the same DocBook sources, but published with the new <a
          href="https://xsltng.docbook.org/">xslTNG Stylesheets</a>, which produce XHTML+CSS, and an
        rendering engine like <i>Antenna House</i> or <i>Weasyprint</i> to generate PDF. The only
        purpose of this version is a <i>"real life test"</i> of the new publishing mechanism,
        together with an <i>"DocBook TNG Framework"</i> that i wrote. It helps me to use and
        customize the xslTNG Stylesheets. — <i>Frank Steimke, Bremen, Gemany</i></p>
    </div>
  </xsl:template>

</xsl:stylesheet>
