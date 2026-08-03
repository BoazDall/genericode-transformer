<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsd">
    
    <!-- 
    Stylesheet that removes publication information from a genericode file,
    updates its version information
    and resets the text regarding provenance to a placeholder.
    -->

    <xsl:output
        method="xml"
        encoding="UTF-8"
        indent="yes" />
        
    <!-- Avoid blank lines there where elements were removed. -->
    <xsl:strip-space elements="*"/>

    <!-- Identity transformation -->
    <xsl:mode on-no-match="shallow-copy" />

    <xsl:param
        name="codeListVersionNumber"
        required="true"
        as="xsd:string" />
        
    <xsl:param
        name="codeListVersionUuid"
        required="true"
        as="xsd:string" />

    <xsl:template match="Identification/Version">
        <xsl:copy>
            <xsl:value-of select="$codeListVersionNumber" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="Identification/CanonicalVersionUri">
        <xsl:copy>
            <xsl:value-of select="'urn:uuid:' || $codeListVersionUuid" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="dcterms:provenance">
        <xsl:copy>
            <xsl:text>(udfyld versionshistorik)</xsl:text>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="dcterms:available|LocationUri|AlternateFormatLocationUri">
        <!-- Do nothing, so do not copy. -->
    </xsl:template>

</xsl:stylesheet>