<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:gt="urn:uuid:dcebd429-ed94-465a-a0a0-66e47def2454"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    name="create-next-code-list-version"
    version="3.1">

    <p:documentation>This step creates a new version of a code list from an existing one, intended as the starting point for further editing.
        A new UUID for the code list version is generated.
        The provenance description is reset to a placeholder.
        The XML elements containing publication information are completely removed.
    </p:documentation>
    
    <p:import href="generate-uuid.xpl" />

    <p:option
        name="gc-file-path-existing-version"
        as="xsd:string"
        required="true" />

    <p:option
        name="new-version-number"
        as="xsd:string"
        required="true" />

    <p:option
        name="debug"
        as="xsd:boolean"
        select="false()"
        static="true" />

    <p:variable
        name="gc-file-path-existing-version-urified"
        select="p:urify($gc-file-path-existing-version)" />

    <p:load
        name="load-gc-file"
        message="Load {$gc-file-path-existing-version-urified}"
        href="{$gc-file-path-existing-version-urified}"
        content-type="application/xml" />
        
    <p:variable
        name="short-name"
        select="/gc:CodeList/Identification/ShortName/text()" />

    <p:variable
        name="existing-version-number"
        select="/gc:CodeList/Identification/Version/text()" />

    <gt:generate-uuid
        name="generate-uuid"
        p:message="Generate new UUID for code list version" />

    <p:variable
        name="new-version-uuid"
        select="/c:result/text()" />

    <p:xslt
        name="transform-code-list-version"
        message="Create new version {$new-version-number} of {$short-name} based on version {$existing-version-number} and with new version UUID: {$new-version-uuid}"
        version="3.0">
        <p:with-input port="source">
            <p:pipe
                step="load-gc-file"
                port="result" />
        </p:with-input>
        <p:with-input
            port="stylesheet"
            href="../xslt/create-next-code-list-version.xsl" />
        <p:with-option
            name="parameters"
            select="map {'codeListVersionNumber' : $new-version-number, 
                         'codeListVersionUuid'   : $new-version-uuid }" />
    </p:xslt>

    <p:variable
        name="new-version-gc-file-path-uri"
        select="replace($gc-file-path-existing-version-urified, 'v' || $existing-version-number, 'v' || $new-version-number)" />

    <p:store
        name="store-new-version"
        message="Store version {$new-version-number} of {$short-name} in {$new-version-gc-file-path-uri}"
        href="{$new-version-gc-file-path-uri}" />

</p:declare-step>