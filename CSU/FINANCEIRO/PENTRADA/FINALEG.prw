#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: FINALEG	 	Autor: Tatiana A. Barbosa	Data: 21/03/11	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: 	Customização da Legenda das rotinas do módulo financeiro.  ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU CardSystem S.A								   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                                                	

User Function FINALEG()         

Local nReg     := PARAMIXB[1]
Local cAlias   := PARAMIXB[2]
Local uRetorno := {}
Local aLegenda := {	{"BR_VERDE"    , "Titulo em aberto"       },;	// "Titulo em aberto"
					{"BR_AZUL"     , "Baixado parcialmente"   },;	// "Baixado parcialmente"
					{"BR_VERMELHO" , "Titulo baixado"         },;	// "Titulo Baixado"
					{"BR_PRETO"    , "Titulo em bordero"      },;	// "Titulo em Bordero"
					{"BR_BRANCO"   , "Adiantamento com saldo" } }	// "Adiantamento com saldo"     

If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	If cAlias = "SE1"
		Aadd(aLegenda, {"BR_AMARELO", "Titulo Protestado"}) //"Titulo Protestado"
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0', aLegenda[3][1] } )
		Aadd(uRetorno, { 'E1_TIPO == "'+MVRECANT+'".and. ROUND(E1_SALDO,2) > 0', aLegenda[5][1] } )						
		Aadd(uRetorno, { '!Empty(E1_NUMBOR)', aLegenda[4][1] } )
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2)', aLegenda[2][1] } )						
		Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"', aLegenda[6][1] } )
		Aadd(uRetorno, { '.T.', aLegenda[1][1] } )
	Else
		IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")           
			Aadd(aLegenda, {"BR_AMARELO", "Titulo aguardando liberacao"}) //Titulo aguardando liberacao
			Aadd(uRetorno, { ' EMPTY(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0', aLegenda[6][1] } ) 
		EndIf
//		IF lFaLegPares
//			Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0 .And. (ROUND(E2_SALDO,2) < ROUND(E2_VALOR,2))', aLegenda[6][1] } )										
//		Endif								
        If SM0->M0_CODIGO == '05'
        	Aadd(aLegenda, {"BR_LARANJA" 	   , "Antecipação ao fornecedor" } )	// "Antecipação ao fornecedor"
           	Aadd(uRetorno, { '!Empty(SE2->E2_XDTANTE) .and. Empty(SE2->E2_BAIXA)', aLegenda[7][1] } )
        EndIf	
		Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0', aLegenda[5][1] } )			
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) + ROUND(E2_SDACRES,2)  = 0', aLegenda[3][1] } )
		Aadd(uRetorno, { '!Empty(E2_NUMBOR)', aLegenda[4][1] } )
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)', aLegenda[2][1] } )
		Aadd(uRetorno, { '.T.', aLegenda[1][1] } )                          		

	Endif
Else
	If cAlias = "SE1"
		Aadd(aLegenda,{"BR_AMARELO", "Titulo Protestado"}) //"Titulo Protestado"
    Else 
    	IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")    
    		Aadd(aLegenda, {"BR_AMARELO",  "Titulo aguardando liberacao"}) //Titulo aguardando liberacao 
    	EndIf

    Aadd(aLegenda, {"BR_LARANJA" 	   , "Antecipação ao fornecedor" } )	// "Antecipação ao fornecedor"
//    Aadd(uRetorno, { '!Empty(E2_DTANTEC)', aLegenda[7][1] } )

	Endif

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Endif

Return uRetorno
