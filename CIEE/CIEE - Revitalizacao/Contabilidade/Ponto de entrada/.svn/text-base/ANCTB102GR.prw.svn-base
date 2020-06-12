#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ANCTB102GR ºAutor  ³Microsiga           º Data ³  08/17/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Antes da gravacao do lancamento contabil automatico.       º±±
±±º          ³ Variaval nOPC - PARAMIXB[1]                                º±±
±±º          ³ 3-inclui                                                   º±±
±±º          ³ 4-altera                                                   º±±
±±º          ³ 5-excluir                                                  º±±
±±º          ³                                                            º±±
±±º          ³ nOpc,dDataLanc,cLote,cSubLote,cDoc                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ANCTB102GR()

Private nOpc		:= paramixb[1]
Private dDataLanc 	:= DTOS(paramixb[2])
Private cLote		:= paramixb[3]
Private cSubLote	:= paramixb[4]
Private cDoc		:= paramixb[5]
Private _aArea		:= GetArea()

If nOpc == 5
	_cQuery := "UPDATE "+ RetSqlName("CT2") + " SET CT2_XUSER = '"+cUserName+"', CT2_XDTEXL = '"+DTOS(DDATABASE)+"' "
	_cQuery += "WHERE CT2_DATA = '"+dDataLanc+"' "
	_cQuery += "AND CT2_LOTE = '"+cLote+"' "
	_cQuery += "AND CT2_SBLOTE = '"+cSubLote+"' "
	_cQuery += "AND CT2_DOC = '"+cDoc+"' "

	TCSQLEXEC(_cQuery)
Else
	DbSelectArea("TMP")
	DbGotop() 
	
	Do While !EOF()
		_nLogic	:= TMP->CT2_FLAG //Informa que o registro esta deletado
		If _nLogic
			DbSelectArea("CT2")
			DbGoto(TMP->CT2_RECNO)
			RecLock("CT2",.F.)
			CT2->CT2_XUSER 	:= cUserName
			CT2->CT2_XDTEXL	:= DDATABASE
			MsUnLock()
		EndIf 
		//Alterado por Patricia Fontanezi 23/08/2012 - Qdo um Lanc Efetivo for estornado, o campo de arquivo enviado para outro sistema, 
		//devera estar em Branco, para que possa ser gravado novamente em outro numero de Lote.
		If nOpc == 6		
			TMP->CT2_GERARQ := ''		
		ENDIF   
		
		DbSelectArea("TMP")
		TMP->(DbSkip())
	EndDo  	
EndIf

RestArea(_aArea)

Return