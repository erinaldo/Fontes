#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR25   บAutor  ณCristiano Giardini  บ Data ณ  25/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Conta Corrente Fornecedores                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINR025()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relatorio Conta Corrente Fornecedores"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relatorio Conta Corrente Fornecedores"
Local nLin    := 80
Local Cabec1  := " Cod Fornec     Nome Fornecedor                                                   Banco     Nome Banco                         Tipo Conta          Numero
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 132    //80 / 132 / 220 Colunas
Private tamanho     := "G"
Private nomeprog    := "CFINR025"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CFINR025"
Private cString     := "SZK"
Private cPerg       := "CFIN25    "

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SZK")
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

If mv_par04 == 1 // Ativo
	Titulo	+=	"  (Ativo)"
ElseIf mv_par04 == 2 // Inativo
	Titulo	+=	"  (Inativo)"
Else
	Titulo	+=	"  (Ativo / Inativo)"
EndIf

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

If mv_par03 == 4 // cartao itau
	Cabec1	:= " Cod Fornec     Nome Fornecedor                                                  Unidade             Banco     Nome Banco                         Tipo Conta          Numero          Limite Periodo          Saque Dia"
Else
	Cabec1	:= " Cod Fornec     Nome Fornecedor                                                   Banco     Nome Banco                         Tipo Conta          Numero"
EndIf

cQuery := "SELECT *"
cQuery += " FROM "+RetSQLname('SZK')+" SZK "
cQuery += " WHERE SZK.D_E_L_E_T_ <> '*' "
cQuery += " AND ZK_BANCO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
If mv_par03 == 1 // conta corrente
	cQuery += " AND ZK_TIPO = '1'"
ElseIf mv_par03 == 2 // conta poupanca
	cQuery += " AND ZK_TIPO = '2'"
ElseIf mv_par03 == 3 // conta cartao brasil
	cQuery += " AND ZK_TIPO = '3'"
ElseIf mv_par03 == 4 // conta cartao itau
	cQuery += " AND ZK_TIPO = '4'"
EndIf
If mv_par04 == 1 // Ativo
	cQuery += " AND ZK_STATUS = 'A'"
ElseIf mv_par04 == 2 // Inativo
	cQuery += " AND ZK_STATUS = 'I'"
EndIf
cQuery += " ORDER BY ZK_TIPO, ZK_NOME, ZK_BANCO "
TcQuery cQuery New Alias "TMP"    

dbSelectArea("TMP")
dbGotop()

_cSegmento	:= TMP->ZK_TIPO

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

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Cabecalho Padrao                                                    ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

/*       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cod Fornec     Nome Fornecedor                                                   Banco     Nome Banco                         Tipo Conta          Numero
999999         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      999       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     xxxxxxxxxxxxxxx     99999999999
*/                                                                                                                  

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Cabecalho Cartao Itau                                               ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

/*       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cod Fornec     Nome Fornecedor                                                  Unidade             Banco     Nome Banco                         Tipo Conta          Numero          Limite Periodo          Saque Dia
999999         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     xxxxxxxxxxxxxxx     999       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     xxxxxxxxxxxxxxx     99999999999     999,999,999.99     999,999,999.99
*/                                                                                                                  

//Quebra de linha	     

	If _cSegmento <> TMP->ZK_TIPO
		nLin++
		nLin++
		@ nLin, 000 PSAY __PrtThinLine()
		nLin++
	//	nLin++

		_cSegmento  := TMP->ZK_TIPO
	
	EndIf

	@ nLin, 001 PSAY TMP->ZK_FORNECE
	@ nLin, 016 PSAY ALLTRIM(TMP->ZK_NOME)
	If mv_par03 == 4 // cartao itau
		@ nLin, 081 PSAY ALLTRIM(TMP->ZK_UNIDADE)
		@ nLin, 101 PSAY TMP->ZK_BANCO
		@ nLin, 111 PSAY TMP->ZK_NOMBCO
		If !Empty(TMP->ZK_NUMCON) // conta corrente
			@ nLin, 146 PSAY "Conta Corrente"
			@ nLin, 166 PSAY TMP->ZK_NUMCON
		ElseIf !Empty(TMP->ZK_NROPOP) // conta poupanca
			@ nLin, 146 PSAY "Conta Poupanca"
			@ nLin, 166 PSAY TMP->ZK_NROPOP
		ElseIf !Empty(TMP->ZK_NROCRT) // conta cartao
			@ nLin, 146 PSAY "Conta Cartao"
			@ nLin, 166 PSAY TMP->ZK_NROCRT
		EndIf
		@ nLin, 182 PSAY TMP->ZK_E_LIMIT picture "@E 999,999,999.99"
		@ nLin, 201 PSAY TMP->ZK_E_SLDIA picture "@E 999,999,999.99"
	Else
		@ nLin, 082 PSAY TMP->ZK_BANCO		
		@ nLin, 092 PSAY TMP->ZK_NOMBCO
		If !Empty(TMP->ZK_NUMCON) // conta corrente
			@ nLin, 127 PSAY "Conta Corrente"
			@ nLin, 147 PSAY TMP->ZK_NUMCON
		ElseIf !Empty(TMP->ZK_NROPOP) // conta poupanca
			@ nLin, 127 PSAY "Conta Poupanca"
			@ nLin, 147 PSAY TMP->ZK_NROPOP
		ElseIf !Empty(TMP->ZK_NROCRT) // conta cartao
			@ nLin, 127 PSAY "Conta Cartao"
			@ nLin, 147 PSAY TMP->ZK_NROCRT
		EndIf
	EndIf

	nLin++
	
	DbSelectArea("TMP")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo      

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
             grupo ,ordem ,pergunt             ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02            ,defspa02,defeng02,cnt02,var03,def03                ,defspa03,defeng03,cnt03,var04,def04              ,defspa04,defeng04,cnt04,var05,def05   ,defspa05,defeng05,cnt05,f3     ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Banco De          ","      ","       ","mv_ch1","C" ,03 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""                   ,""      ,""     ,""   ,""   ,""                 ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SZ1"   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Banco Ate         ","      ","       ","mv_ch2","C" ,03 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""                   ,""      ,""     ,""   ,""   ,""                 ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"SZ1"   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Tipo C/C          ","      ","       ","mv_ch3","N" ,01 ,00 ,0  ,"C",""   ,"mv_par03","Conta Corrente"      ,""      ,""      ,""   ,""   ,"Conta Poupanca",""      ,""      ,""   ,""   ,"Cartao Brasil"      ,""      ,""     ,""   ,""   ,"Cartao Itau"      ,""      ,""      ,""   ,""   ,"Todos",""      ,""     ,""   ,""      ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Status            ","      ","       ","mv_ch4","N" ,01 ,00 ,0  ,"C",""   ,"mv_par04","Ativo"               ,""      ,""      ,""   ,""   ,"Inativo"       ,""      ,""      ,""   ,""   ,"Todos"              ,""      ,""     ,""   ,""   ,""                 ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""      ,"","","",""})

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

Return