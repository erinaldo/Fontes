#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function TesPFCSU()
Return u_CSGPEM10( { .T., '05', '01' }  )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSGPEM10  � Autor � Isamu Kawakami     � Data �  25/05/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Preenche Programacao de Ferias via Schedule                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU  .                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSGPEM10(aParam)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


If aParam == Nil
	_lJob := .F.
Else
	_lJob := aParam[1]
	_cEmp := aParam[2]
	_cFil := aParam[3]
//	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil MODULO "GPE"
EndIf


Private cPerg       := PADR("CSGPEM10",LEN(SX1->X1_GRUPO))
Private oGeraTxt
Private oHTML
Private cMsg

// Verifica se a rotina roda em JOB/MENU

	AjustaSX1()

// Sen�o For Job
If !_lJob // == Nil
	//���������������������������������������������������������������������Ŀ
	//� Montagem da tela de processamento.                                  �
	//�����������������������������������������������������������������������
	@ 200,1 TO 380,480 DIALOG oGeraTxt TITLE OemToAnsi("Programa��o de F�rias")
	@ 02,10 TO 080,290
	@ 10,018 Say " Este programa ira calcular a programa��o de f�rias, "
	@ 18,018 Say " conforme os parametros definidos  pelo usuario, com "
	@ 26,018 Say " os registros do arquivo de Funcion�rios (SRA).  "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt(_lJob)
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	
	Activate Dialog oGeraTxt Centered
	
Else
    //Prepare Environment Empresa _cEmp Filial _cFil Modulo "GPE"
	   OkGeraTxt(_lJob, _cEmp, _cFil)
	   
//    RESET ENVIRONMENT
EndIf

If _lJob
	MemoWrite("\razarios\progferias.txt",cMsg)
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  08/05/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkGeraTxt(_lJob, _cEmp, _cFil)

// Sen�o For Job
If !_lJob
	//���������������������������������������������������������������������Ŀ
	//� Inicializa a regua de processamento                                 �
	//�����������������������������������������������������������������������
	Processa({|| RunCont(_lJob) },"Processando...")
Else
	RunCont(_lJob, _cEmp, _cFil)
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  08/05/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont(_lJob, _cEmp, _cFil)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local dData := If(Type("dDataBase")=="U",Date(),dDataBase)
Private lOk := .F.

// Sen�o For Job
//If !_lJob
	//����������������������������������������������������������������Ŀ
	//� mv_par01 - Cod. Funcionario De ?                               �
	//� mv_par02 - Cod. Funcionario Ate?                               �
	//������������������������������������������������������������������
	//AjustaSX1()
	
	//If !Pergunte("CSGPEM10",.T.)
	//	Return
	//EndIf
	
//Else

//Cria novo processo de email - OS 1793/11
oProcess := TWFProcess():New( "PRGFER", "Programacao de Ferias" )
oProcess:NewTask( "PRGFER01", "\WORKFLOW\HTML\EMGPE001.HTM" )

oHTML:= oProcess:oHTML
/*
If _lJob
	// Seta Ambiente
	RpcSetEnv(_cEmp, _cFil,, 'GPE' )
EndIf
*/
// Fecha Tabela Funcion�rios
If Select("QRYSRA") > 0
	dbSelectArea("QRYSRA")
	dbCloseArea()
EndIf

// Selec��o Registros Funcion�rios
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC "
cQuery += " FROM "+RetSqlName("SRA")+ " SRA "
cQuery += " WHERE RA_SITFOLH = ' ' AND "

// Sen�o For Job
If !_lJob	// _lJob == Nil
	cQuery += "      RA_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  AND "
	cQuery += "      RA_MAT >= '"+mv_par03+"' And RA_MAT <= '"+mv_par04+"' AND "
EndIf

cQuery += "      D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY RA_FILIAL, RA_MAT "

cQuery   := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"QRYSRA",.F.,.T.)

dbSelectArea("QRYSRA")
ProcRegua(RecCount()) // Numero de registros a processar
dbGotop()

// Se N�o Tiver Funcion�rio para C�lculo da Folha
IF QRYSRA->(EOF())
	dbSelectArea("QRYSRA")
	dbCloseArea()
	
	// Sen�o For Job
	If !_lJob
		MsgAlert("N�o Existem Funcion�rios Para C�lculo da Folha.","Atencao!")
	Else
		ConOut("Atencao - Nao Existem Funcionarios Para Calculo da Folha.")
		cMsg := "Atencao - Nao Existem Funcionarios Para Calculo da Folha."
	EndIf
	Return
EndIf

// Inicia Transa��o
Begin Transaction

