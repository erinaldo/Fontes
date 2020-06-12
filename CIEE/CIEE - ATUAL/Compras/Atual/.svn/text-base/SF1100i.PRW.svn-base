#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Felipe Raposo       º Data ³  06/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos a gravacao do SF1 no MATA103 (Docu-  º±±
±±º          ³ mento de Entrada).                                         º±±
±±º          ³ Ele atualiza alguns campos da aba Compras e Ultima Compra  º±±
±±º          ³ do cadastro de fornecedores.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()

Local _nAux1, _aAreaX3
Private _cFiltro

// Armazena as condicoes do SX3
_aAreaX3 := SX3->(GetArea())

// Matriz contendo os campos especificos CIEE.
_aCpos := {"A2_DATAUC", "A2_VALORUC", "A2_DESCUC", "A2_ATRASUC",;  // Campos da aba "Ultima Compra".
"A2_MCOMP", "A2_MDESC", "A2_MATRASO", "A2_COTVEN1", "A2_COTVEN2"}   // Campos da aba "Compras".

// Verifica a existencia dos campos especificos antes de executar a rotina.
_cFiltro := "SX3->("
For _nAux1 := 1 to len(_aCpos)
	_cFiltro += "dbSeek('" + _aCpos[_nAux1] + "')" + IIf (_nAux1 < len(_aCpos), " .and. ", ")")
Next _nAux1
SX3->(dbSetOrder(2))  // X3_CAMPO.
If &(_cFiltro)
	AtuSA2()
Endif

//_cNF := SF1->(F1_DOC + F1_SERIE)
_cNF := SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
DbSelectArea("SD1")
dbSetOrder(1)
dbSeek(xFilial("SD1")+_cNF, .F.)

DbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+SD1->D1_TES, .F.)
_cGeraDup	:= SF4->F4_DUPLIC

_aAreaX 	:= GetArea()

if _cGeraDup == "S"
	AtuSE2()
EndIf   

U_FA050BCO()

RestArea(_aAreaX)

// Restaura as condicoes do SX3.
SX3->(RestArea(_aAreaX3))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSA2    ºAutor  ³ Felipe Raposo      º Data ³  01/22/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que atualiza os campos do cadastro de fornecedores. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSA2()
Local _aAreaF1, _aAreaD1, _aAreaC7, _aAreaA2, _cMsg, _cTit, _cSep, _nAux1, _nAux2
Local _cNF, _cForn, _nTotal1, _nTotal2

_cSep := " - "

// Armazena as condicoes das tabelas antes do processamento.
_aAreaF1 := SF1->(GetArea())
_aAreaD1 := SD1->(GetArea())
_aAreaC7 := SC7->(GetArea())
_aAreaA2 := SA2->(GetArea())

_cNF := SF1->(F1_DOC + F1_SERIE)
SA2->(dbSetOrder(1))  // A2_FILIAL + A2_COD + A2_LOJA.
SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN.

