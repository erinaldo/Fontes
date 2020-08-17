User Function DESHIST()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBHIST   | Autor �Danielle            � Data �  08/16/02   ���
�������������������������������������������������������������������������͹��
��� Desc. ExecBlock CTBHIST                                               ���
��� 																	  ���
��� Objetivo:Validar o codigo para o seguinte historico:  amortizacao     ���
���                                                                       ���
��� Ponto de Disparo: Lancamento Padrao 825                               ���                            
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Declaracao das Variaveis
                                                    
                                                    
Private CRED,CREDRES,nHist:=""
Private RET:=.F.                       

CRED:=SN3->N3_CCDEPR                  	

DbSelectArea("CT1")
DbSetOrder(1)                              
DbSeek(xFilial()+CRED)                   
CREDRES:=CT1->CT1_RES                                          

RET:=TABELA("Z4",CREDRES,.F.)
                                            
If !EMPTY(RET) 
    nHist := "DESCALC AMORTIZ MES"   
   
 Else                                          
	nHist := "DESCALC DEPREC MES"
	
EndIf
                                              
Return nHist