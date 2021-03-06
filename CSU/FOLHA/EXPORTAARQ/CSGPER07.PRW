#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#DEFINE      cSep     ";"
#DEFINE      cEol     Chr(13) + Chr(10)

User Function WFGPER07()
Return u_CSGPER07()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSGPER07	� Autor � Isamu K.         � Data � 12/12/2016    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RELATORIO de PROGRAMACAO DE FERIAS VIA SCHEDULE   		  ���
���			 � com o objetivo de atender a O.S. 3296/16    	    		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSGPER07                                        
                 

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"

Private dHoje	 :=DTOS(Date())
PRIVATE dMES	 :=CVALTOCHAR(MONTH(dDataBase))
PRIVATE dANO	 :=CVALTOCHAR(YEAR(dDataBase)) 
PRIVATE nMES	 :=MONTH(dDataBase)
Private aArea := GetArea()
Private oGeraTxt
Private oHTML
Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".txt"
Private aArea := GetArea()

CsuProg(cCmd)

RESET ENVIRONMENT


RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSUPROG	� Autor � FERNANDO BARRETO      � Data � Jan/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o de processamento do relatorio                       ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��  w
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CSUPROG(cCmd)

Processa( { || OkProc() }, "Executando o Processamento..." )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OKPROC    �Autor  �Isamu K.	         � Data �  19/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Processa o relatorio excel.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSGPER04                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function OkProc()

Local nCnt := 0
Local aCabExcel :={}
Local aItensExcel :={}
Local cArquivo  := "\WFM\SRC\"
                                        
Private cData     := dTos(dDataBase)

cArquivo := cArquivo+"programacao_ferias_price.csv"

nHdl  := fCreate( cArquivo )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

IF nMes <= 9
	dDataIni :=dANO+"0"+dMES+"01"
else
	dDataIni :=dANO+dMES+"01"
endif

IF Select("CONS")>0
	CONS->(dbCloseArea())
Endif

cCONS :="SELECT DISTINCT RA_FILIAL,RA_MAT, RA_NOME,RA_CIC,RA_RG,RA_CC,RA_SITFOLH, RA_HRSMES, RA_ADMISSA, CTT_DESC01,Q3_DESCSUM, CTD_DESC01, "
cCONS +="CTH_DESC01, RF_DFALAAT, RF_DFALVAT, RF_DFERVAT, RF_DFERAAT,R8_TIPO,X5_DESCRI,DATEDIFF( MONTH ,RF_DATABAS,'"+dHoje+"') AS VENCIDO,  "
cCONS +="R8_DATAINI,R8_DATAFIM,RF_DATABAS "
cCONS +="FROM  "+RetSqlName('SRA')+" SRA "
cCONS +="LEFT JOIN "+RetSqlName('SRF')+ " SRF ON RA_MAT=RF_MAT AND RA_FILIAL=RF_FILIAL AND SRF.D_E_L_E_T_='' "
cCONS +="LEFT JOIN "+RetSqlName('SR8')+ " SR8 ON RA_MAT=R8_MAT AND RA_FILIAL=R8_FILIAL AND SR8.D_E_L_E_T_=''AND(R8_DATAFIM>= '"+dDataIni+"'  OR R8_DATAFIM='') "
cCONS +="LEFT JOIN "+RetSqlName('SQ3')+ " SQ3 ON RA_CARGO=Q3_CARGO AND SQ3.D_E_L_E_T_='' "  
cCONS +="LEFT JOIN "+RetSqlName('SX5')+ " SX5 ON X5_TABELA='30' AND X5_CHAVE=R8_TIPO AND SX5.D_E_L_E_T_='', "
cCONS +=RetSqlName('CTT')+ " CTT, "+RetSqlName('CTD')+ " CTD, "+RetSqlName('CTH')+ " CTH "
cCONS +="WHERE RA_MAT BETWEEN '0' AND '999999' "
cCONS +="AND RA_FILIAL BETWEEN '00' AND '99' "
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

//Monta cabe�alho
cLin := "FILIAL"+cSep
cLin += "MATRICULA"+cSep
cLin += "NOME"+cSep
cLin += "CPF"+cSep
cLin += "RG"+cSep
cLin += "COD.CUSTO"+cSep
cLin += "DESCR.CCUSTO"+cSep
cLin += "OPERA��O"+cSep
cLin += "FUN��O"+cSep
cLin += "UNIDADE"+cSep
cLin += "ADMISS�O"+cSep
cLin += "SITUA��O"+cSep
cLin += "MESES VENC."+cSep
cLin += "TIPO AFAST."+cSep
cLin += "DESCRI��O"+cSep
cLin += "DATA INICIO"+cSep
cLin += "DATA FIM"+cSep
cLin += "HRS MES"+cSep
cLin += "DIA VENC."+cSep
cLin += "FALTAS VENC"+cSep
cLin += "DIAS PROPOR."+cSep
cLin += "FALTAS PROPOR"+cSep
cLin += "DATA LIMITE"+cSep
cLin += "AQUISIT.DE"+cSep
cLin += "AQUISIT.ATE"+cEol

fGravaTxt(cLin)

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

	cLin := "'" + cFil + cSep 
	cLin += "'" + cMat + cSep
	cLin += cNome + cSep
	cLin += "'" + cCpf + cSep
	cLin += "'" + cRg + cSep
	cLin += "'" + cCCt + cSep
	cLin += cCC + cSep
	cLin += "'" + cOperacao + cSep
	cLin += "'" + cFuncao + cSep
	cLin += "'" + cUnid + cSep 
	cLin += Dtoc(dAdmissa) + cSep
	cLin += cSitF + cSep 
	cLin += Transform(dVenc,"@E 99") + cSep
	cLin += cSit + cSep 
	cLin += cDesc + cSep 
	cLin += Dtoc(dAfastI) + cSep
	cLin += Dtoc(dAfastF) + cSep
	cLin += Transform(cHMes,"@E 999.99") + cSep 
	cLin += "'" + Transform(nVenc,"@E 99") + cSep 
	cLin += "'" + Transform(nFaVenc,"@E 99") + cSep 
	cLin += "'" + Transform(nDiaProp,"@E 99") + cSep 
	cLin += "'" + Transform(nFalProp,"@E 99") + cSep 
	cLin += Dtoc(dLimite) + cSep
	cLin += Dtoc(dtDe) + cSep
	cLin += dtAte + cEol

	fGravaTxt(cLin)
	
	DBSKIP()       
	
ENDDO

fClose( nHdl )

__CopyFile( GetSrvProfString("StartPath","")+cArquivo, "programacao_ferias_price.csv" )


Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGPEM02   �Autor  �Microsiga           � Data �  01/25/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGravaTxt( cLinha )

If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return