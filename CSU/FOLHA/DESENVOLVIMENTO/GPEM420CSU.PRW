#include "PROTHEUS.ch"
//#INCLUDE "GPEM420.CH"
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
���Natie       �29/09/06�105412�Nao permite a geracao de vlrs extras p/fun���
���            �        �      �cionario que nao possui lancamento        ���
���Ricardo D.  �27/10/06�106047�Ajuste na gravacao para nao gerar erro por���
���            �        �      �gravacao de registro com chave unica.     ���
���Natie       �06/12/06�105412�Inclusao de aviso                         ���
���Natie       �18/04/07�091776�Ajuste no lancamento de vlrs.extras qdo ja���
���            �        �      �existem lactos no SRC                     ���
���            �        �      �nao serao mais consideradas as verbas pre ���
���            �        �      �existentes p/geracao da contra-partida    ���
���Ricardo D.  �18/05/07�126372�Ajuste na rotina de limpeza de valores ex-���
���            �        �      �tras para que nao ocorra erro durante o   ���
���            �        �      �processamento.                            ���
���Alexandre   �15/10/07�130131�Cria��o do array atipo para dinamizar a   ���
���Conselvan   �        �      �grava��o do tipo da verba conforme seu    ���
���            �        �      �cadastro.                                 ���
���Renata E.   �25/08/08�151437�Incluido log de ocorrencias qdo funciona- ���
���            �        �      �rio possuir apenas uma verba de base nos  ���
���            �        �      �cadastro dos valores extras. Nestes casos ���
���            �        �      �a verba nao sera gerada nos lancamentos   ���    
���            �        �      �mensais.                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function GPEM420CSU
Local aSays		:=	{ }
Local aButtons	:= 	{ } //<== arrays locais de preferencia

Private cCadastro := "Gera��o Valores Extras"
Private nSavRec   := RecNO()
Private cPerg     := PADR("CSU420",LEN(SX1->X1_GRUPO))
nOpca := 0                                 

PutSX1(cPerg,"01","Deseja fazer ?        ","","","mv_ch1 ","N",01,0,2,"C","          ","   ","","","mv_par01","Geracao  ","","","","Limpeza        ","","","","","","","","","","","",{"Selecione o tipo de Opera��o que deseja" ,"efetuar: Gera��o ou Limpeza dos Valores ", "Extras."},{},{})
PutSX1(cPerg,"02","Processar em ordem ?  ","","","mv_ch2 ","N",01,0,1,"C","          ","   ","","","mv_par02","Matricula","","","","Centro de Custo","","","","","","","","","","","",{"Informe a Ordem que deseja efetuar o"    ,"Processamento."},{},{})
PutSX1(cPerg,"03","Filial de ?           ","","","mv_ch3 ","C",02,0,0,"G","          ","XM0","","","mv_par03","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"04","Filial at� ?          ","","","mv_ch4 ","C",02,0,0,"G","naovazio  ","XM0","","","mv_par04","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"05","Centro de custo de ?  ","","","mv_ch5 ","C",20,0,0,"G","          ","CTT","","","mv_par05","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"06","Centro de custo at� ? ","","","mv_ch6 ","C",20,0,0,"G","naovazio  ","CTT","","","mv_par06","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"07","Matr�cula de ?        ","","","mv_ch7 ","C",06,0,0,"G","          ","SRA","","","mv_par07","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"08","Matr�cula at� ?       ","","","mv_ch8 ","C",06,0,0,"G","naovazio  ","SRA","","","mv_par08","         ","","","","               ","","","","","","","","","","","",{"",""},{},{})
PutSX1(cPerg,"09","Verba de desconto     ","","","mv_ch9 ","C",03,0,0,"G","naovazio  ","SRV","","","mv_par09","         ","","","","               ","","","","","","","","","","","",{"Informe ou Selecione a Verba que ser� ","utilizada para efetuar o Desconto."},{},{})
PutSX1(cPerg,"10","Data de pagamento ?   ","","","mv_cha ","D",08,0,0,"G","naovazio  ","   ","","","mv_par10","         ","","","","               ","","","","","","","","","","","",{"Informe a Data que ser� utilizada para","gerar o Pagamento dos Valores Extras."},{},{})
PutSX1(cPerg,"11","Verba de provento ?   ","","","mv_chb ","C",03,0,0,"G","naovazio  ","SRV","","","mv_par11","         ","","","","               ","","","","","","","","","","","",{"Informe ou Selecione a Verba que ser� ","utilizada para efetuar o Pagamento."},{},{})
PutSX1(cPerg,"12","Semana de?            ","","","mv_chc ","C",02,0,0,"G","          ","   ","","","mv_par12","         ","","","","               ","","","","","","","","","","","",{"Informe a semana inicial para considerar","no fechamento dos valores extras."},{},{})
PutSX1(cPerg,"13","Semana at�?           ","","","mv_chd ","C",02,0,0,"G","naovazio  ","   ","","","mv_par13","         ","","","","               ","","","","","","","","","","","",{"Informe a semana final para considerar  ","no fechamento dos valores extras."},{},{})
	
Pergunte(cPerg,.F.)
	
AADD(aSays,"Este programa gera para o movimento mensal os lan�amentos  " )
AADD(aSays,"de valores extras ou limpara o arquivo SR1 (Valores Extras)" )
AADD(aSays,"para processamento do proximo mes.                         " )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| GPM420Processa(),"Gera��o Valores Extras"})
Endif

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Funcao  �Gpm420Processa�Autor  �Microsiga           � Data �  06/14/05   ���
���������������������������������������������������������������������������͹��
���Desc.   �                                                                ���
���        �                                                                ���
���������������������������������������������������������������������������͹��
���Uso     � AP                                                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Gpm420Processa()

