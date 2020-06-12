#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
// 30Romaneio          #CESTR02  TSD3SB1CTT.................................................................................xxxxxxxxxx
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTR02   º Autor ³ Felipe Raposo      º Data ³  04/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de emissao de romaneio.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CESTR02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir o romaneio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Romaneio Geral"
Local cPict          := ""
Local titulo         := "Romaneio Geral"
Local nLin           := 80

Local Cabec1       := "Docto.    Data  Material                    Quantidade        Peso         Valor"
Local Cabec2       := "         Baixa                               fornecida                      (R$)"
********          := "999999 99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxx 99999999,99 999999,9999 999.999.999,99"
********          := "01234567890123456789012345678901234567890123456789012345678901234567890123456789"
********          := "0         1         2         3         4         5         6         7         "

Local imprime := .T.
Local aOrd    := {}
Local _aSX1
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "CESTR02"
Private nTipo      := 15
Private aReturn    := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nTipo      := IIf(aReturn[4] == 1, 15, 18)
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := nomeprog
Private cString    := "SD3"

// O bloco de comandos abaixo atualiza a tabela SX1 antes de abrir
// a caixa de perguntas (parametros) ao usuario.
cPerg := "CSTR02    "
_aSX1 := {;
{cPerg,"01","Centro de Custo de ?","¨De Centro de Costo?","From Cost Center   ?","mv_ch1","C",9,0,0,"G","        ","","","","","         ","","","","","","","","","","","","","","","","","","","","","SI3","","004"},;
{cPerg,"02","Centro de Custo ate?","¨A Centro de Costo ?","To Cost Center     ?","mv_cha","C",9,0,0,"G","zzzzzzzz","","","","","         ","","","","","","","","","","","","","","","","","","","","","SI3","","004"},;
{cPerg,"03","Data de Referˆncia ?","¨Fecha Referencia  ?","Reference Date     ?","mv_ch2","D",8,0,0,"G","naovazio","","","","","'31/01/01'","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1) // _FixSX.ch
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do romaneio.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RunReport(Cabec1,Cabec2,Titulo,nLin)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  04/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _cAlias, _aAreaB1, _aAreaCTT
Private _nTotPeso, _nTotVal
Private _cFiltro

// Variaveis totalizadoras.
_nTotPeso := 0
_nTotVal  := 0

_aAreaB1  := SB1->(GetArea())
_aAreaCTT := CTT->(GetArea())
_aAreaD3  := SD3->(GetArea())
_cAlias  := Alias()
_cFiltro := "(D3_CC == mv_par01 .and. D3_EMISSAO == mv_par02)" +;
IIf (empty(aReturn[7]), "", " .and. (" + aReturn[7] + ")")

SB1->(dbSetOrder(1))
CTT->(dbSetOrder(1))
SD3->(dbSetOrder(2))
dbSelectArea(cString)
Set Filter To &(_cFiltro)
dbGoTop()

If !eof()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| ImpRomaneio(Cabec1,Cabec2,Titulo,nLin)},Titulo)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen
Set Filter To
dbSelectArea(_cAlias)
SB1->(RestArea(_aAreaB1))
CTT->(RestArea(_aAreaCTT))
SD3->(RestArea(_aAreaD3))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return


Static Function ImpRomaneio(Cabec1,Cabec2,Titulo,nLin)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())
Do While !eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()
	If lAbortPrint
		@nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo); nLin := 9
	Endif
	
	SB1->(dbSeek(xFilial("SB1") + SD3->D3_COD, .F.))
	@nLin, 00 PSay SubStr(SD3->D3_DOC, 1, 6)
	@nLin, 07 PSay dtoc(SD3->D3_EMISSAO)
	//@nLin, 16 PSay SubStr(SD3->D3_COD, 1, 8)
	@nLin, 16 PSay SubStr(SB1->B1_DESC,  1, 25)
	@nLin, 42 PSay Transform(SD3->D3_QUANT,  "@E 9999999.99")
	@nLin, 54 PSay Transform(SB1->B1_PESO,   "@E 99999.9999")
	@nLin, 66 PSay Transform(SD3->D3_CUSTO1, "@E 99,999,999.99")
	nLin++ // Avanca a linha de impressao
	
	_nTotPeso += SB1->B1_PESO
	_nTotVal  += SD3->D3_CUSTO1
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo); nLin := 8
Endif
@nLin, 00 PSay Replicate("-",limite); nLin++
@nLin, 15 PSay "Total....:"
@nLin, 53 PSay Transform(_nTotPeso, "@E 999999.9999")
@nLin, 65 PSay Transform(_nTotVal,  "@E 999,999,999.99"); nLin++
@nLin, 15 PSay "Quantidade de volumes gerados: ___________"; nLin += 2
@nLin, 00 PSay Replicate("=",limite); nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 44 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo); nLin := 9
Endif
// Observacao.
@nLin, 00 PSay "Obs.: " + Replicate("_",limite - 6); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin += 2

// Vistos.
@nLin, 05 PSay "  Almoxarifado            Adm.  Patrimonial         Adm.  Patrimonial "; nLin++
@nLin, 05 PSay "Liberado:__/__/__         Recebido:__/__/__         Enviado.:__/__/__ "; nLin++
@nLin, 05 PSay "Nome:____________         Nome:____________         Nome:____________ "; nLin++
@nLin, 05 PSay "Visto:___________         Visto:___________         Visto:___________ "; nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 40 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo); nLin := 9
Else
	@nLin, 00 PSay Replicate("=",limite); nLin += 2
Endif
CTT->(dbSeek(xFilial("CTT") + mv_par01, .F.))
@nLin, 05 PSay upper("A ser preenchido pela area / unidade e devolvido ao almoxarifado."); nLin += 3
@nLin, 05 PSay "Unidade destino: " + AllTrim(CTT->CTT_CUSTO) + " - " + CTT->CTT_DESC01; nLin += 2

// Observacao.
@nLin, 00 PSay "Obs.: " + Replicate("_",limite - 6); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin++
@nLin, 00 PSay Replicate("_",limite); nLin += 2

// Vistos.
@nLin, 05 PSay "Unidade de Distribuicao   Unidade de Distribuicao   Unidade de Distribuicao"; nLin++
@nLin, 05 PSay "Recebido......:__/__/__   Reencaminhado.:__/__/__   Recebido......:__/__/__"; nLin++
@nLin, 05 PSay "Nome:__________________   Nome:__________________   Nome:__________________"; nLin++
@nLin, 05 PSay "Visto:_________________   Visto:_________________   Visto:_________________"; nLin++
Return