#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR008 º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de Fechamento - FIBA                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR008()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Contas de Consumo"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "*** FIBA ***"
Private nLin   := 70

Private Cabec1 := ""
Private Cabec2 := ""
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR08" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZD"
Private cPerg        := "FINR08    "
Private mvFicha
Private _aAliases    := {}
Private _aEstrut     := {}
Private _aTitulos    := {}

aAdd(_aTitulos,"Bolsa Auxilio")
aAdd(_aTitulos,"Contribuicao Institucional")
aAdd(_aTitulos,"Diferenças")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Ficha de Lancamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}

AADD(_aPerg,{cPerg,"01","Data de            ?","","","mv_ch1","D",08,0,0,"G","","mv_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Data ate           ?","","","mv_ch2","D",08,0,0,"G","","mv_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Tipo Relatorio     ?","","","mv_ch3","N",01,0,0,"C","","mv_PAR03","Analitico","","","","","Sintetico","","","","","Ambos","","","","","","","","","","","","","","","",""})

AADD(_aPerg,{cPerg,"04","Modelo Relatorio   ?","","","mv_ch4","N",01,0,0,"C","","mv_PAR04","Fiba RDR" ,"","","","","Fiba FLUXO","","","","",""     ,"","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

dbSelectArea("SZD")
DbSetOrder(1)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo  := If(aReturn[4]==1,15,18)

Do Case
	Case cEmpant == '01'
		If mv_par01 == mv_par02
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / SP - "+dtoc(mv_par01)
		Else
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / SP - "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
		EndIf
	Case cEmpant == '03'
		If mv_par01 == mv_par02
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / RJ - "+dtoc(mv_par01)
		Else
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / RJ - "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
		EndIf
	Case cEmpant == '05'
		If mv_par01 == mv_par02
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / NACIONAL - "+dtoc(mv_par01)
		Else
			titulo := "Fechamento do Recebimento de Contribuicoes CIEE / NACIONAL - "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
		EndIf
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| Fiba(Cabec1,Cabec2,Titulo,nLin) },Titulo)


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³   FIBA   º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fiba(Cabec1,Cabec2,Titulo,nLin)
_aAliases := {}

_aEstrut  := {}
// Define a estrutura do arquivo de trabalho.
_aEstrut := {;
{"ED_NATUREZ"  ,  "C", 10, 0},;
{"ED_DESCRI"   ,  "C", 50, 0},;
{"ED_EMISSAO"  ,  "D", 08, 0},;
{"E5_VALOR"    ,  "N", 14, 2},;
{"ZD_SIST"     ,  "C", 30, 0}}
// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMO", .F., .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arq. Auxiliar TMO                                      ³
//³ Este arquivo é para tratar outros lançamentos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IndRegua("TMO", _cArqTrab, "ED_NATUREZ",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMO", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})


_aEstrut  := {}

