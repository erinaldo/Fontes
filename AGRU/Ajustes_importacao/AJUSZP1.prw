#include 'protheus.ch'
#include 'parmtype.ch'

user function AJUSZP1()

Private aRet       := {}
Private aParambox  := {}
Private lRet        := .F.


//  Parambox
aAdd(aParamBox,{1,"Produto de ",Space(15),"","","SB1","",0,.F.}) // Tipo caractere
aAdd(aParamBox,{1,"Produto ate",Space(15),"","","SB1","",0,.F.}) // Tipo caractere

If Len(aParambox) > 0
	lRet := ParamBox(aParambox, "Atualiza as Reservas nos Pedidos de Vendas", @aRet,,,,,,,, .T., .T. )	// Executa funcao PARAMBOX p/ obter os parametros
Endif

If !lRet
	MsgInfo("Cancelado pelo usuário")
	Return lRet
Else
	Processa({|| fExec()}, "Processando...")
	MsgInfo("Processo Finalizado!!!")
Endif 

Return
//
//**************************************************************************************************************
//
Static Function fExec()
Local nAtual 	:= 0
Local nTotReg 	:= 0
Local aQuery	:= {}
Local cQuery	:= ""

//SELECT SC6.C6_QTDVEN - SC6.C6_QTDENT AS DIFQTDE, *

BeginSQL Alias "SC6TRB"
	SELECT *
	FROM %Table:SC6% SC6
	WHERE SC6.%NotDel%
	AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	AND SC6.C6_PRODUTO BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
	ORDER BY SC6.C6_NUM, SC6.C6_ITEM
EndSQL

nTotReg := Contar("SC6TRB","!Eof()")
aQuery	:= GETLastQuery()
cQuery	:= aQuery[2]

ProcRegua(nTotReg)

SC6TRB->(DbGotop())

Do While !SC6TRB->(EOF())
	
	nAtual++
	IncProc("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotReg) + "...")

	U_ResLoad2(SC6TRB->C6_NUM,.T.)
	U_ResManut(SC6TRB->C6_NUM, SC6TRB->C6_ITEM, SC6TRB->C6_PRODUTO, SC6TRB->C6_LOCAL, SC6TRB->C6_QTDVEN , .T., , .T. )
	U_ResGrav1(SC6TRB->C6_NUM, .T., .F., SC6TRB->C6_ITEM)
 
	SC6TRB->(dbSkip())
EndDo

SC6TRB->(dbCloseArea())

return