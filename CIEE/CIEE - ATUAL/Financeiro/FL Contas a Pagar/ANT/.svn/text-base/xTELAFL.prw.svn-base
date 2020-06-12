#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"

User Function xTELAFL(aNVtt)
Local lRet
Local nOpca := 0
Local nReg
Local oDlg
Local nDlgHeight
Local nGDHeight
Local aSize := {}

Private oGetDados1
Private oEnchoice
Private lEnd
Private cArq	        := ""

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := 500
	nGDHeight  := oMainWnd:nBottom
Else
	nDlgHeight := 420
	nGDHeight  := 70
EndIf

aCordW := {135,000,nDlgHeight,632}
nSizeHeader := 210 //Tamanho do Cabecalho Enchoice

Aadd(aSize,nSizeHeader)

IF SELECT("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DBCLOSEAREA())
Endif

cTitulo		:= "Inconsistencias"
cAlias1		:= "PA9"         // Alias da enchoice. 
cAliasSED   := "SED"
nReg		:=(cAlias1)->(Recno())
cAlias2		:= "PAB"            // Alias da GetDados.
aMyEncho	:= {}				// Campos da Enchoice.
cFieldOk	:= "AllwaysTrue()"  // Valida cada campo da GetDados.
cLinOk		:= "AllwaysTrue()"  // Valida a linha.
cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.
nOpcE		:= 3                // Opcao da Enchoice.
lVirtual	:= .T.	            // Exibe os campos virtuais na GetDados.
nLinhas		:= 999              // Numero maximo de linhas na GetDados.

aAltEnch	:= nil              // Campos alteraveis na Enchoice (nil = todos).
aAltEnch	:= {}
AADD(aAltEnch,"PA9_FORNEC")
AADD(aAltEnch,"PA9_EMISSA")
AADD(aAltEnch,"PA9_VENC")
AADD(aAltEnch,"PA9_VENCRE")
//AADD(aAltEnch,"PA9_RATEIO")
//AADD(aAltEnch,"PA9_CTADEB")
//AADD(aAltEnch,"PA9_CC")
//AADD(aAltEnch,"PA9_HIST")

nOpcE 		:= If(nOpcE==Nil,3,nOpcE)
lVirtual 	:= Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas		:=Iif(nLinhas==Nil,999,nLinhas)

nFreeze		:=nil

DbSelectArea("PA9")

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias1, .T.)
RegToMemory(cAlias2, .T.)

//Monta a aHeader.
aHeader 	:= {}

_aArea := SX3->(GetArea())
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias2)
/*
******************** Primeiro aHeader
*/

_xCampos := "PAB_NUM|PAB_NOMFOR|PAB_NATURE|PAB_SALDO|PAB_VLPGT"

Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAlias2) //PAB
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		If alltrim(SX3->X3_CAMPO) $ _xCampos
			aAdd(aHeader,	 {	TRIM(SX3->X3_TITULO)	,;
								SX3->X3_CAMPO			,;
								SX3->X3_PICTURE			,;
								SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL			,;
								SX3->X3_VALID			,;
								SX3->X3_USADO			,;
								SX3->X3_TIPO			,;
								SX3->X3_F3				,;
								SX3->X3_CONTEXT			,;
								SX3->X3_CBOX			,;
								SX3->X3_RELACAO			,;
								SX3->X3_WHEN			,;
								SX3->X3_VISUAL			,;
								SX3->X3_VLDUSER			,;
								SX3->X3_PICTVAR			,;
								SX3->X3_OBRIGAT			})
		Endif
	Endif
	SX3->(dbSkip())
EndDo    

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAliasSED)

_xCampos := "ED_DESCRIC"

Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == cAliasSED) //PAB
	If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL)
		If alltrim(SX3->X3_CAMPO) $ _xCampos
			aAdd(aHeader,	 {	TRIM(SX3->X3_TITULO)	,;
								SX3->X3_CAMPO			,;
								SX3->X3_PICTURE			,;
								SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL			,;
								SX3->X3_VALID			,;
								SX3->X3_USADO			,;
								SX3->X3_TIPO			,;
								SX3->X3_F3				,;
								SX3->X3_CONTEXT			,;
								SX3->X3_CBOX			,;
								SX3->X3_RELACAO			,;
								SX3->X3_WHEN			,;
								SX3->X3_VISUAL			,;
								SX3->X3_VLDUSER			,;
								SX3->X3_PICTVAR			,;
								SX3->X3_OBRIGAT			})
		Endif
	Endif
	SX3->(dbSkip())
EndDo    


SX3->(RestArea(_aArea))

