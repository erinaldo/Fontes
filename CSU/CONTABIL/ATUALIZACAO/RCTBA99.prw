#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"       

#DEFINE STR001 "Selecione o diretorio de grava็ใo do arquivo de rateio."
#DEFINE GD_INSERT	1
#DEFINE GD_DELETE	4	
#DEFINE GD_UPDATE	2
#DEFINE c_BR Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBA99   บAutor  ณVinํcius Greg๓rio   บ Data ณ  22/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Regras de Rateio - Modelo 3                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBA99()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cAliaZB7		:= GetNextAlias() 
Local cUsrLog		:= __cUserID 
Local cCodRat		:= ""
Local cCodIN		:= "" 
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.02.17 - Inclusใo de legenda.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCores    := {	{'ZB7_COMPON=="1"'						,'BR_AMARELO'	},;
						{'ZB7_PROCESS=="S"'						,'BR_VERMELHO'	},;	// Tabela jแ processada
					 	{'ZB7_PROCESS=="N" .and. !U_RCTB99Y()'	,'BR_VERDE'		},;	// Tabela nunca processada e com os itens nใo preenchidos
					 	{'ZB7_PROCESS=="N" .and. U_RCTB99Y()'	,'BR_AZUL'		}}	// Tabela nunca processada e com os itens preenchidos

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.08.03ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg			:= "CTBA99"
Local aRegs			:= {}

Private cAnoMesD	:= ""
Private cAnoMesA	:= ""					 	
					 	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.25                        ณ
//ณAltera็ใo para exibir os registro rec้mณ
//ณgravados.                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lDefTop		:= .F.
Private cAlias 		:= "ZB7"					 	