// Define a estrutura do arquivo de trabalho.
_aEstrut := {;
{"ZD_PAGINA"   ,  "C", 02, 0},;
{"ZD_LINHA"    ,  "C", 02, 0},;
{"ZD_COLUNA"   ,  "C", 02, 0},;
{"ZD_DESC"     ,  "C", 50, 0},;
{"ZD_TIPO"     ,  "C", 01, 0},;
{"ZD_SIST"     ,  "C", 30, 0},;
{"ZD_VALOR"    ,  "N", 14, 2},;
{"ZD_DIFERE"   ,  "N", 14, 2}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arq. Auxiliar TMP                                      ³
//³ Este arquivo é o arquivo principal                     ³
//³ Neste arquivo lançaremos as movimentações bancárias    ³
//³ geradas no processo de importação dos títulos do FCB,  ³
//³ SEC e SPBA, segundo o resultado do query na tabela SE5,³
//³ conforme os parêmetros do relatório.                   ³
//³ SEC e SPBA, segundo o resultado do query na tabela SE5,³
//³                                                        ³
//³ A primeira idéia é ter o TMP como clone do arquivo de  ³
//³ configuração do FIBA, a tabela SZD.                    ³
//³ Assim o TMP será impresso conforme as coordenadas      ³
//³                                                        ³
//³ Para preencher o TMP com valores do SE5,               ³
//³ seguimos a seguinte regra: vejo a natureza E5_NATUREZ  ³
//³ na tabela SED, verifico o campo ED_FECHA, lá existem   ³
//³ várias coordenadas PAGINA+LINHA+COLUNA onde o valor    ³
//³ deve ser preenchido no arquivo TMP                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


IndRegua("TMP", _cArqTrab, "ZD_PAGINA+ZD_LINHA+ZD_COLUNA",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

dbSelectArea("SZD")
dbSetOrder(1)
dbGoTop()
Do While xFilial("SZD")==SZD->ZD_FILIAL .And. !Eof()
	If SZD->ZD_MODELO == str(mv_par04,1) 	//Modelo A igual a 1; Modelos B igual a 2; Ambos igual a 3
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->ZD_PAGINA := SZD->ZD_PAGINA
		TMP->ZD_LINHA  := SZD->ZD_LINHA
		TMP->ZD_COLUNA := SZD->ZD_COLUNA
		TMP->ZD_DESC   := SZD->ZD_DESC
		TMP->ZD_TIPO   := SZD->ZD_TIPO
		TMP->ZD_SIST   := SZD->ZD_SIST
		TMP->ZD_VALOR  := 0
		TMP->ZD_DIFERE := 0
		msUnLock()
	Else
		If SZD->ZD_MODELO == "3" //Ambos
			dbSelectArea("TMP")
			RecLock("TMP", .T.)
			TMP->ZD_PAGINA := SZD->ZD_PAGINA
			TMP->ZD_LINHA  := SZD->ZD_LINHA
			TMP->ZD_COLUNA := SZD->ZD_COLUNA
			TMP->ZD_DESC   := SZD->ZD_DESC
			TMP->ZD_TIPO   := SZD->ZD_TIPO
			TMP->ZD_SIST   := SZD->ZD_SIST
			TMP->ZD_VALOR  := 0
			TMP->ZD_DIFERE := 0
			msUnLock()
		EndIf
	EndIf
	dbSelectArea("SZD")
	dbSkip()
EndDo

// 		If TMP->(dbSeek(ED_PAGINA+ED_LINHA+ED_COLUNA, .F.))

_xFilSE5:=xFilial("SE5")

_cOrdem := " E5_FILIAL+E5_NUMERO"
_cQuery := " SELECT E5_FILIAL, E5_DTDISPO, E5_TIPO, E5_TIPODOC, E5_VALOR, E5_NATUREZ, E5_PREFIXO, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_RECPAG, E5_VLJUROS"
_cQuery += " FROM "
_cQuery += RetSqlName("SE5")+" SE5,"
_cQuery += " WHERE '"+ _xFilSE5 +"' = E5_FILIAL"
_cQuery += " AND    E5_RECPAG  = 'R'"
_cQuery += " AND    E5_PREFIXO IN ('SEC','FCB', 'SBA') "
_cQuery += " AND    E5_DTDISPO    >= '"+DTOS(mv_par01)+"'"
_cQuery += " AND    E5_DTDISPO    <= '"+DTOS(mv_par02)+"'"

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SE5"},,,.T. )

dbSelectArea("QUERY")
dbGoTop()

Do While !Eof()
	
	dbSelectArea("SED")
	dbsetOrder(1)
	// Fluxo 2013
	If dbSeek(xFilial("SED") + QUERY->E5_NATUREZ , .F.) .And. !Empty(SED->ED_FECHA)
		_nPos:=1
		
		While .T.
			If mv_par04 == 1
				_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
			Else
				_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
			EndIf
			If _cChave == space(6) .Or. Val(_cChave) == 0
				Exit
			Else
				If TMP->(dbSeek(_cChave, .F.))
					If QUERY->E5_PREFIXO $ TMP->ZD_SIST
						If mv_par04 == 1
							_cChave2:= (TMP->ZD_TIPO == "O" .Or. "999999" $ SED->ED_FECHA) // Tipo Outros
						Else
							_cChave2:= (TMP->ZD_TIPO == "O" .Or. "999999" $ SED->ED_FECHA_B) // Tipo Outros
						EndIf
						If _cChave2
							RecLock("TMO", .T.)
							TMO->ED_NATUREZ  := SED->ED_CODIGO
							TMO->ED_DESCRI   := SED->ED_DESCRIC
							TMO->E5_VALOR    := QUERY->E5_VALOR-QUERY->E5_VLJUROS
							TMO->ED_EMISSAO  := QUERY->E5_DTDISPO
							TMO->ZD_SIST     := QUERY->E5_PREFIXO //TMP->ZD_SIST
							msUnLock()
							Exit
						Else
							If QUERY->E5_TIPODOC=="DC" .And. TMP->ZD_TIPO == "G"
								RecLock("TMP", .F.)
								//							      ZD_VALOR := ZD_VALOR  +  QUERY->E5_VALOR-QUERY->E5_VLJUROS
								ZD_DIFERE:= ZD_DIFERE - (QUERY->E5_VALOR-QUERY->E5_VLJUROS)
								msUnLock()
							Else
								RecLock("TMP", .F.)
								ZD_VALOR := ZD_VALOR  + QUERY->E5_VALOR-QUERY->E5_VLJUROS
								msUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			_nPos:=_nPos+7
		EndDo
		
	Else // Verifica Natureza Antiga em SED->ED_SUPORC

        _cChave := AllTrim(U_DePaNAT2013(QUERY->E5_NATUREZ))

		dbSelectArea("SED")
		dbsetOrder(1)
		
		If dbSeek(xFilial("SED") + _cChave  , .F.) .And. !Empty(SED->ED_FECHA)
			_nPos:=1
			
			While .T.
				If mv_par04 == 1
					_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
				Else
					_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
				EndIf
				If _cChave == space(6) .Or. Val(_cChave) == 0
					Exit
				Else
					If TMP->(dbSeek(_cChave, .F.))
						If QUERY->E5_PREFIXO $ TMP->ZD_SIST
							If mv_par04 == 1
								_cChave2:= (TMP->ZD_TIPO == "O" .Or. "999999" $ SED->ED_FECHA) // Tipo Outros
							Else
								_cChave2:= (TMP->ZD_TIPO == "O" .Or. "999999" $ SED->ED_FECHA_B) // Tipo Outros
							EndIf
							If _cChave2
								RecLock("TMO", .T.)
								TMO->ED_NATUREZ  := SED->ED_CODIGO
								TMO->ED_DESCRI   := SED->ED_DESCRIC
								TMO->E5_VALOR    := QUERY->E5_VALOR-QUERY->E5_VLJUROS
								TMO->ED_EMISSAO  := QUERY->E5_DTDISPO
								TMO->ZD_SIST     := QUERY->E5_PREFIXO //TMP->ZD_SIST
								msUnLock()
								Exit
							Else
								If QUERY->E5_TIPODOC=="DC" .And. TMP->ZD_TIPO == "G"
									RecLock("TMP", .F.)
									//							      ZD_VALOR := ZD_VALOR  +  QUERY->E5_VALOR-QUERY->E5_VLJUROS
									ZD_DIFERE:= ZD_DIFERE - (QUERY->E5_VALOR-QUERY->E5_VLJUROS)
									msUnLock()
								Else
									RecLock("TMP", .F.)
									ZD_VALOR := ZD_VALOR  + QUERY->E5_VALOR-QUERY->E5_VLJUROS
									msUnLock()
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
				_nPos:=_nPos+7
			EndDo
		EndIf
		
	EndIf
	
	dbSelectArea("QUERY")
	dbSkip()
	
EndDo


U_IMP_SE5()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ImpTmp   ³ Autor ³    Andy               ³ Data ³08/05/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CIEE                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION IMP_SE5()

Private _nSldAnt
Private _nCredito
Private _nTotal

If mv_par03==1 .Or. mv_par03==3
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ imprimindo SE5                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Cabec1:=" Data       Natureza  Tipo  Prefixo Numero  Parcela           Valor"
	//    	      dddddddd   nnnnnnnnn tt    ppp     nnnnnn  p    vvvvvvvvvvvvvvvvvvv
	//          " 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//	01_DATA, 12_NATUREZ 22_TIPO 28_PREFIXO 36_NUMERO 44_PARCELA 49_VALOR
	
	dbSelectArea("QUERY")
	dbGoTop()
	While !EOF()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@ nLin, 01   PSay QUERY->E5_DTDISPO
		@ nLin, 12   PSay AllTrim(QUERY->E5_NATUREZ)
		@ nLin, 22   PSay QUERY->E5_TIPO
		@ nLin, 28   PSay QUERY->E5_PREFIXO
		
		@ nLin, 36   PSay QUERY->E5_NUMERO
		@ nLin, 44   PSay QUERY->E5_PARCELA
		@ nLin, 49   PSay QUERY->E5_VALOR-QUERY->E5_VLJUROS  Picture "@E 999,999,999,999.99"
		
		nLin:=nLin+1
		dbSelectArea("QUERY")
		dbSkip()
		
	EndDo
	
	nLin := 70
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculando Diferencas Recebimento Primeira Página                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

U_Calc_Dif("SBA")
U_Calc_Dif("SEC")
U_Calc_Dif("FCB")
U_Calc_Dif("DEB")
U_CALC_OUTRAS()

If mv_par03==2 .Or. mv_par03==3
	
	dbSelectArea("TMP")
	dbSetOrder(1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimindo Recebimento Primeira Página                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Cabec1:="Fechamento do Recebimento de Contribuicoes"
	
	While !EOF()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		_cPag := TMP->ZD_PAGINA
		
		While !EOF() .And. _cPag == TMP->ZD_PAGINA
			
			If TMP->ZD_TIPO <> "O"
				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 10
				Endif
				If TMP->ZD_TIPO == "T"
					If LEFT(TMP->ZD_DESC,1) == "_"
						@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)    PSay Replicate("_",132)
					Else
						@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)    PSay TMP->ZD_DESC
					EndIf
				Else
					@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)    PSay LEFT(TMP->ZD_DESC,40) //LEFT(TMP->ZD_DESC,30)
					If TMP->ZD_TIPO == "S" .Or. TMP->ZD_TIPO == "G"
						If mv_par04 = 2 //modelo B
							If "01"+TMP->ZD_LINHA+TMP->ZD_COLUNA == "017601" //linha especifica CREDITOS NAO IDENTIFICADOS
								_xcQuery := "SELECT SUM(Z8_VALOR) AS Z8_VALOR "
								_xcQuery += "FROM "+RetSqlName("SZ8")+" SZ8 "
								_xcQuery += "WHERE Z8_FILIAL = 'XX' "
								_xcQuery += "AND D_E_L_E_T_ <> '*' "
								_xcQuery += "AND Z8_EMISSAO = '20100630' "
								TcQuery _xcQuery New Alias "SZ8TMP1"
								
								_xcQuery := "SELECT SUM(Z8_VALOR) AS Z8_VALOR "
								_xcQuery += "FROM "+RetSqlName("SZ8")+" SZ8 "
								_xcQuery += "WHERE Z8_FILIAL = '01' "
								_xcQuery += "AND D_E_L_E_T_ <> '*' "
								_xcQuery += "AND Z8_EMISSAO BETWEEN '20100701' AND '"+DTOS((mv_par01-1))+"' "
								_xcQuery += "AND (SUBSTRING(Z8_RDR,1,2) <> 'AP') "
								TcQuery _xcQuery New Alias "SZ8TMP2"
								
								_xcQuery := "SELECT SUM(Z8_VALOR) AS Z8_VALOR "
								_xcQuery += "FROM "+RetSqlName("SZ8")+" SZ8 "
								_xcQuery += "WHERE Z8_FILIAL = '01' "
								_xcQuery += "AND D_E_L_E_T_ <> '*' "
								_xcQuery += "AND SZ8.Z8_FECRAT BETWEEN '20100701' AND '"+DTOS((mv_par01-1))+"' "
								TcQuery _xcQuery New Alias "SZ8TMP3"
								
								_nSldAnt	:= 0
								
								_nSldAnt	:= (SZ8TMP1->Z8_VALOR + SZ8TMP2->Z8_VALOR - SZ8TMP3->Z8_VALOR)
								
								@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay _nSldAnt  Picture "@E 999,999,999,999.99"
								DbSelectArea("SZ8TMP1")
								SZ8TMP1->(DbCloseArea())
								DbSelectArea("SZ8TMP2")
								SZ8TMP2->(DbCloseArea())
								DbSelectArea("SZ8TMP3")
								SZ8TMP3->(DbCloseArea())
								DbSelectArea("TMP")
							ElseIf "01"+TMP->ZD_LINHA+TMP->ZD_COLUNA == "017701" //linha especifica CREDITOS NAO IDENTIFICADOS
								_xcQuery := "SELECT SUM(Z8_VALOR) AS Z8_VALOR "
								_xcQuery += "FROM "+RetSqlName("SZ8")+" SZ8 "
								_xcQuery += "WHERE Z8_FILIAL = '01' "
								_xcQuery += "AND D_E_L_E_T_ <> '*' "
								_xcQuery += "AND Z8_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par01)+"' "
								_xcQuery += "AND (SUBSTRING(Z8_RDR,1,2) <> 'AP') "
								TcQuery _xcQuery New Alias "SZ8TMP"
								DbSelectArea("SZ8TMP")
								
								_nCredito := 0
								
								_nCredito := SZ8TMP->Z8_VALOR
								
								@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay _nCredito  Picture "@E 999,999,999,999.99"
								SZ8TMP->(DbCloseArea())
								DbSelectArea("TMP")
								
							ElseIf "01"+TMP->ZD_LINHA+TMP->ZD_COLUNA == "017901" //linha especifica TOTAL CREDITOS NAO IDENTIFICADOS
								
								_nTotal := 0
								_nTotal := (_nSldAnt+_nCredito)-(TMP->ZD_VALOR + TMP->ZD_DIFERE)
								
								@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay _nTotal  Picture "@E 999,999,999,999.99"
								
							Else
								@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay TMP->ZD_VALOR + TMP->ZD_DIFERE  Picture "@E 999,999,999,999.99"
							EndIf
						Else
							@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay TMP->ZD_VALOR + TMP->ZD_DIFERE  Picture "@E 999,999,999,999.99"
						EndIf
					Else
						@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+32+10 PSay TMP->ZD_VALOR                   Picture "@E 999,999,999,999.99"
					EndIf
				EndIf
			EndIf
			dbSelectArea("TMP")
			dbSkip()
		EndDo
		nLin := 70
	EndDo
	
	nLin := 70
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimindo SZC Diferencas FIBA                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Cabec1:=" Diferencas Apuradas no Movimento e Outras Contribuicoes"
	Cabec2:=" Emissao  Empresa                                 Tipo           Tipo Emp.      Convenio                    Valor  Natureza"
	//      " 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//           01_EMISSAO 10_EMPRESA 50_TIPO 65_RMV 80_CONV 95_VALOR
	
	U_Imp_Dif("SBA")
	U_Imp_Dif("SEC")
	U_Imp_Dif("FCB")
	U_Imp_Outros()
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QUERY")
dbCloseArea()

