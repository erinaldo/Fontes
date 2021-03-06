#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FAcertaODO� Autor �Isamu K.            � Data �  17/02/2014 ���
�������������������������������������������������������������������������͹��
���Descricao �Acerta a Tabela RHS                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Exclusivo para CSU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Altera��es:
11/02/2015 - OS 0617/15 - COMENTAR ALTERA��ES NOS C�DIDOS DE ASSISTENCIA M�DICA (506 E 651).

/*/
User Function fAcertaOdo


Local cQry1     

Private cPerg := "FACERTARHS"                       

//���������������������������������������������������������������������������
//�Cria as perguntas na tabela SX1 caso n�o existam.                        �
//���������������������������������������������������������������������������
PutSx1(cPerg, "01","Filial De                     ","","","mv_ch1" 	,"C",02,0,0,"G",""											, "SM0","","","mv_par01"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial inicial"	   		    },{},{})
PutSx1(cPerg, "02","Filial At�                    ","","","mv_ch2" 	,"C",02,0,0,"G","NaoVazio"									, "SM0","","","mv_par02"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                  ","","","mv_ch3" 	,"C",06,0,0,"G",""  										, "SRA","","","mv_par03"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matr�cula inicial"			},{},{})
PutSx1(cPerg, "04","Matricula at�                 ","","","mv_ch4" 	,"C",06,0,0,"G","NaoVazio"									, "SRA","","","mv_par04"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matr�cula final"			},{},{})
PutSx1(cPerg, "05","Per�odo de (AAAAMM)           ","","","mv_ch5" 	,"C",06,0,0,"G",""  	   									, ""   ,"","","mv_par05"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Data inicial"				},{},{})
PutSx1(cPerg, "06","Per�odo at� (AAAAMM)          ","","","mv_ch6" 	,"C",06,0,0,"G",""											, ""   ,"","","mv_par06"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Data final"				    },{},{})

If !Pergunte( cPerg, .t. )
   Return
EndIf
            

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 400,480 DIALOG oLeTxt TITLE OemToAnsi("Acerto da tabela RHS ")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira importar os valores de Assistencia Medica e "
@ 18,018 Say " Odontologica do Acumulado Anual para a Tabela de Acumulado de "
@ 26,018 Say " Assistencia Medica (RHS).                                     "
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  18/05/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � Isamu K.           � Data �  04/07/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function RunCont

Local ValPlano := 0
Local aNumDep  := {}
Local cSRDFil := ""
Local cSRDMat := ""
Local cSRDDt  := ""

dbSelectArea("RHS")
cIndex := CriaTrab(nil,.f.)
cChave  := "RHS_FILIAL+RHS_MAT+RHS_COMPPG+RHS_ORIGEM+RHS_CODIGO+RHS_PD"
IndRegua("RHS",cIndex,cChave,,,"Selecionando Registros...")


cQry1 := " SELECT RD_FILIAL, RD_MAT, RD_PD, RD_VALOR, RD_DATARQ, RD_DATPGT "
cQry1 += " FROM "+RetSqlName("SRD")+ " "
cQry1 += " WHERE RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQry1 += " AND RD_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQry1 += " AND RD_DATARQ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQry1 += " AND RD_PD IN ('549','652') "
cQry1 += " AND D_E_L_E_T_ = ' ' "
cQry1 += " ORDER BY RD_FILIAL, RD_MAT, RD_DATARQ "

If Select("TMP1") > 0   
   Tmp1->(dbCloseArea())
Endif  
   
//�������������������������������������������
//�Gera o arquivo temporario da query acima.�
//�������������������������������������������
dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),"TMP1",.F.,.T.)

TMP1->( DbGoTop() )

ProcRegua(Tmp1->(RecCount()))

//�����������������������������������������������������
//�Alimenta o arquivo que sera gerado para o usuario. �
//�����������������������������������������������������
While !TMP1->( Eof() )
	
    IncProc("Importando dados: "+ TMP1->RD_FILIAL+"/"+TMP1->RD_MAT)
	
    cSRDFil := TMP1->RD_FILIAL
    cSRDMat := TMP1->RD_MAT
    cSRDDt  := TMP1->RD_DATARQ
	
	While !Tmp1->(Eof()) .and. TMP1->(RD_FILIAL+RD_MAT+RD_DATARQ)==cSRDFil+cSRDMat+cSRDDt
		
			
		If TMP1->RD_PD == "549"
			
			If RHS->(dbSeek(TMP1->( RD_FILIAL+RD_MAT+RD_DATARQ+"1"+SPACE(2)+"549") ) )
				
				RecLock("RHS",.F.)
				RHS->RHS_VLRFUN := TMP1->RD_VALOR
				MsUnlock()
				
			Endif
			
		ElseiF TMP1->RD_PD == "652"
			
		  	fContaDep(TMP1->RD_FILIAL,TMP1->RD_MAT,TMP1->RD_DATARQ,'652',@VALPLANO,@aNUMDEP)

			nTotDep := Len(aNumDep)
			
			For nX:= 1 to Len(aNumDep)
				
				nSeqDep := aNumDep[nX,1]
								
				If RHS->(dbSeek(TMP1->( RD_FILIAL+RD_MAT+RD_DATARQ+"2"+nSeqDep+"652") )  )
					
					RecLock("RHS",.F.)
					RHS->RHS_VLRFUN := TMP1->RD_VALOR/nTotDep
					MsUnlock()
					
				Endif
				
			Next

			ValPlano := 0
			aNumDep  := {}
			
		Endif
		
		Tmp1->(dbSkip())
	    cSRDFil := TMP1->RD_FILIAL
	    cSRDMat := TMP1->RD_MAT
	    cSRDDt  := TMP1->RD_DATARQ
	    cSRDPD  := TMP1->RD_PD
		
	
	EndDo
	
EndDo

Alert("Dados Importados com Sucesso !!!")

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fContaDep� Autor � Isamu K.           � Data �  04/07/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fContaDep(cFil,cMat,cDatarq,cPDx,nValPl,aDep)


Local cQry
Local aNumDep := {}
Local nVal    := 0

cQry := " SELECT * "
cQry += " FROM "+RetSqlName("RHS")+ " "
cQry += " WHERE RHS_FILIAL = '" + cFil + "' "
cQry += " AND RHS_MAT = '" + cMat + "' "
cQry += " AND RHS_COMPPG = '" + cDatarq + "' "
cQry += " AND RHS_ORIGEM IN ('2','3') "
cQry += " AND RHS_PD = '" + cPDx + "' "
cQry += " AND D_E_L_E_T_ = ' ' "

If Select("TMP2") > 0   
   Tmp2->(dbCloseArea())
Endif  

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),"TMP2",.F.,.T.)

TMP2->(dbGotop())

nVal := TMP2->(RHS_VLRFUN+RHS_VLREMP)

While Tmp2->(!Eof())
	aaDD(aNumDep,{Tmp2->Rhs_Codigo})
	Tmp2->(dbSkip())
EndDo

aDep  := aClone(aNumDep)
nValPl:= nVal

Return