Private cFilterZB7	:= ""
Private cCadastro 	:= "Cadastro de Tabelas de Rateio"
Private aRotina 	:= MenuDef()
Private aIndexZB7	:= {}
Private bFiltraBrw	:= {|| FilBrowse(cAlias,@aIndexZB7,@cFilterZB7,.T.) }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPergunte no inํcio da rotina.          ณ
//ณNecessแrio para filtrar a quantidade deณ
//ณtabelas de rateio que farใo parte do   ณ
//ณfiltro de usuแrio.                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aRegs,{cPerg,"01","Compet๊ncia De"			,"","","mv_ch1","D",08,0,0,"G",""			,"MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Compet๊ncia At้"		,"","","mv_ch2","D",08,0,0,"G",""			,"MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Tabela Rateio De"		,"","","mv_ch3","C",06,0,0,"G",""			,"MV_PAR03","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })
aAdd(aRegs,{cPerg,"04","Tabela Rateio At้"		,"","","mv_ch4","C",06,0,0,"G",""			,"MV_PAR04","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })

CriaSx1(aRegs)     
If !Pergunte(cPerg,.T.) 
	Return .F.
Endif

cAnoMesD	:= SubStr(DTOS(MV_PAR01),1,6)
cAnoMesA	:= SubStr(DTOS(MV_PAR02),1,6)

//If cUserfull != cUsrLog
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPermite mais de um administrador para a tela.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !(cUsrLog$Alltrim(cUserfull))

   	BeginSql Alias cAliaZB7 
		Select ZB6_CODRAT,ZB7_ANOMES from %table:ZB6% ZB6 (NOLOCK), %table:ZB7% ZB7 (NOLOCK)
		WHERE ZB6_FILIAL = %xFilial:ZB6% AND ZB6_USUARI = %exp:cUsrLog% AND ZB6.%NotDel%
		AND ZB6_CODRAT = ZB7_CODRAT AND ZB6_CODRAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
		AND ZB7_ANOMES BETWEEN %exp:cAnoMesD% AND %exp:cAnoMesA% AND ZB7.%NotDel%  
		                                                                                
	  /*	cQuery:=" SELECT DISTINCT ZB6_CODRAT,ZB7_ANOMES FROM ZB7050,ZB6050 "
	  	cQuery+=" WHERE ZB6_CODRAT = ZB7_CODRAT "
	 	cQuery+=" AND ZB6_USUARI='"+cUsrLog+"' "
	 	cQuery+=" AND ZB6_CODRAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
  	    cQuery+=" AND ZB7_ANOMES BETWEEN '"+cAnoMesD+"' AND '"+cAnoMesA+"' "       */
  	    
  	  //  dbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliaZB7, .T., .F. ) 	
  	EndSQL	
	    
	(cAliaZB7)->(DbGoTop())
 	While !(cAliaZB7)->(EOF())
    	cCodRat += ALLTRIM((cAliaZB7)->ZB6_CODRAT)
		(cAliaZB7)->(DbSkip())
		If !(cAliaZB7)->(EOF())         
			cCodRat += ";"
		Endif	
	EndDo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.03.25         ณ
	//ณFecha a แrea de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	(cAliaZB7)->(dbCloseArea())                                                      	
	
	cCodIN := FormatIn(ALLTRIM(cCodRat), ";")	
	
	#IFDEF TOP
		lDefTop := !(TcSrvType() == "AS/400" .Or. TcSrvType() == "iSeries")
	#ENDIF
	
	lDefTop	:= .F.//VG - 2011.03.25 - Corre็ใo para exibir os registros rec้m gravados para o usuแrio.
  //	 cAno:="'"+cAnoMesD+"','"+cAnoMesA+"'"
	chkFile(cAlias) 
	If !lDefTop
		//Executa filtro automaticamente
		cFilterZB7	:= "ZB7_CODRAT $'"+STRTRAN(STRTRAN(STRTRAN(cCodIN,")",""),"(",""),"'","")+"'"
	  //	cFilterZB7	+= " .AND. ZB7_ANOMES $'"+STRTRAN(STRTRAN(STRTRAN(cAno,")",""),"(",""),"'","")+"'"
		If Len(cFilterZB7) > 1950//2000
			Aviso("Aviso","O filtro gerado ้ muito abrangente e os resultados nใo podem ser exibidos. Por favor, revise os parโmetros de exibi็ใo.",{"OK"},,"Aten็ใo",,"BMPPERG")								
			Return .F.
		Endif
		
		DbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)
	Else
		DbSelectArea(cAlias)
		dbSetOrder(1)
		cFilterZB7	:= "ZB7_CODRAT IN"+cCodIN
	EndIf	

ElseIf (cUsrLog $Alltrim(cUserfull))
	cFilterZB7	:= "ZB7_CODRAT <> ' '" 
	Eval(bFiltraBrw)
	DbSelectArea(cAlias)
	dbSetOrder(1) 
Else                       
	DbSelectArea(cAlias)
	dbSetOrder(1) 	
Endif

//mBrowse( 6,1,22,75,cAlias,,,,,,,,,,,,,/*,Iif(lDefTop,cFilterZB7,Nil)*/)                      
mBrowse( 6,1,22,75,cAlias,,,,,,aCores,,,,,,,,Iif(lDefTop,cFilterZB7,Nil))

//Elimina arquivo temporario criado pelo filtro automatico acima
If !lDefTop
	EndFilBrw(cAlias,aIndexZB7)
Endif  

dbSelectArea(cAlias)
dbSetOrder(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99A   บAutor  ณVinํcius Greg๓rio   บ Data ณ  22/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para a manuten็ใo das regras de rateio              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99A(cAlias,nRecn,nOpcx)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                									    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaZB7		:= ZB7->(GetArea())
Local nCpo,nCnt   
Local nLoop			:= 0
Local nOpcA 		:= 0
Local lSeek
Local aObjects  	:= {}
Local aSize     	:= MsAdvSize()
Local nI			:= 0
Local nStyle 		:= IIF(nOpcX == 2 .Or. nOpcX == 5,0,GD_INSERT+GD_UPDATE+GD_DELETE)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22             ณ
//ณGrupo para as informa็๕es deณ
//ณrodap้.                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oGrpRod		:= Nil
Local oSayTot		:= Nil
Local oSayRest		:= Nil

Local bOk      		:= {|| If( Obrigatorio( oEncMain:aGets, oEncMain:aTela) .And. U_ZB8TudOk(), ( nOpcA := 1, oDlgMain:End() ), nOpcA := 0 ) }
Local bCancel  		:= {|| nOpcA := 0, oDlgMain:End() }
Local aAlias		:= {}

Local cUltRev		:= ""

Private aHeaderZB8 	:= {}
Private aColsZB8 	:= {}
Private oDlgMain
Private oEncMain
Private oFolder
Private oGetZB8	                

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22             ณ
//ณVariแvel para as informa็๕esณ
//ณde rodap้.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nTotPerc	:= 0       
Private oGetValTot	:= Nil

Private nRestPerc	:= 0
Private oGetValRest	:= Nil

Private aCampos		:= {}
Private aVisual		:= {}
Private aGets		:= {}
Private aTela		:= {}
Private bCampo		:= { |nCPO| Field( nCPO ) }                             
Private aBotao		:= {}
Private nOpc		:= nOpcx  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22                         ณ
//ณDefini็ใo da fonte para os totalizadoresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define Font oBoldIV  Name  "Arial"  Size 07 , -13 BOLD    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.01.06                               ณ
//ณVerifica se c๓digo de rateio nใo foi utilizadoณ
//ณanteriormente para permitir ou nใo a dele็ใo. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcX == 5
	If !VerifDel(ZB7->ZB7_CODRAT)// .and. ZB7->ZB7_PROCES == 'S'//VG - 2011.06.09 - trecho de c๓digo removido para impedir que os usuแrios
		//excluam tabelas jแ utilizadas em notas fiscais - solicita็ใo feita pelo usuแrio Mafaldo.
		Aviso("Aviso","O c๓digo de rateio jแ foi utilizado anteriormente e portanto nใo pode ser removido.",{"OK"},,"Aten็ใo",,"BMPPERG")			
		Return .F.  
	Endif
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAdicionar a funcionalidade de importa็ใo no aBotaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aBotao, {"DBG06" 		, { || RCTB99I()}, "Importar cadastro", "Importar" }) 
AADD(aBotao, {"PMSEXCEL" 	, { || RCTB99E()}, "Exportar cadastro", "Exportar" })
AADD(aBotao, {"EXCLUIR"		, { || RCTB99K()}, "Excluir Todos", "Exc. Todos" })
                                             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontar os campos da ZB7 para a MsMGetณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
//aAdd( aCampos, "ZB7_ANOMES" )//VG - 2011.01.17 - Altera็ใo para visualizar M๊s/Ano
aAdd( aCampos, "ZB7_MESANO" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO" )
aAdd( aCampos, "ZB7_CCTRAN" )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.02.21 - Altera็ใo para recolocar as ณ
//ณentidades contแbeis de Unidade de Neg๓cio     ณ
//ณe Opera็ใo.                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aCampos, "ZB7_ITTRAN" )
aAdd( aCampos, "ZB7_CLTRAN" )
aAdd( aCampos, "ZB7_PROCES" )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.11                  ณ
//ณInclusใo do campo com o nome     ณ
//ณdo usuแrio que cadastrou a tabelaณ
//ณde rateio.                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aCampos, "ZB7_USRNAM" )
aAdd( aCampos, "ZB7_USRFNA" )//VG - 2011.03.22
aAdd( aCampos, "NOUSER" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine a area dos objetos                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
AAdd( aObjects,{100,060, .t., .f. })
AAdd( aObjects,{100,100, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

RegToMemory("ZB7",nOpcx == 3)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega o ano/m๊sณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcX <> 3
	M->ZB7_MESANO	:= Substr(M->ZB7_ANOMES,5,2)+Substr(M->ZB7_ANOMES,1,4)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aCampos 																ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
SX3->( dbSeek("ZB8") )
aHeaderZB8 := {}
While SX3->( !Eof()) .And. SX3->X3_ARQUIVO $ "ZB8" 
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and.;                          
		( !Alltrim(SX3->X3_CAMPO) $ "ZB8_FILIAL/ZB8_CODRAT/ZB8_ANOMES/ZB8_REVISA/ZB8_CDEBIT")//VG - 2011.01.17 - remover a conta de d้bito
//		( !Alltrim(SX3->X3_CAMPO) $ "ZB8_FILIAL/ZB8_CODRAT/ZB8_ANOMES/ZB8_REVISA")
		Aadd(aHeaderZB8,{	AllTrim(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						SX3->X3_RELACAO,;
						SX3->X3_WHEN,;
						SX3->X3_VISUAL,;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})
	Endif
	SX3->(dbSkip())
EndDo

MontaAcols(aHeaderZB8,"ZB8",1,"ZB7",M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA,"ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA",aColsZB8,nOpcX) 

aSort(aColsZB8,,,{|x,y| val(x[1]) < val(y[1])})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a ๚ltima revisใo jแ foi processadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcX == 4            

	cUltRev	:= U_RZB7ULTR(M->ZB7_CODRAT,M->ZB7_ANOMES,.F.)  

	dbSelectArea("ZB7")
	dbSetOrder(1)
	If dbSeek(xFilial("ZB7")+M->ZB7_CODRAT+M->ZB7_ANOMES+cUltRev,.F.)
	
		If ZB7->ZB7_PROCESS == 'S'
					
			Aviso("Aviso","Serแ gerada uma nova revisใo para a tabela de rateio. Por favor, comunique o administrador das tabelas para ativa-la.",{"OK"},,"Aten็ใo",,"BMPPERG")			
		
			M->ZB7_REVISA	:= SOMA1(cUltRev)		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVG - 2011.03.18                                  ณ
			//ณAltera็ใo para gravar como inativa a nova revisใoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			M->ZB7_ATIVO	:= 'I'
			M->ZB7_PROCESS	:= 'N'

		ElseIf ZB7->ZB7_PROCESS <> 'S' .and. ZB7->ZB7_REVISA <> Replicate('0', TAMSX3("ZB7_REVISA")[1] )//VG - 2011.04.29 Se nใo tiver sido processada e se nใo for a primeira versใo da tabela
		
			Aviso("Aviso","Existe uma revisใo gerada para essa tabela de rateio no perํodo que ainda nใo foi processada. Por favor, entre em contato com o administrador das tabelas para maiores informa็๕es.",{"OK"},,"Aten็ใo",,"BMPPERG")
			Return .F.
					
		Endif	
	Endif

Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria a tela de digitacao do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlgMain := MSDIALOG():New(aSize[7],00,aSize[6],aSize[5],cCadastro,,,,,,,,/*oMainWnd*/,.T.)

//oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"},aCampos),1,,,,oDlgMain,,,,,,.T.,,,)
//oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"},aCampos),1,,,,oDlgMain,,,,,,.T.,,,)    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.18 - Altera็ใo para que novas revis๕es    ณ
//ณsejam geradas como inativas. Para tornแ-las ativas, ้  ณ
//ณnecessแrio que o usuแrio administrador utilize a rotinaณ
//ณde habilita็ใo de revisใo.                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),/*If(nOpcx==4,2,nOpcx)*/nOpcX,,,,aCampos,{15,5,97,620},If(nOpcX==4,If(M->ZB7_REVISA <> "000",{"NOUSER"},{"ZB7_ATIVO"/*,"ZB7_CCTRAN"*/,"NOUSER"}),aCampos),1,,,,oDlgMain,,,,,,.T.,,,)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22          ณ
//ณInclusใo de rodap้ com o ณ
//ณpercentual jแ rateado.   ณ                                                                            
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
oGrpRod		:= TGroup():New(253,05,270,620,"",oDlgMain,,,.T.)
oSayTot		:= TSay():New(258,370,{||'Perc. Distribuํdo:'},oDlgMain,,oBoldIV,,,,.T.,CLR_BLUE,CLR_WHITE,60,20)  
oGetValTot	:= TGet():New(255,433,{|u| if(PCount()>0,nTotPerc:=u,nTotPerc)}, oDlgMain,55,10,PesqPict("ZB8","ZB8_PERCEN"),/*valid*/,,,oBoldIV,,,.T.,,,{||.F.},,,,,,,'nTotPerc')

oSayRest	:= TSay():New(258,520,{||'Falta %:'},oDlgMain,,,,,,.T.,CLR_RED,CLR_WHITE,30,20)  
oGetValRest	:= TGet():New(255,553,{|u| if(PCount()>0,nRestPerc:=u,nRestPerc)}, oDlgMain,55,10,PesqPict("ZB8","ZB8_PERCEN"),/*valid*/,,,,,,.T.,,,{||.F.},,,,,,,'nRestPerc')
                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MsNewGetDados															    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                          
oGetZB8 := MsNewGetDados():New(100,05,250,620,nStyle,"U_ZB8LinOk()","U_ZB8TudOk()","+ZB8_SEQUEN",,,9999,,,,oDlgMain,aHeaderZB8,@aColsZB8)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22                ณ
//ณOnChange da GetDados atualiza oณ
//ณpercentual jแ rateado.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetZB8:bChange	:= {||RCTB99Z()}

ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,bOk,bCancel,,aBotao)

If nOpcA == 1 .And. ( nOpcx == 5 .or. nOpcx == 4 .or. nOpcx == 3 )

	Begin Transaction       
	
		If nOpcX == 5 .or. nOpcX == 4

			If nOpcX == 5      
			
				dbSelectArea("ZB7")
				ZB7->( dbSetOrder(1) )//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO
				If dbSeek(xFilial("ZB7")+M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA+M->ZB7_ATIVO,.F.)
					RecLock("ZB7",.F.)
					ZB7->( dbDelete() )
					MsUnLock()
//					FKCOMMIT()
				Endif
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVG - 2011.06.06                    ณ
				//ณAltera็ใo que verifica se existem  ณ
				//ณregistros da tabela de rateio para ณ
				//ณoutras compet๊ncias. Caso nใo      ณ
				//ณexista, remove todas as permiss๕es ณ
				//ณligadas เ tabela.                  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				dbSelectArea("ZB7")
				ZB7->( dbSetOrder(1) )//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO
				If !dbSeek(xFilial("ZB7")+M->ZB7_CODRAT,.F.)
					dbSelectArea("ZBA")
					dbSetOrder(1)//ZBA_FILIAL+ZBA_CODRAT+ZBA_USUARI
					If dbSeek(xFilial("ZBA")+M->ZB7_CODRAT,.F.)
						Do While !EOF() .and. xFilial("ZBA")+M->ZB7_CODRAT==ZBA->(ZBA_FILIAL+ZBA_CODRAT)
							RecLock("ZBA",.F.)
								ZBA->(dbDelete())							
							MsUnlock()							
							dbSelectArea("ZBA")
							ZBA->(dbSkip())						
						EndDo
					Endif					
				Endif				
				
			Endif    
			
			dbSelectArea("ZB8")
			ZB8->( dbSetOrder(1) )//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
			If dbSeek(xFilial("ZB8")+M->ZB7_CODRAT+M->ZB7_ANOMES+M->ZB7_REVISA,.F.)    
				Do While !EOF() .and. xFilial("ZB8")==ZB8->ZB8_FILIAL .and. M->ZB7_CODRAT==ZB8->ZB8_CODRAT ;
					.and. M->ZB7_ANOMES==ZB8->ZB8_ANOMES .and. M->ZB7_REVISA==ZB8->ZB8_REVISA
					
					RecLock("ZB8",.F.)
					ZB8->( dbDelete() )
					MsUnlock()
					 
					dbSelectArea("ZB8")
					dbSkip()
				EndDo			
			Endif			
		
		Endif
		
		If nOpcX == 3 .or. nOpcX ==4
		
			dbSelectArea("ZB7")  
			
			If M->ZB7_REVISA <> ZB7->ZB7_REVISA	
				RecLock("ZB7",.T.)
			Else
				RecLock("ZB7",nOpcX==3)
			Endif
			
			ZB7->ZB7_FILIAL := 	xFilial("ZB7")				
			ZB7->ZB7_CODRAT	:= 	M->ZB7_CODRAT
			ZB7->ZB7_DESCRI	:=	M->ZB7_DESCRI
//			ZB7->ZB7_ANOMES	:=	M->ZB7_ANOMES
			ZB7->ZB7_ANOMES	:=	U_RZB7AnoMes(M->ZB7_MESANO)
			ZB7->ZB7_REVISA	:=	M->ZB7_REVISA
			ZB7->ZB7_ATIVO	:=	M->ZB7_ATIVO
			ZB7->ZB7_CCTRAN	:= 	M->ZB7_CCTRAN
			//VG - 2011.02.21
			ZB7->ZB7_ITTRAN	:= 	M->ZB7_ITTRAN
			ZB7->ZB7_CLTRAN	:= 	M->ZB7_CLTRAN			
			ZB7->ZB7_PROCES	:= 	M->ZB7_PROCES
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVG - 2011.03.11                  ณ
			//ณInclusใo do campo com o nome     ณ
			//ณdo usuแrio que cadastrou a tabelaณ
			//ณde rateio.                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ZB7->ZB7_USRNAM	:= M->ZB7_USRNAM  
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVG - 2011.06.09                        ณ
			//ณGrava็ใo da data de inclusใo da tabela.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nOpcX	== 3
				ZB7->ZB7_DTDIGI	:= dDataBase
			Endif			
			ZB7->ZB7_USRFNA	:= M->ZB7_USRFNA//VG - 2011.03.22
			
			MsUnlock()			
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGravar os itens da getDados somente se eles forem informados.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !Empty(Alltrim(oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
				oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
				oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]))

				For nLoop	:= 1 to Len(oGetZB8:aCols)
				
					If oGetZB8:aCols[nLoop,Len(oGetZB8:aHeader)+1]
						Loop
					Endif

					dbSelectArea("ZB8")
					RecLock("ZB8",.T.)
					ZB8->ZB8_FILIAL 	:= 	xFilial("ZB8")				
					ZB8->ZB8_CODRAT		:= 	M->ZB7_CODRAT
//					ZB8->ZB8_ANOMES		:=	M->ZB7_ANOMES
					ZB8->ZB8_ANOMES		:=	U_RZB7AnoMes(M->ZB7_MESANO)
					ZB8->ZB8_REVISA		:=	M->ZB7_REVISA
					ZB8->ZB8_SEQUEN    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_SEQUEN")]
					ZB8->ZB8_PERCEN    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
					ZB8->ZB8_CCDBTO    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]				
					ZB8->ZB8_ITDBTO    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]
					ZB8->ZB8_CLVLDB    	:=	oGetZB8:aCols[nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]
					MsUnlock()										
			
				Next nLoop
			Endif
		
			If nOpcX==3
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVG - 2011.01.06                          ณ
				//ณEm caso de inclusใo, insere uma permissใoณ
				//ณde manuten็ใo na tabela de rateio para o ณ
				//ณusuแrio que a cadastrou.                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
				dbSelectArea("ZB6")
				RecLock(Alias(),.T.)
				
				ZB6->ZB6_FILIAL	:= xFilial("ZB6")
				ZB6->ZB6_CODRAT	:= M->ZB7_CODRAT
				ZB6->ZB6_USUARI	:= __cUserId
				
				ZB6->(MsUnlock())				

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVG - 2011.01.14                   ณ
				//ณInsere uma permissใo de utiliza็ใoณ
				//ณda tabela para o usuแrio que a    ณ
				//ณcadastrou                         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				dbSelectArea("ZBA")
				RecLock(Alias(),.T.)
				
				ZBA->ZBA_FILIAL	:= xFilial("ZBA")
				ZBA->ZBA_CODRAT	:= M->ZB7_CODRAT
				ZBA->ZBA_DESCRI	:= M->ZB7_DESCRI
				ZBA->ZBA_USUARI	:= __cUserId
				
				ZBA->(MsUnlock())
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVG - 2011.01.10                           ณ
				//ณEm caso de inclusใo, verifica se ja existeณ
				//ณo codigo incluido na tabela ZB9, se nใo   ณ
				//ณinclui o codigo novo.   			         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
				dbSelectArea("ZB9")
				DbSetOrder(1)
				If !DbSeek(xFilial("ZB9")+M->ZB7_CODRAT)
					RecLock("ZB9",.T.)
					
					ZB9->ZB9_FILIAL	:= xFilial("ZB9")
					ZB9->ZB9_CODRAT	:= M->ZB7_CODRAT
					ZB9->ZB9_DESCRI	:= M->ZB7_DESCRI
					
					ZB9->(MsUnlock())
				Endif					
				
			Endif
		
		Endif		

	End Transaction     
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.03.25            ณ
	//ณAtualiza o filtro do browseณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
	EditFiltro()

EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ ZB8LinOk   ณAutorณVinํcius Greg๓rio      ณ Data ณ04/01/2011ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Valida os dados de Agente de Vendas da linha digitada      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ ZZZTudOk                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ EXPL1 =	Verdadeiro na validacao                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ CSU                              						  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZB8LinOk()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local x             := 1 
Local lRet			:= .T.
Local aArea         := ZB7->(GetArea())
Local nLinha		:= oGetZB8:nAt
Local nPercentual	:= 0

If oGetZB8:aCols[nLinha,Len(aHeaderZB8)+1]
	Return lRet
EndIf                

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se tem alguma coisa preenchida junto com o percentualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]==0 .or. ;
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")])) .or.;			
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")])) .or.;
	Empty(Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])) .and. nOpc <> 5

	Aviso("Aviso","Os seguintes campos sใo obrigat๓rios: "+RetTitle("ZB8_PERCEN")+", "+;
		RetTitle("ZB8_CCDBTO")+", "+;
		RetTitle("ZB8_ITDBTO")+" e "+;
		RetTitle("ZB8_CLVLDB")+". Por favor, verifique o preenchimento. ",{"OK"},,"Aten็ใo",,"BMPPERG")	
	lRet	:= .F.
	Return lRet

Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se existe percentual com valor menor que zero - Tatiana A. Barbosa - OS 2256-11 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]<0

	Aviso("Aviso","O percentual do rateio nใo pode ser menor que zero. Por favor, verifique o preenchimento. ",{"OK"},,"Aten็ใo",,"BMPPERG")	
	lRet	:= .F.
	Return lRet

Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se a combina็ใo estแ d๚plicadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
For x := 1 To Len(oGetZB8:aCols)

	If !oGetZB8:aCols[x][Len(oGetZB8:aHeader)+1]
		nPercentual	+= oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	Endif
	
	If x != nLinha                                       

		If oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
			oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
			oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")];
			 == ;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
			oGetZB8:aCols[x,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")] .and.;
			!oGetZB8:aCols[nLinha,Len(oGetZB8:aHeader)+1] .and.;
			!oGetZB8:aCols[x,Len(oGetZB8:aHeader)+1]			
			
			Aviso("Aviso","A combina็ใo "+;
				"C. de Custo: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")])+","+c_BR+;
				"Un. Neg๓cio: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")])+" e "+;
				"Opera็ใo: "+Alltrim(oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])+c_BR+;
				"estแ duplicado na lista.",;
				{"OK"},,"Aten็ใo",,"BMPPERG")
	
			lRet := .F.						
			Return lRet
		
		Endif                                                                   
	Endif
	
