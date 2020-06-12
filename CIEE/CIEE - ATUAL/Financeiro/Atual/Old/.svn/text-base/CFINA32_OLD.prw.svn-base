#include "Protheus.Ch"
#include "_FixSX.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA32   บ Autor ณ Claudio Barros     บ Data ณ  09/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para controle dos documentos apos retorno do banco. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFIN - CIEE - Especifico                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function CFINA32()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "Cadastro de Documentos"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Baixar","u_CFINA32A()",0,3} ,;
{"Relatorio","u_CFINR32E()",0,2},;
{"Legenda","u_CFINA32D()",0,2}}


dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE2",,"E2_DTCOMPR",,,,)

Return


User Function CFINA32A()


//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
Local aArea   := {}
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local aCpos   := {}
Local aCampos := {}
Local cMsg    := ""
Local cQuery  := " "
Local cFl := Chr(13)+Chr(10)
Local _aStrut
//Local cTipofor := alltrim(Getmv("CI_TIPOFOR"))
Private aRotina     := {}
Private cMarca      := " "
Private cCadastro   := OemToAnsi("Documentos Pendentes")
Private nTotal      := 0
Private cArquivo    := ""
Private aVetor := {}


cPerg := "FINA32"
_aSX1 := {;
{cPerg,"01","Vencto de  ?"," "," ","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"02","Vencto ate ?"," "," ","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1) // _FixSX.ch

// Se o usuario nao confirmar, nao processar.
If !Pergunte(cPerg, .T.)
	Return
EndIf

// Define a estrutura do arquivo de trabalho.
_aStrut := {;
{"Z2_DTCOMPR",  "D", 8, 0},;
{"Z2_EMISSAO",  "D", 8, 0},;
{"Z2_NOMFOR", "C", 20,0},;
{"Z2_VALOR",  "N", 14, 2},;
{"Z2_NUMBOR",  "C", 6, 0},;
{"Z2_NUMAP",  "C", 6, 0},;
{"Z2_FL",  "C", 6, 0},;
{"Z2_PREFIXO",  "C", 3, 0},;
{"Z2_NUM",  "C", 6, 0},;
{"Z2_PARCELA",  "C", 1, 0},;
{"Z2_TIPO",  "C", 3, 0},;
{"Z2_FORNECE",  "C", 6, 0},;
{"Z2_LOJA",  "C", 2, 0},;
{"Z2_VENCREA",   "D", 8, 0}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aStrut, .T.)

dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMP",_cArqTrab, "DTOS(Z2_VENCREA)+Z2_NUMBOR+Z2_NUMAP+Z2_FL",,, "Criando indice...", .T.)

DbSelectArea("TMP")
aArea := GetArea()
cKey  := IndexKey()
dbSelectArea("TMP")

cQuery := " SELECT E2_NOMFOR, E2_VALLIQ, E2_VENCREA, E2_NUMBOR, E2_NUMAP, E2_FL, E2_DTCOMPR,  "+ cFl
cQuery += " E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO,E2_FORNECE,E2_LOJA, E2_EMISSAO " + cFl
cQuery += " FROM "+RetSqlName("SE2")+" " + cFl
cQuery += " WHERE D_E_L_E_T_ = ' '  AND E2_DTCOMPR = ' ' AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+ cFl
cQuery += " AND E2_TIPO NOT IN ('TX','INS','ISS')" + cFl
cQuery += " AND E2_VALLIQ <> 0 " + cFl
cQuery += " ORDER BY E2_VENCREA, E2_NUMBOR, E2_NUMAP, E2_FL " + cFl

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'Q17', .T., .T.)

TcSetField("Q17","E2_DTCOMPR","D",8, 0 )
TcSetField("Q17","E2_VENCREA","D",8, 0 )
TcSetField("Q17","E2_EMISSAO","D",8, 0 )


DbSelectArea("Q17")
Q17->(Dbgotop())


While !Q17->(EOF())
	
    Reclock("TMP",.T.)
	TMP->Z2_DTCOMPR  := Q17->E2_DTCOMPR
	TMP->Z2_NOMFOR   := Q17->E2_NOMFOR
	TMP->Z2_VALOR    := Q17->E2_VALLIQ
	TMP->Z2_NUMBOR   := Q17->E2_NUMBOR
	TMP->Z2_NUMAP    := Q17->E2_NUMAP
	TMP->Z2_FL       := Q17->E2_FL
	TMP->Z2_PREFIXO  := Q17->E2_PREFIXO
	TMP->Z2_NUM      := Q17->E2_NUM
	TMP->Z2_PARCELA  := Q17->E2_PARCELA
	TMP->Z2_TIPO     := Q17->E2_TIPO
	TMP->Z2_FORNECE  := Q17->E2_FORNECE
	TMP->Z2_LOJA     := Q17->E2_LOJA
	TMP->Z2_VENCREA  := Q17->E2_VENCREA
	TMP->Z2_EMISSAO  := Q17->E2_EMISSAO
	TMP->(MsUnlock())
	Q17->(DBSKIP())
	
