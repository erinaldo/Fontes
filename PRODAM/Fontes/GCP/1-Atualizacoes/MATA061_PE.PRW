#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA061()  ³Autor³ José Carlos	 ³ Data ³ 03/07/2015      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Seleciona apenas o fornecedor exclusivo na amarração       ³±±
±±³          ³ Produto x Fornecedor 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³ PE MVC              		                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

/*
	ESPECIFICO PROCESSOS COMPRAS PUBLICAS
	CADASTRO PRODUTO X FORNECEDORES 
*/
User Function MATA061()
Local aParam     := PARAMIXB
Local lRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local nLinha     := 0
Local nLinhaExclusivo := 0
Local nQtdLinhas := 0
Local oGrid
Local nX		 := 0
Local lExclusivo := .F.	//Flag produto exclusivo 

If aParam <> NIL

	oObj       := aParam[1]
	
	cIdPonto   := aParam[2]
	
	cIdModel   := aParam[3]  

	If cIdPonto == 'MODELPOS' 
	    
	    //Objeto de Grid
		oGrid	:= oObj:GetModel("MdGridSA5") 
		
		//Quantidade de linhas da Grid
		nQtdLinhas := oGrid:GetQtdLine()
			
		For nX := 1 To nQtdLinhas
		  	//Posiciona na linha da Grid
			oGrid:GoLine(nX)                
			
			If !(oGrid:IsDeleted())
	        	If ALLTRIM(FwFldGet('A5_XEXCLUS')) == '1' 
	        		lExclusivo := .T.
	        		nLinhaExclusivo ++
	       		EndIf                
	       		nLinha ++
	       	EndIf
	       		
		Next nX		
	   
	   	If lExclusivo .And. nLinhaExclusivo > 1
	 		Help(" ",1,"MATA061_PE",,'Selecione apenas um fornecedor para produto exclusivo.',1,0)
	 		lRet := .F.   
	  	EndIf
	  	
	EndIf              

EndIf

Return lRet