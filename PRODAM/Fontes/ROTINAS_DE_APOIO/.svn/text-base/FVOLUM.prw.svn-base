#Include "TbiConn.ch"
#include "TopConn.ch"
#INCLUDE "FILEIO.CH"
#Include "ApWizard.ch"

#DEFINE cEol Chr(13)+Chr(10)
#DEFINE cVers "1.01"

///***************************************************************************************************
///***************************************************************************************************
/// Rotina desenvolvida especificamente para geração de dados de VOLUMETRIA de operação pós GO-LIVE
///***************************************************************************************************
///***************************************************************************************************
User Function FVOLUM()
	
	Local oWizard, oPanel
	Local aParamBox		:= {}
	Local lOk 				:= .F.
	Local lFinish			:= .T.
	Local cTexto			:= ""
	Local dDtIni			:= CTOD("  /  /  ")
	Private cTxtMsg 		:= ""
	Private cTxt1 		:= ""
	Private oTxtMsg 		:= Nil
	Private oTxt1 		:= Nil
	Private oProcess 		:= Nil
	Private aScript		:= {}
	Private cNomArq		:= ""
	
	///---------------------------------------------------------------------------
	
	cTexto 	:=  "Essa rotina irá gerar dados de VOLUMETRIA"
	cTexto 	+=  cEol
	cTexto 	+=  cEol
	cMens		:= 'Esta rotina executa a geração de dados de volumetria da '
	cMens 		+= 'operação pós GO-LIVE'
	cMens 		+= cEol
	cMens 		+= "Versão "+cVers
	cTxt1		:= ""
	
	//-------------------------------------------------
	// Etapa 1 - Define a tela inicial do Wizard
	//-------------------------------------------------
	DEFINE WIZARD oWizard TITLE "VOLUMETRIA PÓS GO-LIVE" ;
		HEADER "Wizard de geração de VOLUMETRIA pós GO-LIVE" ;
		MESSAGE cMens ;
		TEXT cTexto ;
		NEXT {|| .T. } ;
		FINISH {|| .T. } ;
		PANEL
	
	oPanel := oWizard:GetPanel(1)
	
	//-------------------------------------------------
	// Etapa 3 - Cria Painel da confirmação
	//-------------------------------------------------
	CREATE PANEL oWizard ;
		HEADER "Wizard de geração de VOLUMETRIA pós GO-LIVE" ;
		MESSAGE "Confirmação" PANEL ;
		BACK {|| .T. } ;
		NEXT {|| .T. } ;
		FINISH {|| IIF( lFinish , IIF( ApMsgYesNo("Confirma a execução da rotina ?") , lOk := .T. , .F. ) , .F.) }
	
	oPanel := oWizard:GetPanel(2)
	
	oPanel := oWizard:GetPanel(4)
	ACTIVATE WIZARD oWizard CENTERED
	
	///----------------------------------------------------------------------------------------------------------------
	///Se o Wizard chegou ao fim e passou por todas as validações, permite executar o processamento.
	///----------------------------------------------------------------------------------------------------------------
	If lOk
		oProcess := MsNewProcess():New({|lEnd| PrcACT(lEnd,oProcess)},"Gerando dados de VOLUMETRIA","Aguarde...",.T.)
		oProcess:Activate()
	EndIf
	
Return()




