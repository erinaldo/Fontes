#Include "Protheus.ch"
#Include "FwCommand.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EST003   ºAutor  ³ Vinícius Moreira   º Data ³ 10/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia das permissões.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST003( )

Local oWizard 		:= FWWizardControl( ):New( )
Local oStep
Local oBrowReg, oBrowFil
Local oTmpReg , oTmpFil, oTmpRes
Private cAliasQry	:= GetNextAlias( )
Private cUserDe		:= Space( Len( SDW->DW_USER ) )
Private cUserAte	:= Space( Len( SDW->DW_USER ) )
Private cGrpDe		:= Space( Len( SDW->DW_GRPPROD ) )
Private cGrpAte		:= Space( Len( SDW->DW_GRPPROD ) )

oWizard:SetSize( { 600, 800 } )
oWizard:ActiveUISteps( )

oStep := oWizard:AddStep( "1" )
oStep:SetStepDescription( "Origem" )
oStep:SetConstruction( { |oPanel| fStep01( oPanel )  })
oStep:SetNextAction( { || fGetRegs( ) } )
oStep:SetPrevAction( {|| .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "2" )
oStep:SetStepDescription( "Permissões" )
oStep:SetConstruction( { |oPanel| oTmpReg := fStep02( oPanel, oBrowReg := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || fChkMarca( oTmpReg:GetAlias( ) ) } )
oStep:SetPrevAction( {|| .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "3" )
oStep:SetStepDescription( "Filiais" )
oStep:SetConstruction( { |oPanel| oTmpFil := fStep03( oPanel, oBrowFil := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || fChkMarca( oTmpFil:GetAlias( ) ) } )
oStep:SetPrevAction( {|| .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avançar" )

oStep := oWizard:AddStep( "4" )
oStep:SetStepDescription( "Processamento" )
oStep:SetConstruction( { |oPanel| fStep04( oPanel, oTmpReg, oTmpFil, @oTmpRes )  })
oStep:SetNextAction( { || fAllLog( oTmpRes:GetAlias( ) ), .T. } )
oStep:SetPrevAction( {|| .F. } )
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
Static Function fStep01( oPanel )

Local nLinha := 10

TGet():New(nLinha    ,20, bSetGet(cEmpAnt),oPanel, 10, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Empresa ',1,oPanel:oFont)
TGet():New(nLinha+7.5,40, bSetGet(FWEmpName(cEmpAnt)),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cFilAnt),oPanel, (FWSizeFilial()*5), 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Filial',1,oPanel:oFont)
TGet():New(nLinha+7.5,30+((FWSizeFilial()*5)), bSetGet(FWFilialName()),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

nLinha += 40
TGet():New(nLinha    ,20, bSetGet(cUserDe)	,oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cUserDe	,,,,,,,'Usuario de'	,1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cUserAte)	,oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cUserAte	,,,,,,,'Usuario ate',1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cGrpDe)	,oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cGrpDe	,,,,,,,'Grupo de'	,1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cGrpAte)	,oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cGrpAte	,,,,,,,'Grupo ate'	,1,oPanel:oFont)

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
cQuery += "    SDW.DW_PRODUTO PRODUTO " + CRLF
cQuery += "   ,SB1.B1_DESC    DESCRICAO " + CRLF
cQuery += "   ,SDW.DW_GRPPROD GRPPROD " + CRLF
cQuery += "   ,SDW.DW_USER    USRPRO " + CRLF
cQuery += "   ,SDW.DW_GRUPO   GRUPO " + CRLF
cQuery += "   ,SDW.DW_DOC     DOC " + CRLF
cQuery += "  FROM " + RetSQLName( "SDW" ) + " SDW " + CRLF
cQuery += " LEFT OUTER JOIN " + RetSQLName( "SB1" ) + " SB1 ON " + CRLF
cQuery += "       SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' " + CRLF
cQuery += "   AND SB1.B1_COD     = SDW.DW_PRODUTO " + CRLF
cQuery += "   AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " WHERE SDW.DW_FILIAL  = '" + xFilial( "SDW" ) + "' " + CRLF
cQuery += "   AND SDW.DW_USER    BETWEEN '" + cUserDe + "' AND '" + cUserAte + "' " + CRLF
cQuery += "   AND SDW.DW_GRPPROD BETWEEN '" + cGrpDe + "' AND '" + cGrpAte + "' " + CRLF
cQuery += "   AND SDW.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF
cQuery += "    SDW.DW_PRODUTO " + CRLF
cQuery += "   ,SDW.DW_GRPPROD " + CRLF
cQuery += "   ,SDW.DW_USER " + CRLF
cQuery += "   ,SDW.DW_GRUPO " + CRLF
cQuery += "   ,SDW.DW_DOC " + CRLF
cAliasQry := MPSysOpenQuery( cQuery )
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
oMark:AddIndex( "01", { "PRODUTO", "GRPPROD", "USRPRO", "GRUPO", "DOC" } )
oMark:Create( )
cAliasAux := oMark:GetAlias( )

While ( cAliasQry )->( !Eof( ) )
	RecLock( cAliasAux, .T. )
		( cAliasAux )->OK 			:= .F.
		( cAliasAux )->PRODUTO 		:= ( cAliasQry )->PRODUTO
		( cAliasAux )->DESCRICAO	:= ( cAliasQry )->DESCRICAO
		( cAliasAux )->GRPPROD		:= ( cAliasQry )->GRPPROD
		( cAliasAux )->USRPRO		:= ( cAliasQry )->USRPRO
		( cAliasAux )->GRUPO 		:= ( cAliasQry )->GRUPO
		( cAliasAux )->DOC 			:= ( cAliasQry )->DOC
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
	AddColumn({|| ( cAliasAux )->PRODUTO 	},"Produto"		, Len( ( cAliasAux )->PRODUTO	), , "C") ,;
	AddColumn({|| ( cAliasAux )->DESCRICAO	},"Descricao"	, Len( ( cAliasAux )->DESCRICAO	), , "C") ,;
	AddColumn({|| ( cAliasAux )->GRPPROD 	},"Gru.Prod."	, Len( ( cAliasAux )->GRPPROD	), , "C") ,;
	AddColumn({|| ( cAliasAux )->USRPRO 	},"Usuario"		, Len( ( cAliasAux )->USRPRO	), , "C") ,;
	AddColumn({|| ( cAliasAux )->GRUPO 		},"Grp.Usuario"	, Len( ( cAliasAux )->GRUPO		), , "C") ,;
	AddColumn({|| ( cAliasAux )->DOC 		},"Documento"	, Len( ( cAliasAux )->DOC 		), , "C")  ;
})
oBrowse:SetDoubleClick({|| ( cAliasAux )->OK := !( cAliasAux )->OK })

oBrowse:DisableReport()
oBrowse:DisableConfig()
oBrowse:DisableFilter()
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

Local aSM0 		:= FWLoadSM0( )
Local oMark 	:= FWTemporaryTable( ):New( )
Local cAliasAux	:= ""
Local nI		:= 0

//--Inicio da montagem da tabela temporaria
oMark:SetFields({ ;
		{"OK"		, "L", 1, 0},;
		{"EMPRESA"	, "C", Len( cEmpAnt ), 0},;
		{"FILIAL"	, "C", FWSizeFilial(), 0},;
		{"NOME"		, "C", 60, 0};
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
	;//AddColumn({|| ( cAliasAux )->EMPRESA 	},"Empresa"		, Len( cEmpAnt )	, , "C") ,;
	AddColumn({|| ( cAliasAux )->FILIAL 	},"Filial"		, FWSizeFilial( )	, , "C") ,;
	AddColumn({|| ( cAliasAux )->NOME 		},"Nome"		, 60				, , "C")  ;
})
oBrowse:SetDoubleClick({|| ( cAliasAux )->OK := !( cAliasAux )->OK })

oBrowse:DisableReport()
oBrowse:DisableConfig()
oBrowse:DisableFilter()
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

Local nMeter	:= 0
Local nRegs		:= 0
Local oProcess
Local cAliasReg	:= oTmpReg:GetAlias( )
Local cAliasFil	:= oTmpFil:GetAlias( )
Local cAliasRes	:= ""
Local aFilDes	:= { }

( cAliasFil )->( dbGoTop( ) )
( cAliasFil )->( dbEval( { || If( ( cAliasFil )->OK, ( nRegs++, AAdd( aFilDes, { ( cAliasFil )->EMPRESA, ( cAliasFil )->FILIAL } ) ), ) } ) )
( cAliasFil )->( dbGoTop( ) )

( cAliasReg )->( dbGoTop( ) )
( cAliasReg )->( dbEval( { || If( ( cAliasReg )->OK, nRegs++, ) } ) )
( cAliasReg )->( dbGoTop( ) )

MsgRun("Selecionando registros...","Processando...",{|| oTmpRes := fGerTmpRes( cAliasReg, aFilDes ), cAliasRes := oTmpRes:GetAlias( ) })

nRegs := Len( aFilDes ) * nRegs 
Processa({|oSelf| fProcRegs( nRegs, cAliasRes, aFilDes ) }, "Processando registros..." ) 

( cAliasReg )->( dbGoTop( ) )
//Inicio do browser de exibição dos registros
oBrowse:= FWBrowse( ):New( )
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasRes )
oBrowse:AddStatusColumns( { || If( ( cAliasRes )->SUCESSO == 1 , 'BR_VERDE', If( ( cAliasRes )->SUCESSO == 2, 'BR_VERMELHO', 'BR_AMARELO') ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasRes )->PRODUTO 	},"Produto"		, Len( ( cAliasRes )->PRODUTO	), , "C") ,;
	AddColumn({|| ( cAliasRes )->DESCRICAO	},"Descricao"	, Len( ( cAliasRes )->DESCRICAO	), , "C") ,;
	AddColumn({|| ( cAliasRes )->GRPPROD 	},"Gru.Prod."	, Len( ( cAliasRes )->GRPPROD	), , "C") ,;
	AddColumn({|| ( cAliasRes )->USRPRO 	},"Usuario"		, Len( ( cAliasRes )->USRPRO	), , "C") ,;
	AddColumn({|| ( cAliasRes )->GRUPO 		},"Grp.Usuario"	, Len( ( cAliasRes )->GRUPO		), , "C") ,;
	AddColumn({|| ( cAliasRes )->DOC 		},"Documento"	, Len( ( cAliasRes )->DOC 		), , "C") ,;
	AddColumn({|| ( cAliasRes )->EMPRESA 	},"Empresa"		, Len( cEmpAnt )				 , , "C") ,;
	AddColumn({|| ( cAliasRes )->FILIAL 	},"Filial"		, FWSizeFilial( )				 , , "C") ,;
	AddColumn({|| ( cAliasRes )->MSG		},"Msg.Erro"	, 150							 , , "C")  ;
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
±±ºPrograma  ³fProcRegs ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa gravação dos registros.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static aSDWFields := { }
Static aSDWFldItens := { }
Static Function fProcRegs( nRegs, cAliasReg, aFilDes )

Local cMsg			:= ""
Local cMsgLog 		:= ""
Local nSucesso		:= 3
Local aAllRegs		:= { }
Local nPosPrd		:= 0
Local nPosUsr		:= 0
Local cAux			:= ""

ProcRegua( nRegs+1 )
IncProc( "Agrupando produtos das permissões..." )
( cAliasReg )->( dbGoTop( ) )
While ( cAliasReg )->( !Eof( ) )
	nPosPrd := AScan( aAllRegs, { |x,y| ( x[1] + x[3] + x[4] + x[6] ) == ( cAliasReg )->( PRODUTO + GRPPROD + FILIAL + EMPRESA ) } )
	If nPosPrd == 0
		AAdd( aAllRegs, { 	( cAliasReg )->PRODUTO,;		//01
							( cAliasReg )->DESCRICAO,;		//02
		 					( cAliasReg )->GRPPROD,;		//03
		 					( cAliasReg )->FILIAL,;			//04
		 					{ },;							//05
		 					( cAliasReg )->EMPRESA } )		//06
		nPosPrd := Len( aAllRegs )
	EndIf
	
	AAdd( aAllRegs[nPosPrd,5], { 	( cAliasReg )->USRPRO,;			//01
				 					( cAliasReg )->GRUPO,;			//02
				 					( cAliasReg )->DOC,;			//03
	 								( cAliasReg )->( Recno( ) ) } )	//04
	( cAliasReg )->( dbSkip( ) )
EndDo

For nPosPrd := 1 to Len( aAllRegs )
	IncProc( "Processando permissões do produto " + AllTrim( aAllRegs[nPosPrd,2] ) + " na filial " + aAllRegs[nPosPrd,4] )
	cMsgLog += "Processando permissões do produto " + AllTrim( aAllRegs[nPosPrd,2] ) + " na filial " + aAllRegs[nPosPrd,4] + CRLF
	
	If aAllRegs[nPosPrd, 6] == cEmpAnt
		cAux := fProcAll( aAllRegs[nPosPrd, 1], aAllRegs[nPosPrd, 2], aAllRegs[nPosPrd, 3], aAllRegs[nPosPrd, 4], aAllRegs[nPosPrd, 5], aAllRegs[nPosPrd, 6], cEmpAnt, cFilAnt )
	Else
		cAux := StartJob("U_EST003Job", GetEnvServer( ), .T., aAllRegs[nPosPrd, 1], aAllRegs[nPosPrd, 2], aAllRegs[nPosPrd, 3], aAllRegs[nPosPrd, 4], aAllRegs[nPosPrd, 5], aAllRegs[nPosPrd, 6], cEmpAnt, cFilAnt )
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
	
	For nPosUsr := 1 to Len( aAllRegs[nPosPrd, 5] )
		( cAliasReg )->( dbGoTo( aAllRegs[nPosPrd, 5, nPosUsr, 4] ) )
		RecLock( cAliasReg, .F. )
			( cAliasReg )->SUCESSO	:= nSucesso
			( cAliasReg )->MSG		:= cMsg
			( cAliasReg )->MSGLOG 	:= cMsgLog
		( cAliasReg )->( MsUnlock( ) )
	Next nPosUsr
	
	cMsgLog	:= ""
	cMsg	:= ""
	nSucesso:= 3
Next nPosPrd

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fProcAll ºAutor  ³ Vinícius Moreira   º Data ³ 06/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa os produtos conforme ordenação.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fProcAll( cCodPro, cDesc, cGrpPro, cFilDes, aAllRegs, cEmpDes, cEmpAtu, cFilAtu )

Local cFilBkp 	:= cFilAnt
Local nModBkp	:= nModulo
Local lRet		:= .T.
Local nX 		:= 1
Local aDadSDW	:= { }
Local aDadSDWIt	:= { }
Local aRotAnt	:= If( Type( "aRotina" ) != "U", AClone( aRotina ), { } )
Local lSeekPrd	:= !Empty( cCodPro )
Local cChvSDW	:= ""
Local cCpoSDW	:= ""
Local cMsgLog	:= ""
Local cAliasSDW	:= GetNextAlias()
Default cEmpAtu	:= cEmpAnt
Default cFilAtu	:= cFilAnt
Private aRotina	:= StaticCall( MATA014, MenuDef )

If Len( aSDWFields ) == 0
	aSDWFields 		:= fGetFields( "SDW", , "DW_PRODUTO|DW_GRPPROD|" )
	aSDWFldItens 	:= fGetFields( "SDW", "DW_PRODUTO|DW_GRPPROD|" , )
EndIf

cMsgLog += "*Verificando do cadastro de produtos" + CRLF 
/*
If lSeekPrd
	SDW->( dbSetOrder( 1 ) )	//DW_FILIAL+DW_PRODUTO+DW_USER+DW_DOC
	lRet 	:= SDW->( dbSeek( xFilial( "SDW" ) + cCodPro ) )
	cCpoSDW	:= "DW_FILIAL+DW_PRODUTO"
	cChvSDW	:= SDW->DW_PRODUTO
Else
	SDW->( dbSetOrder( 3 ) )	//DW_FILIAL+DW_GRPPROD+DW_USER+DW_DOC
	lRet := SDW->( dbSeek( xFilial( "SDW" ) + cGrpPro ) )
	cCpoSDW	:= "DW_FILIAL+DW_GRPPROD"
	cChvSDW	:= SDW->DW_GRPPROD
EndIf
*/
fCarrAlias( cCodPro, cGrpPro, @cAliasSDW, cEmpAtu, cFilAtu )

If (cAliasSDW)->(!Eof())
	If lSeekPrd
		SDW->( dbSetOrder( 1 ) )	//DW_FILIAL+DW_PRODUTO+DW_USER+DW_DOC
		cChvSDW	:= (cAliasSDW)->DW_PRODUTO
	Else
		SDW->( dbSetOrder( 3 ) )	//DW_FILIAL+DW_GRPPROD+DW_USER+DW_DOC
		cChvSDW	:= (cAliasSDW)->DW_GRPPROD
	EndIf

	aDadSDW := fMntDados( cAliasSDW, aSDWFields )
	While (cAliasSDW)->( !Eof( ) )
		AAdd( aDadSDWIt, fMntDados( cAliasSDW, aSDWFldItens ) )
		(cAliasSDW)->( dbSkip( ) )
	EndDo
EndIf

If Len( aDadSDW ) > 0
	Begin Transaction
	nModulo := 4
	cFilAnt := cFilDes
	SM0->( dbSeek( cEmpAnt + cFilAnt ) )
	/*
	SB1->( dbSetOrder( 1 ) )	//B1_FILIAL+B1_COD
	If !SB1->( dbSeek( xFilial( "SB1" ) + cCodPro ) )
		lRet := .F.
		cMsgLog := "*Produto não encontrado na filial " + cFilDes
	Else*/
	(cAliasSDW)->(dbCloseArea())
	fCarrAlias( cCodPro, cGrpPro, @cAliasSDW, cEmpDes, cFilDes )
	If !fExclEstru( cAliasSDW, cChvSDW, @cMsgLog )
		lRet := .F.
		DisarmTransaction( )
	ElseIf !fCpyEstru( xFilial( "SDW" ) + cChvSDW, aDadSDW, aDadSDWIt, @cMsgLog )
		lRet := .F.
		DisarmTransaction( )
	EndIf
	End Transaction
	
	cFilAnt := cFilBkp
	SM0->( dbSeek( cEmpAnt + cFilAnt ) )
	aDadSDW 	:= { }
	aDadSDWIt	:= { }
EndIf

( cAliasSDW )->( dbCloseArea( ) )
nModulo	:= nModBkp
aRotina := aRotAnt

If lRet
	cMsgLog := "OK" + cMsgLog
Else
	cMsgLog := "ER" + cMsgLog
EndIf

Return cMsgLog
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
		{"PRODUTO"	, "C", Len( ( cAliasReg )->PRODUTO )	, 0},;
		{"DESCRICAO", "C", Len( ( cAliasReg )->DESCRICAO ) 	, 0},;
		{"GRPPROD"	, "C", Len( ( cAliasReg )->GRPPROD )	, 0},;
		{"USRPRO"	, "C", Len( ( cAliasReg )->USRPRO )		, 0},;
		{"GRUPO"	, "C", Len( ( cAliasReg )->GRUPO )		, 0},;
		{"DOC"		, "C", Len( ( cAliasReg )->DOC )		, 0},;
		{"EMPRESA"	, "C", Len( cEmpAnt )					, 0},;
		{"FILIAL"	, "C", FWSizeFilial()					, 0},;
		{"SUCESSO"	, "N", 1								, 0},;
		{"MSGLOG"	, "M", 80								, 0},;
		{"MSG"		, "C", 150, 0};
	})

