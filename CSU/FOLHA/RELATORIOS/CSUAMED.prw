#include "protheus.ch"
#include "apcfg40.ch"
#include "TOPCONN.CH"

Static aAcessos
Static aModulos
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUAMED³ Autor ³ Douglas David           ³ Data ³ Jul/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatório Assistência Médica								  ³±±
±±³			 ³ Com o objetivo de atender a O.S. 1918/13					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUAMED()
Local wnrel:= "CSUAMED"
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "Relatorio Assistencia Medica"
Local cDesc1     := "Relatorio Assistencia Medica"
Local cDesc2     := "Impressão de dados Tabela RHK x Base Inter Notre(SRA)"
Local cDesc3     := " "
Local Pg		 := "CSUAMED"
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administração"
Private nomeprog := "ASS.MEDICA"
Private nLastKey
Private cString  := ""
PRIVATE M_PAG	 :=1


ValidPerg(Pg)
Pergunte(Pg,.T.)
wnrel := SetPrint(cString,wnrel,Pg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,{},,tamanho,,.T.)
If nLastKey = 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
EndIf
nTipo := IF(aReturn[4] == 1, 15, 18)
Processa( {|lEnd| CSUPROGMED(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUPROGMED	³ Autor ³ Douglas David     ³ Data ³ Jul/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CSUPROGMED(lEnd)
Local nCnt := 0
Local wnrel:= "CSUAMED"
Local aCabExcel :={}
Local aItensExcel :={}

IF Select("CONS")>0
	CONS->(dbCloseArea())
Endif

cCONS :="SELECT DISTINCT RA_CIC, RA_FILIAL, RA_MAT, RA_NOME, RJ_DESC, RA_GS, RA_NASC, RA_ADMISSA, RA_DEMISSA, RA_SEXO, RA_ESTCIVI, "
cCONS +="RA_ENDEREC, RA_COMPLEM, RA_BAIRRO, RA_MUNICIP, RA_ESTADO, RA_CEP, RA_MAE, RA_PIS, RA_HRSMES, RG_TIPORES, "
cCONS +="RHK_PLANO, RHK_PD, RHK_PDDAGR, RCC_CONTEU, SUBSTRING (RCC_CONTEU,3,20) AS CONTEUDO, RB_NOME "
cCONS +="FROM  "+RetSqlName('SRA')+" SRA "                            	
cCONS +="LEFT JOIN "+RetSqlName('SRJ')+ " SRJ ON RA_CODFUNC=RJ_FUNCAO AND SRJ.D_E_L_E_T_ ='' "
cCONS +="LEFT JOIN "+RetSqlName('SRG')+ " SRG ON RA_FILIAL=RG_FILIAL AND RA_MAT=RG_MAT AND SRG.D_E_L_E_T_=''"
cCONS +="LEFT JOIN "+RetSqlName('RHK')+ " RHK ON RA_FILIAL=RHK_FILIAL AND RA_MAT=RHK_MAT AND RHK.D_E_L_E_T_=''"  
cCONS +="LEFT JOIN "+RetSqlName('RHL')+ " RHL ON RHK_FILIAL=RHL_FILIAL AND RHK_MAT=RHL_MAT AND RHK_PLANO=RHL_PLANO AND RHL.D_E_L_E_T_=''"
cCONS +="LEFT JOIN "+RetSqlName('SRB')+ " SRB ON RHL_FILIAL=RB_FILIAL AND RHL_MAT=RB_MAT AND RHL_CODIGO=RB_COD AND SRB.D_E_L_E_T_= ''"   
cCONS +="LEFT JOIN "+RetSqlName('RCC')+ " RCC ON RCC_CODIGO='S008' AND SUBSTRING (RCC_CONTEU,1,2)=RHK_PLANO AND RCC.D_E_L_E_T_='' "
cCONS +="WHERE RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cCONS +="AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cCONS +="AND (RA_DEMISSA = '' OR RA_DEMISSA BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"') "
cCONS +="AND RHK.RHK_TPFORN <> '2' "
cCONS +="AND SRA.D_E_L_E_T_='' "
cCONS +="ORDER BY RA_MAT"

nCnt:= U_MontaView(cCons,"CONS")
DBSELECTAREA("CONS")
CONS->(dbGoTop())
ProcRegua(nCnt)                           	

WHILE !CONS->(eof())
	IncProc("Processando Filial/Matricula: "+CONS->RA_FILIAL+"-"+CONS->RA_MAT)
	cCPF:= CONS->RA_CIC
	cFil:= CONS->RA_FILIAL
	cMat:= CONS->RA_MAT
	cNome:=CONS->RA_NOME
	cDesc:=CONS->RJ_DESC
	cGs	 :=CONS->RA_GS
	dNasc:=STOD(CONS->RA_NASC)
	dAdmissa:=STOD(CONS->RA_ADMISSA)
	dDemissa:=STOD(CONS->RA_DEMISSA)
	cSexo:=CONS->RA_SEXO
	cCiv:=CONS->RA_ESTCIVI
	cEnd:=CONS->RA_ENDEREC
	cCompl:=CONS->RA_COMPLEM
	cBairro:=CONS->RA_BAIRRO
	cMunicip:=CONS->RA_MUNICIP
	cEstado:=CONS->RA_ESTADO
	cCep:=CONS->RA_CEP
	cMae:=CONS->RA_MAE
	cPis:=CONS->RA_PIS	
	cCep:=SUBSTR(CONS->RA_CEP,1,5)+"-"+SUBSTR(CONS->RA_CEP,6,3)
	cHmes:=CONS->RA_HRSMES
	cTpres:=CONS->RG_TIPORES
	cPlano:=CONS->RHK_PLANO
	cPd:=CONS->RHK_PD
	cPddagr:=CONS->RHK_PDDAGR
	cConteudo:=SUBSTR(CONS->RCC_CONTEU,3,20)
	cDepend:=CONS->RB_NOME

	
	AADD(aItensExcel,{cCPF,cFil,cMat,cNome,cDesc,cGs,dNasc,dAdmissa,dDemissa,cSexo,cCiv,cEnd,cCompl,cBairro,cMunicip,cEstado,cCep,;
	cMae,cPis,cHmes,cTpres,cPlano,cPd,cPddagr,cConteudo,cDepend,})
	
	DBSKIP()
ENDDO
//CRIA CABECALHO
AADD(aCabExcel, {"CPF" ,"C", 11, 0})
AADD(aCabExcel, {"Filial" ,"C", 02, 0})
AADD(aCabExcel, {"Matricula" ,"C", 06, 0})
AADD(aCabExcel, {"Nome" ,"C", 45, 0})
AADD(aCabExcel, {"Descrição" ,"C", 40, 0}) 
AADD(aCabExcel, {"GS" ,"C", 02, 0})
AADD(aCabExcel, {"Data Nasc." ,"C", 10, 0})
AADD(aCabExcel, {"Data Admis." ,"C", 10, 0}) 
AADD(aCabExcel, {"Data Demissão" ,"C", 10, 0})
AADD(aCabExcel, {"Tipo Resc. Sexo" ,"C", 01, 0})
AADD(aCabExcel, {"Est. Civil" ,"C", 01, 0})
AADD(aCabExcel, {"Endereço" ,"C", 45, 0})
AADD(aCabExcel, {"Compl.Ender." ,"C", 15, 0})
AADD(aCabExcel, {"Bairro" ,"C", 30, 0})
AADD(aCabExcel, {"Municipio" ,"C", 30, 0})
AADD(aCabExcel, {"Estado" ,"C", 02, 0})
AADD(aCabExcel, {"Cep" ,"C", 08, 0})
AADD(aCabExcel, {"Nome Mãe" ,"C", 40, 0})
AADD(aCabExcel, {"P.I.S." ,"C", 12, 0})
AADD(aCabExcel, {"Hrs. Mensais" ,"C", 03, 0})
AADD(aCabExcel, {"Cd.Resc.RAIS" ,"C", 02, 0})
AADD(aCabExcel, {"Código Plano" ,"C", 02, 0})
AADD(aCabExcel, {"Verb Titular" ,"C", 03, 0})
AADD(aCabExcel, {"Verb Dep/Agr" ,"C", 03, 0})
AADD(aCabExcel, {"Descrição Microsiga" ,"C", 45, 0})
AADD(aCabExcel, {"Dependente" ,"C", 40, 0})

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
{||DlgToExcel({{"GETDADOS", "RELATÓRIO DE ASSISTÊNCIA MÉDICA", aCabExcel,aItensExcel}})})
return


If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³ Douglas David 	    ³ Data ³ Jul/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função para criação do SX1 da rotina                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}
aAdd(aRegs,{_cPerg,"01","Filial de           		  ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial ate           		  ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","Matrícula de            	  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"04","Matrícula ate         	  	  ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"05","Demitidos de         	  	  ?","","","mv_ch5","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"06","Demitidos ate         	  	  ?","","","mv_ch6","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})



For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])//SALVA O CONTEUDO DO ARRAY NO BANCO
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return


