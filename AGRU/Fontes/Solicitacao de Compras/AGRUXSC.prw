#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} SCInDTPR
// Carregar nos itens da Solicitação de Compras a mesma data de necessidade digitada no primeiro item para os demais itens da SC.
// inicializado do campo C1_DATPRF
@author emerson.natali
@since 14/11/2019
@version 1.0
@type function
/*/
User Function SCInDTPR()

Local _dDatNec	:= DDATABASE // Data da necessidade 

	If TYPE("N")<>"U" //Verifica se a variavel N existe
		If len(acols) > 1 //se o Acols for maior que 1 executa a regra, para o primeiro item inicia com DATABASE
			_dDatNec := ACOLS[N-1,ASCAN(AHEADER,{|X| ALLTRIM(X[2])=="C1_DATPRF"})]
		EndIf
	EndIf
	
return(_dDatNec)