Local aCodFol 	:= 	{}
Local aCodpd 	:= 	{}
Local aHoras 	:= 	{}
Local aValor 	:= 	{}
Local aTipo 	:=  {}
Local nValor 	:=	0
Local dDtPgt 	:= 	CtOD("  /  /  ")
Local M   
Local cQtdLanc	:= ""
Local nSeq		:= 0 
Local nPos 		:= 0 
Local nPos1		:= 0
Local nQtdLanc	:= 0 
Local aVerbaAux	:= {} 
Local cTipo 	:= "" 

//�������������������������������������������������������������������Ŀ
//� Variaveis de Log                                                  �
//���������������������������������������������������������������������
Local 	aLogTitle 	:= {}
Local 	bMakeLog	:= { || NIL }
Private	aLog		:= {}				//-- Log de Ocorrencias 	

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
//� mv_par12  - Semana de                                             �
//� mv_par13  - Semana ate                                            �
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
cSemDe		:=  mv_par12
cSemAte     :=  mv_par13


//��������������������������������������������������������������Ŀ
//� Procura primeiro funcionario                                 �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 1 )
	dbSeek( cFilDe + cMatDe, .T. )
Elseif nOrdem == 2
	dbSetOrder( 2 )
	dbSeek( cFilDe + cCcDe + cMatDe, .T. )
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
	IncProc("Gera��o Valores Extras") //
	
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
		dbSetOrder(1)
		dbGoTop()
		SR1->( dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		aCodpd 	:= {}
		aHoras 	:= {}
		aValor 	:= {}                      
		aCC	   	:= {}	
		aTipo 	:= {} //#
		While SR1->(!Eof()) .And. SR1->R1_FILIAL + SR1->R1_MAT == SRA->RA_FILIAL + SRA->RA_MAT
    		If SR1->R1_SEMANA >= cSemDe .and. SR1->R1_SEMANA <= cSemAte .and. SRA->RA_SITFOLH <> "D"
				//��������������������������������������������������������������Ŀ
				//� Monta a Matriz Do Funcionario Por Verba                      �
				//����������������������������������������������������������������
				M  := Ascan( aCodpd , SR1->R1_PD )
				nX := Ascan( aCC    , SR1->R1_CC )
				If M > 0 .And. nX > 0
					aHoras[M] += SR1->R1_HORAS
					aValor[M] += SR1->R1_VALOR
					aCC[M]    := SR1->R1_CC
					aTipo[M]  := SR1->R1_TIPO1
				Else
					Aadd( aCodpd , SR1->R1_PD )
					Aadd( aHoras , SR1->R1_HORAS )
					Aadd( aValor , SR1->R1_VALOR )
					Aadd( aCC    , SR1->R1_CC )
					Aadd( aTipo  , SR1->R1_TIPO1 )
				Endif
			Endif			
				SR1->( dbSkip() )
				
		Enddo 
		//��������������������������������������������������������������Ŀ
		//� N�o ha necessidade de prosseguir processamento se n�o houver �
		//� lancamento no SR1 p/ser efetuado                             �
		//����������������������������������������������������������������
		If Len(aHoras) + Len(aValor) = 0 
			SRA->(dbSkip())
			Loop 
		Endif 

		//��������������������������������������������������������������Ŀ
		//�Seleciono as verbas do SRC que possuem  lancamentos no RC1    �
		//����������������������������������������������������������������
		aVerbaExt	:= {}
		dbSelectArea("SRC")
		If SRC->( dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ) )
			While !SRC->(eof()) .and. ( SRA->RA_FILIAL + SRA->RA_MAT  ) == SRC->( RC_FILIAL+ RC_MAT  )
				If SRA->RA_FILIAL + SRA->RA_MAT == SRC->( RC_FILIAL+ RC_MAT )
			
					cTipo	:= PosSrv(SRC->RC_PD, SRA->RA_FILIAL,"RV_TIPOCOD")	

					If ( nPos:= ascan(aCodpd, {|x| x == SRC->RC_PD } )    ) > 0  .or. ;
					    ( cCodDes == SRC->RC_PD .or. cCodProv == SRC->RC_PD) 
					   
						AADD(aVerbaExt,{SRC->RC_FILIAL ,SRC->RC_MAT     ,SRC->RC_DATA  , SRC->RC_PD   , ;
				    	                SRC->RC_CC     , SRC->RC_SEMANA ,SRC->RC_TIPO1 , SRC->RC_HORAS, ; 
				       		            SRC->RC_VALOR  , SRC->RC_PARCELA,SRC->RC_TIPO2 , cTipo        , ;
										If(!(SRC->RC_TIPO2$"I*C") ,.F., If( Empty(SRC->RC_DATA), .F. , .T.  )  ) } )
				       		            
					Endif 
				Endif	
				SRC->( DBSKIP() )
			EndDo
 	 	EndIf 

		aVerbaAux:= aClone(aVerbaExt)
		//��������������������������������������������������������������Ŀ
		//�Acrescento as verbas do RC1                                   �
		//����������������������������������������������������������������
		For M := 1 To Len(aCodpd)
		
			nPos := Ascan(aVerbaAux, {|x| x[1]+x[2]+x[4]+x[5]== SRA->RA_FILIAL + SRA->RA_MAT + aCodpd[M]+aCC[M] })
			
			cTipo	:= PosSrv(aCodpd[M], SRA->RA_FILIAL,"RV_TIPOCOD")
			
			If nPos > 0
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
					aVerbaAux[nPos1,13]	:= .T.
				Else  // #
					AADD(aVerbaAux,{SRA->RA_FILIAL , SRA->RA_MAT    ,dDataPag  , aCodpd[M]    	,;
			                         aCC[M]         ," "            ,aTipo[M]  , aHoras[M]     	,;  
			                         aValor[M]      ,0              ,"G"       , cTipo   	    , .T.} ) 
				Endif 
			Else // #
				AADD(aVerbaAux,{SRA->RA_FILIAL , SRA->RA_MAT    ,dDataPag  , aCodpd[M]     	,;
                                aCC[M]         ," "             ,aTipo[M]  , aHoras[M]      	,; 
	                            aValor[M]      ,0               ,"G"       , cTipo             ,.T.} ) 
			Endif
		Next

	/*	���������������������������������������������������������������������������Ŀ
		�Verifica se funcionario tem somente uma verba de base nos valores extras   �
		�����������������������������������������������������������������������������*/
		If len(aVerbaAux) == 1 .and. aVerbaAux[1,12] == "3"
		//-- Fil Matric Verba C.C.      Descricao
		//-- 99  999999  999  999999999 Quantidade de lancamentos para esta verba foi excedida.
			IF Empty( aLog ) 
				aAdd( aLog , "Geracao Valores Extras" )
			EndIf
			aAdd( aLog , aVerbaAux[1,01] + "  " + aVerbaAux[1,02] + " " + aVerbaAux[1,04] + "   " + aVerbaAux[1,05] + " - " + "--Funcionario possui apenas uma verba de base nos valores extras."  )
	     Else
			fGravaSRC(aVerbaAux )
		 EndIf
	
	Else
		//��������������������������������������������������������������Ŀ
		//� Limpa Arquivo SR1 - Gravando Ultimo Arredondamento.          �
		//����������������������������������������������������������������
		dbSelectArea( "SR1" )
		If SR1->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
			nCnt := 0
			While SR1->(!Eof()) .And. SR1->R1_FILIAL + SR1->R1_MAT == SRA->RA_FILIAL + SRA->RA_MAT 
				If SR1->R1_SEMANA >= cSemDe .and. SR1->R1_SEMANA <= cSemAte
					If SR1->R1_PD == aCodFol[180,1]
						nValor := SR1->R1_VALOR
						dDtPgt := SR1->R1_DATA			
					Endif
					RecLock( "SR1",.F.,.T. )
					dbDelete()
					nCnt ++
					MsUnlock()
				Endif
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
	
	dbSelectArea( "SRA" )
	SRA->(dbSkip())
