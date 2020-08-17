/*MTDO - NOV./2004 ADEQUADO PARA NOVA VISÃO (SZ2) POR AREA DE NEGOCIO
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460INSS  ºAutor  ³Daniel Paiva        º Data ³  07/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada para atender necessidade especifica de   º±±
±±º          ³localização do endereço de entrega do Cliente CSU-CardSystemº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	MsgAlert("Area de Negócio / Endereço não cadastrado no Complemento do cadastro de clientes !")
	Xval:=""    
Endif   
Endif 

RestArea(_aArea)

Return xVal