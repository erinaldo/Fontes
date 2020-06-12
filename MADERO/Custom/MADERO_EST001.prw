#Include "Protheus.ch"
#Include "FwCommand.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#Include "TOTVS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001   ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia de produtos para outras filiais.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001( )

Local aArea			:= GetArea( )
Local aAreaSB1		:= SB1->( GetArea( ) )
Local cEmpBkp		:= cEmpAnt
Local cFilBkp		:= cFilAnt
Local oWizard 		:= FWWizardControl( ):New( )
Local oStep
Local oBrowReg, oBrowFil
Local oTmpReg , oTmpFil, oTmpRes
Local lUsouQry		:= .F.
Private cAliasQry	:= GetNextAlias( )
Private cProdDe		:= Space( Len( SB1->B1_COD ) )
Private cProdAte	:= Space( Len( SB1->B1_COD ) )
Private cGrupoDe	:= Space( Len( SB1->B1_GRUPO ) )
Private cGrupoAte	:= Space( Len( SB1->B1_GRUPO ) )
Private __cFilDe	:= Space( Len( ADK->ADK_XFILI ) )
Private __cNegDe	:= Space( Len( ADK->ADK_XNEGOC ) )
Private __cSegDe	:= Space( Len( ADK->ADK_XSEGUI ) )

oWizard:SetSize( { 600, 800 } )
oWizard:ActiveUISteps( )

