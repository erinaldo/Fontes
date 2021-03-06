#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FAcertaRHP� Autor �Isamu K.            � Data �  11/02/2015 ���
�������������������������������������������������������������������������͹��
���Descricao �Acerta a Tabela RHP                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Exclusivo para CSU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function fAcertaRhp

Local cQry1

Private cPerg := "FACERTARHP"

//���������������������������������������������������������������������������
//�Cria as perguntas na tabela SX1 caso n�o existam.                        �
//���������������������������������������������������������������������������
PutSx1(cPerg, "01","Filial De                        ","","","mv_ch1" 	,"C",02,0,0,"G",""											, "SM0","","","mv_par01"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial inicial"	   		    },{},{})
PutSx1(cPerg, "02","Filial At�                       ","","","mv_ch2" 	,"C",02,0,0,"G","NaoVazio"									, "SM0","","","mv_par02"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                     ","","","mv_ch3" 	,"C",06,0,0,"G",""  										, "SRA","","","mv_par03"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matr�cula inicial"			},{},{})
PutSx1(cPerg, "04","Matricula at�                    ","","","mv_ch4" 	,"C",06,0,0,"G","NaoVazio"									, "SRA","","","mv_par04"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matr�cula final"			},{},{})
PutSx1(cPerg, "05","Data Pagto de                    ","","","mv_ch5" 	,"D",08,0,0,"G",""  	   									, ""   ,"","","mv_par05"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Data inicial"				},{},{})
PutSx1(cPerg, "06","Data Pagto ate                   ","","","mv_ch6" 	,"D",08,0,0,"G",""											, ""   ,"","","mv_par06"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Data final"				    },{},{})

If !Pergunte( cPerg, .t. )
	Return
EndIf


//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 400,480 DIALOG oLeTxt TITLE OemToAnsi("Acerto da tabela RHP ")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira importar os valores de Co-Participa��o de "
@ 18,018 Say " A. M�dica, do Acumulado Anual para a Tabela de Acumulado de "
@ 26,018 Say " Co-Participa��o (RHP).                                     "
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

Local CodFor  := ""
Local TpForn  := ""
Local TpPlan  := ""

dbSelectArea("RHP")
cIndex := CriaTrab(nil,.f.)
cChave  := "RHP_FILIAL+RHP_MAT+RHP_DATPGT"
IndRegua("RHP",cIndex,cChave,,,"Selecionando Registros...")


cQry1 := " SELECT RD_FILIAL, RD_MAT, RD_PD, RD_VALOR, RD_DATARQ, RD_DATPGT "
cQry1 += " FROM "+RetSqlName("SRD")+ " "
cQry1 += " WHERE RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQry1 += " AND RD_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQry1 += " AND RD_DATPGT BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
cQry1 += " AND RD_PD IN ('514') "
cQry1 += " AND D_E_L_E_T_ = ' ' "
cQry1 += " ORDER BY RD_FILIAL, RD_MAT, RD_DATPGT "

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
While !Tmp1->(Eof()) 
	
	IncProc("Importando dados: "+ TMP1->RD_FILIAL+"/"+TMP1->RD_MAT)
	
	If !RHP->(dbSeek(TMP1->( RD_FILIAL+RD_MAT+RD_DATPGT)))
		
		fBuscaRHK(TMP1->RD_FILIAL,TMP1->RD_MAT,@CODFOR,@TPPLAN)
		
		RecLock("RHP",.T.)
		RHP->RHP_FILIAL := TMP1->RD_FILIAL
		RHP->RHP_MAT    := TMP1->RD_MAT
		RHP->RHP_DTOCOR := STOD(TMP1->RD_DATARQ+"23")
		RHP->RHP_ORIGEM := "1"
		RHP->RHP_TPFORN := "1"
		RHP->RHP_CODFOR := CODFOR
		RHP->RHP_CODIGO := "  "
		RHP->RHP_TPLAN  := TPPLAN
		RHP->RHP_PD     := TMP1->RD_PD
		RHP->RHP_VLRFUN := TMP1->RD_VALOR
		RHP->RHP_VLREMP := 0
		RHP->RHP_COMPPG := TMP1->RD_DATARQ
		RHP->RHP_OBSERV := "SOMA DAS CO-PARTICIPACOES REF. MES "+SUBS(TMP1->RD_DATARQ,5,2)+"/"+SUBS(TMP1->RD_DATARQ,1,4)
		RHP->RHP_DATPGT := Stod(TMP1->RD_DATPGT)
		MsUnlock()

	Endif
	
	
	Tmp1->(dbSkip())
	
EndDo

Alert("Dados Importados com Sucesso !!!")

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �fBuscaRHK � Autor � Isamu K.           � Data �  04/07/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function	fBuscaRHK(cFil,cMat,CODFORX,TPPLANX)


Local cQry

cQry := " SELECT RHK_CODFOR, RHK_TPPLAN "
cQry += " FROM "+RetSqlName("RHK")+ " "
cQry += " WHERE RHK_FILIAL = '" + cFil + "' "
cQry += " AND RHK_MAT = '" + cMat + "' "
cQry += " AND RHK_TPFORN = '1' "
cQry += " AND RHK_PERFIM = '      ' "
cQry += " AND D_E_L_E_T_ = ' ' "

If Select("TMP2") > 0
	Tmp2->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),"TMP2",.F.,.T.)

TMP2->(dbGotop())

CODFORX := TMP2->RHK_CODFOR
TPPLANX := TMP2->RHK_TPPLAN


Return