End


DbSelectArea("TMP")
TMP->(DBGOTOP())

lRetFu := CFINA32B() // Chamada para funcao ListMark


IF Len(aVetor) > 0 .and. lRetFu == .T.
	
	For Ic:=1 To Len(aVetor)
		
		If !Empty(aVetor[Ic][1])
			
			DBSELECTAREA("SE2")
			SE2->(DBSETORDER(1))
			SE2->(DBGOTOP())
			SE2->(DBSEEK(xFILIAL("SE2")+aVetor[Ic][10]+aVetor[Ic][11]+aVetor[Ic][12]+aVetor[Ic][13]+aVetor[Ic][14]+aVetor[Ic][15]))
			Reclock("SE2",.F.)
			SE2->E2_DTCOMPR := dDATABASE
			SE2->E2_OBS   := aVetor[Ic][9]
			SE2->(Msunlock())
		Endif
		
	Next
Endif


If Select("Q17") > 0
	Q17->(DbCloseArea())
EndIf


dbSelectArea("TMP")
_cArqTrab += OrdBagExt()
TMP->(DBCLOSEAREA())
FErase( _cArqTrab )
RestArea( aArea )

Return Nil


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Cfina32D             | AUTOR |Claudio Barros| DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Legenda()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria legenda para usuario identificar os registros              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Cfina32D()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"Comprovante Pendente"})
aAdd(aCor,{"BR_VERMELHO","Comprovante Regularizado"    })

BrwLegenda(cCadastro,OemToAnsi("Registros"),aCor)

Return



Static Function CFINA32B()

Local aSalvAmb := {}
Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Documentos Pendentes"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local oChk     := Nil

Private lChk     := .F.
Private oLbx := Nil

Private lRet 

dbSelectArea("TMP")
aSalvAmb := GetArea()
dbSetOrder(1)

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While !tmp->(Eof())
	aAdd( aVetor, { lMark,TMP->Z2_EMISSAO,TMP->Z2_NOMFOR,TMP->Z2_VALOR,TMP->Z2_VENCREA,;
	TMP->Z2_NUMBOR,TMP->Z2_NUMAP, TMP->Z2_FL, SPACE(40), TMP->Z2_PREFIXO,;
	TMP->Z2_NUM,TMP->Z2_PARCELA,TMP->Z2_TIPO,TMP->Z2_FORNECE,TMP->Z2_LOJA})
	TMP->(dbSkip())
End

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existe Titulos a consultar", {"Ok"} )
	Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 390,650 PIXEL

@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
" ","Emissao","Nome Fornecedor","Valor","Vencimento","Bordero","AP","FL","Observacao";
SIZE 310,165 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
Transform(aVetor[oLbx:nAt,4],"@E 99,999,999.99"),;
aVetor[oLbx:nAt,5],;
aVetor[oLbx:nAt,6],;
aVetor[oLbx:nAt,7],;
aVetor[oLbx:nAt,8],;
aVetor[oLbx:nAt,9]}}

@ 177,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))