FechaAlias(_aAliases)  // DelAlias.ch

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Função que prepara o campo ZD_DIFERE no arq. temporario TMP
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


User Function CALC_DIF(_cPar)
If _cPar == "DEB"
	dbSelectArea("SZC")
	dbSetOrder(1)
	dbSeek(xFilial("SZC") + _cPar + DTOS(MV_PAR01), .T.)
	_nTotal := 0
	
	While !EOF() .And. ZC_EMISSAO >= mv_par01 .And. ZC_EMISSAO <= mv_par02 .And. ZC_PREFIXO==_cPar
		
		_cNat:=SZC->ZC_NATUREO
		
		dbSelectArea("SED")
		dbsetOrder(1)
		// Fluxo 2013
		If dbSeek(xFilial("SED") + _cNat , .F.) .And. !Empty(SED->ED_FECHA)
			_nPos:=1
			Do While .T.
				If mv_par04 == 1
					_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
				Else
					_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
				EndIf
				If _cChave == space(6) .Or. Val(_cChave) == 0
					Exit
				Else
					If TMP->(dbSeek(_cChave, .F.))
						If SZC->ZC_PREFIXO $ TMP->ZD_SIST .And. SZC->ZC_TIPO == "B"    // Acerto Manual
							RecLock("TMP", .F.)
							If TMP->ZD_TIPO == "G"
								ZD_DIFERE:= ZD_DIFERE - SZC->ZC_VALORT
							Else
								ZD_VALOR := ZD_VALOR + SZC->ZC_VALORT
							EndIf
							msUnLock()
						EndIf
					EndIf
				EndIf
				_nPos:=_nPos+7
			EndDo
		Else

        	_cChave := AllTrim(U_DePaNAT2013(_cNat))

			dbSelectArea("SED")
			dbsetOrder(1)
			
			If dbSeek(xFilial("SED") + _cChave, .F.) .And. !Empty(SED->ED_FECHA)
				_nPos:=1
				Do While .T.
					If mv_par04 == 1
						_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
					Else
						_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
					EndIf
					If _cChave == space(6) .Or. Val(_cChave) == 0
						Exit
					Else
						If TMP->(dbSeek(_cChave, .F.))
							If SZC->ZC_PREFIXO $ TMP->ZD_SIST .And. SZC->ZC_TIPO == "B"    // Acerto Manual
								RecLock("TMP", .F.)
								If TMP->ZD_TIPO == "G"
									ZD_DIFERE:= ZD_DIFERE - SZC->ZC_VALORT
								Else
									ZD_VALOR := ZD_VALOR + SZC->ZC_VALORT
								EndIf
								msUnLock()
							EndIf
						EndIf
					EndIf
					_nPos:=_nPos+7
				EndDo
			EndIf
		EndIf
		
		dbSelectArea("SZC")
		dbSkip()
		
	EndDo
	
