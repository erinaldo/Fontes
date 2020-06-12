#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA090TIT  º Autor ³ CLAUDIO BARROS     º Data ³  23/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado na rotina Baixa Automatica      º±±
±±º          ³ por Bordero em Contas a Pagar FINA090                      º±±
±±º          ³ Apos a confirmacao do MARKBROWSE                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - BAIXA AUTOMATICA                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA090TIT()

Local _cPref	:= SE2->E2_PREFIXO
_lRet 			:= .T. 
 

DbSelectArea("SE2")
        
IF ALLTRIM(FUNNAME()) <> 'AFIN050TP'
	If _cPref == 'FL '
		_lRet := .F.
		Alert("Baixa Automática dos Títulos FL não poderão ser feitos por essa Rotina")    
		Return(_lRet)
	Endif   
ENDIF

If E2_PORTADO <> ParamIxb[1]
	_lRet := .F.
	MsgBox("O Titulo "+ALLTRIM(E2_NUM)+ " do Bordero "+Alltrim(E2_NUMBOR)+" nao pertence ao banco selecionado!!!")
	Return(_lRet)
EndIf


If E2_VENCREA <> dDataBase
	_lRet    :=.F.
	MsgAlert("Data Base Diferente com as datas de Vencimento dos Títulos", "Atenção")
	Return(_lRet)
EndIf   



Return(_lRet)