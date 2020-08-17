#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSUR001   บ Autor ณ SILVANO FRANCA     บ Data ณ  25/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DO MOVIMENTO DE ACUMULADOS DA FOLHA.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSUR003()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local titulo       	 	:= "Relat๓rio de acumulados"
Local cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2			:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relat๓rio de acumulados."

Local cPict          	:= ""
Local nLin         	 	:= 80
Local Cabec1       		:= " "
Local Cabec2       		:= " "
Local imprime      		:= .T.

Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 220
Private tamanho         := "G"
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01

Private wnrel     		:= "CSUR003" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SRA"
Private nomeprog        := "CSUR003" // Coloque aqui o nome do programa para impressao no cabecalho
Private cPerg       	:= PADR("CSUACU",LEN(SX1->X1_GRUPO))
Private aOrd       		:= {"Filial + Matrํcula + Perํodo"}

PutSx1(cPerg, "01","Filial De                     ","","","mv_ch1" ,"C",02,0,0,"G",""									, "SM0","","","mv_par01"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Filial inicial"			},{},{})
PutSx1(cPerg, "02","Filial At้                    ","","","mv_ch2" ,"C",02,0,0,"G","NaoVazio"							, "SM0","","","mv_par02"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                  ","","","mv_ch3" ,"C",06,0,0,"G",""  								, "SRA","","","mv_par03"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Matrํcula inicial"		},{},{})
PutSx1(cPerg, "04","Matricula at้                 ","","","mv_ch4" ,"C",06,0,0,"G","NaoVazio"							, "SRA","","","mv_par04"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Matrํcula final"			},{},{})
PutSx1(cPerg, "05","Centro de Custo de            ","","","mv_ch5" ,"C",09,0,0,"G",""  								, "CTT","","","mv_par05"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Centro de custo inicial"	},{},{})
PutSx1(cPerg, "06","Centro de Custo at้           ","","","mv_ch6" ,"C",09,0,0,"G","NaoVazio"							, "CTT","","","mv_par06"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Centro de custo final"	},{},{})
PutSx1(cPerg, "07","Perํodo de (AAAAMM)           ","","","mv_ch7" ,"C",06,0,0,"G",""  	   							, ""   ,"","","mv_par07"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Data inicial"				},{},{})
PutSx1(cPerg, "08","Perํodo at้ (AAAAMM)          ","","","mv_ch8" ,"C",06,0,0,"G","NaoVazio"							, ""   ,"","","mv_par08"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Data final"				},{},{})
PutSx1(cPerg, "09","Verbas                        ","","","mv_ch9" ,"C",90,0,0,"G","fVerbas(NIL,MV_PAR10+MV_PAR11,20)"	, ""   ,"","","mv_par08"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Eventos a considerar"		},{},{})
PutSx1(cPerg, "10","Continua็ใo verbas            ","","","mv_ch10","C",90,0,0,"G","fVerbas(NIL,MV_PAR09+MV_PAR11,20)"	, ""   ,"","","mv_par08"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Eventos a considerar"		},{},{})

// Foi retirado o ultimo parโmetro devido a limita็ใo do numero de caracteres que o fun็ใo TCGenquery suporta.
// Por isso a fun็ใo estแ limitada a 40 verbas.
// PutSx1(cPerg, "11","Continua็ใo verbas            ","","","mv_ch11","C",90,0,0,"G","fVerbas(NIL,MV_PAR09+MV_PAR12,20)"	, ""   ,"","","mv_par08"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Eventos a considerar"		},{},{})

pergunte(cPerg,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/06/09   บฑฑ
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

Local aVerbas	:= {}
Local nOrdem
Local nCount 	:= 1
Local cArqTmp 	:= CriaTrab(,.f.)
Local cCols 	:= 0
Local cStrVerba := ''
nOrdem   		:= aReturn[8]

nVerbas := (Len(alltrim(MV_PAR09)) + Len(alltrim(MV_PAR10)) + Len(alltrim(MV_PAR11))) / 3
cStrPD  := alltrim(MV_PAR09+MV_PAR10+MV_PAR11)

cQuery := "SELECT SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRD.RD_CC, SRD.RD_DATARQ " + Chr(13) + Chr(10)
For nX := 1 to nVerbas
	if Len(Substr(alltrim(cStrPD),nCount,3)) == 3
		cVerba := Substr(alltrim(cStrPD),nCount,3)
		cQuery += ", " + Chr(13) + Chr(10)
		cQuery += "		(SELECT SUM(A.RD_VALOR) " + Chr(13) + Chr(10)
		cQuery += "			FROM "+RetSQLName("SRD")+" A, "+RetSQLName("SRA")+" B " + Chr(13) + Chr(10)
		cQuery += "			WHERE A.RD_MAT		= B.RA_MAT " + Chr(13) + Chr(10)
		cQuery += "			AND A.RD_PD			= '"+ cVerba +"' " + Chr(13) + Chr(10)
		cQuery += "			AND A.RD_FILIAL		= SRD.RD_FILIAL " + Chr(13) + Chr(10)
		cQuery += "			AND A.RD_MAT		= SRD.RD_MAT   " + Chr(13) + Chr(10)
		cQuery += "			AND A.RD_DATARQ		= SRD.RD_DATARQ " + Chr(13) + Chr(10)
		cQuery += "			AND A.RD_CC			= SRD.RD_CC " + Chr(13) + Chr(10)
		cQuery += "			AND A.D_E_L_E_T_	= '' " + Chr(13) + Chr(10)
		cQuery += "			AND B.D_E_L_E_T_	= '') AS VERBA"+ cVerba +" " + Chr(13) + Chr(10)
		
		cStrVerba += cVerba+"/" 
		aAdd(aVerbas, "VERBA"+ cVerba	)
	Endif
	nCount += 3
Next nX

cQuery += " FROM "+RetSQLName("SRD")+" SRD, "+RetSQLName("SRA")+" SRA " + Chr(13) + Chr(10)
cQuery += " WHERE SRD.RD_MAT 		= SRA.RA_MAT " + Chr(13) + Chr(10)
cQuery += "   AND SRD.RD_PD			IN " + FormatIn(cStrVerba, '/') + Chr(13) + Chr(10)
cQuery += "   AND SRD.RD_FILIAL  	>= '"+MV_PAR01+"'	AND SRD.RD_FILIAL	<= '"+MV_PAR02+"' " + Chr(13) + Chr(10)
cQuery += "   AND SRD.RD_DATARQ		>= '"+MV_PAR07+"'	AND SRD.RD_DATARQ	<= '"+MV_PAR08+"' " + Chr(13) + Chr(10)
cQuery += "   AND SRD.RD_MAT		>= '"+MV_PAR03+"'	AND SRD.RD_MAT		<= '"+MV_PAR04+"' " + Chr(13) + Chr(10)
cQuery += "   AND SRD.RD_CC			>= '"+MV_PAR05+"'	AND SRD.RD_CC		<= '"+MV_PAR06+"' " + Chr(13) + Chr(10)
cQuery += "   AND SRD.D_E_L_E_T_ 	=  '' " + Chr(13) + Chr(10)
cQuery += "   AND SRA.D_E_L_E_T_ 	=  '' " + Chr(13) + Chr(10)
cQuery += " GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRD.RD_CC, SRD.RD_DATARQ " + Chr(13) + Chr(10)
cQuery += " ORDER BY SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRD.RD_CC, SRD.RD_DATARQ " + Chr(13) + Chr(10)
//MemoWrite("c:\QUERY.TXT",cQuery) - Grava um arquivo com o conteudo da query no c:\.
MsAguarde( {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)},"Aguarde...","Processando Dados. Este processo pode demorar alguns minutos...")

DbSelectArea("TRB")
DbGoTop()

cLin := '<html>'
cLin += '	<body>'
cLin += '	<Table border="1">'               

cLin +='<tr>' 
cLin +='	<td><B>OUTROS</B></td>'
cLin +='	<td bgcolor = "#C1FFC1"><B>FษRIAS</B></td>'
cLin +='	<td bgcolor = "#FFF68F"><B>13บ SALมRIO</B></td>''
cLin +='</tr>'
cLin +='<tr>' 
cLin +='	<td bgcolor = "#ADD8E6" ><B>FILIAL</B></td>'
cLin +='	<td bgcolor = "#ADD8E6"><B>MATRICULA</B></td>'
cLin +='	<td bgcolor = "#ADD8E6"><B>NOME</B></td>'
cLin +='	<td bgcolor = "#ADD8E6"><B>COMPETสNCIA</B></td>'
cLin +='	<td bgcolor = "#ADD8E6"><B>CENTRO CUSTO</B></td>'
For I := 1 to Len(aVerbas)
	cLin +='	<td bgcolor = "#ADD8E6"><B>'+ Substr(aVerbas[I],6,3)+" - "+ Posicione("SRV",1, xFilial("SRV")+Substr(aVerbas[I],6,3),"RV_DESC")+'</B></td>'
Next I		              
cLin +='</tr>'

While !EOF()       
	cLin +='<tr>'
	cLin +='	<td>'+TRB->RD_FILIAL+'</td>'
	cLin +='	<td>'+TRB->RD_MAT+'</td>'
	cLin +='	<td>'+TRB->RA_NOME+'</td>'
	cLin +='	<td>'+TRB->RD_DATARQ+'</td>' 
	cLin +='	<td>'+TRB->RD_CC+'</td>'
	For I := 1 to Len(aVerbas)
	    if Posicione("SRV",1, xFilial("SRV")+Substr(aVerbas[I],6,3),"RV_REFFER") == "S"
			cLin +='	<td bgcolor = "#C1FFC1">'+Transform(&(TRB->(aVerbas[I])),"@E 999,999.99")+'</td>'
		Elseif	Posicione("SRV",1, xFilial("SRV")+Substr(aVerbas[I],6,3),"RV_REF13") == "S"		
			cLin +='	<td bgcolor = "#FFF68F">'+Transform(&(TRB->(aVerbas[I])),"@E 999,999.99")+'</td>'
		Else			                                                              
			cLin +='	<td>'+Transform(&(TRB->(aVerbas[I])),"@E 999,999.99")+'</td>'
		Endif	
	Next I		                 
	cLin +='</tr>'
	TRB->(DbSkip())
Enddo             

cLin += '	</table>'
cLin += '	</body>'
cLin += '</html>'

MemoWrite("c:\Protheus.html",cLin)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("c:\Protheus.html")
	oExcelApp:SetVisible(.T.)
TRB->( DbCloseArea())     


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MS_FLUSH()

Return
