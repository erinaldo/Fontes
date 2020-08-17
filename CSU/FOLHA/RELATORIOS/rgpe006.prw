#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGPE006   � Autor �Ricardo Duarte Costa� Data �  05/09/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Exportacao de arquivo texto dos funcionarios admitidos no  ���
���          � mes.                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � CSU CARDSYSTEMS                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RGPE006

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private _cPerg       := PADR("RGP006",LEN(SX1->X1_GRUPO))
Private oGeraTxt
Private aStru	:= {}
Private cString := "SRA"
Private aInfo	:= {}

// Carrega as perguntas.
fPerg()
Pergunte(_cPerg,.f.)
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 400,400 DIALOG oGeraTxt TITLE OemToAnsi("Funcionarios Admitidos no Mes")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Funcionarios                                                  "

@ 85,98 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 85,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 85,158 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  05/09/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������
//Close(oGeraTxt)

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  05/09/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

// Cria a estrutura e abre o arquivo temporario como TRB
aAdd(aStru,{"FILIAL"	,"C",02,0})
aAdd(aStru,{"DESCFIL"	,"C",15,0})
aAdd(aStru,{"MAT"		,"C",06,0})
aAdd(aStru,{"NOME"		,"C",50,0})
aAdd(aStru,{"ADMISSA"	,"C",08,0})
cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

// Carrega os parametros
dDataRef	:= mv_par01		//	Data de referencia
cFilde		:= mv_par02		//	Filial De
cFilAte		:= mv_par03		//	Filial Ate
cCcDe		:= mv_par04 	//	Centro de Custos de
cCcAte		:= mv_par05		//	Centro de Custos ate
cMatDe		:= mv_par06		//	Matricula De
cMatAte		:= mv_par07 	//	Matricula Ate
cSitFolha	:= mv_par08		//	Situacoes a imprimir
cCategoria	:= mv_par09		//	Categorias a imprimir
cCaminho	:= mv_par10		//	Caminho e nome do arquivo a exportar.

//Apaga Arquivo Gravado anteriormente
If File(alltrim(cCaminho))
	If !fErase(alltrim(cCaminho)) == 0
		MsgAlert('O arquivo '+AllTrim(cCaminho)+'esta em uso por outra estacao !!! Libere o arquivo antes de tentar novamente . ')
		return
	EndIf	
Endif

dbSelectArea("SRA")
dbSetOrder(1)
dbseek(cFilDe+cMatDe,.t.) // primeiro registro selecionado nos parametros
cFilAnt := SRA->RA_FILIAL
fInfo(@aInfo,SRA->RA_FILIAL)

ProcRegua(RecCount()) // Numero de registros a processar

While !EOF() .and. SRA->RA_FILIAL+SRA->RA_MAT <= cFilAte+cMatAte

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������
    IncProc()

	//���������������������������������������������������������������������Ŀ
	//� Filtra os parametros selecionados......                             �
	//�����������������������������������������������������������������������
	If	SRA->RA_FILIAL < cFilDe .or. SRA->RA_FILIAL > cFilAte .or. ;
		SRA->RA_CC < cCcDe .or. SRA->RA_CC > cCcAte .or. ;
		SRA->RA_MAT < cMatDe .or. SRA->RA_MAT > cMatAte .or. ;
		! SRA->RA_SITFOLH $cSitFolha .or. ! SRA->RA_CATFUNC $cCategoria .or. ;
		MESANO(dDataRef) <> MESANO(SRA->RA_ADMISSA)
		dbskip()
		loop
	Endif

	// Carrega os dados da filial
	If cFilAnt <> SRA->RA_FILIAL
		cFilAnt := SRA->RA_FILIAL
		fInfo(@aInfo,SRA->RA_FILIAL)
	endif
	
	// Alimenta arquivo temporario.
	reclock("TRB",.t.)
	TRB->FILIAL		:= SRA->RA_FILIAL
	TRB->DESCFIL	:= aInfo[1]
	TRB->MAT		:= SRA->RA_MAT
	TRB->NOME		:= SRA->RA_NOME
	TRB->ADMISSA	:= SUBSTR(DTOS(SRA->RA_ADMISSA),7,2)+SUBSTR(DTOS(SRA->RA_ADMISSA),5,2)+SUBSTR(DTOS(SRA->RA_ADMISSA),1,4)
	msunlock()

    dbselectarea("SRA")
    dbSkip()
EndDo

//Copia o arquivo com o nome e o caminho indicados.
dbselectarea("TRB")
copy to &(cCaminho) DELIMITED WITH ('"')

//close TRB
dbCloseArea("TRB")
fErase(cArqTrab)

Return

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �fPerg     � Autor �Ricardo Duarte Costa   � Data �26/08/2003�
�����������������������������������������������������������������������Ĵ
�Descri��o �Grava as Perguntas utilizadas no Programa no SX1            �
�������������������������������������������������������������������������*/
Static Function fPerg()

Local aRegs     := {}
/*
����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg �
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
aAdd(aRegs,{_CPERG,'01' ,'Data de Referencia ?',''				 ,''			 ,'mv_ch1','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'02' ,'Filial De          ?',''				 ,''			 ,'mv_ch2','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0','','',''})
aAdd(aRegs,{_CPERG,'03' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch3','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par03','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0','','',''})
aAdd(aRegs,{_CPERG,'04' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch4','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT','','',''})
aAdd(aRegs,{_CPERG,'05' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch5','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par05','               '  ,''		 ,''	 ,REPLICATE('Z',20) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT','','',''})
aAdd(aRegs,{_CPERG,'06' ,'Matricula De       ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA','','',''})
aAdd(aRegs,{_CPERG,'07' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch7','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par07','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA','','',''})
aAdd(aRegs,{_CPERG,'08' ,'Situa��es  a Impr. ?',''				 ,''			 ,'mv_ch8','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par08','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'09' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_ch9','C'  ,12     ,0      ,0     ,'G','fCategoria                      ','mv_par09','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'10' ,'Caminho do Arquivo ?',''				 ,''			 ,'mv_cha','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})

//��������������������������������������������������������������Ŀ
//� Carrega as Perguntas no SX1                                  �
//����������������������������������������������������������������
ValidPerg(aRegs,_CPERG)

Return NIL
