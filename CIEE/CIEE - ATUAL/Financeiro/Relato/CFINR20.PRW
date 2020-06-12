#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR20   บAutor  ณCristiano Giardini  บ Data ณ  14/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Contas a Pagar - Aguardando Liberacao ou Pagamen-บฑฑ
ฑฑบ          ณ to Liberado                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINR020()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relatorio Contas a Pagar"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relatorio Contas a Pagar"
Local nLin    := 80
Local Cabec1  := "Natureza    Fornecedor                                                    Banco  Agencia  Conta Corrente    Vencimento         Valor    Forma Pgto       Bordero"
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 220    //80 / 132 / 220 Colunas
Private tamanho     := "G"
Private nomeprog    := "CFINR20"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CFINR020"
Private cString     := "SE2"
Private cPerg       := "CFIN20    "

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SE2")
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

cQuery := "SELECT SE2.*, A2_NOME "
cQuery += " FROM "+RetSQLname("SE2")+" SE2, "
cQuery +=          RetSQLName("SA2")+" SA2 "
cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' "
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " AND E2_VENCREA BETWEEN '" + DTOS(mv_par01)+ "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND E2_NATUREZ BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND E2_FORNECE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"   
cQuery += " AND A2_FILIAL = '"+ xFilial("SA2") + "' "
cQuery += " AND A2_COD = E2_FORNECE "
cQuery += " AND A2_LOJA = E2_LOJA "
//PATRICIA FONTANEZI - 30/10/2012 - INCLUSAO DO PARAMETRO 12
IF MV_PAR12 <> " "
	IF MV_PAR12 == '001'   //BANCO BRASIL
		cQuery += " AND E2_BANCO = '"+ mv_par12 + "' "   
	ELSEIF MV_PAR12 == '033' // SANTANDER
   		cQuery += " AND E2_BANCO IN ('033','275','353','356') "  
	ELSEIF MV_PAR12 == '237' // BRADESCO
   		cQuery += " AND E2_BANCO = '"+ mv_par12 + "' "
	ELSEIF MV_PAR12 == '341' // ITAU
   		cQuery += " AND E2_BANCO IN ('341','409') "
   	ELSEIF MV_PAR12 == '104' // CEF
   	  	cQuery += " AND E2_BANCO = '"+ mv_par12 + "' "
	ELSEIF MV_PAR12 == '998'  //OUTROS BANCOS
		cQuery += " AND E2_BANCO NOT IN ('','001','033','275','353','356','237','341','409','104') "  	
	ELSEIF MV_PAR12 == '999'  // BOLETO
		cQuery += " AND E2_CODBAR <> ' ' " 	
	ENDIF
ENDIF

cQuery += " AND E2_TIPO NOT IN ('TX','INS','ISS')"
/*
//Tirado dia 18/08/11 - alterado criterio do relatorio. Esperar analise do usuario.
cQuery += " AND E2_BAIXA    =  ''"
*/
//cQuery += " AND E2_NUMBOR   =  ''" 
cQuery += " AND E2_NUMAP    =  ''"		
If mv_par07 == 1 // Aguardando Liberacao
	cQuery += " AND E2_DATALIB = ''"
ElseIf mv_par07 == 2 // Pagamento Liberado
	cQuery += " AND E2_DATALIB <> ''"
EndIf

If mv_par11 == 1 // Efetuados
	cQuery += " AND E2_NUMBOR BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"  
	cQuery += " AND E2_NUMBOR <> ''"
ElseIf mv_par11 == 2 // Pendentes
	cQuery += " AND E2_NUMBOR   =  ''"
EndIf
cQuery += " ORDER BY E2_VALOR "    //PATRICIA FONTANEZI - INCLUSAO DE ORDEM POR VALOR
//cQuery += " ORDER BY E2_NUMBOR, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VENCREA, E2_BANCO, E2_NOMFOR "
TcQuery cQuery New Alias "TMP"    

TcSetField("TMP","E2_VENCREA","D",8, 0)

dbSelectArea("TMP")
dbGotop()

If mv_par07 == 1
	titulo := "Relatorio Contas a Pagar - Aguardando Liberacao"
ElseIf mv_par07 == 2
	titulo := "Relatorio Contas a Pagar - Pagamento Liberado"
Else
	titulo := "Relatorio Contas a Pagar - Bloqueado e Liberado"
EndIf

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
              
	If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

/*0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  123456789.  123456789.123456789.123456789.123456789.123456789.123456789.  123    123456   123456789,123456  123456789,  123456789,1234  123456789,12345  123456
  Natureza    Fornecedor                                                    Banco  Agencia  Conta Corrente    Vencimento         Valor    Forma Pgto       Bordero
  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999    9999-9   99999999-9        99/99/99    999.999.999,99  xxxxxxxxxxxxxxx  xxxxxx
*/ 

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Filtra Usuario que Incluiu Titulo no SE2                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(mv_par08)
		_cUsuario    := Alltrim(FWLeUserlg("TMP->E2_USERLGI"))   //PATRICIA FONTANEZI - 09/10/2012 - Alltrim(Subs(Embaralha(TMP->E2_USERLGI,1),1,15))
		If _cUsuario <> Alltrim(mv_par08)
			DbSkip()
			Loop
		EndIf                                 
	EndIf		                                 

