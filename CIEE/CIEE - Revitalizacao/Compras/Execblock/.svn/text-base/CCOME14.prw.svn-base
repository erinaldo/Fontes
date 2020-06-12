#INCLUDE "rwmake.ch"    
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME14
Filtra as cotações para o comprador no momento da analise da cotacao
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOME14()
Local cUserFil	:= "" 
Local lFilComp	:= .F.	
Local lFilFech	:= .F. 
Local cFilCot		:= ""
Local cPerg 		:= "CCOME14"

C2E14SX1(cPerg)
If !Pergunte(cPerg, .T.)
	Return (".F.") 
Endif

// Considera os parametros digitados pelo usuario.
lFilComp := (mv_par01 == 1)
lFilFech := (mv_par02 == 1)
cUserFil := If(empty(mv_par03), cUserName, mv_par03)
cUserFil := Upper(AllTrim(cUserFil))

// Filtra cotações fechadas.
cFilCot := IIf (lFilFech, "C8_NUMPED=''", "")

// Filtra por comprador.
cFilCot += IIf (lFilComp, IIf(empty(cFilCot), "", " and ") + "Upper(alltrim(C8_XSOLICI)) = '"+alltrim(cUserFil) +"'", "")


// Retorna o filtro.

Pergunte("MTA160", .F.)

Return(cFilCot)   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E14SX1   ºAutor  ³ Totvs       	   º Data ³01/01/2015    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina									       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function C2E14SX1(cPerg)  
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aSX1		:= {}
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

aAdd( aSX1, {cPerg,'01','Exibe p/ comprador','Exibe p/ comprador','Exibe p/ comprador','mv_ch1','N',1,0,2,'C','','mv_par01','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {cPerg,'02','Filtra cot. atendida','Filtra cot. atendida','Filtra cot. atendida','mv_ch2','N',1,0,2,'C','','mv_par02','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {cPerg,'03','Comprador','Comprador','Comprador','mv_ch3','C',20,0,1,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','US3','','','','',''} )

//
// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aSX1 )
	If !SX1->( dbSeek( PadR( aSX1[nXa][1], nTam1 ) + PadR( aSX1[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aSX1[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aSX1[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf		
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Exibe para o comprador.'},{''},{''}}) 
	AADD(aHelp, {'02',{'Filtra a cotação atendida.'},{''},{''}}) 
	AADD(aHelp, {'03',{'Código do comprador.'},{''},{''}}) 
		
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN     