//Monta a aCols
private aCols 	:= {}

/*
******************** Primeiro aCols
*/
_aAreaX3 := SX3->(GetArea())
DbSelectArea("SX3")
SX3->(dbSetOrder(2))

//ARRAY PATRICIA
_aArrayPAB	:= {}
_aArrayPAB	:= aClone(aNVtt)
_nTotPA9	:= 0

For _nI := 1 to len(_aArrayPAB)
	_aAux1 := {}
	For _nAux1 := 1 to len(aHeader)
		SX3->(dbSeek(aHeader[_nAux1, 2]))
		aAdd(_aAux1, _aArrayPAB[_nI,_nAux1] )
	Next _nAux1
	aAdd(_aAux1, .F.)
	aAdd(aCols, _aAux1)
Next _nI

For _nY := 1 to len(aCols)
	_nTotPA9 += aCols[_nY,5]
Next _nY

//Inicializa variaveis
M->PA9_VALOR 	:= _nTotPA9
M->PA9_PREFIX 	:= "FLI"

_cNumFL	:= ""
For _nY := 1 to len(aCols)
	_cNumFL += aCols[_nY,1] +iif(len(aCols)>1,",","")
Next _nY

M->PA9_CTADEB	:= alltrim(GetMv("CI_FLIREG"))
M->PA9_HIST 	:= "FLI "+M->PA9_NUM+" REEM FL "+_cNumFL //alterado dia 21/02/13 analista Emerson Natali acrescentado campo PA9_NUM para o correto historico da Contabilizacao.

SX3->(RestArea(_aAreaX3))

aButtons	:= {}

/*INICIO ------------- TAMANHO DA TELA*/
_aSize := MsAdvSize()
aObjects:= {}
aPosObj :={}

aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo, aObjects)
/*FIM ------------- TAMANHO DA TELA*/

DEFINE FONT oBold		NAME "Arial" SIZE 0, -18 BOLD
DEFINE FONT oBold_New	NAME "Courier" SIZE 0, -14 BOLD
DEFINE MSDIALOG oDlg TITLE cTitulo From _aSize[7],0 TO _aSize[6],_aSize[5] Pixel of oMainWnd

oEnchoice	:= Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{10,1,120,aPosObj[2,4]+2},aAltEnch,3,,,,,,lVirtual,,,,,,,,.T.)
oEnchoice:Refresh()

aCampos2	:= {}

AADD(aCampos2,"PAB_VLPGT") 	//campos alteraveis no GetDados2// VALOR EDITAVEL

nGetd		:= GD_UPDATE //GD_INSERT+GD_UPDATE+GD_DELETE
oGetDados1	:= MsNewGetDados():New(aPosObj[2,1]+90,aPosObj[2,2]-2,aPosObj[2,3],aPosObj[2,4]+2,nGetd ,/*cLinOk*/"u_LinOKFL()",cTudoOk,"",aCampos2,nFreeze,nLinhas,cFieldOk,/*superdel*/,/*delok*/,/*oFolder:aDialogs[2]*/,aheader ,acols )
oGetDados1:oBrowse:Default()	
oGetDados1:oBrowse:Refresh()	

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,;
											{||iif(U_FLINC_OK(), (nOpca:=1,oDlg:End()), nOpca:=0 )},;
											{||iif(U_FLCAN_OK(), (nOpca:=0,oDlg:End()), nOpca:=0 )},;
											,;
											aButtons),;
											)
lRet:=(nOpca==1)

