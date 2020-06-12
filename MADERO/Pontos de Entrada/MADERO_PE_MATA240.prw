#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT240INC
//TODO Este ponto de entrada est� localizado na fun��o "A240Inclui" e ser� executado somente 
ap�s a inclus�o completa do registro na tabela SD3.Ao ser executado possibilitar� ao usu�rio, 
obter os dados do registro que acabou de ser inclu�do na tabela SD3.
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function MT240INC()

	//Verifica se o controle do saldo � na tabela customizada
	//*******************************************************
	If !IsInCallStack("U_A10001")
		dbSelectArea("SF5")
		SF5->(dbSetOrder(1))
		SF5->(dbGoTop())
		SF5->(dbSeek(xFilial("SF5")+SD3->D3_TM))
		
		If SF5->(Found()) .And. SF5->F5_ATUEMP == "S" .And. SF5->F5_TIPO $ ("RD")
			If !Empty(SD3->D3_OP) .And. !u_IsBusiness() 
				U_APCP03SP(SD3->D3_COD, SD3->D3_OP, SD3->D3_LOTECTL, SD3->D3_QUANT, SF5->F5_TIPO)
			EndIf
		EndIf
	EndIf
	//*******************************************************
		
Return

/*/{Protheus.doc} SD3240E
//TODO LOCALIZA��O : Function a240DesAtu() - Respons�vel por estornar os valores dos arquivos.
EM QUE PONTO : Ap�s a atualiza��o do registro de movimento interno (SD3) no estorno do mesmo.
Pode ser utilizado para atualizar algum campo ou arquivo criado pelo usu�rio.
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function SD3240E()

	//Verifica se o controle do saldo � na tabela customizada
	//*******************************************************
	If !IsInCallStack("U_A10001")
		If SD3->D3_TM $ ("499|999") .And. !Empty(SD3->D3_OP) .And. !u_IsBusiness() 
			U_APCP03SP(SD3->D3_COD, SD3->D3_OP, SD3->D3_LOTECTL, SD3->D3_QUANT, If(SD3->D3_TM == "499","D","R"))
		EndIf
	EndIf
	//*******************************************************

Return