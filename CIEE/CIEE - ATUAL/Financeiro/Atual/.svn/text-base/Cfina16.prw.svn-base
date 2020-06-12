#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINA16 º Autor ³ AP6 IDE             º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cancelamento de Demonstrativo Mensal                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA16()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1	:= "Este programa tem como objetivo o cancelamento da numeracao de "
Private cDesc2	:= "Demonstrativo Mensal das Contas de Consumo"
Private cDesc3	:= "de acordo com os parametros informados pelo usuario."
Private titulo	:= "Cancelamento Demonstrativo Mensal Contabil"
Private nLin	:= 60
Private cString	:= "SZ5"
Private cPerg	:= "FINA16    "
Private _lPode
Private _lRet   := .T.

//If AllTrim(SubStr(cUsuario,7,11)) $ "Siga/Cristiano/Luis Carlos/Adilson"
If Alltrim(cUserName) $ GetMV("CI_USECADM")
	_lPode:=.T.
Else
	_lPode:=.F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Ficha de Lancamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","DM                 ?","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)
If Pergunte(cPerg, .T.)
	
	dbSelectArea("SZ5")
	DbSetOrder(1)
	
	dbSelectArea("SZ5")
	DbSetOrder(2)
	_xFilSZ5:=xFilial("SZ5")
	
	If dbSeek(xFilial("SZ5")+mv_par01, .F.)
		CFINA16A(mv_par01,_lRet) // Cancela a Contabilizacao da DM
		If _lRet
			If SZ5->Z5_FLUXO <> "S" .Or. _lPode
				_cOrdem := " Z5_FILIAL, Z5_FL"
				_cQuery := " SELECT  Z5_FILIAL, Z5_FL, Z5_FLUXO, Z5_VALOR, SZ5.R_E_C_N_O_ REGSZ5"
				_cQuery += " FROM "
				_cQuery += RetSqlName("SZ5")+" SZ5,"
				_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
				_cQuery += " AND    Z5_FL   = '"+mv_par01+"'"
				U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5" },,,.T. )
				
				dbSelectArea("QUERY")
				dbGoTop()
				
				While !EOF()
					If QUERY->Z5_FLUXO == "S"
						_aArea:= GetArea()
						dbSelectArea("SE5")
						dbSetOrder(7)
						If dbSeek(xFilial("SE5")+"CC "+QUERY->Z5_FL, .F.)
							If QUERY->Z5_VALOR == SE5->E5_VALOR
								RecLock("SE5", .F.)
								dbDelete()
								msUnLock()
							EndIf
						EndIf
						RestArea(_aArea)
					EndIf
					
					dbSelectArea("SZ5")
					dbgoto(QUERY->REGSZ5)
					RecLock("SZ5",.F.)
					SZ5->Z5_FL:=SPACE(6)
					SZ5->Z5_FLUXO := " "
					msUnLock()
					
					dbSelectArea("QUERY")
					dbSkip()
				EndDo
				
				dbSelectArea("QUERY")
				dbCloseArea()
				
				//				CFINA16A(mv_par01) // Cancela a Contabilizacao da DM
				_cMsg := "Processo de Cancelamento de DM Efetuado com sucesso!!!"
				MsgAlert(_cMsg, "Atenção")
			Else
				_cMsg := "Processo de Cancelamento de DM Nao Efetuado, DM já com Fluxo gerado !!!"
				MsgAlert(_cMsg, "Atenção")
			EndIf
		EndIf
	Else
		_cMsg := "DM Nao Localizado!!!"
		MsgAlert(_cMsg, "Atenção")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ5")
	dbCloseArea()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA16   ºAutor  ³Microsiga           º Data ³  07/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de exclusao do lancamento contabil (CT2),quando o    º±±
±±º          ³CT2_TPSALD = 9                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CFINA16A(pFicha,lRet)

Local _cQuery := " "
Local _cFl    := CHR(13)+CHR(10)
//Local _lRet   := .T.
Local _cAlias := GetArea()
Local cString := "CT2"
Local _cFicha := "932 "+pFicha
//Local _cFicha := "DM "+pFicha

dbSelectArea("CT2")
dbSetOrder(1)

_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_ORIGEM = '"+_cFicha+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)

TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	MsgAlert("Exclusão não permitida, contabilização efetivada, Informe a contabilidade!!")
	_lRet := .F.
ELSE
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC))
	_cData   := TRV->CT2_DATA
	_cLote   := TRV->CT2_LOTE
	_cSblote := TRV->CT2_SBLOTE
	_cDoc    := TRV->CT2_DOC
	_cLinha  := TRV->CT2_LINHA
	
	While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
		CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc
		
		RecLock("CT2",.F.)
		CT2->CT2_XUSER	:= cUserName
		CT2->CT2_XDTEXL	:= dDataBase
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		CT2->(DBSKIP())
	End
EndIf

If Select("TRV") > 0
	TRV->(DbcloseArea())
Endif

RestArea(_cAlias)

Return(_lRet)