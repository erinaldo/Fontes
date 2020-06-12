#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME05
Atualiza as amarrações Grupo x Fornecedor a partir dos campos A2_XGRP01, A2_XGRP02 e A2_XGRP03
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOME05(lExecPe)
// Variavel auxiliar ao processamento.
Local _aResult, _cMsg, _cTit, _PL := CHR(13) + CHR(10)
Private lAbortPrint := .F., lEnd := .F.
default lExecPe:= .f.
        
if lExecPe    
	C2E05PCLI()
else  
	if msgyesno("Confirma a atualização do cadastro de Grupo x Fornecedor ?")                 
		// Inicia o processamento.
		MsAguarde({ |lEnd| _aResult := C2E05PSA2()}, "Atualizando Grupo x Fornecedor...", "Aguarde", .T.)
		
		// Se houve alguma inclusao ou exclusao na tabela de amarracoes, mostrar na tela.
		If ((_aResult[2] + _aResult[3]) > 0)
			_cMsg :=;
			"Total de clientes processados.: " + AllTrim(Str(_aResult[1])) + _PL +;
			"Total de amarrações criadas...: " + AllTrim(Str(_aResult[2])) + _PL +;
			"Total de amarrações excluidas.: " + AllTrim(Str(_aResult[3]))
			_cTit := "Informações"
			MsgBox (OemToAnsi(_cMsg), OemToAnsi(_cTit), "INFO")
		Endif 
	Endif
Endif

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E05PSA2  ºAutor  ³             	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa todos os clientes					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2E05PSA2()
// Variavel auxiliar do processamento.
Local _aResult, _nTotCli := 0, _nTotInc := 0, _nTotExc := 0
// Armazena as condicoes da tabela antes do processamento.
Private _aBMArea := SBM->(GetArea())
Private _aADArea := SAD->(GetArea())
Private _aA2Area := SA2->(GetArea())

// Acerta os indices que serao usados durante o processamento.
SAD->(dbSetOrder(1)); SBM->(dbSetOrder(1))

// Processa todos os clientes.
SA2->(dbGoTop())
Do While SA2->(!eof())
	MsProcTxt("Processando cliente: " + SA2->A2_COD)
	// Se o usuario cancelar ou a matriz retornada na funcao
	// for falso no primeiro item, terminar o processamento.
	_aResult := C2E05PCLI()
	If lAbortPrint .or. !(_aResult[1])
		SA2->(dbGoBottom())
	Endif
	// Acumuladores.
	_nTotCli += IIf(!lAbortPrint, 1, 0)
	_nTotInc += IIf(!lAbortPrint, _aResult[2], 0)
	_nTotExc += IIf(!lAbortPrint, _aResult[3], 0)
	SA2->(dbSkip())
EndDo

// Restaura as condicoes anteriores das tabelas SAD, SA2 e SBM.
SBM->(RestArea(_aBMArea))
SAD->(RestArea(_aADArea))
SA2->(RestArea(_aA2Area))