@ nLin, 000 PSAY PADR(TMP->E2_NATUREZ,10,"")
@ nLin, 012 PSAY PADR(TMP->A2_NOME,60,"")
@ nLin, 074 PSAY PADR(TMP->E2_BANCO,3,"")
If !EMPTY(TMP->E2_DVFOR)
	@ nLin, 081 PSAY PADR(TMP->E2_AGEFOR,4,"") +"-"+PADR(TMP->E2_DVFOR,1,"")
Else
	@ nLin, 081 PSAY PADR(TMP->E2_AGEFOR,4,"")
End
@ nLin, 090 PSAY PADR(TMP->E2_CTAFOR,16,"")
@ nLin, 108 PSAY PADR(TMP->E2_VENCREA,10,"") 
@ nLin, 120 PSAY TMP->E2_VALOR+TMP->E2_ACRESC-TMP->E2_DECRESC picture "@E 999,999,999.99" //Alterado dia 02/03/10 - Acrescentado campos de ACRESC/ DECRESC
@ nLin, 136 PSAY SUBSTR(TMP->E2_FORPGTO,1,15)
@ nLin, 153 PSAY alltrim(TMP->E2_NUMBOR)

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
           
Local nTam:= TamSx3("ED_CODIGO")[1]
aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem,pergunt           ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03  ,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Vencimento De  ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Vencimento Ate ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Natureza De    ","      ","       ","mv_ch3","C" ,nTam ,00 ,0  ,"G",""   ,"mv_par03",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SED","","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Natureza Ate   ","      ","       ","mv_ch4","C" ,nTam ,00 ,0  ,"G",""   ,"mv_par04",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SED","","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Fornecedor De  ","      ","       ","mv_ch5","C" ,06 ,00 ,0  ,"G",""   ,"mv_par05",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Fornecedor Ate ","      ","       ","mv_ch6","C" ,06 ,00 ,0  ,"G",""   ,"mv_par06",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2","","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Status         ","      ","       ","mv_ch7","N" ,01 ,00 ,0  ,"C",""   ,"mv_par07","Pgto Bloqueado"      ,""      ,""      ,""   ,""   ,"Pgto Liberado",""      ,""      ,""   ,""   ,"Ambos",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"08" ,"Usuario        ","      ","       ","mv_ch8","C" ,14 ,00 ,0  ,"G",""   ,"mv_par08",""                    ,""      ,""      ,""   ,""   ,"             ",""      ,""      ,""   ,""   ,"     ",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"USC","","","",""})

aAdd(aRegs,{cPerg  ,"09" ,"Bordero De     ","      ","       ","mv_ch9","C" ,06 ,00 ,0  ,"G",""   ,"mv_par09",""                    ,""      ,""      ,""   ,""   ,"             ",""      ,""      ,""   ,""   ,"     ",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"10" ,"Bordero Ate    ","      ","       ","mv_chA","C" ,06 ,00 ,0  ,"G",""   ,"mv_par10",""                    ,""      ,""      ,""   ,""   ,"             ",""      ,""      ,""   ,""   ,"     ",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"11" ,"Status Bordero ","      ","       ","mv_chB","N" ,01 ,00 ,0  ,"C",""   ,"mv_par11","Efetuado"            ,""      ,""      ,""   ,""   ,"Pendente"     ,""      ,""      ,""   ,""   ,"Ambos",""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})  
aAdd(aRegs,{cPerg  ,"12" ,"Banco Fornecedor","      ","       ","mv_chC","C" ,03 ,00 ,0  ,"G","","mv_par12"  ,""  					,""      ,""      ,""   ,""   ,""	          ,""      ,""      ,""   ,""   ,""		,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"92" ,"","","",""})
//aAdd(aRegs,{cPerg  ,"12" ,"Banco Fornecedor","      ","       ","mv_chC","N" ,01 ,00 ,0  ,"C","","mv_par12","001 Banco Brasil"	,""      ,""      ,""   ,"","033 Santander",""      ,""      ,""   ,""   ,"237 Bradesco",""      ,""     ,""   ,""   ,"341 Ita๚","","","","","Outros Bancos"   ,""      ,""     ,""   ,"","Boleto","","",""})
//aAdd(aRegs,{cPerg  ,"13" ,"Boleto         ","      ","       ","mv_chD","N" ,01 ,00 ,0  ,"C","U_BOL20()","mv_par13","NAO"  		        ,""      ,""      ,""   ,""   ,"SIM"		  ,""      ,""      ,""   ,""   ,""		,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})

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


