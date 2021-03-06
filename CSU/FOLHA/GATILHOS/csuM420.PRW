//#include "FiveWin.ch"
#INCLUDE "GPEM420.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPEM420  � Autor � Marcos A. Stiefano    � Data � 11/09/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera��o Valores Extras Para Folha                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPEM420(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Cristina    �14/01/99�Proth �Tirar o Resource Process                  ���
���Marina      �27/01/00�      �Acerto calculo de proventos e descontos.  ���
���            �        �      �Cria��o da pergunte:" Informe Provento?". ���
���Marina      �23/02/00�      �Acerto da pergunte "Informe Provento?".   ���
���Emerson     �13/09/00�------�Substituicao do teste da verba por PosSrv.���
���Andreia     �22/05/03�061571�Quando houver rateio de uma mesma verba   ���
���            �        �      �entre centros de custo diferentes, sera   ���
���            �        �      �feito o lancamento rateado no SRC. Se a   ���
���            �        �      �verba ja existir no SRC, sera substituida ���
���            �        �      �pelo valor informado em "Valores Extras". ���
���Natie       �18/04/05�077011�Efetua lancamentos sequenciais p/val.extra���
���            �        �      �com dt.pgto diferentes  (Prov)            ���
���Andreia     �14/06/05�075478�Ajuste para tratar os parametros "Filial  ���
���            �        �      �de" e "Filial Ate" na limpeza dos valores ���
���            �        �      �extras.                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
user Function csuM420
Local aSays		:=	{ }
Local aButtons	:= 	{ } //<== arrays locais de preferencia

Private cCadastro := OemToAnsi(STR0001) //"Gera��o Valores Extras"
Private nSavRec   := RecNO()
Private aCodpd    := {}
nOpca := 0
	
Pergunte("GPM420",.F.)
	
AADD(aSays,OemToAnsi(STR0002) )	//"Este programa gera para o movimento mensal os lan�amentos  "
AADD(aSays,OemToAnsi(STR0003) )	//"de valores extras ou limpara o arquivo SR1 (Valores Extras)"
AADD(aSays,OemToAnsi(STR0004) )	//"para processamento do proximo mes.                         "

AADD(aButtons, { 5,.T.,{|| Pergunte("GPM420",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| Gpm420Processs(),STR0005})  //"Gera��o Valores Extras"
Endif

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Funcao  �Gpm420Processs�Autor  �Microsiga           � Data �  06/14/05   ���
���������������������������������������������������������������������������͹��
���Desc.   �                                                                ���
���        �                                                                ���
���������������������������������������������������������������������������͹��
���Uso     � AP                                                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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

//�������������������������������������������������������������������Ŀ
//� Variaveis de Log                                                  �
//���������������������������������������������������������������������
Local 	aLog		:= {}				//-- Log de Ocorrencias 	
Local 	aLogTitle 	:= {}
Local 	bMakeLog	:= { || NIL }


//�������������������������������������������������������������������Ŀ
//� mv_par01  - Deseja Fazer  1-Gera��o    2-Limpeza                  �
//� mv_par02  - Processar por 1-Matricula  2-C.Custo                  �
//� mv_par03  - Filial De                                             �
//� mv_par04  - Filial Ate                                            �
//� mv_par05  - Centro de Custo De                                    �
//� mv_par06  - Centro de Custo Ate                                   �   
//� mv_par07  - Matricula De                                          �
//� mv_par08  - Matricula Ate                                         �
//� mv_par09  - Informe o Verba Desconto                              �
//� mv_par10  - Data de Pagamento                                     �
//� mv_par11  - Informe a Verba Provento                              �
//���������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Carregando as Perguntas                                      �
//����������������������������������������������������������������
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


//��������������������������������������������������������������Ŀ
//� Procura primeiro funcionario                                 �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento	                                 �
//����������������������������������������������������������������
ProcRegua(SRA->(RECCOUNT()))

While SRA->(!Eof())
	//��������������������������������������������������������������Ŀ
	//� Move Regua Processamento	                                 �
	//����������������������������������������������������������������
	IncProc(STR0013) //"Gera��o Valores Extras"
	
	If SRA->RA_FILIAL # cFilAnte
		If !FP_CODFOL(@aCodFol)
			Return Nil
		Endif
		cFilAnte := SRA->RA_FILIAL
	Endif

	//��������������������������������������������������������������Ŀ
	//� Consiste o De / Ate  nOrdem = 1-Matricula / 2-Centro Custo   �
	//����������������������������������������������������������������
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
			//��������������������������������������������������������������Ŀ
			//� Monta a Matriz Do Funcionario Por Verba                      �
			//����������������������������������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� Grava a Verba no SRC                                         �
		//����������������������������������������������������������������
		nSeq  		:= 0

		//��������������������������������������������������������������Ŀ
		//�                                                              �
		//����������������������������������������������������������������
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
					//��������������������������������������������������������������Ŀ
					//� Verifica se for ref.a  mesma data,  ou seja, ao mesmo lanca- �
					//� mento,e sobrepoe o valor;senao gera novo lancamento c/nova se�
					//� quencia (de acordo com qtde de seq.permitida de cada verba)  �
					//����������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Limpa Arquivo SR1 - Gravando Ultimo Arredondamento.          �
		//����������������������������������������������������������������
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
	IF ( MsgNoYes( OemToAnsi( STR0015 )  , OemToAnsi( STR0016 ) ) ) //-- "Ocorreram inconsist�ncias durante o processo"## "Aten��o "
		bMakeLog := { || fMakeLog( { aLog } ,  aLogTitle  , NIL , .T. , FunName() , NIL , "G" , "L" , NIL , NIL ) }
		MsAguarde( bMakeLog , OemToAnsi( STR0018 ) ) 				//--"Log de Ocorrencias - Valores Extras "
	EndIF
EndIF


//��������������������������������������������������������������Ŀ
//� Recupera a Integridade dos dados                             �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
dbGoTo( nSavRec )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �fGvSRC    �Autor  �Microsiga           � Data �  05/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua gravacao dos valores extras                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGvSRC( aVerbaAux )

Local N			:= 1
Local nProv 	:= 0
Local nDesc 	:= 0
Local lGravaprov:= .F. 

Begin Transaction

	/*
	��������������������������������������������������������������Ŀ
	�Deleta Itens Anterior para Gravar novos dados p/gravar        �
	����������������������������������������������������������������*/
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �fDelExtrr �Autor  �Microsiga           � Data �  05/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a delecao dos lancamentos anteriores para efetuar    ���
���          �a gravacao dos novos lancamentos                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
