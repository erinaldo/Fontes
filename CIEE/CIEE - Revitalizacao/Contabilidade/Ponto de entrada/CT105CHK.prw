#INCLUDE "rwmake.ch"

//--------------------------------------------------------------------
/*/{Protheus.doc} 
@fuuncao: CT105CHK
@author TOTVS Protheus
@since  02/12/2014    
@Ponto de Entrada CT105CHK
@version 1.0
/*/

User Function CT105CHK()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local cCtbOrig := " "
Local cAlias := GetArea()
Private cString := "TMP"

//Validacao se todas as linha estao deletadas
//Se estiverem nao sai da tela
//Alteracao realizada dia 04/11/10 pelo analista Emerson Natali para nao permitir que os usuarios saiam da tela.
_nNrReg 	:= 0
_nNrRegDel 	:= 0
dbSelectArea("TMP")
dbSetOrder(1)
TMP->(DBGOTOP())
Do While !TMP->(EOF())
	If TMP->CT2_FLAG
		_nNrRegDel++
	EndIf
	_nNrReg++
	TMP->(DBSKIP())
EndDo
If _nNrReg == _nNrRegDel
	alert(OemToAnsi("N�o � permitido deletar todos os registros!!! Entre em contato com a Contabilidade!!!"))
	RestArea(cAlias)
	Return(.F.)
EndIf
//fim do bloco

If funname() == "FINA090" //Baixa Automatica por Bordero, nao executa este ponto de entrada
	RestArea(cAlias)
	Return(.T.)
EndIf

dbSelectArea("TMP")
dbSetOrder(1)
TMP->(DBGOTOP())
While !TMP->(EOF())
	dbSelectArea("CT2")
	dbSetOrder(1)
	If MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc+TMP->CT2_LINHA)
		cCtbOrig := CT2->CT2_ORIGEM
	ELSE
		RecLock("TMP",.F.)
		TMP->CT2_ORIGEM := cCtbOrig
		TMP->(MsUnlock())
	ENDIF
	TMP->(DBSKIP())
END

RestArea(cAlias)

Return(.T.)