#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCIEE006   บAutor  ณCristiano Giardini  บ Data ณ  24/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Unidades de Operacao                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CQDOR02() //CIEE006()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relatorio de Unidades de Operacao por Tipo de Documento"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relatorio de Unidades de Operacao por Tipo de Documento"
Local nLin    := 80
//Local Cabec1  := " Unidade                  Endereco                                                                      Bairro                      UF   CEP         Numero Documento"
Local Cabec1  := " Unidade                   Endereco                                                                      Bairro                      UF   CEP          Numero Documento      Tp.Unidade	  Observacao"
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 132    //80 / 132 / 220 Colunas
Private tamanho     := "G"
Private nomeprog    := "CIEE006"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CIEE006"
Private cString     := "PA2"
Private cPerg       := "CIEE06    "

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("PA2")
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

cQuery := "SELECT PA2_COD, PA2_DESC, PA2_END, PA2_BAIRRO, PA2_CID, PA2_EST, PA2_CEP, PA4_NUMDOC, PA2_STATUS, PA1_CNPJ, PA1_DESC, PA2_TPUNID, PA2_OBS"
cQuery += " FROM "+RetSQLname('PA2')+" PA2, "+RetSQLname('PA4')+" PA4, "+RetSQLname('PA1')+" PA1 "
cQuery += " WHERE PA2.D_E_L_E_T_ <> '*' "
cQuery += " AND PA4.D_E_L_E_T_ <> '*' "
cQuery += " AND PA1.D_E_L_E_T_ <> '*' "
cQuery += " AND PA2_COD = PA4_CODUNI "
cQuery += " AND PA4_CODDOC = PA1_COD "
cQuery += " AND PA2_DESC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND PA2_EST BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND PA2_DESCGE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'" 
If mv_par09 <> 4
	cQuery += " AND PA2_TPUNID = '" + alltrim(str(mv_par09)) + "' " 
EndIf
If mv_par07 <> '99'
	cQuery += " AND PA1_TPDOC = '" + mv_par07 + "'"
EndIf
If mv_par08 == 1 		// Ativo
	cQuery += " AND PA2_STATUS = 'A' "
ElseIf mv_par08 == 2   // Inativo
	cQuery += " AND PA2_STATUS = 'I' "	
EndIf


cQuery += " ORDER BY PA2_DESC "
TcQuery cQuery New Alias "TMP"    

dbSelectArea("TMP")
dbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Imprime o complemento do Titulo conforme paramentro mv_par07.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If mv_par07 <> '99' 
	Titulo := Alltrim(Titulo) + "  -  ("+Alltrim(TMP->PA1_DESC)+")"
Else
	Titulo := Alltrim(Titulo) + "  -  (Todos)"	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicio Laco de impressao...                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Unidade                     Endereco                                                                      Bairro                      UF   CEP         Numero Documento      Tp. Unidade      Observacao
xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxx   xx   99999-999   99999999999999999999  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*/                                                                                                                  

	_cTpUnid	:= space(14)
	Do Case 
		Case TMP->PA2_TPUNID == "1"
			_cTpUnid := "Unid.Operac.  "
		Case TMP->PA2_TPUNID == "2"
			_cTpUnid := "Posto de Atend"
		Case TMP->PA2_TPUNID == "3"
			_cTpUnid := "Sala Aprendiz "
	EndCase
	
	@ nLin, 001 PSAY Substr(TMP->PA2_DESC,1,25) //001
	@ nLin, 027 PSAY TMP->PA2_END               //27
	@ nLin, 105 PSAY TMP->PA2_BAIRRO            //105
	@ nLin, 133 PSAY TMP->PA2_EST               //133
	@ nLin, 139 PSAY TMP->PA2_CEP Picture "@R 99999-999" //139
	If Empty(TMP->PA1_CNPJ)                              // 151
		@nLin, 151 PSay TMP->PA4_NUMDOC
	Else
		@nLin, 151 PSay TMP->PA4_NUMDOC Picture "@R 99.999.999/9999-99"	
	EndIf
	
	@ nLin, 173 PSAY Substr(_cTpUnid,1,14)
		
	If mv_par10 == 1
		@ nLin, 189 Psay TMP->PA2_OBS
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
             grupo ,ordem ,pergunt            ,perg spa,perg eng , variav ,tipo,tam,dec,pres ,gsc ,valid,var01     ,def01          ,defspa01,defeng01,cnt01,var02,def02         ,defspa02,defeng02,cnt02,var03,def03           ,defspa03,defeng03,cnt03,var04,def04 ,defspa04,defeng04,cnt04,var05,def05 ,defspa05,defeng05,cnt05,f3     ,"","","",""
*/                                                                                                                          
aAdd(aRegs,{cPerg  ,"01" ,"Unidade de     ?  ","      ","       ","mv_ch1","C" ,40 ,00 ,0    ,"G",""   ,"mv_par01",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""              ,""      ,""     ,""   ,""   ,""     ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"PA2a" ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Unidade ate    ?  ","      ","       ","mv_ch2","C" ,40 ,00 ,0    ,"G",""   ,"mv_par02",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"PA2a" ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Estado de      ?  ","      ","       ","mv_ch3","C" ,02 ,00 ,0    ,"G",""   ,"mv_par03",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"12"   ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Estado ate     ?  ","      ","       ","mv_ch4","C" ,02 ,00 ,0    ,"G",""   ,"mv_par04",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"12"   ,"","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Gerencia de    ?  ","      ","       ","mv_ch5","C" ,40 ,00 ,0    ,"G",""   ,"mv_par05",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"PA5a" ,"","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Gerencia ate   ?  ","      ","       ","mv_ch6","C" ,40 ,00 ,0    ,"G",""   ,"mv_par06",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"PA5a" ,"","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Tipo Documento ?  ","      ","       ","mv_ch7","C" ,02 ,00 ,0    ,"G",""   ,"mv_par07",""              ,""      ,""      ,""   ,""   ,""            ,""      ,""      ,""   ,""   ,""   	       ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,"P1"   ,"","","",""})
aAdd(aRegs,{cPerg  ,"08" ,"Status         ?  ","      ","       ","mv_ch8","N" ,01 ,00 ,0    ,"C",""   ,"mv_par08","Ativo"         ,""      ,""      ,""   ,""   ,"Inativo"     ,""      ,""      ,""   ,""   ,"Ambos"         ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""     ,"","","",""})

aAdd(aRegs,{cPerg  ,"09" ,"Tipo Unidade   ?  ","      ","       ","mv_ch9","N" ,01 ,00 ,0    ,"C",""   ,"mv_par09","Unid.Operacao" ,""      ,""      ,""   ,""   ,"Posto Atend" ,""      ,""      ,""   ,""   ,"Sala Aprendiz" ,""      ,""     ,""   ,""   ,"Ambos",""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""     ,"","","",""})
aAdd(aRegs,{cPerg  ,"10" ,"Observacao     ?  ","      ","       ","mv_chA","N" ,01 ,00 ,0    ,"C",""   ,"mv_par10","Sim"           ,""      ,""      ,""   ,""   ,"Nao"         ,""      ,""      ,""   ,""   ,""              ,""      ,""     ,""   ,""   ,""   	,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""     ,"","","",""})

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