///--------------------------------------------------------------------------------------------------
/// Função que executa o processamento de ajuste do DE/PARA.
///--------------------------------------------------------------------------------------------------
Static Function PrcACT(lEnd,oObj)
	Local lRet			:= .T.
	Local cCod_Emp	:= "01"
	Local cCod_Fil	:= "01"
	Local nArq   		:= 0
	Local v			:= 0
	Local j			:= 0
	Local w			:= 0
	Local d			:= 0
	Local e			:= 0
	Local k			:= 0
	Local nTotal		:= 0
	Local cBloco		:= ""
	Local aBloco		:= {}
	Local cArqConf	:= "VOLUMETRIA.CFG"
	Local cPath 		:= cGetFile("","Local para gravação...",1,,.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY )
	
	Private aVolumetr	:= {}			// Tabelas de Volumetria
	Private aDatas	:= {}	  		// Datas para analise
	Private aDados	:= {}	  		// Datas para analise
	Private dDtLIni	:= date()-7	// Data Limite Inicial
	Private dDataAtu 	:= dDtLIni

	If DTOS(dDataAtu) > DTOS(date())
		dDataAtu := date()
	EndIf
	
	Do while DTOS(dDataAtu) <= DTOS(date())
		AADD(aDatas,dDataAtu)
		dDataAtu += 1
	EndDo


	If Empty(cPath)
		cArqConf := "\temp\"+cArqConf
	Else
		cArqConf := AllTrim(cPath)+cArqConf
	EndIf
	cArqConf := lower(cArqConf)
	If !File(cArqConf)
		ApMsgInfo("Arquivo de configuração '"+cArqConf+"' não encontrado !")
		Return()
	EndIf

	FT_FUSE(cArqConf) //ABRIR O ARQUIVO
	FT_FGOTOP() //PONTO NO TOPO
	While !FT_FEOF() //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
		cBuffer 	:= FT_FREADLN() //LENDO LINHA
	//----------------------------------------------
		nPosFim 	:= AT(";",cBuffer)
		cRef 		:= Substr(cBuffer,1,nPosFim-1)
		cBuffer 	:= Substr(cBuffer,nPosFim+1)
	//----------------------------------------------
		nPosFim 	:= AT(";",cBuffer)
		cInd 		:= Substr(cBuffer,1,nPosFim-1)
		cBuffer 	:= Substr(cBuffer,nPosFim+1)
	//----------------------------------------------
		nPosFim 	:= AT(";",cBuffer)
		cCd_Emp 	:= Substr(cBuffer,1,nPosFim-1)
		cBuffer 	:= Substr(cBuffer,nPosFim+1)
	//----------------------------------------------
		nPosFim 	:= AT(";",cBuffer)
		cCd_Fil 	:= Substr(cBuffer,1,nPosFim-1)
		cBuffer 	:= Substr(cBuffer,nPosFim+1)
	//----------------------------------------------
		cQry 		:= cBuffer
	//----------------------------------------------
		If !Empty(cRef)
			AADD(aVolumetr,{cRef,cInd,cCd_Emp,cCd_Fil,cQry})
		EndIf
	//----------------------------------------------
		FT_FSKIP() //próximo registro no arquivo txt
	//----------------------------------------------
	EndDo
	FT_FUSE() //fecha o arquivo txt
	                                  
	///-----------------------------------------------------------------------------------------
	/// Inicializa ambiente de acordo com a Empresa / Filial
	///-----------------------------------------------------------------------------------------
	oObj:SetRegua1(1)
	oObj:IncRegua1("Abrindo Empresa...")
	
	RpcSetType(3)
	RpcSetEnv(cCod_Emp,cCod_Fil,,,'ATF',,,,,.T.)
	
	oObj:SetRegua2(10)
	
	If Len(aVolumetr)>0
		For v:=1 to Len(aVolumetr)
			cBloco 	:= AllTrim(aVolumetr[v][1])
			cBlcDes	:= AllTrim(aVolumetr[v][2])
			cBlcEmp 	:= AllTrim(aVolumetr[v][3])
			cBlcFil 	:= AllTrim(aVolumetr[v][4])
			cBlcQry 	:= AllTrim(aVolumetr[v][5])
			
			///--------------------------------------------------------------------------------------------------------
			/// BLOCO 
			///--------------------------------------------------------------------------------------------------------
			oObj:IncRegua2("Obtendo dados ... ")

			nTamLin 	:= 4+Len(aDatas)+1
			aDadLin 	:= ARRAY(nTamLin)
			aDadLin[1]	:= cBloco
			aDadLin[2]	:= cBlcDes
			aDadLin[3]	:= cBlcEmp
			aDadLin[4]	:= cBlcFil
			For	j:=1 to Len(aDatas)
			aDadLin[4+j] := 0
		Next
		aDadLin[nTamLin] := 0
		AADD(aDados,aDadLin)
			
		aBloco := {}
		If !Empty(cBlcQry)
			aBloco := GetVol(cBlcQry)
		EndIf
				
		nTotal := 0
		If Len(aBloco) > 0
			For k:=1 to Len(aBloco)
				dDtRef	:= aBloco[k,1]
				nQtde 	:= aBloco[k,2]
				
				If DTOS(dDtRef) > DTOS(date())
					dDtRef := date()
				EndIf
					
				nPosDt 	:= aScan(aDatas,dDtRef)
				nPosLin 	:= aScan(aDados,{|x| x[1] == cBloco })
					
				If DTOS(dDtRef) > DTOS(date())
					nPosDt = Len(aDadLin)
				EndIf
				If DTOS(dDtRef) < DTOS(dDtLIni)
					nPosDt = 1
				EndIf
					
				aDados[nPosLin][4+nPosDt] 	+= nQtde  // Soma na coluna da Data
				aDados[nPosLin][nTamLin] 	+= nQtde  // Soma na última coluna = Total
											
			Next k
		EndIf
			///--------------------------------------------------------------------------------------------------------
	Next v
	
	If Empty(cPath)
		cArq := "\temp\"+"VOLUMETRIA_"+DTOS(date())+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+".TXT"
	Else
		cArq := AllTrim(cPath)+"VOLUMETRIA_"+DTOS(date())+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+".TXT"
	EndIf
	cArq := lower(cArq)
	//cArq	:= "\temp\VOLUMETRIA_"+DTOS(date())+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)+".TXT"
	nArq   := FCreate(cArq)
	For v:=1 to Len(aDados)
		If v=1
			cTexto := "Referência;Indicadores;Empresa;Filial;"
			For d:=1 to Len(aDatas)
				cTexto += DTOC(aDatas[d]) + IIF(d<Len(aDatas),";","")
			Next d
			cTexto += ";" + "TOTAL" + cEol
			FWrite(nArq,cTexto)
		EndIf
		cTexto :=  ""
		For w:=1 to Len(aDados[v])
			If ValType(aDados[v][w]) = "N"
				cTexto +=  AllTrim(STR(aDados[v][w])) + IIF(w<Len(aDados[v]),";","")
			EndIf
			If ValType(aDados[v][w]) = "D"
				cTexto +=  DTOC(aDados[v][w]) + IIF(w<Len(aDados[v]),";","")
			EndIf
			If ValType(aDados[v][w]) = "C"
				cTexto +=  AllTrim(aDados[v][w]) + IIF(w<Len(aDados[v]),";","")
			EndIf
		Next
		cTexto +=  cEol
		FWrite(nArq,cTexto)
			///--------------------------------------------------------------------------------------------------------
	Next v
	FClose(nArq)

EndIf
	
	///-------------------------------------------------------
	/// Fecha o ambiente em uso
	///-------------------------------------------------------
RpcClearEnv()
	///-------------------------------------------------------
	
Return()



///----------------------------------------------------------------------------------------------------------------------------
/// Função que executa a querie e retorna as datas e número de ocorrências por data.
///----------------------------------------------------------------------------------------------------------------------------
Static Function GetVol(cQry)
	Local cQuery 		:= cQry
	Local cAliasTrb 	:= "TMPX"
	Local aBloco		:= {}
	
	If Select(cAliasTrb) <> 0
		dbSelectArea(cAliasTrb)
		(cAliasTrb)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbEval({|| aAdd(aBloco,{CTOD(substr((cAliasTrb)->DATAREF,7,2)+"/"+substr((cAliasTrb)->DATAREF,5,2)+"/"+substr((cAliasTrb)->DATAREF,1,4)),(cAliasTrb)->QTDE})}))
	(cAliasTrb)->(dbCloseArea())
	
Return(aBloco)



