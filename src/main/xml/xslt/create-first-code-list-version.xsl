<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsd">

    <xsl:output
        encoding="UTF-8"
        indent="yes" />

    <xsl:param
        name="codeListShortName"
        required="true"
        as="xsd:string" />

    <xsl:param
        name="codeListVersionNumber"
        required="false"
        as="xsd:string"
        select="'1.0.0'" />

    <xsl:param
        name="codeListUuid"
        required="true"
        as="xsd:string" />

    <xsl:param
        name="codeListVersionUuid"
        required="true"
        as="xsd:string" />
        
    <xsl:template name="xsl:initial-template">
            
        <xsl:document>
            <gc:CodeList
                xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
                xmlns:dcterms="http://purl.org/dc/terms/">
                <Annotation>
                    <Description>
                        <dcterms:description>(udfyld beskrivelse)</dcterms:description>
                        <dcterms:provenance>(udfyld versionshistorik)</dcterms:provenance>
                        <dcterms:language>da</dcterms:language>
                        <dcterms:license>https://creativecommons.org/licenses/by/4.0/deed.da</dcterms:license>
                        <dcterms:source>(udfyld eller fjern kilde)</dcterms:source>
                    </Description>
                </Annotation>
                <Identification>
                    <ShortName>
                        <xsl:value-of select="$codeListShortName" />
                    </ShortName>
                    <Version>
                        <xsl:value-of select="$codeListVersionNumber" />
                    </Version>
                    <CanonicalUri>
                        <xsl:value-of select="'urn:uuid:' || $codeListUuid" />
                    </CanonicalUri>
                    <CanonicalVersionUri>
                        <xsl:value-of select="'urn:uuid:' || $codeListVersionUuid" />
                    </CanonicalVersionUri>
                    <Agency>
                        <LongName>(udfyld ejer)</LongName>
                    </Agency>
                </Identification>
                <ColumnSet>
                    <Column
                        Id="kode"
                        Use="required">
                        <Annotation>
                            <Description>
                                <dcterms:description>tilladt værdi i data</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>kode</ShortName>
                        <Data Type="string" />
                    </Column>
                    <Column
                        Id="navn"
                        Use="required">
                        <Annotation>
                            <Description>
                                <dcterms:description>foretrukne term for koden</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>navn</ShortName>
                        <Data
                            Type="string"
                            Lang="da" />
                    </Column>
                    <Column
                        Id="definition"
                        Use="optional">
                        <Annotation>
                            <Description>
                                <dcterms:description>kort beskrivelse eller formel forklaring af kodens betydning</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>definition</ShortName>
                        <Data
                            Type="string"
                            Lang="da" />
                    </Column>
                    <Column
                        Id="kommentar"
                        Use="optional">
                        <Annotation>
                            <Description>
                                <dcterms:description>kommentar som hjælper til afklaring af forståelse af koden</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>kommentar</ShortName>
                        <Data
                            Type="string"
                            Lang="da" />
                    </Column>
                    <Column
                        Id="virkningFra"
                        Use="required">
                        <Annotation>
                            <Description>
                                <dcterms:description>tidspunkt for hvornår koden må tages i anvendelse for nye registreringer</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>virkningFra</ShortName>
                        <Data Type="date" />
                    </Column>
                    <Column
                        Id="virkningTil"
                        Use="optional">
                        <Annotation>
                            <Description>
                                <dcterms:description>tidspunkt for hvornår koden ikke længere må anvendes i nye registreringer. Koden kan eksistere i data, der er registreret før dette tidspunkt</dcterms:description>
                            </Description>
                        </Annotation>
                        <ShortName>virkningTil</ShortName>
                        <Data Type="date" />
                    </Column>
                    <Key Id="key_kode">
                        <ShortName>key_kode</ShortName>
                        <ColumnRef Ref="kode" />
                    </Key>
                    <Key Id="key_navn">
                        <ShortName>key_navn</ShortName>
                        <ColumnRef Ref="navn" />
                    </Key>
                </ColumnSet>
                <SimpleCodeList>
                    <Row>
                        <Value ColumnRef="kode">
                            <SimpleValue>xyz</SimpleValue>
                        </Value>
                        <Value ColumnRef="navn">
                            <SimpleValue>Navn for xyz</SimpleValue>
                        </Value>
                        <Value ColumnRef="definition">
                            <SimpleValue>Definition for xyz</SimpleValue>
                        </Value>
                        <Value ColumnRef="kommentar">
                            <SimpleValue>Kommentar for xyz</SimpleValue>
                        </Value>
                        <Value ColumnRef="virkningFra">
                            <SimpleValue>1970-01-01</SimpleValue>
                        </Value>
                        <Value ColumnRef="virkningTil" />
                    </Row>
                </SimpleCodeList>
            </gc:CodeList>
        </xsl:document>
    </xsl:template>

</xsl:stylesheet>