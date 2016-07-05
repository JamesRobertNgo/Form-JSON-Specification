<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	
	<!-- ==================== -->
	<!-- NAMED TEMPLATES      -->
	<!-- ==================== -->
	
	<!-- JS ESCAPE TEMPLATE -->
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
	
	<!-- JS STRING TEMPLATE -->
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
	
	<!-- MATCH ROOT -->
	<xsl:template match="/">
		<xsl:text>(function(){ </xsl:text>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='P']"/>
		
		<xsl:apply-templates select="//data[property[@name='1']/@value='F']"/>
		
		<xsl:text> })();</xsl:text>
	</xsl:template>
	
	<!-- MATCH PARAMETER DATA -->
	<xsl:template match="//data[property[@name='1']/@value='P']">
		
		<!-- PLACEHOLDER VARIABLE -->
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
	
	<!-- MATCH FORM DATA -->
	<xsl:template match="//data[property[@name='1']/@value='F']">
		
		<!-- FORM -->
		<xsl:text>var form = document.createElement("form"); </xsl:text>
		
		<!-- FORM ID -->
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value != 'null'">
				<xsl:text>form.setAttribute("id", </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="concat('form_', property[@name='2']/@value)"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<!-- FORM ACTION -->
		<xsl:choose>
			<xsl:when test="property[@name='3']/@value != 'null'">
				<xsl:text>form.setAttribute("action", </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='3']/@value"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<!-- FORM METHOD -->
		<xsl:choose>
			<xsl:when test="property[@name='4']/@value != 'null'">
				<xsl:text>form.setAttribute("method", </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="property[@name='4']/@value"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<!-- APPLY FORM ATTRIBUTES -->
		<xsl:apply-templates select="//data[property[@name='1']/@value='FA']"/>
		
		<!-- APPLY FORM MODS -->
		<xsl:apply-templates select="//data[property[@name='1']/@value='FM']"/>
		
		<!-- APPLY FORM ELEMENTS -->
		<xsl:apply-templates select="//data[property[@name='1']/@value='E' and property[@name='5']/@value='null']"/>
		
		<!-- FORM BUTTONS -->
		<xsl:text>var p = document.createElement("p"); </xsl:text>
		
		<xsl:choose>
			<xsl:when test="property[@name='2']/@value != 'null'">
				<xsl:text>p.setAttribute("id", </xsl:text>
				<xsl:call-template name="js-string">
					<xsl:with-param name="text" select="concat('form_', property[@name='2']/@value, '_buttons')"/>
				</xsl:call-template>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:text>var submit = document.createElement("input"); </xsl:text>
		<xsl:text>submit.setAttribute("type", "submit"); </xsl:text>
		
		<xsl:text>p.appendChild(submit); </xsl:text>
		
		<xsl:text>var reset = document.createElement("input"); </xsl:text>
		<xsl:text>reset.setAttribute("type", "reset"); </xsl:text>
		
		<xsl:text>p.appendChild(reset); </xsl:text>
		
		<xsl:text>form.appendChild(p); </xsl:text>
		
		<!-- INSERT FORM INTO PLACEHOLDER -->
		<xsl:text>placeholder.appendChild(form); </xsl:text>
	</xsl:template>
	
	<!-- MATCH FORM ATTRIBUTE DATA -->
	<xsl:template match="//data[property[@name='1']/@value='FA']">
		<xsl:text>form.setAttribute(</xsl:text>
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
		<xsl:text>); </xsl:text>
	</xsl:template>
	
	<!-- MATCH FORM MOD DATA -->
	<xsl:template match="//data[property[@name='1']/@value='FM']">
		<xsl:choose>
			<xsl:when test="property[@name='5']/@value != 'null'">
				<xsl:text>(function(form) { </xsl:text>
				
				<xsl:text>var data = { </xsl:text>
				
				<xsl:text>"id": </xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='2']/@value != 'null'">
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="property[@name='2']/@value"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>null</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>, </xsl:text>
				
				<xsl:text>"data": </xsl:text>
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
				
				<xsl:text>"modTypeCd": </xsl:text>
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
				
				<xsl:text>}; </xsl:text>
				
				<xsl:text>var code = function(data, form) { </xsl:text>
				<xsl:value-of select="normalize-space(property[@name='5']/@value)"/>
				<xsl:text>}; </xsl:text>
				
				<xsl:text>code(data, form); </xsl:text>
				
				<xsl:text>})(form); </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- MATCH ELEMENT DATA -->
	<xsl:template match="//data[property[@name='1']/@value='E']">
		<xsl:choose>
			<xsl:when test="property[@name='8']/@value != 'null'">
				<xsl:variable name="ID" select="property[@name='2']/@value"/>
				
				<xsl:text>(function(parent, form) { </xsl:text>
				
				<xsl:text>var data = { </xsl:text>
				
				<xsl:text>"id": </xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='2']/@value != 'null'">
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="$ID"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>null</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>, </xsl:text>
				
				<xsl:text>"name": </xsl:text>
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
				
				<xsl:text>"label": </xsl:text>
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
				
				<xsl:text>, </xsl:text>
				
				<xsl:text>"typeCode": </xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='6']/@value != 'null'">
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="property[@name='6']/@value"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>null</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>}; </xsl:text>
				
				<xsl:text>var elementCode = function(data, parent, form) { </xsl:text>
				<xsl:value-of select="normalize-space(property[@name='8']/@value)"/>
				<xsl:text>}; </xsl:text>
				
				<xsl:text>var element = elementCode(data, parent, form); </xsl:text>
				
				<xsl:text>var attributeCode = function(element) { </xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='9']/@value != 'null'">
						<xsl:value-of select="normalize-space(property[@name='9']/@value)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>return element</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>}; </xsl:text>
				
				<xsl:text>var attributeElement = attributeCode(element); </xsl:text>
				
				<!-- APPLY ELEMENT ATTRIBUTES -->
				
				<xsl:apply-templates select="//data[property[@name='1']/@value='EA' and property[@name='5']/@value=$ID]"/>
				
				<!-- APPLY ELEMENT MODS -->
				
				<xsl:apply-templates select="//data[property[@name='1']/@value='EM' and property[@name='7']/@value=$ID]"/>
				
				<!-- BUILD SUB ELEMENTS -->
				
				<xsl:apply-templates select="//data[property[@name='1']/@value='E' and property[@name='5']/@value=$ID]"/>
				
				<xsl:text>})(</xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='5']/@value != 'null'">
						<xsl:text>element, form</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>form, form</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>); </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- MATCH ELEMENT ATTRIBUTE DATA -->
	<xsl:template match="//data[property[@name='1']/@value='EA']">
		<xsl:if test="position() > 1">
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		
		<xsl:text>attributeElement.setAttribute(</xsl:text>
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
		<xsl:text>);&#xa;</xsl:text>
	</xsl:template>
	
	<!-- MATCH ELEMENT MOD DATA -->
	<xsl:template match="//data[property[@name='1']/@value='EM']">
		<xsl:choose>
			<xsl:when test="property[@name='6']/@value != 'null'">
				<xsl:text>(function(element, form) {</xsl:text>
				
				<xsl:text>var data = { </xsl:text>
				
				<xsl:text>"id": </xsl:text>
				<xsl:choose>
					<xsl:when test="property[@name='2']/@value != 'null'">
						<xsl:call-template name="js-string">
							<xsl:with-param name="text" select="property[@name='2']/@value"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>null</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>, </xsl:text>
				
				<xsl:text>"data": </xsl:text>
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
				
				<xsl:text>"typeCode": </xsl:text>
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
				
				<xsl:text>}; </xsl:text>
				
				<xsl:text>var code = function(data, form) { </xsl:text>
				<xsl:value-of select="normalize-space(property[@name='6']/@value)"/>
				<xsl:text>}; </xsl:text>
				
				<xsl:text>code(data, element, form); </xsl:text>
				
				<xsl:text>})(element, form); </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>