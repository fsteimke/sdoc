<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:db="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

  <p:option name="project-dir" as="xs:string" select="'file:/c:/Users/Frank.Steimke/sdoc/'"/>
  <p:variable name="main-filename" as="xs:string" select="'MAIN.SLEDS.xml'"/>
  <p:variable name="original-dir" as="xs:string"
    select="string-join(($project-dir,'doc-sle-15SP7'),'/')"/>
  <p:variable name="main-input" as="xs:string"
    select="string-join(($original-dir,'xml',$main-filename),'/')"/>
  <p:variable name="output-dir" as="xs:string" select="string-join(($project-dir,'src'),'/')"/>
  <p:variable name="main-output" as="xs:string"
    select="string-join(($output-dir, $main-filename),'/')"/>
  <p:variable name="monolith-output" as="xs:string"
    select="string-join(($output-dir, 'MONOLITH.xml'),'/')"/>

  <p:variable name="xml-format" select="map{
    'method':'xml',
    'indent':true(),
    'suppress-indentation':'Q{http://docbook.org/ns/docbook}address Q{http://docbook.org/ns/docbook}literallayout Q{http://docbook.org/ns/docbook}programlisting Q{http://docbook.org/ns/docbook}programlistingco Q{http://docbook.org/ns/docbook}screen Q{http://docbook.org/ns/docbook}screenco Q{http://docbook.org/ns/docbook}screenshot Q{http://docbook.org/ns/docbook}synopsis'
    }"/>

  <p:xinclude fixup-xml-base="{true()}">
    <p:with-input>
      <p:document href="{$main-input}"/>
    </p:with-input>
  </p:xinclude>

  <p:xslt>
    <p:with-input port="stylesheet" href="basic-migration.xsl"/>
  </p:xslt>

  <p:xslt>
    <p:with-input port="stylesheet" href="corrections.xsl"/>
  </p:xslt>

  <p:xslt>
    <p:with-input port="stylesheet" href="remaining-tasks.xsl"/>
  </p:xslt>

  <p:store href="{$monolith-output}" name="monolith">
    <p:with-option name="serialization" select="$xml-format"/>
  </p:store>

  <p:xslt name="prepare-storing">
    <p:with-input port="stylesheet" href="store-files.xsl"/>
    <p:with-option name="parameters" select="map{'output-directory':$output-dir}"/>
  </p:xslt>

  <p:group name="store-files">
    <p:store href="{$main-output}">
      <p:with-option name="serialization" select="$xml-format"/>
    </p:store>

    <p:for-each>
      <p:with-input select="/">
        <p:pipe port="secondary" step="prepare-storing"/>
      </p:with-input>
      <p:store href="{base-uri(.)}">
        <p:with-option name="serialization" select="$xml-format"/>
      </p:store>
    </p:for-each>
  </p:group>

  <p:for-each>
    <p:with-input select="//db:imagedata">
      <p:pipe step="monolith" port="result"/>
    </p:with-input>
    <p:variable name="fileref" as="xs:string" select="/db:imagedata/@fileref"/>
    <p:variable name="basename" as="xs:string" select="tokenize($fileref,'/')[last()]"/>
    <p:variable name="type" select="tokenize($fileref,'\.')[last()]"/>
    <p:variable name="source"
      select="string-join(('file:/c:/Users/Frank.Steimke/sdoc','doc-sle-15SP7/images/src',$type,$basename),'/')"/>
    <p:variable name="dest" as="xs:string"
      select="string-join(('file:/c:/Users/Frank.Steimke/sdoc','src',$fileref),'/')"/>
    <p:try>
      <p:file-copy href="{$source}" target="{$dest}"/>
      <p:catch>
        <p:identity message="Missing {$fileref}"/>
      </p:catch>
    </p:try>
  </p:for-each>
</p:declare-step>
