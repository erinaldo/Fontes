#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"       

#DEFINE c_BR Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBAA2   บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ C๓pia m๚ltipla de tabelas de rateio para uma ๚nica tabela  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBAA2()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea	:= GetArea()

Private aItens		:= {}

Private oOk	    	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oNo	    	:= LoadBitmap( GetResources(), "BR_VERMELHO")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGarantir que a tabela destino esteja sem os itens preenchidosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If U_RCTB99Y()
	Aviso("Aviso","A tabela de destino jแ tem itens preenchidos. Por favor, utilize uma tabela com o cadastro do cabe็alho somente.",{"OK"},,"Aten็ใo",,"NOCHECKED")			
	Return .F.
Endif         

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama a rotina que monta a tela de marca็ใo dos valores.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MontaTela()

RestArea(aArea)
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTela บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela para sele็ใo das tabelas de rateio que serใo  บฑฑ
ฑฑบ          ณ importadas para a tabela principal                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaTela()                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//Local bOk      		:= {|| If( Obrigatorio( oEncMain:aGets, oEncMain:aTela) .And. U_ZB8TudOk(), ( nOpcA := 1, oDlgMain:End() ), nOpcA := 0 ) }
Local bOk      		:= {|| IF(TudoOK(),(nOpca:=1,oDlgMain:End()),nOpcA:=0) }
Local bCancel  		:= {|| nOpcA := 0, oDlgMain:End() }
Local aAlias		:= {}

Private aHeader 	:= {}
Private aCols	 	:= {}
Private oDlgMain
Private oEncMain
Private oFolder
Private oGetD	
Private aCampos		:= {}
Private aVisual		:= {}
Private aGets		:= {}
Private aTela		:= {}
Private bCampo		:= { |nCPO| Field( nCPO ) }                             
Private aBotao		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแveis de posi็ใo de campos no aHeaderณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nPMark		:= 0
Private nPCodRat	:= 0
Private nPDescri	:= 0
Private nPAnoMes	:= 0
Private nPRevisa	:= 0
Private nPAtivo		:= 0
Private nPCCTran	:= 0
Private nPItTran	:= 0
Private nPClTran	:= 0
Private nPProces	:= 0
Private nPPercent	:= 0
Private nPNomUser	:= 0
Private nPCompon	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAdicionar a funcionalidade de importa็ใo no aBotaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//AADD(aBotao, {"DBG06" 		, { || RCTB99I()}, "Importar cadastro", "Importar" }) 
//AADD(aBotao, {"PMSEXCEL" 	, { || RCTB99E()}, "Exportar cadastro", "Exportar" })
                                             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontar os campos da ZB7 para a MsMGetณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
