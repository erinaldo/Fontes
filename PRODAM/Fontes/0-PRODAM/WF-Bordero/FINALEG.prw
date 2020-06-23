#Include 'Protheus.ch'
static lPrime:= .T.
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FINALEG
Ponto de entrada para tratamento das legendas do contas a pagar
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function FINALEG()
Local nRec			:= PARAMIXB[1]
Local cAlias		:= PARAMIXB[2]
Local aLegenda 	:= {}
Local uRetorno 	:= {}
Static lVez

If cAlias == "SE1" 
	aLegenda := { {"BR_VERDE"	, 	"Titulo em aberto" },;	 
					{"BR_AZUL"		, 	"Baixado parcialmente" },;	
					{"BR_VERMELHO", "Titulo Baixado" },;	   
					{"BR_PRETO"	, 	"Titulo em Bordero" },;	   
					{"BR_BRANCO"	, "Adiantamento com saldo" },;	
					{"BR_CINZA"	,	"Titulo baixado parcialmente e em bordero" },;
					{"BR_AMARELO"	, "Titulo Protestado"}} 	
																						
	dbSelectArea("SE1")
	dbSetOrder(1)
	uRetorno := .T.
	If Empty(lVez)   // Via menu, a opcao passada eh 1.
		lVez := .T.
		uRetorno := {}

		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0'													, aLegenda[3][1]				} ) //"Titulo Baixado" 
		Aadd(uRetorno, { '!Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))'			, aLegenda[6][1]				} ) //"Titulo baixado parcialmente e em bordero"
		Aadd(uRetorno, { 'E1_TIPO == "'+MVRECANT+'".and. ROUND(E1_SALDO,2) > 0 .And. !FXAtuTitCo()'	, aLegenda[5][1]				} ) //"Adiantamento com saldo"
		Aadd(uRetorno, { '!Empty(E1_NUMBOR)'														, aLegenda[4][1]				} ) //"Titulo em Bordero"
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2) .And. !FXAtuTitCo()'				, aLegenda[2][1]				} ) //"Baixado parcialmente"
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"'			, aLegenda[Len(aLegenda)][1]	} ) //"Titulo Protestado"
		Aadd(uRetorno, { '.T.'															, aLegenda[1][1] } )			
	Else
		BrwLegenda(cCadastro, "Legenda", aLegenda)
	Endif

ELSEIF cAlias == "SE2" .AND. !ISINCALLSTACK("FINA426")

	aLegenda := { {"BR_AMARELO" , "Aguardando Liberacao" },;
					{"BR_VERDE"   , "Pgto Liberado"        },;
					{"BR_AZUL"    , "Baixado parcialmente" },;
					{"BR_VERMELHO", "Titulo Baixado"       },;
					{"BR_LARANJA"	, "Título em bordero aguardando aprovação"},;
					{"BR_PRETO"	, "Titulo em Bordero liberado"},;
					{"BR_CANCEL"	, "Titulo em Bordero reprovado"},;
					{"BR_CINZA"  	, "Titulo baixado parcialmente e em bordero" },;
					{"BR_BRANCO"  , "Adiantamento com saldo"}}
																						
	dbSelectArea("SE2")
	dbSetOrder(1)
	uRetorno := .T.
	If Empty(lVez)   // Via menu, a opcao passada eh 1.
		lVez := .T.
		uRetorno := {}
		
		Aadd(uRetorno, { ' !( SE2->E2_TIPO $ MVPAGANT ).and. EMPTY(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0', aLegenda[1][1] } )
		Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0', aLegenda[8][1] } )			
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) + ROUND(E2_SDACRES,2)  = 0', aLegenda[4][1] } )
		Aadd(uRetorno, { '!Empty(E2_NUMBOR).AND.E2_XSTSAPV$"0,1"', aLegenda[5][1] } )
		Aadd(uRetorno, { '!Empty(E2_NUMBOR).AND.E2_XSTSAPV$"2,5"', aLegenda[6][1] } )
		Aadd(uRetorno, { '!Empty(E2_NUMBOR).AND.E2_XSTSAPV$"3,6"', aLegenda[7][1] } )
		Aadd(uRetorno, { '!Empty(E2_NUMBOR) .and.(ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2))', aLegenda[8][1] } )
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)', aLegenda[3][1] } )
		Aadd(uRetorno, { '.T.'															, aLegenda[2][1] } )		
	Else
		BrwLegenda(cCadastro, "Legenda", aLegenda)
	Endif
EndIf

Return uRetorno