If lRet
//1) Grava o registro na PA9
	RecLock("PA9",.T.)
	PA9->PA9_FILIAL := xFilial("PA9")
	PA9->PA9_TIPO 	:= M->PA9_TIPO
	PA9->PA9_NUM 	:= M->PA9_NUM
	PA9->PA9_PREFIX := M->PA9_PREFIX
	PA9->PA9_FORNEC := M->PA9_FORNEC
	PA9->PA9_LOJA 	:= M->PA9_LOJA
	PA9->PA9_VALOR 	:= M->PA9_VALOR
	PA9->PA9_EMISSA := M->PA9_EMISSA
	PA9->PA9_VENC 	:= M->PA9_VENC
	PA9->PA9_VENCRE := M->PA9_VENCRE
	PA9->PA9_RATEIO := M->PA9_RATEIO
	PA9->PA9_CTADEB := M->PA9_CTADEB
	PA9->PA9_DESCCT := M->PA9_DESCCT
	PA9->PA9_CC 	:= M->PA9_CC
	PA9->PA9_CTACRE := M->PA9_CTACRE
	PA9->PA9_NATURE := M->PA9_NATURE
	PA9->PA9_DESCNA := M->PA9_DESCNA
	PA9->PA9_HIST 	:= M->PA9_HIST
	PA9->PA9_NOMFOR := M->PA9_NOMFOR
	PA9->PA9_DTENC 	:= M->PA9_DTENC
	PA9->PA9_SALDO 	:= M->PA9_VALOR // O campo Saldo na inclusao e igual ao Valor digitado
	PA9->PA9_LIQUID := M->PA9_LIQUID
	PA9->PA9_RECONC := M->PA9_RECONC
	MsUnLock()

	ConfirmSX8()

	_nTotSld	:= {}
	For _nI := 1 to len(oGetDados1:aCols)
		If oGetDados1:aCols[_nI,5] > 0
			dbselectarea("PAB") 
			DBSETORDER(1)
			RECLOCK("PAB",.T.)
			PAB->PAB_FILIAL  := xFilial("PAB")
			PAB->PAB_PREFIX  := M->PA9_PREFIX
			PAB->PAB_NUM     := M->PA9_NUM
			PAB->PAB_CLIFOR  := M->PA9_FORNEC
			PAB->PAB_LOJA    := M->PA9_LOJA
			PAB->PAB_TIPO    := M->PA9_TIPO
			PAB->PAB_VALOR   := oGetDados1:aCols[_nI,5] //Campos digitado pelo usuario
			PAB->PAB_NATURE  := oGetDados1:aCols[_nI,3] //Natureza da tela de Inconsistencia (PAB)
			PAB->PAB_RECPAG  := "P"
			PAB->PAB_PERC    := round((oGetDados1:aCols[_nI,5]/M->PA9_VALOR)*100,2)
			PAB->(MSUNLOCK())
		EndIf		
		//array com a somataria por Titulo
		DbSelectArea("PAB")
		DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
		_cCodFor	:= ""
		If DbSeek(xFilial("PAB")+ "FL " + oGetDados1:aCols[_nI,1])
			_cCodFor	:= PAB->PAB_CLIFOR+PAB_LOJA
		Else
			If DbSeek(xFilial("PAB")+ "FLI" + oGetDados1:aCols[_nI,1])
				_cCodFor	:= PAB->PAB_CLIFOR+PAB_LOJA
			EndIf
		EndIf
		_nPos := aScan( _nTotSld,{|x| AllTrim(x[1]) == _cCodFor+oGetDados1:aCols[_nI,1] })
		If _nPos == 0
			aAdd(_nTotSld,{_cCodFor+oGetDados1:aCols[_nI,1],oGetDados1:aCols[_nI,5], oGetDados1:aCols[_nI,1]})
		Else
			_nTotSld[_nPos,2]+= oGetDados1:aCols[_nI,5]
		EndIf

	Next _nI

	//Processa ExecAuto (Inclusao do Contas a Pagar/ Contabilizacao)
	lEnd	:= .F.
	Private lRetAguarde := .F.
	MsAguarde({|lEnd| RunProc(@lEnd)}, "Aguarde...", OemToAnsi("Processando Inclusใo do Tํtulo...Aguarde..FLI"),.T.)
	If lRetAguarde

		For _nY := 1 to Len(_nTotSld) //array com os titulos originais.
			DbSelectArea("PA9")
			DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+TIPO+FORNECEDOR+LOJA
			If DbSeek(xFilial("PA9")+ PA9->("FL "+_nTotSld[_nY,3]+"FL "+Substr(_nTotSld[_nY,1],1,8)) )
				RecLock("PA9",.F.)
				PA9->PA9_SALDO -= _nTotSld[_nY,2]
				MsUnLock()
			Else
				If DbSeek(xFilial("PA9")+ PA9->("FLI"+_nTotSld[_nY,3]+"FL "+Substr(_nTotSld[_nY,1],1,8)) )
					RecLock("PA9",.F.)
					PA9->PA9_SALDO -= _nTotSld[_nY,2]
					MsUnLock()
				EndIf
			EndIf
		Next _nY
	
		For _nW := 1 to len(oGetDados1:aCols)
			If oGetDados1:aCols[_nW,5] > 0
				//array com a somataria por Titulo
				_cCodFor	:= ""
				DbSelectArea("PAB")
				DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
				If DbSeek(xFilial("PAB")+ "FL " + oGetDados1:aCols[_nW,1])
					_cCodFor	:= PAB->(PAB_CLIFOR+PAB_LOJA)
				Else
					If DbSeek(xFilial("PAB")+ "FLI" + oGetDados1:aCols[_nW,1])
						_cCodFor	:= PAB->(PAB_CLIFOR+PAB_LOJA)
					EndIf
				EndIf
	
				_lAchou	:= .F.
				DbSelectArea("PAB")
			 	DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
				If DbSeek(xFilial("PAB")+ "FL "+oGetDados1:aCols[_nW,1]+" "+"FL "+_cCodFor+oGetDados1:aCols[_nW,3] )
					_lAchou	:= .T.
				Else
					If DbSeek(xFilial("PAB")+ "FLI"+oGetDados1:aCols[_nW,1]+" "+"FL "+_cCodFor+oGetDados1:aCols[_nW,3] )
						_lAchou	:= .T.
					EndIf
				EndIf

				If _lAchou
					_nSldAnt	:= PAB->PAB_SALDO
					RecLock("PAB",.F.)
					PAB->PAB_SALDO-=oGetDados1:aCols[_nW,5] //VALOR DIGITADO PELO USUARIO
					MsUnLock()

					DbSelectArea("SE5") 
					DbSetOrder(7)
					DbGotop()
 					If DbSeek(xFilial("SE5")+PAB->(PAB_PREFIX+PAB_NUM+" "+PAB_TIPO+PAB_CLIFOR+PAB_LOJA))
						While SE5->(!EOF()) .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == PAB->(PAB_PREFIX+PAB_NUM+" "+PAB_TIPO+PAB_CLIFOR+PAB_LOJA)
						    If SE5->E5_MOTBX <> 'RES' .AND. SE5->E5_SITUACA <> 'C' .AND. SE5->E5_RECONC <> 'x' .AND. SE5->E5_VALOR == _nSldAnt
						       	_cBancoSE5	:= SE5->E5_BANCO
						       	_cAgSE5		:= SE5->E5_AGENCIA
						       	_cContSE5	:= SE5->E5_CONTA
						       	_nSeq		:= SE5->E5_SEQ
						       	
						       	RecLock("SE5",.F.)
						       	SE5->E5_SITUACA := "C"
						       	MsUnLock()

								DbSelectArea("SE2")
								DbSetOrder(1)
								If DbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
									RecLock("SE2",.F.)
									SE2->E2_SALDO	:= _nSldAnt
									SE2->E2_VALLIQ	:= 0
									MsUnlock()

									//Gera lancamento Estorno (Cancelamento) da Baixa. (Manualmente)
									aMatriz	:= {}
									_cCntBco	:= Posicione("SA6",1,xFilial("SA6")+_cBancoSE5+_cAgSE5+_cContSE5,"A6_CONTABI")
									_cCntPA9	:= Posicione("PA9",1,xFilial("PA9")+PAB->(PAB_PREFIX+PAB_NUM+PAB_TIPO+PAB_CLIFOR+PAB_LOJA),"PA9_CTACRE")
									If Empty(alltrim(_cCntPA9))
										_cCntPA9	:= Posicione("SA2",1,xFilial("SA2")+PAB->(PAB_CLIFOR+PAB_LOJA),"A2_REDUZ")
									EndIf
									_cCCPA9		:= Posicione("PA9",1,xFilial("PA9")+PAB->(PAB_PREFIX+PAB_NUM+PAB_TIPO+PAB_CLIFOR+PAB_LOJA),"PA9_CC")
									_cNomPA9	:= Posicione("PA9",1,xFilial("PA9")+PAB->(PAB_PREFIX+PAB_NUM+PAB_TIPO+PAB_CLIFOR+PAB_LOJA),"PA9_NOMFOR")
									_dVctoPA9	:= Posicione("PA9",1,xFilial("PA9")+PAB->(PAB_PREFIX+PAB_NUM+PAB_TIPO+PAB_CLIFOR+PAB_LOJA),"PA9_VENCRE")

									//            debito  , credito  cc debito, cc credito, valor   , historico
									aadd(aMatriz,{_cCntBco, _cCntPA9, ""      , ""        , _nSldAnt, "CANC. PGTO "+alltrim(PAB->PAB_TIPO)+" "+alltrim(PAB->PAB_NUM)+" "+alltrim(_cNomPA9)+" "+Dtoc(_dVctoPA9) } )
