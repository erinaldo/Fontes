#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSGPEX21 � Autor � Adilson Silva      � Data � 01/04/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Roteiro para Geracao do Anuenio na Folha de Pagamento.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fGerAnuenio()

 Local nValBase := 0
 Local nValPag  := 0
 Local cPdAnun  := aCodFol[001,1]
 Local cPdMater := aCodFol[040,1]
 Local cMesAnt  := U_fSbMesAno( cPeriodo )
 
 ZXC->(dbSetOrder( 1 ))
 If ZXC->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPeriodo )) .And. ZXC->ZXC_VALOR > 0
    nValBase := ZXC->ZXC_VALOR
 ElseIf ZXC->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cMesAnt )) .And. ZXC->ZXC_VALOR > 0
    nValBase := ZXC->ZXC_VALOR
 EndIf
 
 If nValBase > 0
    If c__Roteiro $ "FOL/RES"
       nValPag := Round((nValBase / 30) * DiasTrab,2)
    ElseIf c__Roteiro == "FER"
       nValPag := Round((nValBase / 30) * M->RH_DFERIAS,2)
       cPdAnun := aCodFol[0084,1]
    ElseIf c__Roteiro $ "132"
       nValPag := Round((nValBase / 12) * nAvos,2)
    EndIf
 EndIf

 // Gera o Valor Conforme Roteiro de Calculo
 If nValPag > 0 .And. U_fChkGrava( cPdAnun )
    fGeraVerba(cPdAnun,nValPag,,,,,,,,,.T.)
 EndIf

 // Verifica Salario Maternidade
 If fBuscaPd( cPdMater ) > 0 .And. nDiasMat > 0
    nValPag := Round((nValBase / 30) * nDiasMat,2)
    If U_fChkGrava( cPdMater )
       aPd[fLocaliaPd(cPdMater),5] += nValPag
    EndIf
 EndIf
 
Return( "" )
