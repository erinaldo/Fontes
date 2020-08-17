#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "REPORT.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GJLOJM01
Monitor OPs x NFC-e
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function GJLOJM01()
LOCAL cPerg	:= "GJLOJM01A "
Local oBrowse := FwMBrowse():New()
Local cFiltro := "D2_XAUTOP$'1,2,3,4'"
LOCAL aColumns:= {}
Private cCposModel:= ""
Private cCposView:= ""

aColumns:= P12M01FLD(1)
aFields:= P12M01FLD(2)

oBrowse:SetAlias("SD2")

oBrowse:SetDescription("Monitor OPs x NFC-e") 
oBrowse:DisableDetails() 

//Legendas para o browse
oBrowse:Addlegend( "D2_XAUTOP=='1'"	, "BR_AZUL"		,"Não gera ordem de produção")
oBrowse:Addlegend( "D2_XAUTOP=='2'"	, "BR_LARANJA"	,"Ordem de produção gerada e não encerrada")
oBrowse:Addlegend( "D2_XAUTOP=='3'"	, "BR_VERDE"		,"Ordem de produção gerada e encerrada") 
oBrowse:Addlegend( "D2_XAUTOP=='4'"	, "BR_VERMELHO"	,"Inconsistência")


P12M01SX1(cPerg)
If Pergunte(cPerg,.T.)
	cFiltro+=" .AND. D2_XNFCE>= '"+ AllTrim(MV_PAR01) +"'"
	cFiltro+=" .AND. D2_XNFCE<= '"+ AllTrim(MV_PAR02) +"'"
	cFiltro+=" .AND. D2_EMISSAO>= '"+ DTOS(MV_PAR03) +"'"
	cFiltro+=" .AND. D2_EMISSAO<= '"+ DTOS(MV_PAR04) +"'"
	IF MV_PAR05!=5
		cFiltro+=" .AND. D2_XAUTOP=='"+ CVALTOCHAR(MV_PAR05) +"'"
	ENDIF	
		
ENDIF

oBrowse:SetFilterDefault(cFiltro)
//oBrowse:SetTemporary(.T.)
//oBrowse:SetFields(aFields())
oBrowse:SetOnlyFields(aColumns) //Seta as colunas que sera exibida no FwMBrowse
oBrowse:LOPTIONREPORT:=	.F.
//oBrowse:SetUseFilter(.f.)
//oBrowse:SetUseCaseFilter(.f.)

oBrowse:Activate()
oBrowse:Destroy()

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Rotina de definição do menu
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}
		
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.GJLOJM01" OPERATION 2 ACCESS 0 		
ADD OPTION aRotina TITLE "Imprimir" ACTION "U_P12M01PRT"	OPERATION 4 ACCESS 0	
ADD OPTION aRotina TITLE "Reprocessar" ACTION "U_P12M01REP" OPERATION 6	ACCESS 0 
ADD OPTION aRotina TITLE "Legenda" ACTION "U_P12M01LEG"	OPERATION 7 ACCESS 0		

Return(aRotina)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Rotina de definição do MODEL
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum  
/*/
//---------------------------------------------------------------------------------------
Static Function ModelDef()
Local oStruSD2 	:= FWFormStruct(1,"SD2", {|cCpo| ALLTRIM(cCpo)$cCposModel }) 
Local oModel   	:= MPFormModel():New( 'P12M01MD', /*bPreValidacao*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ )

oModel:AddFields("MNTMASTER", /*cOwner*/, oStruSD2)
oModel:SetPrimaryKey({"D2_FILIAL","D2_DOC","D2_SERIE","D2_CLIENTE","D2_LOJA","D2_COD","D2_ITEM"})
oModel:SetDescription("Monitor OPs x NFC-e")

