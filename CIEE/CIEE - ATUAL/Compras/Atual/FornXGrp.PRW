#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FORNXGRP  ºAutor  ³Felipe Raposo       º Data ³  08/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Prog. cria os registros de amarracao Grupo x Fornecedor,   º±±
±±º          ³ a partir dos campos A2_GRUPO1, A2_GRUPO2 e A2_GRUPO3.      º±±
±±º          ³ No cadastro de fornecedores existem tres pondos de entrada.º±±
±±º          ³ Um na confirmacao da inclusao, outro na alteracao e outro  º±±
±±º          ³ exclusao. Esses pontos de entrada atualizam a tabela de    º±±
±±º          ³ amarracao Grupo x Fornecedores (SAD).                      º±±
±±º          ³ Tambem esta nesse arquivo a User Function FornXGrp()       º±±
±±º          ³ Essa funcao refaz as amarracoes de todos os clientes. Se a º±±
±±º          ³ tabela de clientes for muito grande, o processamento pode  º±±
±±º          ³ levar um certo tempo.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para atualizar as amarracoes    ³
//³ Grupo x Fornecedor na inclusao do fornecedor.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function M020Inc()
U_ProcCli()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para atualizar as amarracoes    ³
//³ Grupo x Fornecedor na alteracao do fornecedor.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function M020Alt()
U_ProcCli()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para excluir as amarracoes      ³
//³ Grupo x Fornecedor na exclusao do fornecedor.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function M020Dele()
// Armazena as condicoes da tabela antes do processamento.
Private _aADArea := SAD->(GetArea())
// Acerta os indices que serao usados durante o processamento.
SAD->(dbSetOrder(1)); SAD->(dbSeek(xFilial("SAD") + SA2->A2_COD, .F.))
Do While (xFilial("SAD") + SA2->A2_COD == SAD->AD_FILIAL + SAD->AD_FORNECE)
	RecLock("SAD", .F.)
	SAD->(dbDelete())
	SAD->(msUnLock())
EndDo
// Restaura as condicoes anteriores das tabelas SAD e SBM.
SAD->(RestArea(_aADArea))
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FORNXGRP  ºAutor  ³Felipe Raposo       º Data ³  08/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Prog. cria os registros de amarracao Grupo x Fornecedor,   º±±
±±º          ³ a partir dos campos A2_GRUPO1, A2_GRUPO2 e A2_GRUPO3.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ 1 - Essa rotina reprocessa todos os clientes e acerta      º±±
±±º          ³ todas as amarracoes, caso seja necessario.                 º±±
±±º          ³ 2 - O grupo "00" (generico para o financeiro) eh ignorado  º±±
±±º          ³ nesse processamento.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FornXGrp()
// Variavel auxiliar ao processamento.
Local _aResult, _cMsg, _cTit, _PL := CHR(13) + CHR(10)
Private lAbortPrint := .F., lEnd := .F.

// Inicia o processamento.
MsAguarde({ |lEnd| _aResult := ProcSA2()}, "Atualizando Grupo x Fornecedor...", "Aguarde", .T.)

// Se houve alguma inclusao ou exclusao na tabela de amarracoes, mostrar na tela.
If ((_aResult[2] + _aResult[3]) > 0)
	_cMsg :=;
	"Total de clientes processados.: " + AllTrim(Str(_aResult[1])) + _PL +;
	"Total de amarrações criadas...: " + AllTrim(Str(_aResult[2])) + _PL +;
	"Total de amarrações excluidas.: " + AllTrim(Str(_aResult[3]))
	_cTit := "Informações"
	MsgBox (OemToAnsi(_cMsg), OemToAnsi(_cTit), "INFO")
Endif
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa todos os clientes.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcSA2()
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
	_aResult := U_ProcCli()
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa o cliente.                    ³
//³Essa rotina processa os tres grupos de ³
//³cada cliente e gera, para cada grupo,  ³
//³um registro na tabela SAD (Amarracao   ³
//³Grupo x Fornecedor.                    ³
//³Se algum erro ocorrer durante o proces-³
//³samento, a matriz retornada pela fun-  ³
//³cao tera valor .F. no primeiro item.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ProcCli()

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
_nTotInc += GravaSAD(SA2->(A2_COD + A2_LOJA), SA2->A2_GRUPO1)
_nTotInc += GravaSAD(SA2->(A2_COD + A2_LOJA), SA2->A2_GRUPO2)
_nTotInc += GravaSAD(SA2->(A2_COD + A2_LOJA), SA2->A2_GRUPO3)
_nCntBD += _nTotInc  // Acumula as novas amarracoes, caso elas tenham sido criadas.

// Conta quantas amarracoes devem existir no SAD.
_nCntA2 += If ((empty(SA2->A2_GRUPO1) .or. AllTrim(SA2->A2_GRUPO1) == "00") .or. SA2->A2_GRUPO1 $ (SA2->A2_GRUPO2 + "," + SA2->A2_GRUPO3), 0, 1)
_nCntA2 += If ((empty(SA2->A2_GRUPO2) .or. AllTrim(SA2->A2_GRUPO2) == "00") .or. SA2->A2_GRUPO2 == SA2->A2_GRUPO3, 0, 1)
_nCntA2 += If ((empty(SA2->A2_GRUPO3) .or. AllTrim(SA2->A2_GRUPO3) == "00"), 0, 1)

// Apaga as amarracoes excluidas pelo usuario.
_nSldDel := _nCntBD - _nCntA2 // Calcula quantos registros devem ser apagados do SAD.
SAD->(dbSeek(xFilial("SAD") + SA2->A2_COD + SA2->A2_LOJA, .F.))
Do While SAD->(!eof()) .and.;
	(SAD->AD_FORNECE + SAD->AD_LOJA == SA2->A2_COD + SA2->A2_LOJA)
	// Se essa amarracao nao existir no cadastro de fornecedores, apaga o registro.
	If !(SAD->AD_GRUPO $ (SA2->A2_GRUPO1 + "," + SA2->A2_GRUPO2 + "," + SA2->A2_GRUPO3))
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui uma amarracao, caso necessario. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GravaSAD(_cFornCh, _cGrupo)
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