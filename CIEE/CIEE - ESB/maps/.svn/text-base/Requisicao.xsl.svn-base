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
				<xsl:text disable-output-escaping="yes">CEAIA01</xsl:text>
			</xsl:element>
			<xsl:element name="GlobalDocumentFunctionDescription">
				<xsl:text disable-output-escaping="yes">Requisicao de materiais</xsl:text>
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
				<xsl:value-of select="/ROOT/CABECALHO/DocCompany" />
			</xsl:element>
			<xsl:element name="DocBranch">
				<xsl:value-of select="/ROOT/CABECALHO/DocBranch" />
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
						<xsl:text disable-output-escaping="yes">CEAIA01</xsl:text>
					</xsl:element>
					<xsl:element name="Version">
						<xsl:text disable-output-escaping="yes">1.0</xsl:text>
					</xsl:element>
					<xsl:element name="FunctionCode">
						<xsl:value-of select="/ROOT/CABECALHO/FunctionCode" />
					</xsl:element>          
					<xsl:element name="Content">
						<xsl:element name="CEAIA01">
							<xsl:attribute name="Operation">
								<xsl:value-of select="/ROOT/CABECALHO/Operation" />
							</xsl:attribute>
							<xsl:attribute name="version">
								<xsl:text disable-output-escaping="yes">1.01</xsl:text>
							</xsl:attribute> 
							<xsl:for-each select="/ROOT/CABECALHO">                       
								<xsl:element name="SZNMASTER">
									<xsl:attribute name="modeltype">
										<xsl:text disable-output-escaping="yes">FIELDS</xsl:text>
									</xsl:attribute>
									<xsl:element name="ZN_NUMSOC">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_NUMSOC" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_USEREQ">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_USEREQ" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_EMAIL">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_EMAIL" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_CR">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_CR" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_DESCCR">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_DESCCR" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_RAMAL">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_RAMAL" />
										</xsl:element>
									</xsl:element>
									<xsl:element name="ZN_DATA">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_DATA" />
										</xsl:element>
									</xsl:element> 	
									<xsl:element name="ZN_EMAIL2">
										<xsl:element name="value">
											<xsl:value-of select="/ROOT/CABECALHO/ZN_EMAIL2" />
										</xsl:element>
									</xsl:element> 																
									<xsl:element name="items">                    
										<xsl:for-each select="ITEM">
											<xsl:element name="item">
												<xsl:variable name="count" select="position()" />
												<xsl:attribute name="id">
													<xsl:value-of select="format-number($count,'000')" />
												</xsl:attribute> 								
												<xsl:element name="ZN_COD">
													<xsl:element name="value">
														<xsl:value-of select="ZN_COD" />
													</xsl:element>
												</xsl:element> 								
												<xsl:element name="ZN_DESCR">
													<xsl:element name="value">
														<xsl:value-of select="ZN_DESCR" />
													</xsl:element>
												</xsl:element> 								
												<xsl:element name="ZN_UM">
													<xsl:element name="value">
														<xsl:value-of select="ZN_UM" />
													</xsl:element>
												</xsl:element> 								
												<xsl:element name="ZN_QUANT">
													<xsl:element name="value">
														<xsl:value-of select="ZN_QUANT" />
													</xsl:element>
												</xsl:element> 															
												<xsl:element name="ZN_SALDO">
													<xsl:element name="value">
														<xsl:value-of select="ZN_SALDO" />
													</xsl:element>
												</xsl:element> 								
											</xsl:element>
										</xsl:for-each>                  
									</xsl:element> 								
								</xsl:element>
							</xsl:for-each>                            
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