DEFINE SBUTTON FROM 177,193 TYPE 11 ACTION (CFINA32C()) ENABLE OF oDlg
DEFINE SBUTTON FROM 177,233 TYPE 1 ACTION (lRet :=.T.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 177,273 TYPE 2 ACTION (lRet :=.F.,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
RestArea( aSalvAmb )

Return(lRet)

Static Function Marca(lMarca)


Local i := 0

For i := 1 To Len(aVetor)
	aVetor[i][1] := lMarca
Next i
oLbx:Refresh()

Return


Static Function CFINA32C()

Local cObs := SPACE(40)
Local oDlg1   := Nil
Local oFld    := Nil

DEFINE MSDIALOG oDlg1 TITLE "Observacao do Documento" FROM 0,0 TO 130,382 OF oDlg1 PIXEL

@ 06,06 TO 46,177 LABEL "Observacao" OF oDlg1 PIXEL
@ 25, 15 MSGET cObs Valid(!Empty(cObs))  PICTURE "@!" SIZE 150,10 PIXEL OF oDlg1

//+----------------------------------------------------------------------------
//| Botoes da MSDialog
//+----------------------------------------------------------------------------
DEFINE SBUTTON FROM  050, 150 TYPE  1 ENABLE ACTION (oDLg1:End()) OF oDLg1
ACTIVATE MSDIALOG oDlg1 CENTER

aVETOR[OLBX:NAT][9] := cObs


Return     



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR32E()บ Autor ณ AP6 IDE            บ Data ณ  11/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINR32E()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Comprovantes Bancarios"
Local cPict          := ""
Local titulo       := "Relatorio de Comprovantes Bancarios"
Local nLin         := 80                                                                                                     
Local Cabec1       := "Emissao   Nome Fornecedor                    Valor      Vencimento    Bordero   AP         FL       Comprovante    Observacao"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Local cFl := CHR(13)+CHR(14)
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CFINR32" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CFIR32"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CFINR32" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SE2" 


dbSelectArea("SE2")
dbSetOrder(1)


CriaSx1()
If !pergunte(cPerg,.T.)
	Return Nil
EndIf

If MV_PAR05 == 1
   titulo+=" - Baixados "
ElseIf MV_PAR05 == 1
   titulo+=" - Pendentes " 
Else 
   titulo+=" - Baixados e Pendentes "
EndIf                          

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cFl := CHR(13)+CHR(14)
Local cQuery := " "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := " SELECT E2_NOMFOR, E2_VALLIQ, E2_VENCREA, E2_NUMBOR, E2_NUMAP, E2_FL, E2_DTCOMPR,  "+ cFl
cQuery += " E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO,E2_FORNECE,E2_LOJA, E2_EMISSAO, E2_OBS " + cFl
cQuery += " FROM "+RetSqlName("SE2")+" " + cFl
cQuery += " WHERE D_E_L_E_T_ = ' '  AND E2_VENCREA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "+ cFl
cQuery += " AND E2_DTCOMPR BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+ cFl
cQuery += " AND E2_VALLIQ <> 0 " + cFl
cQuery += " AND E2_FORNECE >=  '"     + mv_par06 + "'"+ cFl    
cQuery += " AND E2_FORNECE <=  '"     + mv_par07 + "'"+ cFl
IF MV_PAR05 == 1
   cQuery += " AND E2_DTCOMPR <> ' ' "+ cFl
ELSEIF MV_PAR05 == 2
      cQuery += " AND E2_DTCOMPR = ' ' "+ cFl
ENDIF      
cQuery += " ORDER BY E2_VENCREA, E2_NUMBOR, E2_NUMAP, E2_FL, E2_PREFIXO, E2_NUM " + cFl
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'Q18', .T., .T.)

TcSetField("Q18","E2_DTCOMPR","D",8, 0 )
TcSetField("Q18","E2_VENCREA","D",8, 0 )
TcSetField("Q18","E2_EMISSAO","D",8, 0 )


DBSELECTAREA("Q18")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O tratamento dos parametros deve ser feito dentro da logica do seu  ณ
//ณ relatorio. Geralmente a chave principal e a filial (isto vale prin- ณ
//ณ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ณ
//ณ meiro registro pela filial + pela chave secundaria (codigo por exem ณ
//ณ plo), e processa enquanto estes valores estiverem dentro dos parame ณ
//ณ tros definidos. Suponha por exemplo o uso de dois parametros:       ณ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ Assim o processamento ocorrera enquanto o codigo do registro posicioณ
//ณ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ณ
//ณ limite para o processamento. Caso existam outros parametros a serem ณ
//ณ checados, isto deve ser feito dentro da estrutura de la็o (WHILE):  ณ
//ณ                                                                     ณ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ mv_par03 -> Considera qual estado?                                  ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ     If A1_EST <> mv_par03                                           ณ
//ณ         dbSkip()                                                    ณ
//ณ         Loop                                                        ณ
//ณ     Endif                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Q18->(dbGoTop())
While !Q18->(EOF())

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif


//             1         2         3         4         5         6         7         8         9         0         1         2         3
//   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//   Emissao   Nome Fornecedor                    Valor      Vencimento    Bordero   AP         FL       Comprovante    Observacao
//   99/99/99  XXXXXXXXXXXXXXXXXXX       999.999.999,99        99/99/99     XXXXXX   XXXXXX     XXXXXX   99/99/99       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 


	    @nLin,000 PSAY Q18->E2_EMISSAO
	    @nLin,010 PSAY Q18->E2_NOMFOR
	    @nLin,036 PSAY Q18->E2_VALLIQ  Picture "@E 999,999,999.99
	    @nLin,056 PSAY Q18->E2_VENCREA
	    @nLin,070 PSAY Q18->E2_NUMBOR
	    @nLin,080 PSAY Q18->E2_NUMAP  
		@nLin,091 PSAY Q18->E2_FL  	    
        @nLin,100 PSAY Q18->E2_DTCOMPR
	    @nLin,115 PSAY Q18->E2_OBS
        nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("Q18") > 0
   DbCloseArea("Q18")
EndIf   
    

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

cPerg := PADR(cPerg,6)


AADD(aReg,{cPerg,"01","Baixa Compr De  ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"02","Baixa Compr Ate ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"03","Vencimento De  ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"04","Vencimento Ate ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"05","Comprovantes ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Baixados","","","Pendentes","","","Ambos","","","","","","","",""})
AADD(aReg,{cPerg,"06","Fornecedor De  ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","SA2","",""})
AADD(aReg,{cPerg,"07","Fornecedor Ate ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","SA2","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

SX1->(dbSetOrder(1)); SX1->(dbSeek(cPerg + "06"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := SE2->E2_FORNECE
SX1->(msUnLock())
SX1->(dbSeek(cPerg + "07"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := SE2->E2_FORNECE
SX1->(msUnLock())

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil



