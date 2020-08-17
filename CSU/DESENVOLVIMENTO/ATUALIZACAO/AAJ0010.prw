#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AAJ0010  บ Autor ณ Adalberto Althoff  บ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo xls com dados comparativos de dois meses do   บฑฑ
ฑฑบ          ณ SRD.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AAJ0010


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cPerg       := PADR("AJ0010",LEN(SX1->X1_GRUPO))
Private oGeraXls

dbSelectArea("SRA")
dbSetOrder(1)

ValidPerg(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,400 DIALOG oGeraXls TITLE OemToAnsi("Arquivo Excel Dados Acumulados")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo no Excel conforme os para- "
@ 18,018 Say " metros definidos  pelo usuario, com os registros  do  arquivo  de "
@ 26,018 Say " Acumulados Anuais."

@ 60,098 BMPBUTTON TYPE 01 ACTION (OkGeraXls(),Close(oGeraXls))
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oGeraXls)
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraXls Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERAXLSบ Autor ณ AP5 IDE            บ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo XLS.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraXls

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida datas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

/*
IF MesAno(MV_PAR06)==MesAno(MV_PAR05)
	MsgStop("Selecione datas com meses e anos diferentes...")
	return
endif	
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSepara string de verbas por virgulas, entre aspas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cVerbas := alltrim(MV_PAR02)+alltrim(MV_PAR03)+alltrim(MV_PAR04)
nTamStr := len(cVerbas)
for i=1 to nTamStr/3-1
	cVerbas := left(cVerbas,i*6-3)+"','"+subs(cVerbas,i*6-2)
next
cVerbas := "'"+cVerbas+"'"


                 
Do Case
	Case MV_PAR01 == 1  

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณQuery Analiticaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                                
		
		_cQuery := "select NUM.FIL AS FILIAL, NUM.MAT AS MATRICULA, RA.RA_NOME AS NOME, "
		_cQuery += "RA.RA_CC AS CCUSTO, CTT.CTT_DESC01 AS DESCCC, NUM.ANT AS " + "Mes_"+MesAno(MV_PAR05) + ",  "
		_cQuery += "NUM.ATU AS " + "Mes_"+MesAno(MV_PAR06) + ", DIFERENCA = (NUM.ATU-NUM.ANT) FROM  "

		_cQuery += "( select tabA.RD_FILIAL AS FIL, tabA.RD_MAT AS MAT,  "
		_cQuery += "tabA.SUMATU AS ATU, tabB.SUMANT AS ANT from "

		_cQuery += "( "
		_cQuery += "select RD_FILIAL, RD_MAT, SUM(RD_VALOR) AS SUMATU  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR06) + "' "
		_cQuery += "AND   D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_MAT  "
		_cQuery += ") as tabA  "

		_cQuery += "left join "

		_cQuery += "( "
		_cQuery += "select RD_FILIAL, RD_MAT, SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "AND D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_MAT  "
		_cQuery += ") as tabB  "

		_cQuery += "ON (tabB.RD_FILIAL = tabA.RD_FILIAL AND tabB.RD_MAT = tabA.RD_MAT) "

		_cQuery += "union "

		_cQuery += "select tabB.RD_FILIAL AS FIL, tabB.RD_MAT AS MAT, tabA.SUMATU AS ATU,  "
		_cQuery += "tabB.SUMANT AS ANT from "

		_cQuery += "( "
		_cQuery += "select RD_FILIAL, RD_MAT, SUM(RD_VALOR) AS SUMATU from SRD050  "
		_cQuery += "WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR06) + "'	AND   D_E_L_E_T_ <> '*' "
		_cQuery += "group by RD_FILIAL,RD_MAT  "
		_cQuery += ") as tabA  "

		_cQuery += "right join "

		_cQuery += "( "
		_cQuery += "select RD_FILIAL, RD_MAT, SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "AND D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_MAT  "
		_cQuery += ") as tabB  "

		_cQuery += "ON (tabB.RD_FILIAL = tabA.RD_FILIAL AND tabB.RD_MAT = tabA.RD_MAT) "

		_cQuery += ") as NUM, "

		_cQuery += "( "
		_cQuery += "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC FROM "+RETSQLNAME('SRA')+" WHERE D_E_L_E_T_ <> '*' "
		_cQuery += ") AS RA, "

		_cQuery += "( "
		_cQuery += "SELECT CTT_CUSTO,CTT_DESC01 FROM "+RETSQLNAME('CTT')+" WHERE D_E_L_E_T_ <> '*' "
		_cQuery += ") AS CTT "

		_cQuery += "WHERE NUM.FIL  = RA.RA_FILIAL AND NUM.MAT  = RA.RA_MAT AND  "
		_cQuery += "RA.RA_CC = CTT.CTT_CUSTO ORDER BY NUM.FIL+NUM.MAT "
		
/*
		_cQuery := "SELECT PR.RD_FILIAL  AS FILIAL, "
		_cQuery += "       PR.RD_MAT     AS MATRICULA, "
		_cQuery += "       RA.RA_NOME    AS NOME, "
		_cQuery += "       RA.RA_CC      AS CCUSTO, "
		_cQuery += "       CC.CTT_DESC01 AS DESCCC, "		
		_cQuery += "       AN.SUMANT     AS " + "Mes_"+MesAno(MV_PAR05) + ", " 
		_cQuery += "       PR.SUMATU     AS " + "Mes_"+MesAno(MV_PAR06) + ", "
		_cQuery += "       DIFERENCA     = (PR.SUMATU-AN.SUMANT)  "
		_cQuery += "FROM ( 	select RD_FILIAL,  "
		_cQuery += "               RD_MAT,  "
		_cQuery += "               SUM(RD_VALOR) AS SUMATU  "
		_cQuery += "	from "+RETSQLNAME('SRD')+"  "
		_cQuery += "	WHERE RD_PD      IN("+cVerbas+") "
		_cQuery += "	AND   RD_DATARQ  = '" + MesAno(MV_PAR06) + "' "
		_cQuery += "	AND   D_E_L_E_T_ <> '*' "
		_cQuery += "	group by RD_FILIAL,RD_MAT ) AS PR JOIN "
		_cQuery += "     (	select RD_FILIAL,  "
		_cQuery += "               RD_MAT,  "
		_cQuery += "               SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "	from "+RETSQLNAME('SRD')+" "
		_cQuery += "	WHERE RD_PD      IN("+cVerbas+") "
		_cQuery += "	AND   RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "	AND   D_E_L_E_T_ <> '*' "
		_cQuery += "	group by RD_FILIAL,RD_MAT ) AS AN ON (     PR.RD_MAT    = AN.RD_MAT "
		_cQuery += "	                                       AND PR.RD_FILIAL = AN.RD_FILIAL ), "
		_cQuery += "     (  select RA_FILIAL,  "
		_cQuery += "               RA_MAT,  "
		_cQuery += "               RA_NOME,  "
		_cQuery += "               RA_CC  "
		_cQuery += "	from "+RETSQLNAME('SRA')+" "
		_cQuery += "	WHERE  D_E_L_E_T_ <> '*') AS RA,  "
		_cQuery += "     (	select CTT_CUSTO,  "
		_cQuery += "              CTT_DESC01  "
		_cQuery += "	from "+RETSQLNAME('CTT')+" "		
		_cQuery += "	WHERE D_E_L_E_T_ <> '*') AS CC "		
		_cQuery += "WHERE PR.RD_MAT    = RA.RA_MAT  "
		_cQuery += "AND   PR.RD_FILIAL = RA.RA_FILIAL "
		_cQuery += "AND   RA.RA_CC     = CC.CTT_CUSTO "		
		_cQuery += "ORDER BY FILIAL,MATRICULA		 "
*/		
	Case MV_PAR01 == 2
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณQuery Sinteticaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


		_cQuery := "SELECT NUM.FIL AS FILIAL, NUM.CC AS CCUSTO, CTT.CTT_DESC01 AS DESCCC, "
		_cQuery += "NUM.ANT AS " + "Mes_"+MesAno(MV_PAR05) + ", NUM.ATU AS " + "Mes_"+MesAno(MV_PAR06) + ", DIFERENCA = (NUM.ATU-NUM.ANT) FROM  "

		_cQuery += "( select tabA.RD_FILIAL AS FIL, tabA.RD_CC AS CC,  "
		_cQuery += "tabA.SUMATU AS ATU, tabB.SUMANT AS ANT from "

		_cQuery += "( select RD_FILIAL, RD_CC, SUM(RD_VALOR) AS SUMATU from "+RETSQLNAME('SRD')+"  "
		_cQuery += "WHERE RD_PD      IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR06) + "'  "
		_cQuery += "AND D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_CC "
		_cQuery += ") as tabA  "

		_cQuery += "LEFT JOIN "

		_cQuery += "(select RD_FILIAL, RD_CC, SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "AND   D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_CC "
		_cQuery += ") as tabB  "

		_cQuery += "ON (tabB.RD_FILIAL = tabA.RD_FILIAL AND tabB.RD_CC = tabA.RD_CC) "

		_cQuery += "UNION "

		_cQuery += "select tabB.RD_FILIAL AS BFIL, tabB.RD_CC AS BCC, "
		_cQuery += "tabA.SUMATU, tabB.SUMANT from "

		_cQuery += "( select RD_FILIAL, RD_CC, SUM(RD_VALOR) AS SUMATU  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR06) + "'  "
		_cQuery += "AND D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_CC "
		_cQuery += ") as tabA  "

		_cQuery += "Right JOIN "

		_cQuery += "(select RD_FILIAL, RD_CC, SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "from "+RETSQLNAME('SRD')+" WHERE RD_PD IN("+cVerbas+") AND RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "AND D_E_L_E_T_ <> '*' group by RD_FILIAL,RD_CC "
		_cQuery += ") as tabB  "

		_cQuery += "ON (tabB.RD_FILIAL = tabA.RD_FILIAL AND tabB.RD_CC = tabA.RD_CC) "

		_cQuery += ") AS NUM, "

		_cQuery += "(SELECT CTT_CUSTO,CTT_DESC01 FROM "+RETSQLNAME('CTT')+" WHERE D_E_L_E_T_ <> '*') AS CTT "

		_cQuery += "WHERE CTT.CTT_CUSTO = NUM.CC "

		_cQuery += "ORDER BY FILIAL,CCUSTO "