Enddo

IF !Empty( aLog )
	IF ( MsgNoYes( "Ocorreram inconsist�ncias durante o processo" , "Aten��o" ) )
		bMakeLog := { || fMakeLog( { aLog } ,  aLogTitle  , NIL      , .T., FunName() , NIL , "G" , "L" , NIL , .F. ) }
		MsAguarde( bMakeLog , "-- Log de Ocorrencias - Valores Extras " )
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
���Funcao    �fGravaSRC �Autor  �Microsiga           � Data �  05/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua gravacao dos valores extras                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGravaSRC( aVerbaAux )

Local N			:= 1
Local nProv 	:= 0
Local nDesc 	:= 0
Local nSeq		:= 0 
Local nSeq_aux	:= 0 
Local nQtdLanc	:= 0 
Local nVal		:= 0 
Local cCod		:= ""
Local cCodAnt	:= aVerbaAux[1,04]
Local cCCAnt	:= aVerbaAux[1,05]
Local cQtdLanc	:= ""
Local lGravaprov:= .F. 
Local aCPartida	:= {} 					//-- Array contendo os lancamentos de contra-partida dos valore extras

Begin Transaction

	/*
	��������������������������������������������������������������Ŀ
	�Deleta Itens Anterior para Gravar novos dados                 �
	����������������������������������������������������������������*/
	If Len(aVerbaAux) > 0
		fDelExtra( aVerbaAux )
	Endif
                   
	aSort( aVerbaAux,,,{ |x,y| x[1]+ x[2]+ x[4]+ x[5] < y[1]+ y[2]+ y[4]+ y[5] } ) 				//-- Filial +Matric+Verba+CC 
	
	/*
	��������������������������������������������������������������Ŀ
	�Lanca a verba de valores extras                               �
	����������������������������������������������������������������*/

	For N:= 1 to Len(aVerbaAux)
		/*
		��������������������������������������������������������������Ŀ
		�Verifica qtde de lactos possiveis para a verba                �
		����������������������������������������������������������������*/
		fLancVerba(aVerbaAux[N,04], @nQtdLanc )
		
		/*
		��������������������������������������������������������������Ŀ
		�Verifica qtde de lactos existentes no SRC p/gerar sequencia   �
		����������������������������������������������������������������*/ 	
		nSeq_aux	:= 0 
		Aeval( aVerbaAux,{ |x|  nSeq_aux +=If(x[1]+x[2]+x[4]+x[5] == SRA->RA_FILIAL + SRA->RA_MAT + aVerbaAux[N,04] + aVerbaAux[N,05] .and. ;
		                                          ! x[13] .and. ; 
		                                          !( dtos(x[3]) = dtos(aVerbaAux[N,03] ) ) ,1  ,0 )  }  ) 	
		/*
		��������������������������������������������������������������Ŀ
		�Verifica se tem verba tp informada para seguir a sequencia    �
		����������������������������������������������������������������*/
		If aVerbaAux[N,04] + aVerbaAux[N,05] <> cCodAnt + cCCAnt  .and. aVerbaAux[N,13]
			nSeq	:= 0
			cCodAnt	:= aVerbaAux[N,04]
			cCcAnt 	:= aVerbaAux[N,05]
		Endif 

		If nSeq_aux > 0
			nSeq:= nSeq_aux + 1
		Else 	
			nSeq++
		Endif

		If nSeq > nQtdLanc
			//-- Fil Matric Verba C.C.                   Descricao 
			//--  99 999999 999   99999999999999999999 - Quantidade de lancamentos para esta verba foi excedida.
			IF Empty( aLog ) 
				aAdd( aLog , "Geracao Valores Extras" ) 
			EndIF
			aAdd( aLog , aVerbaAux[N,01]+ "  " + aVerbaAux[N,02] + " "+ aVerbaAux[N,04] + "   "+ aVerbaAux[N,05] + " - " + "--Excedeu o numero de lancamentos permitido para esta verba."  )
 		Else 
			/*
			��������������������������������������������������������������Ŀ
			�so gero as verbas de partida                                  �
			����������������������������������������������������������������*/
  			If aVerbaAux[N,13]
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
				SRC->RC_SEQ    := strzero(nSeq	,1)
				SRC->( MsUnlock() )
				/*
				��������������������������������������������������������������Ŀ
				�Soma as verbas com  mesma verba s para a verba e c.c para     �
				�lancar uma unica contra partida                               �				
				����������������������������������������������������������������*/
				If aVerbaAux[N,12] == "1"  .and.  !(aVerbaAux[N,11]$ "I*C") 
					If ( nPos:= ascan( aCPartida, {|x| x[3] == aVerbaAux[N,05] }  ) ) > 0   //-- C.C. 
						aCPartida[nPos,1] += aVerbaAux[N,09]          //--Valor 
					Else
						aadd(aCPartida, {aVerbaAux[N,09], 0 , aVerbaAux[N,05] ,aVerbaAux[N,03] }  )
					Endif 
				Elseif aVerbaAux[N,12] == "2"   .and.  !(aVerbaAux[N,11]$ "I*C")
					If ( nPos:= ascan( aCPartida, {|x| x[3] == aVerbaAux[N,05] }  ) ) > 0   //-- C.C.
						aCPartida[nPos,2] += aVerbaAux[N,09]
					Else
						aadd(aCPartida, { 0 , aVerbaAux[N,09],aVerbaAux[N,05], aVerbaAux[N,03] }  )
					Endif 
				Endif
				lGravaprov	:= .T.
			Endif	
		Endif 	
	Next N
	
	/*
	��������������������������������������������������������������Ŀ
	�Lanca a verba de contra-partida de valores extras             �
	����������������������������������������������������������������*/
	aSort( aCPartida ,,,{ |x,y|  x[3] <  y[3]  } ) 				//-- Verba + CC

	nSeq	:= 0
	cCodAnt	:= ""
	cCcAnt	:= If (!Empty(aCPartida),aCPartida[1,3],0) 
	
	For N:= 1 to Len( aCPartida )
		//-- Verifica se tem  valores
		If (aCPartida[N,1] > 0 .or. aCPartida[N,2] > 0  ) .And. !Empty(cCodDes) .And. !Empty(cCodProv) .and. lGravaProv
			If aCPartida[N,1] - aCPartida[N,2] > 0					//-- (cCodProv- cCodDes) 
				cCod := cCodDes
				nVal := aCPartida[N,1] - aCPartida[N,2]
			Else
				cCod := cCodProv
				nVal := (aCPartida[N,1] - aCPartida[N,2]) * (-1)
			Endif
			
			/*
			��������������������������������������������������������������Ŀ
			�Verifica qtde de lactos possiveis para a verba                �
			����������������������������������������������������������������*/
			fLancVerba( cCod , @nQtdLanc )
	
			/*
			��������������������������������������������������������������Ŀ
			�Verifica se tem verba tp informado para seguir a sequencia    �
			����������������������������������������������������������������*/
			If aCPartida[N,3] <> cCcAnt 
				nSeq	:= 0
				cCodAnt	:= cCod
				cCcAnt 	:= If(!Empty(aCPartida),aCPartida[N,3],0)
			Endif
		
			/*
			��������������������������������������������������������������Ŀ
			�Verifica qtde de lactos existentes no SRC p/gerar sequencia   �
			����������������������������������������������������������������*/ 	
			nSeq_aux	:= 	fQtdeLancSRC( cCod , aCPartida[N,4] )
 			If nSeq_aux > 0
				nSeq:= nSeq_aux + 1
			Else 	
				nSeq++
 			Endif
		
			If nSeq > nQtdLanc
				//-- Fil Matric Verba C.C.                   Descricao 
				//--  99 999999 999   99999999999999999999 - Quantidade de lancamentos para esta verba foi excedida.
				IF Empty( aLog ) 
					aAdd( aLog , "Geracao Valores Extras" )
				EndIF
				aAdd( aLog , SRA->( RA_FILIAL+ "  " + RA_MAT ) + " "+ cCod + "   "+aCPartida[N,3] + " - " + "--Excedeu o numero de lancamentos permitido para esta verba."  )
 	 		Else
				RecLocK("SRC",.T.)
				SRC->RC_FILIAL  := SRA->RA_FILIAL
				SRC->RC_MAT     := SRA->RA_MAT
				SRC->RC_DATA    := aCPartida[N,04]
				SRC->RC_PD      := cCod
				SRC->RC_CC      := aCPartida[N,3]
				SRC->RC_SEMANA  := " "
				SRC->RC_TIPO1   := "V"
				SRC->RC_HORAS   := 0.00
				SRC->RC_VALOR   := nVal
				SRC->RC_PARCELA := 0
				SRC->RC_TIPO2   := "G"
				SRC->RC_SEQ     := strzero(nSeq	,1) 
				MsUnlock()
			Endif 
		Endif
	Next N 
	
