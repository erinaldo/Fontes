#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#include "TBICONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  SchImpTurn � Autor � Romay Oliveira     � Data �  01/2015 	  ���
�������������������������������������������������������������������������͹��
���Descricao �Schedule para importacao dos resultados do ponto     		  ���
���			 eletronico pela tabela ZP4 de integracao com o Tephra	      ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico CSU		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function SchImpTurn(cxEmp,cxFil)
                                       
cxEmp	:= aParams[1]
cxFil	:= aParams[2]

RpcSetType(3)
RpcSetEnv(cxEmp,cxFil,,,"GPE",GetEnvServer(),{"SPF,SRA,ZP4"})   

ConOut("Inicio Job de importacao Tephra de turnos de trabalho data: "+DtoC(Date())+" hora: "+Time()+" " )

u_xIntTurno()

ConOut("Fim Job de importacao Tephra de turnos de trabalho data: "+DtoC(Date())+" hora: "+Time()+" " )

RpcClearEnv()

Return() 