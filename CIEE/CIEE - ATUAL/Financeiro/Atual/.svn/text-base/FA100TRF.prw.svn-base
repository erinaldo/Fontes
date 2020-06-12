#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#INCLUDE "MSOLE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA100TRF  ºAutor  ³Emerson Natali      º Data ³  06/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprimir Carta Word para transferencia natureza TED        º±±
±±º          ³ Movimentacao Bancaria                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA100TRF()

Local cBcoOrig 		:= paramixb[01]	//Origem
Local cAgenOrig 	:= paramixb[02]	//Origem
Local cCtaOrig 		:= paramixb[03]	//Origem
Local cBcoDest 		:= paramixb[04]	//Destino
Local cAgenDest 	:= paramixb[05]	//Destino
Local cCtaDest 		:= paramixb[06]	//Destino
Local cTipoTran 	:= paramixb[07]	//Tipo
Local cDocTran 		:= paramixb[08]	//Documento
Local nValorTran 	:= paramixb[09]	//Valor
Local cHist100	 	:= paramixb[10]	//Historico
Local cBenef100 	:= paramixb[11]	//Beneficiario
Local cNaturOri 	:= paramixb[12]	//Natureza Origem
Local cNaturDes 	:= paramixb[13]	//Natureza Destino
Local cModSpb 		:= paramixb[14]	//SPB - NIL
Local lEstorno 		:= paramixb[15]	//.T. Quando estiver estornando, .F. Quando estiver incluindo

Local lRet			:= .T.

Local _cNomeBco		:= ""
Local _cNomeBcoDes	:= ""
Local _cContato		:= ""
Local _cNomeAg		:= ""
Local _cNomeAgDes	:= ""

Private _aArea		:= GetArea()

//Se for estorno de Transferencia nao mostra DOC
If lEstorno
	RestArea(_aArea)
	Return(lRet)
EndIf

//Se for Tipo diferente de TR nao mostra DOC para empresa RJ
If cEmpant == '03' //RJ
	If cTipoTran <> "TR"
		RestArea(_aArea)
		Return(lRet)
	EndIf
//Se for Tipo diferente de TE nao mostra DOC para empresa SP
ElseIf cEmpant == '01' //SP
	If cTipoTran <> "TE"
		RestArea(_aArea)
		Return(lRet)
	EndIf
EndIf

//Se for Natureza igual a Caixa Centralizado nao mostra DOC
If cEmpant == '03' //RJ
	If Alltrim(cNaturOri) == "6.04.02" .or. Alltrim(cNaturDes) == "6.04.02"
		RestArea(_aArea)
		Return(lRet)
	EndIf
ElseIf cEmpant == '01' //SP
	If Alltrim(cNaturOri) == "33040102" .or. Alltrim(cNaturDes) == "33040102"
		RestArea(_aArea)
		Return(lRet)
	EndIf
EndIf

PRIVATE cWord		:= OLE_CreateLink()

If (cWord < "0")
	Help(" ",1,"A9810004") //"MS-WORD nao encontrado nessa maquina !!"
	Return
Endif

//PRIVATE cPath		:= "\\Netuno\AP8\Protheus_Data\dirdoc\"
//PRIVATE cPath		:= "\\Fenix\P10\Protheus_Data\dirdoc\"
PRIVATE cPath		:= "\\Fenix\dirdoc\"

If SM0->M0_CODIGO == "01" //SAO PAULO
	PRIVATE cArquivo	:= cPath+"TRANSF_TED.DOT"
ElseIf SM0->M0_CODIGO == "03" //RIO DE JANEIRO
	PRIVATE cArquivo	:= cPath+"TRANSF_TEDRIO.DOT"
EndIf

DbSelectArea("SA6")
DbSetOrder(1)
If DbSeek(xFilial("SA6")+cBcoOrig+cAgenOrig+cCtaOrig)
	_cNomeBco 	:= SA6->A6_NOME
	_cContato 	:= SA6->A6_CONTATO
	_cNomeAg	:= SA6->A6_NOMEAGE
EndIf

