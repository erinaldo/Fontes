#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CPCOA13   ºAutor  ³TOTVS               º Data ³  22/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta status dos Centros de Custo e verifica Planilha	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CPCOA13
Local nI
Local aArea     := GetArea()
Local aAreaCTT  := CTT->(GetArea())
Local aAreaAK2  := AK2->(GetArea())
Local aButtons  := {}
Local cTitulo	:= "Status dos CCs (Centros de Custos)"
Local aVet		:= {}
Local oDlg      := NIL
Private oLbx    := NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se existe registros na CTT |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len( aVet := _PCO13Atu(.f.,0) ) == 0
	MsgAlert("Não foram encontrados registros no cadastro de Centro Custo (CC)", "ATENCAO!!!")
	Return
Endif

If AK1->AK1_FILIAL <> XFILIAL("AK1")
	MsgStop("Empresa selecionada diferente da filial corrente. Verifique!")
	Return
Endif

SetKey( VK_F5, { || _PCO13Atu(.t.,0) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Tela de Responsaveis CC|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFont   NAME 'Arial' SIZE 6, -13 BOLD
DEFINE FONT oFontF3 NAME 'Arial' SIZE 12, -13 BOLD

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 550,800 PIXEL STYLE DS_MODALFRAME STATUS
oDlg:lMaximized := .F.
oDlg:lEscClose  := .F.

@ 16,02 LISTBOX oLbx VAR cVar FIELDS HEADER ;
"","CC", "Descrição", "Responsável","E-mail", "Telefone" SIZE 322,245 OF oDlg PIXEL //ColSizes 20,15,22,15,30,25,30,25,45,15,30,25,85,30,30,30

oLbx:SetArray( aVet )
oLbx:bLine := {|| {aVet[oLbx:nAt,01],;
aVet[oLbx:nAt,02],;
aVet[oLbx:nAt,03],;
aVet[oLbx:nAt,04],;
aVet[oLbx:nAt,05],;
Transform(aVet[oLbx:nAt,06],"@R (99) 9999-9999")}}

oLbx:Refresh()

oLbx:Align := CONTROL_ALIGN_TOP

@ 252,010 BITMAP oBmp1 RESOURCE "ENABLE" SIZE 7,7 OF oDlg PIXEL ON CLICK _PCO13Atu(.t.,1)
@ 253,020 SAY "Em Aberto " SIZE 40,8 FONT oFont COLOR CLR_HBLUE OF oDlg PIXEL
oBmp1:cToolTip := "Filtrar CC's em aberto"

@ 252,060 BITMAP oBmp2 RESOURCE "DISABLE" SIZE 7,7 OF oDlg PIXEL ON CLICK _PCO13Atu(.t.,2)
@ 253,070 SAY "Finalizada " SIZE 40,8 FONT oFont COLOR CLR_HBLUE OF oDlg PIXEL
oBmp2:cToolTip := "Filtrar CC's em finalizadas"

@ 252,110 BITMAP oBmp3 RESOURCE "BR_CINZA" SIZE 7,7 OF oDlg PIXEL ON CLICK _PCO13Atu(.t.,3)
@ 253,120 SAY "CC sem movimento" SIZE 50,8 FONT oFont COLOR CLR_HBLUE OF oDlg PIXEL
oBmp3:cToolTip := "Filtrar CC's não cadastradas na Planilha"

@ 252,200 SAY "F5 - Remove Filtros" SIZE 100,8 FONT oFontF3 COLOR CLR_HBLUE OF oDlg PIXEL

//ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)
Define SButton From 258, 365 Type 2 Action ( oDlg:End() ) OnStop "Fechar" Enable Of oDlg
Activate MSDialog  oDlg Center


SetKey( VK_F5  , NIL )

RestArea(aAreaCTT)
RestArea(aAreaAK2)
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_PCO13Atu ºAutor  ³TOTVS               º Data ³  03/16/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização da grid                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _PCO13Atu(_lRefresh,_nStatus)
Local oOk       := LoadBitmap( GetResources(), "ENABLE" )
Local oNo       := LoadBitmap( GetResources(), "DISABLE" )
Local oNc       := LoadBitmap( GetResources(), "BR_CINZA" )
Local _aAreaAK2 := AK2->(GetArea())
Local _aAreaCTT := CTT->(GetArea())
Local _aRet     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o Vetor do LISTBOX  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CTT->(dbSetOrder(1))
CTT->(dbSeek(XFilial("CTT")))

While CTT->(!Eof()) .and. CTT->CTT_FILIAL == XFilial("CTT")
	// Filtra somente CC analiticos
	IF CTT->CTT_BLOQ == "2" .and. CTT->CTT_CLASSE == "2" .and. PcoDirCC_User(CTT->CTT_CUSTO,__CUSERID) <> 0
		
		// Tratamento do semaforo
		AK2->(dbSetOrder(8))
		IF !AK2->(dbSeek(XFilial("AK2")+AK1->(AK1_CODIGO+AK1_VERSAO)+CTT->CTT_CUSTO))
			oSt := oNc
		ELSE
			oSt := oNo
			While AK2->(!Eof()) .and. AK2->AK2_FILIAL == XFilial("AK2") .and. AK2->(AK2_ORCAME+AK2_VERSAO+AK2_CC) == AK1->(AK1_CODIGO+AK1_VERSAO)+CTT->CTT_CUSTO
				IF AK2->AK2_XSTS == "0"
					oSt := oOk
				ENDIF
				AK2->(dbSkip())
			Enddo
		ENDIF
		
		// Validação de filtros
		IF (_nStatus == 1 .and. oSt <> oOk) .or. (_nStatus == 2 .and. oSt <> oNo) .or. (_nStatus == 3 .and. oSt <> oNc)
			CTT->(dbSkip())
			Loop
		ENDIF
		
		Aadd(_aRet, {oSt,CTT->(CTT_CUSTO),CTT->(CTT_DESC01),UsrRetName(CTT->(CTT_XUSER)),UsrRetMail(CTT->(CTT_XUSER)),CTT->(CTT_XTEL)})
	ENDIF
	
	CTT->(dbSkip())
Enddo

IF _lRefresh // atualiza grid
	oLbx:SetArray( _aRet )
	oLbx:bLine := {|| {_aRet[oLbx:nAt,01],;
	_aRet[oLbx:nAt,02],;
	_aRet[oLbx:nAt,03],;
	_aRet[oLbx:nAt,04],;
	_aRet[oLbx:nAt,05],;
	Transform(_aRet[oLbx:nAt,06],"@R (99) 9999-9999")}}
	
	oLbx:Refresh() // Refresh de tela
ENDIF

RestArea(_aAreaAK2)
RestArea(_aAreaCTT)
Return(_aRet)
