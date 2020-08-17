#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function TesPFCSU()
Return u_CSGPEM10( { .T., '05', '01' }  )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSGPEM10  º Autor ³ Isamu Kawakami     º Data ³  25/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Preenche Programacao de Ferias via Schedule                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da CSU  .                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSGPEM10(aParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


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

// Senão For Job
If !_lJob // == Nil
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,1 TO 380,480 DIALOG oGeraTxt TITLE OemToAnsi("Programação de Férias")
	@ 02,10 TO 080,290
	@ 10,018 Say " Este programa ira calcular a programação de férias, "
	@ 18,018 Say " conforme os parametros definidos  pelo usuario, com "
	@ 26,018 Say " os registros do arquivo de Funcionários (SRA).  "
	
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  08/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OkGeraTxt(_lJob, _cEmp, _cFil)

// Senão For Job
If !_lJob
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({|| RunCont(_lJob) },"Processando...")
Else
	RunCont(_lJob, _cEmp, _cFil)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  08/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunCont(_lJob, _cEmp, _cFil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local dData := If(Type("dDataBase")=="U",Date(),dDataBase)
Private lOk := .F.

// Senão For Job
//If !_lJob
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 - Cod. Funcionario De ?                               ³
	//³ mv_par02 - Cod. Funcionario Ate?                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
// Fecha Tabela Funcionários
If Select("QRYSRA") > 0
	dbSelectArea("QRYSRA")
	dbCloseArea()
EndIf

// Selecção Registros Funcionários
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC "
cQuery += " FROM "+RetSqlName("SRA")+ " SRA "
cQuery += " WHERE RA_SITFOLH = ' ' AND "

// Senão For Job
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

// Se Não Tiver Funcionário para Cálculo da Folha
IF QRYSRA->(EOF())
	dbSelectArea("QRYSRA")
	dbCloseArea()
	
	// Senão For Job
	If !_lJob
		MsgAlert("Não Existem Funcionários Para Cálculo da Folha.","Atencao!")
	Else
		ConOut("Atencao - Nao Existem Funcionarios Para Calculo da Folha.")
		cMsg := "Atencao - Nao Existem Funcionarios Para Calculo da Folha."
	EndIf
	Return
EndIf

// Inicia Transação
Begin Transaction

While !EOF()
	
	// Senão For Job
	If !_lJob
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	// Programação 1o. Período
	_dIniVenc := _dDtConc2 - 60   // 60 dias do Final Periodo Concessivo
	
	If dData < _dIniVenc
		dbSelectArea("QRYSRA")
		dbSkip()
		Loop
	EndIf
	
	_dIniGozo := _dDtConc2 - 45  // 45 dias do Final Periodo Concessivo
	
	_dIniGozo := Ctod(STRZERO(Day(_dIniGozo),2)+"/"+Strzero(Month(_dIniGozo),2)+"/"+Str(Year(_dIniGozo),4),"ddmmyy")
	
	// Desloca Data para próxima 2a. feira
	While Dow(_dIniGozo) <> 2 // 1- Domingo, 2- Segunda-Feira, ..., 7-Sábado
		_dIniGozo += 1
	EndDo
	
	cMesDia := Subs(Dtos(_dIniGozo),5)
	
	// Verifica se a Data é Feriado
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
	
	// Calcula datas Inicio, Fim e Retorno de Férias
	_dIniFer := _dIniGozo
	_dRetFer := _dIniGozo + 19 	// 30 dias
	_dFimFer := _dRetFer
	
	// Inclui Programação de Férias
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
	// Fim da Inclusão de Férias

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega array para enviar e-mail - OS 1793/11                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd((oHTML:ValByName("it.mat")),QRYSRA->RA_MAT)
	aadd((oHTML:ValByName("it.func")),QRYSRA->RA_NOME)
	aadd((oHTML:ValByName("it.depto")),Alltrim(QRYSRA->RA_CC))
	aadd((oHTML:ValByName("it.descc")),Posicione("CTT",1,xFilial("CTT")+QRYSRA->RA_CC,"CTT_DESC01"))
	aadd((oHTML:ValByName("it.paqini")),_dDtBase)
	aadd((oHTML:ValByName("it.paqfim")),_dDtAqui2)
	aadd((oHTML:ValByName("it.dtsaida")),_dIniGozo)
	aadd((oHTML:ValByName("it.dtferias")),20)
	aadd((oHTML:ValByName("it.dtabono")),10)

	// Flag de Inclusão
	lOk := .T.
	
	dbSelectArea("QRYSRA")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail com informacoes das ferias programadas - OS 1793/11    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Informo os dados do e-mail:
oProcess:cTo 		:= GetMV("MV_MAILGPE")  
oProcess:cSubject	:= "Preenchimento da Programação de Férias"
	
//Inicio o Processo, enviando o e-mail.
oProcess:Start()


If lOk
	// Senão For Job
	If !_lJob
		ApMsgInfo("Inclusão Programação de Férias Finalizada!","Atenção!")
	Else
		ConOut("Atenção - Inclusao Programacao de Ferias Finalizada!")
		cMsg := "Atenção - Inclusao Programacao de Ferias Finalizada!"
	EndIf
Else
	// Senão For Job
	If !_lJob
		ApMsgInfo("Não Foram Incluidas Programações de Férias!","Atenção!")
	Else
		ConOut("Atenção - Nao Foram Incluidas Programacoes de Ferias!")
		cMsg := "Atenção - Nao Foram Incluidas Programacoes de Ferias!"
	EndIf
EndIf

// Término Transação
End Transaction
// Fim Funcionários
/*
If !_lJob	// _lJob == Nil
	// não faz nada
Else
	RpcClearEnv()
EndIf
*/
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³16.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1


Local aRegs := {}


aAdd(aRegs,{cPerg,'01','Filial De             ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'02','Filial Ate            ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'03','Matricula De          ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})
aAdd(aRegs,{cPerg,'04','Matricula Ate         ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})

ValidPerg(aRegs,cPerg)

Return
