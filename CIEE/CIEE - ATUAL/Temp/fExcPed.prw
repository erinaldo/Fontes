#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
              
//Exclui pedidos nao faturados - Problema de 11/03 (Importacao arquivo SOC)
User Function fExcPed()                  	

Local cQuery:=""
Local cAlias:=GetNextAlias()
Private lMsErroAuto  :=.F.
                                   

cQuery:=" Select C5_NUM FROM "+RetSqlName('SC5')
cQuery+=" Where C5_FILIAL = '"+xFilial('SC5')+"' AND C5_EMISSAO = '20140521' AND C5_NOTA = ' ' AND C5_XRPSSOC <> ' ' AND C5_MUNPRES = ' ' AND D_E_L_E_T_ = ' '"
TcQuery cQuery New Alias (cAlias)

DBSELECTAREA(cAlias)
While (cAlias)->(!Eof())
	
	dbSelectArea('SC5')
	dbSetOrder(1)
	dbSeek(xFilial('SC5')+(cAlias)->C5_NUM)
	
	dbSelectArea('SC9')
	dbSetOrder(1)
	If DbSeek( xFilial('SC9')+(cAlias)->C5_NUM )
		a460Estorna()
	EndIf
	
	dbSelectArea('SC5')
	dbSeek(xFilial('SC5')+(cAlias)->C5_NUM)
	lMsErroAuto  :=.F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},{{"C5_NUM",SC5->C5_NUM,NIL}},{},5)
	
	If lMsErroAuto
		MostraErro()   
	Else
		Conout('Pedido excluido: '+(cAlias)->C5_NUM)
	EndIf   
	
	DBSELECTAREA(cAlias)
	dbSkip()
End
(cAlias)->(dbCloseArea())

Return