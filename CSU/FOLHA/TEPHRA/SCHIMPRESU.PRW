#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#include "TBICONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  SchImpResu � Autor � Romay Oliveira     � Data �  01/2015 	  ���
�������������������������������������������������������������������������͹��
���Descricao �Schedule para importacao dos resultados do ponto     		  ���
���			 eletronico pela tabela ZP3 de integracao com o Tephra	      ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico CSU		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function SchImpResu(cxEmp,cxfil)
cxEmp1 := cxEmp
cxFil1 := cxfil

RpcSetType(3)
RpcSetEnv(cxEmp1,cxFil1,,,"GPE",GetEnvServer(),{"SRC,SRA,SRV,ZP3,SR8"})   

ConOut("Inicio Job de importacao Tephra de resultados do ponto data: "+DtoC(Date())+" hora: "+Time()+" " )

u_xIntResult()

ConOut("Fim Job de importacao Tephra de resultados do ponto data: "+DtoC(Date())+" hora: "+Time()+" " )

RpcClearEnv()

Return() 