//NAO GERA LANCAMENTO CONTABIL
//11/12/2012
//									GeraLacto(aMatriz)
								EndIf
								
						       	Exit
						    EndIf
							DbSkip()
						EndDo
					EndIf

					aVetor :={	{"E2_PREFIXO"	,PAB->PAB_PREFIX,Nil},;
								{"E2_NUM"	 	,PAB->PAB_NUM	,Nil},;
								{"E2_PARCELA"	," "			,Nil},;
								{"E2_TIPO"		,PAB->PAB_TIPO	,Nil},;
								{"E2_FORNECE"	,PAB->PAB_CLIFOR,Nil},;  
								{"E2_LOJA"  	,PAB->PAB_LOJA	,Nil},;
					   			{"AUTMOTBX" 	,"RES"			,Nil},;		//MOTIVO BAIXA
					   			{"AUTBANCO"		,_cBancoSE5		,Nil},;     //BANCO
					   			{"AUTAGENCIA"	,_cAgSE5		,Nil},;     //AGENCIA
					   			{"AUTCONTA" 	,_cContSE5		,Nil},;     //CONTA
					   			{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
					   			{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
					   			{"AUTHIST"		,"TIT FLI "+M->PA9_NUM	,Nil},;     //HISTORICO
					   			{"AUTVLRPG"		,oGetDados1:aCols[_nW,5] ,Nil}}
					   			
					MSExecAuto({|x,y| Fina080(x,y)},aVetor,3)

					If PAB->PAB_SALDO > 0
						aVetor :={	{"E2_PREFIXO"	,PAB->PAB_PREFIX,Nil},;
									{"E2_NUM"	 	,PAB->PAB_NUM	,Nil},;
									{"E2_PARCELA"	," "			,Nil},;
									{"E2_TIPO"		,PAB->PAB_TIPO	,Nil},;
									{"E2_FORNECE"	,PAB->PAB_CLIFOR,Nil},;  
									{"E2_LOJA"  	,PAB->PAB_LOJA	,Nil},;
						   			{"AUTMOTBX" 	,"NOR"			,Nil},;		//MOTIVO BAIXA
						   			{"AUTBANCO"		,_cBancoSE5		,Nil},;     //BANCO
						   			{"AUTAGENCIA"	,_cAgSE5		,Nil},;     //AGENCIA
						   			{"AUTCONTA" 	,_cContSE5		,Nil},;     //CONTA
						   			{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
						   			{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
						   			{"AUTHIST"		,"BX TIT NORMAL",Nil},;     //HISTORICO
						   			{"AUTVLRPG"		,PAB->PAB_SALDO ,Nil}}
						   			
						MSExecAuto({|x,y| Fina080(x,y)},aVetor,3)
/*
11/12/2012
TENTAR ALTERAR A CONTA E O HISTORICO
E MUDAR O TIPO DE 'RES' PARA 'ELI'
**********************************************************************************************************/
						_ct2Area 	:= GetArea()
						_dData		:= DTOS(CT2->CT2_DATA)
						_cLote		:= CT2->CT2_LOTE
						_cSbLote	:= CT2->CT2_SBLOTE
						_cDoc		:= CT2->CT2_DOC
						_cItemD		:= ""
						_cContaD	:= ""
						_cCCD		:= ""
						_cItemC		:= ""
						_cContaC	:= ""
						_cCCC		:= ""
						DbSelectArea("CT2")
						DbSetOrder(1) //FILIAL+DTOS(DATA)+LOTE+SBLOTE+DOC+LINHA)
						If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
							Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
								If !Empty(CT2->CT2_ITEMD) //CT2_DC == '1'
									_cItemD		:= CT2->CT2_ITEMD
									_cContaD	:= CT2->CT2_DEBITO
									_cCCD		:= CT2->CT2_CCD
								ElseIf !Empty(CT2->CT2_ITEMC) //CT2_DC == '2'
									_cItemC		:= CT2->CT2_ITEMC
									_cContaC	:= CT2->CT2_CREDIT
									_cCCC		:= CT2->CT2_CCC
								EndIf
								DbSelectArea("CT2")
								CT2->(DbSkip())
							EndDo
						EndIf
						If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
							Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
								RecLock("CT2",.F.)
                                DbDelete()
								MsUnLock()
								DbSelectArea("CT2")
								CT2->(DbSkip())
							EndDo
						EndIf
						RestArea(_ct2Area)
/***********************************************************************************************************/
					EndIf
				EndIf
			EndIf
		Next _nW

		//EXECAUTO CANCELA BAIXA DO TITULO E BAIXA COM RESIDUO
		
	Else
		//Se nao conseguir gravar o ExecAuto
		//tem que excluir o PA9 e o PAA e o PAB
		DbSelectArea("PA9")
		DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+TIPO+FORNECEDOR+LOJA
		If DbSeek(xFilial("PA9")+ PA9->(PA9_PREFIX+PA9_NUM+PA9_TIPO+PA9_FORNEC+PA9_LOJA) )
			RecLock("PA9",.F.)
			DbDelete()
			MsUnLock()
			DbSelectArea("PAA")
			DbSetOrder(3) //FILIAL+NUMERO+PREFIXO+FORNECEDOR+LOJA
			If DbSeek(xFilial("PAA")+ PA9->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA) )
				Do While !EOF() .and. PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNEC+PAA_LOJA) == PA9->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA)
					RecLock("PAA",.F.)
					DbDelete()
					MsUnLock()
					DbSelectArea("PAA")
					PAA->(DbSkip())
				EndDo
			EndIf
			DbSelectArea("PAB")
			DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
			If DbSeek(xFilial("PAB")+ PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA) )
				Do While !EOF() .and. PAB->(PAB_PREFIX+PAB_NUM+PAB_PARCEL+PAB_TIPO+PAB_CLIFOR+PAB_LOJA) == PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA)
					RecLock("PAB",.F.)
					DbDelete()
					MsUnLock()
					DbSelectArea("PAB")
					PAB->(DbSkip())
				EndDo
            EndIf
		EndIf		
	EndIf

	//GRAVA HISTORICO DO MOVIMENTO (FLI) E ORIGENS (FL)
	//ALERT("HISTORICO")

	For _nX := 1 to len(oGetDados1:aCols)
		If oGetDados1:aCols[_nX,5] > 0
			//array com a somataria por Titulo
			_cCodFor	:= ""
			DbSelectArea("PAB")
			DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
			If DbSeek(xFilial("PAB")+ "FL " + oGetDados1:aCols[_nX,1])
				_cCodFor	:= PAB->(PAB_CLIFOR+PAB_LOJA)
			Else
				If DbSeek(xFilial("PAB")+ "FLI" + oGetDados1:aCols[_nX,1])
					_cCodFor	:= PAB->(PAB_CLIFOR+PAB_LOJA)
				EndIf
			EndIf
	
			_lAchou	:= .F.
			DbSelectArea("PAB")
		 	DbSetOrder(1) //FILIAL+PREFIXO+NUMERO+PARCELA+TIPO+FORNECEDOR+LOJA+NATUREZA
			If DbSeek(xFilial("PAB")+ "FL "+oGetDados1:aCols[_nX,1]+" "+"FL "+_cCodFor+oGetDados1:aCols[_nX,3] )
				_lAchou	:= .T.
			Else
				If DbSeek(xFilial("PAB")+ "FLI"+oGetDados1:aCols[_nX,1]+" "+"FL "+_cCodFor+oGetDados1:aCols[_nX,3] )
					_lAchou	:= .T.
				EndIf
			EndIf

			If _lAchou
				_dVctoPA9	:= Posicione("PA9",1,xFilial("PA9")+PAB->(PAB_PREFIX+PAB_NUM+PAB_TIPO+PAB_CLIFOR+PAB_LOJA),"PA9_VENCRE")
				
				RecLock("PAC",.T.)
				PAC->PAC_FILIAL	:= xFilial("PAC")
				PAC->PAC_TPORI 	:= PAB->PAB_TIPO 					// Tipo  - Titulo Origem
				PAC->PAC_PRFORI	:= PAB->PAB_PREFIX 					// Prefixo  - Titulo Origem
				PAC->PAC_NUMORI	:= oGetDados1:aCols[_nX,1] 			// Numero - Titulo Origem
				PAC->PAC_NOMORI	:= Posicione("SA2",1,xFilial("SA2")+PAB->(PAB_CLIFOR+PAB_LOJA),"A2_NREDUZ")// Nome Forn  - Titulo Origem
				PAC->PAC_FORORI	:= PAB->PAB_CLIFOR 					// Cod Forn  - Titulo Origem
				PAC->PAC_LOJORI	:= PAB->PAB_LOJA 					// Loja  - Titulo Origem
				PAC->PAC_VECORI	:= _dVctoPA9						// Vencto  - Titulo Origem
				PAC->PAC_NATORI	:= oGetDados1:aCols[_nX,3] 			// Natureza - Titulo Origem
				PAC->PAC_VALORI	:= oGetDados1:aCols[_nX,5] 			// Valor Digitado - Titulo Origem

				PAC->PAC_TPFLI 	:= M->PA9_TIPO 					// Tipo - Titulo FLI
				PAC->PAC_PRFFLI	:= M->PA9_PREFIX 					// Prefixo - Titulo FLI
				PAC->PAC_NUMFLI	:= M->PA9_NUM 					// Numero - Titulo FLI
				PAC->PAC_NOMFLI	:= Posicione("SA2",1,xFilial("SA2")+M->PA9_FORNEC+M->PA9_LOJA,"A2_NREDUZ")// Nome Forn  - Titulo FLI
				PAC->PAC_FORFLI	:= M->PA9_FORNEC 					// Cod Forn - Titulo FLI
				PAC->PAC_LOJFLI	:= M->PA9_LOJA 					// Loja - Titulo FLI
				PAC->PAC_VECFLI	:= M->PA9_VENCRE 					// Vencto - Titulo FLI
				PAC->PAC_NATFLI	:= M->PA9_NATURE 					// Natureza - Titulo FLI
				PAC->PAC_VALFLI	:= M->PA9_VALOR 					// Valor Digitado - Titulo FLI
				MsUnLock()
			EndIf
		EndIf
	Next _nX

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunProc(lEnd)