Return oModel
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Rotina de definição do VIEW
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function ViewDef()
Local oView    := FWFormView():New()
Local oStruSD2 := FWFormStruct(2, "SD2", {|cCpo| ALLTRIM(cCpo)$cCposView })  //{|cCpo| ALLTRIM(cCpo)$"D2_XNFCE,D2_EMISSAO,D2_COD,D2_ITEM,D2_OP" } 
Local oModel   := FWLoadModel("GJLOJM01")           	

oView:SetModel(oModel)
oView:AddField("VIEW_CAB", oStruSD2, "MNTMASTER")
oView:AddOtherObject('VIEW_LOG',{|OtherObj| P12M01LOG(OtherObj) },{|| },{||})


oView:CreateHorizontalBox("SUPERIOR", 19)
oView:CreateHorizontalBox("INFERIOR", 81)
oView:CreateFolder( 'FOLDER4', 'INFERIOR')
oView:AddSheet('FOLDER4','SHEET1','LOG')
oView:CreateHorizontalBox( 'BOXLOG', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET1')

oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
oView:SetOwnerView('VIEW_LOG','BOXLOG')


Return oView
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01REP
Rotina de exibição da Legenda
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user Function P12M01REP()
LOCAL cPerg	:= "GJLOJM01B "
Local nCnt		:= 0
Local aParBkp	:= {}

For nCnt:= 1 To 5
    aAdd(aParBkp,&("MV_PAR"+StrZero(nCnt,2)))
Next nCnt

P12M01SX1(cPerg)
If Pergunte(cPerg,.T.)
	IF MSGYESNO("Confirma o reprocessamento ?")
		//Rotina que reprocessa a ordem de produção
		U_GJLOJE01(7)
		MSGINFO("Reprocessamento finalizado!")		
	ENDIF		
ENDIF

For nCnt := 1 To Len( aParBkp )
   &( "MV_PAR" + StrZero( nCnt, 2, 0 ) ) := aParBkp[ nCnt ]
Next nCnt

return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01FLD
Monta array com os campos a ser exebido no FwMBrowse
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P12M01FLD(nTipo)
Local aRet 		:= {}
Local oView 		:= NIL
Local aFieldsView	:= NIL


IF nTipo == 1	
	
	aRet 		:= {"D2_FILIAL",;
					"D2_EMISSAO",;
					"D2_COD",;
					"D2_XDESCPR",;
					"D2_ITEM",;
					"D2_XNFCE",;
					"D2_OP",;
					"D2_XLOGOP"}
										
	FOR nCnt:=	1  to len(aRet)					
		cCposModel	+= aRet[nCnt]+","
		IF aRet[nCnt]!="D2_XLOGOP"
			cCposView	+= aRet[nCnt]+","
		ENDIF	
	NEXT nCnt
	
ELSE	
	oView 			:= ViewDef()                                             
	aFieldsView 	:= oView:GetModel("MNTMASTER"):GetStruct():GetFields()  // Campos contidos na estrutura do View

	For nCnt := 1 To Len( aFieldsView )
		If aFieldsView[nCnt,3] != "D2_XDESCPR" 
			Aadd(aRet,{aFieldsView[nCnt,1],; 	//Descrição do campo
						 aFieldsView[nCnt,3],; 	//Nome do campo
						 aFieldsView[nCnt,4],; 	//Tipo
						 aFieldsView[nCnt,5],; 	//Tamanho
						 aFieldsView[nCnt,6],; 	//Decimal
						 ""			   	 	  }) 	//Picture
		ENDIF	
	Next nCnt
ENDIF

Return aRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01LEG
Rotina de exibição da Legenda
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user Function P12M01LEG()
Local oLegenda  :=  FWLegend():New()
		   	
oLegenda:Add("","BR_AZUL"		, "Não gera ordem de produção")
oLegenda:Add("","BR_LARANJA"	, "Ordem de produção gerada e não encerrada")
oLegenda:Add("","BR_VERDE"		, "Ordem de produção gerada e encerrada")
oLegenda:Add("","BR_VERMELHO"	, "inconsistência")
	                                                              
oLegenda:Activate()
oLegenda:View()
oLegenda:DeActivate()

Return( .T. )
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01LOG
Monta painel de visualização do LOG
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P12M01LOG(OtherObj)
LOCAL oMemo	:= NIL
Local cMsgObs	:= fWFldGet("D2_XLOGOP") 

@ 5, 5 Get oMemo Var cMsgObs Memo Size 200, 145 Of OtherObj Pixel
oMemo:bRClicked := { || AllwaysTrue() }	  
oMemo:align:= CONTROL_ALIGN_ALLCLIENT
oMemo:oFont := TFont():New ("Courier New", 7, 16)

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01PRT
Rotina de impressão do FwMBrowse
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER Function P12M01PRT()
LOCAL cPerg	:= "GJLOJM01A "
Local oReport	:= NIL 
Local oSection:= NIL

Pergunte( cPerg, .F. )
oReport := TReport():New("GJLOJM01","Relação OPs x NFC-e",cPerg,{|oReport| P12M01IMP(oReport)},"Este relatório imprime a relação de OPs x NFC-e")
oReport:SetLandScape(.T.)   

DEFINE SECTION oSection OF oReport TITLE "Relação OPs x NFC-e" 
DEFINE CELL NAME "D2_COD" OF oSection
DEFINE CELL NAME "D2_XDESCPR" OF oSection
DEFINE CELL NAME "D2_ITEM" OF oSection
DEFINE CELL NAME "D2_XNFCE" OF oSection
DEFINE CELL NAME "D2_OP" OF oSection  
DEFINE CELL NAME "D2_XAUTOP" OF oSection
DEFINE CELL NAME "D2_XLOGOP" OF oSection
oSection:Cell("D2_XLOGOP"):lLineBreak:=.T.
  
oReport:PrintDialog()
   
Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01IMP
Rotina de impressão do FwMBrowse
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function P12M01IMP(oReport)
Local oSection:= oReport:Section(1) 
Local cTab  	:= GetNextAlias()
Local cFiltro	:= ""
Local nTot		:= 0

IF MV_PAR05==5
	cFiltro+="% D2_XAUTOP IN ('1','2','3','4')%"	
ELSE	
	cFiltro+="% D2_XAUTOP='"+ CVALTOCHAR(MV_PAR05) +"'%"
ENDIF

BeginSql Alias cTab	
	SELECT COALESCE(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),D2_XLOGOP )),'') AS D2_XLOGOP
			,B1_DESC AS D2_XDESCPR
			,SD2.*
	FROM %TABLE:SD2% SD2
	INNER JOIN %TABLE:SB1% SB1 ON B1_FILIAL=%xfilial:SB1%
		AND B1_COD=D2_COD
		AND SB1.D_E_L_E_T_='' 
	WHERE D2_FILIAL=%xfilial:SD2%
	AND D2_XNFCE BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND D2_EMISSAO BETWEEN %exp:DTOS(MV_PAR03)% AND %exp:DTOS(MV_PAR04)%
	AND %exp:cFiltro%
	AND D2_XNFCE!=''  
