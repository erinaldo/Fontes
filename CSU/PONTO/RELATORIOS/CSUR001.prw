#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSUR001   บ Autor ณ SILVANO FRANCA     บ Data ณ  10/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE HORAS EXTRAS.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSUR001()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


Local titulo       	 	:= "Relat๓rio de horas extras"
Local cDesc1			:= "Este programa tem como objetivo gerar uma planilha "
Local cDesc2			:= "excel com os eventos da tabela de apontamentos do   "
Local cDesc3         	:= "perํodo que estแ aberto. "

Local cPict          	:= ""
Local nLin         	 	:= 80
Local Cabec1       		:= "FL	        DATA		C.CUSTO	        	UNID	MATR	NOME	                      	50% H.E		60% H.E		80% H.E		100% H.E	TOTAL H.E	SETOR					EQUIPE	NOME SUPER"
Local Cabec2       		:= "  "
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

Private wnrel     		:= "CSUR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SRA"
Private nomeprog        := "CSUR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private cPerg       	:= PADR("CSUHE1",LEN(SX1->X1_GRUPO))
Private aOrd       		:= {"Filial + Matrํcula + Data"}

PutSx1(cPerg, "01","Filial De                     ","","","mv_ch1","C",02,0,0,"G",""							, "SM0","","","mv_par01"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Filial inicial"			},{},{})
PutSx1(cPerg, "02","Filial At้                    ","","","mv_ch2","C",02,0,0,"G","NaoVazio"					, "SM0","","","mv_par02"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                  ","","","mv_ch3","C",06,0,0,"G",""  							, "SRA","","","mv_par03"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Matrํcula inicial"		},{},{})
PutSx1(cPerg, "04","Matricula at้                 ","","","mv_ch4","C",06,0,0,"G","NaoVazio"					, "SRA","","","mv_par04"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Matrํcula final"			},{},{})
PutSx1(cPerg, "05","Centro de Custo de            ","","","mv_ch5","C",09,0,0,"G",""  							, "CTT","","","mv_par05"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Centro de custo inicial"	},{},{})
PutSx1(cPerg, "06","Centro de Custo at้           ","","","mv_ch6","C",09,0,0,"G","NaoVazio"					, "CTT","","","mv_par06"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Centro de custo final"	},{},{})
PutSx1(cPerg, "07","Data de                       ","","","mv_ch7","D",08,0,0,"G","NaoVazio"	   				, ""   ,"","","mv_par07"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Data inicial"				},{"perํodo mแximo = 5 dias"},{})
PutSx1(cPerg, "08","Data at้                      ","","","mv_ch8","D",08,0,0,"G","U_ValDtHE()"				    , ""   ,"","","mv_par08"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Data final"				},{"perํodo mแximo = 5 dias"},{})
PutSx1(cPerg, "09","Eventos                       ","","","mv_ch9","C",60,0,0,"G","fVerbas(NIL,MV_PAR09,20)"	, ""   ,"","","mv_par09"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",{"Eventos a considerar"		},{},{})

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

nOrdem   		:= aReturn[8]


cQuery := "SELECT SPC.PC_FILIAL,  "+ Chr(13) + Chr(10)
cQuery += " 	SUBSTRING(SPC.PC_DATA,7,2) +'/'+ SUBSTRING(SPC.PC_DATA,5,2) +'/'+ SUBSTRING(SPC.PC_DATA,1,4) AS DATAEV, "+ Chr(13) + Chr(10)
cQuery += "	SPC.PC_CC, SPC.PC_MAT, SRA.RA_NOME "+ Chr(13) + Chr(10)
   
nEventos := Len(alltrim(MV_PAR09))
nEventos := nEventos / 3
For nX := 1 to nEventos
	if Len(Substr(alltrim(MV_PAR09),nCount,3)) == 3
		cQuery += " , "
		cQuery += "		(SELECT SUM(A.PC_QUANTC) "+ Chr(13) + Chr(10)
		cQuery += " FROM "+RetSQLName("SPC")+"    A, "+RetSQLName("SRA")+" B, "+RetSQLName("SP9") +" C "+ Chr(13) + Chr(10)
		cQuery += "	WHERE A.PC_MAT = B.RA_MAT "+ Chr(13) + Chr(10)
		cQuery += "	AND C.P9_CODFOL = '"+ Substr(alltrim(MV_PAR09),nCount,3)+"' "+ Chr(13) + Chr(10)
		cQuery += "	AND A.PC_PD =  C.P9_CODIGO "+ Chr(13) + Chr(10)
		cQuery += "	AND A.PC_FILIAL	= SPC.PC_FILIAL "+ Chr(13) + Chr(10)
		cQuery += "	AND A.PC_MAT = SPC.PC_MAT   "+ Chr(13) + Chr(10)
		cQuery += "	AND A.PC_DATA = SPC.PC_DATA "+ Chr(13) + Chr(10)
		cQuery += "	AND A.PC_CC	= SPC.PC_CC "+ Chr(13) + Chr(10)
		cQuery += "	AND A.D_E_L_E_T_	 = '' "+ Chr(13) + Chr(10)
		cQuery += "	AND B.D_E_L_E_T_ = '' "+ Chr(13) + Chr(10)
		cQuery += "	AND C.D_E_L_E_T_	 = '' ) AS EVENTO"+Substr(alltrim(MV_PAR09),nCount,3)+" "+ Chr(13) + Chr(10)

		aAdd(aVerbas, "EVENTO"+Substr(alltrim(MV_PAR09),nCount,3)	)

	Endif
	nCount += 3
Next nX

cQuery += " FROM "+RetSQLName("SPC")+"  SPC, "+RetSQLName("SRA")+" SRA "				+ Chr(13) + Chr(10)
cQuery += " WHERE SPC.PC_FILIAL = SRA.RA_FILIAL "										+ Chr(13) + Chr(10)
cQuery += "   AND SPC.PC_MAT = SRA.RA_MAT "												+ Chr(13) + Chr(10)
cQuery += "   AND SPC.PC_FILIAL  	>= '"+MV_PAR01+"'		AND SPC.PC_FILIAL	<= '"+MV_PAR02+"' "+ Chr(13) + Chr(10)
cQuery += "   AND SPC.PC_DATA		>= '"+DtoS(MV_PAR07)+"'	AND SPC.PC_DATA		<= '"+DtoS(MV_PAR08)+"' "+ Chr(13) + Chr(10)
cQuery += "   AND SPC.PC_MAT		>= '"+MV_PAR03+"'		AND SPC.PC_MAT		<= '"+MV_PAR04+"' "+ Chr(13) + Chr(10)
cQuery += "   AND SPC.PC_CC			>= '"+MV_PAR05+"'		AND SPC.PC_CC		<= '"+MV_PAR06+"' "+ Chr(13) + Chr(10)
cQuery += "   AND SPC.D_E_L_E_T_ = '' "+ Chr(13) + Chr(10)
cQuery += "   AND SRA.D_E_L_E_T_ = '' "+ Chr(13) + Chr(10)
cQuery += " GROUP BY SPC.PC_FILIAL, SPC.PC_DATA, SPC.PC_CC, SPC.PC_MAT, SRA.RA_NOME	 "+ Chr(13) + Chr(10)
cQuery += " ORDER BY SPC.PC_FILIAL, SPC.PC_MAT, SPC.PC_DATA, SPC.PC_CC "+ Chr(13) + Chr(10)
MemoWrite("c:\QUERY.TXT",cqUERY)

MsAguarde( {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)},"Aguarde...","Processando Dados. Este processo pode demorar...")

DbSelectArea("TRB")
DbGoTop()

cLin := '<html>'
cLin += '	<body>'
cLin += '	<Table border="1">'

cLin +='<tr>'
cLin +='	<td>FILIAL</td>'
cLin +='	<td>DATA</td>' 
cLin +='	<td>CENTRO CUSTO</td>'
cLin +='	<td>UNIDADE</td>'
cLin +='	<td>MATRICULA</td>'
cLin +='	<td>NOME</td>'
For I := 1 to Len(aVerbas)
	cLin +='	<td>'+Posicione("SRV",1, xFilial("SRV")+Substr(aVerbas[I],7,3),"RV_DESC")+'('+Substr(aVerbas[I],7,3)+')'+'</td>'
Next I		              

cLin +='	<td>TOTAL</td>'
cLin +='	<td>SETOR</td>'
cLin +='	<td>EQUIPE</td>'
cLin +='	<td>NOME SUPERVISOR</td>'
cLin +='</tr>'

While !EOF()       
	nValor := 0
	For I := 1 to Len(aVerbas)
		nValor += &(TRB->(aVerbas[I]))
	Next I		     
	if nValor > 0
	cLin +='<tr>'
	SRA->(DbSeek(TRB->PC_FILIAL+TRB->PC_MAT))
	cLin +='	<td>'+TRB->PC_FILIAL+'</td>'
	cLin +='	<td>'+TRB->DATAEV+'</td>' 
	cLin +='	<td>'+TRB->PC_CC+'</td>'
	cLin +='	<td>'+Substr(SRA->RA_ITEMD,1,2)+'</td>'
	cLin +='	<td>'+TRB->PC_MAT+'</td>'
	cLin +='	<td>'+TRB->RA_NOME+'</td>'
	For I := 1 to Len(aVerbas)
		cLin +='	<td>'+Transform(&(TRB->(aVerbas[I])),"@E 999,999.99")+'</td>'
	Next I		                 
	cLin +='	<td>'+Transform(nValor,"@E 999,999.99")+'</td>'
	cLin +='	<td>'+Posicione("CTT",1,xFilial("CTT")+TRB->PC_CC,"CTT_DESC01")+'</td>'
	cLin +='	<td>'+Posicione("SZM",1,xFilial("SZM")+SRA->RA_EQUIPE,"ZM_DESCR")+'</td>'
	cLin +='	<td>'+Posicione("SZM",1,xFilial("SZM")+SRA->RA_EQUIPE,"ZM_NOMES")+'</td>'  
	cLin +='</tr>'
	endif
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

User Function ValDtHE()

if (MV_Par08 - MV_par07) < 0
    Alert("A data de nใo pode ser superior a data at้")
	MV_Par08 := CtoD("  /  /  ")
Endif    

If (MV_Par08 - MV_par07) > 5
   Alert("O perํodo informado nใo pode ser superior a 5 dias.")
	MV_Par08 := CtoD("  /  /  ")
Endif                             


Return

