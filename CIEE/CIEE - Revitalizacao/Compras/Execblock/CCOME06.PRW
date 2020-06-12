#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME06
Incrementa campo de cotação vencedora no cadastro de fornecedores
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function CCOME06() 
Local _aFornVen, _aFornPer
Local _aAreaC8, _aAreaA2
Local _nAux1, _nAux2, _cCotNum

// Armazena as condicoes das tabelas antes do processamento.
_aAreaC8 := SC8->(GetArea())
_aAreaA2 := SA2->(GetArea())

// Acerta os indices utilizados no programa.
SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
SA2->(dbSetOrder(1))  // A2_FILIAL + A2_COD + A2_LOJA.

// Configura as variaveis que auxiliarao no processamento.
_aFornPer := _aFornVen := {}
_cCotNum := SC8->C8_NUM

// Varre toda a cotacao para saber quem eh(sao) o(s) fornecedor(es)
// vencedor(es) e o(s) armazena em variaveis.
SC8->(dbSeek(xFilial("SC8") + _cCotNum, .F.))
Do While (SC8->(C8_FILIAL + C8_NUM) == xFilial("SC8") + _cCotNum)
	If SC8->C8_XCOTSTS == "1"
		aAdd(_aFornVen, {SC8->(C8_FORNECE + C8_LOJA), SC8->(C8_NUM+C8_IDENT+C8_PRODUTO)})
		Exit
	Endif
	SC8->(dbSkip())
EndDo

// Atualiza os outros fornecedores.
SC8->(dbSeek(xFilial("SC8") + _cCotNum, .F.))
Do While (SC8->(C8_FILIAL + C8_NUM) == xFilial("SC8") + _cCotNum)
	
	If !empty(SC8->C8_NUMPED) .and. SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
		
		// Armazena em variaveis os dados ja cadastrados (sem incrementar).
		_nAux1 := val(SubStr(SA2->A2_XCOTVE1, 3, 1))
		_nAux2 := val(SubStr(SA2->A2_XCOTVE1, 3, 4))
		
		// Algoritimo para evitar que um fornecedor com duas propostas seja contabilizado
		// duas vezes, o que seria injusto, pois ele iria perder em uma das propostas.
		If  aScan(_aFornVen, {|x| x[1] == SC8->(C8_FORNECE + C8_LOJA) .and.;
			x[2] == SC8->(C8_NUM+C8_IDENT+C8_PRODUTO)}) != 0
			
			_nAux1 ++  // Vencedor.
			_nAux2 ++  // Participante.
		Else
			If  aScan(_aFornPer, {|x| x[1] == SC8->(C8_FORNECE + C8_LOJA) .and.;
				x[2] == SC8->(C8_NUM+C8_IDENT+C8_PRODUTO)}) == 0
				
				aAdd(_aFornPer, {SC8->(C8_FORNECE + C8_LOJA), SC8->(C8_NUM+C8_IDENT+C8_PRODUTO)})
				// Por nao ser um fornecedor vencedor, incrementa somente o participante.
				_nAux2 ++  // Participante.
			Endif
		Endif
		//
		RecLock("SA2", .F.)
		SA2->A2_XCOTVE1 := StrZero(_nAux1, 3) + "/" + StrZero(_nAux2, 3)
		SA2->(msUnLock())
	Endif
	SC8->(dbSkip())
EndDo

// Restaura as condicoes anteriores das tabelas.
SC8->(RestArea(_aAreaC8))
SA2->(RestArea(_aAreaA2))

Return