//Definindo indice
oTmpRes:AddIndex( "01", { "EMPRESA", "FILIAL", "PRODUTO", "GRPPROD", "USRPRO", "GRUPO", "DOC" } )
oTmpRes:Create( )
cAliasRes := oTmpRes:GetAlias( )

While ( cAliasReg )->( !Eof( ) )
	If ( cAliasReg )->OK
		For nX := 1 to Len( aFilDes )
			RecLock( cAliasRes, .T. )
				( cAliasRes )->SUCESSO 		:= 3
				( cAliasRes )->PRODUTO 		:= ( cAliasReg )->PRODUTO
				( cAliasRes )->DESCRICAO	:= ( cAliasReg )->DESCRICAO
				( cAliasRes )->GRPPROD 		:= ( cAliasReg )->GRPPROD
				( cAliasRes )->USRPRO		:= ( cAliasReg )->USRPRO
				( cAliasRes )->GRUPO		:= ( cAliasReg )->GRUPO
				( cAliasRes )->DOC 			:= ( cAliasReg )->DOC
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
±±ºPrograma  ³fExclEstruºAutor  ³ Vinícius Moreira   º Data ³ 08/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica necessidade de exclusão dos registros do destino. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fExclEstru( cAliasSDW, cChvSDW, cMsgLog )

Local aDados		:= { }
Local aDadSDW		:= { }
Local nOpcX			:= 5
Local cPathTmp		:= "\Copia_Filiais\"
Local cArqTmp 		:= "EST003_e_" + AllTrim( cChvSDW ) + "_" + AllTrim( cFilAnt ) + "_" + __cUserId + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + "_.txt"
Default cMsgLog		:= ""
Private lMsErroAuto	:= .F.
Private INCLUI 		:= nOpcX == 3
Private ALTERA 		:= nOpcX == 4
Private EXCLUI 		:= nOpcX == 5

While (cAliasSDW)->(!Eof())
	SDW->(dbGoTo((cAliasSDW)->R_E_C_N_O_))
	If !Empty( SDW->DW_PRODUTO )
		cMsgLog += "*Excluindo permissões do produto " + AllTrim( SDW->DW_PRODUTO ) + " existentes na filial " + cFilAnt + CRLF
		SDW->( dbSetOrder( 1 ) )	//DW_FILIAL+DW_PRODUTO+DW_USER+DW_DOC
	Else
		cMsgLog += "*Excluindo permissões do grupo " + AllTrim( SDW->DW_GRPPROD ) + " existentes na filial " + cFilAnt + CRLF
		SDW->( dbSetOrder( 3 ) )	//DW_FILIAL+DW_GRPPROD+DW_USER+DW_DOC
	EndIf
	AAdd( aDadSDW, { "DW_PRODUTO"	, SDW->DW_PRODUTO	, Nil } )
	AAdd( aDadSDW, { "DW_GRPPROD"	, SDW->DW_GRPPROD	, Nil } )
	AAdd( aDadSDW, { "DW_USER"		, SDW->DW_USER		, Nil } )
	AAdd( aDadSDW, { "DW_DOC"		, SDW->DW_DOC		, Nil } )
	AAdd( aDados, { "MATA014_CAB", aDadSDW } )

	FWMVCRotAuto( FwLoadModel ("MATA014"),"SDW",MODEL_OPERATION_DELETE, aDados )
	//MSExecAuto({|x,y,z| MATA014( x, y, z ) }, nOpcX, aDadSDW, Nil )
	If lMsErroAuto
		fCriaDir( cPathTmp )
		MostraErro( cPathTmp, cArqTmp )
		cMsgLog += "Erro: " + MemoRead( cPathTmp + cArqTmp )
		cMsgLog += CRLF + CRLF
		FErase( cPathTmp + cArqTmp )
	Else
		SDW->(dbGoTo((cAliasSDW)->R_E_C_N_O_))
		If SDW->( !Deleted( ) )
			RecLock( "SDW", .F. )
				SDW->( dbDelete( ) )
			SDW->( MsUnlock( ) )
		EndIf
		cMsgLog += "-->OK" + CRLF
	EndIf
	(cAliasSDW)->(dbSkip())
EndDo

Return !lMsErroAuto
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCpyEstru ºAutor  ³ Vinícius Moreira   º Data ³ 09/05/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia registros                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCpyEstru( cChvSDW, aDadSDW, aDadSDWIt, cMsgLog )

Local aDados		:= { }
Local nOpcX			:= 3
Local cPathTmp		:= "\Copia_Filiais\"
Local cArqTmp 		:= "est003_i_" + AllTrim( cChvSDW ) + "_" + AllTrim( cFilAnt ) + "_" + __cUserId + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + "_.txt"
Default cMsgLog		:= ""
Private lMsErroAuto	:= .F.
Private INCLUI 		:= nOpcX == 3
Private ALTERA 		:= nOpcX == 4
Private EXCLUI 		:= nOpcX == 5

//aDadSDW := fChkCpos( aDadSDW )
//AEval( aDadSDWIt, {|x,y| aDadSDWIt[y] := fChkCpos( x ) } )

cMsgLog += "*Criando permissões na filial " + cFilAnt + CRLF
AAdd( aDados, { "MATA014_CAB", aDadSDW } )
AAdd( aDados, { "MATA014_SDW", aDadSDWIt } )
FWMVCRotAuto( FwLoadModel ("MATA014"),"SDW",MODEL_OPERATION_INSERT, aDados ) 
//MSExecAuto({|x,y,z| MATA014( x, y, z ) }, nOpcX, aDadSDW, aDadSDWIt )	
If lMsErroAuto
	fCriaDir( cPathTmp )
	MostraErro( cPathTmp, cArqTmp )
	MemoWrite( cPathTmp+StrTran( cArqTmp, "_i_", "_i_DADOS_" ), VarInfo("SDW",aDadSDW,,.F.) + CRLF + Replicate( "-", 50 ) + CRLF + VarInfo("SDW",aDadSDWIt,,.F.) )
	cMsgLog += "Erro: " + MemoRead( cPathTmp + cArqTmp )
	cMsgLog += CRLF + CRLF
	FErase( cPathTmp + cArqTmp )
Else
	cMsgLog += "-->OK" + CRLF
EndIf

Return !lMsErroAuto
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
Static Function fGetFields( cAliasAtu, cNotShow, cYesShow )

Local aRet 			:= { }
Local cCampo		:= ""
Default cNotShow	:= ""
Default cYesShow	:= ""

dbSelectArea( "SX3" )
SX3->( dbSetOrder( 1 ) )//X3_ARQUIVO
If SX3->( dbSeek( cAliasAtu ) )
	While SX3->( !Eof( ) ) .And. SX3->X3_ARQUIVO == cAliasAtu
		cCampo := AllTrim( SX3->X3_CAMPO ) + "|"
		If !cCampo $ cNotShow 
			If ( !Empty( cYesShow ) .And. cCampo $ cYesShow ) .Or. ( Empty( cYesShow ) .And. X3Uso( SX3->X3_USADO ) .And. SX3->X3_CONTEXT != "V" )  
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

Local nC	:= 0
Local aRet	:= { }

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
±±ºPrograma  ³ EST003JobºAutor  ³ Vinícius Moreira   º Data ³ 29/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta ambiente pra execução do JOB.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EST003Job( cCodPro, cDesc, cGrpPro, cFilDes, aAllRegs, cEmpDes, cEmpAtu, cFilAtu )

Local cRet 		:= ""

RpcSetType( 3 )
RpcSetEnv( cEmpDes, cFilDes, , , "EST" )
cRet := fProcAll( cCodPro, cDesc, cGrpPro, cFilDes, aAllRegs, cEmpDes, cEmpAtu, cFilAtu )
RpcClearEnv()

Return cRet 
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
Static Function fCarrAlias( cCodPro, cGrpProd, cAliasSDW, cEmpOri, cFilOri )

Local cQuery := ""

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM SDW" + cEmpOri + "0 SDW " + CRLF 
cQuery += "  WHERE SDW.DW_FILIAL  = '" + cFilOri + "' " + CRLF
If !Empty( cCodPro ) 
	cQuery += "    AND SDW.DW_PRODUTO = '" + cCodPro + "' " + CRLF
EndIf
If !Empty( cGrpProd )
	cQuery += "    AND SDW.DW_GRPPROD = '" + cGrpProd + "' " + CRLF
EndIf 
cQuery += "    AND SDW.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    SDW.R_E_C_N_O_ " + CRLF 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasSDW,.F.,.T.)

Return 