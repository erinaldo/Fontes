#include "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F240FIL  � Autor � Nadia C.Mamude     � Data � 30/12/2013  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada com o objetivo de filtrar titulos na gerac���
���          � Bordero de Pagamentos.	                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico- STA HELENA                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F240FIL()   


Local aArea := GetArea()
Local cRet := ''
//_nOpcao := 1
//_vLimVal := 0
//_vLimAte := 5000.00
//_Bco     := space(3)  
//_ForDe   := "000001" //space(Len(CriaVar("E2_FORNECE"))) //space(6)
//_ForAte  := "ZZZZZZ" //Replicate("Z",Len(CriaVar("E2_FORNECE"))) //space(6)
cModPg    := CMODPGTO  
cPort     := CPORT240

If cModPg $ "01/05/03/41/43/"    //DOC/TED/CRED CTA   

     msgalert("ATENCAO!!! Filtro t�tulos para Doc/TED/Credito Conta ")
     cRet += 'E2_SALDO > 0'
     cRet += '.and.'+'EMPTY(E2_CODBAR)'
    
elseif cModPg == "30"   //BOLETO PROPRIO BANCO        

     msgalert("ATENCAO!!! Filtro de Boletos do Proprio Banco ")
     cRet += 'E2_SALDO > 0'
     cRet += '.and.'+'!EMPTY(E2_CODBAR)'
     cRet += '.and.'+'substr(E2_CODBAR,1,3) == "237"'
  
elseif cModPg == "31"   //BOLETO OUTROS BANCOS

     msgalert("ATENCAO!!! Filtro de Boletos de Outros Bancos ")
     cRet += 'E2_SALDO > 0'
     cRet += '.and.'+'!EMPTY(E2_CODBAR)'
     cRet += '.and.'+'substr(E2_CODBAR,1,3) != "237"'
    
Endif

RestArea(aArea)

Return(cRet)