Else
	For _nI:=1 to len(_aTitulos)-1
		
		dbSelectArea("SZC")
		dbSetOrder(1)
		dbSeek(xFilial("SZC") + _cPar + DTOS(MV_PAR01), .T.)
		
		
		_nTotal := 0
		
		While !EOF() .And. ZC_EMISSAO >= mv_par01 .And. ZC_EMISSAO <= mv_par02 .And. ZC_PREFIXO==_cPar
			
			Do case
				case _nI==1; _cNat:=SZC->ZC_NATUREB
				case _nI==2; _cNat:=SZC->ZC_NATUREC
					//			case _nI==3; _cNat:=SZC->ZC_NATURET
			EndCase
			
			dbSelectArea("SED")
			dbsetOrder(1)
			// Fluxo 2013
			
			If dbSeek(xFilial("SED") + _cNat , .F.) .And. !Empty(SED->ED_FECHA)
				_nPos:=1
				Do While .T.
					If mv_par04 == 1
						_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
					Else
						_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
					EndIf
					If _cChave == space(6) .Or. Val(_cChave) == 0
						Exit
					Else
						If TMP->(dbSeek(_cChave, .F.))
							If SZC->ZC_PREFIXO $ TMP->ZD_SIST
								RecLock("TMP", .F.)
								If SZC->ZC_TIPO == "A"   // Acerto Manual
									//							   ZD_VALOR := ZD_VALOR + SZC->ZC_VALORT
									Do case
										case _nI==1; ZD_VALOR := ZD_VALOR +  SZC->ZC_VALORB
										case _nI==2; ZD_VALOR := ZD_VALOR +  SZC->ZC_VALORC
									EndCase
								Else
									Do case
										case _nI==1; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORB
										case _nI==2; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORC
											//						   		case _nI==3; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORT
									EndCase
								EndIf
								msUnLock()
							EndIf
						EndIf
					EndIf
					_nPos:=_nPos+7
				EndDo
			Else
				         
        		_cChave := AllTrim(U_DePaNAT2013(_cNat))

				dbSelectArea("SED")
				dbsetOrder(1)
				
				If dbSeek(xFilial("SED") +  _cChave , .F.) .And. !Empty(SED->ED_FECHA)
					_nPos:=1
					Do While .T.
						If mv_par04 == 1
							_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
						Else
							_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
						EndIf
						If _cChave == space(6) .Or. Val(_cChave) == 0
							Exit
						Else
							If TMP->(dbSeek(_cChave, .F.))
								If SZC->ZC_PREFIXO $ TMP->ZD_SIST
									RecLock("TMP", .F.)
									If SZC->ZC_TIPO == "A"   // Acerto Manual
										//							   ZD_VALOR := ZD_VALOR + SZC->ZC_VALORT
										Do case
											case _nI==1; ZD_VALOR := ZD_VALOR +  SZC->ZC_VALORB
											case _nI==2; ZD_VALOR := ZD_VALOR +  SZC->ZC_VALORC
										EndCase
									Else
										Do case
											case _nI==1; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORB
											case _nI==2; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORC
												//						   		case _nI==3; ZD_DIFERE := ZD_DIFERE + SZC->ZC_VALORT
										EndCase
									EndIf
									msUnLock()
								EndIf
							EndIf
						EndIf
						_nPos:=_nPos+7
					EndDo
				EndIf
				
				
			EndIf
			
			dbSelectArea("SZC")
			dbSkip()
			
		EndDo
		
	Next _nI
