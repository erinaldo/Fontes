#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.05ºAutor  ³Adriana e Danielle  º Data ³  10/03/02   º±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.06ºAutor  ³Adriana             º Data ³  30/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma³CSUCAPA_1.07ºAutor  ³MTdO                º Data ³  30/12/03   º±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CSUCAPA_1.07aºAutor ³MTdO                º Data ³  30/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma³CSUCAPA_1.07bºAutor ³MTdO-revis.  josmar º Data ³  17/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºPrograma³CSUCAPA_1.07cºAutor ³MTdO-revis.  josmar º Data ³  17/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºDesc.   ³Impressão da Autorizacao de Pagamento                         º±± 
±±º        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³MARKETSYSTEM                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                           

User Function CAPA_INSTITUTO()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private empresa:=""
Private cPerg  := PADR("CAPA",LEN(SX1->X1_GRUPO))
Private Res,Conta,NatDesc,Desc,X,Nome_for,Cod_for,Conta_Reduz_for,ContaReduz,Descr_for,Cgc_for:= ""
Private	Tit_Emissao,Tit_Vencim,Tit_RatCSU,Tit_VencRea,Tit_Parc,Tit_VlBruto,Tit_VlIR,Tit_VlInss,Tit_Vlmp135:="" //ACRESCENTADO VARIAVEL (TIT_VLMP135) P/ CONTEMPLAR MP135 - DEZ/2003
Private Tit_VlIss,Tit_VlLiq,Tit_Hist,Tit_tipo,Tit_NumDoc,Tit_Naturez,Tit_Custo,Empresa,Tit_contareduz,Tit_Descr:=""
Private Courier, cCode
Private Linha,Soma,Vlrateio,Perc,Valrat :=0
Private Somabruto:=0
Private SomaIRRF:=0
Private SomaINSS:=0
Private SomaISS:=0
Private Somaliq:=0
Private Tit_Conta_Debito:=""
Private Tit_Descricao:=""
Private Aglutina:={}
Private Rateio:={}
Private Pag:=1

nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.

