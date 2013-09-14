<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  exclude-result-prefixes="xs">

<xsl:output method="text" encoding="UTF-8"/>

<xsl:include href="classes_doc.xsl"/>

<xsl:param name="service" required="yes" as="xs:string"/>
<xsl:param name="destDirectory" required="yes" as="xs:string"/>

<xsl:template match="/">
  <xsl:variable name="classes" as="element()+">
    <xsl:apply-templates select="/wsdl:definitions/wsdl:types/xs:schema/*:complexType" mode="classes-doc"/>
  </xsl:variable>
  <xsl:apply-templates select="$classes" mode="php"/>
</xsl:template>

<xsl:template match="class" mode="php">
  <xsl:result-document href="{$destDirectory}/{@className}.php">&lt;?php

namespace dts\ebaysdk\<xsl:copy-of select="$service"/>;

/**
 *<xsl:apply-templates select="property" mode="property-list">
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
 */
class <xsl:value-of select="@className" /><xsl:apply-templates select="." mode="extends"/>
{
    public function __construct()
    {
    }
}
</xsl:result-document>
</xsl:template>

<xsl:template match="class" mode="extends">
  <xsl:choose>
    <xsl:when test="@extends='Base64BinaryType' or 
                    @extends='BooleanType' or
                    @extends='DecimalType' or
                    @extends='DoubleType' or
                    @extends='IntegerType' or
                    @extends='StringType' or
                    @extends='TokenType' or
                    @extends='URIType'"> extends \dts\ebaysdk\types\<xsl:value-of select="@extends"/></xsl:when>
    <xsl:when test="@extends"> extends \dts\ebaysdk\<xsl:copy-of select="$service"/>\<xsl:value-of select="@extends"/></xsl:when>
    <xsl:otherwise> extends \dts\ebaysdk\base\Base</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="property-list">
 * @property <xsl:value-of select="@type"/> $<xsl:value-of select="@name"/>
</xsl:template>

</xsl:stylesheet>