EndIf

Return


User Function CALC_OUTRAS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lancamentos Manuais em SZC de Outras Contribuicoes ZC_TIPO=="DIV"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SZC")
dbSetOrder(1)
dbSeek(xFilial("SZC") + "DIV" + DTOS(MV_PAR01), .T.)

While !EOF() .And. ZC_EMISSAO >= mv_par01 .And. ZC_EMISSAO <= mv_par02 .And. ZC_PREFIXO=="DIV"
	dbSelectArea("SED")
	dbsetOrder(1)
	// Fluxo 2013
	If dbSeek(xFilial("SED") + SZC->ZC_NATUREO , .F.)
		If mv_par04 == 1
			_cChave3:= ("999999" $ SED->ED_FECHA) // Tipo Outros
		Else
			_cChave3:= ("999999" $ SED->ED_FECHA_B) // Tipo Outros
		EndIf
		If _cChave3
			dbSelectArea("TMO")
			RecLock("TMO", .T.)
			TMO->ED_NATUREZ  := SZC->ZC_NATUREO
			TMO->ED_DESCRI   := SZC->ZC_EMPRESA // SED->ED_DESCRIC
			TMO->E5_VALOR    := SZC->ZC_VALORT
			TMO->ED_EMISSAO  := SZC->ZC_EMISSAO
			TMO->ZD_SIST     := SZC->ZC_PREFIXO //TMP->ZD_SIST
			msUnLock()
		EndIf
	Else        
	
		_cChave := AllTrim(U_DePaNat2013(SZC->ZC_NATUREO))

		dbSelectArea("SED")
		dbsetOrder(1)
				
	
		If dbSeek(xFilial("SED") + _cChave , .F.)
			If mv_par04 == 1
				_cChave3:= ("999999" $ SED->ED_FECHA) // Tipo Outros
			Else
				_cChave3:= ("999999" $ SED->ED_FECHA_B) // Tipo Outros
			EndIf
			If _cChave3
				dbSelectArea("TMO")
				RecLock("TMO", .T.)
				TMO->ED_NATUREZ  := SZC->ZC_NATUREO
				TMO->ED_DESCRI   := SZC->ZC_EMPRESA // SED->ED_DESCRIC
				TMO->E5_VALOR    := SZC->ZC_VALORT
				TMO->ED_EMISSAO  := SZC->ZC_EMISSAO
				TMO->ZD_SIST     := SZC->ZC_PREFIXO //TMP->ZD_SIST
				msUnLock()
			EndIf
		EndIf
		
	EndIf
	dbSelectArea("SZC")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Totalizar Outras Contribuicoes no Total Geral Conforme a Natureza
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TMO")
dbGoTop()
Do While !Eof()
	dbSelectArea("SED")
	dbsetOrder(1)
	// Fluxo 2013
	If dbSeek(xFilial("SED") + TMO->ED_NATUREZ , .F.) .And. !Empty(SED->ED_FECHA)
		_nPos:=1
		While .T.
			If mv_par04 == 1
				_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
			Else
				_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
			EndIf
			If _cChave == space(6)
				Exit
			Else
				If TMP->(dbSeek(_cChave, .F.))
					If ALLTRIM(TMO->ZD_SIST) $ ALLTRIM(Posicione("SZD",1,xFilial("SZD")+_cChave+ALLTRIM(STR(mv_par04,0)),"ZD_SIST"))
						RecLock("TMP", .F.)
						ZD_VALOR := ZD_VALOR + TMO->E5_VALOR
						msUnLock()
					EndIf
				EndIf
			EndIf
			
			_nPos:=_nPos+7
		EndDo
	Else

		_cChave := AllTrim(U_DePaNat2013(TMO->ED_NATUREZ))

		dbSelectArea("SED")
		dbsetOrder(1)

		If dbSeek(xFilial("SED") + _cChave, .F.) .And. !Empty(SED->ED_FECHA)
			_nPos:=1
			While .T.
				If mv_par04 == 1
					_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
				Else
					_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
				EndIf
				If _cChave == space(6)
					Exit
				Else
					If TMP->(dbSeek(_cChave, .F.))
						If ALLTRIM(TMO->ZD_SIST) $ ALLTRIM(Posicione("SZD",1,xFilial("SZD")+_cChave+ALLTRIM(STR(mv_par04,0)),"ZD_SIST"))
							RecLock("TMP", .F.)
							ZD_VALOR := ZD_VALOR + TMO->E5_VALOR
							msUnLock()
						EndIf
					EndIf
				EndIf
				
				_nPos:=_nPos+7
			EndDo
		EndIf
		
	EndIf
	dbSelectArea("TMO")
	dbSkip()