Private lMsErroAuto 	:= .F.

_aTitulo := {	{"E2_PREFIXO", M->PA9_PREFIX	, NIL},; 
				{"E2_NUM"    , M->PA9_NUM		, NIL},;
				{"E2_PARCELA", ' '				, NIL},;
				{"E2_TIPO"   , M->PA9_TIPO		, NIL},;
				{"E2_HIST"   , M->PA9_HIST		, NIL},;
				{"E2_NATUREZ", M->PA9_NATURE	, NIL},;
				{"E2_FORNECE", M->PA9_FORNEC	, NIL},;
				{"E2_LOJA"   , M->PA9_LOJA		, NIL},;
				{"E2_REDUZ"  , M->PA9_CTADEB	, NIL},;
				{"E2_RED_CRE", M->PA9_CTACRE	, NIL},; 
				{"E2_EMISSAO", M->PA9_EMISSA	, NIL},;
				{"E2_VENCTO" , M->PA9_VENC		, NIL},;
				{"E2_VENCREA", M->PA9_VENCRE	, NIL},;
				{"E2_RATEIO" , M->PA9_RATEIO	, NIL},;
				{"E2_VALOR"  , M->PA9_VALOR		, NIL},;
				{"E2_CCUSTO" , M->PA9_CC		, NIL},;
				{"E2_DATALIB", dDataBase		, NIL},;
				{"E2_USUALIB", alltrim(cUserName), NIL}}
		
