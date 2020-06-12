#INCLUDE "rwmake.ch"
#INCLUDE "ccoma02.ch"
#INCLUDE "_FixSX.ch" // "AddSX1.ch"
#DEFINE _PL CHR(13) + CHR(10)
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ccoma02   º Autor ³ Felipe Raposo      º Data ³  04/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizacao da cotacao de compra.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ccoma02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aAreaC8, _aCpos, _cPerg, _aSX1
Local _mFilComp, _mFilFech, _cUser, _cFiltro, _bFilBrw, _aIndexSC8 := {}

Private cCadastro, cDelFunc, cString

// Perguntas incluidas no sistema.
_cPerg := "CMA02a    "
_aSX1 := {;
{_cPerg,"01","Exibe p/ comprador  ","Exibe p/ comprador  ","Exibe p/ comprador  ","mv_ch1","N",01,0,1,"C","","mv_par01","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""},;
{_cPerg,"02","Filtra cot. atendida","Filtra cot. atendida","Filtra cot. atendida","mv_ch2","N",01,0,1,"C","","mv_par02","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""},;
{_cPerg,"03","Comprador           ","Comprador           ","Comprador           ","mv_ch3","C",15,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","USC","",""}}
//{_cPerg,"04","Observ.relatorio    ","Observ.relatorio    ","Observ.relatorio    ","mv_ch4","C",90,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1)

// O bloco de comandos abaixo atualiza a tabela SXB antes de
// executar o programa.
_aSXb := {;
{"USC","1","01","US","Usuarios","Usuarios","Users",""},;
{"USC","5","01","","","","","NAME"}}
//AjustaSXB(_aSXb) // _FixSX.ch

If Pergunte(_cPerg, .T.)
	
	// Armazena as condicoes do alias.
	_aAreaC8 := SC8->(GetArea())
	
	// Considera os parametros digitados pelo usuario.
	_mFilComp := (mv_par01 == 1)
	_mFilFech := (mv_par02 == 1)
//	_cUser    := If(empty(mv_par03), SubStr(cUsuario, 7, 15), mv_par03)
	_cUser    := If(empty(mv_par03), cUserName, mv_par03)
	
	// Filtra SC fechadas.
	_cFiltro := IIf (_mFilFech, "empty(C8_NUMPED)", "")
	
	// Filtra por comprador.
//	_cFiltro += IIf (_mFilComp, IIf(empty(_cFiltro), "", " .and. ") + "U_ccoma02c(C8_NUMSC, '" + _cUser + "')", "")
	_cFiltro += IIf (_mFilComp, IIf(empty(_cFiltro), "", " .and. ") + "alltrim(C8_SOLICIT) == '"+alltrim(_cUser) +"'", "")

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta um aRotina proprio.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRotina := {;
	{"Pesquisar",      "AxPesqui",      0, 1},;
	{"Incluir",        "U_ccoma02a(1)", 0, 4},;
	{"Alterar",        "U_ccoma02a(2)", 0, 4},;
	{"Analisar",       "U_ccoma02a(3)", 0, 4},;
	{"Fechar cotação", "U_ccoma02a(4)", 0, 4},;
	{"Excluir",        "U_ccoma02a(5)", 0, 5},;
	{"Legenda",        "U_ccoma02a(6)", 0, 4}}
	//{"Visualizar", "AxVisual", 0, 2},;
	//{"Alterar",    "AxAltera", 0, 4},;
	//{"Excluir",    "AxDeleta", 0, 5}}
	
	cCadastro := "Cotação de compras"
	cDelFunc  := ".F."
	cString   := "SC8"
	_aCpos := {;   // Campo que aparecera no browser, antes dos outros.
	{"Cotação",    "C8_NUM"},;
	{"Item",       "C8_ITEM"},;
	{"Fornecedor", "C8_FORNECE"},;
	{"Loja",       "C8_LOJA"}}
	dbSelectArea(cString)
	dbSetOrder(4)  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
	
	// Filtra o browser de acordo com os parametros informados pelo usuario.
	If !empty(_cFiltro)
		_bFilBrw := {|| FilBrowse(cString, @_aIndexSC8, @_cFiltro)}
		Eval(_bFilBrw)
	Endif

	// Exibe a tela com a lista de cotacoes ja filtrada.
	mBrowse(06, 01, 22, 75, cString, _aCpos,,,,, Legenda(0))

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndFilBrw(cString, _aIndexSC8)
	
	// Retorna as condicoes anteriores do alias.
	SC8->(RestArea(_aAreaC8))
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMA02a  ºAutor  ³ Felipe Raposo      º Data ³  18/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ccoma02a(_nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cMsg, _aCPAux1, _nAux1, _nAux2, _nAux3, _cAux1, _cAux2, _cAux3, _aAux1, _cFornAux
Local _aCotAux1, _cItem, _cCotAux, _cNumSC, _nPreco, _lPriX8 := .T.
Local _cC7_NUM, _aC7_NUM, _cGrpAprov, _cGrpCompr, _nTotLib, lFirstNiv
Local _aAreaA2, _aAreaB1, _aAreaC1, _aAreaC7, _aAreaC8, _aAreaE2, _aAreaY1
LOCAL _cNomeArq   := "SZI" + SM0->M0_CODFIL +"0"
// Armazenam as condicoes das tabelas antes do processamento.
Private _aCotProd,_nPrvOpc

// Variaveis do dialogo principal.
Private _cProdCot, _nJuros, _mObs,_dEmissao, aCols, aHeader, n
_mObs := SPACE(20)
// Variaveis do primeiro formulario.
Private _cCotacao1, _cFornCod1, _cPgtoCod1, _cFornLoj1, _cFornNom1, _cItem1, aVetor1, nList1, _nPrazo1
Private _nQTDE1, _nPRECO1, _nDESC1, _nVLDESC1, _nIPI1, _nISS1, _nFRETE1, _nDESP1, _nACERTO1, _nTotal1
Private _cNumPed1, _cNumSC1, _cItemSC1, _cCotSts1, _cNumPro1, _cIdent1

// Variaveis do segundo formulario.
Private _cCotacao2, _cFornCod2, _cPgtoCod2, _cFornLoj2, _cFornNom2, _cItem2, aVetor2, nList2, _nPrazo2
Private _nQTDE2, _nPRECO2, _nDESC2, _nVLDESC2, _nIPI2, _nISS2, _nFRETE2, _nDESP2, _nACERTO2, _nTotal2
Private _cNumPed2, _cNumSC2, _cItemSC2, _cCotSts2

// Variaveis do terceiro formulario.
Private _cCotacao3, _cFornCod3, _cPgtoCod3, _cFornLoj3, _cFornNom3, _cItem3, aVetor3, nList3, _nPrazo3
Private _nQTDE3, _nPRECO3, _nDESC3, _nVLDESC3, _nIPI3, _nISS3, _nFRETE3, _nDESP3, _nACERTO3, _nTotal3
Private _cNumPed3, _cNumSC3, _cItemSC3, _cCotSts3

// Variavel auxiliar ao processamento.
_nPrvOpc := _nOpc

// Armazenam as condicoes das tabelas antes do processamento.
_aAreaA2 := SA2->(GetArea())
_aAreaB1 := SB1->(GetArea())
_aAreaC1 := SC1->(GetArea())
_aAreaC7 := SC7->(GetArea())
_aAreaC8 := SC8->(GetArea())
_aAreaE2 := SE2->(GetArea())
_aAreaY1 := SY1->(GetArea())

// Valores iniciais das variaveis.
_nJuros := 0
_cFornCod1 := _cFornNom1 := _cFornCod2 := _cFornNom2 := _cFornCod3 := _cFornNom3 := Space(06)
_cPgtoCod1 := _cPgtoCod2 :=  _cPgtoCod3 := Space(03)
_cFornLoj1 := _cFornLoj2 := _cFornLoj3 := Space(02)
_cItem1 := _cItem2 := _cItem3 := Space(02)
_nPrazo1 := _nPrazo2 := _nPrazo3 := 0
aVetor1 := aVetor2  := aVetor3 := {{Trim(Transform(0, PesqPict('SZ3', 'Z3_VALOR'))), ctod("")}}
_nQTDE1 := _nPRECO1 := _nDESC1 := _nVLDESC1 := _nIPI1 := _nISS1 := _nFRETE1 := _nDESP1 := _nACERTO1 := _nTotal1 := 0
_nQTDE2 := _nPRECO2 := _nDESC2 := _nVLDESC2 := _nIPI2 := _nISS2 := _nFRETE2 := _nDESP2 := _nACERTO2 := _nTotal2 := 0
_nQTDE3 := _nPRECO3 := _nDESC3 := _nVLDESC3 := _nIPI3 := _nISS3 := _nFRETE3 := _nDESP3 := _nACERTO3 := _nTotal3 := 0
_dEmissao := CTOD("  /  /  ")
_cProdCot := SC8->C8_PRODUTO

Do Case
	Case _nOpc == 1  // Inclui cotacao.
		If empty(SC8->C8_NUMPED)
			_cCotacao1 := SC8->C8_NUM
			_cFornCod1 := CriaVar("C8_FORNECE")
			_cPgtoCod1 := CriaVar("C8_COND")
			_cFornLoj1 := CriaVar("C8_LOJA")
			_cItem1    := SC8->C8_ITEM
			_cFornNom1 := CriaVar("A2_NREDUZ")
			_nPrazo1   := CriaVar("C8_PRAZO")
			aVetor1    := U_GetCondPag("", 1)
			_nQTDE1    := SC8->C8_QUANT
			_nPRECO1   := CriaVar("C8_PRECO")
			_nDESC1    := CriaVar("C8_DESC")
			_nVLDESC1  := CriaVar("C8_VLDESC")
			_nIPI1     := CriaVar("C8_ALIIPI")
			_nISS1     := CriaVar("C8_PICM")
			_nFRETE1   := CriaVar("C8_VALFRE")
			_nDESP1    := CriaVar("C8_DESPESA")
			_nACERTO1  := CriaVar("C8_ACERTO")  // Especifico.
			_nTotal1   := CriaVar("C8_TOTAL")
			_cNumPed1  := CriaVar("C8_NUMPED")
			_cNumSC1   := SC8->C8_NUMSC
			_cItemSC1  := SC8->C8_ITEMSC
			_cIdent1   := SC8->C8_IDENT
			Show1Form(_nOpc)
		Else
			_cMsg := "A cotação " + SC8->C8_NUM + " já está encerrada!"
			MsgBox(_cMsg, "Atenção", "INFO")
		Endif
		
	Case _nOpc == 2  // Alterar cotacao.
		If empty(SC8->C8_NUMPED)
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
			// Atualiza campos.
			_cCotacao1 := SC8->C8_NUM
			_cFornCod1 := SC8->C8_FORNECE 
            _cPgtoCod1 := SC8->C8_COND
			_cFornLoj1 := SC8->C8_LOJA
			_cItem1    := SC8->C8_ITEM
			_cFornNom1 := SA2->A2_NREDUZ
			_nPrazo1   := SC8->C8_PRAZO
			aVetor1    := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
			_nQTDE1    := SC8->C8_QUANT
			_nPRECO1   := SC8->C8_PRECO
			_nDESC1    := SC8->C8_DESC
			_nVLDESC1  := SC8->C8_VLDESC
			_nIPI1     := SC8->C8_ALIIPI
			_nISS1     := SC8->C8_PICM
			_nFRETE1   := SC8->C8_VALFRE
			_nDESP1    := SC8->C8_DESPESA
			_nACERTO1  := SC8->C8_ACERTO
			_nTotal1   := SC8->C8_TOTAL
			_cNumPed1  := SC8->C8_NUMPED
			Show1Form(_nOpc)
		Else
			_cMsg := "A cotação " + SC8->C8_NUM + " já está encerrada!"
			MsgBox(_cMsg, "Atenção", "INFO")
		Endif
		
	Case _nOpc == 3  // Analisa cotacao.
		_cCotAux  := SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO)
		_cNumSC   := SC8->C8_NUMSC
		SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
		SC8->(dbGoTop()); SC8->(dbSeek(_cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
		_aCotProd := {}
		// Enquanto for a cotacao do mesmo produto.
		Do While SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO) == _cCotAux
			If SC8->C8_TOTAL != 0 .and. SC8->C8_NUMSC == _cNumSC
				aAdd (_aCotProd, {SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO), SC8->C8_TOTAL,SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT)})
			Endif
			SC8->(dbSkip())
		EndDo
		// Ordena por total (segundo campo da matriz) em ordem crescente.
		_aCotProd := aSort(_aCotProd,,, { |x, y| x[2] < y[2] })
		If len(_aCotProd) > 0
			SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			For _nAux1 := 1 to IIf (len(_aCotProd) > 3, 3, len(_aCotProd))
				_cAux1 := AllTrim(str(_nAux1))
				SC8->(dbSeek(xFilial("SC8") + _aCotProd[_nAux1, 1], .F.))
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Atualiza campos.
				_cCotacao&(_cAux1) := SC8->C8_NUM
				_cFornCod&(_cAux1) := SC8->C8_FORNECE
                _cPgtoCod&(_cAux1) := SC8->C8_COND				
				_cFornLoj&(_cAux1) := SC8->C8_LOJA
				_cItem&(_cAux1)    := SC8->C8_ITEM
				_cFornNom&(_cAux1) := SA2->A2_NREDUZ
				_nPrazo&(_cAux1)   := SC8->C8_PRAZO
				aVetor&(_cAux1)    := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
				_nQTDE&(_cAux1)    := SC8->C8_QUANT
				_nPRECO&(_cAux1)   := SC8->C8_PRECO
				_nDESC&(_cAux1)    := SC8->C8_DESC
				_nVLDESC&(_cAux1)  := SC8->C8_VLDESC
				_nIPI&(_cAux1)     := SC8->C8_ALIIPI
				_nISS&(_cAux1)     := SC8->C8_PICM
				_nFRETE&(_cAux1)   := SC8->C8_VALFRE
				_nDESP&(_cAux1)    := SC8->C8_DESPESA
				_nACERTO&(_cAux1)  := SC8->C8_ACERTO
				_nTotal&(_cAux1)   := SC8->C8_TOTAL
				_cNumPed&(_cAux1)  := SC8->C8_NUMPED
				_cCotSts&(_cAux1)  := SC8->C8_COTSTS
			Next _nAux1
			_mObs    := SC8->C8_OBSMEMO
			_dEmissao :=  SC8->C8_EMISSAO
			Show3Forms(_nOpc)
    		DbselecTarea("SZI")
            DBSETORDER(1)    
            IF DBSEEK(XFILIAL("SZI")+_cCotacao1)
               _cQuery := " DELETE FROM "+_cNomeArq+" WHERE ZI_NUMSC  = '" +_cCotacao1+"'"
               TCSQLEXEC(_cQuery)
               ENDIF              
             DbselecTarea("SC8")

		Else
			_cMsg := "Não existe nenhuma proposta para essa cotação!!!"
			MsgAlert(_cMsg, "Atenção")
		Endif
		
	Case _nOpc == 4  // Fechar cotacao.
		_cCotAux := SC8->C8_NUM
		_cNumSC  := SC8->C8_NUMSC
		_cAux1   := SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO)
		
		If !empty(SC8->C8_NUMPED)
			_cMsg := "A cotação " + SC8->C8_NUM + " já está encerrada!"
			MsgBox(_cMsg, "Solicitação " + _cNumSC)
			Return //Exit
		Endif
		_cMsg := "Deseja fechar a cotação " + SC8->C8_NUM + "?"
		If MsgYesNo(_cMsg, "Solicitação " + _cNumSC)
			SC8->(dbSetOrder(3))  // C8_FILIAL+C8_NUM+C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED+C8_ITEMPED.
			SC8->(dbGoTop()); SC8->(dbSeek(xFilial("SC8") + _cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
			// Variaveis auxiliares.
			_aCotAux1 := {}  // Cotacao x Fornecedor.
			// _aCotAux1[n, 1] - Cotacao (RecNo).
			// _aCotAux1[n, 2] - Fornecedor + Loja.
			// _aCotAux1[n, 3] - Outra matriz contendo as parcelas.
			
			// Enquanto for a mesma cotacao.
			// Armazena em variaveis a(s) cotacao(oes) escolhida(s) para auxiliar
			// no processamento mais adiante.
			Do While SC8->(C8_FILIAL+C8_NUM) == xFilial("SC8") + _cCotAux
				// Status da cotacao.
				// 1 - Cotacao escolhida.
				// 2 - Cotacao nao escolhida.
				If SC8->C8_COTSTS == "1" .and. empty(SC8->C8_NUMPED)
					If SC8->C8_TOTAL > 0
						// C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO (SINDEX 4)
						_cAux1 := SC8->(C8_NUM + C8_IDENT + C8_PRODUTO)                       // Ordem 4 do SC8.
						_cAux2 := SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM)	// Ordem 1 do SZ3.
						// Matriz que contem a cotacao vencedora e o fornecedor vencedor.
						aAdd (_aCotAux1, {SC8->(RecNo()), SC8->(C8_FORNECE + C8_LOJA), U_GetCondPag(_cAux2, 2)})
					Else
						_cMsg := "A cotação escolhida não foi atualizada junto ao fornecedor!"
						MsgAlert(_cMsg, "Atenção")
						Exit
					Endif
				Endif
				SC8->(dbSkip())
			EndDo
			
			// Testa se houve alguma cotacao escolhida para virar pedido.
			If len(_aCotAux1) <= 0
				_cMsg := "A cotação " + _cCotAux + " não tem um fornecedor vencedor!"
				MsgBox(_cMsg, "Solicitação " + _cNumSC)
				Return //Exit
			Endif
			
			// Ordena por fornecedor (segundo campo da matriz) em ordem crescente, para
			// poder aglutinar as cotacoes de um mesmo fornecedor em um unico pedido.
			_aCotAux1 := aSort(_aCotAux1,,, {|x, y| x[2] < y[2]})
			
			Begin Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria o pedido de compra.                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.
			SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
			SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN.
			SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
			SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
			SY1->(dbSetOrder(3))  // Y1_FILIAL+Y1_USER.
			SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
			_cFornAux := ""; _aC7_NUM := {}
			
           _nItem    := 1 
			
			For _nAux1 := 1 to len(_aCotAux1)
				If _cFornAux != _aCotAux1[_nAux1, 2]
					If !_lPriX8
						ConfirmSX8()
					Endif
					_cC7_NUM  := GetSX8Num("SC7", "C7_NUM")
					_lPriX8 := .F.
					// Armazena os pedidos criados para processar o grupo
					// de liberacao de pedidos posteriormente.
					aAdd (_aC7_NUM, _cC7_NUM)
//					_nItem    := 1  // Na Gravação do Pedido os itens estão repetidos  CFB - 15/06/04 10H05
					_cFornAux := _aCotAux1[_nAux1, 2]
					If SC7->(dbSeek(xFilial("SC7") + _cC7_NUM, .F.))
						_cMsg := "Já existe o pedido de compra de número " + _cC7_NUM + _PL +;
						"e o sistema gerou esse número novamente." + _PL +;
						"Isso pode misturar os dois pedidos de compra com o mesmo número." + _PL +;
						"Para evitar que isso ocorra o sistema irá abortar." + _PL + _PL +;
						"Favor informar o administrador do sistema."
						MsgAlert(_cMsg, "Atenção")
						"Erro forcado: num. do PC " + 1  // Forca o erro para o sistema abortar.
					Endif
				Endif
				// Gera o pedido de compra.
				// Ordem 4 - C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT
				SC8->(dbGoTo(_aCotAux1[_nAux1, 1]))
				SB1->(dbSeek(xFilial("SB1") + SC8->C8_PRODUTO, .F.))
				SC1->(dbSeek(xFilial("SC1") + SC8->(C8_NUM + C8_PRODUTO + C8_IDENT), .F.))
				_cItem := StrZero(_nItem++, len(SC7->C7_ITEM))
				/* Inclui o pedido */
				RecLock("SC7", .T.)
				SC7->C7_FILIAL  := xFilial("SC7")
				SC7->C7_FILENT  := xFilial("SC7")
				SC7->C7_NUM     := _cC7_NUM
				SC7->C7_FORNECE := SC8->C8_FORNECE
				SC7->C7_LOJA    := SC8->C8_LOJA
				SC7->C7_ITEM    := _cItem // SC8->C8_ITEMSC //_cItem  / Para o pedido estava gravando o mesmo item da cotação qdo. deveria ser SEQUENCIAL CFB 15/06/04
				SC7->C7_NUMSC   := SC8->C8_NUMSC
				SC7->C7_ITEMSC  := SC8->C8_ITEMSC
				SC7->C7_QTDSOL  := SC8->C8_QUANT
				SC7->C7_NUMCOT  := SC8->C8_NUM
				SC7->C7_PRODUTO := SC8->C8_PRODUTO
				SC7->C7_DESCRI  := SB1->B1_DESC  // DESCR. PRODUTO.

				SC7->C7_ESPEC   := SB1->B1_ESPEC  // ESPECIFICACAO PRODUTO.
				
				SC7->C7_UM      := SC8->C8_UM
				SC7->C7_SEGUM   := SC8->C8_SEGUM
				SC7->C7_QUANT   := SC8->C8_QUANT
				SC7->C7_QTSEGUM := SC8->C8_QTSEGUM
//				_nPreco := SC8->(C8_TOTAL / C8_QUANT)
				_nPreco := SC8->C8_PRECO
				_nTotal := SC8->(C8_TOTAL - C8_DESPESA - C8_VALFRE - C8_VALIPI)
				// _nPreco := SC8->C8_PRECO - SC8->(C8_VLDESC / C8_QUANT)
				// Arredonda para baixo as casas apos os centavos.
				_nFator := 10 ^ TamSX3("C7_PRECO")[2]   // 10.000,00
				_nPreco := int(_nPreco * _nFator) / _nFator
				SC7->C7_PRECO   := _nPreco
				SC7->C7_TOTAL   := _nPreco * SC8->C8_QUANT
				SC7->C7_DESPESA := SC8->C8_DESPESA
				SC7->C7_VLDESC  := ((_nPreco * SC8->C8_QUANT) - _nTotal)  // DESCONTO ($).
				SC7->C7_VALFRE  := SC8->C8_VALFRE
				//SC8->(C8_QUANT * C8_PRECO - C8_VLDESC + C8_ACERTO)
				// O desconto nao saira destacado no pedido. Ele sera
				// calculado e embutido no valor unitario.
				// SC7->C7_DESC1   := SC8->C8_DESC1  // DESCONTO (%).
				// SC7->C7_DESC    := SC8->C8_DESC   // DESCONTO (%).
				// SC7->C7_VLDESC  := SC8->C8_VLDESC // DESCONTO ($).
				SC7->C7_BASEIPI := SC8->C8_BASEIPI  // IPI.
				SC7->C7_IPI     := SC8->C8_ALIIPI
				SC7->C7_VALIPI  := SC8->C8_VALIPI
				// SC7->C7_BASEICM :=  // ICMS.
				// SC7->C7_PICM    :=
				// SC7->C7_VALICM  :=
				SC7->C7_TES     := SB1->B1_TE
				SC7->C7_CC      := SC1->C1_CC
				SC7->C7_EMISSAO := dDataBase
				SC7->C7_DATPRF  := DataValida(SC8->C8_PRAZO + dDataBase) // DATA ENTREGA
				SC7->C7_TIPO    := 1
				SC7->C7_LOCAL   := SB1->B1_LOCPAD
				SC7->C7_OBS     := SC8->C8_OBS
				SC7->C7_COND    := SC8->C8_COND
				SC7->C7_FLUXO   := "S"
				SC7->C7_PENDEN  := "N"
				SC7->C7_USER    := RetCodUsr()  // __cUserID // Cod. do usuario.
				SC7->C7_TPFRETE := "C"   // CIF
				SC7->C7_MOEDA   := 1
				SC7->C7_TXMOEDA := 1
				SC7->C7_PENDEN  := "N"
				SC7->C7_CONAPRO := "L"
				SC7->C7_ESPEC	:= SC1->C1_ESPEC 		//Acrescentado pelo analista Emerson para trazer a ESPECIFICAO do produto. dia 23/02/2010

				SC7->C7_RATEIO	:= "2" 					//Acrescentado pelo analista Emerson dia 03/05/2012. Campo novo na versao 11 inicializador Padrao igual a NAO.
				/*
				// Aplicar a rotina de acordo com o programa de
				// inclusao de pedido de compra.
				SC7->C7_CONAPRO :=
				SC7->C7_GRUPCOM :=
				SC7->C7_APROV   :=
				*/
				SC7->(msUnLock())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria os titulos a pagar no financeiro.                          ³
				//³ Caso o titulo ja exista, somente incrementa o valor.            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Varre toda a matriz que contem a condicao de pagto. da cotacao,
				// ou seja, processa todas as parcelas.
				_nAux3 := len(_aCotAux1[_nAux1, 3])  // Parcelas.
				For _nAux2 := 1 to _nAux3
					_cCotAux := _aCotAux1[_nAux1, 3][_nAux2]
					SZ3->(dbSeek(xFilial("SZ3") + _cCotAux, .F.))
					If SZ3->Z3_TIPO == "P" .or.;   // Pagto. a partir do pedido.
						SZ3->Z3_TIPO == "D" // Uma data especifica.
						_cAux1 := IIf (_nAux3 > 1, char(64 + val(SZ3->Z3_PARCELA)), "")  // Parcela.
						_cAux2 := "PC " + _cC7_NUM + _cAux1  // Chave do titulo.
						// Indice 1 - E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
						If  SE2->(dbSeek(xFilial("SE2") + _cAux2, .F.)) .and.;
							SE2->E2_VENCTO == SZ3->Z3_DATA
							RecLock("SE2", .F.)
							SE2->E2_VALOR   += SZ3->Z3_VALOR
							SE2->E2_SALDO   += SZ3->Z3_VALOR
							SE2->E2_VLCRUZ  += SZ3->Z3_VALOR
							SE2->(msUnLock())
						Else
							// Encontra a ultima parcela e incrementa um, para
							// nao gerar chaves duplicadas.
							_nAux4 := _nAux3
							Do While SE2->(dbSeek(xFilial("SE2") + _cAux2, .F.))
								_nAux4 ++
								_cAux1 := char(64 + val(SZ3->Z3_PARCELA))
								_cAux2 := "PC " + _cC7_NUM + _cAux1  // Chave do titulo.
							EndDo
							RecLock("SE2", .T.)
							SE2->E2_FILIAL  := xFilial("SE2")
							SE2->E2_TIPO    := "PC"
							SE2->E2_NUM     := _cC7_NUM
							SE2->E2_PREFIXO := "PC"
							SE2->E2_PARCELA := _cAux1
							SE2->E2_FORNECE := SC8->C8_FORNECE
							SE2->E2_LOJA    := SC8->C8_LOJA
							SE2->E2_NOMFOR  := SA2->A2_NOME
							SE2->E2_EMISSAO := dDataBase
							SE2->E2_VENCTO  := SZ3->Z3_DATA
							SE2->E2_VENCREA := SZ3->Z3_DATA
							SE2->E2_VALOR   := SZ3->Z3_VALOR
							SE2->E2_EMIS1   := dDataBase
							SE2->E2_SALDO   := SZ3->Z3_VALOR
							SE2->E2_VENCORI := SZ3->Z3_DATA
							SE2->E2_MOEDA   := 1
							SE2->E2_RATEIO  := "N"
							SE2->E2_VLCRUZ  := SZ3->Z3_VALOR
							SE2->E2_FLUXO   := "S"
							SE2->E2_ORIGEM  := "FINA050" //"CCOMA02"
							SE2->E2_DESDOBR := "N"
//							SE2->E2_MULTNAT := "2"
							SE2->E2_MULNATU := "2"							
							SE2->E2_PROJPMS := "2"
							SE2->E2_DIRF    := "2"
							SE2->E2_PEDIDO  := _cC7_NUM
							SE2->(msUnLock())
						Endif
					Endif
				Next _nAux2
				/**/
				
				// Variaveis auxiliares para a marcacao das cotacoes
				// e dos pedidos como fechados.
				_cAux1 := SC8->C8_NUM
				_cAux2 := SC8->C8_IDENT
				_cAux3 := SC8->C8_PRODUTO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a tabela de sol. compras (marca como SC atendida).     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_aAux1 := {}
				SC1->(dbGoTop()); SC1->(dbSeek(xFilial("SC1") + _cAux1 + _cAux3 + _cAux2, .T.))
				Do While SC1->(C1_FILIAL + C1_COTACAO + C1_PRODUTO + C1_IDENT) == xFilial("SC1") + _cAux1 + _cAux3 + _cAux2
					aAdd(_aAux1, SC1->(RecNo()))
					SC1->(dbSkip())
				EndDo
				For _nAux2 := 1 to len(_aAux1)
					SC1->(dbGoTo(_aAux1[_nAux2]))
					RecLock("SC1", .F.)
					SC1->C1_PEDIDO  := _cC7_NUM
					SC1->C1_ITEMPED := _cItem
					SC1->C1_FORNECE := SC8->C8_FORNECE
					SC1->C1_LOJA    := SC8->C8_LOJA
					SC1->C1_QUJE    += SC8->C8_QUANT
					SC1->C1_QUJE    := IIf (SC1->C1_QUJE > SC1->C1_QUANT, SC1->C1_QUANT, SC1->C1_QUJE)
					SC1->(msUnLock())
				Next _nAux2
				/**/
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a tabela de cotacoes (marca como cotacao fechada).     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_aAux1 := {}
				SC8->(dbGoTop()); SC8->(dbSeek(xFilial("SC8") + _cAux1 + _cAux2 + _cAux3, .T.))
				Do While SC8->(C8_FILIAL + C8_NUM + C8_IDENT + C8_PRODUTO) == xFilial("SC8") + _cAux1 + _cAux2 + _cAux3
					aAdd(_aAux1, SC8->(RecNo()))
					SC8->(dbSkip())
				EndDo
				For _nAux2 := 1 to len(_aAux1)
					SC8->(dbGoTo(_aAux1[_nAux2]))
					RecLock("SC8", .F.)
					SC8->C8_NUMPED  := IIf (SC8->C8_COTSTS == "1", _cC7_NUM, Replicate("X", len(SC8->C8_NUMPED)))
					SC8->C8_ITEMPED := IIf (SC8->C8_COTSTS == "1", _cItem,   Replicate("X", len(SC8->C8_ITEMPED)))
					SC8->C8_MOTIVO  := IIf (SC8->C8_COTSTS == "1", "ENCERRADO AUTOMATICAMENTE", "")
					SC8->(msUnLock())
				Next _nAux2
				/**/
				
				// Ponto de entrada copiado do programa oficial.
				If ExistBlock("avalcot"); ExecBlock("avalcot"); Endif
				
			Next _nAux1
			ConfirmSX8()
			
			// Trecho do programa extraido do MATA120.PRX e adaptado para o CIEE.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera arquivo de controle de alcadas SCR.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Grupo de aprovador do ped. de compra.
			_cGrpAprov := SuperGetMv("MV_PCAPROV")
			For _nAux1 := 1 to len(_aC7_NUM)
				// Totaliza o pedido de compra.
				_nTotLib := 0
				SC7->(dbSeek(xFilial("SC7") + _aC7_NUM[_nAux1], .F.))
				Do While SC7->(C7_FILIAL + C7_NUM) == xFilial("SC7") + _aC7_NUM[_nAux1]
					_nTotLib += SC7->(C7_TOTAL + C7_DESPESA + C7_FRETE - C7_VLDESC)
					SC7->(dbSkip())
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o grupo de aprovacao do comprador.                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SY1->(dbSeek(xFilial("SY1") + RetCodUsr(), .F.))
					_cGrpAprov := If(!empty(SY1->Y1_GRAPROV), SY1->Y1_GRAPROV, _cGrpAprov)
					_cGrpCompr := SY1->Y1_GRUPCOM
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para alterar o grupo de aprovacao.          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ExistBlock("MT120APV")
					_cGrpAprov := SY1->(ExecBlock("MT120APV",.F.,.F.))
				EndIf
				
				MaAlcDoc({_aC7_NUM[_nAux1], "PC", _nTotLib,,, SC7->C7_APROV,, SC7->C7_MOEDA, SC7->C7_TXMOEDA, SC7->C7_EMISSAO}, SC7->C7_EMISSAO, 3)
				lFirstNiv := MaAlcDoc({_aC7_NUM[_nAux1], "PC", _nTotLib,,, _cGrpCompr,, SC7->C7_MOEDA, SC7->C7_TXMOEDA, SC7->C7_EMISSAO},, 1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua a gravacao do campo de controle de aprovacao C7_CONAPRO  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SC7->(dbSeek(xFilial("SC7") + _aC7_NUM[_nAux1]))
				Do While SC7->(C7_FILIAL + C7_NUM) == xFilial("SC7") + _aC7_NUM[_nAux1]
					RecLock("SC7", .F.)
					SC7->C7_GRUPCOM := _cGrpCompr
					SC7->C7_APROV   := _cGrpAprov
					SC7->C7_CONAPRO := IIf(lFirstNiv, "L", "B")
					SC7->(msUnLock())
					SC7->(dbSkip())
				EndDo
			Next _nAux1
			/**/
			
			End Transaction
		Endif  // Deseja fechar cotacao?
		
	Case _nOpc == 5  // Exclui.
		// Testa se a cotacao nao foi encerrada.
		If empty(SC8->C8_NUMPED)
			_cMsg := "Deseja excluir a cotacao inteira?"
			If MsgYesNo(_cMsg, "Atenção")
				_cMsg := "Isso irá excluir todos os ítens em aberto da cotacao?" + _PL +;
				"Deseja confirma?"
				If MsgYesNo(_cMsg, "Excluir cotação " + SC8->C8_NUM)
					_aAux1 := {}
					_cAux1 := SC8->(C8_FILIAL+C8_NUM)
					_cAux2 := SC8->C8_NUM
					// Varre todos os itens da cotacao e armazena quais serao excluidos.
					SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
					Do While SC8->(C8_FILIAL+C8_NUM) == _cAux1
						If empty(C8_NUMPED)  // Se a cotacao nao estiver fechada, excluir.
							aAdd(_aAux1, SC8->(RecNo()))
						Endif
						SC8->(dbSkip())
					EndDo
					//
					// Exclui os itens da cotacao e marca SC como aberta.
					SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
					For _nAux1 := 1 to len(_aAux1)
						// Exclui o item da cotacao.
						SC8->(dbGoto(_aAux1[_nAux1]))
						_cAux3 := SC8->(C8_PRODUTO + C8_IDENT)
						RecLock("SC8", .F.)
						SC8->(dbDelete())
						SC8->(msUnLock())
						// Marca SC como aberta.
						If SC1->(dbSeek(xFilial("SC1") + _cAux2 + _cAux3, .F.))
							RecLock("SC1", .F.)
							SC1->C1_COTACAO := ""
							SC1->C1_QUJE 	:= 0 //alterado dia 19/02/2013. Analista Emerson Natali. Ao excluir a Cotacao nao estava deixando a Solicitacao em aberta para o usuario Excluir. Faltava este campo.
							SC1->(msUnLock())
						Endif
					Next _nAux1
					//
				Endif
				
			Else
				// Exclui somente o item, caso o usuario confirme a operacao.
				SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Atualiza campos.
				_cCotacao1 := SC8->C8_NUM
				_cFornCod1 := SC8->C8_FORNECE
                _cPgtoCod1 := SC8->C8_COND				
				_cFornLoj1 := SC8->C8_LOJA
				_cItem1    := SC8->C8_ITEM
				_cFornNom1 := SA2->A2_NREDUZ
				_nPrazo1   := SC8->C8_PRAZO
				aVetor1    := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
				_nQTDE1    := SC8->C8_QUANT
				_nPRECO1   := SC8->C8_PRECO
				_nDESC1    := SC8->C8_DESC
				_nVLDESC1  := SC8->C8_VLDESC
				_nIPI1     := SC8->C8_ALIIPI
				_nISS1     := SC8->C8_PICM
				_nFRETE1   := SC8->C8_VALFRE
				_nDESP1    := SC8->C8_DESPESA
				_nACERTO1  := SC8->C8_ACERTO
				_nTotal1   := SC8->C8_TOTAL
				_cNumPed1  := SC8->C8_NUMPED
				Show1Form(_nOpc)
			Endif
		Else
			_cMsg := "A cotação " + SC8->C8_NUM + " já está encerrada!"
			MsgInfo(_cMsg, "Atenção")
		Endif
		
	Case _nOpc == 6  // Legenda.
		Legenda()
EndCase

// Restaura as condicoes anteriores das tabelas.
SA2->(RestArea(_aAreaA2))
SB1->(RestArea(_aAreaB1))
SC1->(RestArea(_aAreaC1))
SC7->(RestArea(_aAreaC7))
SC8->(RestArea(_aAreaC8))
SE2->(RestArea(_aAreaE2))
SY1->(RestArea(_aAreaY1))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuCpos   ºAutor  ³ Felipe Raposo      º Data ³  18/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCpos(_cForm, _cOpc)
Local _nTotItem, _lRet, _cMsg, _aArea, _nAux1, _nAux2
_cForm := AllTrim(str(_cForm))
_lRet  := .T.
Do Case
	Case _cOpc == "FORN"
		_aArea := SA2->(GetArea())
		If _cFornCod&(_cForm) != SA2->A2_COD
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SA2->(dbSeek(xFilial("SA2") + _cFornCod&(_cForm), .F.))
		Endif
        _cPgtoCod&(_cForm) := SA2->A2_COND
		_cFornLoj&(_cForm) := SA2->A2_LOJA
		oSayForn&(_cForm):cCaption := SA2->A2_NREDUZ
		oSayForn&(_cForm):Refresh()
		SA2->(RestArea(_aArea))
		
	Case _cOpc == "TOTAL"
		// Atualiza o campo "desconto".
		If _nDESC&(_cForm) != 0
			_nVLDESC&(_cForm) := (_nQTDE&(_cForm) * _nPRECO&(_cForm)) * (_nDESC&(_cForm) / 100)
		Endif
		
		// Atualiza o campo "total".
		/*_nTotItem := (_nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm))
		_nTotal&(_cForm) := _nTotItem + _nFRETE&(_cForm) + _nDESP&(_cForm) +;
		(_nTotItem * _nIPI&(_cForm) / 100) + _nACERTO&(_cForm)*/
		
		// Atualiza o campo "total".
		_nTotal&(_cForm) := (_nQTDE&(_cForm) * _nPRECO&(_cForm)) - _nVLDESC&(_cForm) + _nACERTO&(_cForm)
		_nTotal&(_cForm) *= 1 + (_nIPI&(_cForm) / 100)
		_nTotal&(_cForm) += _nFRETE&(_cForm) + _nDESP&(_cForm)
		
		// Atualiza cond. pagto.
		// AtuPgto()   // A desenvolver.
		oMainMenu:Refresh()
		
	Case _cOpc == "TOTAL-ATU"
		// Atualiza o campo acerto.
		/* _nTotItem := (_nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm))
		_nAux1 := _nTotItem + _nFRETE&(_cForm) + _nDESP&(_cForm) +;
		(_nTotItem * _nIPI&(_cForm) / 100)
		_nACERTO&(_cForm) := _nTotal&(_cForm) - _nAux1 */
		_nAux1 := _nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm)
		_nAux2 := _nTotal&(_cForm) - (_nDESP&(_cForm) + _nFRETE&(_cForm))
		_nACERTO&(_cForm) := (_nAux2 / (1 + (_nIPI&(_cForm) / 100))) - (_nAux1)
		oMainMenu:Refresh()
		
	Case _cOpc == "JUROS"
		// Nao foi implementado o campo juros ainda.
		
EndCase
Return _lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMA02   ºAutor  ³ Felipe Raposo      º Data ³  18/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcCot()
Local _cChave1, _cChave2, _cChaveAux, _cParc, _cMsg, _nTotPag, _aCondPag
Local _nAux1, _nAux2, _cAux1, _cAux2, _cAux3    


If _nPrvOpc == 5  // Exclui.
	// Armazerna os itens de pagto a serem excluidos.
	_cAux1    := SC8->C8_NUM
	_cAux2    := SC8->C8_PRODUTO
	_cAux3    := SC8->C8_IDENT
	_aCondPag := U_GetCondPag(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 2)
	SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
	
	Begin Transaction
	// Exclui a cotacao.
	RecLock("SC8", .F.)
	SC8->(dbDelete())
	SC8->(msUnLock())
	//
	
	// Varre excluindo todos os itens de pagto da cotacao.
	For _nAux1 := 1 to len(_aCondPag)
		SZ3->(dbSeek(xFilial("SZ3") + _aCondPag[_nAux1], .F.))
		RecLock("SZ3", .F.)
		SZ3->(dbDelete())
		SZ3->(msUnLock())
	Next _nAux1
	//
	
	// Se for o ultimo item da cotacao marcar SC como aberta.
	SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
	If !SC8->(dbSeek(xFilial("SC8") + _cAux1 + _cAux3 + _cAux2, .F.))
		SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
		SC1->(dbSeek(xFilial("SC1") + _cAux1 + _cAux2 + _cAux3, .T.))
		RecLock("SC1", .F.)
		SC1->C1_COTACAO := ""
		SC1->(msUnLock())
	Endif
	//
	End Transaction
Else
	// Acerta a opcao escolhida em caso de opcao analise.
	If _nPrvOpc == 3; _nFornOpc -= 1; Endif
	
	// Acerta os indices dos aliases.
	SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
	SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
	
	// Verifica as condicoes de pagto antes da gravacao.
	For _nAux1 := 1 to IIf(_nPrvOpc == 3, 3, 1)
		_cAux1 := AllTrim(str(_nAux1))
		If !empty(_cFornCod&(_cAux1))
			_nTotPag := 0
			For _nAux2 := 1 to len(aVetor&(_cAux1)) // len(aCols&(_cAux1))
				_cAux2 := StrTran(aVetor&(_cAux1)[_nAux2, 1], ".", "")
				_cAux2 := StrTran(_cAux2, ",", ".")
				_nTotPag += val(_cAux2)
			Next _nAux2
			// Se a diferenca for menor que um centavo, ignorar e permitir a confirmacao.
			If (_nTotPag - _nTotal&(_cAux1) >= 0.01)
				_cMsg := "Valor total para pagamento incorreto!" + _PL +;
				"Valor da solicitacao.......: " + Transform(_nTotal&(_cAux1), PesqPict('SZ3', 'Z3_VALOR')) + _PL +;
				"Valor total da cond. pagto.: " + Transform(_nTotPag, PesqPict('SZ3', 'Z3_VALOR')) + _PL + _PL +;
				"Favor verificar!"
				MsgBox(_cMsg, "Atenção - cotação " + AllTrim(str(_nAux1)))
				Return
			Endif
		Endif
	Next _nAux1
	
	// Grava a cotacao.
	Begin Transaction
	For _nAux1 := 1 to IIf(_nPrvOpc == 3, 3, 1)
		_cAux1 := AllTrim(str(_nAux1))
		// Verifica se a planilha esta ativa antes de gravar os dados.
		If !empty(_cFornCod&(_cAux1))
			
			Do Case
				Case _nPrvOpc == 3  // Analisar.
					SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
					SC8->(dbSeek(xFilial("SC8") + _aCotProd[_nAux1, 1], .F.))
					// Armazena a sol. de compras para aglutinacao no momento da escolha.
					_cNumSC := SC8->C8_NUMSC
					RecLock("SC8", .F.)
					
				Case _nPrvOpc == 2  // Alterar.
					RecLock("SC8", .F.)
					
				Case _nPrvOpc == 1  // Incluir.
					
					// Busca o numero da proxima proposta.
					_cNumPro1 := "01"
					SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
					SC8->(dbSeek(xFilial("SC8") + _cCotacao1 + _cIdent1, .F.))
					Do While SC8->(C8_FILIAL + C8_NUM + C8_IDENT) == xFilial("SC8") + _cCotacao1 + _cIdent1
						If SC8->(C8_FORNECE + C8_LOJA) == _cFornCod1 + _cFornLoj1
							_cNumPro1 := IIf(_cNumPro1 > SC8->C8_NUMPRO, _cNumPro1, Soma1(SC8->C8_NUMPRO))
						Endif
						SC8->(dbSkip())
					EndDo
					
					SB1->(dbSeek(xFilial("SB1") + _cProdCot, .F.))
					RecLock("SC8", .T.)
					SC8->C8_FILIAL  := xFilial("SC8")
					SC8->C8_FILENT  := xFilial("SC8")
					SC8->C8_NUM     := _cCotacao1
					SC8->C8_ITEM    := _cItem1  // StrZero(_nAux2 + 1, len(SC8->C8_ITEM))
					SC8->C8_PRODUTO := _cProdCot
					SC8->C8_NUMPRO  := _cNumPro1
					SC8->C8_NUMSC   := _cNumSC1
					SC8->C8_ITEMSC  := _cItemSC1
					SC8->C8_IDENT   := _cIdent1  // StrZero(val(_cItemSC1), len(SC8->C8_IDENT))
					SC8->C8_TES     := SB1->B1_TE
					SC8->C8_UM      := SB1->B1_UM
					SC8->C8_SEGUM   := SB1->B1_SEGUM
					SC8->C8_QTSEGUM := _nQTDE1 * ;
					IIf(SB1->B1_TIPCONV == "M", SC8->C8_QTSEGUM, 1 / SC8->C8_QTSEGUM)
					SC8->C8_EMISSAO := dDataBase
					SC8->C8_TPFRETE := "C"
					SC8->C8_MOEDA   := 1
					//SC8->C8_VALIDA  := dDataBase
					//SC8->C8_DATPRF  := dDataBase
					
				OtherWise
					_cMsg := IIf(Type('_nPrvOpc') == "N",;
					"_nPrvOpc: " + AllTrim(str(_nPrvOpc)) + " inválido!",;
					"Type('_nPrvOpc'): " + Type('_nPrvOpc') + " inválido!") + _PL +;
					"Informe o erro a um administrador do sistema"
					MsgAlert(_cMsg, "Erro de processamento!!!")
					Return //Exit
			EndCase
			SC8->C8_FORNECE := _cFornCod&(_cAux1)
			SC8->C8_COND    := _cPgtoCod&(_cAux1)                 
			SC8->C8_LOJA    := _cFornLoj&(_cAux1)
			SC8->C8_PRAZO   := _nPrazo&(_cAux1)
			SC8->C8_QUANT   := _nQTDE&(_cAux1)
			SC8->C8_PRECO   := _nPRECO&(_cAux1)
			SC8->C8_ACERTO  := _nACERTO&(_cAux1)
			SC8->C8_TOTAL   := _nTotal&(_cAux1)
			SC8->C8_DESC    := _nDESC&(_cAux1)     // DESCONTO (%).
			SC8->C8_VLDESC  := _nVLDESC&(_cAux1)   // DESCONTO ($).
			SC8->C8_BASEIPI := _nTotal&(_cAux1) - _nFRETE&(_cAux1) - _nDESP&(_cAux1)  // _nPRECO&(_cAux1) * _nQTDE&(_cAux1) - _nVLDESC&(_cAux1).
			SC8->C8_ALIIPI  := _nIPI&(_cAux1)
			SC8->C8_VALIPI  := (_nPRECO&(_cAux1) * _nQTDE&(_cAux1) - _nVLDESC&(_cAux1)) * _nIPI&(_cAux1) / 100
			SC8->C8_PICM    := _nISS&(_cAux1)
			SC8->C8_VALFRE  := _nFRETE&(_cAux1)
			SC8->C8_DESPESA := _nDESP&(_cAux1)
			// SC8->C8_COND    := "999"  // Cond. Pagto. especifica CIEE.
			SC8->(msUnLock())
			
			// Grava a condicao de pagamento.
			_cChaveAux := xFilial("SZ3") + _cCotacao&(_cAux1) + _cProdCot +;
			_cFornCod&(_cAux1) + _cFornLoj&(_cAux1) + _cItem&(_cAux1)
			// Varre toda a aCols (todos os registros).
			For _nAux2 := 1 to len(aCols&(_cAux1))
				
				// Verifica se a linha esta marcada como apagada.
				_lLinDel := aCols&(_cAux1)[_nAux2, len(aHeader) + 1]
				
				// Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA
				// _aItens := {"Z3_PARCELA", "Z3_DATA", "Z3_PERCENT", "Z3_VALOR"}
				_cParc := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PARCELA"})]
				_cChave := _cChaveAux + _cParc
				
				If SZ3->(dbSeek(_cChave))
					RecLock("SZ3", .F.)  // Abre registro para edicao.
					If _lLinDel; SZ3->(dbDelete()); Endif
				ElseIf !_lLinDel
					RecLock("SZ3", .T.)  // Cria novo registro.
					SZ3->Z3_FILIAL  := xFilial("SZ3")
					SZ3->Z3_NUMCOT  := _cCotacao&(_cAux1)
					SZ3->Z3_PRODUTO := _cProdCot
					SZ3->Z3_FORNECE := _cFornCod&(_cAux1)
					SZ3->Z3_LOJA    := _cFornLoj&(_cAux1)
					SZ3->Z3_ITEM    := _cItem&(_cAux1)
					SZ3->Z3_PARCELA := _cParc
				Endif
				// Se a linha nao estiver apagada, incluir na tabela.
				If !_lLinDel
					SZ3->Z3_DIAS    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DIAS"})]
					SZ3->Z3_TIPO    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})]
					SZ3->Z3_DATA    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]
					SZ3->Z3_PERCENT := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PERCENT"})]
					SZ3->Z3_VALOR   := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]
				Endif
				SZ3->(msUnLock())
			Next _nAux2
		Endif
	Next _nAux1
	
	// Atualiza o status da cotacao e alguns outros campos.
	// 1 - Cotacao escolhida.
	// 2 - Cotacao nao escolhida.
	If _nPrvOpc == 3  // Analisar.
		_cAux2 := AllTrim(str(_nFornOpc))
		_cCotAux  := SC8->(C8_FILIAL+C8_NUM+C8_PRODUTO)
		SC8->(dbSetOrder(3))  // C8_FILIAL+C8_NUM+C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED+C8_ITEMPED.
		SC8->(dbGoTop()); SC8->(dbSeek(_cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
		// Enquanto for a cotacao do mesmo produto.
		Do While SC8->(C8_FILIAL+C8_NUM+C8_PRODUTO) == _cCotAux
			// Escolhe a cotacao aglutinando por sol. de compras.
			If SC8->C8_NUMSC == _cNumSC
				RecLock("SC8", .F.)                  
				If _nFornOpc = 0 // Em Aberto
				  SC8->C8_COTSTS := "2"
				EndIf
				If _nFornOpc > 0 // Escolheu um Fornecedor                                            
				  If SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT) == _aCotProd[_nFornOpc, 3]
				     SC8->C8_COTSTS := "1"
				  Else 
			         If SC8->C8_COTSTS <> "1"
				        SC8->C8_COTSTS := "2"
				     EndIf
                  EndIf
				EndIf
			  
/*
				SC8->C8_COTSTS := IIf ((_nFornOpc > 0 .and.;
				SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT) == _aCotProd[_nFornOpc, 3]),;
				"1", "2")
*/				
				SC8->C8_OBSMEMO := _mObs
				SC8->(msUnLock())
			Endif
			SC8->(dbSkip())
		EndDo
	Endif
	End Transaction
Endif        
oMainMenu:end()  // Fecha a tela.
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Legenda   ºAutor  ³ Felipe Raposo      º Data ³  18/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Legenda(_uPar)
Local _uRet, _aFlag

_aLeg := {;
{"BR_AMARELO",  "Cotação em aberto (não cotada)."},;
{"BR_VERDE",    "Cotação em análise."},;
{"BR_AZUL",     "Cotação escolhida."},;
{"BR_VERMELHO", "Cotação encerrada."}}

If ValType(_uPar) != "U" .and. _uPar == 0
	_aFlag := {;
	{'!empty(C8_NUMPED)',                        _aLeg[4][1]},;  // Vermelho.
	{' empty(C8_NUMPED) .and. C8_COTSTS == "1"', _aLeg[3][1]},;  // Azul
	{' empty(C8_NUMPED) .and. C8_TOTAL == 0',    _aLeg[1][1]},;  // Amarelo.
	{' empty(C8_NUMPED) .and. C8_TOTAL != 0',    _aLeg[2][1]}}   // Verde
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCondPagºAutor  ³ Felipe Raposo      º Data ³  23/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetCondPag(_cCotacao, _nTipo)
Local _aRet, _aAux1, _aEmpty, _aAreaZ3
_aRet := _aAux1 := _aEmpty := {}
_aAreaZ3 := SZ3->(GetArea())
SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
SZ3->(dbSeek(xFilial("SZ3") + _cCotacao, .F.))

Do While xFilial("SZ3") + _cCotacao == SZ3->(Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM)
	Do Case
		Case _nTipo == 1
			_aAux1  := {Trim(Transform(SZ3->Z3_VALOR, PesqPict('SZ3', 'Z3_VALOR'))),;
			SZ3->Z3_DATA,;
			SZ3->(Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA)}
		Case _nTipo == 2
			_aAux1  := SZ3->(Z3_NUMCOT + Z3_PRODUTO + Z3_FORNECE + Z3_LOJA + Z3_ITEM + Z3_PARCELA)
	EndCase
	aAdd(_aRet, _aAux1)
	SZ3->(dbSkip())
EndDo

// Valor a ser retornado caso nao exista cond. de pagamento para essa cotacao.
_aEmpty := IIf(_nTipo == 1, {{Trim(Transform(0, PesqPict('SZ3', 'Z3_VALOR'))), ctod("")}}, {})
_aRet := IIf(empty(_aRet), _aEmpty, _aRet)

SZ3->(RestArea(_aAreaZ3))
Return (_aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMA02b  ºAutor  ³Microsiga           º Data ³  30/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ccoma02b(_nDias)
Local _nLin, _nLinTam, _oDlg2, _dPagto, _nOpcAux
_dPagto := ctod("")
_nLin := 06; _nLinTam := 17
@ 000, 000 to 140, 200 Dialog _oDlg2 Title "Tipo de pagamento"
@ _nLin, 012 Say "Data de pagamento a partir do"; _nLin += 12
@ _nLin, 012 Button "_Nota Fiscal (entrada)" size 75, 15 action (_nOpcAux := 2, _oDlg2:end()); _nLin += _nLinTam
@ _nLin, 012 Button "_Pedido"                size 75, 15 action (_nOpcAux := 1, _oDlg2:end()); _nLin += _nLinTam
@ _nLin, 012 Button "_Data Especícifa"       size 75, 15 action (_nOpcAux := 3, _oDlg2:end()); _nLin += _nLinTam
Activate dialog _oDlg2 Centered
Do Case
	Case _nOpcAux == 1  // A partir do pedido.
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "P"
		_dPagto := DataValida(dDataBase + _nDias)
		
	Case _nOpcAux == 2  // A partir da NF.
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "N"
		
	Case _nOpcAux == 3  // Data especifica
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "D"
EndCase
Return(_dPagto)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMA02c  ºAutor  ³Microsiga           º Data ³  18/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ccoma02c(_cNumSC, _cUser)
Local _aAreaC1, _lRet
_aAreaC1 := SC1->(GetArea())

// Confere se a solicitacao de compra eh do
// usuario passado por parametro.
SC1->(dbSetOrder(1))  // C1_FILIAL+C1_NUM+C1_ITEM.
SC1->(dbSeek(xFilial("SC1") + _cNumSC, .F.))
_lRet := upper(AllTrim(SC1->C1_SOLICIT)) == upper(AllTrim(_cUser))

SC1->(RestArea(_aAreaC1))
Return(_lRet)


User Function ccoma02d(_cNumSC, _cUser)
Local _aAreaC1, _lRet, _cRet
_aAreaC1 := SC1->(GetArea())

// Confere se a solicitacao de compra eh do
// usuario passado por parametro.
SC1->(dbSetOrder(1))  // C1_FILIAL+C1_NUM+C1_ITEM.
SC1->(dbSeek(xFilial("SC1") + _cNumSC, .F.))
_lRet := upper(AllTrim(SC1->C1_SOLICIT)) == upper(AllTrim(_cUser))

//ALLTRIM(Posicione("SC1",1,xFilial("SC1"+SC8->C8_NUMSC,"C1_SOLICIT"))) == ALLTRIM(_cUser)

//If _lRet
//	_cRet	:= "SC8->C8_NUMSC == " + _cNumSC
//Else
//	_cRet	:= ""
//EndIf


SC1->(RestArea(_aAreaC1))
Return(_cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcIMP  ºAutor   ³ROBERTO R.MEZZALIRA º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO QUE IMPRIME O CONTEUDO DA TELA DE COTACAO EM UM     º±±
±±º          ³ RELATORIO PELO CRYSTAL REPORTS                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcIMP()

Local cParams		:= ""
Local cOpcoes		:= "1;0;2;Solicitacao de Compras"

DBSelectArea("SZI")
// Grava a cotacao para impressao
	DBSelectArea("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB1")+_cProdCot)
	_cDESCPRO    := SB1->B1_DESC
    DBSelectArea("SZI")	
   	DBSETORDER(1)
	If !empty(_cFornCod1)
		RecLock("SZI",.T.)
	    SZI->ZI_FILIAL     := XFILIAL("SZI")
		SZI->ZI_PRODUTO    := _cProdCot
		SZI->ZI_DESCPRO    := _cDESCPRO 
		SZI->ZI_NUMSC      := _cCotacao1
        SZI->ZI_OBS        := _mObs 
	    SZI->ZI_EMISSAO    := _dEmissao               
        // INDICA A COLUNA DO VENCEDOR 
   	    DO CASE
   	      CASE _cCotSts1 == "1"
   	           SZI->ZI_VENCEDO := "1"
		  CASE _cCotSts2 == "1"
   	           SZI->ZI_VENCEDO := "2"
		  CASE _cCotSts3 == "1"
   	           SZI->ZI_VENCEDO := "3"
		ENDCASE
		SZI->ZI_CODFOR1    := _cFornCod1
        SZI->ZI_NOMFOR     := _cFornNom1 
		SZI->ZI_PRAZO      := _nPrazo1
		SZI->ZI_QTD        := _nQTDE1
		SZI->ZI_PRECO      := _nPRECO1
		SZI->ZI_TOTAL      := _nTotal1
		SZI->ZI_DESCONT    := _nDESC1     // DESCONTO (%).
		SZI->ZI_VLDESC     := _nVLDESC1   // DESCONTO ($).
		SZI->ZI_VALIPI     := (_nPRECO1 * _nQTDE1 - _nVLDESC1) * _nIPI1 / 100
		SZI->ZI_PICM       := _nISS1
        SZI->ZI_COND 	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod1,"E4_DESCRI")
       	
       	SZI->ZI_CODFOR2    := _cFornCod2
        SZI->ZI_NOMFOR2    := _cFornNom2 
		SZI->ZI_PRAZO2     := _nPrazo2
		SZI->ZI_QTD2       := _nQTDE2
		SZI->ZI_PRECO2     := _nPRECO2
		SZI->ZI_TOTAL2     := _nTotal2
		SZI->ZI_DESCON2    := _nDESC2     // DESCONTO (%).
		SZI->ZI_VLDESC2    := _nVLDESC2   // DESCONTO ($).
		SZI->ZI_VALIPI2    := (_nPRECO2 * _nQTDE2 - _nVLDESC2) * _nIPI2 / 100
		SZI->ZI_PICM2      := _nISS2    
        SZI->ZI_COND2	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod2,"E4_DESCRI")
       
       	SZI->ZI_CODFOR3    := _cFornCod3
        SZI->ZI_NOMFOR3    := _cFornNom3 
		SZI->ZI_PRAZO3     := _nPrazo3
		SZI->ZI_QTD3       := _nQTDE3
		SZI->ZI_PRECO3     := _nPRECO3
		SZI->ZI_TOTAL3     := _nTotal3
		SZI->ZI_DESCON3    := _nDESC3     // DESCONTO (%).
		SZI->ZI_VLDESC3    := _nVLDESC3   // DESCONTO ($).
		SZI->ZI_VALIPI3    := (_nPRECO3 * _nQTDE3 - _nVLDESC3) * _nIPI3 / 100
		SZI->ZI_PICM3      := _nISS3
        SZI->ZI_COND3	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod3,"E4_DESCRI")

		SZI->(msUnLock())
  ENDIF
_COBS   := IIF(EMPTY(_mObs),SPACE(10),substr(ALLTRIM(_mObs),1,250) )
cParams :=_cCotacao1 + ";" + _COBS + ";" //+";"+mv_par04               

If cEmpant == '01'
	CALLCRYS("CRYSOL", cParams, cOpcoes)
Else
	CALLCRYS("CRYSOL_RJ", cParams, cOpcoes)
EndIf

RETURN