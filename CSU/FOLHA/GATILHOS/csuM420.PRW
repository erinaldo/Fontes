//#include "FiveWin.ch"
#INCLUDE "GPEM420.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPEM420  ³ Autor ³ Marcos A. Stiefano    ³ Data ³ 11/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera‡„o Valores Extras Para Folha                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPEM420(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cristina    ³14/01/99³Proth ³Tirar o Resource Process                  ³±±
±±³Marina      ³27/01/00³      ³Acerto calculo de proventos e descontos.  ³±±
±±³            ³        ³      ³Cria‡Æo da pergunte:" Informe Provento?". ³±±
±±³Marina      ³23/02/00³      ³Acerto da pergunte "Informe Provento?".   ³±±
±±³Emerson     ³13/09/00³------³Substituicao do teste da verba por PosSrv.³±±
±±³Andreia     ³22/05/03³061571³Quando houver rateio de uma mesma verba   ³±±
±±³            ³        ³      ³entre centros de custo diferentes, sera   ³±±
±±³            ³        ³      ³feito o lancamento rateado no SRC. Se a   ³±±
±±³            ³        ³      ³verba ja existir no SRC, sera substituida ³±±
±±³            ³        ³      ³pelo valor informado em "Valores Extras". ³±±
±±³Natie       ³18/04/05³077011³Efetua lancamentos sequenciais p/val.extra³±±
±±³            ³        ³      ³com dt.pgto diferentes  (Prov)            ³±±
±±³Andreia     ³14/06/05³075478³Ajuste para tratar os parametros "Filial  ³±±
±±³            ³        ³      ³de" e "Filial Ate" na limpeza dos valores ³±±
±±³            ³        ³      ³extras.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
user Function csuM420
Local aSays		:=	{ }
Local aButtons	:= 	{ } //<== arrays locais de preferencia

Private cCadastro := OemToAnsi(STR0001) //"Gera‡„o Valores Extras"
Private nSavRec   := RecNO()
Private aCodpd    := {}
nOpca := 0
	
Pergunte("GPM420",.F.)
	
AADD(aSays,OemToAnsi(STR0002) )	//"Este programa gera para o movimento mensal os lan‡amentos  "
AADD(aSays,OemToAnsi(STR0003) )	//"de valores extras ou limpara o arquivo SR1 (Valores Extras)"
AADD(aSays,OemToAnsi(STR0004) )	//"para processamento do proximo mes.                         "