Begin Transaction
		
//MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,3)   			//MSEXECAUTO DE INCLUSAO DE TITULO    
  MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,3,,,lExibeLanc) //MSEXECAUTO DE INCLUSAO DE TITULO
		
If lMsErroAuto
	_aArea := GetArea()
	RestArea(_aArea)
	DisarmTransaction()
	MostraErro()
	//Retorna o numero SXE, SXF nao utilizado
	RollBackSX8()
	break
	lEnd := .F.
	lRetAguarde := .F.
	Return(lEnd)
EndIf
End Transaction		

lEnd := .T.
lRetAguarde := .T.

Return(lEnd)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao de Linha acols PAB                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LinOKFL()

Local _nTotPA9	:= 0

If oGetDados1:aCols[n,5] > oGetDados1:aCols[n,4] //Valor Digitado > Valor Original
	msgbox("O valor digitado ้ maior que o Saldo da Natureza")
	oGetDados1:aCols[n,5] := oGetDados1:aCols[n,4]
	Return(.F.)
EndIf

For _nI := 1 to Len(oGetDados1:aCols)
	_nTotPA9 += oGetDados1:aCols[_nI,5]
Next _nI

M->PA9_VALOR := _nTotPA9

oEnchoice:Refresh()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  07/24/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao OK tela                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FLINC_OK()
_lRet	:= .T.

