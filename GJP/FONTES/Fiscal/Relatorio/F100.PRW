#include "protheus.ch"

User Function F100()

Local oReport        

If TRepInUse()	
	//verifica se relatorios personalizaveis esta disponivel	
	Pergunte("F100",.F.)	
	oReport := ReportDef()	
	oReport:PrintDialog()	
EndIf             

Return



Static Function ReportDef()

Local oReport
Local oSection
Local oSection1

oReport := TReport():New("F100","Relação Ajustes Documentos PIS/COFINS","F100",{|oReport| PrintReport(oReport)},"Este relatorio irá imprimir a relacao dos Demais Documentos PIS/COFINS conforme os parâmetros solicitados.")

// Forca Retrato
oReport:SetLandScape(.T.)
oReport:DisableOrientation()                                                                                 

oSection := TRSection():New(oReport,OemToAnsi("Demais Documentos PIS/COFINS"),{"CF8","SA2","SA1","SB1"})
oSection:SetHeaderSection(.T.)
oSection:SetTitle("Demais Documentos PIS/COFINS")

TRCell():New(oSection,"CF8_FILIAL","CF8")
TRCell():New(oSection,"CF8_CODIGO","CF8")
TRCell():New(oSection,"CF8_DTOPER","CF8")
TRCell():New(oSection,"CF8_TPREG" ,"CF8")
TRCell():New(oSection,"CF8_INDOPE","CF8")       
oSection:Cell("CF8_INDOPE"):SetCBox("0=Aquisição;1=Rec.Trib.;2=Rec.Não Trib.")
TRCell():New(oSection,"CF8_ITEM"  ,"CF8")
TRCell():New(oSection,"CF8_CLIFOR","CF8")
TRCell():New(oSection,"CF8_LOJA"  ,"CF8")
TRCell():New(oSection,"CF8_VLOPER","CF8")
TRCell():New(oSection,"CF8_CODBCC","CF8")
TRCell():New(oSection,"CF8_CSTPIS","CF8","PIS","@!",2)
TRCell():New(oSection,"CF8_BASPIS","CF8")
TRCell():New(oSection,"CF8_VALPIS","CF8")
TRCell():New(oSection,"CF8_CSTCOF","CF8","COF","@!",2)
TRCell():New(oSection,"CF8_BASCOF","CF8")
TRCell():New(oSection,"CF8_VALCOF","CF8")
TRCell():New(oSection,"CF8_SALDO","CF8") 
TRCell():New(oSection,"CF8_DESCPR","CF8")    

oBreak := TRBreak():New(oSection,{|| CF8_FILIAL + CF8_INDOPE },"Totalizadores",.F.,'Totalizadores',.T.)                                   
TRFunction():New(oSection:Cell("CF8_VLOPER"),NIL,"SUM",oBreak,'Valor da Operação',,,.F.,.F.)
TRFunction():New(oSection:Cell("CF8_BASPIS"),NIL,"SUM",oBreak,'Base de PIS',,,.F.,.F.)
TRFunction():New(oSection:Cell("CF8_BASCOF"),NIL,"SUM",oBreak,'Base de COFINS',,,.F.,.F.)
TRFunction():New(oSection:Cell("CF8_VALPIS"),NIL,"SUM",oBreak,'Valor de PIS',,,.F.,.F.) 
TRFunction():New(oSection:Cell("CF8_VALCOF"),NIL,"SUM",oBreak,'Valor de COFINS',,,.F.,.F.)

oSection:SetHeaderBreak(.T.) //Imprime cabeçalho das células após quebra

oSection:SetHeaderSection(.T.)


                                      
// Habilita quebra de linha
oSection:SetLineBreak(.T.)
                   

oSection1 := TRSection():New(oReport,OemToAnsi("Ajuste de PIS/COFINS"),{"CF5"})
oSection1:SetHeaderSection(.T.)
oSection1:SetTitle("Ajustes de PIS/COFINS")

TRCell():New(oSection1,"CF5_FILIAL","CF5")
TRCell():New(oSection1,"CF5_CODIGO","CF5")
TRCell():New(oSection1,"CF5_DTREF" ,"CF5")
TRCell():New(oSection1,"CF5_TPAJST","CF5")
TRCell():New(oSection1,"CF5_PISCOF","CF5")
TRCell():New(oSection1,"CF5_INDAJU","CF5")
TRCell():New(oSection1,"CF5_CODAJU","CF5")            
TRCell():New(oSection1,"CF5_CODCON","CF5")
TRCell():New(oSection1,"CF5_CODCRE","CF5") 
TRCell():New(oSection1,"CF5_NUMDOC","CF5")
TRCell():New(oSection1,"CF5_DESAJU","CF5")
TRCell():New(oSection1,"CF5_TIPATV","CF5")
TRCell():New(oSection1,"CF5_BSCALC","CF5")
TRCell():New(oSection1,"CF5_ALIQ"  ,"CF5")
TRCell():New(oSection1,"CF5_VALAJU","CF5")

