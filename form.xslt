<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	
	<!-- ==================== -->
	<!-- NAMED TEMPLATES      -->
	<!-- ==================== -->
	
	<!-- ** JS ESCAPE TEMPLATE ** -->
	<xsl:template name="js-escape">
		<xsl:param name="text"/>
		
		<xsl:if test="string-length($text) > 0">
			<xsl:value-of select="substring-before(concat($text, '&quot;'), '&quot;')"/>
			
			<xsl:if test="contains($text, '&quot;')">
				<xsl:text>\&quot;</xsl:text>

				<xsl:call-template name="js-escape">
					<xsl:with-param name="text" select="substring-after($text, '&quot;')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- ** JS STRING TEMPLATE ** -->
	<xsl:template name="js-string">
		<xsl:param name="text"/>
		
		<xsl:text>&quot;</xsl:text>
		
		<xsl:call-template name="js-escape">
			<xsl:with-param name="text" select="normalize-space($text)" />
		</xsl:call-template>
		
		<xsl:text>&quot;</xsl:text>
	</xsl:template>
	
	<!-- ==================== -->
	<!-- MATCHED TEMPLATES    -->
	<!-- ==================== -->
	
	<!-- ** MATCH ROOT ** -->
	<xsl:template match="/">
		<xsl:text>(function(){ </xsl:text>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENTTYPES']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='PARAMETERS']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='FORM']"/>
		
		<xsl:text> })();</xsl:text>
	</xsl:template>
	
	<!-- ** MATCH PARAMETER DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='PARAMETERS']">
		<xsl:text>var placeholder = document.getElementById(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value != 'null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>); </xsl:text>
	</xsl:template>
	
	<!-- ** MATCH FORM DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='FORM']">
		<xsl:text>var form = document.createElement("form"); </xsl:text>
		
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value!='null'">
				<xsl:text>form.setAttribute("id", </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="concat('form_', property[@name='2']/@value)"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:text>placeholder.appendChild(form); </xsl:text>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENTS' and property[@name='3']/@value='null']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='ATTRIBUTES' and property[@name='6']/@value='null']"/>
	</xsl:template>
	
	<!-- ** MATCH ELEMENT TYPES DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='ELEMENTTYPES']">
		<xsl:text>function element_</xsl:text>
		<xsl:value-of select="property[@name='2']/@value"/>
		<xsl:text>(data, parent, form) {</xsl:text>
		<xsl:value-of select="normalize-space(property[@name='3']/@value)"/>
		<xsl:text>};</xsl:text>
	</xsl:template>
	
	<!-- ** MATCH ELEMENTS DATA ** -->
	<xsl:template match="//data[property[@name='1']/@value='ELEMENTS']">
		<xsl:text>(function(parent, form) { </xsl:text>
		
		
		<xsl:text>var data = { </xsl:text>
		
		<xsl:text>"id": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='2']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>, </xsl:text>
		
		<xsl:text>"typeCd": </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value!='null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
				
		<xsl:text>}; </xsl:text>
		
		
		<xsl:text>var references = element_</xsl:text>
		<xsl:value-of select="property[@name='4']/@value"/>
		<xsl:text>(data, parent, form); </xsl:text>
		
		
		<xsl:text>var parent = references.oneItem; </xsl:text>
		
		
		<xsl:variable name="ID" select="property[@name='2']/@value"/>
		<xsl:apply-templates select="//data[property[@name='1']/@value='ELEMENTS' and property[@name='3']/@value=$ID]"/>
		
		<xsl:text>})</xsl:text>
		
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value != 'null'">
				<xsl:text>parent</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>form</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, form); </xsl:text>
	</xsl:template>
	
	<!-- ** MATCH FORM ATTRIBUTES DATA ** -->
	<!--
	<xsl:template match="//data[property[@name='1']/@value='ATTRIBUTES']">
		<xsl:choose>
			<xsl:when test="property[@name='6']/@value != 'null'">
				<xsl:text>element.setAttribute</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>form.setAttribute</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>(</xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value != 'null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, </xsl:text>
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value != 'null'">
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>null</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>);</xsl:text>
	</xsl:template>
	-->
	
	
</xsl:stylesheet>