EndSql 

Count To nTot      
oReport:SetMeter(nTot*2)

//GETLastQuery()[2]
(cTab)->(dbSelectArea((cTab)))
(cTab)->(dbGoTop())
While (cTab)->(!EOF()).AND. !oReport:Cancel()	     
	oReport:IncMeter()                			
	oSection:Init()
	oSection:Cell("D2_COD"		):SetBlock({|| (cTab)->D2_COD })
	oSection:Cell("D2_XDESCPR"	):SetBlock({|| (cTab)->D2_XDESCPR })
	oSection:Cell("D2_ITEM"		):SetBlock({|| (cTab)->D2_ITEM }) 	
	oSection:Cell("D2_XNFCE"		):SetBlock({|| (cTab)->D2_XNFCE })
	oSection:Cell("D2_OP"		):SetBlock({|| (cTab)->D2_OP })
	
	IF (cTab)->D2_XAUTOP == "1"
		oSection:Cell("D2_XAUTOP"	):SetBlock({|| "Não gera OP" })
	ELSEIF (cTab)->D2_XAUTOP == "2"
		oSection:Cell("D2_XAUTOP"	):SetBlock({|| "OP não encerrada" })
	ELSEIF (cTab)->D2_XAUTOP == "3"
		oSection:Cell("D2_XAUTOP"	):SetBlock({|| "OP encerrada" })
	ELSEIF (cTab)->D2_XAUTOP == "4"
		oSection:Cell("D2_XAUTOP"	):SetBlock({|| "inconsistência" }) 
	ENDIF
	 
	oSection:Cell("D2_XLOGOP"	):SetBlock({|| (cTab)->D2_XLOGOP })		
	oSection:PrintLine()		