oStep := oWizard:AddStep( "1" )
oStep:SetStepDescription( "Origem" )
oStep:SetConstruction( { |oPanel| fStep01( oPanel )  })
oStep:SetNextAction( { || fGetRegs( ), lUsouQry := .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "2" )
oStep:SetStepDescription( "Produtos" )
oStep:SetConstruction( { |oPanel| oTmpReg := fStep02( oPanel, oBrowReg := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "3" )
oStep:SetStepDescription( "Filiais" )
oStep:SetConstruction( { |oPanel| oTmpFil := fStep03( oPanel, oBrowFil := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "4" )
oStep:SetStepDescription( "Processamento" )
oStep:SetConstruction( { |oPanel| fStep04( oPanel, oTmpReg, oTmpFil, @oTmpRes )  })
oStep:SetNextAction( { || fAllLog( oTmpRes:GetAlias( ) ), .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oWizard:Activate( )
oWizard:Destroy( )

If Select( cAliasQry ) > 0
	( cAliasQry )->( dbCloseArea( ) )
EndIf

If oTmpReg != Nil
	oTmpReg:Delete( )
EndIf

If oTmpFil != Nil
	oTmpFil:Delete( )
EndIf

If oTmpRes != Nil
	oTmpRes:Delete( )
EndIf

cEmpAnt := cEmpBkp
cFilAnt := cFilBkp
RestArea( aAreaSB1 )
RestArea( aArea )

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fStep01  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela do primeiro passo.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fStep01( oPanel1, lFacilita )

Local nLinha 		:= 10
Local aGrupos		:= Separa( AllTrim( Posicione( "SX3", 2, PadR( "ADK_XGNEG", Len( SX3->X3_CAMPO ), " " ), "X3_CBOX" ) ), ":" )
Local cGrpNeg		:= fGetGrpNeg( )
Default lFacilita	:= .F.

oPanel := TScrollBox():New(oPanel1,01,01, oPanel1:nHeight-10, oPanel1:nWidth-10)
oPanel:Align := CONTROL_ALIGN_ALLCLIENT


TGet():New(nLinha    ,20, bSetGet(cEmpAnt),oPanel, 10, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Empresa ',1,oPanel:oFont)
TGet():New(nLinha+7.5,40, bSetGet(FWEmpName(cEmpAnt)),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cFilAnt),oPanel, (FWSizeFilial()*5), 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Filial',1,oPanel:oFont)
TGet():New(nLinha+7.5,30+((FWSizeFilial()*5)), bSetGet(FWFilialName()),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

If lFacilita
	/*
	nLinha += 25
	TSay():New(nLinha,20,{|| "Grupo Negocio" },oDlg,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	nLinha += 20
	TComboBox():New(nLinha,20,{|u|if(PCount()>0,cGrpNeg:=u,cGrpNeg)},aGrupos,100,20,oDlg,,{||},,,,.T.,,,,,,,,,'cGrpNeg')
	*/
	If !Empty( cGrpNeg )
		If Len( aGrupos ) < 2
			aGrupos := { "1=Industria", "2=Unidades de Negocio" }
		EndIf
		cGrpNeg := SubStr( aGrupos[AScan( aGrupos, {|x,y| Left( x, 1 ) == cGrpNeg } )], 3 )
	EndIf
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(cGrpNeg),oPanel, 120, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Grupo Negoc.',1,oPanel:oFont)
Else
	nLinha += 40
	TGet():New(nLinha    ,20, bSetGet(cProdDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",cProdDe,,,,,,,'Produto de',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(cProdAte),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",cProdAte,,,,,,,'Produto ate',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(cGrupoDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",cGrupoDe,,,,,,,'Grupo de',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(cGrupoAte),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",cGrupoAte,,,,,,,'Grupo ate',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(__cFilDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SM0",__cFilDe,,,,,,,'Filial',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(__cNegDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"ZA",__cNegDe,,,,,,,'Negocio',1,oPanel:oFont)
	nLinha += 25
	TGet():New(nLinha    ,20, bSetGet(__cSegDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"ZB",__cSegDe,,,,,,,'Seguimento',1,oPanel:oFont)
EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGetRegs ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca registros que serão processados.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetRegs( )

Local cQuery	:= ""
Local lRet		:= .F.

cQuery += "  SELECT " + CRLF 
cQuery += "    B1_COD  PRODUTO " + CRLF
cQuery += "   ,B1_DESC DESCRICAO " + CRLF
cQuery += "   FROM " + RetSQLName( "SB1" ) + " SB1 " + CRLF
cQuery += "  WHERE SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' " + CRLF
cQuery += "    AND SB1.B1_COD     BETWEEN '" + cProdDe + "' AND '" + cProdAte + "' " + CRLF
cQuery += "    AND SB1.B1_GRUPO   BETWEEN '" + cGrupoDe + "' AND '" + cGrupoAte + "' " + CRLF
cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF
cQuery += "    SB1.B1_COD " + CRLF
cAliasQry := MPSysOpenQuery( cQuery, cAliasQry )
lRet := ( cAliasQry )->( !Eof( ) )
If !lRet
	Alert( "Não foram encontrados registros para processamento" )
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fStep02  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela do segundo passo.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fStep02( oPanel, oBrowse )

Local oMark 	:= FWTemporaryTable( ):New( )
Local cAliasAux	:= ""
Local aStruct 	:= ( cAliasQry )->( dbStruct( ) )

//--Inicio da montagem da tabela temporaria
//Acrescenta o campo de mark
AAdd( aStruct, { } )
AIns( aStruct, 1 )
aStruct[ 01 ] := { "OK", "L", 1, 0 }
oMark:SetFields( aStruct )

//Definindo indice
oMark:AddIndex( "01", { "PRODUTO" } )
oMark:Create( )
cAliasAux := oMark:GetAlias( )

While ( cAliasQry )->( !Eof( ) )
	RecLock( cAliasAux, .T. )
		( cAliasAux )->OK 			:= .F.
		( cAliasAux )->PRODUTO 		:= ( cAliasQry )->PRODUTO
		( cAliasAux )->DESCRICAO	:= ( cAliasQry )->DESCRICAO
	( cAliasAux )->( MsUnlock( ) )
	( cAliasQry )->( dbSkip( ) )
EndDo
( cAliasQry )->( dbCloseArea( ) )
//Final da montagem da tabela temporaria
//Inicio do browser de exibição dos registros
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasAux )
oBrowse:AddMarkColumns( ;
	{|| If( ( cAliasAux )->OK , "LBOK", "LBNO" ) },;
	{||  ( cAliasAux )->OK :=  ! ( cAliasAux )->OK } ,;
	{|| MarkAll( oBrowse ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasAux )->PRODUTO 	},"Produto"		, Len( SB1->B1_COD ), , "C") ,;
	AddColumn({|| ( cAliasAux )->DESCRICAO 	},"Descricao"	, Len( SB1->B1_DESC ), , "C")  ;
})
oBrowse:SetDoubleClick({|| ( cAliasAux )->OK := !( cAliasAux )->OK })

oBrowse:DisableReport()
oBrowse:DisableConfig()
//oBrowse:DisableFilter()
oBrowse:Activate()
//Final do browser de exibição dos registros

Return oMark
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fStep03  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela do terceiro passo.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fStep03( oPanel, oBrowse )
Local oMark 	:= FWTemporaryTable( ):New( )
Local cAliasAux	:= ""

//--Inicio da montagem da tabela temporaria
oMark:SetFields({ ;
		{"OK"		, "L", 1				, 0},;
		{"EMPRESA"	, "C", Len( cEmpAnt )	, 0},;
		{"FILIAL"	, "C", FWSizeFilial()	, 0},;
		{"NOME"		, "C", 60				, 0};
	})
	
//Definindo indice
oMark:AddIndex("01", {"EMPRESA", "FILIAL"} )
oMark:Create( )
cAliasAux := oMark:GetAlias( )

U_COM001A( @cAliasAux )

//Final da montagem da tabela temporaria
//Inicio do browser de exibição das filiais
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasAux )
oBrowse:AddMarkColumns( ;
	{|| If( ( cAliasAux )->OK , "LBOK", "LBNO" ) },;
	{||  ( cAliasAux )->OK :=  ! ( cAliasAux )->OK } ,;
	{|| MarkAll( oBrowse ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasAux )->FILIAL 	},"Filial"		, FWSizeFilial( )	, , "C") ,;
	AddColumn({|| ( cAliasAux )->NOME 		},"Nome"		, 60				, , "C")  ;
})
oBrowse:SetDoubleClick({|| ( cAliasAux )->OK := !( cAliasAux )->OK })
//oBrowse:Seek()
oBrowse:DisableReport()
oBrowse:DisableConfig()
//oBrowse:DisableFilter()
oBrowse:Activate()
//Final do browser de exibição das filiais

Return oMark
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fStep04  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela do quarto passo.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fStep04( oPanel, oTmpReg, oTmpFil, oTmpRes )

Local nRegs		:= 0
Local oProcess
Local cAliasReg	:= oTmpReg:GetAlias( )
Local cAliasFil	:= oTmpFil:GetAlias( )
Local cAliasRes	:= ""
Local aFilDes	:= { }

( cAliasFil )->( dbGoTop( ) )
( cAliasFil )->( dbEval( { || If( ( cAliasFil )->OK, AAdd( aFilDes, { ( cAliasFil )->EMPRESA, ( cAliasFil )->FILIAL } ), ) } ) )
( cAliasFil )->( dbGoTop( ) )

( cAliasReg )->( dbGoTop( ) )
( cAliasReg )->( dbEval( { || If( ( cAliasReg )->OK, nRegs++, ) } ) )
( cAliasReg )->( dbGoTop( ) )

MsgRun("Selecionando registros...","Processando...",{|| oTmpRes := fGerTmpRes( cAliasReg, aFilDes ), cAliasRes := oTmpRes:GetAlias( ) })

nRegs := Len( aFilDes ) * nRegs 
Processa({|oSelf| U_EST001Prep( nRegs, cAliasRes ) }, "Processando registros..." ) 

( cAliasReg )->( dbGoTop( ) )
//Inicio do browser de exibição dos registros
oBrowse:= FWBrowse( ):New( )
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasRes )
oBrowse:AddStatusColumns( { || If( ( cAliasRes )->SUCESSO == 1 , 'BR_VERDE', If( ( cAliasRes )->SUCESSO == 2, 'BR_VERMELHO', 'BR_AMARELO') ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasRes )->PRODUTO 	},"Produto"		, Len( SB1->B1_COD )	, , "C") ,;
	AddColumn({|| ( cAliasRes )->DESCRICAO 	},"Descricao"	, Len( SB1->B1_DESC )	, , "C") ,;
	AddColumn({|| ( cAliasRes )->FILIAL 	},"Filial"		, FWSizeFilial( )		, , "C") ,;
	AddColumn({|| ( cAliasRes )->MSG		},"Msg.Erro"	, 150					, , "C")  ;
})
oBrowse:SetDoubleClick({|| fShowErro( ( cAliasRes )->MSGLOG ) })

oBrowse:DisableReport()
oBrowse:DisableConfig()
oBrowse:DisableFilter()
oBrowse:Activate()
//Final do browser de exibição dos registros

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST001PrepºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa gravação dos registros.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static aSB1Fields := { }
Static aSB5Fields := { }
Static aSGIFields := { }
User Function EST001Prep( nRegs, cAliasReg, lShwMsg )

//Local aArea		:= { }
Local cAux		:= ""
Local cMsg		:= ""
Local cMsgLog 	:= ""
Local nSucesso	:= 3
Local aAllPrd	:= { }
Local cEmpBkp	:= cEmpAnt
Local cFilBkp	:= cFilAnt
Default lShwMsg	:= .T.
Private nOrdPrd	:= 1
Private lTrtExt	:= IsInCallStack( "U_EST001" )

If lShwMsg
	ProcRegua( nRegs )
EndIf
( cAliasReg )->( dbGoTop( ) ) 
While ( cAliasReg )->( !Eof( ) )
	If lShwMsg
		IncProc( "Processando produto " + ( cAliasReg )->PRODUTO )
	EndIf
	If fChkPro( ( cAliasReg )->PRODUTO, ( cAliasReg )->FILIAL, ( cAliasReg )->EMPRESA )
		nSucesso	:= 3
		cMsg		:= "Produto ja existe na filial " + AllTrim( ( cAliasReg )->EMPRESA ) + "/" + AllTrim( ( cAliasReg )->FILIAL ) + "."
		cMsgLog 	+= "Produto " + ( cAliasReg )->PRODUTO + "  - " + ( cAliasReg )->DESCRICAO + CRLF
		cMsgLog 	+= "-->" + cMsg + CRLF 
	Else
		//Busca todos os produtos alternativos.
		fPrepPro( ( cAliasReg )->PRODUTO, @aAllPrd )
	EndIf
	If Empty( cMsg )
		If Len( aAllPrd ) == 0
			nSucesso 	:= 2
			cMsg		:= "Nenhum produto encontrado para copia."
		Else
			ASort(aAllPrd,,,{|x,y| x[3] > y[3] .Or. ( x[3] == y[3] .And. x[2] > y[2] ) })
			If cEmpAnt == ( cAliasReg )->EMPRESA
				cAux := U_EST001Grv( aAllPrd, ( cAliasReg )->EMPRESA, ( cAliasReg )->FILIAL )
			Else
				cAux := StartJob("U_EST001Job", GetEnvServer( ), .T., aAllPrd, AllTrim( ( cAliasReg )->EMPRESA ), AllTrim( ( cAliasReg )->FILIAL ), cEmpAnt, cFilAnt)
			EndIf
			cMsgLog += SubStr( cAux, 3 )
			cAux	:= SubStr( cAux, 1, 2 ) 
			If cAux == "OK"
				nSucesso 	:= 1 
				cMsg		:= "Gravado com sucesso."
			Else
				nSucesso 	:= 2
				cMsg		:= "Ocorreram erros durante o processamento."
			EndIf
		EndIf
	EndIf
	
	If Empty( cMsgLog )
		cMsgLog := cMsg
	EndIf
	
	RecLock( cAliasReg, .F. )
		( cAliasReg )->SUCESSO	:= nSucesso
		( cAliasReg )->MSG		:= cMsg
		( cAliasReg )->MSGLOG 	:= cMsgLog
	( cAliasReg )->( MsUnlock( ) )
	
	cMsgLog	:= ""
	cMsg	:= ""
	nSucesso:= 3
	aAllPrd	:= { }
	cEmpAnt := cEmpBkp
	cFilAnt := cFilBkp
	SM0->( dbSeek( cEmpAnt + cFilAnt ) )
	( cAliasReg )->( dbSkip( ) )
EndDo

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MarkAll  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para marcar/desmarcar todos os registros.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function MarkAll(oBrowse)

(oBrowse:GetAlias())->( dbGotop() )
(oBrowse:GetAlias())->( dbEval({|| OK := !OK },, { || ! Eof() }))
(oBrowse:GetAlias())->( dbGotop() )

oBrowse:Refresh(.T.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AddColumn ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criação das colunas.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AddColumn(bData,cTitulo,nTamanho,nDecimal,cTipo,cPicture)

Local oColumn

oColumn := FWBrwColumn():New()
oColumn:SetData( bData )
oColumn:SetTitle(cTitulo)
oColumn:SetSize(nTamanho)
IF nDecimal != Nil
	oColumn:SetDecimal(nDecimal)
EndIF
oColumn:SetType(cTipo)
IF cPicture != Nil
	oColumn:SetPicture(cPicture)
EndIF

Return oColumn
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTmpResºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta TMP de resultados.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGerTmpRes( cAliasReg, aFilDes )

Local cAliasRes	:= ""
Local oTmpRes	:= FWTemporaryTable( ):New( )
Local nX		:= 0 

//--Inicio da montagem da tabela temporaria
//Acrescenta o campo de mark
oTmpRes:SetFields({ ;
		{"PRODUTO"	, "C", Len( SB1->B1_COD )	, 0},;
		{"DESCRICAO", "C", Len( SB1->B1_DESC )	, 0},;
		{"EMPRESA"	, "C", Len( cEmpAnt )		, 0},;
		{"FILIAL"	, "C", FWSizeFilial( )		, 0},;
		{"MSG"		, "C", 150					, 0},;
		{"SUCESSO"	, "N", 1					, 0},;
		{"MSGLOG"	, "M", 80					, 0};
	})

//Definindo indice
oTmpRes:AddIndex( "01", { "FILIAL", "PRODUTO" } )
oTmpRes:Create( )
cAliasRes := oTmpRes:GetAlias( )

While ( cAliasReg )->( !Eof( ) )
	If ( cAliasReg )->OK
		For nX := 1 to Len( aFilDes )
			RecLock( cAliasRes, .T. )
				( cAliasRes )->SUCESSO 		:= 3
				( cAliasRes )->PRODUTO 		:= ( cAliasReg )->PRODUTO
				( cAliasRes )->DESCRICAO	:= ( cAliasReg )->DESCRICAO
				( cAliasRes )->EMPRESA		:= aFilDes[ nX, 1 ]
				( cAliasRes )->FILIAL		:= aFilDes[ nX, 2 ]
			( cAliasRes )->( MsUnlock( ) )
		Next nX
	EndIf
	( cAliasReg )->( dbSkip( ) )
EndDo
( cAliasReg )->( dbGoTop( ) )

Return oTmpRes
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fPrepPro ºAutor  ³ Vinícius Moreira   º Data ³ 07/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca todas as dependencias de produtos para inclusão.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPrepPro( cCodPro, aProdutos, nNivPro )

Local aArea		:= GetArea( )
Local aAreaSB1	:= SB1->( GetArea( ) )
Local aAreaSGI	:= SGI->( GetArea( ) )
Local lRet 		:= .T.
Local nNivAtu	:= 0
Default nNivPro	:= 1

SB1->( dbSetOrder( 1 ) )//B1_FILIAL+B1_COD
If ( lRet := SB1->( dbSeek( xFilial( "SB1" ) + PadR( cCodPro, Len( SB1->B1_COD ), " " ) ) ) )
	AAdd( aProdutos, { SB1->B1_COD, nOrdPrd, nNivPro } )
	nOrdPrd++
	SGI->( dbSetOrder( 1 ) )//GI_FILIAL+GI_PRODORI+GI_ORDEM+GI_PRODALT
	If SGI->( dbSeek( xFilial( "SGI" ) + SB1->B1_COD ) )
		nNivPro++
		nNivAtu := nNivPro 
		While SGI->( !Eof( ) ) .And. SGI->( GI_FILIAL + GI_PRODORI ) == SB1->( B1_FILIAL + B1_COD )
			fPrepPro( SGI->GI_PRODALT, @aProdutos, @nNivPro )
			nNivPro := nNivAtu
			SGI->( dbSkip( ) )
		EndDo
	EndIf
EndIf 

RestArea( aAreaSGI )
RestArea( aAreaSB1 )
RestArea( aArea )

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001GrvºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa os produtos conforme ordenação.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001Grv( aAllPrd, cEmpDes, cFilDes, cEmpAtu, cFilAtu )

Local cEmpBkp	:= cEmpAnt
Local cFilBkp 	:= cFilAnt
Local nModBkp	:= nModulo
Local lRet		:= .T.
Local nX 		:= 1
Local nCol		:= 1
Local cCodPro	:= ""
Local aDadSB1	:= { }
Local aDadSB5	:= { }
Local aDadSGI	:= { }
Local aPrdAnt	:= { }
Local cArmzPad	:= ""
Local cGrpTrib	:= ""
Local cAliasSB1	:= "SB1TMPQry"//GetNextAlias()
Local cAliasSB5	:= "SB5TMPQry"//GetNextAlias()
Local cAliasSGI	:= "SGITMPQry"//GetNextAlias()
Local cMsgLog	:= ""
Default aAllPrd	:= { }
Default cEmpAtu	:= cEmpAnt
Default cFilAtu	:= cFilAnt

If Len( aSB1Fields ) == 0
	aSB1Fields := fGetFields( "SB1" )
	aSB5Fields := fGetFields( "SB5", "B5_FILIAL|" )
	aSGIFields := fGetFields( "SGI", "GI_FILIAL|" )
EndIf

If lTrtExt
	//Begin Transaction
	BeginTran()
EndIf
For nX := 1 to Len( aAllPrd )
	cCodPro := aAllPrd[ nX, 1 ]
	//Evita que produtos já gravados sejam reprocessados
	If AScan( aPrdAnt, {|x,y| x == cCodPro } ) > 0
		Loop
	EndIf
	AAdd( aPrdAnt, cCodPro )
	
	ConOut( "EST001 - " + cCodPro + " - Abrindo alias" )
	
	fCarrAlias( cCodPro, @cAliasSB1, @cAliasSB5, @cAliasSGI, cEmpAtu, cFilAtu )
	//SB1->( dbSetOrder( 1 ) )	//B1_FILIAL+B1_COD
	//SB1->( dbSeek( xFilial( "SB1" ) + cCodPro ) )
	cMsgLog += "Produto " + (cAliasSB1)->B1_COD + "  - " + (cAliasSB1)->B1_DESC + CRLF
	
	If (cAliasSB1)->B1_MSBLQL == "1"
		lRet := .F.
		cMsgLog += "--> Produto esta bloqueado " + CRLF
	Else
		aDadSB1 := fMntDados( cAliasSB1, aSB1Fields )
		cArmzPad := (cAliasSB1)->B1_LOCPAD
		cGrpTrib := (cAliasSB1)->B1_GRTRIB
	
		If (cAliasSB5)->( !Eof( ) )
			aDadSB5 := fMntDados( cAliasSB5, aSB5Fields )
		EndIf
		
		While (cAliasSGI)->( !Eof( ) )
			AAdd( aDadSGI, fMntDados( cAliasSGI, aSGIFields ) )
			(cAliasSGI)->( dbSkip( ) )
		EndDo
			
		If fChkPro( cCodPro, cFilDes )
			lRet := .F.
			cMsgLog += "--> Ja existe na filial " + cFilDes + CRLF 
		Else
			cFilAnt := cFilDes
			SM0->( dbSeek( cEmpAnt + cFilAnt ) )
			
			NNR->( dbSetOrder( 1 ) )	//NNR_FILIAL+NNR_CODIGO
			SF7->( dbSetOrder( 1 ) )	//F7_FILIAL+F7_GRTRIB+F7_GRPCLI+F7_SEQUEN
			If !Empty( cArmzPad ) .And. !NNR->( dbSeek( xFilial( "NNR" ) + cArmzPad ) )
				lRet := .F.
				cMsgLog += "--> Armazem padrão " + cArmzPad + " não encontrado na filial " + cFilDes + CRLF
			ElseIf !Empty( cGrpTrib ) .And. AllTrim(cGrpTrib) $ GetMv("MV_XGRTVDA",,"") .And. !SF7->( dbSeek( xFilial( "SF7" ) + cGrpTrib ) )
				lRet := .F.
				cMsgLog += "--> Grupo de tributação " + AllTrim( cGrpTrib ) + " não encontrado na filial " + cFilDes + CRLF
			Else
				If fCpyPro( cCodPro, aDadSB1, aDadSB5, aDadSGI, @cMsgLog )
					lRet := .T.
					cMsgLog += "--> OK " + CRLF
				Else
					lRet := .F.
					If lTrtExt
						DisarmTranscation( )
					EndIf
					Exit
				EndIf			
			EndIf
			
			cFilAnt := cFilBkp
			SM0->( dbSeek( cEmpAnt + cFilAnt ) )
		EndIf
	EndIf
	
	ConOut( "EST001 - " + cCodPro + " - Fechando alias" )
	( cAliasSB1 )->( dbCloseArea( ) )
	( cAliasSB5 )->( dbCloseArea( ) )
	( cAliasSGI )->( dbCloseArea( ) )
	aDadSB1 := { }
	aDadSB5	:= { }
	aDadSGI	:= { }
Next nX

If Select( cAliasSB1 ) > 0
	ConOut( "EST001 - " + cCodPro + " - Fechando alias depois do exit" )
	( cAliasSB1 )->( dbCloseArea( ) )
	( cAliasSB5 )->( dbCloseArea( ) )
	( cAliasSGI )->( dbCloseArea( ) )
EndIf

If lTrtExt
	//End Transaction
	EndTran()
EndIf

nModulo	:= nModBkp

If lRet
	cMsgLog := "OK" + cMsgLog
Else
	cMsgLog := "ER" + cMsgLog
EndIf

cEmpAnt := cEmpBkp
cFilAnt := cFilBkp
SM0->( dbSeek( cEmpAnt + cFilAnt ) )

Return cMsgLog
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCpyPro  ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia cadastro de produto para outra filial.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCpyPro( cCodPro, aDadSB1, aDadSB5, aDadSGI, cMsgLog )
Local nOpcX			:= 3
Local cPathTmp		:= "\Copia_Filiais\"
Local cArqTmp 		:= "est001_" + AllTrim( cCodPro ) + "_" + AllTrim( cFilAnt ) + "_" + __cUserId + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + "_.txt"
Local nX			:= 0
Local aDados		:= { }
Local nLin			:= 0
Local nCol			:= 0
Private INCLUI 		:= nOpcX == 3
Private ALTERA 		:= nOpcX == 4
Private EXCLUI 		:= nOpcX == 5
Private lMsErroAuto	:= .F.

If IsInCallStack( "U_EST001Job" )
	CTB105MVC( .T. )
EndIf

// -> Ajusta código de barras
For nX:=1 to Len(aDadSB1)
    If aScan(aDadSB1[nX],{|x| AllTrim(x) == "B1_CODBAR"}) > 0 
       If AllTrim(aDadSB1[nX,02]) <> ""
          aDadSB1[nX,02]:=SubStr(aDadSB1[nX,02],1,TamSx3("B1_CODBAR")[1]-1)+" "
       EndIf
       Exit          
    EndIf    
Next nX

SM0->( dbSeek( cEmpAnt + cFilAnt ) )
nModulo := 4
/*
AAdd( aDados, {"SB1MASTER", aDadSB1} )

If Len( aDadSGI ) > 0
	AAdd( aDados, {"SGIDETAIL", aDadSGI} )
EndIf

If Len( aDadSB5 ) > 0
	AAdd( aDados, {"SB5DETAIL", aDadSB5} )
EndIf                                                        
 
FWMVCRotAuto( FwLoadModel ("MATA010"),"SB1",MODEL_OPERATION_INSERT, aDados,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se deu erro, volto a numeracao e exibo a mensagem.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMsErroAuto
	fCriaDir( cPathTmp )
	MostraErro( cPathTmp, cArqTmp )
	cMsgLog += "Erro: " + MemoRead( cPathTmp + cArqTmp )
	cMsgLog += CRLF + CRLF
	FErase( cPathTmp + cArqTmp )
EndIf
*/
aDadSB1 := fChkCpos( aDadSB1 )
MSExecAuto({|x,y,z| MATA010( x, y ) }, aDadSB1, nOpcX, Nil )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se deu erro, volto a numeracao e exibo a mensagem.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMsErroAuto
	fCriaDir( cPathTmp )
	MostraErro( cPathTmp, cArqTmp )
	cMsgLog += "Filial: " + cEmpAnt + "/" + cFilAnt + CRLF 
	cMsgLog += "Erro SB1: " + MemoRead( cPathTmp + cArqTmp )
	cMsgLog += CRLF + CRLF
	FErase( cPathTmp + cArqTmp )
Else
	If Len( aDadSB5 ) > 0
		aDadSB5 := fChkCpos( aDadSB5 )
		MSExecAuto({|x,y,z| MATA180( x, y ) }, aDadSB5, nOpcX, Nil )
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se deu erro, volto a numeracao e exibo a mensagem.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMsErroAuto
		fCriaDir( cPathTmp )
		MostraErro( cPathTmp, cArqTmp )
		cMsgLog += "Filial: " + cEmpAnt + "/" + cFilAnt + CRLF
		cMsgLog += "Erro SB5: " + MemoRead( cPathTmp + cArqTmp )
		cMsgLog += CRLF + CRLF
		FErase( cPathTmp + cArqTmp )
	Else
		If Len( aDadSGI ) > 0
			For nLin := 1 to Len( aDadSGI )
				RecLock( "SGI", .T. )
					SGI->GI_FILIAL := xFilial( "SGI" )
					For nCol := 1 to Len( aDadSGI[nLin] )
						SGI->&( AllTrim( aDadSGI[nLin, nCol, 1] ) ) := aDadSGI[nLin, nCol, 2] 
					Next nCol
				SGI->( MsUnlock( ) )
			Next nLin
		EndIf
	EndIf
EndIf

Return !lMsErroAuto 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fChkCpos ºAutor  ³ Vinícius Moreira   º Data ³ 26/03/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Checa ordem dos campos para execução do MsExecAuto.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChkCpos(aCpos)

Local aCposAux := {}
Local aRet     := {}
Local nCpo     := 0
Local nTamCpo  := Len(SX3->X3_CAMPO)

dbSelectArea("SX3")
SX3->(dbSetOrder(2))//X3_CAMPO

For nCpo := 1 to Len(aCpos)
	If SX3->(dbSeek(PadR(aCpos[nCpo, 1], nTamCpo, " ")))
		aAdd(aCposAux, {SX3->X3_ORDEM, aCpos[nCpo]})
	Else
		aAdd(aCposAux, {"999", aCpos[nCpo]})
	EndIf
Next nCpo
ASort(aCposAux,,,{|x,y| x[1] < y[1] })
For nCpo := 1 to Len(aCposAux)
	aAdd(aRet, aCposAux[nCpo,2])
Next nCpo

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCriaDir ºAutor  ³ Vinícius Moreira   º Data ³ 29/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria diretorios utilizados pelo programa.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaDir(cPatch, cBarra)
	
Local lRet   := .T.
Local aDirs  := {}
Local nPasta := 1
Local cPasta := ""
Default cBarra	:= "\"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criando diretório de configurações de usuários.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDirs := Separa(cPatch, cBarra)
For nPasta := 1 to Len(aDirs)
	If !Empty (aDirs[nPasta])
		cPasta += cBarra + aDirs[nPasta]
		If !ExistDir (cPasta) .And. MakeDir(cPasta) != 0
			lRet := .F.
			Exit
		EndIf
	EndIf
Next nPasta
	
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetFieldsºAutor  ³ Vinícius Moreira   º Data ³ 29/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca campos em uso para o alias.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetFields( cAliasAtu, cNotShow )

Local aRet 			:= { }
Local cCampo		:= ""
Default cNotShow	:= ""

dbSelectArea( "SX3" )
SX3->( dbSetOrder( 1 ) )//X3_ARQUIVO
If SX3->( dbSeek( cAliasAtu ) )
	While SX3->( !Eof( ) ) .And. SX3->X3_ARQUIVO == cAliasAtu
		cCampo := AllTrim( SX3->X3_CAMPO ) + "|"
		If !cCampo $ cNotShow 
			If X3Uso( SX3->X3_USADO ) .And. SX3->X3_CONTEXT != "V"
				AAdd( aRet, { SX3->X3_CAMPO, SX3->X3_TIPO, Nil } )
			EndIf
		EndIf
		SX3->( dbSkip( ) )
	EndDo
EndIf

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fChkPro  ºAutor  ³ Vinícius Moreira   º Data ³ 07/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Checa se o produto existe na filial destino.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChkPro( cCodPro, cFilDes, cEmpDes )

Local cAliasQry := "TMPSB1Exists"
Local cQuery	:= ""
Local lRet		:= .F.
Default cEmpDes	:= cEmpAnt

cQuery += "  SELECT " + CRLF 
cQuery += "    B1_COD " + CRLF
If cEmpDes != cEmpAnt
	cQuery += "   FROM SB1" + AllTrim( cEmpDes ) + "0 SB1 " + CRLF
Else
	cQuery += "   FROM " + RetSQLName( "SB1" ) + " SB1 " + CRLF
EndIf
cQuery += "  WHERE SB1.B1_FILIAL  = '" + cFilDes + "' " + CRLF
cQuery += "    AND SB1.B1_COD     = '" + cCodPro + "' " + CRLF
cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasQry,.F.,.T.)  
lRet := ( cAliasQry )->( !Eof( ) )
( cAliasQry )->( dbCloseArea( ) )

Return lRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fShowErroºAutor  ³ Vinícius Moreira   º Data ³ 07/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe erro em tela.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fShowErro( cMemo )

Local oDlg
Local cMemo
Local cFile    :=""
Local oFont 

DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

DEFINE MSDIALOG oDlg TITLE "Log" From 3,0 to 340,417 PIXEL

@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := { | | AllwaysTrue( ) }
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End( ) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTER
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fMntDadosºAutor  ³ Vinícius Moreira   º Data ³ 07/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilia na montagem do vetor do ExecAuto.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMntDados( cAliasAtu, aFields )

Local aRet	:= { }
Local nC	:= 0

For nC := 1 to Len( aFields )
	If ( cAliasAtu )->( FieldPos( aFields[ nC, 1 ] ) ) > 0 .And. !Empty( ( cAliasAtu )->&( aFields[ nC, 1 ] ) )
		If aFields[ nC, 2 ] == "D"
			AAdd( aRet, { aFields[ nC, 1 ], SToD( ( cAliasAtu )->&( aFields[ nC, 1 ] ) ), Nil } )
		ElseIf aFields[ nC, 2 ] == "L"
			AAdd( aRet, { aFields[ nC, 1 ], "T" $ ( cAliasAtu )->&( aFields[ nC, 1 ] ), Nil } )
		Else
			AAdd( aRet, { aFields[ nC, 1 ], ( cAliasAtu )->&( aFields[ nC, 1 ] ), Nil } )
		EndIf
	EndIf
Next nC

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fAllLog  ºAutor  ³ Vinícius Moreira   º Data ³ 07/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilia na montagem do vetor do ExecAuto.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAllLog( aAliasRes )

Local cMsgLog := ""
Local cFilAtu := ""

If MsgYesNo( "Deseja visualizar todos os logs?", "Logs" )
	( aAliasRes )->( dbGoTop( ) )
	While ( aAliasRes )->( !Eof( ) )
		If cFilAtu != ( aAliasRes )->FILIAL
			cFilAtu := ( aAliasRes )->FILIAL
			If !Empty( cMsgLog )
				cMsgLog += Replicate( "-", 20 ) + CRLF + CRLF 
			EndIf
			cMsgLog += "//** Filial : " + ( aAliasRes )->FILIAL + " **//" + CRLF + CRLF 
		EndIf
		cMsgLog += ( aAliasRes )->MSGLOG
		( aAliasRes )->( dbSkip( ) )
	EndDo
	fShowErro( cMsgLog )
EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fChkMarcaºAutor  ³ Vinícius Moreira   º Data ³ 09/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Checa se algum registro foi selecionado.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChkMarca( cAliasAtu )

Local lRet := .F.
Local aArea	:= ( cAliasAtu )->( GetArea( ) )

( cAliasAtu )->( dbGoTop( ) )
While ( cAliasAtu )->( !Eof( ) )
	If ( cAliasAtu )->OK
		lRet := .T.
		Exit
	EndIf
	( cAliasAtu )->( dbSkip( ) )
EndDo 

If !lRet
	Alert( "Nenhum registro foi selecionado." )
EndIf

RestArea( aArea )

Return lRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCarrAliasºAutor  ³ Vinícius Moreira   º Data ³ 28/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os alias das tabelas envolvidas buscando informa-  º±±
±±º          ³ ção nas outras empresas.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCarrAlias( cCodPro, cAliasSB1, cAliasSB5, cAliasSGI, cEmpOri, cFilOri )

Local cQuery := ""

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM SB1" + cEmpOri + "0 SB1 " + CRLF 
cQuery += "  WHERE SB1.B1_FILIAL  = '" + cFilOri + "' " + CRLF 
cQuery += "    AND SB1.B1_COD     = '" + cCodPro + "' " + CRLF 
cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    SB1.R_E_C_N_O_ " + CRLF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasSB1,.F.,.T.)

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM SB5" + cEmpOri + "0 SB5 " + CRLF 
cQuery += "  WHERE SB5.B5_FILIAL  = '" + cFilOri + "' " + CRLF 
cQuery += "    AND SB5.B5_COD     = '" + cCodPro + "' " + CRLF 
cQuery += "    AND SB5.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    SB5.R_E_C_N_O_ " + CRLF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasSB5,.F.,.T.)

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM SGI" + cEmpOri + "0 SGI " + CRLF 
cQuery += "  WHERE SGI.GI_FILIAL  = '" + cFilOri + "' " + CRLF 
cQuery += "    AND SGI.GI_PRODORI = '" + cCodPro + "' " + CRLF 
cQuery += "    AND SGI.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    SGI.R_E_C_N_O_ " + CRLF 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasSGI,.F.,.T.)

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001JobºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta ambiente pra execução do JOB.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001Job( aAllPrd, cEmpDes, cFilDes, cEmpAtu, cFilAtu )

Local cRet 		:= ""
Private lTrtExt	:= .T.

RpcSetType( 3 )
RpcSetEnv( cEmpDes, cFilDes, , , "EST" )
cRet := U_EST001Grv( aAllPrd, cEmpDes, cFilDes, cEmpAtu, cFilAtu )
RpcClearEnv()

Return cRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001A  ºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta ambiente pra execução do JOB.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001A( oModel )

Local aArea		:= GetArea( )
Local aAreaSB1	:= SB1->( GetArea( ) )
Local nCpo 		:= 1
Local aChanges	:= { }
Local cCpo		:= ""
Local nCpo      := 1
Local oStruct	:= Nil
Local aCampos	:= { }
Local nPosPrd	:= 0
Local nPosCpo	:= 0

If Type( "__aPrdsAlt__" ) == "A" 
	SB1->( dbSetOrder( 1 ) )//B1_FILIAL+B1_COD
	If SB1->( dbSeek( xFilial( "SB1" ) + PadR( oModel:GetValue( "B1_COD" ), Len( SB1->B1_COD ), " " ) ) )
		oStruct	:= oModel:GetStruct( )
		aCampos	:= oStruct:GetFields( )
		
		For nCpo := 1 to Len( aCampos )
			//cCpo := SB1->( FieldName( nCpo ) )
			cCpo := aCampos[nCpo,3]
			If SB1->&( cCpo ) != oModel:GetValue( cCpo )
				AAdd( aChanges, { cCpo, SB1->&( cCpo ), oModel:GetValue( cCpo ) } )
			EndIf
		Next nCpo
		
		If Len( aChanges ) > 0
			If ( nPosPrd := AScan( __aPrdsAlt__, {|x,y| x[1] == SB1->B1_COD } ) ) == 0
				AAdd( __aPrdsAlt__, { SB1->B1_COD, aChanges } )
			Else
				For nCpo := 1 to Len( aChanges )
					If ( nPosCpo := AScan( __aPrdsAlt__[nPosPrd,2], {|x,y| x[1] == aChanges[nCpo,1] } ) ) == 0
						AAdd( __aPrdsAlt__[nPosPrd,2], aChanges[nCpo] )
					EndIf
				Next nCpo
			EndIf
			
		EndIf
	EndIf
EndIf

RestArea( aAreaSB1 )
RestArea( aArea )

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001B  ºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta ambiente pra execução do JOB.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001B( xPar1, xPar2, xPar3, xPar4, xPar5, xPar6, xPar7, xPar8 )

Public __aPrdsAlt__ := { }

A010WizFac( xPar1, xPar2, xPar3, xPar4, xPar5, xPar6, xPar7, xPar8 )

If Len( __aPrdsAlt__ ) > 0
	fFacilita( )
EndIf

__aPrdsAlt__ := Nil

Return 

Static Function fFacilita( )

Local oWizard 		:= FWWizardControl( ):New( )
Local oStep
Local oBrowFil
Local oTmpFil
Private cAltPrds	:= ""

oWizard:SetSize( { 600, 800 } )
oWizard:ActiveUISteps( )

oStep := oWizard:AddStep( "1" )
oStep:SetStepDescription( "Origem" )
oStep:SetConstruction( { |oPanel| fStep01( oPanel, .T. )  })
oStep:SetNextAction( { || .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "2" )
oStep:SetStepDescription( "Filiais" )
oStep:SetConstruction( { |oPanel| oTmpFil := fStep03( oPanel, oBrowFil := FWBrowse( ):New( ) )  })//Reaproveita o codigo existente.
oStep:SetNextAction( { || Processa({|oSelf| fChangePrds( oTmpFil ) }, "Processando registros..." ), .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "3" )
oStep:SetStepDescription( "Processamento" )
oStep:SetConstruction( { |oPanel| fResAlt( oPanel, cAltPrds ) })
oStep:SetNextAction( { || .T. } )
oStep:SetPrevAction( { || Alert("Opção inválida!"), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oWizard:Activate( )
oWizard:Destroy( )

If oTmpFil != Nil
	oTmpFil:Delete( )
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fChangePrdsºAutor ³ Vinícius Moreira   º Data ³ 03/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da lista de produtos que serao alterados.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChangePrds( oTmpFil )

Local aArea			:= GetArea( )
Local aAreaSB1		:= SB1->( GetArea( ) )
Local cCodPro		:= ""
Local nProd			:= 1 
Local nCpo			:= 0
Local nOpcX			:= 4
Local aDadSB1		:= { }
Local cAliasFil		:= oTmpFil:GetAlias( )
Local cFilBkp		:= cFilAnt
Local cEmpBkp		:= cEmpAnt
Local aFilDes		:= { }
Local cEmpDes		:= ""
Local cFilDes		:= ""
Local nFilDes       := 0
Private lMsErroAuto	:= .F.

( cAliasFil )->( dbGoTop( ) )
( cAliasFil )->( dbEval( { || If( ( cAliasFil )->OK, AAdd( aFilDes, { ( cAliasFil )->EMPRESA, ( cAliasFil )->FILIAL } ), ) } ) )

ProcRegua( Len( aFilDes ) * Len( __aPrdsAlt__ ) )

For nFilDes := 1 to Len( aFilDes )
	cEmpDes := aFilDes[nFilDes,1]
	cFilDes := aFilDes[nFilDes,2]
	cAltPrds += "-->Filial: " + cEmpDes + "/" + cFilDes + CRLF
	For nProd := 1 to Len( __aPrdsAlt__ )
		IncProc( "Processando filial " + cEmpDes + "/" + cFilDes )
		cCodPro := __aPrdsAlt__[nProd, 1]
		
		cAltPrds += "  Produto: " + cCodPro + CRLF
		
		AAdd( aDadSB1, { "B1_COD", PadR( cCodPro, Len( SB1->B1_COD ), " " ), Nil  }  )
		For nCpo := 1 to Len( __aPrdsAlt__[nProd, 2] )
			cAltPrds += "    " + __aPrdsAlt__[nProd, 2, nCpo, 1] + " -> " + CValToChar( __aPrdsAlt__[nProd, 2, nCpo, 2] ) + " - " + CValToChar( __aPrdsAlt__[nProd, 2, nCpo, 3] ) + CRLF
			AAdd( aDadSB1, { __aPrdsAlt__[nProd, 2, nCpo, 1], __aPrdsAlt__[nProd, 2, nCpo, 3], Nil  }  )
		Next nCpo
		aDadSB1 := fChkCpos( aDadSB1 )
		
		If cEmpDes != cEmpAnt
			cAltPrds += " Resultado: " + StartJob("U_EST001C", GetEnvServer( ), .T., cCodPro, aDadSB1, cEmpDes, cFilDes )
		Else
			cFilAnt := cFilDes
			SM0->( dbSeek( cEmpDes + cFilDes ) )
			
			cAltPrds += " Resultado: " + U_EST001C( cCodPro, aDadSB1 )
		EndIf
		
		cEmpAnt := cEmpBkp
		cFilAnt := cFilBkp
		SM0->( dbSeek( cEmpAnt + cFilAnt ) )
		
		aDadSB1 := { }
		cAltPrds += CRLF
	Next nProd
Next nFilDes

RestArea( aAreaSB1 )
RestArea( aArea )

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001C  ºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa alteracao do produto.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001C( cCodPro, aDadSB1, cEmpDes, cFilDes )

Local cRet 			:= ""
Local nOpcX			:= 4
Default cEmpDes		:= "" 
Default cFilDes		:= ""
Private lMsErroAuto	:= .F.

If !Empty( cEmpDes ) .And. IsBlind()
	RpcSetType( 3 )
	RpcSetEnv( cEmpDes, cFilDes, , , "EST" )
EndIf

SB1->( dbSetOrder( 1 ) )
If !SB1->( dbSeek( xFilial( "SB1" ) + cCodPro ) )
	cRet := "Produto nao encontrado"
Else
	MSExecAuto({|x,y,z| MATA010( x, y ) }, aDadSB1, nOpcX, Nil )
	If lMsErroAuto
		cRet := "Erro durante alteracao"
	Else
		cRet := "OK"
	EndIf
EndIf
cRet += CRLF

If !Empty( cEmpDes ) .And. IsBlind()
	RpcClearEnv()
EndIf

Return cRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fResAlt  ºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe dados finais sobre as alteracoes.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fResAlt( oPanel, cTexto )

TMultiget():new( 01, 01, {| u | if( pCount() > 0, cTexto := u, cTexto ) }, oPanel, 520, 184, , , , , , .F. )

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetGrpNegºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca grupo da empresa atual.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetGrpNeg( )

Local xRet		:= "1"
Local cQuery	:= ""
Local cAliasQry	:= GetNextAlias( )

If ADK->( FieldPos( "ADK_XGEMP" ) ) > 0
	cQuery := "  SELECT " + CRLF 
	cQuery += "    ADK.ADK_XGNEG XGNEG " + CRLF
	cQuery += "   FROM " + RetSQLName( "ADK" ) + " ADK " + CRLF 
	cQuery += "  WHERE ADK.ADK_FILIAL =  '" + xFilial( "ADK" ) + "' " + CRLF
	cQuery += "    AND ADK.ADK_XGEMP  =  '" + cEmpAnt +  "' " + CRLF 
	cQuery += "    AND ADK.ADK_XFILI  =  '" + cFilAnt + "' " + CRLF
	cQuery += "    AND ADK.ADK_XGNEG  <> ' ' " + CRLF  
	cQuery += "    AND ADK.D_E_L_E_T_ =  ' ' " + CRLF
	cQuery += "  GROUP BY " + CRLF
	cQuery += "    ADK.ADK_XGNEG " + CRLF 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	
	If ( cAliasQry )->( !Eof( ) )
		xRet := ( cAliasQry )->XGNEG
	EndIf
	( cAliasQry )->( dbCloseArea( ) ) 
EndIf

Return xRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST001D  ºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Checa numeracao do produto.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST001D( oModel )

Local cAliasBkp	:= Alias( )
Local aArea		:= GetArea( )
Local aAreaSB1	:= SB1->( GetArea( ) )
Local cNewCod	:= ""
Local lRet 		:= .T.
Local cQuery	:= ""
Local cAliasQry	:= GetNextAlias( )
Local cGrpNeg	:= fGetGrpNeg( )
Local cDesc		:= oModel:GetValue( "B1_DESC" )
Local aEmps		:= { }
Local nPos		:= 0
Local nPosEmp	:= 0
Local nPosFil	:= 0
Local cFiliais	:= ""

Local oDlg
Local oMsg
Local cMsg		:= "Produto encontrado nos locais abaixo:" + CRLF
Local oFont 

cQuery := "  SELECT " + CRLF 
cQuery += "    ADK.ADK_XGEMP XGEMP " + CRLF
cQuery += "   ,ADK.ADK_XFILI CODFIL " + CRLF 
cQuery += "   ,ADK.ADK_NOME  NOME " + CRLF 
cQuery += "   FROM " + RetSQLName( "ADK" ) + " ADK " + CRLF
cQuery += "  WHERE ADK.ADK_FILIAL = '" + xFilial( "ADK" ) + "' " + CRLF
cQuery += "    AND ADK.ADK_XGNEG  = '" + cGrpNeg + "' " + CRLF  
cQuery += "    AND ADK.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  GROUP BY " + CRLF
cQuery += "    ADK.ADK_XGEMP " + CRLF
cQuery += "   ,ADK.ADK_XFILI " + CRLF 
cQuery += "   ,ADK.ADK_NOME " + CRLF
cQuery += "  ORDER BY " + CRLF
cQuery += "    ADK.ADK_XGEMP " + CRLF
cQuery += "   ,ADK.ADK_XFILI " + CRLF  
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
While ( cAliasQry )->( !Eof( ) )
	nPos := AScan( aEmps, {|x,y| x[1] == ( cAliasQry )->XGEMP } )
	
	If nPos == 0
		AAdd( aEmps, { ( cAliasQry )->XGEMP, { } } )
		nPos := Len( aEmps )
	EndIf
	
	AAdd( aEmps[nPos,2], {	( cAliasQry )->CODFIL,;
							( cAliasQry )->NOME } )
	( cAliasQry )->( dbSkip( ) )
EndDo
( cAliasQry )->( dbCloseArea( ) )

For nPosEmp := 1 to Len( aEmps )
	For nPosFil := 1 to Len( aEmps[nPosEmp, 2] )
		If !Empty( cFiliais )
			cFiliais += ","
		EndIf
		cFiliais += aEmps[nPosEmp, 2, nPosFil, 1]
	Next nPosFil
	
	cQuery := "  SELECT " + CRLF 
	cQuery += "    SB1.B1_FILIAL " + CRLF 
	cQuery += "   FROM SB1" + aEmps[nPosEmp, 1] + "0 SB1 " + CRLF 
	cQuery += "  WHERE SB1.B1_FILIAL IN " + FormatIn( cFiliais, "," ) + CRLF 
	cQuery += "    AND SB1.B1_DESC    = '"  + cDesc + "' " + CRLF 
	cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "  ORDER BY " + CRLF 
	cQuery += "    SB1.B1_FILIAL " + CRLF 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	If ( cAliasQry )->( !Eof( ) )
		lRet := .F.
		cMsg += "Empresa: " + aEmps[nPosEmp, 1] + CRLF 
		While ( cAliasQry )->( !Eof( ) )
			cMsg += "-> " + ( cAliasQry )->B1_FILIAL + CRLF 
			(cAliasQry)->( dbSkip( ) )
		EndDo
		cMsg += + CRLF 
	EndIf
	( cAliasQry )->( dbCloseArea( ) )
Next nPosEmp

dbSelectArea( "SB1" )
If lRet 
	cNewCod := oModel:GetValue( "B1_XLOCAL" )
	cNewCod += oModel:GetValue( "B1_XTIPO" )
	cNewCod += oModel:GetValue( "B1_XCLAS" ) 
	cNewCod += Left( oModel:GetValue( "B1_GRUPO" ), 3 )//Conforme conversado, o campo deve considerar apenas 3 caracteres.
	cNewCod += fGetSeq( cNewCod, aEmps )
	cNewCod += "00"
	cNewCod := PadR( cNewCod, Len( SB1->B1_COD ), " " )
	
	oModel:SetValue( "B1_COD", cNewCod )
Else
	Help("",1,"MADERO_EST001D",,cMsg,4,1)
EndIf

RestArea( aAreaSB1 )
RestArea( aArea )
If !Empty( cAliasBkp )
	dbSelectArea( cAliasBkp )
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGetSeq  ºAutor  ³ Vinícius Moreira   º Data ³ 03/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca ultima sequencia para inclusao do produto.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetSeq( cNewCod, aEmps )

Local cAliasBkp	:= Alias( )
Local cRet 		:= "0001"
Local cQuery	:= ""
Local cAliasQry	:= GetNextAlias( )
Local nEmp		:= 0
Local nFil		:= 0
Local cFiliais	:= ""
Local cQryEmp	:= ""

cQuery := "  SELECT " + CRLF
cQuery += "    MAX( SUBSTR( B1_COD, 9, 4 ) ) NUMSEQ " + CRLF
cQuery += "   FROM ( " + CRLF
For nEmp := 1 to Len( aEmps )
	If !Empty( cQryEmp )
		cQryEmp += "            UNION ALL " + CRLF
	EndIf

	AEval( aEmps[nEmp,2], {|x,y| cFiliais += If(!Empty(cFiliais), ",", ""), cFiliais += x[1] } )
	cQryEmp += "            SELECT " + CRLF 
	cQryEmp += "             SB1" + aEmps[nEmp,1] + ".B1_COD " + CRLF 
	cQryEmp += "            FROM SB1" + aEmps[nEmp,1] + "0 SB1" + aEmps[nEmp,1] + " " + CRLF  
	cQryEmp += "           WHERE SB1" + aEmps[nEmp,1] + ".B1_FILIAL IN " + FormatIn( cFiliais, "," ) + CRLF 
	cQryEmp += "             AND SB1" + aEmps[nEmp,1] + ".B1_XLOCAL || SB1" + aEmps[nEmp,1] + ".B1_XTIPO || SB1" + aEmps[nEmp,1] + ".B1_XCLAS || SB1" + aEmps[nEmp,1] + ".B1_GRUPO = '"  + cNewCod + "' " + CRLF 
	cQryEmp += "             AND SB1" + aEmps[nEmp,1] + ".D_E_L_E_T_ = ' ' " + CRLF
	cFiliais := ""
Next nEmp
cQuery += cQryEmp
cQuery += "   ) TMP " + CRLF  
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
If (cAliasQry)->(!Eof())
	cRet := Soma1( (cAliasQry)->NUMSEQ )
EndIf
(cAliasQry)->(dbCloseArea())
dbSelectArea( cAliasBkp )

Return cRet
