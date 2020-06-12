#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE12 
Copia a forma de pagamento do fornecedor para os titulos a pagar gerados pela emissao 
da nota fiscal de entrada, e abre uma tela para o usuario digitar a forma correta ou 
confirmar a sugerida.
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION CESTE12()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaE2, _nAux1
Local _aTits := {}

Local _cForPgto := IIf(SF1->F1_TIPO $ "DB",;
CriaVar("E2_XFORPGT"),;
POSICIONE("SA2",1,xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA),"A2_XFORPGT"))
Local _aRet   := {}
Local _cF3    := ""
Local _aDados := {{1, "Forma de pagamento", _cForPgto, "", "AllwaysTrue()", _cF3, "", 90, .F.}}

// Pega os titulos gerados pela nota fiscal.
SE2->(dbSeek(xFilial("SE2") + SF1->(F1_SERIE + F1_DOC), .F.))
Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + SF1->(F1_SERIE + F1_DOC)
	aAdd(_aTits, SE2->(RecNo()))
	SE2->(dbSkip())  // Proximo registro.
EndDo

// Exibe a tela de entrada de dados para o usuario,
// caso haja algum titulo a ser alterado.
If !empty(_aTits) .and. ParamBox(_aDados, "Entre com o a forma de pagamento", @_aRet)  // Se o usuario confirmou.
	_cForPgto := _aRet[1]  // Pega o que o usuario digitou, se ele confirmar.
Endif

// Altera os titulos, de acordo com a digitacao do usuario.
For _nAux1 := 1 to len(_aTits)
	SE2->(dbGoTo(_aTits[_nAux1]))  // Proximo registro.
	RecLock("SE2", .F.)  // Abre o registro para edicao.
	SE2->E2_XFORPGT := _cForPgto  // Atualiza o campo.
	SE2->(msUnLock())  // Salva o registro e libera para uso.
Next _nAux1

// Armazena as condicoes dos alias antes do processamento.
_aAreaE2 := SE2->(GetArea())

// Acerta os indices das tabelas.
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.


// Restaura as condicoes dos alias.
SE2->(RestArea(_aAreaE2))

Return