oBreak := TRBreak():New(oSection1,{|| CF5_FILIAL + CF5_TPAJST + CF5_PISCOF + CF5_INDAJU },"Totalizadores",.F.,'Totalizadores',.T.)                                   
TRFunction():New(oSection1:Cell("CF5_VALAJU"),NIL,"SUM",oBreak,'Valor do ajuste',,,.F.,.F.)

//oSection:SetHeaderBreak(.T.) //Imprime cabeçalho das células após quebra
oSection1:SetHeaderSection(.T.)
                                      
// Habilita quebra de linha
oSection1:SetLineBreak(.T.)
                                                             
Return oReport                                               



Static Function PrintReport(oReport)

Local cAliasCF5	:= GetNextAlias()
Local cAliasCF8	:= GetNextAlias()
Local oSection 	:= oReport:Section(1)
Local oSection1	:= oReport:Section(2)
Local cFiltro	:= ''                          
Local dDataDe   := Ctod("01/" + StrZero(MV_PAR01,2) + "/" + StrZero(MV_PAR02,4))  
Local dDataFim  := Ctod("01/" + StrZero(Iif(MV_PAR01==12,1,MV_PAR01+1),2) + "/" + StrZero(Iif(MV_PAR01==12,MV_PAR02+1,MV_PAR02),4)) - 1
                                                                                   
oReport:SetMeter(RecCount())

cFiltro := "%"
cFiltro += "CF8.CF8_FILIAL	= '"	+ xFilial('CF8')			+ "' AND "
cFiltro += "CF8.CF8_DTOPER	>= '" 	+ %Exp:DToS (dDataDe)% 		+ "' AND "
cFiltro += "CF8.CF8_DTOPER	<= '" 	+ %Exp:DToS (dDataFim)% 	+ "' AND "
cFiltro += "CF8.D_E_L_E_T_	= '' "
cFiltro += "%"	

oSection:BeginQuery()

BeginSql Alias cAliasCF8
	COLUMN CF8_DTOPER AS DATE	
	
	SELECT
	CF8.CF8_CODIGO,CF8.CF8_DTOPER,CF8.CF8_TPREG ,CF8.CF8_INDOPE,CF8.CF8_ITEM  ,CF8.CF8_CLIFOR,;
	CF8.CF8_LOJA  ,CF8.CF8_VLOPER,CF8.CF8_CODBCC,CF8.CF8_CSTPIS,CF8.CF8_BASPIS,CF8.CF8_VALPIS,;
	CF8.CF8_CSTCOF,CF8.CF8_BASCOF,CF8.CF8_VALCOF,CF8.CF8_SALDO ,CF8.CF8_DESCPR,CF8.CF8_FILIAL
	FROM
		%TABLE:CF8% CF8

	WHERE
		%Exp:cFiltro%	
	ORDER BY 
		CF8.CF8_FILIAL, CF8.CF8_INDOPE, CF8.CF8_CODIGO, CF8.CF8_DTOPER
		EndSql

oReport:SetTitle("Demais Documentos PIS/COFINS")
oSection:EndQuery()
oReport:SetMeter((cAliasCF8)->(RecCount()))
oSection:SetHeaderSection(.T.)
oSection:SetTitle("Demais Documentos PIS/COFINS")
oSection:Print()	

cFiltro := "%"
cFiltro += "CF5.CF5_FILIAL	= '"	+ xFilial('CF5')			+ "' AND "
cFiltro += "CF5.CF5_DTREF	>= '" 	+ %Exp:DToS (dDataDe)% 		+ "' AND "
cFiltro += "CF5.CF5_DTREF	<= '" 	+ %Exp:DToS (dDataFim)% 	+ "' AND "
cFiltro += "CF5.D_E_L_E_T_	= '' "
cFiltro += "%"	

oSection:BeginQuery()

BeginSql Alias cAliasCF5
	COLUMN CF5_DTREF AS DATE	
	    
	SELECT	
	CF5.CF5_CODIGO,CF5.CF5_TPAJST,CF5.CF5_PISCOF,CF5.CF5_INDAJU,CF5.CF5_DTREF,CF5.CF5_CODAJU,CF5.CF5_NUMDOC,;
	CF5.CF5_DESAJU,CF5.CF5_CODCRE,CF5.CF5_TIPATV,CF5.CF5_BSCALC,CF5.CF5_ALIQ,CF5.CF5_VALAJU,;
	CF5.CF5_FILIAL,CF5.CF5_CODCON
	FROM
		%TABLE:CF5% CF5
						
	WHERE
		%Exp:cFiltro%	
	ORDER BY 
		CF5.CF5_FILIAL, CF5.CF5_TPAJST, CF5.CF5_PISCOF, CF5.CF5_INDAJU, CF5.CF5_DTREF
		EndSql
						
oReport:SetTitle("Ajustes de PIS/COFINS")
oSection1:EndQuery()
oReport:SetMeter((cAliasCF5)->(RecCount()))
oSection1:SetHeaderSection(.T.)       
oSection1:SetTitle("Ajustes de PIS/COFINS")
oSection1:Print()	

oSection1:Finish()

Return