EndDo


Return


User Function IMP_DIF(_cPar)

Do Case
	case _cPar == "SBA"; _cNomPar:= "SPBA"
	case _cPar == "SEC"; _cNomPar:= "SECOR"
	case _cPar == "FCB"; _cNomPar:= "FCB"
EndCase

//  _aTitulos[1] -  "Bolsa Auxilio"
//  _aTitulos[2] -  "Contribuicao Institucional"
//  _aTitulos[3] -  "Diferenças"

For _nI:=1 to len(_aTitulos)
	
	dbSelectArea("SZC")
	dbSetOrder(1)
	dbSeek(xFilial("SZC") + _cPar + DTOS(MV_PAR01), .T.)
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif
	
	_lPrim := .T.
	_nTotal := 0
	
	While !EOF() .And. ZC_EMISSAO >= mv_par01 .And. ZC_EMISSAO <= mv_par02 .And. ZC_PREFIXO==_cPar
		
		If SZC->ZC_TIPO == "A"  // Lançamento Manual tipo Acerto
			dbSkip()
			Loop
		EndIf
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
		Endif
		
		Do case
			case _nI==1
				If SZC->ZC_VALORB <> 0
					If _lPrim
						@ nLin,01    PSay  _cNomPar + " - " + _aTitulos[_nI]
						nLin   := nLin+1
						_lPrim := .F.
					EndIf
					
					@ nLin,01 PSay SZC->ZC_EMISSAO
					@ nLin,10 PSay SZC->ZC_EMPRESA
					@ nLin,50 PSay IF(SZC->ZC_TIPO == "C" , "CENTRALIZADO",IF(SZC->ZC_TIPO=="N","NOME",IF(SZC->ZC_TIPO=="D","DIRETO","REGIONALIZADO")))
					@ nLin,65 PSay IF(SZC->ZC_RMU  == "R" , "PRIVADA"     ,IF(SZC->ZC_RMU=="M" ,"MISTA","PUBLICA"))
					@ nLin,80 PSay SZC->ZC_CONV
					
					@ nLin,95 PSay SZC->ZC_VALORB Picture "@E 999,999,999,999.99"
					@ nLin,115 PSay SZC->ZC_NATUREB
					nLin:=nLin+1
					
				EndIf
				_nTotal :=_nTotal+SZC->ZC_VALORB
				
				
				
			case _nI==2
				If SZC->ZC_VALORC <> 0
					If _lPrim
						@ nLin,01    PSay  _cNomPar + " - " + _aTitulos[_nI]
						nLin   := nLin+1
						_lPrim := .F.
					EndIf
					
					@ nLin,01 PSay SZC->ZC_EMISSAO
					@ nLin,10 PSay SZC->ZC_EMPRESA
					@ nLin,50 PSay IF(SZC->ZC_TIPO == "C" , "CENTRALIZADO",IF(SZC->ZC_TIPO=="N","NOME",IF(SZC->ZC_TIPO=="D","DIRETO","REGIONALIZADO")))
					@ nLin,65 PSay IF(SZC->ZC_RMU  == "R" , "PRIVADA"     ,IF(SZC->ZC_RMU=="M" ,"MISTA","PUBLICA"))
					@ nLin,80 PSay SZC->ZC_CONV
					
					@ nLin,95 PSay SZC->ZC_VALORC Picture "@E 999,999,999,999.99"
					@ nLin,115 PSay SZC->ZC_NATUREC
					nLin:=nLin+1
					
				EndIf
				_nTotal :=_nTotal+SZC->ZC_VALORC
				
				
			case _nI==3
				If SZC->ZC_VALORT <> 0
					If _lPrim
						@ nLin,01    PSay  _cNomPar + " - " + _aTitulos[_nI]
						nLin   := nLin+1
						_lPrim := .F.
					EndIf
					
					@ nLin,01 PSay SZC->ZC_EMISSAO
					@ nLin,10 PSay SZC->ZC_EMPRESA
					@ nLin,50 PSay IF(SZC->ZC_TIPO == "C" , "CENTRALIZADO",IF(SZC->ZC_TIPO=="N","NOME",IF(SZC->ZC_TIPO=="D","DIRETO","REGIONALIZADO")))
					@ nLin,65 PSay IF(SZC->ZC_RMU  == "R" , "PRIVADA"     ,IF(SZC->ZC_RMU=="M" ,"MISTA","PUBLICA"))
					@ nLin,80 PSay SZC->ZC_CONV
					
					@ nLin,95 PSay SZC->ZC_VALORT Picture "@E 999,999,999,999.99"
					nLin:=nLin+1
					
				EndIf
				_nTotal :=_nTotal+SZC->ZC_VALORT
				
		EndCase
		dbSelectArea("SZC")
		dbSkip()
		
	EndDo
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif
	
	If _nTotal <> 0
		@ nLin,01    PSay  "Total de " + _aTitulos[_nI]
		@ nLin,95    PSay  _nTotal Picture "@E 999,999,999,999.99"
		nLin:=nLin+2
	EndIf
	
