<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esb="com.totvs.esb.XSLFunctions" xmlns:uuid="java:java.util.UUID" version="1.0" exclude-result-prefixes="esb" extension-element-prefixes="esb">
	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<xsl:template match="/">
		<xsl:element name="TOTVSIntegrator">
			<xsl:element name="GlobalProduct">
				<xsl:text disable-output-escaping="yes">PROTHEUS</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalFunctionCode">
				<xsl:text disable-output-escaping="yes">EAI</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionCode">
				<xsl:text disable-output-escaping="yes">CEAIA29</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionDescription">
				<xsl:text disable-output-escaping="yes">Usuarios RH</xsl:text>
			</xsl:element>
			<xsl:element name="DocVersion">
				<xsl:text disable-output-escaping="yes">1.0</xsl:text>
			</xsl:element>
			<xsl:element name="DocDateTime">
				<xsl:value-of select="current-dateTime()" />
			</xsl:element>      
			<xsl:element name="DocIdentifier"> 
				<xsl:value-of select="uuid:randomUUID()" />    
			</xsl:element>      
			<xsl:element name="DocCompany">
				<xsl:value-of select="/ROOT/UsuariosRH/DocCompany" />
			</xsl:element>
			<xsl:element name="DocBranch">
				<xsl:value-of select="/ROOT/UsuariosRH/DocBranch" />
			</xsl:element>
			<xsl:element name="DocName" />
			<xsl:element name="DocFederalID" />      
			<xsl:element name="DocType">
				<xsl:text disable-output-escaping="yes">2</xsl:text>
			</xsl:element>
			<xsl:element name="Message">
				<xsl:element name="Layouts">
					<xsl:element name="Identifier">
						<xsl:value-of select="/ROOT/HEADER/Identifier" />
						<xsl:text disable-output-escaping="yes">CEAIA29</xsl:text>
					</xsl:element>
					<xsl:element name="Version">
						<xsl:text disable-output-escaping="yes">1.0</xsl:text>
					</xsl:element>
					<xsl:element name="FunctionCode">
						<xsl:value-of select="/ROOT/UsuariosRH/FunctionCode" />
					</xsl:element>          
					<xsl:element name="Content">
						<xsl:element name="CEAIA29">
							<xsl:attribute name="Operation">
								<xsl:value-of select="/ROOT/UsuariosRH/Operation" />
							</xsl:attribute>
							<xsl:attribute name="version">
								<xsl:text disable-output-escaping="yes">1.01</xsl:text>
							</xsl:attribute>                        
							<xsl:element name="ZAAMASTER">
								<xsl:attribute name="modeltype">
									<xsl:text disable-output-escaping="yes">GRID</xsl:text>
								</xsl:attribute>
								<xsl:element name="items">                    
									<xsl:for-each select="/ROOT/UsuariosRH">
										<xsl:element name="item">
											<xsl:variable name="count" select="position()" />
											<xsl:attribute name="id">
												<xsl:value-of select="format-number($count,'000')" />
											</xsl:attribute> 
											
											<xsl:element name="ZAA_MAT">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_MAT" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_LGREDE">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_LGREDE" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_NOME">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_NOME" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_CC">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_CC" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_EMAIL">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_EMAIL" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_MATSUP">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_MATSUP" />
												</xsl:element>
											</xsl:element>
											<xsl:element name="ZAA_CGC">
												<xsl:element name="value">
													<xsl:value-of select="ZAA_CGC" />
												</xsl:element>
											</xsl:element> 						                                              
										</xsl:element>
									</xsl:for-each>                  
								</xsl:element>                
							</xsl:element>                            
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
