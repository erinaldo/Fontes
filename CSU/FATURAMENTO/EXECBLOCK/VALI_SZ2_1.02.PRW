/*MTDO - NOV./2004 ADEQUADO PARA NOVA VIS�O (SZ2) POR AREA DE NEGOCIO
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460INSS  �Autor  �Daniel Paiva        � Data �  07/24/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para atender necessidade especifica de   ���
���          �localiza��o do endere�o de entrega do Cliente CSU-CardSystem���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function vali_Z2a()
_CodArea:=""    
Xval:=""
_aArea := GetArea()

IF	M->C5_AREA=="CARD"
	_CodArea:="02"
ElseIf M->C5_AREA=="CRED"
	_CodArea:="03" 
ElseIf M->C5_AREA=="CONT" // OS 1928/15 By Douglas David
	_CodArea:="04"	
ElseIf M->C5_AREA=="MARK"
	_CodArea:="07"	
Else
	_CodArea:=""
EndIf
            
If !Empty(_CodArea )
dbselectarea("SZ2")
dbsetorder(1)        
dbseek(xfilial("SZ2")+Alltrim(M->C5_CLIENTE)+AllTrim(M->C5_LOJACLI)+_CodArea)  

Xval:=M->C5_AREA

IF !Found()
	MsgAlert("Area de Neg�cio / Endere�o n�o cadastrado no Complemento do cadastro de clientes !")
	Xval:=""    
Endif   
Endif 

RestArea(_aArea)

Return xVal