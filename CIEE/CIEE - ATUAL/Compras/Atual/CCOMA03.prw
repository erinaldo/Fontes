#INCLUDE "rwmake.ch"
#DEFINE _cEOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ccoma03   º Autor ³ Felipe Raposo      º Data ³  15/04/03   º±±
±±º          ³          º       ³ Andy               º      ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa a validacao dos campos quantidade e valor unitario º±±
±±º          ³ no momento da digitacao da NF de entrada, a partir de um   º±±
±±º          ³ pedido.                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ _cCampo -> O campo que esta chamando a rotina.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T.  -  Aceita o valor informado.                          º±±
±±º          ³ .F.  -  Nao aceita o valor informado.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CCOMA03(_cCampo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaB1, _aAreaC7, _lRet, _cMsg
Local _nPsProd, _nPsQuant, _nPsVUnit, _nPsPed, _nPsItemPC
Local _nFator  := GetMV("MV_FATORD1")

// Busca a posicao dos campos na aCols pela aHeader.
_nPsProd   := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
_nPsQuant  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"})
_nPsVUnit  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
_nPsPed    := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_PEDIDO"})
_nPsItemPC := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEMPC"})

// Armazena as condicoes das tabelas antes do processamento.
_aAreaB1 := SB1->(GetArea())
_aAreaC7 := SC7->(GetArea())

// Executa a validacao somente se a nota for digitada
// a partir de um pedido de compra.
If empty(aCols[n, _nPsPed] + aCols[n, _nPsItemPC])

	//Fabio 20/08/2013 - Gatilho do D1_TOTAL
	_lRet:=ExecVal()
	Return(_lRet)
Endif

// Acerta os indices das tabelas.
SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.
SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN.

// Posiciona as tabelas correspondentes.
SB1->(dbSeek(xFilial("SB1") + aCols[n, _nPsProd], .F.))
SC7->(dbSeek(xFilial("SC7") + aCols[n, _nPsPed] + aCols[n, _nPsItemPC], .F.))

// Busca o fator de diferenca permitida, de acordo
// com o tipo do produto.
_nFator := IIf(AllTrim(SB1->B1_TIPO) == "ME",1+(_nFator/100), 1)  // 10% ou 0%

// Faz a consistencia, propriamente dita.
Do Case
	Case _cCampo == "D1_VUNIT"
		If !(_lRet := m->D1_VUNIT == IIF(!EMPTY(SC7->C7_DESC), SC7->C7_PRECO*((100-SC7->C7_DESC)/100),SC7->C7_PRECO))
			MsgAlert("Valor diferente do pedido de compra!", "Atenção")
		Endif
		
	Case _cCampo == "D1_QUANT"
		If !(_lRet := m->D1_QUANT <= SC7->C7_QUANT * _nFator)
			_cMsg := "Quantidade inválida!" + _cEOL +;
			"Verifique o valor informado no pedido de compra."
			MsgAlert(_cMsg, "Atenção")
		Endif
EndCase
          
//Fabio 20/08/2013 - Gatilho do D1_TOTAL
If _lRet
	_lRet:=ExecVal()
EndIf
// Restaura as condicoes anteriores das tabelas utilizadas.
SB1->(RestArea(_aAreaB1))
SC7->(RestArea(_aAreaC7))
Return(_lRet)

/*--------------------------------------------------------
* Gatilha o Total e faz a validação e gatilho do campo.
--------------------------------------------------------*/
Static Function ExecVal()

Local aArea:=GetArea()
Local nTotal:=0
Local nVUnit:=0
Local nQuant:=0
Local lRetorno:=.T.
Local cBkpReadVar:=__READVAR
Local nBkpTotal:=GdFieldGet("D1_TOTAL")

nQuant:=Iif(__READVAR=='D1_QUANT',M->D1_QUANT,GdFieldGet("D1_QUANT"))
nVUnit:=Iif(__READVAR=='D1_VUNIT',M->D1_VUNIT,GdFieldGet("D1_VUNIT"))
             
nTotal:=Round(nQuant*nVUnit, TamSx3('D1_TOTAL')[2])
GdFieldPut('D1_TOTAL',nTotal)
M->D1_TOTAL:=nTotal

__READVAR:='M->D1_TOTAL'
lRetorno:=&(X3Valid('D1_TOTAL'))

If lRetorno
	If ExistTrigger('D1_TOTAL')
		RunTrigger(2,n,,,'D1_TOTAL')
	EndIf
Else
	M->D1_TOTAL:=nBkpTotal      
	GdFieldPut('D1_TOTAL',nBkpTotal)
EndIf

__READVAR:=cBkpReadVar
                
RestArea(aArea)
Return(lRetorno)