Next x

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificar se o valor do percentual estแ acima de 100%.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*If nPercentual > 100 
	Aviso("Aviso","A somat๓ria do percentual ้ igual a "+Alltrim(STR(nPercentual))+"%. O somat๓ria dos valores deverแ totalizar 100%.",{"OK"},,"Aten็ใo",,"BMPPERG")
	lRet	:= .F.
	Return lRet	     	
EndIf*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida็ใo do cliente para a combina็ใo das entidades contแbeisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !U_VldCTBg( oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")], oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")], oGetZB8:aCols[nLinha,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")], Nil )
	lRet	:= .F.
	Return lRet	     	
EndIf
	
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ ZB8TudOk   ณAutorณVinํcius Greg๓rio      ณ Data ณ12/07/2010ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Valida os dados de Agente de Vendas da linha digitada      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ ZB8TudOk                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ EXPL1 =	Verdadeiro na validacao                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ CSU														  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZB8TudOk()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea			:= GetArea()
Local aAreaZB7		:= ZB7->( GetArea())
Local lReturn		:= .T.
Local nLoop			:= 0
Local nOri			:= 0
Local nPercTot		:= 0

If nOpc == 5 .or. nOpc==2
	Return(lReturn)
Endif	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.02.21 - Valida a combina็ใo  ณ
//ณde Centro de Custo Transit๓rio, Unidadeณ
//ณde Neg๓cio Transit๓ria Opera็ใo Transi-ณ
//ณt๓ria.                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !U_VldCTBg( M->ZB7_ITTRAN, M->ZB7_CCTRAN, M->ZB7_CLTRAN, Nil )           
//	VG - 2011.02.21 - Ignorar essa mensagem pois a fun็ใo do cliente jแ exibe um aviso de inconsist๊ncia.
//	Aviso("Aviso","A combina็ใo de Centro de Custo Transit๓rio, Unidade de Neg๓cio Transit๓ria e Opera็ใo Transit๓ria nใo ้ vแlida."+;
//	"Por favor, utilize outra combina็ใo.",{"OK"},,"Aten็ใo",,"BMPPERG")
	lReturn	:= .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se existem registros duplicadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lReturn 
	
//	If ZB7->(DbSeek(xFilial("ZB7")+M->(ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA))) .and. nOpc==3
	If ZB7->(DbSeek(xFilial("ZB7")+M->ZB7_CODRAT+U_RZB7AnoMes(M->ZB7_MESANO)+M->ZB7_REVISA)) .and. nOpc==3
		Aviso("Aviso","Jแ existe um cadastro com o Codigo: "+Alltrim(ZB7_CODRAT)+" -Ano/Mes: "+Alltrim(ZB7_ANOMES)+" e Revisใo: "+ALLTRIM(ZB7_REVISA)+;
		". Por favor, utilize outro.",{"OK"},,"Aten็ใo",,"BMPPERG")
		lReturn := .F.		
    Endif      
    
Endif 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ้ a inclusใo da tabela de rateio. Se for, ณ
//ณpermite que o usuแrio cadastre apenas o cabe็alho     ณ
//ณda tabela ou a tabela inteira.                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lReturn
	If nOpc==3 .and. (Empty(Alltrim(oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]+;
		oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]+;
		oGetZB8:aCols[1,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")])))

		Aviso("Aviso","A tabela de rateios serแ criada sem a defini็ใo de seus itens. Ela s๓ poderแ ser "+c_BR+;
				"utilizada para contabiliza็ใo depois que as regras de rateio forem definidas.",{"OK"},,"Aten็ใo",,"BMPPERG")	
		
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Valida cada linha ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nLoop := 1 to Len(oGetZB8:aCols)
			nOri 			:= oGetZB8:nAt
			oGetZB8:nAt 	:= nLoop
			lReturn			:= U_ZB8LinOk()
			If !lReturn
				Exit
			Endif
		Next nLoop

		For nLoop := 1 to Len(oGetZB8:aCols)		
			If !oGetZB8:aCols[nLoop][Len(oGetZB8:aHeader)+1]//VG - 2011.03.18 - Corre็ใo somat๓ria da porcentagem ignorando as linhas deletadas.
				nPercTot		+= oGetZB8:aCols[nLoop][BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
			Endif
		Next nLoop
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se a somat๓ria dos percentuais dos itensณ
		//ณ้ igual a 100%                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nPercTot <> 100
			Aviso("Aviso","A somat๓ria dos percentuais nos itens ้ diferente de 100%. Por favor, verifique os valores novamente. Somat๓ria Atual: "+Alltrim(STR(nPercTot)),;
				{"OK"},,"Aten็ใo",,"NOCHECKED")	
			lReturn := .F.
		Endif
		
	Endif
Endif

RestArea(aAreaZB7)
RestArea(aArea)
Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ MontaAcols ณAutorณVinํcius Greg๓rio      ณ Data ณ22/12/2010ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Preenche o aCols a partir dos arquivos utilizados nas      ณฑฑ
ฑฑณ          ณ amarracoes do cliente                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ EXPA1 = aHeader 										      ณฑฑ
ฑฑณ			 ณ EXPC2 = Alias a ser pesquisado						      ณฑฑ
ฑฑณ			 ณ EXPN3 = Ordem da chave de pesquisa 						  ณฑฑ
ฑฑณ			 ณ EXPC4 = Alias do cabe็alho    							  ณฑฑ
ฑฑณ			 ณ EXPC5 = Chave para a pesquisa							  ณฑฑ
ฑฑณ			 ณ EXPC6 = Condicao para a busca							  ณฑฑ
ฑฑณ			 ณ EXPA7 = Array de retorno     							  ณฑฑ
ฑฑณ			 ณ EXPN8 = numero com a opcao do cadastro					  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ EXPA1 =	Copia do aCols									  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaAcols(aHeader,cAliasCol,nOrder,cAliasCab,cChave,cCondicao,aColsRet,nOpcX)
Local nX
Local nDec     := 0
Local nUsado   := Len(aHeader)
Local aArea    := ZB7->( GetArea())

Default aColsRet := {} //Define o tipo da variavel, caso o valor seja nulo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe nใo for inclusใo, carrega o aCols com as informa็๕es do banco.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcX <> 3

	dbSelectArea(cAliasCol)
	dbSetorder(nOrder)
	MsSeek(xFilial(cAliasCol)+cChave)
	
	While !Eof() .And. xFilial(cAliasCol)==&(cAliasCol+"_FILIAL") .And. &(cCondicao)==cChave
  
	    Aadd(aColsRet,Array(nUsado+1))
	    
	    For nX := 1 to Len(aHeader) 
	
			If aHeader[nX,10] <> "V"
		        aColsRet[Len(aColsRet),nX] := &(FieldName(FieldPos(cAliasCol+SubStr(AllTrim(aHeader[nX,2]),4))))    
			Else   
				If Empty(aHeader[nX,18]) //Nao possui IniBrowse
					aColsRet[Len(aColsRet),nX] := CriaVar(AllTrim(aHeader[nX,2]),.T.)
				Else
					aColsRet[Len(aColsRet),nX] := &(aHeader[nX,18])
				Endif
		   EndIf 
			    
	    Next nX
		    
		aColsRet[Len(aColsRet),nUsado+1] := .F.    
		
		(cAliasCol)->(dbSkip())                                               
				
	EndDo          
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o aCols Vazio, caso nao haja dados para edicao          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aColsRet)==0
	Aadd(aColsRet,Array(nUsado+1))
	Aeval(aHeader,{|x,y|aColsRet[Len(aColsRet),y]:=If(AllTrim(aHeader[y,2])=="ZB8_SEQUEN","01",CriaVar(AllTrim(aHeader[y,2])))})
	
	aColsRet[Len(aColsRet),nUsado+1] := .F.    
EndIf

RestArea(aArea)
Return(aColsRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                            Oficina1                                                   บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณMenuDef ณDefini็ใo das rotinas para o programa                            บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบProjeto/PL  ณ Defini็ใo de op็๕es para o cadastro de regras de rateio.                 บฑฑ
ฑฑฬออออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSolicitante ณ99.99.99ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAutor       ณ22.12.10ณVinํcius Greg๓rio                                                บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณNil                                                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MenuDef()
     
Private aRotina   := {	{ "Pesquisar"		,"PesqBrw"   			 	 	,  	0, 1},;
			            { "Visualizar"		,"U_RCTB99A('ZB7',Recno(),2)"	,	0, 2},;
		            	{ "Incluir"			,"U_RCTB99A('ZB7',Recno(),3)"	,	0, 3},;
						{ "Alterar"			,"U_RCTB99A('ZB7',Recno(),4)"	,	0, 4},;
						{ "Excluir"			,"U_RCTB99A('ZB7',Recno(),5)"	,	0, 5},;
						{ "Copiar"			,"U_RCTB99C"				 	,	0, 2},;
						{ "Cp. Mult."		,"U_RCTBAA2"				 	,	0, 2},;
						{ "Hab.Revis."		,"U_RCTB99R"					, 	0, 2},;
						{ "Legenda"			,"U_RCTB99L"					, 	0, 2}}
						
Return(aRotina)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณBuscaHeaderณ Autor ณJaime Wikanski        ณ Data ณ            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณPesquisa a posicao do campo no aheader                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function BuscaHeader(aArrayHeader,cCampo)

Return(AScan(aArrayHeader,{|aDados| AllTrim(Upper(aDados[2])) == Alltrim(Upper(cCampo))}))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99VA  บAutor  ณVinํcius Greg๓rio   บ Data ณ  23/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o ano e m๊s informados.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99VA(cAnoRef)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local lRetorno	:= .T.
Local cAno		:= ""
Local cMes		:= ""

If Len(Alltrim(cAnoRef)) <> 6
//	Aviso("Aviso","A data de refer๊ncia deve ser completamente preenchida (Ex.: 2010/12)",{"OK"},,"Aten็ใo",,"BMPPERG")		
	Aviso("Aviso","A data de refer๊ncia deve ser completamente preenchida (Ex.: 12/2010)",{"OK"},,"Aten็ใo",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica o  anoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cAno	:= Substr(cAnoRef,1,4)
cAno	:= Substr(cAnoRef,3,4)

If Empty(cAno)
	Aviso("Aviso","O ano deve ser informado.",{"OK"},,"Aten็ใo",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica os mesesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         
//cMes	:= Substr(cAnoRef,5,2)
cMes	:= Substr(cAnoRef,1,2)

If Empty(cAno)
	Aviso("Aviso","O m๊s deve ser informado.",{"OK"},,"Aten็ใo",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
ElseIf Val(cMes) < 0 .or. Val(cMes) > 12
	Aviso("Aviso","M๊s informado invแlido.",{"OK"},,"Aten็ใo",,"BMPPERG")		
	lRetorno	:= .F.
	Return lRetorno
Endif

RestArea(aArea)
Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99C   บAutor  ณVinํcius Greg๓rio   บ Data ณ  28/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para a c๓pia de um rateio                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99C()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aRet 		:= {}
Local aPar 		:= {}
Local cCpyZB7	:= GetNextAlias()  
Local cCpyZB8	:= GetNextAlias()  
Local cCodRat	:= ""
Local cAnoMes	:= ""
Local cRevisa	:= ""
Local cStatus	:= ""

//aAdd(aPar,{1,"Qual o novo perํodo"	,Space(06),"@R 9999/99","","","",0,.F.}) 	// Tipo caractere
aAdd(aPar,{1,"Qual o novo perํodo"	,Space(06),"@R 99/9999","","","",0,.F.}) 	// Tipo caractere

// ParamBox(aParamBox, cTitulo			, aRet	  ,bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)
If !ParamBox(aPar,"Parametros do processamento",@aRet, ,, , , , ,"RCTB99C",.F., .F.)
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o M๊s/Ano informadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !U_RCTB99VA(aRet[1])
	Return
Endif
	    
cCodRat := ZB7_CODRAT
cAnoMes	:= ZB7_ANOMES
cRevisa := ZB7_REVISA
cStatus := ZB7_ATIVO 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se a data eh diferente do cadastro que esta sendo copiadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ZB7->(DbSeek(xFilial("ZB7")+ZB7_CODRAT+U_RZB7AnoMes(aRet[1])+ZB7_REVISA+"A"))	
//	Aviso("Aten็ใo","A data "+substr(aRet[1],1,4)+"/"+substr(aRet[1],5,2)+" nใo pode ser a mesma da linha copiada, escolha outra por favor.",{"OK"},,"Aten็ใo",,"BMPPERG")
	Aviso("Aten็ใo","A data "+substr(aRet[1],1,2)+"/"+substr(aRet[1],3,4)+" nใo pode ser a mesma da linha copiada, escolha outra por favor.",{"OK"},,"Aten็ใo",,"BMPPERG")
	Return
Endif

	BeginSql Alias cCpyZB7
		Select * from %table:ZB7% ZB7
		WHERE ZB7.ZB7_FILIAL = %xFilial:ZB7% 
		AND ZB7.ZB7_CODRAT = %exp:cCodRat% 		
		AND ZB7.ZB7_ANOMES = %exp:cAnoMes% 		
		AND ZB7.ZB7_REVISA = %exp:cRevisa% 
		AND ZB7.ZB7_ATIVO = %exp:cStatus% 
		AND ZB7.%notDel%	
	EndSQL         
  
	(cCpyZB7)->(DbGoTop())	
	
	ZB7->(RecLock("ZB7",.T.))
		
		ZB7->ZB7_FILIAL 	:= xFilial("ZB7")
		ZB7->ZB7_CODRAT 	:= (cCpyZB7)->ZB7_CODRAT
		ZB7->ZB7_DESCRI 	:= (cCpyZB7)->ZB7_DESCRI
//		ZB7->ZB7_ANOMES 	:= aRet[1]
		ZB7->ZB7_ANOMES 	:= U_RZB7AnoMes(aRet[1])
		ZB7->ZB7_REVISA 	:= (cCpyZB7)->ZB7_REVISA
		ZB7->ZB7_ATIVO  	:= "A"
		ZB7->ZB7_CCTRAN  	:= (cCpyZB7)->ZB7_CCTRAN
		ZB7->ZB7_ITTRAN  	:= (cCpyZB7)->ZB7_ITTRAN
		ZB7->ZB7_CLTRAN  	:= (cCpyZB7)->ZB7_CLTRAN
		ZB7->ZB7_PROCES  	:= 'N'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVG - 2011.03.11                           ณ
		//ณColoca o nome do usuแrio que estแ copiandoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ZB7->ZB7_USRNAM  	:= UsrRetName(__cUserId)
		ZB7->ZB7_USRNAM  	:= UsrFullName(__cUserId)//VG - 2011.03.22
	
	ZB7->(MsUnlock())    
	
	BeginSql Alias cCpyZB8
		Select * from %table:ZB8% ZB8
		WHERE ZB8.ZB8_FILIAL = %xFilial:ZB8% 
		AND ZB8.ZB8_CODRAT = %exp:cCodRat% 		
		AND ZB8.ZB8_ANOMES = %exp:cAnoMes% 		
		AND ZB8.ZB8_REVISA = %exp:cRevisa% 
		AND ZB8.%notDel%	
	EndSQL            	
	
	(cCpyZB8)->(DbGoTop())	
	
	While !(cCpyZB8)->(Eof())    
		ZB8->(RecLock("ZB8",.T.))	     
	    
	    	ZB8->ZB8_FILIAL := xFilial("ZB8")
	    	ZB8->ZB8_CODRAT := (cCpyZB8)->ZB8_CODRAT
//	    	ZB8->ZB8_ANOMES := aRet[1]
	    	ZB8->ZB8_ANOMES := U_RZB7AnoMes(aRet[1])
	    	ZB8->ZB8_REVISA := (cCpyZB8)->ZB8_REVISA
	    	ZB8->ZB8_SEQUEN := (cCpyZB8)->ZB8_SEQUEN
	    	ZB8->ZB8_CDEBIT := (cCpyZB8)->ZB8_CDEBIT
	    	ZB8->ZB8_PERCEN := (cCpyZB8)->ZB8_PERCEN
	    	ZB8->ZB8_CCDBTO := (cCpyZB8)->ZB8_CCDBTO
	    	ZB8->ZB8_ITDBTO := (cCpyZB8)->ZB8_ITDBTO
	    	ZB8->ZB8_CLVLDB	:= (cCpyZB8)->ZB8_CLVLDB
		
		ZB8->(MsUnlock())
		(cCpyZB8)->(DbSkip())
	EndDo            

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.03.25      ณ
	//ณReinicializa o filtroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	EditFiltro()
	

Aviso("Aten็ใo","Tabela de Rateios copiada com sucesso!",{"OK"},,"Aten็ใo",,"BMPPERG")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99I   บAutor  ณRafael Gama		 บ Data ณ  05/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao dos itens do excel para o aCols                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB99I()

Local aImport	:= {}
Local nI		:= 0
Local nJ		:= 0
Local nK		:= 0

aImport := U_RCTBMA0() 

If Empty(aImport)
	Return
Endif

If Empty(oGetZB8:aCols[1][3])
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณse o acosl estiver vazio, importa do jeito que esta na planilhaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oGetZB8:aCols := {}	
   	For nI := 1 to Len(aImport)
   		Aadd(oGetZB8:aCols,Array(Len(aHeaderZB8)+1))
		For nK := 1 To Len(aHeaderZB8)
			oGetZB8:aCols[nI][nK]	:= CriaVar(aHeaderZB8[nK,2],.F.)
		Next nK
   	
		For nJ := 1 to Len(oGetZB8:aCols[nI])                  			
	    	oGetZB8:aCols[nI][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
		Next nJ
	Next nI	
Else  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณse o acosl estiver preenchido, importa seguindo a sequencida do acolsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nI := 1 to Len(aImport)	
		Aadd(oGetZB8:aCols,Array(Len(aHeaderZB8)+1))
		For nK := 1 To Len(aHeaderZB8)
			oGetZB8:aCols[Len(oGetZB8:aCols)][nK]	:= CriaVar(aHeaderZB8[nK,2],.F.)
		Next nK
	
		For nJ := 1 to Len(oGetZB8:aCols[nI]) 
			If nJ == 1
				oGetZB8:aCols[Len(oGetZB8:aCols)][nJ] := SOMA1(oGetZB8:aCols[Len(oGetZB8:aCols)-1][nJ])
			Else
		   		oGetZB8:aCols[Len(oGetZB8:aCols)][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])
		   	Endif	
	    Next nJ
	Next nI	
Endif         

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB99E  บAutor  ณRafael Gama		 บ Data ณ  03/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exportacao dos itens da modelo 3 para excel                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB99E()

Local aItensEx 	:= {} 
Local nI		:= 0
Local nJ		:= 0

aItensEx := aClone(oGetZB8:aCols)
  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz a varredura do acols para adicionar o espa็o em branco(CHR(160)) nos campos  ณ
//ณ que sao caracteres para o excel reconhecer como caractere						ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*If !Empty(oGetZB8:aCols)
	For nI := 1 to Len(oGetZB8:aCols)		
		For nJ := 1 to Len(oGetZB8:aCols[nI])
	    	If Valtype(oGetZB8:aCols[nI][nJ]) == "C"
	        	aItensEx[nI][nJ] := CHR(160)+Alltrim(oGetZB8:aCols[nI][nJ])
			Endif	
	    Next
	Next
Endif*/


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||GeraExcel({{"GETDADOS","CONTAS DE RATEIO",oGetZB8:aHeader,aItensEx}})})

Return      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ GeraExcelณ Autor ณ  Rafael Gama          ณ Data ณ 04/01/2011 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณFuncao que exporta os valores da tela para o Microsoft Excel  ณฑฑ
ฑฑณ          ณno formato .CSV                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParโmetrosณ Array contendo os objetos a serem exportados                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nil                                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ CSU			                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraExcel(aExport)

Local aArea		:= GetArea()
Local cDirDocs	:= MsDocPath() 
Local cPath		:= AllTrim(GetTempPath())
Local aCampos	:= {}
Local ny		:= 0
Local nX        := 0
Local nz		:= 0
Local cBuffer   := ""
Local oExcelApp := Nil
Local nHandle   := 0
Local cArquivo  := SuperGetMV("MV_XNOMPLN",,"tabela_de_rateio")
Local _cArquivo	:= ""
Local aHeader	:= {}
Local aCols		:= {}
Local cAuxTxt
Local aParamBox	:= {}
Local aRet		:= {}
Local lArqLocal := ExistBlock("DIRDOCLOC") 
Local cType			:=	"Arquivos XLS|*.XLS|Todos os Arquivos|*.*"

aTamSX3 := TAMSX3("ZB8_SEQUEN")
Aadd(aCampos, { "SEQUENC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_PERCEN")
Aadd(aCampos, { "PERCENT"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_CCDBTO")
Aadd(aCampos, { "CCUSTO"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_ITDBTO")
Aadd(aCampos, { "UNNEGOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB8_CLVLDB")
Aadd(aCampos, { "OPERACA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TMPTRB",.f.)
DbSelectArea("TMPTRB")                                           

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"SEQUENC","Sequencia"})

For nA := 1 to Len(aInd)
	IndRegua("TMPTRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando อndice Temporแrio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

For nLoop := 1 to Len(aExport[1,4])
	RecLock("TMPTRB",.T.)
	TMPTRB->SEQUENC	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_SEQUEN")]
	TMPTRB->PERCENT	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	TMPTRB->CCUSTO	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CCDBTO")]
	TMPTRB->UNNEGOC	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_ITDBTO")]
	TMPTRB->OPERACA	:= aExport[1,4,nLoop,BuscaHeader(oGetZB8:aHeader,"ZB8_CLVLDB")]
	MsUnlock()
Next nLoop
                                  
//_cArquivo := __RELDIR+cArquivo+".xls"//VG - 2011.02.28 - na homologa็ใo o __RELDIR ้ no C:\ do usuแrio!!!
_cArquivo := cDirDocs+ "\" +cArquivo+".xls"

Copy to &_cArquivo
dbCloseArea("TMPTRB")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega o Excel com o Arquivo Criado              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If lArqLocal
//	cArquivo := cPath + "\" + cArquivo
//Else
//	cArquivo := cDirDocs + "\" + cArquivo
//Endif

//cPath  := AllTrim(GetTempPath())
CpyS2T( _cArquivo , cPath, .T. )
If ! ApOleClient( 'MsExcel' )
	MsgStop( "MsExcel nao instalado" )
	Return
EndIf
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".xls" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerifDel  บAutor  ณV. Greg๓rio         บ Data ณ  06/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se nใo existe nenhum registro de SEV que utiliza  บฑฑ
ฑฑบ          ณ esse c๓digo de rateio.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerifDel(cCodRat)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lRetorno	:= .T.     
Local cQry		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry	:= "SELECT count(*) CONTADOR FROM "+RetSQLName("SEV")+" "+c_BR
cQry	+= "WHERE EV_FILIAL = '"+xFilial("SEV")+"' "+c_BR
cQry	+= "AND EV_XCODRAT = '"+cCodRat+"' "+c_BR
cQry	+= "AND D_E_L_E_T_ <> '*' "+c_BR

If Select("TMPDEL") > 0
	DbSelectArea("TMPDEL")
	DbCloseArea()
Endif
MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TMPDEL", .F., .T.)}, "Verificando se nใo foi utilizado anteriormente...")

If TMPDEL->CONTADOR > 0
	lRetorno	:= .F.
Endif

Return lRetorno 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBMA2  บAutor  ณRafael Gama         บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se a descricao do registro da ZB7 esta igual a    บฑฑ
ฑฑบ          ณ outra descricao com o mesmo c๓digo de rateio.		      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBMA2()

Local lRet 		:= .T.  
Local cAliasZB7	:= GetNextAlias()

     
	If Select(cAliasZB7) > 0
		DbSelectArea(cAliasZB7)
		DbCloseArea()
	Endif  

	BeginSql Alias cAliasZB7 
	
		Select Distinct ZB7_CODRAT, ZB7_DESCRI from %table:ZB7% (NOLOCK)
		Where ZB7_FILIAL = %xFilial:ZB7% AND ZB7_CODRAT = %exp:M->ZB7_CODRAT% AND %notDel%	
		
	EndSQL
    
    If !(cAliasZB7)->(Eof())
		If ALLTRIM(M->ZB7_DESCRI) <> ALLTRIM((cAliasZB7)->ZB7_DESCRI)
			Aviso("Aviso","A descri็ใo nใo pode ser diferente do Rateio "+ALLTRIM(M->ZB7_CODRAT)+".!",{"OK"},,"Aten็ใo",,"BMPPERG")
		    lRet := .F.
		Endif
	Endif				    
	
	DbSelectArea(cAliasZB7)
	DbCloseArea()

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBMA3  บAutor  ณRafael Gama         บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o codigo a cadastrar eh permito para o usuario บฑฑ
ฑฑบ          ณ que esta logado.										      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBMA3()

Local lRet 			:= .T.  
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

If cUserfull <> __cUserID
	ZB6->(Dbsetorder(1))
	If ZB6->(DbSeek(xFilial("ZB6")+M->ZB7_CODRAT))
		If !ZB6->(DbSeek(xFilial("ZB6")+M->ZB7_CODRAT+__cUserID,))
			Aviso("Aviso","C๓digo utilizado anteriormente e o usuแro nใo tem permissใo para inclusใo do codigo "+ALLTRIM(M->ZB7_CODRAT)+".",{"OK"},,"Aten็ใo",,"BMPPERG")
			lRet := .F.  
		Endif
	Endif
Endif

Return(lRet)                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRZB7AnoMesบAutor  ณVinํcius Greg๓rio   บ Data ณ  17/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inverter o ano e m๊s para gravar na base de dados.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RZB7ANOMES(cMesAno)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local cRetorno	:= ""

cRetorno	:= Substr(cMesAno,3,4)+Substr(cMesAno,1,2)

RestArea(aArea)
Return cRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99L   บAutor  ณVinํcius Greg๓rio   บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe a legenda do browse                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99L()                
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aLegenda := {}
               
aAdd(aLegenda, {"BR_VERDE"  	,"Tabela pendente de atualiza็ใo"}) 	
aAdd(aLegenda, {"BR_VERMELHO"	,"Tabela processada"})
aAdd(aLegenda, {"BR_AZUL"		,"Tabela atualizada"})  
aAdd(aLegenda, {"BR_AMARELO"	,"Tabela componente"})//VG - 2011.06.09

BrwLegenda("Tabelas de Rateio","Legenda" ,aLegenda) //"Legenda"        
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB99Y  บAutor  ณVinํcius Greg๓rio   บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para valida็ใo de legenda                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99Y()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local lRetorno	:= .F.

dbSelectArea("ZB8")
dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
If dbSeek(ZB7->ZB7_FILIAL+ZB7->ZB7_CODRAT+ZB7->ZB7_ANOMES+ZB7->ZB7_REVISA,.F.)
	lRetorno	:= .T.
Endif          

dbSelectArea("ZB7")

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB99Z  บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcular a somat๓ria dos percentuais                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB99Z()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local nLoop		:= 0 
Local nPercTot	:= 0

For nLoop := 1 to Len(oGetZB8:aCols)		
	If !oGetZB8:aCols[nLoop][Len(oGetZB8:aHeader)+1]//VG - 2011.03.18 - Corre็ใo somat๓ria da porcentagem ignorando as linhas deletadas.
		nPercTot		+= oGetZB8:aCols[nLoop][BuscaHeader(oGetZB8:aHeader,"ZB8_PERCEN")]
	Endif
Next nLoop

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.22        ณ
//ณAtualiza as informa็๕esณ
//ณde totaliza็ใo.        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotPerc	:=	nPercTot 
nRestPerc	:= 100-nPercTot
If oGetValTot <> Nil .and. oGetValRest <> Nil
	oGetValTot:Refresh()                     
	oGetValRest:Refresh()
Endif

Return                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB99K  บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para deletar todos os itens.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB99K()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                       
Local nLoop	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMarcar todos os registros da GetDados como deletadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop := 1 to Len(oGetZB8:aCols)
	oGetZB8:aCols[nLoop][Len(aHeaderZB8)+1]	:= .T.
Next nLoop

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTB99R   บAutor  ณVinํcius Greg๓rio   บ Data ณ  18/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para habilitar novas revis๕es                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB99R()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local cUserAdm	:= ALLTRIM(SuperGetMV("MV_XRATBLQ",,""))//usuแrio com prermissใo para desbloquear revis๕es

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o usuแrio tem permissใo para habilitar revis๕esณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If __cUserId <> cUserAdm
	Aviso("Aviso","Usuแrio sem permiss๕es para essa opera็ใo.",{"OK"},,"Aten็ใo",,"BMPPERG")			
	Return .F.	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ้ uma revisใo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ZB7->ZB7_REVISA == "000"
	Aviso("Aviso","O registro selecionado nใo ้ uma revisใo de tabela de rateio.",{"OK"},,"Aten็ใo",,"BMPPERG")			
	Return .F.	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se estแ inativa  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ZB7->ZB7_ATIVO <> 'I'
	Aviso("Aviso","A revisใo jแ estแ ativa.",{"OK"},,"Aten็ใo",,"BMPPERG")			
	Return .F.	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtiva a revisใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("ZB7")
RecLock("ZB7",.F.)
	ZB7->ZB7_ATIVO := 'A'
MsUnlock()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPergunta se o usuแrio deseja estornar ณ
//ณtodas as contabiliza็๕es de rateio jแ ณ
//ณprocessadas para aquela tabela.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Aviso("Estorno","Deseja estornar todos os documentos de entradas com rateio jแ processado para essa tabela no perํodo?",;
	{"Sim","Nใo"},,"Aten็ใo",,"BMPPERG")==1
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEstorna todas notas contabilizadas para aquela tabela de rateio no perํodo.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProcEst()	
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออหออออออออออออออออออออออออออออออออออออออหออออออหอออออออออออออปฑฑ
ฑฑบPrograma  ณProcEst   บAutor  บVinํcius Greg๓rio                     บ Data บ  07/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออสออออออออออออออออออออออออออออออออออออออสออออออสอออออออออออออนฑฑ
ฑฑบDescri…o ณ Processa o estorno das notas rateadas para a tabela de rateio na vig๊ncia.   บฑฑ
ฑฑบ          ณ                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCSU        		                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                    
Static Function ProcEst()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nTotRegs		:= 0
Local cQry			:= ""
Local nX			:= 0
Local nCountReg		:= 1

Local cDataDe 	:=	"01/"+Substr(ZB7->ZB7_ANOMES,5,2)+"/"+Substr(ZB7->ZB7_ANOMES,1,4)
Local cDataAte	:= 	LastDay(CTOD("01/"+Substr(ZB7->ZB7_ANOMES,5,2)+"/"+Substr(ZB7->ZB7_ANOMES,1,4)))
Local cRatDe	:= 	ZB7->ZB7_CODRAT
Local cBranco	:= ""

Local aIndisp	:= {}

Local cUltRev	:= ""
Local cAnoMes	:= ""       

Local nA 			:= 0
Local aCampos 		:= {}
Local aDescCpo		:= {}
Local aTamSX3		:= {}
Local cArq 			:= ""
Private aInd  		:= {}
Private Qry 		:= GetNextAlias()
                         
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os campos do arquivo temporario para markbrowse ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Aadd(aCampos, { "TMP_OK"    	,"C",02,0 })                        

aTamSX3 := TAMSX3("F1_FILIAL")
Aadd(aCampos, { "TMP_FILIAL"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DOC")
Aadd(aCampos, { "TMP_DOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_SERIE")
Aadd(aCampos, { "TMP_SERIE"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_FORNECE")
Aadd(aCampos, { "TMP_FORNEC"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_LOJA")
Aadd(aCampos, { "TMP_LOJA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("A2_NREDUZ")
Aadd(aCampos, { "TMP_NREDUZ"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB7_CODRAT")
Aadd(aCampos, { "TMP_CODRAT"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ZB7_DESCRI")
Aadd(aCampos, { "TMP_DESCRI"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DUPL")
Aadd(aCampos, { "TMP_DUPL"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_EMISSAO ")
Aadd(aCampos, { "TMP_EMISSA "	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_CODIGO")
Aadd(aCampos, { "TMP_NATURE"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_DESCRIC")
Aadd(aCampos, { "TMP_NATDES"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

Aadd(aCampos, { "TMP_MARCA"    	,"C",01,0 })//VG - campo que irแ permitir marcar ou nใo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta array com a descricao dos campos a serem exibidos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCpos := { {"TMP_OK"		,,""},; //"OK" 
	  	   {"TMP_FILIAL"	,,"Filial"},; //"Filial"	 
	  	   {"TMP_DOC"		,,"Documento"},; //"Documento"	 
	  	   {"TMP_SERIE"		,,"Serie"},; //"Serie"
   		   {"TMP_DUPL"		,,"Duplicata"},; //"Duplicata"
   	  	   {"TMP_FORNEC"	,,"Fornecedor"},; //"Forneceodr"
		   {"TMP_LOJA"		,,"Loja"},; //"Loja"
   		   {"TMP_NREDUZ"	,,"Nome"},; //"Nome"
   		   {"TMP_NATURE"	,,"Cod Natureza"},; //"Cod Natureza"
   		   {"TMP_NATDES"	,,"Nome Natureza"},; //"Descricao Natureza"
   		   {"TMP_CODRAT"	,,"Cod. Rateio"},; //"Nome"
   		   {"TMP_DESCRI"	,,"Descr. Rateio"},; //"Nome"
   		   {"TMP_EMISSA"	,,"Emissao"} }  //"Nome" 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo temporario								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TRB",.f.)
DbSelectArea("TRB")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA","Filial+Doc+Serie+Fornece+Loja"})

For nA := 1 to Len(aInd)
	IndRegua("TRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando อndice Temporแrio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta a variavel utilizada para marcacao           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cMarca := GetMark(,"TRB","TMP_OK")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para pegar os Documentos de Entradaณ
//ณque ainda nใo foram processados.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//VG - 2011.03.03 - Removi a filial da query na SF1 a pedido da usuแria Mirian. As tabelas SEV e SED sใo compartilhadas.
//Isso pode atrapalhar consideravelmente a performance dessa consulta na tabela SF1!!!
BeginSql alias Qry

	SELECT F1_FILIAL, F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DUPL,F1_EMISSAO, EV_XCODRAT ZB7_CODRAT, ED_CODIGO, ED_DESCRIC 
	FROM %table:SF1% SF1(NOLOCK),%table:SEV% SEV(NOLOCK), %table:SED% SED(NOLOCK)
	WHERE F1_XPRORAT = '1'
		AND F1_EMISSAO BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
		AND F1_DTLANC <> '        '
		AND SF1.%notDel%             
    	AND EV_FILIAL = %xfilial:SEV%
	    AND EV_NUM = F1_DOC 
    	AND EV_PREFIXO = F1_PREFIXO      
    	AND EV_CLIFOR = F1_FORNECE
    	AND EV_LOJA = F1_LOJA
    	AND EV_XCODRAT = %Exp:cRatDe%
	    AND SEV.%notDel%   
       	AND ED_FILIAL = %xfilial:SED%
	    AND ED_CODIGO = EV_NATUREZ
   	    AND SED.%notDel%   
	    		
EndSql                              

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a quantidade de registros a processar			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
(Qry)->( DbEval( {|| nTotRegs++},,{ || !Eof()} ))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta o arquivo de trabalho                			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea(Qry)
DbGoTop()
ProcRegua(nTotRegs)
While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua de processanto            			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncProc("Processando registro "+Alltrim(Str(nCountReg))+" de "+Alltrim(Str(nTotRegs))+".")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava os registros na tabela temporaria      			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("TRB")
	DbSetOrder(1)
	RecLock("TRB",.T.)
	
	TRB->TMP_FILIAL	:= (QRY)->F1_FILIAL
	TRB->TMP_OK		:= cMarca//Space(02)
	TRB->TMP_DOC	:= (QRY)->F1_DOC
	TRB->TMP_SERIE	:= (QRY)->F1_SERIE
	TRB->TMP_FORNEC	:= (QRY)->F1_FORNECE
	TRB->TMP_LOJA 	:= (QRY)->F1_LOJA
	TRB->TMP_NREDUZ	:= Posicione("SA2",1,xFilial("SA2")+(QRY)->F1_FORNECE+(QRY)->F1_LOJA,"A2_NREDUZ")
	TRB->TMP_CODRAT	:= (QRY)->ZB7_CODRAT
	TRB->TMP_DESCRI	:= Posicione("ZB7",1,xFilial("ZB7")+(QRY)->ZB7_CODRAT,"ZB7_DESCRI")
	TRB->TMP_DUPL	:= (QRY)->F1_DUPL
	TRB->TMP_EMISSA	:= Stod((QRY)->F1_EMISSAO)
	TRB->TMP_NATURE	:= (QRY)->ED_CODIGO
	TRB->TMP_NATDES	:= (QRY)->ED_DESCRIC
	TRB->TMP_MARCA	:= Space(01)
    
	MsUnlock()
	
	nCountReg++
	
	DbSelectArea(QRY)
	DbSkip()
	
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a area do arquivo de execucao da query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select(QRY) > 0
	DbSelectArea(QRY)
	DbCloseArea()
Endif        

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBuscar os lan็amentos contแbeis relativos เ nota.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbSetOrder(1)//TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA
dbGoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa o estorno dos rateios.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
U_CTBMA4PR(.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApaga a tabela temporแria. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	FErase(cArq+GetDbExtension())
	For nA := 1 to Len(aInd)
		FErase(aInd[nA,1]+OrdBagExt())
	Next nA
Endif

Return(Nil)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditFiltroบAutor  ณVinํcius Greg๓rio   บ Data ณ  25/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EditFiltro()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cAliaZB7		:= GetNextAlias() 
Local cUsrLog		:= __cUserID 
Local cCodRat		:= ""
Local cCodIN		:= "" 
Local cUserfull		:= ALLTRIM(SuperGetMV("MV_XUSRRAT",,""))

If !lDefTop

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEncerra o filtro anterior.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	EndFilBrw(cAlias,aIndexZB7)
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRemonta o filtroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(cUsrLog$Alltrim(cUserfull))

		BeginSql Alias cAliaZB7 
			Select ZB6_CODRAT from %table:ZB6% ZB6 (NOLOCK), %table:ZB7% ZB7 (NOLOCK)
			WHERE ZB6_FILIAL = %xFilial:ZB6% AND ZB6_USUARI = %exp:cUsrLog% AND ZB6.%NotDel%
			AND ZB6_CODRAT = ZB7_CODRAT AND ZB6_CODRAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
			AND ZB7_ANOMES BETWEEN %exp:cAnoMesD% AND %exp:cAnoMesA% AND ZB7.%NotDel%
		EndSQL	
	    
		(cAliaZB7)->(DbGoTop())
	
		While !(cAliaZB7)->(EOF())
    		cCodRat += ALLTRIM((cAliaZB7)->ZB6_CODRAT)
			(cAliaZB7)->(DbSkip())
			If !(cAliaZB7)->(EOF())         
				cCodRat += ";"
			Endif	
		EndDo       
		
		(cAliaZB7)->(dbCloseArea())
	
		cCodIN := FormatIn(ALLTRIM(cCodRat), ";")	
	
//		cFilterZB7	:= "ZB7_CODRAT $ "+cCodIN
		cFilterZB7	:= "ZB7_CODRAT $'"+STRTRAN(STRTRAN(STRTRAN(cCodIN,")",""),"(",""),"'","")+"'"
		
		If Len(cFilterZB7) > 2000
			Aviso("Aviso","O filtro gerado ้ muito abrangente e os resultados nใo podem ser exibidos. Por favor, revise os parโmetros de exibi็ใo.",{"OK"},,"Aten็ใo",,"BMPPERG")								
			Return .F.
		Endif
		
		DbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)

	ElseIf (cUsrLog $Alltrim(cUserfull))
		cFilterZB7	:= "ZB7_CODRAT <> ' '" 
		Eval(bFiltraBrw)
		DbSelectArea(cAlias)
		dbSetOrder(1) 
	
	Endif
   
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CriaSx1  ณ Verifica e cria um novo grupo de perguntas com base nos      บฑฑ
ฑฑบ             ณ          ณ parโmetros fornecidos                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 23.05.05 ณ Modelagem de Dados                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 28.04.04 ณ TI0607 - Almir Bandina                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = array com o conte๚do do grupo de perguntas (SX1)                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99/99/99 - Consultor - Descricao da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)
Return(Nil)