If Empty(M->PA9_FORNEC) .or. Empty(M->PA9_EMISSA) .or. Empty(M->PA9_VENC) .or. Empty(M->PA9_VENCREA)
	msgbox("Campos obrigatorios estใo em branco! Favor preencher.")
	_lRet	:= .F.
	Return(_lRet)
EndIf

If M->PA9_RATEIO == "N"
	If Empty(M->PA9_CTADEB)
		msgbox("Campo de Conta Debito! Favor preencher.")
		_lRet	:= .F.
		Return(_lRet)
	Else
		DbSelectArea("CT1") 					
		CT1->(DbSetOrder(2))
		dBGOTOP()
		If DbSeek(xFilial("CT1")+M->PA9_CTADEB) 
		    IF CT1->CT1_CCOBRG == '1' .AND. EMPTY(M->PA9_CC)
		    	MSGINFO("Digite o Centro de Responsabilidade")
		    	_lRet	:= .F.
		    	Return(_lRet)
		    Endif
		Endif
	EndIf
EndIf

_nValRat	:= 0
DbSelectArea("PAA")
DbSetOrder(3) //TITULO+PREFIX+FORNEC+LOJA
If DbSeek(xFilial("PAA")+M->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA))
	Do While !EOF() .and. PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNECE+PAA_LOJA) == M->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA)
		_nValRat += PAA->PAA_VALOR
		PAA->(DbSkip())
	EndDo
	
	If _nValRat <> M->PA9_VALOR
		msgbox("O Valor do titulo de Inconsistencia (FLI) esta diferente do valor no Rateio!!! Favor corrigir!!!","Atencao")
    	_lRet	:= .F.
    	Return(_lRet)
	EndIf