Next _nI




Return



User Function IMP_OUTROS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimindo SZC Diferencas FIBA                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nTotal   := 0
_nTotSist := 0

dbSelectArea("TMO")

_aEstrut  := {}
_aEstrut := {;
{"ED_NATUREZ"  ,  "C", 10, 0},;
{"ED_DESCRI"   ,  "C", 50, 0},;
{"ED_EMISSAO"  ,  "D", 08, 0},;
{"E5_VALOR"    ,  "N", 14, 2},;
{"ZD_SIST"     ,  "C", 30, 0}}
_cArqTrab := CriaTrab(_aEstrut, .T.)

IndRegua("TMO", _cArqTrab, "ZD_SIST+ED_NATUREZ",,, "Criando indice...", .T.)

dbSelectArea("TMO")
dbGotop()
_cSistema	:= TMO->ZD_SIST
_cParSist	:= ""
_lFirst     := .T.
If !EOF()
	@ nLin,01    PSay  Replicate("_",132)     ; nLin       := nLin+2
	@ nLin,01    PSay  "Outras Contribuicoes "; nLin       := nLin+1
	nLin++
EndIf

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
	Endif
	
	If _cSistema <> TMO->ZD_SIST
		_cSistema	:= TMO->ZD_SIST
		_lFirst     := .T.
		nLin++
		@ nLin,01    PSay  "Total "+_cParSist+" :"
		@ nLin,95    PSay  _nTotSist Picture "@E 999,999,999,999.99"
		_nTotSist := 0
		nLin++
		nLin++
	EndIf
	
	Do Case
		case alltrim(TMO->ZD_SIST) == "SBA"
			_cParSist := "SPBA"
		case alltrim(TMO->ZD_SIST) == "SEC"
			_cParSist := "SECOR"
		case alltrim(TMO->ZD_SIST) == "FCB"
			_cParSist := "FCB"
		case alltrim(TMO->ZD_SIST) == "DIV"
			_cParSist := "OUTROS ACERTOS FINANCEIROS - (TESOURARIA)"
	EndCase
	
	If _lFirst
		@ nLin,001 PSay _cParSist
		nLin++
		_lFirst := .F.
	EndIf
	
	@ nLin,001 PSay TMO->ED_EMISSAO
	@ nLin,010 PSay TMO->ED_DESCRI
	@ nLin,095 PSay TMO->E5_VALOR Picture "@E 999,999,999,999.99"
	@ nLin,115 PSay TMO->ED_NATUREZ
	_nTotal    := _nTotal    + TMO->E5_VALOR
	_nTotSist  += TMO->E5_VALOR
	nLin       := nLin+1
	
	dbSelectArea("TMO")
	dbSkip()
	
EndDo

If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 10
Endif

If _nTotSist <> 0
	nLin++
	@ nLin,01    PSay  "Total "+_cParSist+" :"
	@ nLin,95    PSay  _nTotSist Picture "@E 999,999,999,999.99"
	nLin++
EndIf

If _nTotal <> 0
	nLin++
	@ nLin,01    PSay  "Total de Outras Contribuicoes"
	@ nLin,95    PSay  _nTotal Picture "@E 999,999,999,999.99"
EndIf
Return