// Retorna uma matriz com os itens:
// 1 - Total de clientes processados.
// 2 - Total de amarracoes criadas.
// 3 - Total de amarracoes excluidas.
Return ({_nTotCli, _nTotInc, _nTotExc})
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E05PCLI  ºAutor  ³             	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o cliente.                    					  º±±
±±º          ³ Essa rotina processa os tres grupos de 					  º±±
±±º          ³ cada cliente e gera, para cada grupo,  					  º±±
±±º          ³ um registro na tabela SAD (Amarracao   					  º±±
±±º          ³ Grupo x Fornecedor.                    					  º±±
±±º          ³ Se algum erro ocorrer durante o proces-					  º±±
±±º          ³ samento, a matriz retornada pela fun-  					  º±±
±±º          ³ cao tera valor .F. no primeiro item.   					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static Function C2E05PCLI()

// Variaveis auxiliares ao processamento.
Local _lRet := .F., _cMsg, _cTit, _nAux1 := 0
Local _nCntBD := 0, _nCntA2 := 0, _nTotInc := 0, _nTotExc := 0
Local _nTotDel := 0, _nSldDel := 0
// Armazena as condicoes da tabela antes do processamento.
Private _aADArea := SAD->(GetArea())

// Acerta os indices que serao usados durante o processamento.
SAD->(dbSetOrder(1))

// Conta no SAD quantas amarracoes esse fornecedor tem.
SAD->(dbSeek(xFilial("SAD") + SA2->A2_COD + SA2->A2_LOJA, .F.))
Do While SAD->(!eof()) .and.;
	SAD->AD_FORNECE + SAD->AD_LOJA == SA2->A2_COD + SA2->A2_LOJA
	_nCntBD++
	SAD->(dbSkip())
EndDo

// Cria as amarracoes, caso seja necessario e incrementa na variavel _nCnBD
// a quantidade de registros criados na tabela SAD.
_nTotInc += C2E05SAD(SA2->(A2_COD + A2_LOJA), SA2->A2_XGRP01)
_nTotInc += C2E05SAD(SA2->(A2_COD + A2_LOJA), SA2->A2_XGRP02)
_nTotInc += C2E05SAD(SA2->(A2_COD + A2_LOJA), SA2->A2_XGRP03)
_nCntBD += _nTotInc  // Acumula as novas amarracoes, caso elas tenham sido criadas.

// Conta quantas amarracoes devem existir no SAD.
_nCntA2 += If ((empty(SA2->A2_XGRP01) .or. AllTrim(SA2->A2_XGRP01) == "00") .or. SA2->A2_XGRP01 $ (SA2->A2_XGRP02 + "," + SA2->A2_XGRP03), 0, 1)
_nCntA2 += If ((empty(SA2->A2_XGRP02) .or. AllTrim(SA2->A2_XGRP02) == "00") .or. SA2->A2_XGRP02 == SA2->A2_XGRP03, 0, 1)
_nCntA2 += If ((empty(SA2->A2_XGRP03) .or. AllTrim(SA2->A2_XGRP03) == "00"), 0, 1)

// Apaga as amarracoes excluidas pelo usuario.
_nSldDel := _nCntBD - _nCntA2 // Calcula quantos registros devem ser apagados do SAD.
SAD->(dbSeek(xFilial("SAD") + SA2->A2_COD + SA2->A2_LOJA, .F.))
Do While SAD->(!eof()) .and.;
	(SAD->AD_FORNECE + SAD->AD_LOJA == SA2->A2_COD + SA2->A2_LOJA)
	// Se essa amarracao nao existir no cadastro de fornecedores, apaga o registro.
	If !(SAD->AD_GRUPO $ (SA2->A2_XGRP01 + "," + SA2->A2_XGRP02 + "," + SA2->A2_XGRP03))
		_nTotExc ++
		_nSldDel --
		RecLock("SAD", .F.)
		SAD->(dbDelete())
		SAD->(msUnLock())
	Endif
	SAD->(dbSkip())
EndDo

// Nesse ponto do programa a variavel _nSldDel nunca pode ser diferente de zero. Caso
// isso ocorra, revisa o codigo fonte, ou entre em contato com o autor do programa.
If !(_lRet := (_nSldDel == 0))
	_cMsg := "Erro _nSldDel = " + AllTrim(Str(_nSldDel)) +;
	" #001. Avise um administrador do sistema."
	_cTit := "Atenção. Fornecedor: " + SA2->(A2_COD + A2_LOJA)
	MsgBox (OemToAnsi(_cMsg), OemToAnsi(_cTit), "ALERT")
Endif

// Restaura as condicoes anteriores da tabela SAD.
SAD->(RestArea(_aADArea))
// Retorna uma matriz de tres itens.
// 1 - Status do processamento: .T. para ok, ou .F. para erro.
// 2 - Quantidade de amarracoes criadas.
// 3 - Quantidade de amarracoes excluidas.
Return ({_lRet, _nTotInc, _nTotExc})
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E05SAD   ºAutor  ³             	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui uma amarracao, caso necessario		              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2E05SAD(_cFornCh, _cGrupo)
Local _cMsg, _cTit, _nRetorno
Private _aADArea, _aA2Area, _aBMArea
// Armazena as condicoes anteriores das tabelas SAD, SA2 e SBM.
_aADArea := SAD->(GetArea())
_aA2Area := SA2->(GetArea())
_aBMArea := SBM->(GetArea())

// Acerta os indices.
SAD->(dbSetOrder(1))
SA2->(dbSetOrder(1))
SBM->(dbSetOrder(1))
_nRetorno := 0
// Se for grupo "00" (generico para financeiro) nao atualiza a amarracao.
If !empty(_cGrupo) .and. AllTrim(_cGrupo) != "00"
	// Posiciona a tabela SBM (Grupo de produtos) e  SA2 (cadastro
	// de fornecedores) e processa.
	If  SBM->(dbSeek(xFilial("SBM") + _cGrupo, .F.)) .and.;
		SA2->(dbSeek(xFilial("SA2") + _cFornCh, .F.))
		// Processa, caso nao exista a amarracao.
		If !(SAD->(dbSeek(xFilial("SAD") + _cFornCh + SBM->BM_GRUPO, .F.)))
			RecLock("SAD", .T.)
			SAD->AD_FILIAL  := xFilial("SAD")
			SAD->AD_FORNECE := SA2->A2_COD
			SAD->AD_LOJA    := SA2->A2_LOJA
			SAD->AD_NOMEFOR := SA2->A2_NOME
			SAD->AD_GRUPO   := SBM->BM_GRUPO
			SAD->AD_NOMGRUP := SBM->BM_DESC
			SAD->(msUnLock())  // Salva as alteracoes.
			_nRetorno ++
		Endif
	Else
		_cMsg := "Grupo " + _cGrupo + " não encontrado."
		_cTit := "Fornecedor " + _cFornCh + " - " + SA2->A2_NOME
		MsgBox(OemToAnsi(_cMsg), OemToAnsi(_cTit), "ALERT")
	Endif
Endif
// Restaura as condicoes anteriores das tabelas SAD e SBM.
SAD->(RestArea(_aADArea))
SA2->(RestArea(_aA2Area))
SBM->(RestArea(_aBMArea))
// Retorna o numero de amarracoes criadas.
Return (_nRetorno)