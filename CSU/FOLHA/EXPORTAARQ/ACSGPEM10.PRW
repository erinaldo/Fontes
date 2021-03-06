#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function ATesPFCSU()
Return u_ACSGPEM10()

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
User Function ACSGPEM10()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"
Private cPerg
Private oGeraTxt
Private oHTML
Private cMsg
Private lNotEnv := .F.
RunCont()
RESET ENVIRONMENT


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
Static Function RunCont()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local dData := If(Type("dDataBase")=="U",Date(),dDataBase)
Private lOk := .F.

//Cria novo processo de email - OS 1793/11
oProcess := TWFProcess():New( "PRGFER", "Programacao de Ferias" )
oProcess:NewTask( "PRGFER01", "\WORKFLOW\HTML\EMGPE001.HTM" )

oHTML:= oProcess:oHTML

// Selec��o Registros Funcion�rios
cQuery := " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC "
cQuery += " FROM "+RetSqlName('SRA')+" "
cQuery += " WHERE RA_SITFOLH = ' ' AND "
cQuery += " D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY RA_FILIAL, RA_MAT "


dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"QRYSRA",.F.,.T.)

dbSelectArea("QRYSRA")
dbGotop()

//Inicia Transa��o
//Begin Transaction

While !EOF()
	
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
	
	//BY ISAMU OS 3663-13
	cQ := " SELECT RH_DBASEAT AS DATARET "
	cQ += " FROM "+RetSqlName('SRH')+" "
	cQ += " WHERE RH_FILIAL  = "+QRYSRA->RA_FILIAL+" "
	cQ += " AND RH_MAT = "+QRYSRA->RA_MAT+" "
	cQ += " AND RH_DATABAS = '"+Dtos(_dDtBase)+"' "
	cQ += " AND "+RetSqlName('SRH')+".D_E_L_E_T_ <> '*' "
	
	If Select("QrySrh") > 0
		QrySrh->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQ),"QRYSRH",.F.,.T.)
	
	If !(QrySrh->(Eof()))
		_dDtBase := Stod(QrySrh->DataRet)+1
	Endif
	
	
	//If Posicione("SRH",1,QRYSRA->RA_FILIAL+QRYSRA->RA_MAT+Dtos(_dDtBase),"RH_DATABAS")
	//   _dDtBase := Posicione("SRH",1,QRYSRA->RA_FILIAL+QRYSRA->RA_MAT+Dtos(_dDtBase),"RH_DBASEAT")+1
	//Endif
	
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
	
	lNotEnv := .T.
	
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

If !lNotEnv
	
	MemoWrite("\wfm\ferias\progferias.txt","N�o existe funcion�rio para programa��o de f�rias."+' - '+DtoS(Date())+'-'+Time())
	
	//Cria novo processo de email
	oProcess := TWFProcess():New( "PRGFER", "Programacao de Ferias" )
	oProcess:NewTask( "PRGFER02", "\WORKFLOW\HTML\EMGPE002.HTM" )
	oHTML:= oProcess:oHTML
	
EndIf
//���������������������������������������������������������������������Ŀ
//� Envia e-mail com informacoes das ferias programadas - OS 1793/11    �
//�����������������������������������������������������������������������
//Informo os dados do e-mail:
oProcess:cTo 		:= GetMV("MV_MAILGPE")
oProcess:cSubject	:= "Preenchimento da Programa��o de F�rias"

//Inicio o Processo, enviando o e-mail.
oProcess:Start()

//End Transaction
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
