#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN021
Aglutinação dos Títulos que serão renegociados
@return		Nenhum
@author		Nivia Ferreira
@since		20/02/2017
@version	12
@Alter - Wesley Alves - Alteração para colocar no titulo aglutinado as informações de Centro de custo e Caracteristica;
/*/
//-------------------------------------------------------------------

User Function ASTIN021()   //F0102001()

	Local oDlg 		:= Nil
	Local cPref		:= Space( TamSX3("E1_PREFIXO")[1] )
	Local cTipo 	:= Space( TamSX3("E1_TIPO")[1] )
	Local cNrf  	:= Space( TamSX3("E1_NUM")[1] )
	Local cNatur	:= Space( TamSX3("E1_NATUREZ")[1] )
	Local cCli  	:= Space( TamSX3("E1_CLIENTE")[1] )
	Local cLoja 	:= Space( TamSX3("E1_LOJA")[1] )
	Local cContra	:= Space( TamSX3("E1_XCONTRA")[1] )

	Local cEmisd	:= ctod("  /  /  ")
	Local cEmisa	:= ctod("  /  /  ")
	Local dVenci	:= ctod("  /  /  ")
	Local dData		:= ctod("  /  /  ")
	Local lRet		:= .F.
	Local cTela	    := SuperGetMv("FS_FILTRO",.F.,"")
	Local cFiltel 	:= Separa(cTela,'|',.F.)

	Local aCoors	:= FWGetDialogSize( oMainWnd )
	Local bOk     	:= {|| If(FSValida(cTipo, cNatur, cCli, cLoja, dVenci ), (lRet := .T.,oDlg:End()),)}
	Local bCancel 	:= {||oDlg:End()}

	Private aRotina	:= {}

	IF	Len(cFiltel) > 0
		cLoja 	:= PadR(cFiltel[1], TamSX3("E1_LOJA")[1] )
		cTipo   := PadR(cFiltel[2], TamSX3("E1_TIPO")[1] )
		cNatur  := PadR(cFiltel[3], TamSX3("E1_NATUREZ")[1])
	EndIf

	cName 		:= 'Verdana'
	nWidth 		:=  1
	nHeight 	:= -13
	lBold 		:= .F.
	lUnderline 	:= .F.
	lItalic 	:= .F.
	oTFont 		:= TFont():New(cName,nWidth,nHeight,,lBold,,,,,lUnderline,lItalic)

	Define MsDialog oDlg Title 'Faturas a Receber' From 22,9 TO 300,540 Pixel

	oSay1	:= TSay():New(040,010,{||'Prefixo'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oPref	:= TGet():New(037,060,{|u| if( PCount() > 0, cPref := u, cPref ) } ,oDlg,20,12,X3Picture('E1_PREFIXO'),,,,,,,.T.,,,,,,,,,,,,,,)

	oSay2	:= TSay():New(040,140,{||'Tipo'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oTipo	:= TGet():New(037,190,{|u| if( PCount() > 0, cTipo := u, cTipo ) } ,oDlg,30,12,X3Picture('E1_TIPO'),{|| FSValTipo( cTipo )},,,,,,.T.,,,,,,,,,'05','cTipo',,,,)

	oSay3	:= TSay():New(060,010,{||'Nr. Fatura'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oNrf	:= TGet():New(057,060,{|u| if( PCount() > 0, cNrf:= u, cNrf ) } ,oDlg,50,12,X3Picture('E1_NUM'),,,,,,,.T.,,,,,,,,,,,,,,)

	oSay4	:= TSay():New(060,140,{||'Natureza'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oNatur	:= TGet():New(057,190,{|u| if( PCount() > 0, cNatur:= u, cNatur ) } ,oDlg,50,12,X3Picture('E1_NATUREZ'),{|| FinVldNat( .F., cNATUR, 1 )},,,,,,.T.,,,,,,,,,'SED','cNatur',,,,)

	oSay5	:= TSay():New(080,010,{||'Emissão De'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oEmisd	:= TGet():New(077,060,{|u| if( PCount() > 0, cEmisd := u, cEmisd ) } ,oDlg,50,12,X3Picture('E1_EMISSAO'),,,,,,,.T.,,,,,,,,,,,,,,)

	oSay6	:= TSay():New(080,140,{||'Emissão Ate'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oEmisa	:= TGet():New(077,190,{|u| if( PCount() > 0, cEmisa := u, cEmisa ) } ,oDlg,50,12, X3Picture('E1_EMISSAO'),,,,,,,.T.,,,,,,,,,,,,,,)

	oSay7	:= TSay():New(100,010,{||'Cliente'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,050,20)
	oCli	:= TGet():New(097,060,{|u| if( PCount() > 0, cCli := u, cCli ) } ,oDlg,50,12,X3Picture('E1_CLIENTE'),{||existcpo("SA1",cCli,,,,.F.)},,,,,,.T.,,,,,,,,,'SA1','cCli',,,,)

	oSay8	:= TSay():New(100,140,{||'Loja'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,070,20)
	oLoja	:= TGet():New(097,190,{|u| if( PCount() > 0, cLoja := u, cLoja ) } ,oDlg,20,12, X3Picture("E1_LOJA"),{||existcpo("SA1",cCli+cLOJA,,,,.F.)},,,,,,.T.,,,,,,,,,,,,,,)

	oSay9	:= TSay():New(120,010,{||'Dt Vencimento'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,070,20)
	oVenci	:= TGet():New(117,060,{|u| if( PCount() > 0, dVenci := u, dVenci ) } ,oDlg,50,12,X3Picture('E1_VENCTO'),,,,,,,.T.,,,,,,,,,,,,,,)

	oSay10	:= TSay():New(120,140,{||'Contrato'},oDlg,,oTFont,,,,.T.,CLR_RED,CLR_WHITE,070,20)
	oContr	:= TGet():New(117,190,{|u| if( PCount() > 0, cContra := u, cContra ) } ,oDlg,50,12,,,,,,,,.T.,,,,,,,,,,,,,,)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

	If	lRet
		FSBrowse(cPref, cTipo, cNrf, cNatur, cCli, cLoja, cEmisd, cEmisa, dVenci, cContra)
	EndIf

Return Nil

//-------------------------------------------------------------------
//Filtro e Seleção dos Titulos
//-------------------------------------------------------------------
Static Function FSBrowse(cPref, cTipo, cNrf, cNatur, cCli, cLoja, cEmisd, cEmisa, dVenci, cContra)

	Local cFiltro   	:= ''
	Local aRotina		:= {}
	Local oMark			:= Nil
	Local oDlgMB		:= Nil
	Local aCoors		:= FWGetDialogSize( oMainWnd )
	Local cFiltro1		:= ''
	Local cMarca   		:= ''

	cFiltro1  := " .And. E1_NATUREZ = '"+ cNatur + "'"
	cFiltro1  += " .And. E1_CLIENTE = '"+ cCli + "'"
	cFiltro1  += " .And. E1_LOJA = '"+ cLoja + "'"
	cFiltro1  += " .And. E1_TIPO = '"+ cTipo + "'"
	IF 	!Empty(cContra)
		cFiltro1  += " .And. E1_XCONTRA = '" + cContra + "'"
	EndIf

	cFiltro := " (SE1->E1_ORIGEM == 'FINI055' .And. SE1->E1_SITUACA == '0' .And. Empty(SE1->E1_BAIXA) .And. Empty(SE1->E1_NUMBOR)" +;
	" .And. Empty(SE1->E1_XTITAGL) .And. SE1->E1_XAGLUT <>'1' .And. SE1->E1_XPARCL <> '1' " +;
	cFiltro1 + ")  .Or. " +;
	" ((SE1->E1_ORIGEM ='L' .OR. SE1->E1_ORIGEM='S' .OR. SE1->E1_ORIGEM='T') .Or. SE1->E1_IDLAN > 0) .And. Empty(SE1->E1_NUMBOR) "+;
	" .And. Empty(SE1->E1_BAIXA) .And. ( SE1->E1_TIPO $ MVABATIM .And. SE1->E1_SALDO > 0) "+;
	" .And. Empty(SE1->E1_XTITAGL) .And. SE1->E1_XAGLUT <>'1' .And. SE1->E1_XPARCL <> '1'"

	//  cFiltro := "  Empty(SE1->E1_XTITAGL) .And. SE1->E1_XAGLUT <>'1' .And. SE1->E1_XPARCL <> '1'"+;
	//          	   " .And. Empty(SE1->E1_BAIXA) .And. SE1->E1_SALDO > 0 "

	cFiltro  += cFiltro1

	IF 	!Empty(cPref)
		cFiltro  += " .And. E1_PREFIXO = '"+ cPref + "'"
	EndIf
	IF 	!Empty(cNrf)
		cFiltro  += " .And. E1_NUM = '"+ cNrf + "'"
	EndIf
	IF 	!Empty(cEmisd)
		cFiltro  += " .And. E1_EMISSAO >= '"+ DToS( cEmisd ) + "'"
	EndIf
	IF 	!Empty(cEmisa)
		cFiltro  += " .And. E1_EMISSAO <= '"+ DToS( cEmisd ) + "'"
	EndIf

	dbSelectArea("SE1")
	dbSetOrder(1)
	SET FILTER TO & cFiltro
	While !SE1->(Eof())

		IF	!Empty(SE1->E1_XOK)
			RecLock("SE1",.F.)
			SE1->E1_XOK	= ''
			SE1->(MsUnlock())
		EndIf

		SE1->(dbSkip())
	EndDo

	Define MsDialog oDlgMB Title 'Renegociação' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oMark := FWMarkBrowse():New()
	oMark:SetAlias('SE1')
    
	cMarca  := oMark:Mark()

	oMark:SetFieldMark( "E1_XOK" )
	oMark:SetMark(cMarca, 'SE1', 'E1_XOK')
	oMark:SetAllMark( { || oMark:AllMark() } )

	oMark:SetOwner(oDlgMB)
	oMark:SetDescription('Cliente: ' + cCli+'-'+cloja +'  '+ POSICIONE('SA1', 1, xFilial('SA1') + cCli+cLoja, 'A1_NOME'))
	oMark:SetFilterDefault( cFiltro )
	oMark:AddButton( "Gravar", { || lRET:=u_FSGRAVA(oMark, dVenci),Iif(lRET,oDlgMB:End(),) },,,, .F., 3 )

	oMark:DisableSeek(.F.)
	oMark:SetMenuDef('')
	oMark:DisableDetails()
	oMark:SetFixedBrowse(.F.)
	oMark:SetUseFilter( .F. )
	oMark:DisableReport()
	oMark:SetWalkThru(.T.)
	oMark:Activate()

	oDlgMB:Activate()

Return()

//-------------------------------------------------------------------
//Valida se o Tipo Existe
//-------------------------------------------------------------------
Static Function FSValTipo(cTipo)
	Local lRet	:= .T.

	dbSelectArea("SX5")
	If 	!dbSeek(xFilial("SX5")+"05"+cTipo)
		MsgAlert("Tipo Inválido.")
		lRet := .F.
	EndIf

Return(lRet)

//-------------------------------------------------------------------
//Valida campos
//-------------------------------------------------------------------
Static Function FSValida(cTipo, cNatur, cCli, cLoja, dVenci )
	Local lRet	:= .T.

	If	Empty(cTipo)
		MsgAlert("Tipo deve ser informado.")
		lRet := .F.
	EndIf

	IF	lRet
		If	Empty(cNatur)
			MsgAlert("Natureza deve ser informada.")
			lRet := .F.
		EndIf
	EndIf

	IF	lRet
		If	Empty(cCli)
			MsgAlert("Cliente deve ser informado.")
			lRet := .F.
		EndIf
	EndIf

	IF	lRet
		If	Empty(cLoja)
			MsgAlert("Loja deve ser informada.")
			lRet := .F.
		EndIf
	EndIf

	IF	lRet
		If	Empty(dVenci)
			MsgAlert("Data de Vencimento deve ser informada.")
			lRet := .F.
		Else
			If	dVenci < Ddatabase
				MsgAlert("Data de Vencimento invalida.")
				lRet := .F.
			EndIf
		EndIf
	EndIf

Return(lRet)

//-------------------------------------------------------------------
//Atualiza o valor dos titulos de origem
//-------------------------------------------------------------------
User Function FSGRAVA(oMark, dVenci)
	Local lRet		:= .T.
	Local aArea    	:= GetArea()
	Local cMarca   	:= oMark:Mark()
	Local aSE1	   	:= {}
	Local nValor	:= 0
	Local cContRM   := ''

	SE1->( dbGoTop() )
	While !SE1->( EOF() )
		If 	oMark:IsMark(cMarca)

			IF	!Empty(SE1->E1_XCONTRA )
				IF	Empty(cContRM)
					cContRM:=SE1->E1_XCONTRA
				EndIf
				IF	cContRM <> 	SE1->E1_XCONTRA
					MsgAlert("Titulos selecionados com contrato diferente.")
					lRet := .F.
					Return(lRet)
				Else
					lRET := .T.
				EndIf
			EndIf

			//Integracao RM
			dData 	  := ddatabase
			ddatabase := dVenci

			If !u_ASTIN011()  //F0101001() 
				lRet := .F.
			EndIf
			ddatabase := dData

			If !lRet
				Exit
			EndIf

			nValor += SE1->E1_VALOR

			//aadd(aSE1,{SE1->E1_PREFIXO,SE1->E1_TIPO,SE1->E1_NUM,SE1->E1_NATUREZ,SE1->E1_CLIENTE,SE1->E1_PARCELA,SE1->E1_LOJA,})	//wap.o
			aadd(aSE1,{SE1->E1_PREFIXO,SE1->E1_TIPO,SE1->E1_NUM,SE1->E1_NATUREZ,SE1->E1_CLIENTE,SE1->E1_PARCELA,SE1->E1_LOJA,0,SE1->E1_CCUSTO, SE1->E1_XCARACT, SE1->E1_XCONTRA, SE1->E1_XEMPRE})	//wap.o

		Endif

		SE1->( dbSkip() )
	End

	IF 	!Empty(aSE1)
		FS040INC(aSE1, dVenci)
	EndIf

	RestArea( aArea )
	oMark:Refresh(.T.)

Return(lRet)

//-------------------------------------------------------------------
//Grava titulo aglutinado e baixa titulo(s) de origem
//-------------------------------------------------------------------
Static Function FS040INC(aSE1, dVenci)

	Local aArray 			:= {}
	Local aBaixa 			:= {}
	Local nX	 			:= 0
	Local nJuros			:= 0
	Local nMulta	    	:= 0
	Local nValor			:= 0
	Local nValorAbatimentos	:= 0
	Local nValorDocumento	:= 0
	Local lGerou			:= .F.
	Local cMotiv    		:= 'Baixa por Renegociação'
	Local cNumTit 			:= ProxTitulo("SE1",aSE1[1,1])
	Local aArea    			:= GetArea()

	Private lMsErroAuto := .F.
    Private lNotIntgr   := .F.
    
	Begin Transaction

		For nX:=1 to Len(aSE1)

			SE1->(DbOrderNickName("RENEGOCIA1"))
			SE1->(DbGoTOP())
			//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_TIPO+E1_NATUREZ+E1_CLIENTE+E1_LOJA

			If 	SE1->(DbSeek(xFilial("SE1")+asE1[NX,1]+aSE1[NX,3]+aSE1[NX,2]+aSE1[NX,4]+aSE1[NX,5]+aSE1[NX,7] ))

				nValorAbatimentos :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				//calculo valor total
				//nValorDocumento := Round((((SE1->E1_SALDO+SE1->E1_ACRESC)-SE1->E1_DECRESC)*100)-(nValorAbatimentos*100),0)/100
				nValorDocumento := Round((((SE1->E1_SALDO+SE1->E1_ACRESC)-SE1->E1_DECRESC)*100)-(nValorAbatimentos*100),2)/100

				IF 	SE1->E1_VENCREA < dVenci
					//lVencido := .T.

					//multa VALOR * 2.00 / 100
					//nMulta := Round ((nValorDocumento * SE1->E1_PORCJUR / 100) , 2)
					nMulta := (nValorDocumento * SE1->E1_PORCJUR / 100)

					//juros VALOR * 0.033 / 100 * DIAS VENCIDO
					//nJuros := Round ((nValorDocumento * (SE1->E1_VALJUR / 100)) * (dVenci - SE1->E1_VENCREA) , 2)
					nJuros := (nValorDocumento * (SE1->E1_VALJUR / 100)) * (dVenci - SE1->E1_VENCREA)

				EndIF

				//atualiza valor total
				aSE1[NX,8] := nValorDocumento + Round (nMulta + nJuros ,2)
				nValor +=     nValorDocumento + Round (nMulta + nJuros ,2)

				//aSE1[NX,8] := nValorDocumento + nMulta + nJuros
				//nValor += nValorDocumento + nMulta + nJuros

				nJuros := 0
				nMulta := 0

			EndIF
		Next

		If 	MsgNoYes("Deseja Realmente gerar o título no valor R$" + Alltrim(TRANSFORM(nValor, '@E 999,999.99')) +" ?","Atenção")

			aArray := { { "E1_PREFIXO"  , aSE1[1,1] 	, NIL },;
			{ "E1_TIPO"     , aSE1[1,2]     , NIL },;
			{ "E1_NATUREZ"  , aSE1[1,4]     , NIL },;
			{ "E1_NUM"      , cNumTit       , NIL },;
			{ "E1_CLIENTE"  , aSE1[1,5]     , NIL },;
			{ "E1_EMISSAO"  , dDataBase		, NIL },;
			{ "E1_VENCTO"   , dVenci 		, NIL },;
			{ "E1_VENCREA"  , dVenci		, NIL },;
			{ "E1_VALOR"    , nValor        , NIL },;
			{ "E1_CCUSTO"   , aSE1[1,9]     , NIL },;         //wap.n
			{ "E1_PARCELA"  , '01'		    , NIL },;
			{ "E1_XAGLUT"   , '1'           , NIL },;
			{ "E1_XCARACT"  , aSE1[1,10]    , NIL },;         //wap.n
			{ "E1_XCONTRA"  , aSE1[1,11]    , NIL },;
			{ "E1_XEMPRE"   , aSE1[1,12]    , NIL },;
			{ "E1_HIST"		,"Titulo Renegociado", Nil}}

			MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao

			If 	lMsErroAuto .Or. SE1->E1_NUM <> cNumTit
				AutoGrLog( "Problema na inclusão do Titulo Renegociado." )
				MostraErro()
				DisarmTransaction()
				Break
			Else
                    
				lNotIntgr := .T.         
				
					DBSelectArea('SA1')

				For nX:=1 to Len(aSE1)

					SE1->(DbOrderNickName("RENEGOCIA1"))
					//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_TIPO+E1_NATUREZ+E1_CLIENTE+E1_LOJA
					If 	SE1->(DbSeek(xFilial("SE1")+aSE1[NX,1]+aSE1[NX,3]+aSE1[NX,2]+aSE1[NX,4]+aSE1[NX,5]+aSE1[NX,7] ))
					
						RegToMemory("SE1")
				
						aBaixa := {}
						
						/*
						Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
						Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM     , nil})
						Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
						Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO    , nil})
						Aadd(aBaixa, {"E1_CLIENTE" , SE1->E1_CLIENTE , nil})
						Aadd(aBaixa, {"E1_LOJA"    , SE1->E1_LOJA    , nil})
						Aadd(aBaixa, {"AUTMOTBX"   , "REN"           , nil})
						Aadd(aBaixa, {"AUTDTBAIXA" , dVenci		     , nil})
						Aadd(aBaixa, {"AUTDTCREDITO",dVenci			 , nil})
						Aadd(aBaixa, {"AUTHIST"    , cMotiv		     , nil})
						Aadd(aBaixa, {"AUTVALREC"  , aSE1[NX,8]      , nil})
						*/
						
						aBaixa := {{"E1_PREFIXO" , SE1->E1_PREFIXO , Nil    },;
						           {"E1_NUM"     , SE1->E1_NUM     , Nil    },;
								   {"E1_PARCELA" , SE1->E1_PARCELA , Nil    },;
						           {"E1_TIPO"    , SE1->E1_TIPO    , nil    },;
						           {"E1_CLIENTE" , SE1->E1_CLIENTE , nil    },;
						           {"E1_LOJA"    , SE1->E1_LOJA    , nil    },;
						           {"AUTMOTBX"   , "REN"           , nil    },;
						           {"AUTBANCO"    ,MV_PAR13        , Nil    },;
	         					   {"AUTAGENCIA"  ,MV_PAR14        , Nil    },;
						   	       {"AUTCONTA"    ,MV_PAR15        , Nil    },;
						           {"AUTDTBAIXA" , dVenci		   , nil    },;
						           {"AUTDTCREDITO",dVenci		   , nil    },;
						           {"AUTHIST"     ,cMotiv		   , nil    },;
						           {"AUTJUROS"    ,0               ,Nil, .T.},;
						           {"AUTVALREC"  , aSE1[NX,8]      , nil    }} 
						           
						If	valType(ALTERA) <> "U"
							ALTERA := .T.
						EndIf

						lMsErroAuto := .F.
						dData 	  	:= ddatabase
						ddatabase 	:= dVenci
						MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) //3 - Baixa de Título
						

						IF 	lMsErroAuto .Or. Empty(SE1->E1_BAIXA)
							ddatabase := dData
							AutoGrLog( "Problema na Baixa por Renegociação." )
							MostraErro()
							DisarmTransaction()
							Break
						Else
							ddatabase := dData
							RecLock("SE1",.F.)
							SE1->E1_XAGLUT  := '1'
							SE1->E1_XTITAGL := cNumTit
							SE1->E1_XOK		:= ''
							SE1->(MsUnlock())
							lGerou			:= .T.
						EndIf
					EndIf
				Next
                
				lNotIntgr := .F.

				MsgAlert("Renegociação incluída com sucesso. Foi gerado o Titulo " + cNumTit +" Valor R$ " + Alltrim(TRANSFORM(nValor, '@E 999,999.99')) +".")
			Endif
		Endif
	End Transaction

	//Geração do Bordero
	IF	lGerou
		FINA060(3)
	EndIf

	RestArea( aArea )
Return()