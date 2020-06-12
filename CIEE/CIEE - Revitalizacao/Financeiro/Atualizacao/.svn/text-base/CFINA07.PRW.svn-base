#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA07
Rotina de impressใo da presta็ใo de contas
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CFINA07()       
LOCAL cPerg		:= "CFINA07"
LOCAL aRet		:= {} 
local cCadastro	:= "Presta็ใo de contas"
                                                                                                                                            

C6A07SX1(cPerg)
If PERGUNTE(cPerg,.T.)
	MSGRUN("Gerando presta็ใo de contas, aguarde...",,{|| C6A07IMP() })
ENDIF
	
RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A07IMP   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a presta็ใo de contas 	 					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C6A07IMP() 
LOCAL hWord		:= NIL
LOCAL cArqDot 	:= ""
LOCAL cPathDot 	:= ""
LOCAL cPathEst	:= "" 
LOCAL lRet		:= .T.    
Local cLogoServ := FisxLogo("1") 
local cLogoLoc	:= "logo.bpm"
 	
cArqDot 	:= MV_PAR05+MV_PAR06+".DOT" 											// NOME DO ARQUIVO MODELO DO WORD .DOT
cPathDot 	:= Alltrim(GETMV("MV_DIRACA")) + cArqDot								// PATH DO ARQUIVO MODELO DO WORD
cPathEst	:= Alltrim(GETMV("MV_DIREST")) 											// PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO		        	
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se existe o arquivo modelo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF !FILE(cPathDot)
	MsgStop("Nใo foi possivel localizar o arquivo modelo "+cArqDot+" no servidor.") 	
	lRet:= .F.
ENDIF		               	

IF lRet 	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se existe o endere็o local ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF !FILE(cPathEst)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cria o diretorio local para copiar o modelo Word   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MontaDir(cPathEst)  
	ENDIF       
   	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Criando link de comunicacao com o word                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	hWord := OLE_CreateLink()
	IF hWord != "0"
		MsgStop("Nใo foi possํvel realizar uma conexใo com Word!") 			
	ELSE
		OLE_SetProperty ( hWord, oleWdVisible,.F.) //VISUALIZAR O DOT			
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica a existencia de arquivo com mesmo nome e apaga ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF FILE( cPathEst + cArqDot )
			Ferase( cPathEst + cArqDot )
		ENDIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Copia o arquivo modelo para estacao  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CpyS2T(cPathDot,cPathEst,.T.)   
		
		//IF !FILE( cPathEst + cLogoLoc )			 
		//	CpyS2T(cLogoServ,cPathEst + cLogoLoc,.T.)
		//ENDIF		
		
		OLE_NewFile( hWord, cPathEst + cArqDot)	
		OLE_SetProperty( hWord, oleWdVisible, .F. )
		OLE_SetProperty( hWord, oleWdPrintBack, .F. ) 
		
		/*OLE_SetDocumentVar( hWord, 'cFileImg' 	, cPathEst + cLogoLoc) 
								
					                         		    
		OLE_SetDocumentVar( hWord, 'TLinhas' , "10" ) 			// Numero de linhas da tabela  <-- Caso nใo tenha tabela passar zero
		OLE_SetDocumentVar( hWord, 'NomeTab' , "tab" )			// Nome do indicador da tabela
		OLE_SetDocumentVar( hWord, 'TCampos' , "5" ) 			// Numero de campos da tabela 				
		
		
		FOR nXa := 1 TO 10                                
			FOR nXb:= 1 TO 5
				cCamp := "IT_L" + allTrim(Str(nXa)) + "C" + allTrim(Str(nXb)) 
				OLE_SetDocumentVar( hWord, cCamp , cCamp )
			NEXT nXb
		NEXT nXa 
		
		OLE_UpdateFields(hWord) 
		OLE_ExecuteMacro( hWord , "CRIATAB" ) 
		
		// insere a imagem
		OLE_SetDocumentVar( hWord, 'IndImg' 	, "CASS1" )		
		OLE_SetDocumentVar( hWord, 'cWidth' 	, "50" )
		OLE_SetDocumentVar( hWord, 'cHeight' 	, "50" )
		OLE_UpdateFields(hWord)				
		OLE_ExecuteMacro( hWord , "INSERTIMG" )  
		
		
		OLE_SetDocumentVar( hWord, 'cFilePdf', "c:\temp\" )		// Endere็o a ser salvo na estacao					                         		
		OLE_SetDocumentVar( hWord, 'cNomePdf', "TESTE.PDF" )	// Nome e esten็ใo PDF
		OLE_UpdateFields(hWord)				
		OLE_ExecuteMacro( hWord , "SAVEPDF" )
		*/
				
		OLE_SetProperty( hWord, oleWdVisible, .F. ) 	// seto a propriedade de visibilidade do word
		OLE_SetProperty( hWord, oleWdPrintBack, .T. )  // seto a propriedade de impressใo (segundo plano .T. ou .F.)   

		//OLE_SetProperty( hWord, oleWdVisible, .F. ) 	// seto a propriedade de visibilidade do word
		//OLE_SetProperty( hWord, oleWdPrintBack, .T. )  // seto a propriedade de impressใo (segundo plano .T. ou .F.) 
				                            
		OLE_CloseFile(hWord)		
		OLE_CloseLink(hWord) //Fecha o Link com Word 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica a existencia de arquivo com mesmo nome e apaga ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF FILE( cPathEst + cArqDot )
			Ferase( cPathEst + cArqDot )
		ENDIF				
	ENDIF
ENDIF

RETURN      
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A07IMP   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza parametros  	 					      	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C6A07SX1(cPerg)
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }
                                 
AADD(aDados,{cPerg,'01','Processamento de ?','Processamento de ?','Processamento de ?','MV_CH1','D',8,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
AADD(aDados,{cPerg,'02','Processamento at้ ?','Processamento at้ ?','Processamento at้ ?','MV_CH2','D',8,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
AADD(aDados,{cPerg,'03','Cliente ?','Cliente ?','Cliente ?','MV_CH3','C',TAMSX3("A1_COD")[1],0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SA1','','','','',''} )
AADD(aDados,{cPerg,'04','Loja ?','Loja ?','Loja ?','MV_CH4','C',TAMSX3("A1_LOJA")[1],0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
AADD(aDados,{cPerg,'05','Modelo ?','Modelo ?','Modelo ?','MV_CH5','C',TAMSX3("ZA7_COD")[1],0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','ZA7','','','','',''} )
AADD(aDados,{cPerg,'06','Revisใo ?','Revisใo ?','Revisใo ?','MV_CH6','C',TAMSX3("ZA7_REV")[1],0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','ZA7','','','','',''} )


//
// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Data de processamento inicial.'},{''},{''}}) 
	AADD(aHelp, {'02',{'Data de processamento final.'},{''},{''}}) 
	AADD(aHelp, {'03',{'C๓digo do cliente.'},{''},{''}}) 
	AADD(aHelp, {'04',{'Loja do cliente.'},{''},{''}})
	AADD(aHelp, {'05',{'Modelo da presta็ใo de contas.'},{''},{''}})	
		
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN   