#INCLUDE "PROTHEUS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MA160TOK
Ponto de entrada no final da analise cotacao
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MA160TOK()
Local aDadosCot	:= PARAMIXB[3] 
LOcal aDadosCompl	:= PARAMIXB[5]
Local oDlg			
Local oRadio
Local nOpca:= 0
Private nRadio     

IF ParamIXB[1] <> 2  // Nao e visualizacao
	DEFINE MSDIALOG oDlg FROM  094,1 TO 220,293 TITLE "Gerar:" PIXEL 	
		@ 05,07 TO 42, 140 OF oDlg  PIXEL	
		@ 10,10 Radio oRadio VAR nRadio;
						ITEMS "Pedido de Compra",;	 
							   "Contrato";
							3D SIZE 60,15 OF oDlg PIXEL
	
		DEFINE SBUTTON FROM 45,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1, oDlg:End())
		DEFINE SBUTTON FROM 45,115 TYPE 2 ENABLE OF oDlg ACTION (nOpca := 0, oDlg:End())
	
		ACTIVATE MSDIALOG oDlg CENTERED
	
	
	DBSELECTAREA("SC8")  
	cNum := SC8->C8_NUM  
	
	If nOpca == 1  
		Do Case     
			Case nRadio == 1
				Return .T.
			Case nRadio == 2   
				If !(U_CCOME15('2', cNum, aDadosCot, aDadosCompl))
					Return .F.
				Endif	 
		End Case 
	Else        
		Return .F.
	EndIf
Endif

Pergunte("MTA160",.F.) //Restaura parametros da cotacao

Return .T.