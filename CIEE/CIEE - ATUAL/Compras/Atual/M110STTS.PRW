#INCLUDE "rwmake.ch"
#include "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M110STTS  º Autor ³ Andy Pudja         º Data ³  01/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para o informe do campo especifico        º±±
±±º          ³ SC1->C1_NUMCIEE numero de solicitacao de compra            º±±
±±º          ³ gerado pelo formulario.                                    º±±
±±º          ³ Ponto de entrada executado na inclusao da SC MATA110       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M110STTS()
_aAreaAtu := GetArea()
_aAreaSC1 := SC1->(GetArea())
Private _cNumCIEE := cA110Num

If Inclui
	
	@ 33,25 TO 110,349 Dialog oDlg01 Title "Numero da Solicitacao CIEE"
	@ 01,05 TO 035, 128
	@ 08,08 Say "NumCIEE: "
	@ 08,35 Get _cNumCIEE PICTURE "@E 999999" VALID U_SC1CIEE()
	@ 05, 132  BMPBUTTON TYPE 1 Action CLOSE (oDlg01)
	
	Activate Dialog oDlg01 CENTERED
	
	dbSelectArea("SC1")
	dbOrderNickName("SCCIEE")
	If dbSeek(xFilial("SC1") + _cNumCIEE ) .Or. Val(_cNumCIEE)==0
		_cNumCIEE := cA110Num
	EndIf
	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSeek(xFilial("SC1") + cA110Num )
	While SC1->C1_FILIAL+SC1->C1_NUM == xFilial("SC1")+cA110Num .And. !Eof()
		RecLock("SC1",.F.)
		SC1->C1_NUMCIEE  := _cNumCIEE
		MsUnLock()
		dbSkip()
	EndDo
EndIf

SC1->(RestArea(_aAreaSC1))
RestArea(_aAreaAtu)
Return


User Function SC1CIEE()
_cRet:=.T.
dbSelectArea("SC1")
dbOrderNickName("SCCIEE")
If dbSeek(xFilial("SC1") + _cNumCIEE )
	_cRet:=.F.
	msgAlert(OemToAnsi("Numeração Já Existe!"),OemToAnsi("Atenção"))
EndIf
Return(_cRet)

User Function NUMSC1()
// Acertando a numeracao de SC, pois o Campo C1_NUMCIEE assume a partir do dia 01/07,
// os valores do campo C1_NUM e renumerou as solicitações de 000001 a 001661 
/*
_nNum:=1
dbSelectArea("SC1")
dbOrderNickName("SCCIEE")
dbGoTop()
_cChave:=SC1->C1_NUMCIEE
While !Eof()
	While !Eof() .And. _cChave==SC1->C1_NUMCIEE
		RecLock("SC1",.F.)
		SC1->C1_NUM  := StrZero(_nNum,6)
		MsUnLock()
		dbSkip()
	EndDo
	_cChave:=SC1->C1_NUMCIEE
	_nNum  :=_nNum +1
EndDo
*/

//********************************************************************
//* Bloco para acerto de SC8, conforme a mudança da numeracao do SC1 *
//********************************************************************

dbSelectArea("SC8")
dbSetOrder(1)
dbGoTop()
While !Eof()
  
  dbSelectArea("SC1")
  dbOrderNickName("SCCIEE")
  If dbSeek(xFilial("SC1") + SC8->C8_NUMSC )
    dbSelectArea("SC8")
	RecLock("SC8",.F.)
    	SC8->C8_NUMSC := SC1->C1_NUM
	MsUnLock()
  EndIf	
  
  dbSelectArea("SC1")  
  dbSkip()

EndDo

//********************************************************************
//* Bloco para acerto de SC7, conforme a mudança da numeracao do SC1 *
//********************************************************************

dbSelectArea("SC7")
dbSetOrder(1)
dbGoTop()
While !Eof()
  
  dbSelectArea("SC1")
  dbOrderNickName("SCCIEE")
  If dbSeek(xFilial("SC1") + SC7->C7_NUMSC )
    dbSelectArea("SC7")
	RecLock("SC7",.F.)
    	SC7->C7_NUMSC := SC1->C1_NUM
	MsUnLock()
  EndIf	
  
  dbSelectArea("SC7")  
  dbSkip()

EndDo


Return
