#include "rwmake.ch"
#INCLUDE "Rwmake.ch"  
#include "TOPCONN.CH"

/*/
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������ͱ�
���Programa � CCBEM_ATIVO � Autor � Douglas David/Alexandre Eduardo� Data � 18/03/14� ��
������������������������������������������������������������������������������������͹��
���Descricao � GATILHO CENTRO DE CUSTO x CONTA DE DESPESA                            ���
���          �                                                                       ���
������������������������������������������������������������������������������������͹��
���Uso       � Especifico CSU                                                        ���
������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
/*/

User Function CCBEM_ATIVO()

Local _aArea		:= GetArea()  
Local _cCustoBem	:= ""
Local _CtaDespFim	:= ""	                             
    
DbSelectArea("SN3") 
    SN3->(DbSetOrder(1))
    SN3->(DbSeek(xFilial()))
        
   _cCustoBem	:= Posicione("SNG",1,xFilial("SNG")+M->N1_GRUPO,"NG_CDEPREC")
    	    	 	
   		If SUBSTR(M->N3_CUSTBEM, 1, 2) $ "05/09" 
        reclock("SN3", .F.)                              		
       	SN3->N3_CDEPREC := "3020"+SUBSTR(_cCustoBem,5,9)
     	MsUnLock()
       		Else   
      		reclock("SN3", .F.)                           		
      	 	SN3->N3_CDEPREC := "3010"+SUBSTR(_cCustoBem,5,9)
       		MsUnLock()                          
    	Endif
   
   _CtaDespFim:= SN3->N3_CDEPREC 
    
    
RestArea(_aArea)

Return(_CtaDespFim)