EndIf

_lRet := U_VALINC() //Validacao para verificar se nao tem rateio

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  07/24/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao Cancelar Tela                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FLCAN_OK()
_lRet	:= .T.

DbSelectArea("PAA")
DbSetOrder(3) //TITULO+PREFIX+FORNEC+LOJA
If DbSeek(xFilial("PAA")+M->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA))
	If MsgYesNo(OemToAnsi("Existem Rateios digitados, que serao apagados ao cancelar"+CHR(13) + CHR(10)+"Deseja continuar?"), OemToAnsi("Inconsistencias FL"))
		_lRet := .T.
		Do While !EOF() .and. PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNECE+PAA_LOJA) == M->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA)
			RecLock("PAA",.F.)
			DbDelete()
			MsUnLock()
			PAA->(DbSkip())
		EndDo
	Else
		_lRet := .F.
	EndIf
EndIf
             
//Retorna o numero SXE, SXF nao utilizado
RollBackSX8()

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho no campo PAB_VLPGT utilizado dentro da tela de     บฑฑ
ฑฑบ          ณ Inconsistencias da FL. Atualizacao do valor na tabela      บฑฑ
ฑฑบ          ณ PA9                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function xGatTlFL()

Local _nTotPA9	:= 0

If oGetDados1:aCols[n,5] > oGetDados1:aCols[n,4] //Valor Digitado > Valor Original
	msgbox("O valor digitado ้ maior que o Saldo da Natureza")
	Return(oGetDados1:aCols[n,4])
EndIf

For _nI := 1 to Len(oGetDados1:aCols)
	_nTotPA9 += oGetDados1:aCols[_nI,5]
Next _nI

M->PA9_VALOR := _nTotPA9

oEnchoice:Refresh()

Return(oGetDados1:aCols[n,5])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTELAFL   บAutor  ณMicrosiga           บ Data ณ  08/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraLacto(aMatriz)

Local nDecs			:=	2
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local dDataLanc 	:= CTOD("") 

Private lMsErroAuto := .F.
Private _cLoteCie	:= "008850"
Private _cSubLCie 	:= "001"

_dDtLancto	:= dDataBase

aCab := {;
		{"dDataLanc", _dDtLancto,NIL},;
		{"cLote"	, _cLoteCie ,NIL},;
		{"cSubLote"	, _cSubLCie ,NIL}}

_cLinCie := 1

For _nI	:= 1 to Len(aMatriz)

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")								, NIL},;
					{"CT2_LINHA"	, StrZero(_cLinCie,3)							, NIL},;
					{"CT2_DC"		, "3"	 										, NIL},;
					{"CT2_ITEMD"	, aMatriz[_nI,1]								, NIL},;
					{"CT2_ITEMC"	, aMatriz[_nI,2]								, NIL},;
					{"CT2_CCD"		, aMatriz[_nI,3]								, NIL},;
					{"CT2_CCC"		, aMatriz[_nI,4]								, NIL},;
					{"CT2_DCD"		, "" 											, NIL},;
					{"CT2_DCC"		, "" 											, NIL},;
					{"CT2_VALOR"	, Round(aMatriz[_nI,5],nDecs)					, NIL},;
					{"CT2_HP"		, ""											, NIL},;
					{"CT2_HIST"		, aMatriz[_nI,6]	   							, NIL},;
					{"CT2_TPSALD"	, "9"											, NIL},;
					{"CT2_ORIGEM"	, ""											, NIL},;
					{"CT2_MOEDLC"	, "01"											, NIL},;
					{"CT2_EMPORI"	, Substr(cNumEmp,1,2)							, NIL},;
					{"CT2_ROTINA"	, "FLI"											, NIL},;
					{"CT2_LP"		, ""											, NIL},;
					{"CT2_KEY"		, ""											, NIL}})
	_cLinCie++
Next _nI

aadd(aTotItem,aItem)
MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
aTotItem	:=	{}
			
If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	Return .F.
Endif
		
aCab	:= {}
aItem	:= {}

Return()