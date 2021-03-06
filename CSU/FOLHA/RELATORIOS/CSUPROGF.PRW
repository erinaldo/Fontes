#include "protheus.ch"
#include "apcfg40.ch"
#include "TOPCONN.CH"

Static aAcessos
Static aModulos
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSUPROGF	� Autor � FERNANDO BARRETO      � Data � Jan/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RELATORIO de PROGRAMACAO DE FERIAS						  ���
���			 � com o objetivo de atender o chamado 0258/12				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUPROGF()
Local wnrel:= "CSUPROGF"
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "RELATORIO PROGRAMACAO DE FERIAS"
Local cDesc1     := "RELATORIO PROGRAMACAO DE FERIAS"
Local cDesc2     := "Ira imprimir a programacao de f�rias"
Local cDesc3     := " "
Local Pg		 := "CSUPROGF"
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administra��o"
Private nomeprog := "PROG.FERIAS"
Private nLastKey
Private cString  := ""
PRIVATE M_PAG	 :=1
Private dHoje	 :=DTOS(Date())
PRIVATE dMES	 :=CVALTOCHAR(MONTH(dDataBase))
PRIVATE dANO	 :=CVALTOCHAR(YEAR(dDataBase)) 
PRIVATE nMES	 :=MONTH(dDataBase)
//PRIVATE MES_SEG	 :=CVALTOCHAR(MONTH(dDataBase)+1)


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
Processa( {|lEnd| CSUPROG(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSUPROG	� Autor � FERNANDO BARRETO      � Data � Jan/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o de processamento do relatorio                       ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CSUPROG(lEnd)
Local nCnt := 0
Local wnrel:= "CSUPROGF"
Local aCabExcel :={}
Local aItensExcel :={}

/*
����������������������������������������������������Ŀ
|      	RELATORIO PROGRAMACAO DE FERIAS			     |
������������������������������������������������������
*/
/*IF MES_SEG=='13'
	MES_SEG:='01'
	ANO_SEG:=CVALTOCHAR(YEAR(dDataBase)+1)
ELSE
	ANO_SEG:=CVALTOCHAR(YEAR(dDataBase))
ENDIF*/
IF nMes <= 9
	dDataIni :=dANO+"0"+dMES+"01"
else
	dDataIni :=dANO+dMES+"01"
endif
//dDataFim :=ANO_SEG+"0"+MES_SEG+"01

IF Select("CONS")>0
	CONS->(dbCloseArea())
Endif

cCONS :="SELECT DISTINCT RA_FILIAL,RA_MAT, RA_NOME,RA_CIC,RA_RG,RA_CC,RA_SITFOLH, RA_HRSMES, RA_ADMISSA, CTT_DESC01,Q3_DESCSUM, CTD_DESC01, "
cCONS +="CTH_DESC01, RF_DFALAAT, RF_DFALVAT, RF_DFERVAT, RF_DFERAAT,R8_TIPO,X5_DESCRI,DATEDIFF( MONTH ,RF_DATABAS,'"+dHoje+"') AS VENCIDO,  "
cCONS +="R8_DATAINI,R8_DATAFIM,RF_DATABAS "//,YEAR(RF_DATABAS)AS AQUIS_DE"
cCONS +="FROM  "+RetSqlName('SRA')+" SRA "
cCONS +="LEFT JOIN "+RetSqlName('SRF')+ " SRF ON RA_MAT=RF_MAT AND RA_FILIAL=RF_FILIAL AND SRF.D_E_L_E_T_='' "
cCONS +="LEFT JOIN "+RetSqlName('SR8')+ " SR8 ON RA_MAT=R8_MAT AND RA_FILIAL=R8_FILIAL AND SR8.D_E_L_E_T_=''AND(R8_DATAFIM>= '"+dDataIni+"'  OR R8_DATAFIM='') "
cCONS +="LEFT JOIN "+RetSqlName('SQ3')+ " SQ3 ON RA_CARGO=Q3_CARGO AND SQ3.D_E_L_E_T_='' "  // OS 2101/13
cCONS +="LEFT JOIN "+RetSqlName('SX5')+ " SX5 ON X5_TABELA='30' AND X5_CHAVE=R8_TIPO AND SX5.D_E_L_E_T_='', "
cCONS +=RetSqlName('CTT')+ " CTT, "+RetSqlName('CTD')+ " CTD, "+RetSqlName('CTH')+ " CTH "
cCONS +="WHERE RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cCONS +="AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
// 	cCONS +="AND RF_DATABAS BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
cCONS +="AND RA_SITFOLH!='D' "
cCONS +="AND RA_CC=CTT_CUSTO "
cCONS +="AND RA_ITEMD=CTD_ITEM "
cCONS +="AND RA_CLVLDB=CTH_CLVL "
cCONS +="AND SRA.D_E_L_E_T_='' "
cCONS +="AND CTT.D_E_L_E_T_='' "
cCONS +="AND CTD.D_E_L_E_T_='' "
cCONS +="AND CTH.D_E_L_E_T_='' "
cCONS +="ORDER BY 1,2,3 "

nCnt:= U_MontaView(cCons,"CONS")
DBSELECTAREA("CONS")
CONS->(dbGoTop())
ProcRegua(nCnt)

WHILE !CONS->(eof())
	IncProc("Processando Filial/Matricula: "+CONS->RA_FILIAL+"-"+CONS->RA_MAT)
	cFil:= CONS->RA_FILIAL
	cMat:= CONS->RA_MAT
	cNome:= CONS->RA_NOME
	cCCT:= CONS->RA_CC
	cCC:=CONS->CTT_DESC01
	cCPF:= CONS->RA_CIC
	cRG:=CONS->RA_RG
	cSITF:=CONS->RA_SITFOLH
	cSit:=CONS->R8_TIPO
	cHmes:=CONS->RA_HRSMES
	dAdmissa:=STOD(CONS->RA_ADMISSA)
	cOperacao:=CONS->CTD_DESC01
	cFuncao:=CONS->Q3_DESCSUM
	cUnid:=CONS->CTH_DESC01
	nVenc:=CONS->RF_DFERVAT
	nFaVenc:=CONS->RF_DFALVAT
	nDiaProp:=CONS->RF_DFERAAT
	nFalProp:=CONS->RF_DFALAAT
	cDesc:=CONS->X5_DESCRI
	dVenc:=CONS->VENCIDO
	dAfastI:=STOD(CONS->R8_DATAINI)
	dAfastF:=STOD(CONS->R8_DATAFIM)
	//calcula o proximo periodo aquisitivo
	dPerIni:=YearSum( dAfastI , 1 )
	dPerFim:=YearSum( dAfastF , 1 )
	//calcula o limite maximo
	dBase  :=STOD(CONS->RF_DATABAS)
	dLimite:=YearSum( dBase , 2 )
	dLimite:=DaySub( dLimite , 45 )
   //	dtDe:=CONS->AQUIS_DE
   	dtDe:=STOD(CONS->RF_DATABAS)
	dano:=CVALTOCHAR(YEAR(dtDe)+1)
	dtAte:=SUBSTR(CONS->RF_DATABAS,7,2)+"/"+SUBSTR(CONS->RF_DATABAS,5,2)+"/"+dano

	
	AADD(aItensExcel,{cFil,cMat,cNome,cCPF,cRG,cCCT,cCC,cOperacao,cFuncao,cUnid,dAdmissa,cSITF,dVenc,cSit,cDesc,;
	dAfastI,dAfastF,cHmes,nVenc,nFaVenc,nDiaProp,nFalProp,dLimite,dtDe,dtAte,})
	
	DBSKIP()
ENDDO
//CRIA CABECALHO
AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
AADD(aCabExcel, {"MATRICULA" ,"C", 06, 0})
AADD(aCabExcel, {"NOME" ,"C", 45, 0})
AADD(aCabExcel, {"CPF" ,"C", 11, 0})
AADD(aCabExcel, {"RG" ,"C", 8, 0})
AADD(aCabExcel, {"C_CUSTO" ,"C", 10, 0})
AADD(aCabExcel, {"DESC_CUSTO" ,"C", 40, 0})
AADD(aCabExcel, {"OPERA��O" ,"C", 20, 0})
AADD(aCabExcel, {"FUN��O" ,"C", 20, 0})
AADD(aCabExcel, {"UNIDADE" ,"C", 20, 0})
AADD(aCabExcel, {"ADMISS�O" ,"C", 10, 0})
AADD(aCabExcel, {"SITUA��O" ,"C", 02, 0})
AADD(aCabExcel, {"MESES_VENC" ,"C", 02, 0})
AADD(aCabExcel, {"TIPO_AFAST" ,"C", 02, 0})
AADD(aCabExcel, {"DESCRI��O" ,"C", 02, 0})
AADD(aCabExcel, {"DATA_INI" ,"C", 10, 0})
AADD(aCabExcel, {"DATA_FIM" ,"C", 10, 0})
AADD(aCabExcel, {"HR_MES" ,"C", 03, 0})
AADD(aCabExcel, {"DIA_VENC" ,"C", 03, 0})
AADD(aCabExcel, {"FALTAS VENC" ,"C", 03, 0})
AADD(aCabExcel, {"DIA_PROPOR" ,"C", 03, 0})
AADD(aCabExcel, {"FALTAS_PROPOR" ,"C", 03, 0})
AADD(aCabExcel, {"DATA_LIMITE" ,"C", 10, 0})
AADD(aCabExcel, {"AQUIS_DE" ,"C", 10, 0})
AADD(aCabExcel, {"AQUIS_ATE" ,"C", 10, 0})

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
{||DlgToExcel({{"GETDADOS", "RELAT�RIOS DE PROGRAMA��O DE F�RIAS", aCabExcel,aItensExcel}})})
return


If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ValidPerg � Autor � Fernando Barreto      � Data � Jan/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o para cria��o do SX1 da rotina                       ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}
aAdd(aRegs,{_cPerg,"01","Filial de           		  ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial ate           		  ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","Matr�cula de            	  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"04","Matr�cula ate         	  	  ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","          "})

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