AADD(aButtons, { 5,.T.,{|| Pergunte("GPM420",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| Gpm420Processs(),STR0005})  //"Gera‡„o Valores Extras"
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao  ³Gpm420ProcesssºAutor  ³Microsiga           º Data ³  06/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³                                                                º±±
±±º        ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ AP                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Gpm420Processs()

Local aCodFol 	:= 	{}
//Local aCodpd 	:= 	{}
Local aHoras 	:= 	{}
Local aValor 	:= 	{}
Local nValor 	:=	0
Local dDtPgt 	:= 	CtOD("  /  /  ")
Local M   
Local nQtdLanc	:= 1 
Local nSeq		:= 0 
Local nPos 		:= 0 
Local nPos1		:= 0
Local aVerbaAux	:= {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis de Log                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local 	aLog		:= {}				//-- Log de Ocorrencias 	
Local 	aLogTitle 	:= {}
Local 	bMakeLog	:= { || NIL }


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01  - Deseja Fazer  1-Gera‡„o    2-Limpeza                  ³
//³ mv_par02  - Processar por 1-Matricula  2-C.Custo                  ³
//³ mv_par03  - Filial De                                             ³
//³ mv_par04  - Filial Ate                                            ³
//³ mv_par05  - Centro de Custo De                                    ³
//³ mv_par06  - Centro de Custo Ate                                   ³   
//³ mv_par07  - Matricula De                                          ³
//³ mv_par08  - Matricula Ate                                         ³
//³ mv_par09  - Informe o Verba Desconto                              ³
//³ mv_par10  - Data de Pagamento                                     ³
//³ mv_par11  - Informe a Verba Provento                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLimGer     :=  mv_par01
nOrdem      :=  mv_par02
cFilDe      :=  mv_par03
cFilAte     :=  mv_par04
cCcDe       :=  mv_par05
cCcAte      :=  mv_par06
cMatDe      :=  mv_par07
cMatAte     :=  mv_par08
cCodDes     :=  mv_par09
dDataPag    :=  mv_par10
cCodProv	:=  mv_par11


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura primeiro funcionario                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 1 )
	dbSeek( cFilDe + cMatDe , .T. )
Elseif nOrdem == 2
	dbSetOrder( 2 )
	dbSeek( cFilDe + cCcDe + cMatDe , .T. )
Endif

cFilAnte := "!!"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento	                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(SRA->(RECCOUNT()))

While SRA->(!Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Move Regua Processamento	                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc(STR0013) //"Gera‡„o Valores Extras"
	
	If SRA->RA_FILIAL # cFilAnte
		If !FP_CODFOL(@aCodFol)
			Return Nil
		Endif
		cFilAnte := SRA->RA_FILIAL
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste o De / Ate  nOrdem = 1-Matricula / 2-Centro Custo   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem == 1
		If SRA->(Eof()) .Or. (SRA->RA_FILIAL + SRA->RA_MAT > cFilAte + cMatAte )
			Exit
		Endif
	ElseIf nOrdem == 2
		If SRA->(Eof()) .Or. (SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT > cFilAte + cCcAte + cMatAte)
			Exit
		Endif
	Endif              
	
	If nLimger == 1
		
		dbSelectArea( "SR1" )
		SR1->( dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		aCodpd 	:= {}
		aHoras 	:= {}
		aValor 	:= {}                      
		aCC	   	:= {}	
		While SR1->(!Eof()) .And. SR1->R1_FILIAL + SR1->R1_MAT == SRA->RA_FILIAL + SRA->RA_MAT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta a Matriz Do Funcionario Por Verba                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			M  := Ascan( aCodpd , SR1->R1_PD )
			nX := Ascan( aCC    , SR1->R1_CC )
			If M > 0 .And. nX > 0
				aHoras[M] += SR1->R1_HORAS
				aValor[M] += SR1->R1_VALOR
				aCC[M]    := SR1->R1_CC
			Else
				Aadd( aCodpd , SR1->R1_PD )
				Aadd( aHoras , SR1->R1_HORAS )
				Aadd( aValor , SR1->R1_VALOR )
				Aadd( aCC    , SR1->R1_CC )
			Endif
			SR1->( dbSkip() )
		Enddo 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava a Verba no SRC                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSeq  		:= 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aVerbaExt	:= {}
		dbSelectArea("SRC") 
		If SRC->( dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ) )
			While !SRC->(eof()) .and. ( SRA->RA_FILIAL + SRA->RA_MAT  ) == SRC->( RC_FILIAL+ RC_MAT  )
				If SRA->RA_FILIAL + SRA->RA_MAT + MesAno( dDataPag )  == SRC->( RC_FILIAL+ RC_MAT + MesAno(RC_DATA) )
				   
					AADD(aVerbaExt,{SRC->RC_FILIAL ,SRC->RC_MAT     ,SRC->RC_DATA , SRC->RC_PD, ;
				    	            SRC->RC_CC     , SRC->RC_SEMANA ,SRC->RC_TIPO1 , SRC->RC_HORAS,; 
				        	        SRC->RC_VALOR  , SRC->RC_PARCELA,SRC->RC_TIPO2 , SRC->RC_SEQ } ) 
				Endif	
				SRC->( DBSKIP() )
			EndDo 
 	 	EndIf 
		
		aVerbaAux:= aClone(aVerbaExt)
		
		For M := 1 To Len(aCodpd)
		
			nPos := Ascan(aVerbaAux, {|x| x[1]+x[2]+x[4]+x[5]== SRA->RA_FILIAL + SRA->RA_MAT + aCodpd[M]+aCC[M] }) 
			
			If nPos > 0 
 				nQtdLanc	:= PosSrv(aCodpd[M],SRA->RA_FILIAL,"RV_QTDLANC" ) 
 				nSeq 		:= 0 
				aeval( aVerbaAux,{|x|  nSeq	+= If(SRA->RA_FILIAL + SRA->RA_MAT + aCodpd[M]+aCC[M] = x[1]+x[2]+x[4]+x[5],1,0 )  }) 
				If fNotLancPD( aCodpd[M], SRA->RA_FILIAL , .T. , @nQtdLanc )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se for ref.a  mesma data,  ou seja, ao mesmo lanca- ³
					//³ mento,e sobrepoe o valor;senao gera novo lancamento c/nova se³
					//³ quencia (de acordo com qtde de seq.permitida de cada verba)  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nPos1:= Ascan(aVerbaAux, {|x| x[1]+x[2]+x[4]+x[5]+dtos(x[3]) == SRA->RA_FILIAL + SRA->RA_MAT+ aCodpd[M]+aCC[M] + dtos(dDataPag ) }) 
					If nPos1 > 0 
						aVerbaAux[nPos1,5]	:= aCC[M]
						aVerbaAux[nPos1,8]	:= aHoras[M]
						aVerbaAux[nPos1,9]	:= aValor[M]
					Else 
						If nSeq >= nQtdLanc 
							//-- Fil Matric Verba C.C.                   Descricao 
							//--  99 999999 999   99999999999999999999 - Quantidade de lancamentos para esta verba foi excedida.
							IF Empty( aLog ) 
								aAdd( aLog , oemtoAnsi(STR0017) ) 		//-- "Geracao Valores Extras
							EndIF
							aAdd( aLog , SRA->( RA_FILIAL+ "  " + RA_MAT ) + " "+ aCodpd[M] + "   "+aCC[M] + " - " + STR0014  )    //"--Excedeu o numero de lancamentos permitido para esta verba.
						Else                        
							AADD(aVerbaAux,{SRA->RA_FILIAL , SRA->RA_MAT    ,dDataPag  , aCodpd[M]    ,;
					                         aCC[M]         ," "            ,"V"       , aHoras[M]     ,; 
					                         aValor[M]      ,0              ,"G"       , If(nSeq >=1, StrZero(nSeq+1,1),"1" ) } ) 
						Endif
					Endif 
				Endif
			Else
				AADD(aVerbaAux,{SRA->RA_FILIAL , SRA->RA_MAT    ,dDataPag  , aCodpd[M]      ,;
                                aCC[M]         ," "             ,"V"       , aHoras[M]      ,; 
	                            aValor[M]      ,0               ,"G"       , "1"            } ) 
			Endif
		Next
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpa Arquivo SR1 - Gravando Ultimo Arredondamento.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SR1" )
		If SR1->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
			nCnt := 0
			While SR1->(!Eof()) .And. SR1->R1_FILIAL + SR1->R1_MAT == SRA->RA_FILIAL + SRA->RA_MAT
				If SR1->R1_PD == aCodFol[180,1]
					nValor := SR1->R1_VALOR
					dDtPgt := SR1->R1_DATA			
				Endif
				RecLock( "SR1",.F.,.T. )
				dbDelete()
				nCnt ++
				MsUnlock()
				SR1->(dbSkip())
			Enddo
			WRITESX2("SR1",nCnt)	
			dbSelectArea( "SX2" )
			MsUnlock()
			If nValor > 0
				dbSelectArea( "SR1" )			
				RecLocK("SR1",.T.)
				SR1->R1_FILIAL  := SRA->RA_FILIAL
				SR1->R1_MAT     := SRA->RA_MAT
				SR1->R1_PD      := aCodFol[180,1]
				SR1->R1_TIPO1   := "V"
				SR1->R1_HORAS   := 0		
				SR1->R1_VALOR   := nValor
				SR1->R1_SEMANA  := "01"
				SR1->R1_CC      := SRA->RA_CC
				SR1->R1_PARCELA := 0
				SR1->R1_TIPO2   := "G"
				SR1->R1_DATA    := dDtPgt	
				MsUnlock()
			Endif	
		Endif			
	Endif
	
	fGvSRC(aVerbaAux )
	
	dbSelectArea( "SRA" )
	SRA->(dbSkip())
Enddo

IF !Empty( aLog )
	IF ( MsgNoYes( OemToAnsi( STR0015 )  , OemToAnsi( STR0016 ) ) ) //-- "Ocorreram inconsistˆncias durante o processo"## "Aten‡„o "
		bMakeLog := { || fMakeLog( { aLog } ,  aLogTitle  , NIL , .T. , FunName() , NIL , "G" , "L" , NIL , NIL ) }
		MsAguarde( bMakeLog , OemToAnsi( STR0018 ) ) 				//--"Log de Ocorrencias - Valores Extras "
	EndIF
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
dbGoTo( nSavRec )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fGvSRC    ºAutor  ³Microsiga           º Data ³  05/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua gravacao dos valores extras                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGvSRC( aVerbaAux )

Local N			:= 1
Local nProv 	:= 0
Local nDesc 	:= 0
Local lGravaprov:= .F. 

Begin Transaction

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Deleta Itens Anterior para Gravar novos dados p/gravar        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Len(aVerbaAux) > 0
		fDelExtrr( aVerbaAux ) 
	Endif
	
	For N:= 1 to Len(aVerbaAux)

		RecLock("SRC", .T. )				//-- INCLUSAO 
		SRC->RC_FILIAL := aVerbaAux[N,01]
		SRC->RC_MAT    := aVerbaAux[N,02]
		SRC->RC_DATA   := aVerbaAux[N,03]
		SRC->RC_PD     := aVerbaAux[N,04]
		SRC->RC_CC     := aVerbaAux[N,05]
		SRC->RC_SEMANA := aVerbaAux[N,06]
		SRC->RC_TIPO1  := aVerbaAux[N,07]
		SRC->RC_HORAS  := aVerbaAux[N,08]
		SRC->RC_VALOR  := aVerbaAux[N,09]
		SRC->RC_PARCELA:= aVerbaAux[N,10]
		SRC->RC_TIPO2  := aVerbaAux[N,11]
		SRC->RC_SEQ    := aVerbaAux[N,12]
		SRC->( MsUnlock() )
		If PosSrv(aVerbaAux[N,4], SRA->RA_FILIAL,"RV_TIPOCOD") == "1"  .and. cCodProv <> SRC->RC_PD .and. Ascan( aCodpd , SRC->RC_PD ) > 0
			nProv += aVerbaAux[N,09]
			lGravaprov	:= .T. 
		Elseif PosSrv(aVerbaAux[N,4],SRA->RA_FILIAL,"RV_TIPOCOD") == "2"  .and. cCodDes <> SRC->RC_PD .and. Ascan( aCodpd , SRC->RC_PD ) > 0
			nDesc += aVerbaAux[N,09]
			lGravaprov	:= .T. 			
		Endif
	Next N
	
	If (nProv > 0 .Or. nDesc > 0) .And. !Empty(cCodDes) .And. !Empty(cCodProv) .and. lGravaProv
		If nProv - nDesc > 0
			cCod := cCodDes
			nVal := nProv - nDesc
		Else
			cCod := cCodProv
			nVal := (nProv - nDesc) * (-1)
		Endif
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cCod )
			RecLocK("SRC",.F.,.T.)
		Else
			RecLocK("SRC",.T.)
		Endif
		SRC->RC_FILIAL  := SRA->RA_FILIAL
		SRC->RC_MAT     := SRA->RA_MAT
		SRC->RC_DATA    := dDatapag
		SRC->RC_PD      := cCod
		SRC->RC_CC      := SRA->RA_CC
		SRC->RC_SEMANA  := " "
		SRC->RC_TIPO1   := "V"
		SRC->RC_HORAS   := 0.00
		SRC->RC_VALOR   := nVal
		SRC->RC_PARCELA := 0
		SRC->RC_TIPO2   := "G"
		SRC->RC_SEQ     := "1"
		MsUnlock()
	Endif
	
End Transaction 	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fDelExtrr ºAutor  ³Microsiga           º Data ³  05/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a delecao dos lancamentos anteriores para efetuar    º±±
±±º          ³a gravacao dos novos lancamentos                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fDelExtrr( aVerbaAux ) 
Local 	n:= 1

For N:= 1 to Len(aVerbaAux)
	SRC->( dbSeek( aVerbaAux[N,1] + aVerbaAux[N,2]+  aVerbaAux[N,4] + aVerbaAux[N,5]  )) 
	While !eof() .and. ;
	      ( aVerbaAux[N,1] + aVerbaAux[N,2]+  aVerbaAux[N,4] + aVerbaAux[N,5] ) == SRC->(RC_FILIAL+RC_MAT+RC_PD+RC_CC) 
		If  dtos(SRC->RC_DATA ) == dtos(aVerbaAux[n,3]) 
			RecLock( "SRC" , .F. , .F. ) 
			SRC->( dbDelete() ) 
			SRC->( MsUnLock() ) 
		Endif
		SRC->( DbSkip() )
	EndDo 
Next N
Return