/*
		_cQuery := "SELECT PR.RD_FILIAL  AS FILIAL,  "
		_cQuery += "       PR.RD_CC      AS CCUSTO,  "
		_cQuery += "       CC.CTT_DESC01 AS DESCCC, "
		_cQuery += "       AN.SUMANT     AS " + "Mes_"+MesAno(MV_PAR05) + ",  "
		_cQuery += "       PR.SUMATU     AS " + "Mes_"+MesAno(MV_PAR06) + ", "
		_cQuery += "       DIFERENCA     = (PR.SUMATU-AN.SUMANT)  "
		_cQuery += "FROM ( 	select RD_FILIAL,  "
		_cQuery += "               RD_CC,  "
		_cQuery += "               SUM(RD_VALOR) AS SUMATU  "
		_cQuery += "	from "+RETSQLNAME('SRD')+"  "
		_cQuery += "	WHERE RD_PD      IN("+cVerbas+") "
		_cQuery += "	AND   RD_DATARQ  = '" + MesAno(MV_PAR06) + "' "
		_cQuery += "	AND   D_E_L_E_T_ <> '*' "
		_cQuery += "	group by RD_FILIAL,RD_CC ) AS PR JOIN "
		_cQuery += "     (	select RD_FILIAL,  "
		_cQuery += "               RD_CC,  "
		_cQuery += "               SUM(RD_VALOR) AS SUMANT  "
		_cQuery += "	from "+RETSQLNAME('SRD')+" "
		_cQuery += "	WHERE RD_PD      IN("+cVerbas+") "
		_cQuery += "	AND   RD_DATARQ  = '" + MesAno(MV_PAR05) + "' "
		_cQuery += "	AND   D_E_L_E_T_ <> '*' "
		_cQuery += "	group by RD_FILIAL,RD_CC ) AS AN ON (      PR.RD_CC    = AN.RD_CC "
		_cQuery += "                                          AND PR.RD_FILIAL = AN.RD_FILIAL ),"		
		_cQuery += "     (	select CTT_CUSTO,  "
		_cQuery += "              CTT_DESC01  "
		_cQuery += "	from "+RETSQLNAME('CTT')+" "		
		_cQuery += "	WHERE D_E_L_E_T_ <> '*') AS CC "		
		_cQuery += "WHERE PR.RD_CC     = CC.CTT_CUSTO  "
		_cQuery += "ORDER BY FILIAL,CCUSTO		 "
*/		
		