End Transaction 	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �fDelExtra �Autor  �Microsiga           � Data �  05/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a delecao dos lancamentos anteriores para efetuar    ���
���          �a gravacao dos novos lancamentos                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  fDelExtra( aVerbaAux ) 
Local 	n:= 1

For N:= 1 to Len(aVerbaAux) 
	SRC->( dbSeek( aVerbaAux[N,1] + aVerbaAux[N,2]+  aVerbaAux[N,4] )) //+ aVerbaAux[N,5]  ) ) 
	While !SRC->(eof()) .and. SRC->RC_PD = aVerbaAux[N,4] 
		If dtos( dDataPag ) == dtos(aVerbaAux[n,3]) .AND.;
		   dtos(SRC->RC_DATA) == dtos( dDataPag )
			RecLock( "SRC" , .F. , .F. ) 
			SRC->( dbDelete() ) 
			SRC->( MsUnLock() ) 
		Endif 	
		SRC->( DbSkip() )
	EndDo 
Next N
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEM420   �Autor  �Microsiga           � Data �  04/19/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fLancVerba(cCodVerba ,nQtdLanc ) 

Local cQtdLanc	:= PosSrv(cCodVerba,SRA->RA_FILIAL,"RV_QTDLANC" )

Return ( nQtdLanc := Val( IF( Empty( cQtdLanc ) , "1" , cQtdLanc  ) ) ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEM420   �Autor  �Microsiga           � Data �  04/19/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fQtdeLancSRC(cCod, dData  ) 

Local aAreaSRC	:= SRC->(GetArea())               
Local nSeq		:= 0 

If SRC->( dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cCod  ) ) 
	While !SRC->(eof()) .and. SRC->(RC_FILIAL+RC_MAT+RC_PD ) == SRA->(RA_FILIAL + RA_MAT) + cCod 
		If  !(dtos(SRC->RC_DATA) == dtos( dData )) 
			nSeq++ 
		Endif 	
		SRC->( DbSkip() )
	EndDo          
Endif 	
RestArea(aAreaSRC) 	

Return(nSeq)