While !EOF()
	
	// Sen�o For Job
	If !_lJob
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		IncProc()
	EndIf
	
	
	dbSelectArea("SRF")
	dbSetOrder(1)
	If dbSeek(xFilial("SRF", QRYSRA->RA_FILIAL)+QRYSRA->RA_MAT)
		If !Empty(SRF->RF_DATAINI)
			dbSelectArea("QRYSRA")
			dbSkip()
			Loop
		EndIf
	EndIf
	
	_dDtBase := SRF->RF_DATABAS
	
	// 1o. Periodo (Aquisitivo)
	_dDtAqui1 := _dDtBase
	
	_dDtAqui2 := fCalcFimAq(_dDtAqui1)
	
	// 2o. Periodo (Concessivo)
	_dDtConc1 := _dDtAqui2+1
	_dDtConc2 := fCalcFimAq(_dDtConc1)
	
	// Programa��o 1o. Per�odo
	_dIniVenc := _dDtConc2 - 60   // 60 dias do Final Periodo Concessivo
	
	If dData < _dIniVenc
		dbSelectArea("QRYSRA")
		dbSkip()
		Loop
	EndIf
	
	_dIniGozo := _dDtConc2 - 45  // 45 dias do Final Periodo Concessivo
	
	_dIniGozo := Ctod(STRZERO(Day(_dIniGozo),2)+"/"+Strzero(Month(_dIniGozo),2)+"/"+Str(Year(_dIniGozo),4),"ddmmyy")
	
	// Desloca Data para pr�xima 2a. feira
	While Dow(_dIniGozo) <> 2 // 1- Domingo, 2- Segunda-Feira, ..., 7-S�bado
		_dIniGozo += 1
	EndDo
	
	cMesDia := Subs(Dtos(_dIniGozo),5)
	
	// Verifica se a Data � Feriado
	cQuery1 := "SELECT * FROM "+RETSQLNAME('SP3')+ " "
	cQuery1 += "WHERE SUBSTRING(P3_DATA,5,4) = "+cMesDia+" "
	cQuery1 += "AND "+RETSQLNAME("SP3")+".D_E_L_E_T_ <> '*' "
	
	If Select("TRBSP3") > 0
		dbSelectArea("TRBSP3")
		dbCloseArea()
	Endif
	
	cQuery1 := ChangeQuery(cQuery1)
	TcQuery cQuery1 New Alias "TRBSP3"
	
	dbSelectArea("TRBSP3")
	dbGotop()
	
	
	While !TrbSp3->(Eof())
		If !(Empty(TrbSp3->P3_Data))
			_dIniGozo += 1
		Endif
		TrbSp3->(dbSkip())
	EndDo
	
	// Calcula datas Inicio, Fim e Retorno de F�rias
	_dIniFer := _dIniGozo
	_dRetFer := _dIniGozo + 19 	// 30 dias
	_dFimFer := _dRetFer
	
	// Inclui Programa��o de F�rias
	dbSelectArea("SRF")
	dbSetOrder(1)
	If dbSeek(xFilial("SRF", QRYSRA->RA_FILIAL)+QRYSRA->RA_MAT)
		RecLock("SRF",.F.)
	Else
		RecLock("SRF",.T.)
		SRF->RF_FILIAL  := xFilial("SRF", QRYSRA->RA_FILIAL)
		SRF->RF_MAT 	:= QRYSRA->RA_MAT
		SRF->RF_DATABAS	:= _dDtBase
	Endif
	SRF->RF_TEMABPE := "S"
	SRF->RF_DFEPRO1 := 20 
	SRF->RF_DABPRO1 := 10
	SRF->RF_DATAINI := _dIniGozo
	MsUnLock()
	// Fim da Inclus�o de F�rias

//���������������������������������������������������������������������Ŀ
//� Carrega array para enviar e-mail - OS 1793/11                       �
//�����������������������������������������������������������������������
	aadd((oHTML:ValByName("it.mat")),QRYSRA->RA_MAT)
	aadd((oHTML:ValByName("it.func")),QRYSRA->RA_NOME)
	aadd((oHTML:ValByName("it.depto")),Alltrim(QRYSRA->RA_CC))
	aadd((oHTML:ValByName("it.descc")),Posicione("CTT",1,xFilial("CTT")+QRYSRA->RA_CC,"CTT_DESC01"))
	aadd((oHTML:ValByName("it.paqini")),_dDtBase)
	aadd((oHTML:ValByName("it.paqfim")),_dDtAqui2)
	aadd((oHTML:ValByName("it.dtsaida")),_dIniGozo)
	aadd((oHTML:ValByName("it.dtferias")),20)
	aadd((oHTML:ValByName("it.dtabono")),10)

	// Flag de Inclus�o
	lOk := .T.
	
	dbSelectArea("QRYSRA")
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� Envia e-mail com informacoes das ferias programadas - OS 1793/11    �
//�����������������������������������������������������������������������
//Informo os dados do e-mail:
oProcess:cTo 		:= GetMV("MV_MAILGPE")  
oProcess:cSubject	:= "Preenchimento da Programa��o de F�rias"
	
//Inicio o Processo, enviando o e-mail.
oProcess:Start()


If lOk
	// Sen�o For Job
	If !_lJob
		ApMsgInfo("Inclus�o Programa��o de F�rias Finalizada!","Aten��o!")
	Else
		ConOut("Aten��o - Inclusao Programacao de Ferias Finalizada!")
		cMsg := "Aten��o - Inclusao Programacao de Ferias Finalizada!"
	EndIf
Else
	// Sen�o For Job
	If !_lJob
		ApMsgInfo("N�o Foram Incluidas Programa��es de F�rias!","Aten��o!")
	Else
		ConOut("Aten��o - Nao Foram Incluidas Programacoes de Ferias!")
		cMsg := "Aten��o - Nao Foram Incluidas Programacoes de Ferias!"
	EndIf
EndIf

// T�rmino Transa��o
End Transaction
// Fim Funcion�rios
/*
If !_lJob	// _lJob == Nil
	// n�o faz nada
Else
	RpcClearEnv()
EndIf
*/
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Nereu Humberto Jr     � Data �16.09.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSx1


Local aRegs := {}


aAdd(aRegs,{cPerg,'01','Filial De             ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'02','Filial Ate            ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'03','Matricula De          ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})
aAdd(aRegs,{cPerg,'04','Matricula Ate         ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})

ValidPerg(aRegs,cPerg)

Return