EndCase		


ProcRegua(2)
IncProc("Selecionando Registros...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("TRBAAJ") >0
	DBSelectArea("TRBAAJ")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TCQUERY _cQuery NEW ALIAS "TRBAAJ"
IncProc("Selecionando Registros...")

DBSelectArea("TRBAAJ")                   
   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia alias para DBF ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_cNomeArq 	:= CriaTrab(NIL,.F.)

copy to &(_cNomeArq)
Dbusearea(.T.,,_cNomeArq,"TRBEXL",.F.,.F.)

DbSelectArea("TRBEXL")

DBGOTOP()

ProcRegua(2)
IncProc("Ajustando registros selecionados...")

vAnt := "Mes_"+MesAno(MV_PAR05)
vAtu := "Mes_"+MesAno(MV_PAR06)

Do while !eof()
	if empty(&vAnt) .or. empty(&vAtu) .or. empty(diferenca)
		RecLock("TRBEXL",.F.)
		If empty(&vAnt)
			TRBEXL->&vAnt := 0
		Endif                              
		If empty(&vAtu)
			TRBEXL->&vAtu := 0
		Endif                                      
		If empty(diferenca)
			TRBEXL->DIFERENCA := &vAtu - &vAnt
		Endif
		MSUnlock()   
	EndIf
	DbSkip()	
Enddo

IncProc("Ajustando registros selecionados...")

TRBEXL->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre DBF no Excel ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

OpExcel(_cNomeArq)          

//Close(oGeraXls)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OpExcel  บ Autor ณ Adilson Gomes      บ Data ณ  08/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ OLE para uso do excel com o microsiga.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OpExcel(cArqTRC)
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia DBF para pasta TEMP do sistema operacional da estacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If FILE(cArqTRC+".DBF")
	COPY FILE (cArqTRC+".DBF") TO (cPath+cArqTRC+".DBF")
EndIf

If !ApOleClient("MsExcel")
	MsgStop("MsExcel nao instalado.")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria link com o excelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp := MsExcel():New()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre uma planilhaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp:WorkBooks:Open(cPath+cArqTRC+".DBF")
oExcelApp:SetVisible(.T.)
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VALIDPERGบ Autor ณ Adalberto Althoff  บ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar, VALIDADA PARA AP7                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Tipo do Arquivo ","","","mv_ch1","n",01,0,0,"C","            ","mv_par01","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","   ","","",".RHTPREL. "})
aAdd(aRegs,{_cPerg,"02","Verbas          ","","","mv_ch2","C",30,0,0,"G","fVerbas     ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"03","Verbas          ","","","mv_ch3","C",30,0,0,"G","fVerbas     ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"04","Verbas          ","","","mv_ch4","C",30,0,0,"G","fVerbas     ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"05","Data Anterior   ","","","mv_ch5","D",08,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"06","Data Atual      ","","","mv_ch6","D",08,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})


For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return