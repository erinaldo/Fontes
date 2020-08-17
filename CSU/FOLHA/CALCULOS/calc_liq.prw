#INCLUDE 'RWMAKE.Ch'                                          
#INCLUDE 'PROTHEUS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao de usuario   ³ fLiquido                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Calculo do Liquido - Específico CSU                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fliquido(aCodfol,nArred,lIns,lSfam)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aCodFol   - Matriz Com Codigos da Folha                     ³±±
±±³          ³cCodliq   - Verba de Gravacao do Liquido                    ³±±
±±³          ³nArred    - Valor a Ser Arredondado                         ³±±
±±³          ³cCodArred - Verba de Grav. do Arredondamento                ³±±
±±³          ³lIns      - .F. OU .F. para Gravar Insuficiencia de saldo   ³±±
±±³          ³cCodIns   - Verba de Grav. da Insuficiencia                 ³±±
±±³          ³lObrigat  - .T. Para Obrigatoriedade da Verba no Liquido    ³±±
±±³          ³lGrava    - .T. Para Gravar o Liquido, Arred. e Insuf.      ³±±
±±³          ³lDemiss   - .T. Para Considerar Funcionarios Demitidos na Ge³±±
±±³          ³                racao de Insuficiencia de Saldo			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fLiquido(aCodfol,cCodliq,nArred,cCodArred,lIns,cCodIns,lObrigat,lGrava,lDemiss)

Local nObrigat	:= 0.00
Local nPos		:= 0.00
Local nApd		:= 0.00
Local nLenApd	:= IF( Type("aPd") == "A" , Len( aPd ) , 0.00 )
Local aArea		:=	{}
//by Isamu: verbas que poderiam estar com RV_OBRIGAT="S"
Local cPDSalMat := aCodFol[040,1]
Local cPDINSS   := aCodFol[064,1]
Local cPDIRRF   := aCodFol[066,1]
Local cPDAdto   := aCodFol[007,1]   
Local cPDSalFam := aCodFol[34,1]
Local cPDPLR    := aCodFol[151,1]

//Local TipoAf    := " " 
//Local dDtRef    := Ctod("")
//--Sit.Func. na data de ref
cSitFolh	:= If( type("cSitFolh")=="U",SRA->RA_SITFOLH,cSitFolh)

DEFAULT aCodFol 	:= {}
DEFAULT cCodLiq		:= Space(03)
DEFAULT nArred		:= 0.00
DEFAULT cCodArred	:= Space(03)
DEFAULT lIns		:= .T.
DEFAULT cCodIns		:= Space(03)
DEFAULT lGrava		:= .T.
DEFAULT lObrigat	:= .F.
DEFAULT lDemiss		:= .F. 

//dDtRef := Stod(GetMv("MV_FOLMES")+"01")

// VERIFICA SE O TIPO DE AFASTAMENTO É MATERNIDADE
//Fchkafas(sra->ra_filial,sra->ra_mat,dDtRef,,,@TipoAf)