(cTab)->(DBSKIP())
END
(cTab)->(DBCLOSEAREA())

Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} P12M01SX1
Atualiza parametros 
@author  	Carlos Henrique
@since     	14/10/2016
@version  	P.12.1.7      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
STATIC FUNCTION P12M01SX1(cPerg)
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

IF cPerg=="GJLOJM01A "
	AADD(aDados,{cPerg,'01','Cupom NFC-E de ?','Cupom NFC-E de ?','Cupom NFC-E de ?','MV_CH1','C',TAMSX3("D2_XNFCE")[1],0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'02','Cupom NFC-E até ?','Cupom NFC-E até ?','Cupom NFC-E até ?','MV_CH2','C',TAMSX3("D2_XNFCE")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'03','Emissão de ?','Emissão de ?','Emissão de ?','MV_CH3','D',8,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'04','Emissão até ?','Emissão até ?','Emissão até ?','MV_CH4','D',8,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'05','Status NFC-E ?','Status NFC-E ?','Status NFC-E ?','MV_CH5','C',1,0,0,'C','','MV_PAR05','Não Gera OP','Não Gera OP','Não Gera OP','','','OP não encerrada','OP não encerrada','OP não encerrada','','','OP encerrada','OP encerrada','OP encerrada','','','inconsistência','inconsistência','inconsistência','','','Todos','Todos','Todos','','','','','','',''} )	
ELSE
	AADD(aDados,{cPerg,'01','Cupom NFC-E de ?','Cupom NFC-E de ?','Cupom NFC-E de ?','MV_CH1','C',TAMSX3("D2_XNFCE")[1],0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'02','Cupom NFC-E até ?','Cupom NFC-E até ?','Cupom NFC-E até ?','MV_CH2','C',TAMSX3("D2_XNFCE")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'03','Emissão de ?','Emissão de ?','Emissão de ?','MV_CH3','D',8,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'04','Emissão até ?','Emissão até ?','Emissão até ?','MV_CH4','D',8,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'05','Status Reprocessamento ?','Status Reprocessamento ?','Status Reprocessamento ?','MV_CH5','C',1,0,0,'C','','MV_PAR05','Não Gera OP','Não Gera OP','Não Gera OP','','','OP não encerrada','OP não encerrada','OP não encerrada','','','inconsistência','inconsistência','inconsistência','','','Todos acima','Todos acima','Todos acima','','','','','','','','','','','',''} )	
ENDIF

// Atualizando dicionário
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
	AADD(aHelp, {'01',{'Informe o numero do cupom inicial.'},{''},{''}})
	AADD(aHelp, {'02',{'Informe o numero do cupom final.'},{''},{''}}) 
	AADD(aHelp, {'03',{'Informe a data inicial.'},{''},{''}}) 
	AADD(aHelp, {'04',{'Informe a data final.'},{''},{''}})
	
	IF cPerg=="GJLOJM01A "
		AADD(aHelp, {'05',{'Informe o status do cupom.'},{''},{''}})
	ELSE
		AADD(aHelp, {'05',{'Informe o status do Reprocessamento.'},{''},{''}})
	ENDIF

	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	
EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN
