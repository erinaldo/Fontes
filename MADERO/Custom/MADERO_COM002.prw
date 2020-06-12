#Include "Protheus.ch"                    
#Include "FwCommand.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! COM002                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descri��o        ! Copia da tabela de pre�o de compras.                                          !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Vin�cius Moreira                                                              !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 10/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/ 
User Function COM002( )

Local oWizard 		:= FWWizardControl( ):New( )
Local oStep
Local oBrowReg, oBrowFil
Local oTmpReg , oTmpFil, oTmpRes
Private cAliasQry	:= GetNextAlias()
Private cFornDe		:= Space(TamSx3("AIA_CODFOR")[1])
Private cFornAte	:= Space(TamSx3("AIA_CODFOR")[1])
Private cTabDe		:= Space(TamSx3("AIA_CODTAB")[1])
Private cTabAte		:= Space(TamSx3("AIA_CODTAB")[1])

oWizard:SetSize( { 600, 800 } )
oWizard:ActiveUISteps( )

oStep := oWizard:AddStep( "1" )
oStep:SetStepDescription( "Origem" )
oStep:SetConstruction( { |oPanel| fStep01( oPanel )  })
oStep:SetNextAction( { || fGetRegs( ) } )
oStep:SetPrevAction( { || Alert("Op��o inv�lida."), .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avan�ar" )

oStep := oWizard:AddStep( "2" )
oStep:SetStepDescription( "Tabela de pre�o" )
oStep:SetConstruction( { |oPanel| oTmpReg := fStep02( oPanel, oBrowReg := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || fChkMarca( oTmpReg:GetAlias( ) ) } )
oStep:SetPrevAction( { || Alert("Op��o inv�lida."), .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avan�ar" )

oStep := oWizard:AddStep( "3" )
oStep:SetStepDescription( "Filiais" )
oStep:SetConstruction( { |oPanel| oTmpFil := fStep03( oPanel, oBrowFil := FWBrowse( ):New( ) )  })
oStep:SetNextAction( { || fChkMarca( oTmpFil:GetAlias( ) ) } )
oStep:SetPrevAction( { || Alert("Op��o inv�lida."), .F. } )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avan�ar" )

oStep := oWizard:AddStep( "4" )
oStep:SetStepDescription( "Processamento" )
oStep:SetConstruction( { |oPanel| fStep04( oPanel, oTmpReg, oTmpFil, @oTmpRes )  })
oStep:SetNextAction( { || fAllLog( oTmpRes:GetAlias( ) ), .T. } )
oStep:SetPrevAction( { || Alert("Op��o inv�lida."), .F.} )
oStep:SetCancelAction( {|| .T. } )
oStep:SetNextTitle( "Avan�ar" )

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fStep01  �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela do primeiro passo.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fStep01( oPanel )

Local nLinha := 10

TGet():New(nLinha    ,20, bSetGet(cEmpAnt),oPanel, 10, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Empresa ',1,oPanel:oFont)
TGet():New(nLinha+7.5,40, bSetGet(FWEmpName(cEmpAnt)),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cFilAnt),oPanel, (FWSizeFilial()*5), 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,'Filial',1,oPanel:oFont)
TGet():New(nLinha+7.5,30+((FWSizeFilial()*5)), bSetGet(FWFilialName()),oPanel, 150, 12 , "@X",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,/*cReadVar*/,,,,,,,)

nLinha += 40
TGet():New(nLinha    ,20, bSetGet(cFornDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA2",cFornDe,,,,,,,'Fornecedor de',1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cFornAte),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA2",cFornAte,,,,,,,'Fornecedor ate',1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cTabDe),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"AIA",cTabDe,,,,,,,'Tabela de',1,oPanel:oFont)
nLinha += 25
TGet():New(nLinha    ,20, bSetGet(cTabAte),oPanel, 120, 12 , "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"AIA",cTabAte,,,,,,,'Tabela ate',1,oPanel:oFont)

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetRegs �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca registros que ser�o processados.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetRegs( )

Local cQuery	:= ""
Local lRet		:= .F.

cQuery += "  SELECT " + CRLF 
cQuery += "    AIA.AIA_CODFOR CODFOR " + CRLF
cQuery += "   ,AIA.AIA_LOJFOR LOJFOR " + CRLF
cQuery += "   ,SA2.A2_NOME    NOME " + CRLF
cQuery += "   ,AIA.AIA_CODTAB TABELA " + CRLF
cQuery += "   FROM " + RetSQLName( "AIA" ) + " AIA " + CRLF
cQuery += "  INNER JOIN " + RetSQLName( "SA2" ) + " SA2 ON " + CRLF
cQuery += "        SA2.A2_FILIAL  = '" + xFilial( "SA2" ) + "' " + CRLF
cQuery += "    AND SA2.A2_COD     = AIA.AIA_CODFOR " + CRLF
cQuery += "    AND SA2.A2_LOJA    = AIA.AIA_LOJFOR " + CRLF
cQuery += "    AND SA2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  WHERE AIA.AIA_FILIAL  = '" + xFilial( "AIA" ) + "' " + CRLF
cQuery += "    AND AIA.AIA_CODFOR  BETWEEN '" + cFornDe + "' AND '" + cFornAte + "' " + CRLF
cQuery += "    AND AIA.AIA_CODTAB  BETWEEN '" + cTabDe + "' AND '" + cTabAte + "' " + CRLF 
cQuery += "    AND AIA.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  GROUP BY " + CRLF
cQuery += "    AIA.AIA_CODFOR " + CRLF
cQuery += "   ,AIA.AIA_LOJFOR " + CRLF
cQuery += "   ,SA2.A2_NOME " + CRLF
cQuery += "   ,AIA.AIA_CODTAB " + CRLF
cQuery += "  ORDER BY " + CRLF
cQuery += "    AIA.AIA_CODFOR " + CRLF
cQuery += "   ,AIA.AIA_LOJFOR " + CRLF
cQuery += "   ,AIA.AIA_CODTAB " + CRLF
cAliasQry := MPSysOpenQuery( cQuery )
lRet := ( cAliasQry )->( !Eof( ) )
If !lRet
	Alert( "N�o foram encontrados registros para processamento" )
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fStep02  �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela do segundo passo.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
oMark:AddIndex( "01", { "CODFOR", "LOJFOR", "TABELA" } )
oMark:Create( )
cAliasAux := oMark:GetAlias( )

While ( cAliasQry )->( !Eof( ) )
	RecLock( cAliasAux, .T. )
		( cAliasAux )->OK 			:= .F.
		( cAliasAux )->CODFOR 		:= ( cAliasQry )->CODFOR
		( cAliasAux )->LOJFOR		:= ( cAliasQry )->LOJFOR
		( cAliasAux )->NOME			:= ( cAliasQry )->NOME
		( cAliasAux )->TABELA 		:= ( cAliasQry )->TABELA
	( cAliasAux )->( MsUnlock( ) )
	( cAliasQry )->( dbSkip( ) )
EndDo
( cAliasQry )->( dbCloseArea( ) )
//Final da montagem da tabela temporaria
//Inicio do browser de exibi��o dos registros
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasAux )
oBrowse:AddMarkColumns( ;
	{|| If( ( cAliasAux )->OK , "LBOK", "LBNO" ) },;
	{||  ( cAliasAux )->OK :=  ! ( cAliasAux )->OK } ,;
	{|| MarkAll( oBrowse ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasAux )->CODFOR 	},"Codigo"		, Len( AIA->AIA_CODFOR ), , "C") ,;
	AddColumn({|| ( cAliasAux )->LOJFOR		},"Loja"		, Len( AIA->AIA_LOJFOR ), , "C") ,;
	AddColumn({|| ( cAliasAux )->NOME 		},"Nome"		, Len( SA2->A2_NOME )	, , "C") ,;
	AddColumn({|| ( cAliasAux )->TABELA 	},"Tabela"		, Len( AIA->AIA_CODTAB ), , "C")  ;
})
oBrowse:SetDoubleClick({|| ( cAliasAux )->OK := !( cAliasAux )->OK })

oBrowse:DisableReport()
oBrowse:DisableConfig()
oBrowse:DisableFilter()
oBrowse:Activate()
//Final do browser de exibi��o dos registros

Return oMark
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fStep03  �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela do terceiro passo.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//Inicio do browser de exibi��o das filiais
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
//Final do browser de exibi��o das filiais

Return oMark
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fStep04  �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela do quarto passo.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//Inicio do browser de exibi��o dos registros
oBrowse:= FWBrowse( ):New( )
oBrowse:SetDescription("")
oBrowse:SetOwner( oPanel )
oBrowse:SetDataTable( .T. )
oBrowse:SetAlias( cAliasRes )
oBrowse:AddStatusColumns( { || If( ( cAliasRes )->SUCESSO == 1 , 'BR_VERDE', If( ( cAliasRes )->SUCESSO == 2, 'BR_VERMELHO', 'BR_AMARELO') ) } )

oBrowse:SetColumns({;
	AddColumn({|| ( cAliasReg )->CODFOR 	},"Codigo"		, Len( AIA->AIA_CODFOR ), , "C") ,;
	AddColumn({|| ( cAliasReg )->LOJFOR		},"Loja"		, Len( AIA->AIA_LOJFOR ), , "C") ,;
	AddColumn({|| ( cAliasReg )->NOME 		},"Nome"		, Len( SA2->A2_NOME )	, , "C") ,;
	AddColumn({|| ( cAliasReg )->TABELA 	},"Tabela"		, Len( AIA->AIA_CODTAB ), , "C") ,;
	AddColumn({|| ( cAliasRes )->FILIAL 	},"Filial"		, FWSizeFilial( )		, , "C") ,;
	AddColumn({|| ( cAliasRes )->MSG		},"Msg.Erro"	, 150					, , "C")  ;
})
oBrowse:SetDoubleClick({|| fShowErro( ( cAliasRes )->MSGLOG ) })

oBrowse:DisableReport()
oBrowse:DisableConfig()
oBrowse:DisableFilter()
oBrowse:Activate()
//Final do browser de exibi��o dos registros

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fProcRegs �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa grava��o dos registros.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static aAIAFields := { }
Static aAIBFields := { }
Static Function fProcRegs( nRegs, cAliasReg, aFilDes )
Local cMsg			:= ""
Local cMsgLog 		:= ""
Local nSucesso		:= 3
Local aAllRegs		:= { }
Local nPosFor		:= 0
Local nPosPrd		:= 0
Local cAux			:= ""

ProcRegua( nRegs+1 )
IncProc( "Agrupando produtos das tabelas e fornecedores..." )
( cAliasReg )->( dbGoTop( ) )
While ( cAliasReg )->( !Eof( ) )
	AAdd( aAllRegs, { 	( cAliasReg )->CODFOR,;			//01
	 					( cAliasReg )->LOJFOR,;			//02
	 					( cAliasReg )->NOME,;			//03
	 					( cAliasReg )->TABELA,;			//04
	 					( cAliasReg )->FILIAL,;			//05
	 					{ },; 							//06
	 					( cAliasReg )->EMPRESA,;		//07
	 					( cAliasReg )->( Recno( ) ) } )	//08
	( cAliasReg )->( dbSkip( ) )
EndDo

For nPosFor := 1 to Len( aAllRegs )
	IncProc( "Processando tabela " + aAllRegs[nPosFor,4] + " na filial " + aAllRegs[nPosFor,5] )
	cMsgLog += "Processando tabela " + aAllRegs[nPosFor,4] + " na filial " + aAllRegs[nPosFor,5] + CRLF

	If ( cAliasReg )->EMPRESA == cEmpAnt
		cAux := fProcAll( aAllRegs[nPosFor, 1], aAllRegs[nPosFor, 2], aAllRegs[nPosFor, 3], aAllRegs[nPosFor, 4], aAllRegs[nPosFor, 6], aAllRegs[nPosFor, 5], cEmpAnt)
	Else
		cAux := StartJob("U_COM002Job", GetEnvServer( ), .T., aAllRegs[nPosFor, 1], aAllRegs[nPosFor, 2], aAllRegs[nPosFor, 3], aAllRegs[nPosFor, 4], aAllRegs[nPosFor, 6], aAllRegs[nPosFor, 5], aAllRegs[nPosFor, 7], cEmpAnt, cFilAnt)
	EndIf
	
	cMsgLog += SubStr( cAux, 3 )
	cAux	:= SubStr( cAux, 1, 2 )
	
	If cAux == "OK"
		nSucesso 	:= 1 
		cMsg		:= "Gravado com sucesso."
	ElseIf cAux == "ER"
		nSucesso 	:= 2
		cMsg		:= "Ocorreram erros durante o processamento." 
	Else
		nSucesso 	:= 3
		cMsg		:= "Copia realizada com advertencias."
	EndIf
	
	( cAliasReg )->( dbGoTo( aAllRegs[nPosFor, 8] ) )
	RecLock( cAliasReg, .F. )
		( cAliasReg )->SUCESSO	:= nSucesso
		( cAliasReg )->MSG		:= cMsg
		( cAliasReg )->MSGLOG 	:= cMsgLog
	( cAliasReg )->( MsUnlock( ) )
	
	cMsgLog	:= ""
	cMsg	:= ""
	nSucesso:= 3
	cAux	:= ""
Next nPosFor

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fProcAll �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa os produtos conforme ordena��o.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fProcAll( cCodFor, cLojFor, cNomFor, cCodTab, aAllRegs, cFilDes, cEmpDes, cEmpAtu, cFilAtu )

Local cEmpBkp 	:= cEmpAnt
Local cFilBkp 	:= cFilAnt
Local nModBkp	:= nModulo
Local lRet		:= .T.
Local nX 		:= 1
Local aDadAIA	:= { }
Local aDadAIB	:= { }
Local lJaExiste	:= .F.
Local aRotAnt	:= If( Type( "aRotina" ) != "U", AClone( aRotina ), { } )
Local cQuery	:= " "
Local cAliasAIA	:= GetNextAlias()
Local cAliasAIB	:= GetNextAlias()
Local cMsgLog	:= ""
Local lAlerta	:= .F.
Local aItens	:= { }
Default cEmpAtu	:= cEmpAnt
Default cFilAtu	:= cFilAnt
Private aRotina	:= StaticCall( COMA010, MenuDef )

If Len( aAIAFields ) == 0
	aAIAFields := fGetFields( "AIA" )
	aAIBFields := fGetFields( "AIB", "", )
EndIf

fCarrAlias( cCodFor, cLojFor, cCodTab, @cAliasAIA, @cAliasAIB, cEmpAtu, cFilAtu )

nModulo := 2
cEmpAnt := cEmpDes
cFilAnt := cFilDes
SM0->( dbSeek( cEmpAnt + cFilAnt ) )

//Checando a existencia dos produtos no destino
SB1->( dbSetOrder( 1 ) )
While ( cAliasAIB )->( !Eof( ) )
	If SB1->( dbSeek( cFilDes + ( cAliasAIB )->AIB_CODPRO ) )
		AAdd( aItens, ( cAliasAIB )->AIB_ITEM )
	Else
		lAlerta := .T.
		cMsgLog += "--> Alerta: Produto " + ( cAliasAIB )->AIB_CODPRO + " nao encontrado no destino." + CRLF
	EndIf	
	( cAliasAIB )->( dbSkip( ) )
EndDo

If Len( aItens ) == 0
	lRet := .F.
	cMsgLog += "Erro: Nenhum produto encontrado para processamento"
Else
	Begin Transaction
	( cAliasAIB )->( dbGoTop( ) )
	AIA->( dbSetOrder( 1 ) )	//AIA_FILIAL+AIA_CODFOR+AIA_LOJFOR+AIA_CODTAB
	If AIA->( dbSeek( xFilial( "AIA" ) + cCodFor + cLojFor + cCodTab ) )
		cMsgLog += "--> Deletando tabela existente no destino." + CRLF
		If !fExclEstru( cCodFor, cLojFor, cCodTab, @cMsgLog )
			lRet := .F.
			DisarmTransaction( )
		EndIf
	EndIf
				    
	If lRet
		If (cAliasAIA)->( !Eof( ) )	
			SE4->( dbSetOrder( 1 ) )	//E4_FILIAL+E4_CODIGO
			If !Empty( (cAliasAIA)->AIA_CONDPG ) .And. !SE4->( dbSeek( xFilial( "SE4" ) + (cAliasAIA)->AIA_CONDPG ) )
				lRet := .F.
				cMsgLog := "Erro: Condi��o de pagamento " + (cAliasAIA)->AIA_CONDPG + " n�o encontrada no destino " + CRLF
			Else
			
				aDadAIA := fMntDados( cAliasAIA, aAIAFields )		
				While (cAliasAIB)->( !Eof( ) )
					If AScan( aItens, { |x,y| x == (cAliasAIB)->AIB_ITEM }  ) > 0
						AAdd( aDadAIB, fMntDados( cAliasAIB, aAIBFields ) )
					EndIf
					(cAliasAIB)->( dbSkip( ) )
				EndDo
				
				cMsgLog += "*Criando tabela de pre�os na filial " + cFilAnt + CRLF 
				If !fCpyEstru( cCodTab, aDadAIA, aDadAIB, @cMsgLog )
					lRet := .F.
					DisarmTransaction( )
				EndIf
				
				aDadAIA	:= { }
				aDadAIB	:= { }		
			EndIf
		EndIf
	EndIf
	End Transaction
EndIf
( cAliasAIA )->(dbCloseArea())
( cAliasAIB )->(dbCloseArea())

cEmpAnt := cEmpBkp
cFilAnt := cFilBkp
SM0->( dbSeek( cEmpAnt + cFilAnt ) )
nModulo	:= nModBkp
aRotina := aRotAnt

If lRet
	If lAlerta
		cMsgLog := "WA" + cMsgLog
	Else
		cMsgLog := "OK" + cMsgLog
	EndIf
Else
	cMsgLog := "ER" + cMsgLog
EndIf

Return cMsgLog
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MarkAll  �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para marcar/desmarcar todos os registros.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function MarkAll(oBrowse)

(oBrowse:GetAlias())->( dbGotop() )
(oBrowse:GetAlias())->( dbEval({|| OK := !OK },, { || ! Eof() }))
(oBrowse:GetAlias())->( dbGotop() )

oBrowse:Refresh(.T.)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AddColumn �Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria��o das colunas.                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGerTmpRes�Autor  � Vin�cius Moreira   � Data � 06/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta TMP de resultados.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGerTmpRes( cAliasReg, aFilDes )

Local cAliasRes	:= ""
Local oTmpRes	:= FWTemporaryTable( ):New( )
Local nX		:= 0 

//--Inicio da montagem da tabela temporaria
//Acrescenta o campo de mark
oTmpRes:SetFields({ ;
		{"CODFOR"	, "C", Len( AIA->AIA_CODFOR )	, 0},;
		{"LOJFOR"	, "C", Len( AIA->AIA_LOJFOR ) 	, 0},;
		{"NOME"		, "C", Len( SA1->A1_NOME )		, 0},;
		{"TABELA"	, "C", Len( AIA->AIA_CODTAB )	, 0},;
		{"EMPRESA"	, "C", Len( cEmpAnt )			, 0},;
		{"FILIAL"	, "C", FWSizeFilial()			, 0},;
		{"SUCESSO"	, "N", 1						, 0},;
		{"MSGLOG"	, "M", 80						, 0},;
		{"MSG"		, "C", 150, 0};
	})

//Definindo indice
oTmpRes:AddIndex( "01", { "EMPRESA", "FILIAL", "CODFOR", "LOJFOR" } )
oTmpRes:Create( )
cAliasRes := oTmpRes:GetAlias( )

While ( cAliasReg )->( !Eof( ) )
	If ( cAliasReg )->OK
		For nX := 1 to Len( aFilDes )
			RecLock( cAliasRes, .T. )
				( cAliasRes )->SUCESSO 		:= 3
				( cAliasRes )->CODFOR 		:= ( cAliasReg )->CODFOR
				( cAliasRes )->LOJFOR		:= ( cAliasReg )->LOJFOR
				( cAliasRes )->NOME 		:= ( cAliasReg )->NOME
				( cAliasRes )->TABELA		:= ( cAliasReg )->TABELA
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCpyEstru �Autor  � Vin�cius Moreira   � Data � 09/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Copia registros                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCpyEstru( cCodTab, aDadAIA, aDadAIB, cMsgLog )

Local nOpcX			:= 3
Local cPathTmp		:= "\Copia_Filiais\"
Local cArqTmp 		:= "est002_i_" + AllTrim( cCodTab ) + "_" + AllTrim( cFilAnt ) + "_" + __cUserId + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + "_.txt"
Default cMsgLog		:= ""
Private lMsErroAuto	:= .F.
Private INCLUI 		:= nOpcX == 3
Private ALTERA 		:= nOpcX == 4
Private EXCLUI 		:= nOpcX == 5

aDadAIA := fChkCpos( aDadAIA )
AEval( aDadAIB, {|x,y| aDadAIB[y] := fChkCpos( x ) } )

MSExecAuto({|x,y,z| COMA010( x, y, z ) }, nOpcX, aDadAIA, aDadAIB )	
If lMsErroAuto
	fCriaDir( cPathTmp )
	MostraErro( cPathTmp, cArqTmp )
	MemoWrite( cPathTmp+StrTran( cArqTmp, "_i_", "_i_DADOS_" ), VarInfo("AIA",aDadAIA,,.F.) + CRLF + Replicate( "-", 50 ) + CRLF + VarInfo("AIB",aDadAIB,,.F.) )
	cMsgLog += "Erro: " + MemoRead( cPathTmp + cArqTmp )
	cMsgLog += CRLF + CRLF
	FErase( cPathTmp + cArqTmp )
Else
	cMsgLog += "-->OK" + CRLF
EndIf

Return !lMsErroAuto
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetFields�Autor  � Vin�cius Moreira   � Data � 29/07/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca campos em uso para o alias.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			If ( X3Uso( SX3->X3_USADO ) .And. SX3->X3_CONTEXT != "V" ) .Or. X3Obrigat( SX3->X3_CAMPO ) .Or. cCampo $ cYesShow 
				AAdd( aRet, { SX3->X3_CAMPO, SX3->X3_TIPO, Nil } )
			EndIf
		EndIf
		SX3->( dbSkip( ) )
	EndDo
EndIf

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMntDados�Autor  � Vin�cius Moreira   � Data � 07/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Auxilia na montagem do vetor do ExecAuto.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCriaDir �Autor  � Vin�cius Moreira   � Data � 29/07/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria diretorios utilizados pelo programa.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCriaDir(cPatch, cBarra)
	
Local lRet   := .T.
Local aDirs  := {}
Local nPasta := 1
Local cPasta := ""
Default cBarra	:= "\"
//�����������������������������������������������Ŀ
//�Criando diret�rio de configura��es de usu�rios.�
//�������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fAllLog  �Autor  � Vin�cius Moreira   � Data � 07/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Auxilia na montagem do vetor do ExecAuto.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fShowErro�Autor  � Vin�cius Moreira   � Data � 07/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibe erro em tela.                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fChkMarca�Autor  � Vin�cius Moreira   � Data � 09/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se algum registro foi selecionado.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fChkCpos �Autor  � Vin�cius Moreira   � Data � 26/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa ordem dos campos para execu��o do MsExecAuto.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COM002Job�Autor  � Vin�cius Moreira   � Data � 29/08/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta ambiente pra execu��o do JOB.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function COM002Job( cCodFor, cLojFor, cNomFor, cCodTab, aAllRegs, cFilDes, cEmpDes, cEmpAtu, cFilAtu )

Local cRet 		:= ""

RpcSetType( 3 )
RpcSetEnv( cEmpDes, cFilDes, , , "EST" )
cRet := fProcAll( cCodFor, cLojFor, cNomFor, cCodTab, aAllRegs, cFilDes, cEmpDes, cEmpAtu, cFilAtu )
RpcClearEnv()

Return cRet 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCarrAlias�Autor  � Vin�cius Moreira   � Data � 28/08/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os alias das tabelas envolvidas buscando informa-  ���
���          � ��o nas outras empresas.                                   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCarrAlias( cCodFor, cLojFor, cCodTab, cAliasAIA, cAliasAIB, cEmpOri, cFilOri )

Local cQuery := ""

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM AIA" + cEmpOri + "0 AIA " + CRLF 
cQuery += "  WHERE AIA.AIA_FILIAL  = '" + cFilOri + "' " + CRLF
cQuery += "    AND AIA.AIA_CODFOR  = '" + cCodFor + "' " + CRLF
cQuery += "    AND AIA.AIA_LOJFOR  = '" + cLojFor + "' " + CRLF 
cQuery += "    AND AIA.AIA_CODTAB  = '" + cCodTab + "' " + CRLF 
cQuery += "    AND AIA.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    AIA.R_E_C_N_O_ " + CRLF 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasAIA,.F.,.T.)

cQuery := "  SELECT " + CRLF 
cQuery += "    * " + CRLF 
cQuery += "   FROM AIB" + cEmpOri + "0 AIB " + CRLF 
cQuery += "  WHERE AIB.AIB_FILIAL  = '" + cFilOri + "' " + CRLF
cQuery += "    AND AIB.AIB_CODFOR  = '" + cCodFor + "' " + CRLF
cQuery += "    AND AIB.AIB_LOJFOR  = '" + cLojFor + "' " + CRLF 
cQuery += "    AND AIB.AIB_CODTAB  = '" + cCodTab + "' " + CRLF 
cQuery += "    AND AIB.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  ORDER BY " + CRLF 
cQuery += "    AIB.R_E_C_N_O_ " + CRLF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAliasAIB,.F.,.T.) 

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExclEstru�Autor  � Vin�cius Moreira   � Data � 08/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica necessidade de exclus�o dos registros do destino. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fExclEstru( cCodFor, cLojFor, cCodTab, cMsgLog )

Local aDadAIA		:= { }
Local nOpcX			:= 5
Local cPathTmp		:= "\Copia_Filiais\"
Local cArqTmp 		:= "COM002_e_" + AllTrim( cCodTab ) + "_" + AllTrim( cFilAnt ) + "_" + __cUserId + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + "_.txt"
Default cMsgLog		:= ""
Private lMsErroAuto	:= .F.
Private INCLUI 		:= nOpcX == 3
Private ALTERA 		:= nOpcX == 4
Private EXCLUI 		:= nOpcX == 5

AAdd( aDadAIA, { "AIA_CODFOR"	, AIA->AIA_CODFOR	, Nil } )
AAdd( aDadAIA, { "AIA_LOJFOR"	, AIA->AIA_LOJFOR	, Nil } )
AAdd( aDadAIA, { "AIA_CODTAB"	, AIA->AIA_CODTAB	, Nil } )

MSExecAuto({|x,y,z| COMA010( x, y, z ) }, nOpcX, aDadAIA, {} )
If lMsErroAuto
	fCriaDir( cPathTmp )
	MostraErro( cPathTmp, cArqTmp )
	cMsgLog += "Erro: " + MemoRead( cPathTmp + cArqTmp )
	cMsgLog += CRLF + CRLF
	FErase( cPathTmp + cArqTmp )
Else
	cMsgLog += "-->OK" + CRLF
EndIf

Return !lMsErroAuto