If nDiasMat > 0//TipoAf == "Q"
 
	FDELPD("008")
  
  
  nLiquido := 0.00

  // Soma P/ compor o Liq
  Aeval( aPd ,{ |x| SomaInc(x,0,@nLiquido,,,,,,.F.,aCodFol ) } )


  // Verifica o valor dos Valores Obrigatorios
  IF lObrigat
      IF SRV->( FieldPos("RV_OBRIGAT") == 0 ) //Quando nao Existir o Campo considera apenas o Sal. Fam.
	     Aeval(aPd,{ |X| nObrigat += If ( X[1]==aCodFol[34,1] .And. x[3] = cSemana .And. X[9] # "D" ,X[5] ,0)})
	  Else
	   
	   For nApd := 1 To nLenApd
			//by Isamu: alteracao para identificar apenas Sal.Maternidade, INSS, IRRF e Adto Salario, pois alterar o 
			//campo RV_OBRIGAT, estava interferindo no calculo de rescisao 
			//IF aPD[ nApd , 3 ] == cSemana .and. aPd[ nApd , 9 ] # "D" .and. ;
			   //Upper( PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_OBRIGAT") ) == "S" 
			   
           If aPD[ nApd , 3 ] == cSemana .and. aPd[ nApd , 9 ] # "D" .and.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDSalMat .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDINSS .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDIRRF .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDAdto .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == "123" .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDSalFam .or.;
              PosSrv(aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_COD") == cPDPLR

				If PosSrv( aPD[ nApd , 1 ],SRA->RA_FILIAL,"RV_TIPOCOD" ) == "2"  // Validação para verificar se a verba é Provento ou Desconto
					nObrigat -= aPd[ nApd , 5 ]
				Else
					nObrigat += aPd[ nApd , 5 ]
				Endif

		   EndIF
	   Next nApd
	
	EndIF
	
  EndIF

  IF Type("cCalcInf") != "U" .and. cCalcInf == "S" // GETMV("MV_CALCINF")
    	nObrigat := 0
  EndIF
  
  //by Isamu caso, nobrigat seja negativo, atribuo zero
  If nObrigat < 0
     nObrigat := 0
  Endif   

  nVAL_ARRE := VLR_INS := 0.00
  
  IF ( nLiquido < 0.00  .or. ( lObrigat .and. nliquido < nObrigat) ) .and. lIns
	// CALCULO DO PROVENTO INSUFICIENCIA DE SALDO
	// QUANDO HA VERBAS OBRIGATORIAS O VALOR DO LIQUIDO DEVE
	// SER IGUAL AO MESMO, E NUNCA ZERO, NESTES CASOS
	nVlr_ins := 0.00
	IF !( cSitFolh $ "D*E" ) .or. ( cSitFolh == "D" .and. lDemiss )
		IF Round(nLiquido,2) < 0.00 .Or. ( lObrigat .and. Round(nLiquido,2) < nObrigat)
		   
			  IF Round(nLiquido,2) < 0.00
				  nVlr_ins = (nLiquido * -1) //+ nObrigat OS 3478/17
				  nVlr_ins += nObrigat //os 0191/18
				  nLiquido := nObrigat
		      ElseIF lObrigat
				  nVlr_ins := nObrigat - nLiquido
            	  nLiquido := nObrigat
			  EndIF

		EndIF
	ElseIF Round( nLiquido , 2 ) < 0.00
		nVlr_ins = ( nLiquido * -1 )
    EndIF
	IF nVlr_ins # 0

//		FDELPD("008")
		
		IF lGrava
			FMatriz( cCodIns , nVlr_ins )
			If cSemana # Nil .And. !lUltSemana .And. cSemana # Space(2) .And. SRA->RA_TIPOPGT = "S"
				nPos := Ascan( aPeriodo , { |x| x[2] == cSemana } )
				GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aCodFol[046,1],Ctod("  /  /  "),SRA->RA_CC,aPeriodo[nPos+1,2],"V","G",0,nVlr_ins,0)
			Endif
		EndIF	
	EndIF
  
  EndIF


  //--Calcula Arredondamento
  IF nArred > 0.00 .and. nLiquido > 0
	nLiquido := Round( nLiquido , 2 )
	// --- Procura Arredondamento
	IF cCodarred # SPACE(3) .and. Ascan(aPd, { |x| x[1] == cCodarred .and. x[3] == cSemana .and. x[9] # "D"} ) == 0
		nSALV_ARR := nArred
		CALC_ARRE(@nLIQUIDO, @nArred, @nVAL_ARRE,cSemana)
		nArred := nSALV_ARR
		IF lGrava
			FMatriz(cCodArred,nVal_Arre)
		EndIF	
	EndIF
  EndIF

  FDELPD("999")

//-- Grava‡ao do Liquido
  IF Ascan(aPd,{ |x| x[1] == cCodLiq .and. x[3] == cSemana .and. x[9] # "D"}) == 0
	IF lGrava
		If cPaisLoc == "BRA"
			fMatriz(cCodLiq,nLiquido)
		Else
			fMatriz(cCodLiq,nLiquido,,,,,,,,dData_Pgto)			
		Endif
	EndIF
  EndIF
  
Endif

Return( IF( !lGrava , nObrigat , 0 ) ) 
