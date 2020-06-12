#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT240INC
//TODO Este ponto de entrada está localizado na função "A240Inclui" e será executado somente 
após a inclusão completa do registro na tabela SD3.Ao ser executado possibilitará ao usuário, 
obter os dados do registro que acabou de ser incluído na tabela SD3.
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function MT240INC()

	//Verifica se o controle do saldo é na tabela customizada
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
//TODO LOCALIZAÇÃO : Function a240DesAtu() - Responsável por estornar os valores dos arquivos.
EM QUE PONTO : Após a atualização do registro de movimento interno (SD3) no estorno do mesmo.
Pode ser utilizado para atualizar algum campo ou arquivo criado pelo usuário.
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function SD3240E()

	//Verifica se o controle do saldo é na tabela customizada
	//*******************************************************
	If !IsInCallStack("U_A10001")
		If SD3->D3_TM $ ("499|999") .And. !Empty(SD3->D3_OP) .And. !u_IsBusiness() 
			U_APCP03SP(SD3->D3_COD, SD3->D3_OP, SD3->D3_LOTECTL, SD3->D3_QUANT, If(SD3->D3_TM == "499","D","R"))
		EndIf
	EndIf
	//*******************************************************

Return