#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

//FAZ LEITURA DO XML E-SOCIAL
user function GPXML01()
Local cError   := ""
Local cWarning := ""
Local oXml := NIL
Local aFiles := {}
Local nX
local nCount
Local nRet := ""

If !ExistDir( "\esocial\bkp" )
	nRet := MakeDir( "\esocial\bkp" )
	if nRet != 0
		MsgStop( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
	endif
EndIf

aFiles := Directory("\ESOCIAL\*.*")
nCount := Len( aFiles )
For nX := 1 to nCount
	cXML := aFiles[nX,1]

	//Abre o Objeto XML
	oXml := XmlParserFile( "\ESOCIAL\"+cXML, "_", @cError, @cWarning )
	If (oXml == NIL )
	  MsgStop("Falha na abertura do Objeto XML : "+cError+" / "+cWarning)
	  Return
	Endif
	
	// Mostrando a informação
	If (oXml:_esocial:_evtTabEstab <> NIL) //Evento 1005
		nCNPJ := oXml:_esocial:_evtTabEstab:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"1005-ESTABELECIMENTO")
		_xSegregaXML(nCNPJ,"1005",cXML)
		
	ElseIf  (oXml:_esocial:_evttabrubrica <> NIL) //Evento 1010
		nCNPJ := oXml:_esocial:_evttabrubrica:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"1010-RUBRICAS")
		_xSegregaXML(nCNPJ,"1010",cXML)
		
	ElseIf (oXml:_esocial:_evtTabLotacao <> NIL) //Evento 1020
		nCNPJ := oXml:_esocial:_evtTabLotacao:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"1020-CENTRO DE CUSTO")
		_xSegregaXML(nCNPJ,"1020",cXML)
		
	ElseIf (oXml:_esocial:_evtTabCargo <> NIL) //Evento 1030
		nCNPJ := oXml:_esocial:_evtTabCargo:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"1030-CARGO")
		_xSegregaXML(nCNPJ,"1030",cXML)
		
	ElseIf (oXml:_esocial:_evtTabHorTur <> NIL) //Evento 1050
		nCNPJ := oXml:_esocial:_evtTabHorTur:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"1050-TURNO")
		_xSegregaXML(nCNPJ,"1050",cXML)
		
	ElseIf (oXml:_esocial:_evtAdmissao <> NIL) //Evento 2200
		nCNPJ := oXml:_esocial:_evtAdmissao:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"2200-ADMISSAO")
		_xSegregaXML(nCNPJ,"2200",cXML)
				
	ElseIf (oXml:_esocial:_evtTSVInicio <> NIL) //Evento 2300
		nCNPJ := oXml:_esocial:_evtTSVInicio:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"2300-ADMISSAO")
		_xSegregaXML(nCNPJ,"2300",cXML)

	ElseIf (oXml:_esocial:_retornoEnvioLoteEventos <> NIL) //Evento retorno
		nCNPJ := oXml:_esocial:_retornoEnvioLoteEventos:_ideEmpregador:_nrInsc:text
		//MsgInfo(nCNPJ,"RETORNO")
		_xSegregaXML(nCNPJ,"retorno",cXML)
				
	ElseIf (oXml:_esocial:_retornoProcessamentoLoteEventos <> NIL) //Evento lixo
		nCNPJ := oXml:_esocial:_retornoProcessamentoLoteEventos:_ideEmpregador:_nrInsc:text 
		//MsgInfo(nCNPJ,"LIXO")
		_xSegregaXML(nCNPJ,"lixo",cXML)
				
	EndIf 

Next nX


Return oXml

/*
-------------------------------------------------------------
- Função comum para remover arquivo XML nas pastas corretas
-------------------------------------------------------------
*/

Static Function _xSegregaXML(nCNPJ,cEvento,cXML)
Local aCNPJ := {}
aadd(aCNPJ, {"59937524","59937524000156"})
aadd(aCNPJ, {"29309127","29309127000156"})

_nPos := ascan(aCNPJ, {|x| x[1] == nCNPJ} )
If _nPos > 0
	If !ExistDir( "\esocial\bkp\"+aCNPJ[_nPos,2] )
		nRet := MakeDir( "\esocial\bkp\"+aCNPJ[_nPos,2] )
		if nRet != 0
			MsgStop( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		else
			If !ExistDir( "\esocial\bkp\"+aCNPJ[_nPos,2]+"\"+cEvento )
				nRet := MakeDir( "\esocial\bkp\"+aCNPJ[_nPos,2]+"\"+cEvento )
				if nRet != 0
					MsgStop( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
				EndIf
			endIf
		endif
	Else
		If !ExistDir( "\esocial\bkp\"+aCNPJ[_nPos,2]+"\"+cEvento )
			nRet := MakeDir( "\esocial\bkp\"+aCNPJ[_nPos,2]+"\"+cEvento )
			if nRet != 0
				MsgStop( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
			EndIf
		endIf
	EndIf
	__copyfile("\esocial\"+cXML,"\esocial\bkp\"+aCNPJ[_nPos,2]+"\"+cEvento+"\"+cXML)
//	ferase("\esocial\"+cXML)
EndIf

Return