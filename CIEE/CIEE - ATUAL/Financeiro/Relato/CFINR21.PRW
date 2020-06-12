#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR21   บAutor  ณCristiano Giardini  บ Data ณ  28/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Fechamento de Caixa                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINR021()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relatorio Fechamento de Caixa"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relatorio Fechamento de Caixa"
Local nLin    := 80
Local Cabec1  := "  Convenio            Valor Bolsa        Valor CI       Juros     Valor Total  Identificacao         Data Credito  Conta Corrente  RDR     Segmento
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 132    //80 / 132 / 220 Colunas
Private tamanho     := "G"
Private nomeprog    := "CFINR021"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CFINR021"
Private cString     := "SZ8"
Private cPerg       := "CFIN21    "

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SZ8")
dbSetOrder(1)        

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

pergunte(cperg,.F.)

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

Do Case
	Case cEmpant == '01'
		Titulo := Alltrim(Titulo) + "  -  CIEE / SP"				
	Case cEmpant == '03'
		Titulo := Alltrim(Titulo) + "  -  CIEE / RJ"				
	Case cEmpant == '05'
		Titulo := Alltrim(Titulo) + "  -  CIEE / NACIONAL"						
EndCase		

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/09/06   บฑฑ
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

Private _cSegmento

cQuery := "SELECT *"
cQuery += " FROM "+RetSQLname('SZ8')+" SZ8 "
cQuery += " WHERE SZ8.D_E_L_E_T_ <> '*' "
cQuery += " AND Z8_EMISSAO BETWEEN '" + DTOS(mv_par01)+ "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND Z8_IDENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND Z8_RDR BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"  
If mv_par07 == 1 // Mista
	cQuery += " AND Z8_RMU = 'M'"
ElseIf mv_par07 == 2 // Privada
	cQuery += " AND Z8_RMU = 'R'"
ElseIf mv_par07 == 3 // Publica
	cQuery += " AND Z8_RMU = 'U'"
ElseIf mv_par07 == 4 // Outras Contribuicoes
	cQuery += " AND Z8_RMU = 'O'"
EndIf
cQuery += " ORDER BY Z8_RMU, Z8_CONV "
TcQuery cQuery New Alias "TMP"    

TcSetField("TMP","Z8_EMISSAO","D",8, 0 )

dbSelectArea("TMP")
dbGotop()

_cSegmento	:= TMP->Z8_RMU

_nSub_BA	:= 0
_nSub_CI	:= 0
_nSub_JU	:= 0
_nSub_TO	:= 0
 
_nTot_BA	:= 0
_nTot_CI	:= 0
_nTot_JU	:= 0
_nTot_TO	:= 0

While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif    

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
              
   If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

/*       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 Convenio            Valor Bolsa        Valor CI       Juros     Valor Total  Identificacao         Data Credito  Conta Corrente  RDR      Segmento
 99999*9999*9999  999.999.999,99  999.999.999,99  999.999,99  999.999.999,99  xxxxxxxxxxxxxxxxxxxx  99/99/99      99999999-9      999999   xxxxxxxx
*/

//Quebra de linha	     
If _cSegmento <> TMP->Z8_RMU
	nLin++
	@ nLin, 002 PSAY "SUB-TOTAL   ==>"
	@ nLin, 019 PSAY _nSub_BA		picture "@E 999,999,999.99"
	@ nLin, 035 PSAY _nSub_CI		picture "@E 999,999,999.99"
	@ nLin, 051 PSAY _nSub_JU		picture "@E 999,999.99"
	@ nLin, 063 PSAY _nSub_TO		picture "@E 999,999,999.99"
	nLin++
	@ nLin, 000 PSAY __PrtThinLine()
	nLin++
//	nLin++

	_cSegmento  := TMP->Z8_RMU
	
   _nSub_BA	:= 0
   _nSub_CI	:= 0
   _nSub_JU	:= 0
   _nSub_TO	:= 0
	
EndIf

@ nLin, 002 PSAY TMP->Z8_CONV
@ nLin, 019 PSAY TMP->Z8_BA			picture "@E 999,999,999.99"
@ nLin, 035 PSAY TMP->Z8_CI			picture "@E 999,999,999.99"
@ nLin, 051 PSAY TMP->Z8_IR			picture "@E 999,999.99"
@ nLin, 063 PSAY TMP->Z8_VALOR		picture "@E 999,999,999.99"
@ nLin, 079 PSAY TMP->Z8_IDENT_D
@ nLin, 101 PSAY TMP->Z8_EMISSAO
@ nLin, 115 PSAY TMP->Z8_CONTA
@ nLin, 131 PSAY TMP->Z8_RDR
@ nLin, 143 PSAY TMP->Z8_RMU

nLin++
	
_nSub_BA	+= TMP->Z8_BA
_nSub_CI	+= TMP->Z8_CI
_nSub_JU	+= TMP->Z8_IR
_nSub_TO	+= TMP->Z8_VALOR
   
_nTot_BA	+= TMP->Z8_BA
_nTot_CI	+= TMP->Z8_CI
_nTot_JU	+= TMP->Z8_IR
_nTot_TO	+= TMP->Z8_VALOR

DbSelectArea("TMP")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo      

nLin++
@ nLin, 002 PSAY "SUB-TOTAL   ==>"
@ nLin, 019 PSAY _nSub_BA		picture "@E 999,999,999.99"
@ nLin, 035 PSAY _nSub_CI		picture "@E 999,999,999.99"
@ nLin, 051 PSAY _nSub_JU		picture "@E 999,999.99"
@ nLin, 063 PSAY _nSub_TO		picture "@E 999,999,999.99"
nLin++
@ nLin, 000 PSAY __PrtThinLine()

nLin++
@ nLin, 002 PSAY "TOTAL GERAL ==>"
@ nLin, 019 PSAY _nTot_BA		picture "@E 999,999,999.99"
@ nLin, 035 PSAY _nTot_CI		picture "@E 999,999,999.99"
@ nLin, 051 PSAY _nTot_JU		picture "@E 999,999.99"
@ nLin, 063 PSAY _nTot_TO		picture "@E 999,999,999.99"

DbSelectArea("TMP")
DbCloseArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt             ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03    ,defspa03,defeng03,cnt03,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data De           ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Data Ate          ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Identificacao De  ","      ","       ","mv_ch3","C" ,02 ,00 ,0  ,"G",""   ,"mv_par03",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SZB","","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Identificacao Ate ","      ","       ","mv_ch4","C" ,02 ,00 ,0  ,"G",""   ,"mv_par04",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SZB","","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"RDR De            ","      ","       ","mv_ch5","C" ,06 ,00 ,0  ,"G",""   ,"mv_par05",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"RDR Ate           ","      ","       ","mv_ch6","C" ,06 ,00 ,0  ,"G",""   ,"mv_par06",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""       ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Segmento          ","      ","       ","mv_ch7","N" ,01 ,00 ,0  ,"C",""   ,"mv_par07","Mista"               ,""      ,""      ,""   ,""   ,"Privada"      ,""      ,""      ,""   ,""   ,"Publica",""      ,""     ,""   ,""   ,"Outras Contrib",""      ,""      ,""   ,""   ,"Todos",""      ,""     ,""   ,""   ,"","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

//pergunte(cperg,.T.)

Return