_cForn := SF1->(F1_FORNECE + F1_LOJA)
If SA2->(dbSeek(xFilial("SA2") + _cForn, .F.))
	
	RecLock("SA2", .F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os campos da aba "Adm./Fin."        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA2->A2_VRACUMR += SF1->F1_VALBRUT
	SA2->A2_VRACUMD += xMoeda(SF1->F1_VALBRUT, 1, 2, SF1->F1_DTDIGIT, TamSX3("F1_VALBRUT")[2])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os campos da aba "Ultima Compra"    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA2->A2_DATAUC  := SF1->F1_DTDIGIT
	SA2->A2_VALORUC := SF1->F1_VALBRUT                             
	SD1->(dbSetOrder(1)); SD1->(dbSeek(xFilial("SD1") + _cNF, .F.))
	SA2->A2_DESCUC  := Transform(SF1->(F1_DESCONT / (F1_DESCONT+F1_VALBRUT)) * 100, "@E 99.99") + "%" +;
	_cSep + "$" + AllTrim(Transform(SF1->F1_DESCONT, "@E 999,999,999.99"))+" PC"+SD1->D1_PEDIDO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os campos da aba "Compras"          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Campo de maior compra.
	_nAux1 := SA2->A2_MCOMP
	_nAux1 := SubStr(_nAux1, at("-", _nAux1) + 2, 15)
	_nAux1 := StrTran(_nAux1, "$", "")
	_nAux1 := StrTran(_nAux1, ".", "")
	_nAux1 := StrTran(_nAux1, ",", ".")
	_nAux1 := val(_nAux1)
	If SF1->F1_VALBRUT >= _nAux1
		SA2->A2_MCOMP := dtoc(SF1->F1_DTDIGIT) + _cSep + "$" + AllTrim(Transform(SF1->F1_VALBRUT, "@E 999,999,999.99"))
	Endif
	
	// Campos de maior desconto.
	_nAux1 := SA2->A2_MDESC
	_nAux1 := SubStr(_nAux1, at("-", _nAux1) + 2, 06)
	_nAux1 := StrTran(_nAux1, "%", "")
	_nAux1 := StrTran(_nAux1, ",", ".")
	_nAux1 := val(_nAux1)
	_nAux2 := SF1->(F1_DESCONT / F1_VALBRUT) * 100
	If _nAux2 >= _nAux1
		SA2->A2_MDESC := dtoc(SF1->F1_DTDIGIT) + _cSep + Transform(_nAux2, "@E 99.99") + "%" +;
		_cSep + "$" + AllTrim(Transform(SF1->F1_DESCONT, "@E 999,999,999.99"))
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa todos os itens da nota.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM.
	SD1->(dbSetOrder(1)); SD1->(dbSeek(xFilial("SD1") + _cNF, .F.))
	Do While (xFilial("SD1") + _cNF == SD1->(D1_FILIAL + D1_DOC + D1_SERIE))
		If !empty(SD1->D1_PEDIDO)
			SC7->(dbSeek(xFilial("SC7") + SD1->(D1_PEDIDO + D1_ITEMPC), .F.))
			
			// Calcula o atraso do item, se houver.
			_nAtraso := SD1->D1_DTDIGIT - SC7->C7_DATPRF; _nAtraso := IIf (_nAtraso < 0, 0, _nAtraso)
			
			// Atraso da ultima compra.
			SA2->A2_ATRASUC := _nAtraso
			
			// Maior atraso.
			_nAux1 := SA2->A2_MATRASO
			_nAux1 := SubStr(_nAux1, at("-", _nAux1) + 2, 8)
			_nAux1 := StrTran(StrTran(_nAux1, "DIAS", ""), "DIA", "")
			_nAux1 := val(_nAux1)
			If _nAtraso >= _nAux1
				SA2->A2_MATRASO := dtoc(SD1->D1_DTDIGIT) + _cSep +;
				Transform(_nAtraso, "@E 999") + IIf (_nAtraso == 1, " DIA", " DIAS")
			Endif
			
			// Numero de pedidos atendidos.
			/*
			If
			SA2->A2_NUMPED  += 1
			Endif
			*/
		Endif
		SD1->(dbSkip())
	EndDo
	SA2->(msUnLock())
Else
	_cMsg := "Fornecedor '" + _cForn + "' não encontrado!!!"
	_cTit := "Atenção: " + SF1->(F1_SERIE + F1_DOC)
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi(_cTit))
Endif

// Restaura as condicoes anteriores das tabelas.
SF1->(RestArea(_aAreaF1))
SD1->(RestArea(_aAreaD1))
SC7->(RestArea(_aAreaC7))
SA2->(RestArea(_aAreaA2))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSA2    ºAutor  ³ Felipe Raposo      º Data ³  01/22/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que atualiza os campos do cadastro de fornecedores. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuSE2()

	_cForn 		:= SF1->(F1_FORNECE + F1_LOJA)
	_cRazSoc	:= ""
     
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2")+_cForn,.f.)
		_cRazSoc := SA2->A2_NOME
	EndIf
	
	
	DbSelectArea("SE2")
    DbSetOrder(6)          
    lEncontrei := .f.
    If ! DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC+"A"+"NF ")
        If DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC+" "+"NF ")
           lEncontrei := .t.
        EndIf
    Else
        lEncontrei := .t.
    EndIf               
    
	If lEncontrei
        Do While !SE2->(Eof()) .And. SF1->F1_FORNECE == SE2->E2_FORNECE .And. SF1->F1_LOJA == SE2->E2_LOJA;
        					.And. SF1->F1_SERIE == SE2->E2_PREFIXO .And. SF1->F1_DOC == SE2->E2_NUM;
        					.And. Alltrim(SE2->E2_TIPO) == "NF"
		        RecLock("SE2",.f.)
		        E2_RAZSOC    := _cRazSoc
		        SE2->(MsUnLock())
		        SE2->(DbSkip())       		
       EndDo
	Else
       Help("",1,"NOPARIRF",,"Nao Encontrei a Parcela para",5,2)
	EndIf
  
Return