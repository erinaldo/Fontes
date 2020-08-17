#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWRCOM06  บ Autor ณ Fernando Lima	     บ Data ณ  03/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia workflow com pedido de compras a serem aprovados     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo da CSU  .                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function WRCOM06()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


PREPARE ENVIRONMENT EMPRESA "05" FILIAL "01" MODULO "COM"
Private cPerg
Private oGeraTxt
Private oHTML
Private cMsg
Private lNotEnv := .F.
RunCont()

If Select("TRBSC7") > 0
	dbSelectArea("TRBSC7")
	dbCloseArea()
EndIf

If Select("QRYSC7") > 0
	dbSelectArea("QRYSC7")
	dbCloseArea()
EndIf

RESET ENVIRONMENT

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  08/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunCont()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local dData := If(Type("dDataBase")=="U",Date(),dDataBase)
Private lOk := .F.

//Cria novo processo de email - OS 1793/11
///oProcess := TWFProcess():New( "WCOM06", "Pedidos a serem liberados" )
///oProcess:NewTask( "WCOM06", "C:\FONTE\HTML\RCOMR06.HTM" )

///oHTML:= oProcess:oHTML

// Selec็ใo Registros Pedidos

cQuery  := " SELECT DISTINCT C7_FILIAL, C7_NUM, A.CR_APROV, A.NIVEL, A.CR_USER USER1 "
cQuery  += " FROM "
cQuery  += " (SELECT C.CR_FILIAL, C.CR_NUM, C.CR_APROV, B.NIVEL, C.CR_USER "
cQuery  += "		FROM "
cQuery  += "		(SELECT MIN(CR_NIVEL) AS NIVEL, CR_NUM, CR_FILIAL "
cQuery  += "		FROM "+RetSqlName('SCR')+" "
cQuery  += "			WHERE CR_DATALIB = '' "
cQuery  += "			AND CR_TIPO = 'PC' "
cQuery  += "			AND SCR050.D_E_L_E_T_ = '' "
cQuery  += "			GROUP BY CR_NUM, CR_FILIAL) AS B "
cQuery  += "			INNER JOIN SCR050 AS C "
cQuery  += "		ON B.CR_FILIAL = C.CR_FILIAL "
cQuery  += "		AND B.CR_NUM = C.CR_NUM "
cQuery  += "		AND B.NIVEL = C.CR_NIVEL "
cQuery  += "		WHERE C.D_E_L_E_T_ = '') "
cQuery  += " AS A INNER JOIN "+RetSqlName('SC7')+" "
cQuery  += " ON A.CR_FILIAL = C7_FILIAL "
cQuery  += " AND A.CR_NUM = C7_NUM "
cQuery  += " WHERE C7_QUJE = 0 "
cQuery  += " AND C7_RESIDUO = ''  "
cQuery  += " AND C7_CONAPRO = 'B' "
cQuery  += " AND C7_QTDACLA = 0 "
cQuery  += " AND SC7050.D_E_L_E_T_ = '' "
cQuery  += " ORDER BY CR_APROV "

If Select("QRYSC7") > 0
	dbSelectArea("QRYSC7")
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"QRYSC7",.F.,.T.)

_gerou    := .F.
nLineSize := 80
nTabSize := 2
lWrap := .T.

While !EOF() 
		  
	_envmail := POSICIONE("SAK",2,xFILIAL("SAK")+QRYSC7->USER1,"AK_ENVMAIL")

	IF _envmail == 'N'
		dbSelectArea("QRYSC7")
		dbSkip()
		Loop
	endif
    
	_gerou    := .T.	
	//Cria novo processo de email - OS 1793/11
	oProcess := TWFProcess():New( "WCOM06", "Pedidos a serem liberados" )
	oProcess:NewTask( "WCOM06", "\WORKFLOW\HTML\RCOMR06.HTM" )
	
	oHTML:= oProcess:oHTML
	_cUser1   := QRYSC7->USER1
	
	While !eof() .and. QRYSC7->USER1 == _cUser1
		
		cQuery := " SELECT SUM(C7_TOTAL) TOTAL  "
		cQuery += " FROM "+RetSqlName('SC7')+" SC7 , "
		cQuery += " WHERE  SC7.C7_NUM = '"+QRYSC7->C7_NUM +"' "
		cQuery += " AND  SC7.D_E_L_E_T_ = ' ' "
		
		If Select("TRBSC7") > 0
			dbSelectArea("TRBSC7")
			dbCloseArea()
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"TRBSC7",.F.,.T.)
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		If !(dbSeek(QRYSC7->C7_FILIAL + QRYSC7->C7_NUM))
			dbSelectArea("QRYSC7")
			dbSkip()
			Loop
		EndIf

		nLines := MlCount(SC7->C7_XJUSTIF,nLineSize, nTabSize, lWrap)
		_Descr := ""
				
		For nCurrLine := 1 To nLines
			_Descr += Memoline( SC7->C7_XJUSTIF, nLineSize, nCurrline, nTabSize, lWrap )
		Next	

		dDtVenc := Condicao(TRBSC7->TOTAL, SC7->C7_COND,,SC7->C7_EMISSAO) 

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Carrega array para enviar e-mail - OS 1793/11                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		aadd((oHTML:ValByName("it.pedido")),QRYSC7->C7_NUM)
		aadd((oHTML:ValByName("it.emissao")),SC7->C7_EMISSAO)
		aadd((oHTML:ValByName("it.fornecedor")),Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ"))
		aadd((oHTML:ValByName("it.Venc")),dDtVenc[1][1])
		aadd((oHTML:ValByName("it.CC")),SC7->C7_CC,"CTT_DESC01")
		aadd((oHTML:ValByName("it.valor")),Transform(TRBSC7->TOTAL, "@E 999,999,999.99"))
		aadd((oHTML:ValByName("it.observacao")),_Descr)
		aadd((oHTML:ValByName("it.nivel")),QRYSC7->NIVEL)
		aadd((oHTML:ValByName("it.aprovador")),UsrFullName(QRYSC7->USER1))
		
		dbSelectArea("QRYSC7")
		dbSkip()
	enddo
	
	IF _gerou 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia e-mail com informacoes das ferias programadas - OS 1793/11    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//Informo os dados do e-mail:
	_email := usrretmail(_cUser1)
	//_email := "alexandre.souza@csu.com.br"
	oProcess:cTo 		:= _email   /////GetMV("MV_MAILGPE")
	oProcess:cSubject	:= "Pedidos a serem Liberados "
	
	//Inicio o Processo, enviando o e-mail.
	oProcess:Start()
	endif

_gerou    := .F.

EndDo


//End Transaction
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAjustaSX1 ณ Autor ณ Nereu Humberto Jr     ณ Data ณ16.09.2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria as perguntas necesarias para o programa                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                      ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSx1


Local aRegs := {}


aAdd(aRegs,{cPerg,'01','Filial De             ?','','','mv_ch1','C',02,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'02','Filial Ate            ?','','','mv_ch2','C',02,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0',''})
aAdd(aRegs,{cPerg,'03','Matricula De          ?','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})
aAdd(aRegs,{cPerg,'04','Matricula Ate         ?','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA',''})

ValidPerg(aRegs,cPerg)

Return