aAdd( aCampos, "ZB7_ANOMES" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO"  )
aAdd( aCampos, "ZB7_CCTRAN" )
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
//aAdd( aCampos, "ZB7_COMPON" )
aAdd( aCampos, "NOUSER" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine a area dos objetos                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
AAdd( aObjects,{100,060, .t., .f. })
AAdd( aObjects,{100,100, .t., .t. })

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

RegToMemory("ZB7",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCorrigir a visualiza็ใo do m๊s/ano no formato desejadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
M->ZB7_MESANO	:= Substr(M->ZB7_ANOMES,5,2)+Substr(M->ZB7_ANOMES,1,4) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.11                     ณ
//ณAlterar o nome do usuแrio baseado noณ
//ณusuแrio que estแ copiando a tabela. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
M->ZB7_USRNAM	:= UsrRetName(__cUserId)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader 																ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
aHeader := {}

Aadd(aHeader,{"OK",;
			"COR",;
			"@BMP",;
			1,;
            0,;
            .T.,;
            "",;
            "",;
            "",;
            "R",;
            "",;
            "",;
            .F.,;
            "V",;
          	"",;
           	"",;
           	"",;
           	""})      
           	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณColuna com o percentualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
SX3->( dbSetOrder(2) )//CAMPO
SX3->( dbSeek("ZB8_PERCEN") )
Aadd(aHeader,{	AllTrim(X3Titulo()),;
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

dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
SX3->( dbSeek("ZB7") )
While SX3->( !Eof()) .And. SX3->X3_ARQUIVO $ "ZB7" 
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .and.;                          
		( !Alltrim(SX3->X3_CAMPO) $ "ZB7_FILIAL")
		Aadd(aHeader,{	AllTrim(X3Titulo()),;
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGuardar posi็๕es da GetDadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nPMark		:= aScan( aHeader, { |x| AllTrim(x[2]) == "COR" 		})
nPCodRat	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CODRAT"	})
nPDescri	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_DESCRI"	})
nPAnoMes	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ANOMES"	})
nPRevisa	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_REVISA"	})
nPAtivo		:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ATIVO"	})
nPCCTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CCTRAN"	})
nPItTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_ITTRAN"	})
nPClTran	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_CLTRAN"	})
nPProces	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_PROCES"	})
nPPercent	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB8_PERCEN"	})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.03.11                                       ณ
//ณNome do usuแrio que cadastrou as tabelas selecionadas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nPNomUser	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_USRNAM"	})
nPCompon	:= aScan( aHeader, { |x| AllTrim(x[2]) == "ZB7_COMPON"	})

aCols := MontaAcols()
                             
/*aAdd( aCampos, "ZB7_CODRAT" )
aAdd( aCampos, "ZB7_DESCRI" )
aAdd( aCampos, "ZB7_ANOMES" )
aAdd( aCampos, "ZB7_REVISA" )
aAdd( aCampos, "ZB7_ATIVO"  )
aAdd( aCampos, "ZB7_CCTRAN" )
aAdd( aCampos, "ZB7_ITTRAN" )
aAdd( aCampos, "ZB7_CLTRAN" )
aAdd( aCampos, "ZB7_PROCES" )*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria a tela de digitacao do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlgMain := MSDIALOG():New(aSize[7],00,aSize[6],aSize[5],cCadastro,,,,,,,,/*oMainWnd*/,.T.)

oEncMain := MSMGet():New("ZB7", ZB7->(RecNo()),2,,,,aCampos,{15,5,97,620},aCampos,1,,,,oDlgMain,,,,,,.T.,,,)
                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MsNewGetDados															    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                          
oGetD := MsNewGetDados():New(100,5,280,620,0,,"TudOk()",,,,9999,,,,oDlgMain,aHeader,@aCols)
oGetD:oBrowse:blDblClick	:= {||GetPercentual()}

ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,bOk,bCancel,,aBotao)

If nOpcA == 1

	CalcPercent()
	Grava()
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ MontaAcols ณAutorณVinํcius Greg๓rio      ณ Data ณ22/12/2010ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Preenche o aCols a partir dos arquivos utilizados nas      ณฑฑ
ฑฑณ          ณ amarracoes do cliente                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ EXPA1 =	Copia do aCols									  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaAcols()
Local aRetorno	:= {}
Local nUsado   	:= Len(aHeader)
Local aArea    	:= ZB7->(GetArea())
Local nRecno	:= ZB7->(RecNo())
Local nLoop		:= 0
Local dtBase	:= dDataBase
Local dtBase2	:= dDataBase
DtBase:=MonthSub(dtbase,11)
DtBase:=AnoMes(dtbase)  
dtBase2:=AnoMes(dtbase2)  
dbSelectArea("ZB7")
dbSetOrder(1)
dbGoTop()                   
Do While !EOF()
	IF ZB7->ZB7_ANOMES>=DtBase .AND. ZB7->ZB7_ANOMES<=DtBase2
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe tiver itens preenchidos, permite a c๓piaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  		If U_RCTB99Y()                                                    
			aAdd(aRetorno,Array(nUsado+1))    
		
			For nLoop := 1 to Len(aHeader)            
				If Alltrim(aHeader[nLoop][2])=="COR"  
					aRetorno[Len(aRetorno)][nLoop]		:= oNo
				ElseIf Alltrim(aHeader[nLoop][2])=="ZB8_PERCEN"
					aRetorno[Len(aRetorno)][nLoop]		:= 0
				Else
					aRetorno[Len(aRetorno)][nLoop]		:= ZB7->&(Alltrim(aHeader[nLoop][2]))
				Endif
			Next nLoop		                             		
	
			aRetorno[Len(aRetorno)][nUsado+1]	:= .F.

		Endif	
		dbSelectArea("ZB7")
		dbSkip()
	ELSE
		dbSkip()
	endif
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVolta para a posi็ใo inicial na tabelaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ZB7->(dbGoTo(nRecNo))

RestArea(aArea)
Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoOK    บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TudoOK()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lRetorno	:= .T.
Local nLoop		:= 0
Local nSoma		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a soma ้ igual a 100%ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aEval(oGetD:aCols,{|aItem| nSoma += aItem[nPPercent]})
If nSoma <> 100
	Aviso("Aviso",;
		"A soma do rateio ้ diferente de 100%. Por favor, verifique novamente os percentuais das tabelas de rateio selecionadas.",;
		{"OK"},,;
		"Aten็ใo",,;
		"NOCHECKED")				
	lRetorno	:= .F.
Endif

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPercentualบAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para pegar o percentual relativo aos itens da tabela   บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPercentual()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oDlg, oGroup, oBtnOK, oBtnCn, oGetPerc
Local oSayPerc
Local nGetPerc		:= If(oGetD:aCols[oGetD:nAt][nPPercent]==0,CriaVar("ZB8_PERCEN",.F.),oGetD:aCols[oGetD:nAt][nPPercent])  
Local cTitDialog	:= "Porcentagem para a tabela"
Local cTitGroup		:= ""    
Local nOpcA			:= 0   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDialog principal. Na ativa็ใo ela ้ centralizada.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM 0,0 TO 100,250 PIXEL TITLE cTitDialog

oGroup:= TGroup():New(05,05,(oDlg:nClientHeight/3)-10,(oDlg:nClientWidth/2)-5,cTitGroup,oDlg,,,.T.)

oSayPerc	:= tSay():New(10,10,{||'Porcentagem:'},oDlg,,,,,,.T.,CLR_BLUE,CLR_WHITE,33,20)  
oGetPerc	:= TGet():New(10,52,{|u| if(PCount()>0,nGetPerc:=u,nGetPerc)}, oDlg,30,10,PesqPict("ZB8","ZB8_PERCEN"),{||nGetPerc >= 0 .and. nGetPerc <= 100},,,,,,.T.,,,,,,,,,,'nGetPerc')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBotใo para o controle de fechamento da janelaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oBtnOK:=tButton():New((oDlg:nClientHeight/3.2),10,"OK",oDlg,{||nOpcA:=1,oDlg:End()},40,10,,,,.T.)
oBtnCN:=tButton():New((oDlg:nClientHeight/3.2),(oDlg:nClientWidth/3.2),"Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)

ACTIVATE MSDIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa a inclusใo do apontamento de produ็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcA==1
	If nGetPerc == 0
		oGetD:aCols[oGetD:nAt][nPPercent]  	:= nGetPerc
		oGetD:aCols[oGetD:nAt][nPMark]		:= oNo
	Else
		oGetD:aCols[oGetD:nAt][nPPercent]  	:= nGetPerc
		oGetD:aCols[oGetD:nAt][nPMark]		:= oOk
	Endif
	oGetD:Refresh()
Endif             

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcPercent บAutor  ณVinํcius Greg๓rio   บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por recalcular os percentuais dos itens   บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcPercent()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea    	:= ZB7->(GetArea())
Local nRecno	:= ZB7->(RecNo())
Local aCampos	:= {"ZB8_SEQUEN","ZB8_PERCEN","ZB8_CCDBTO","ZB8_ITDBTO","ZB8_CLVLDB"}
Local aTrab		:= {}
Local nLoop		:= 0
Local nLoop2	:= 0
Local nSequen	:= 0

aItens	:= {}

For nLoop:=1 to Len(oGetD:aCols)

	If oGetD:aCols[nLoop][nPMark]==oOk

		dbSelectArea("ZB8")
		dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
		If dbSeek(xFilial("ZB8")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa],.F.)
			Do While !EOF() .and. ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA)==xFilial("ZB8")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa]
				aAdd(aItens,Array(Len(aCampos)))
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAlimenta o array e recalcula o percentualณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				For nLoop2 := 1 to Len(aCampos)
					If aCampos[nLoop2]=="ZB8_SEQUEN"
					    aItens[Len(aItens)][nLoop2]	:= STRZERO(nSequen+1,TAMSX3("ZB8_SEQUEN")[1])
				    	nSequen++
					ElseIf aCampos[nLoop2]=="ZB8_PERCEN"
						//Recalculo de percentual
						aItens[Len(aItens)][nLoop2]	:= (oGetD:aCols[nLoop][nPPercent]*ZB8->ZB8_PERCEN)/100				
					Else 
						aItens[Len(aItens)][nLoop2]	:= ZB8->&(aCampos[nLoop2])
					Endif							
				Next nLoop2
			
				ZB8->(dbSkip())
			EndDo
		Endif
		
	Endif
	
Next nLoop	

ZB7->(dbGoTo(nRecNo))
RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณV. Greg๓rio         บ Data ณ  03/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a grava็ใo dos itens para a tabela de rateio       บฑฑ
ฑฑบ          ณ destino                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nLoop		:= 0       
Local nLoop2	:= 0
Local aCampos	:= {"ZB8_SEQUEN","ZB8_PERCEN","ZB8_CCDBTO","ZB8_ITDBTO","ZB8_CLVLDB"}

For nLoop:=1 to Len(aItens)

	dbSelectArea("ZB8")
	RecLock("ZB8",.T.)
    ZB8->ZB8_FILIAL	:= xFilial("ZB8")
    ZB8->ZB8_CODRAT	:= M->ZB7_CODRAT
    ZB8->ZB8_ANOMES	:= M->ZB7_ANOMES
    ZB8->ZB8_REVISA	:= M->ZB7_REVISA
    For nLoop2	:= 1 to Len(aItens[nLoop])
    	ZB8->&(aCampos[nLoop2])	:= aItens[nLoop][nLoop2]
	Next nLoop2
	MsUnlock()        
	
Next nLoop

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.06.09              ณ
//ณGrava o flag ZB7_COMPON em   ณ
//ณtodas as tabelas que fizeram ณ
//ณparte da tabela principal.   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop	:= 1 to Len(oGetD:aCols)
	If oGetD:aCols[nLoop][nPMark]==oOk
		dbSelectArea("ZB7")
		dbSetOrder(1)//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA+ZB7_ATIVO		
		If dbSeek(xFilial("ZB7")+oGetD:aCols[nLoop][nPCodRat]+oGetD:aCols[nLoop][nPAnoMes]+oGetD:aCols[nLoop][nPRevisa]+oGetD:aCols[nLoop][nPAtivo],.F.)
			Reclock("ZB7",.F.)
			ZB7->ZB7_COMPON	:= '1'
			MsUnlock()
		Endif
	Endif
Next nLoop

Return .T.