If DbSeek(xFilial("SA6")+cBcoDest+cAgenDest+cCtaDest)
	_cNomeBcoDes 	:= SA6->A6_NOME
	_cNomeAgDes 	:= SA6->A6_NOMEAGE
EndIf

_cCodIdent := ""
Do Case
	Case cBcoDest == "237"
		_cCodIdent	:= OemToAnsi("Código Identificador: 00026-4")
	Case (cBcoDest == "341" .or. cBcoDest == "001")
		_cCodIdent	:= OemToAnsi("Código Identificador: "+SM0->M0_CGC)
EndCase

If (cWord >= "0")
	OLE_NewFile( cWord,cArquivo)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que faz o Word aparecer na Area de Transferencia do Windows,     ³
	//³sendo que para habilitar/desabilitar e so colocar .T. ou .F.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetProperty(cWord, oleWdVisible  ,.T. )
	OLE_SetProperty(cWord, oleWdPrintBack,.T. )

	OLE_SetDocumentVar(cWord, "xNomeBco"	, _cNomeBco		)
	OLE_SetDocumentVar(cWord, "xAgOrig"		, cAgenOrig + " - " + _cNomeAg		)
	OLE_SetDocumentVar(cWord, "xContato"	, _cContato		)

	OLE_SetDocumentVar(cWord, "xValor"		, Alltrim(Transform(nValorTran, "@E 999,999,999.99" ) )	)
	OLE_SetDocumentVar(cWord, "xExtenso"	, Extenso(nValorTran))

	OLE_SetDocumentVar(cWord, "xBcoOrig"	, cBcoOrig + " - " + _cNomeBco			)
	OLE_SetDocumentVar(cWord, "xCCOrig"		, cCtaOrig		)
	
	OLE_SetDocumentVar(cWord, "xBcoDes"		, cBcoDest + " - " + _cNomeBcoDes		)
	OLE_SetDocumentVar(cWord, "xCCDes"		, cCtaDest		)
	OLE_SetDocumentVar(cWord, "xAgDEs"		, cAgenDest + " - " + _cNomeAgDes		)

	OLE_SetDocumentVar(cWord, "xCNPJ"		, Transform(SM0->M0_CGC, "@R 99.999.999/9999-99" )	) 

	OLE_SetDocumentVar(cWord, "xCodIdent"	, _cCodIdent	) 

EndIf

OLE_UpdateFields(cWord)

//_cPath		:= "\\Netuno\AP8\Protheus_Data\arq_txt\tesouraria\TED\"
//_cPath		:= "\\Fenix\P10\Protheus_Data\arq_txt\tesouraria\TED\"

If cEmpant == '01' //SP
	_cPath		:= "\\Fenix\arq_txt\tesouraria\TED\"
	_cPath1		:= "\arq_txt\tesouraria\TED\"
ElseIf cEmpant == '03' //RJ
	_cPath		:= "\\Fenix\arq_txtrj\tesouraria\TED\"
	_cPath1		:= "\arq_txtrj\tesouraria\TED\"
EndIf

//_cPath		:= "\\Fenix\arq_txt\tesouraria\TED\"
//_cPath1		:= "\arq_txt\tesouraria\TED\"

cArqAux 	:= alltrim(cCtaOrig)+" "+Dtos(DDATABASE)+"_"+"01"

If !File(_cPath1+cArqAux+".DOC")
	OLE_SaveAsFile( cWord, _cPath+cArqAux+".DOC" )
Else
	_lVerdade := .T.
	Do While _lVerdade	
		_nPos		:= At("_", cArqAux)
		_nvar		:= Strzero((Val(Substr(cArqAux,_nPos+1,2))+1),2)
		cArqAux 	:= SUBSTR(cArqAux,1,_nPos) + _nvar

		If !File(_cPath1+cArqAux+".DOC")	
			OLE_SaveAsFile( cWord, _cPath+cArqAux+".DOC" )
			_lVerdade := .F.
		EndIf
	EndDo
EndIf

Sleep(10000)	// Espera 10 segundos pra dar tempo de imprimir.

OLE_CloseLink( cWord )

RestArea(_aArea)
Return(lRet)