Private Courier   := TFont():New( "Courier New",,nHeight,,lBold,,,,,lUnderLine )
Private Courier08F:= TFont():New( "Courier New",,08,,.f.,,,,,.f. )
Private Courier08T:= TFont():New( "Courier New",,08,,.t.,,,,,.f. )
Private Courier10F:= TFont():New( "Courier New",,10,,.f.,,,,,.f. )
Private Courier10T:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private Courier12T:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
Private Courier12F:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
Private Courier14 := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
Private Courier28 := TFont():New( "Courier New",,28,,.t.,,,,,.f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

validperg()

If !Pergunte(cPerg,.T.)
	
	Return
	
Endif

RptStatus({|| RunReport()})

Return

// **********************************
// *           PARAMETROS           *
// **********************************
// * mv_par01  * Emissao de      ?  *
// * mv_par02  * Emissao ate     ?  *
// * mv_par03  * Tipo de         ?  *
// * mv_par04  * Tipo ate        ?  *
// * mv_par05  * Numero de       ?  *
// * mv_par06  * Mumero ate      ?  *
// * mv_par07  * Fornecedor de   ?  *
// * mv_par08  * Fornecedor ate  ?  *
// * mv_par09  * Loja de         ?  *
// * mv_par10  * Loja ate        ?  *
// **********************************

//********************************************************************

Static Function RunReport()

ProcRegua(3)

_cQuery := " SELECT * FROM "+RETSQLNAME("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
_cQuery += " E2_FILIAL = '"+xFilial("SE2")+"' AND "                                 
_cQuery += " E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
_cQuery += " E2_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
_cQuery += " E2_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
_cQuery += " E2_FORNECE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
_cQuery += " E2_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
_cQuery += " ORDER BY E2_FILIAL,E2_EMISSAO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA "

IF Select("TRSE2")>0
	dbselectarea("TRSE2")
	dbclosearea()
Endif

IncProc("Obtendo Dados ")
TCQUERY _cQuery NEW ALIAS "TRSE2"

acampos := TRSE2->( dbStruct()  )

cArqTrb := CriaTrab(aCampos,.t.)

Copy to &cArqTrb
                 
dbclosearea("TRSE2")

dbUseArea(.T.,,cArqTrb,"TRSE2",.T.)

cIndTrb1 := CriaTrab(Nil,.F.)

IncProc("Indexando Dados")
DbSelectArea("TRSE2")
cChave1 := "E2_FILIAL+E2_EMISSAO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA"

IndRegua("TRSE2",cIndTrb1,cChave1,,,OemToAnsi("Indexando Dados...") )

dbSelectArea("TRSE2")
dbsetorder(1)
DBGOTOP()

SetRegua(RecCount())

WHILE !EOF()
	
	IncRegua("Imprimindo os registros...")
	
	_aSM := GetArea()
	
	//Dados do fornecedor
	dbselectarea ("SA2")
	dbsetorder (1)
	dbseek (xFilial() + TRSE2->E2_FORNECE + TRSE2->E2_LOJA)
	                      
	//Dados do Fornecedor
	Nome_for	   := SA2->A2_NOME
	Cod_for		   := SA2->A2_COD
	Conta_Reduz_for:= ContaReduz(SA2->A2_CONTA)
	Descr_for	   := Desc(Conta_Reduz_For)
	Cgc_for 	   := SA2->A2_CGC
	
	//Dados do Titulo
	Tit_Emissao    	:= TRSE2->E2_EMISSAO
	Tit_Emissao     := SUBS(Tit_Emissao,7,2)+"/"+SUBS(Tit_Emissao,5,2)+"/"+SUBS(Tit_Emissao,1,4)
	Tit_Vencim     	:= TRSE2->E2_VENCTO
	Tit_Vencim      := SUBS(Tit_Vencim,7,2)+"/"+SUBS(Tit_Vencim,5,2)+"/"+SUBS(Tit_Vencim,1,4) 
	Tit_RatCSU	   	:= TRSE2->E2_MULTNAT
	Tit_VencRea    	:= TRSE2->E2_VENCREA
	Tit_VencRea     := SUBS(Tit_VencRea,7,2)+"/"+SUBS(Tit_VencRea,5,2)+"/"+SUBS(Tit_VencRea,1,4)
	Tit_Parc       	:= TRSE2->E2_PARCELA
	Tit_Vlmp135		:= (TRSE2->E2_Pis+TRSE2->E2_CSLL+TRSE2->E2_Cofins)
	Tit_VlBruto    	:= (TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS+TRSE2->E2_PIS+TRSE2->E2_CSLL+TRSE2->E2_COFINS)
	Tit_VlIR       	:= TRSE2->E2_IRRF
	Tit_VlInss     	:= TRSE2->E2_INSS
	Tit_VlIss   	:= TRSE2->E2_ISS 
	Tit_VlLiq     	:= TRSE2->E2_VALOR
	Tit_Hist   	  	:= TRSE2->E2_HIST
	Tit_tipo      	:= TRSE2->E2_TIPO
	Tit_NumDoc    	:= TRSE2->E2_NUM
	
	//QUANDO MULTIPLANATUREZA FOR 2(NAO) 
	IF TRSE2->E2_MULTNAT == "2" 
		Empresa			:= TRSE2->E2_PREFIXO
		Tit_Naturez		:= TRSE2->E2_NATUREZ
		Tit_Custo 		:= TRSE2->E2_CCUSTO
		Tit_Conta_Debito:= NatDesc(TRSE2->E2_NATUREZ,TRSE2->E2_CCUSTO)
		Tit_Descricao   := Desc(Tit_Conta_Debito)
	Endif
	
	//QUANDO MULTIPLANATUREZA FOR 1(SIM)
	IF TRSE2->E2_MULTNAT == "1"
		   
		    Empresa			:= TRSE2->E2_PREFIXO
			Tit_Naturez		:= TRSE2->E2_NATUREZ
			Tit_Custo 		:= TRSE2->E2_CCUSTO
			tx_prefixo		:= TRSE2->E2_PREFIXO
			tx_Numero   	:= TRSE2->E2_NUM
			tx_parc         := TRSE2->E2_PARCELA
			tx_tipo         := TRSE2->E2_TIPO
			tx_codforn		:= TRSE2->E2_FORNECE
			tx_loja			:= TRSE2->E2_LOJA
		    tx_vencrea      := TRSE2->E2_VENCREA
		    tx_vencrea     := SUBS(tx_vencrea,7,2)+"/"+SUBS(tx_vencrea,5,2)+"/"+SUBS(tx_vencrea,1,4)
		    
		//comparacao das soma dos rateios com o valor total do titulo
			VALRAT := Tit_VlBruto
			
			//ROTINA QUE VERIFICA SE O TITULO DE RATEIO TEM RATEIO DE NATUREZAS E CENTROS DE CUSTOS OU SÓ RATEIO DE NATUREZAS JUNTOS NO MESMO TITULO						                           
			//VERIFICA SE TITULO DE RATEIO TEM RATEIO DE NATUREZAS E CENTRO DE CUSTOS
			dbselectarea("SEZ")
			dbsetorder(1)
				   						   		
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)
				SOMA:=0
				while xFilial()== SEZ->EZ_FILIAL .AND. tx_prefixo == SEZ->EZ_PREFIXO .AND.;
					tx_numero == SEZ->EZ_NUM .AND. tx_parc == SEZ->EZ_PARCELA .AND.;
					tx_tipo == SEZ->EZ_TIPO .AND. tx_codforn == SEZ->EZ_CLIFOR .AND.;
					tx_loja == SEZ->EZ_LOJA 
							    
					Tit_Custo     := SEZ->EZ_CCUSTO
					Tit_Naturez   := SEZ->EZ_NATUREZ
					PERC          := ROUND(SEZ->EZ_VALOR/VALRAT,6)
				   	VLRATEIO      := ROUND(VALRAT*PERC,2) 
					
					SOMA := SOMA + VLRATEIO
					Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
					Tit_Descr	  := Desc(Tit_contareduz)
							
					aadd(Rateio,{Tit_Naturez,;      //1
					tx_numero,;                     //2
					Tit_Custo,;                     //3
					Tit_contareduz,;                //4
					Tit_Descr,;                     //5
					VLRATEIO,;                      //6
					tx_vencrea,;                    //7
					Tit_parc,;                      //8
					Tit_Tipo,;                      //9
					tx_Prefixo})                    //10 EMPRESA 
					dbselectarea("SEZ")
					dbskip()     
				enddo
				//VERIFICA SE TITULO DE RATEIO TEM RATEIO SO DE NATUREZAS
				dbselectarea("SEV") 
				dbsetorder(1)
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)

					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
			 				tx_numero == SEV->EV_NUM .AND. tx_parc == SEV->EV_PARCELA .AND.;
							tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
							tx_loja == SEV->EV_LOJA
						
						IF SEV->EV_RATEICC == "2" 
						     
						    Tit_Custo           := "Nao Rateado"
							Tit_naturez         := SEV->EV_NATUREZ
							PERC                := ROUND(SEV->EV_VALOR/VALRAT,6)
				   			VLRATEIO            := ROUND(VALRAT*PERC,2)
					
							SOMA := SOMA + VLRATEIO
							Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
							Tit_Descr	  := Desc(Tit_contareduz)
							
							aadd(Rateio,{Tit_Naturez,;      //1
							tx_numero,;                     //2
							Tit_Custo,;                     //3
							Tit_contareduz,;                //4
							Tit_Descr,;                     //5
							VLRATEIO,;                      //6
							tx_vencrea,;                    //7
							Tit_parc,;                      //8
							Tit_Tipo,;                      //9
							tx_prefixo})                    //10 EMPRESA 
							
						ENDIF
						dbselectarea("SEV")
						dbskip()
					enddo	
					If SOMA <> Tit_VlBruto
					
						VLRATEIO := Rateio[len(rateio),6]
						
						IF soma > Tit_VlBruto
							VLRATEIO:= VLRATEIO-(soma-Tit_VlBruto)
						Else
							VLRATEIO:= VLRATEIO+(Tit_VlBruto-soma)
						Endif
					    
						Rateio[len(rateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ELSE
				// SE NAO ACHOU O TITULO NO SEZ - TITULOS COM RATEIO SO DE NATUREZAS
				dbselectarea("SEV") 
				dbsetorder(1)
								
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
					SOMA:=0
					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
							tx_numero == SEV->EV_NUM .AND. tx_parc == SEV->EV_PARCELA .AND.;
							tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
							tx_loja == SEV->EV_LOJA
						
						Tit_Custo           := "Nao Rateado"
						Tit_naturez         := SEV->EV_NATUREZ
						PERC                := SEV->EV_PERC 
				   		VLRATEIO            := ROUND(VALRAT*PERC,2)
					
						SOMA := SOMA + VLRATEIO
						Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
						Tit_Descr	  := Desc(Tit_contareduz)
							
						aadd(Rateio,{Tit_Naturez,;      //1
						tx_numero,;                     //2
						Tit_Custo,;                     //3
						Tit_contareduz,;                //4
						Tit_Descr,;                     //5
						VLRATEIO,;                      //6
						tx_vencrea,;                    //7
						Tit_parc,;                      //8
						Tit_Tipo,;                      //9
						tx_prefixo})                    //10 EMPRESA 
						dbselectarea("SEV")
						dbskip()
					enddo	
					If SOMA <> Tit_VlBruto
					
						VLRATEIO := Rateio[len(rateio),6]
						
						IF soma > Tit_VlBruto
							VLRATEIO:= VLRATEIO-(soma-Tit_VlBruto)
						Else
							VLRATEIO:= VLRATEIO+(Tit_VlBruto-soma)
						Endif
					    
						Rateio[len(rateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ENDIF
	ENDIF
	
	
	//QUANDO MULTIPLA NATUREZA FOR IGUAL A BRANCO
	If empty(TRSE2->E2_MULTNAT)
		
		If TRSE2->E2_TIPO$"INS/ISS/TX " 
			
			Empresa			:= TRSE2->E2_PREFIXO
			Tit_Naturez		:= TRSE2->E2_NATUREZ
			Tit_Custo 		:= TRSE2->E2_CCUSTO
			tx_prefixo		:= TRSE2->E2_PREFIXO
			tx_Numero   	:= TRSE2->E2_NUM
			tx_parc         := TRSE2->E2_PARCELA
			tx_parcpric     := SUBSTR(TRSE2->E2_CSUKEY,12,1)
			tx_tipo         := SUBSTR(TRSE2->E2_CSUKEY,13,3)
			tx_codforn		:= SUBSTR(TRSE2->E2_CSUKEY,16,6)
			tx_loja			:= SUBSTR(TRSE2->E2_CSUKEY,22,2)
			tx_vencrea      := TRSE2->E2_VENCREA
			tx_vencrea      := SUBS(tx_vencrea,7,2)+"/"+SUBS(tx_vencrea,5,2)+"/"+SUBS(tx_vencrea,1,4)
			
			//comparacao das soma dos rateios com o valor total do titulo
			VALRAT      := TRSE2->E2_VALOR  
						
			// BUSCA VALOR TOTAL DO TITULO PAI
			_AREA := GetArea()
			REG := RECNO() // POSICAO DO PONTEIRO ANTES DO DBSEEK
			dbselectarea("SE2")
			dbsetorder(1)
						
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)
				VlBrutopai	:= (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_PIS+SE2->E2_CSLL+SE2->E2_COFINS)
			ENDIF
			
			RestArea(_AREA)
			DBGOTO(REG) // VOLTA O PONTEIRO APOS O DBSEEK
			  
			//Verifica se o titulo tem rateiro 						                           
			dbselectarea("SEZ")
			dbsetorder(1)
					   						   		
			IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)
				
				SOMA:=0
				Tit_RatCSU := "1" //SETA O TÍTULO PARA RATEIRO

				while xFilial()== SEZ->EZ_FILIAL .AND. tx_prefixo == SEZ->EZ_PREFIXO .AND.;
					tx_numero == SEZ->EZ_NUM .AND. tx_parcpric == SEZ->EZ_PARCELA .AND.;
					tx_tipo == SEZ->EZ_TIPO .AND. tx_codforn == SEZ->EZ_CLIFOR .AND.;
					tx_loja == SEZ->EZ_LOJA 
					
					Tit_custo     := SEZ->EZ_CCUSTO
					Tit_naturez   := SEZ->EZ_NATUREZ
					PERC          := ROUND(SEZ->EZ_VALOR/VlBrutopai,6) 
				   	VLRATEIO      := ROUND(VALRAT*PERC,2)
					
					SOMA := SOMA + VLRATEIO
					Tit_contareduz:= NatDesc(SEZ->EZ_NATUREZ,SEZ->EZ_CCUSTO)
					Tit_Descr	  := Desc(Tit_contareduz)
							
					aadd(Rateio,{Tit_naturez,;      //1
					tx_numero,;                     //2
					Tit_custo,;                     //3
					Tit_contareduz,;                //4
					Tit_Descr,;                     //5
					VLRATEIO,;                      //6
					tx_vencrea,;                    //7
					Tit_parc,;                      //8
					Tit_Tipo,;                      //9
					tx_prefixo})                    //10 EMPRESA 
					dbselectarea("SEZ")
					dbskip()     
				enddo
			//VERIFICA SE TITULO DE RATEIO TEM RATEIO SO DE NATUREZAS
				dbselectarea("SEV") 
				dbsetorder(1)
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
					
					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
			 				tx_numero == SEV->EV_NUM .AND. tx_parcpric == SEV->EV_PARCELA .AND.;
							tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
							tx_loja == SEV->EV_LOJA
						
						IF SEV->EV_RATEICC == "2" 
						     
						    Tit_Custo           := "Nao Rateado"
							Tit_naturez         := SEV->EV_NATUREZ
							PERC                := ROUND(SEV->EV_VALOR/VlBrutopai,6)
				   			VLRATEIO            := ROUND(VALRAT*PERC,2)
					
							SOMA := SOMA + VLRATEIO
							Tit_contareduz:= NatDesc(Tit_Naturez,Tit_Custo)
							Tit_Descr	  := Desc(Tit_contareduz)
							
							aadd(Rateio,{Tit_Naturez,;      //1
							tx_numero,;                     //2
							Tit_Custo,;                     //3
							Tit_contareduz,;                //4
							Tit_Descr,;                     //5
							VLRATEIO,;                      //6
							tx_vencrea,;                    //7
							Tit_parc,;                      //8
							Tit_Tipo,;                      //9
							tx_prefixo})                    //10 EMPRESA 
							
						ENDIF
						dbselectarea("SEV")
						dbskip()
					enddo	
					If SOMA <> VALRAT  
					
						VLRATEIO := Rateio[len(rateio),6]
						
						IF soma > VALRAT
							VLRATEIO:= VLRATEIO-(soma-VALRAT)
						Else
							VLRATEIO:= VLRATEIO+(VALRAT-soma)
						Endif
					    
						Rateio[len(rateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ELSE
				// SE NAO ACHOU O TITULO NO SEZ
				dbselectarea("SEV") 
				dbsetorder(1)
								
				IF dbseek(xFilial()+tx_prefixo+tx_numero+tx_parcpric+tx_tipo+tx_codforn+tx_loja,.F.)  //IF dbseek(TRSE2->E2_CSUKEY,.F.)
					SOMA:=0
					Tit_RatCSU := "1" // SETA O TITULO PARA RATEIRO
					while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
							tx_numero == SEV->EV_NUM .AND. tx_parcpric == SEV->EV_PARCELA .AND.;
							tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
							tx_loja == SEV->EV_LOJA
						
						Tit_Custo           := "Nao Rateado"
						Tit_naturez := SEV->EV_NATUREZ
						PERC                := SEV->EV_PERC 
				   		VLRATEIO            := ROUND(VALRAT*PERC,2)
					
						SOMA := SOMA + VLRATEIO
						Tit_contareduz:= NatDesc(SEV->EV_NATUREZ,Tit_Custo)
						Tit_Descr	  := Desc(Tit_contareduz)
							
						aadd(Rateio,{Tit_naturez,;      //1
						tx_numero,;                     //2
						Tit_Custo,;                     //3
						Tit_contareduz,;                //4
						Tit_Descr,;                     //5
						VLRATEIO,;                      //6
						tx_vencrea,;                    //7
						Tit_parc,;                      //8
						Tit_Tipo,;                      //9
						tx_prefixo})                    //10 EMPRESA 
						dbselectarea("SEV")
						dbskip()
					enddo	
					If SOMA <> VALRAT 
					
						VLRATEIO := Rateio[len(rateio),6]
						
						IF soma > VALRAT
							VLRATEIO:= VLRATEIO-(soma-VALRAT)
						Else
							VLRATEIO:= VLRATEIO+(VALRAT-soma)
						Endif
					    
						Rateio[len(rateio),6]:=VLRATEIO
						
					Endif
					soma:=0
				Endif
			ENDIF                      
		Endif		
	Endif
	
	RestArea(_aSM)
	                         
	Somabruto	:=Somabruto+(TRSE2->E2_VALOR+TRSE2->E2_IRRF+TRSE2->E2_INSS+TRSE2->E2_ISS+TRSE2->E2_PIS+TRSE2->E2_CSLL+TRSE2->E2_COFINS)
	SomaInss 	:=SomaInss+TRSE2->E2_INSS
	SomaIRRF 	:=SomaIRRF+TRSE2->E2_IRRF
	SomaIss  	:=SomaIss+TRSE2->E2_ISS
	SomaLiq  	:=SomaLiq+TRSE2->E2_VALOR
     
    IF tit_tipo == "TX "
       
       IF(_nPosic:=ascan(Aglutina,{|_vAux|_vAux[01]==Tit_Emissao.and.;
                                           _vAux[05]==Tit_Parc.and.;
                                           _vAux[12]==Tit_tipo.and.;
                                           _vAux[13]==Tit_Numdoc.and.;
                                           _vAux[14]==Tit_Naturez.and.;
                                           _vAux[19]==Cod_for}))==0 
                                          
			aadd(Aglutina,;
			{Tit_Emissao,;			//01
			Tit_Vencim,;    		//02
			Tit_RatCSU,;    		//03
			Tit_VencRea,;   		//04
			Tit_Parc,;      		//05
			Tit_VlBruto,;   		//06
			Tit_VlIR,;      		//07
			Tit_VlInss,;    		//08
			Tit_VlIss,;     		//09
			Tit_VlLiq,;     		//10
			Tit_Hist,;      		//11
			Tit_tipo,;      		//12
			Tit_NumDoc,;    		//13
			Tit_Naturez,;   		//14
			Tit_Custo,;     		//15
			Tit_Vlmp135,;			//16 
			desc,;   				//17 CAMPO NAO UTILIZADO MANTER A ORDEM
			Nome_for,;	    		//18
			Cod_for,;				//19
			Conta_Reduz_for,; 		//20
			Descr_for,;	      		//21
			Cgc_for ,;      		//22
			Tit_Conta_Debito,;		//23
			Tit_Descricao,;		  	//24
			Empresa})   		  	//25                                           
	   ELSE 
     	   aGlutina[_nPosic][06]+=tit_vlBruto
	       aGlutina[_nPosic][10]+=tit_vlLiq
	   ENDIF                                        
     ELSE
	  	aadd(Aglutina,;
		{Tit_Emissao,;			//01
		Tit_Vencim,;    		//02
		Tit_RatCSU,;    		//03
		Tit_VencRea,;   		//04
		Tit_Parc,;      		//05
		Tit_VlBruto,;   		//06
		Tit_VlIR,;      		//07
		Tit_VlInss,;    		//08
		Tit_VlIss,;     		//09
		Tit_VlLiq,;     		//10
		Tit_Hist,;      		//11
		Tit_tipo,;      		//12
		Tit_NumDoc,;    		//13
		Tit_Naturez,;   		//14
		Tit_Custo,;     		//15
		Tit_Vlmp135,;			//16 
		desc,;   				//17 CAMPO NAO UTILIZADO MANTER A ORDEM
		Nome_for,;	    		//18
		Cod_for,;				//19
		Conta_Reduz_for,; 		//20
		Descr_for,;	      		//21
		Cgc_for ,;      		//22
		Tit_Conta_Debito,;		//23
		Tit_Descricao,;		  	//24
		Empresa})   		  	//25
	ENDIF
		
	DBSelectArea("TRSE2")
	dbSkip()
Enddo

//inicia a impressão dos títulos...
oPrn := TMSPrinter():New()
oPrn :Setup()

For x:=1 to Len(Aglutina)
	
	oPrn:Say( 10, 10, " ",Courier,100 ) // startando a impressora
	cabecalho()
	OPrn:Say(600,380,"NOME      : "+Aglutina[X,18],Courier12T,0)
	oPrn:Say(650,380,"FORNECEDOR: " +Aglutina[X,19],Courier12T,0)
	oPrn:Say(650,1100,"CNPJ       : "+TRANSFORM((Aglutina[X,22]),"@R 99.999.999/9999-99"),Courier12T,0)
	oPrn:Say(700,380,"TIPO   : " +(Aglutina[X,12]),Courier12T,0)
	oPrn:Say(700,1100,"NUM.DOC : " +(Aglutina[X,13]),Courier12T,0)
	OPrn:Say(900,100,"DT.EMISSAO " ,Courier12T,0)
	OPrn:Say(950,100,TRANSFORM((Aglutina [X,1]),"@E"),Courier12F,0)
	OPrn:Say(900,600,"VENCIMENTO " ,Courier12T,0)
	OPrn:Say(950,600,TRANSFORM((Aglutina [X,2]),"@E"),Courier12F,0)
	OPrn:Say(900,1100,"VENC.REAL " ,Courier12T,0)
	OPrn:Say(950,1100,TRANSFORM((Aglutina [X,4]),"@E"),Courier12F,0)
	OPrn:Say(900,1600,"PARCELA",Courier12T,0)
	OPrn:Say(950,1600,(Aglutina [X,05]),Courier12F,0)
	OPrn:Say(900,1900,"VL. BRUTO R$",Courier12T,0)
	OPrn:Say(950,1900, TRANSFORM((Aglutina[X,6]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,100,"LEI 10833/03 R$",Courier12T,0) 
	OPrn:Say(1150,100, TRANSFORM((Aglutina[X,16]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,560,"VL. I.R. R$",Courier12T,0)
	OPrn:Say(1150,570, TRANSFORM((Aglutina[X,7]),"@E 999,999.99"),Courier12F,0)
	OPrn:Say(1100,1000,"VL. I.N.S.S. R$",Courier12T,0)
	OPrn:Say(1150,1020, TRANSFORM((Aglutina[X,8]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,1450,"VL.I.S.S. R$",Courier12T,0)
	OPrn:Say(1150,1450,TRANSFORM((Aglutina[X,9]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1100,1900,"VL. LIQUIDO R$",Courier12T,0)
	OPrn:Say(1150,1900, TRANSFORM((Aglutina[X,10]),"@E 999,999,999.99"),Courier12F,0)
	OPrn:Say(1250,100,"HISTORICO :"+(Aglutina[X,11]),Courier12T,0)
	OPrn:Say(1500,050,REPLICATE("_",150),Courier12T,0)
	OPrn:Say(1600,050,"C/CREDITO  ",Courier12T,0)
	OPrn:Say(1650,050,Aglutina [X,20],Courier12F,0)
	OPrn:Say(1600,800,"DESCRICAO  ",Courier12T,0)
	OPrn:Say(1650,800,Aglutina [X,21],Courier12F,0)
	OPrn:Say(1800,50,"EMPRESA ",Courier08T,0)
	OPrn:Say(1800,200,"NATUREZA ",Courier08T,0)
	OPrn:Say(1800,450,"NUMERO ",Courier08T,0)
	OPrn:Say(1800,650,"C/CUSTO ",Courier08T,0)
	OPrn:Say(1800,850,"C/DEBITO ",Courier08T,0)
	OPrn:Say(1800,1050,"DESCRICAO",Courier08T,0)
	OPrn:Say(1800,1950,"VALOR R$",Courier08T,0)
	OPrn:Say(1800,2250,"VENC.REAL",Courier08T,0)
	linha:=1850
	
	If  AGLUTINA[X,3]=="1" // TITULO COM RATEIRO
		
		FOR J:=1 TO LEN(RATEIO)
			//tipo                            //numero                         //parcela
			If RATEIO[J,9]==AGLUTINA[X,12] .AND. RATEIO[J,2]==AGLUTINA[X,13] .AND. RATEIO[J,8]==AGLUTINA[X,5]
				
				OPrn:Say(linha,50,RATEIO[J,10],Courier08F,0)
				OPrn:Say(linha,200,RATEIO[J,1],Courier08F,0)
				OPrn:Say(linha,450,RATEIO[J,2],Courier08F,0)
				OPrn:Say(linha,650,RATEIO[J,3],Courier08F,0)
				OPrn:Say(linha,850,RATEIO[J,4],Courier08F,0)
				OPrn:Say(linha,1050,RATEIO[J,5],Courier08F,0)
				OPrn:Say(linha,1950,TRANSFORM(RATEIO[J,6],"@E 999,999,999.99"),Courier08F,0)
				OPrn:Say(linha,2250,TRANSFORM(RATEIO[J,7],"@E"),Courier08F,0)
				linha:=linha+50
				
				if linha>2860
					PAG:=PAG+1
					oPrn:EndPage()
					oPrn:StartPage()
					cabecalho()
					cabecalho2()
					linha:=480
				Endif
				
			Endif
		NEXT
		
	Else
	
		OPrn:Say(linha,50,Aglutina[X,25],Courier08F,0)
		OPrn:Say(linha,200,Aglutina[X,14],Courier08F,0)
		OPrn:Say(linha,450,Aglutina[X,13],Courier08F,0)
		OPrn:Say(linha,650,Aglutina[X,15],Courier08F,0)
		OPrn:Say(linha,850,Aglutina[X,23],Courier08F,0)
		OPrn:Say(linha,1050,Aglutina[X,24],Courier08F,0)
		OPrn:Say(linha,1950,TRANSFORM(Aglutina[X,06],"@E 999,999,999.99"),Courier08F,0)
		OPrn:Say(linha,2250,TRANSFORM(Aglutina[X,4],"@E"),Courier08F,0)
	Endif
	
	linha:=linha+200
	OPrn:Say(Linha,050,REPLICATE("_",40),Courier12T,0)
	OPrn:Say(Linha,1500,REPLICATE("_",40),Courier12T,0)
	linha:=linha+50
	OPrn:Say(Linha,400,"AUTORIZADO",Courier12T,0)
	
	oPrn:EndPage()
	
	if len(aglutina)>1 .AND. (x)<len(aglutina)
		oPrn:StartPage()
	Endif
	
	
NEXT

oPrn:Preview()

MS_FLUSH()
DBCloseArea("TRSE2")

Return

//********************************************************************

Static Function Cabecalho()

linha:=30
OPrn:Say(Linha,050,REPLICATE("_",150),Courier12T,0)
linha:=linha+100

Empresa := SM0->M0_CODIGO		

IF Empresa=="30" // MARKETSYSTEM
	oPrn:Say(linha,100,"MARKETSYSTEM",Courier14,0  )
ElseIF Empresa=="31"  
	oPrn:Say(linha,100,"ANAPURUS",Courier14,0  )
ElseIF Empresa=="32"  
	oPrn:Say(linha,100,"CRIEFF",Courier14,0  )
ElseIF Empresa=="33"  
	oPrn:Say(linha,100,"GLOBAL",Courier14,0  )	
ElseIF Empresa=="34"  
	oPrn:Say(linha,100,"B2C",Courier14,0  )	
ElseIF Empresa=="35"  
	oPrn:Say(linha,100,"MONTALCINO",Courier14,0  )	
ElseIF Empresa=="36"  
	oPrn:Say(linha,100,"TALENTO",Courier14,0  )	
ElseIF Empresa=="37"  
	oPrn:Say(linha,100,"TVSYSTEM",Courier14,0  )	
ElseIF Empresa=="06"  
	oPrn:Say(linha,100,"INSTITUTO CSU",Courier14,0  )		
Endif
oPrn:Say(linha,2120,"DATA "+TRANSFORM(DATE(),"@E"),Courier12T,0)
linha:=linha+50
oPrn:Say(linha,2120,"HORA "+TIME(),Courier12T,0  )
linha:=linha+50
oPrn:Say(linha,900,"AUTORIZACAO DE PAGAMENTO",Courier14,0  )
oPrn:Say(linha,2120,"PAG. "+Alltrim(STR(PAG)),Courier12T,0  )
linha:=linha+100
OPrn:Say(Linha,050,REPLICATE("_",150),Courier12T,0)

Return

//********************************************************************

Static Function Cabecalho2()

linha:=linha+100
OPrn:Say(1800,50,"EMPRESA ",Courier08T,0)
OPrn:Say(1800,200,"NATUREZA ",Courier08T,0)
OPrn:Say(1800,450,"NUMERO ",Courier08T,0)
OPrn:Say(1800,650,"C/CUSTO ",Courier08T,0)
OPrn:Say(1800,850,"C/DEBITO ",Courier08T,0)
OPrn:Say(1800,1050,"DESCRICAO",Courier08T,0)
OPrn:Say(1800,1950,"VALOR R$",Courier08T,0)
OPrn:Say(1800,2250,"VENC.REAL",Courier08T,0)
linha:=linha+50

Return

//********************************************************************

Static Function Natdesc(Natureza,Ccusto)

dbselectarea("SED")
dbsetorder(1)
Res:=""
If dbseek (xFilial()+Natureza)// Natureza recebe o codigo para localizar se e despesa ou receita ou patrimonial
	
	If SED->ED_RECDEP$"D"
		
		dbselectarea("CTT")
		dbsetorder(1)
		If dbseek (xFilial()+Ccusto)//Posiciona o centro de custo para saber o grupo
			grupo:=CTT->CTT_GRUPO
			
			dbselectarea("SZ1")
			
			dbsetorder(1)
			If dbseek (XFilial()+Natureza+Grupo)//Posiciona a natureza e o grupo de centro de custo para achar a conta contabil
				Conta:=SZ1->Z1_CCONTAB
				
				dbselectarea ("CT1")
				dbsetorder(1)
				If dbseek (XFilial()+Conta)//Posiciona a conta para achar o codigo reduzido e a descricao
					
					Res :=CT1->CT1_RES
					
				Endif
			Else
				
				Res:=""
				
			Endif
		Else 
				Res:=""

		Endif
		
		
	Elseif SED->ED_RECDEP$"P/R"
		
		dbselectarea("SZ1")
		dbsetorder(1)
		If dbseek (XFilial()+Natureza)//Posiciona a natureza  para achar a conta contabil
			Conta:=SZ1->Z1_CCONTAB
			
			dbselectarea ("CT1")
			dbsetorder(1)
			If dbseek (XFilial()+Conta)//Posiciona a conta para achar o codigo reduzido e a descricao
				
				Res :=CT1->CT1_RES
				
			Endif
		Else
			
			Res:=""
			
		Endif
	Endif
Endif
Return(Res)

//********************************************************************

Static Function Desc(Res)

Desc:="VERIFICAR AMARRAÇÃO CONTÁBIL"

IF !EMPTY(RES)
	dbselectarea ("CT1")
	dbsetorder(2)
	If dbseek (XFilial()+Res)//Posiciona a conta para achar a descricao
		Desc:=CT1->CT1_DESC01
	Endif
Else
	Desc:="VERIFICAR AMARRAÇÃO CONTÁBIL"
Endif
Return (Desc)

//********************************************************************
 
Static Function ContaReduz(Conta)
Private reduz:=""

dbselectarea ("CT1")
dbsetorder(1)

If dbseek (XFilial()+Conta)//Posiciona a conta para achar o codigo reduzido
	Reduz:=CT1->CT1_RES
Endif

Return (Reduz)

//********************************************************************

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01"," Emissao de      ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"," Emissao ate     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03"," Tipo de         ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04"," Tipo ate        ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05"," Numero de       ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06"," Numero ate      ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07"," Fornecedor de   ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"08"," Fornecedor ate  ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"09"," Loja de         ?","","","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10"," Loja ate        ?","","","mv_ch10","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

//********************************************************************