#Include "Rwmake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSGPER04  ºAutor  ³Silvano Franca      º Data ³  17/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera informacoes da folha de pagamento em formato         º±±
±±º          ³  Microsoft Excel.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Void                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CSGPER04()

Private cPerg := "SRCPD"                          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas na tabela SX1 caso não existam.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1(cPerg, "01","Filial De                     ","","","mv_ch1" 	,"C",02,0,0,"G",""											, "SM0","","","mv_par01"," "		," "," ","",""			,"","","","","","","","","","","",{"Filial inicial"			},{},{})
PutSx1(cPerg, "02","Filial Até                    ","","","mv_ch2" 	,"C",02,0,0,"G","NaoVazio"									, "SM0","","","mv_par02"," "		," "," ","",""			,"","","","","","","","","","","",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                  ","","","mv_ch3" 	,"C",06,0,0,"G",""  										, "SRA","","","mv_par03"," "		," "," ","",""			,"","","","","","","","","","","",{"Matrícula inicial"			},{},{})
PutSx1(cPerg, "04","Matricula até                 ","","","mv_ch4" 	,"C",06,0,0,"G","NaoVazio"									, "SRA","","","mv_par04"," "		," "," ","",""			,"","","","","","","","","","","",{"Matrícula final"			},{},{})
PutSx1(cPerg, "05","Centro de Custo de            ","","","mv_ch5" 	,"C",09,0,0,"G",""  										, "CTT","","","mv_par05"," "		," "," ","",""			,"","","","","","","","","","","",{"Centro de custo inicial"	},{},{})
PutSx1(cPerg, "06","Centro de Custo até           ","","","mv_ch6" 	,"C",09,0,0,"G","NaoVazio"									, "CTT","","","mv_par06"," "		," "," ","",""			,"","","","","","","","","","","",{"Centro de custo final"		},{},{})
PutSx1(cPerg, "07","Período						  ","","","mv_ch7"	,"N",01,0,0,"C",""											, ""   ,"","","mv_par07","Mensal"	," "," ","","Acumulado"	,"","","","","","","","","","","",{"Mensal ou acumulado"		},{},{})
PutSx1(cPerg, "08","Período de (AAAAMM)           ","","","mv_ch8" 	,"C",06,0,0,"G",""  	   									, ""   ,"","","mv_par08"," "		," "," ","",""			,"","","","","","","","","","","",{"Data inicial"				},{},{})
PutSx1(cPerg, "09","Período até (AAAAMM)          ","","","mv_ch9" 	,"C",06,0,0,"G",""											, ""   ,"","","mv_par09"," "		," "," ","",""			,"","","","","","","","","","","",{"Data final"				},{},{})
PutSx1(cPerg, "10","Verbas                        ","","","mv_chA" 	,"C",90,0,0,"G","fVerbas(NIL,MV_PAR10+MV_PAR11+MV_PAR12,30)", ""   ,"","","mv_par10"," "		," "," ","",""			,"","","","","","","","","","","",{"Eventos a considerar"		},{},{})
PutSx1(cPerg, "11","Continuação verbas            ","","","mv_chB" 	,"C",90,0,0,"G","fVerbas(NIL,MV_PAR10+MV_PAR11+MV_PAR12,30)", ""   ,"","","mv_par11"," "		," "," ","",""			,"","","","","","","","","","","",{"Eventos a considerar"		},{},{})
PutSx1(cPerg, "12","Continuação verbas            ","","","mv_chC" 	,"C",90,0,0,"G","fVerbas(NIL,MV_PAR10+MV_PAR11+MV_PAR12,30)", ""   ,"","","mv_par12"," "		," "," ","",""			,"","","","","","","","","","","",{"Eventos a considerar"		},{},{})
PutSx1(cPerg, "13","Imprime todas verbas          ","","","mv_chD" 	,"N",01,0,0,"C",""				                   			, ""   ,"","","mv_par13","Sim"		," "," ","","Não"		,"","","","","","","","","","","",{"Imprime todos eventos"		},{},{})
PutSx1(cPerg, "14","Salvar em                     ","","","mv_chF" 	,"C",20,0,0,"G","NaoVazio"									, "DIR","","","mv_par14"," "		," "," ","",""			,"","","","","","","","","","","",{"Caminho\Nome Ex: C:\teste"	},{},{})

If !Pergunte( cPerg, .t. )
   Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a digitacao do periodo quando acumulado.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR07 == 2 .and. Empty(MV_PAR09)
	Aviso("Parâmetro incorreto", "Quando o periodo for acumulado, é necessário informar o período desejado.",{"Voltar"},1,"Ação não permitida.")
	return
Endif        

Processa( { || OkProc() }, "Executando o Processamento..." )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OKPROC    ºAutor  ³Silvano Franca      º Data ³  17/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Processa o relatorio excel.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSGPER04                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OkProc()

Local cSelekt, cQryCpos, nCntView
Local aCampos := {}
Local aVerbas := {}
Local nConta  := 0
Local nCount 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria do DBF com os dados basicos                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"FILIAL"  	,"C",002,0})
AADD(aCampos,{"MATRICULA"   ,"C",006,0})
AADD(aCampos,{"NOME"    	,"C",TamSX3('RA_NOME')[1],0})
AADD(aCampos,{"CPF"         ,"C",TamSX3("RA_CIC")[1],0})
AADD(aCampos,{"CC"			,"C",TamSX3('RC_CC')[1],0})  
AADD(aCampos,{"DESC_CC"		,"C",TamSX3('CTT_DESC01')[1],0})
AADD(aCampos,{"UNIDADE"			,"C",TamSX3('RA_ITEMD')[1],0})  
AADD(aCampos,{"OPERACAO"		,"C",TamSX3('RA_CLVLDB')[1],0})
AADD(aCampos,{"DESC_OPER"		,"C",TamSX3('CTH_DESC01')[1],0})
AADD(aCampos,{"DESC_CARGO"	,"C",TamSX3('RJ_DESC')[1],0})
AADD(aCampos,{"SALARIO" 	,"N",TamSX3('RA_SALARIO')[1],TamSX3('RA_SALARIO')[2]})
AADD(aCampos,{"HR_MES"	 	,"N",TamSX3('RA_HRSMES')[1],TamSX3('RA_HRSMES')[2]})
AADD(aCampos,{"ADMISSAO" 	,"D",008,0})
AADD(aCampos,{"DEMISSAO" 	,"D",008,0})                
AADD(aCampos,{"MOTIVO"		,"C",TamSX3('X5_DESCRI')[1],0})
AADD(aCampos,{"SITUACAO" 	,"C",TamSX3('RA_SITFOLH')[1],0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para verificar quais verbas devem ser geradas no relatorio.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR13 == 1 // Todas as verbas
	if MV_PAR07 == 1 // MOVIMENTO MENSAL        
		cQryCpos := "	SELECT DISTINCT RC_PD PD" 
		cQryCpos += "	FROM "+RetSQLName("SRC")+ " "
		cQryCpos += "	WHERE RC_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQryCpos += "	    AND RC_MAT 	BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQryCpos += "	    AND RC_CC 	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		cQryCpos += "		AND D_E_L_E_T_ = ' '  "
		cQryCpos += "	ORDER BY RC_PD  "
	Else // ACUMULADO
		AADD(aCampos,{"PERIODO" 	,"C",TamSX3('RD_DATARQ')[1],0})
		cQryCpos := "	SELECT DISTINCT RD_PD PD" 
		cQryCpos += "	FROM "+RetSQLName("SRD")
		cQryCpos += "	WHERE RD_FILIAL 	BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQryCpos += "	    AND RD_MAT 		BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQryCpos += "	    AND RD_CC 		BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		cQryCpos += "	    AND RD_DATARQ 	BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR08+"' "
		cQryCpos += "		AND D_E_L_E_T_ 	= ' '  "
		cQryCpos += "	ORDER BY RD_PD  "
	Endif	
	U_MontaView( cQryCpos, "cQryCpos" )

	cQryCpos->( DbGoTop() )
Else // Verbas informadas
	if MV_PAR07 == 2 // Se acumulado
		AADD(aCampos,{"PERIODO" 	,"C",TamSX3('RD_DATARQ')[1],0})
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra a String dos parametros de verbas e adiciona cada verba em um posicao do array. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVerbas := (Len(alltrim(MV_PAR10)) + Len(alltrim(MV_PAR11)) + Len(alltrim(MV_PAR12))) / 3
	cStrPD  := alltrim(MV_PAR10)+Alltrim(MV_PAR11)+Alltrim(MV_PAR12)
	
	For nX := 1 to nVerbas
		if Len(Substr(alltrim(cStrPD),nCount,3)) == 3
			cVerba := Substr(alltrim(cStrPD),nCount,3)                                                                      
			aAdd(aVerbas, cVerba)
		Endif
		nCount += 3
	Next nX
	ASort(aVerbas)
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona os campos da verbas no arquivo temporario .DBF     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR13 == 1// Todas as verbas
	While !cQryCpos->( Eof() )
		If Posicione("SRV", 1, xFilial("SRV")+cQryCpos->PD, "RV_TIPO") $ "HD"
			AADD(aCampos,{ "H"+cQryCpos->PD ,"N",TamSX3('RC_HORAS')[1],TamSX3('RC_HORAS')[2]})
	    Endif
		AADD(aCampos,{ "V"+cQryCpos->PD ,"N",TamSX3('RC_VALOR')[1],TamSX3('RC_VALOR')[2]})
		cQryCpos->( DbSkip() )
	EndDo
Else // Verbas Informadas
	For I := 1 to Len(aVerbas)
		If Posicione("SRV", 1, xFilial("SRV")+aVerbas[i], "RV_TIPO") $ "HD"
			AADD(aCampos,{ "H"+aVerbas[i] ,"N",TamSX3('RC_HORAS')[1],TamSX3('RC_HORAS')[2]})
	    Endif
		AADD(aCampos,{ "V"+aVerbas[i] ,"N",TamSX3('RC_VALOR')[1],TamSX3('RC_VALOR')[2]})
	Next I		              
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo := U_CriaTMP( aCampos, 'SRASRC' )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com os dados dos funcionarios, conforme os parametros.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if MV_PAR07 == 1 // MOVIMENTO MENSAL        
	cSelekt := " SELECT	SRC.RC_FILIAL FILIAL, SRC.RC_MAT MAT, SRA.RA_NOME NOME, SRA.RA_SALARIO SALARIO, SRC.RC_CC CC, SRA.RA_HRSMES HRMES,"
	cSelekt += " 		SRA.RA_ADMISSA ADMISSA, SRA.RA_DEMISSA DEMISSA, SRA.RA_SITFOLH SITFOLH, SRA.RA_CODFUNC CODFUNC, SRA.RA_RESCRAI RESCRAI,SRA.RA_CIC CPF,SRA.RA_ITEMD UNIDAD,SRA.RA_CLVLDB OPERAC"
	cSelekt += " FROM "+RetSQLName("SRC")+" SRC, "+RetSQLName("SRA")+" SRA "
	cSelekt += " WHERE  SRC.RC_FILIAL  = SRA.RA_FILIAL "
	cSelekt += "    AND SRC.RC_MAT 	   = SRA.RA_MAT "
	cSelekt += "    AND SRC.RC_FILIAL  >= '"+MV_PAR01+"'	AND SRC.RC_FILIAL	<= '"+MV_PAR02+"' 	"
	cSelekt += "    AND SRC.RC_MAT	   >= '"+MV_PAR03+"'	AND SRC.RC_MAT		<= '"+MV_PAR04+"' 	"
	cSelekt += "    AND SRC.RC_CC	   >= '"+MV_PAR05+"'	AND SRC.RC_CC		<= '"+MV_PAR06+"'	"
	cSelekt += "    AND SRC.D_E_L_E_T_ =  ' ' "
	cSelekt += "    AND SRA.D_E_L_E_T_ =  ' ' "
	cSelekt += " GROUP BY SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRA.RA_SALARIO, SRC.RC_CC , SRA.RA_ADMISSA, SRA.RA_DEMISSA, SRA.RA_SITFOLH, "
	cSelekt += " 	SRA.RA_CODFUNC, SRA.RA_RESCRAI, SRA.RA_HRSMES,SRA.RA_CIC,SRA.RA_ITEMD,SRA.RA_CLVLDB"
	cSelekt += " ORDER BY SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRC.RC_CC "
Else // ACUMULADO
	cSelekt := " SELECT	SRD.RD_FILIAL FILIAL, SRD.RD_MAT MAT, SRA.RA_NOME NOME, SRA.RA_SALARIO SALARIO, SRD.RD_CC CC, SRA.RA_HRSMES HRMES, "
	cSelekt += " 		SRA.RA_ADMISSA ADMISSA, SRA.RA_DEMISSA DEMISSA, SRA.RA_SITFOLH SITFOLH, SRA.RA_CODFUNC CODFUNC, SRA.RA_RESCRAI RESCRAI, SRD.RD_DATARQ DATARQ,SRA.RA_CIC CPF,SRA.RA_ITEMD UNIDAD,SRA.RA_CLVLDB OPERAC"
	cSelekt += "  FROM "+RetSQLName("SRD")+" SRD, "+RetSQLName("SRA")+" SRA "
	cSelekt += "  WHERE  SRD.RD_FILIAL  = SRA.RA_FILIAL "
	cSelekt += "     AND SRD.RD_MAT 	   = SRA.RA_MAT "
	cSelekt += "     AND SRD.RD_FILIAL  >= '"+MV_PAR01+"'	AND SRD.RD_FILIAL	<= '"+MV_PAR02+"' 	"
	cSelekt += "     AND SRD.RD_MAT	   	>= '"+MV_PAR03+"'	AND SRD.RD_MAT		<= '"+MV_PAR04+"' 	"
	cSelekt += "     AND SRD.RD_CC	   	>= '"+MV_PAR05+"'	AND SRD.RD_CC		<= '"+MV_PAR06+"'	"
	cSelekt += "     AND SRD.RD_DATARQ  >= '"+MV_PAR08+"'	AND SRD.RD_DATARQ	<= '"+MV_PAR09+"'	"
	cSelekt += "     AND SRD.D_E_L_E_T_ =  ' ' "
	cSelekt += "     AND SRA.D_E_L_E_T_ =  ' ' "
	cSelekt += " GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRA.RA_SALARIO, SRD.RD_CC , SRA.RA_ADMISSA, SRA.RA_DEMISSA, SRA.RA_SITFOLH, SRA.RA_CODFUNC, "
	cSelekt += " 	SRA.RA_RESCRAI, SRD.RD_DATARQ, SRA.RA_HRSMES,SRA.RA_CIC,SRA.RA_ITEMD,SRA.RA_CLVLDB"
	cSelekt += " ORDER BY SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRD.RD_CC  "
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera o arquivo temporario da query acima.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nCntView := U_MontaView( cSelekt, "QryMestre" )

ProcRegua( nCntView )

QryMestre->( DbGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta o arquivo que sera gerado para o usuario. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !QryMestre->( Eof() )

    nConta ++

    IncProc( "Processando "+AllTrim(Str(nConta))+" - De: "+AllTrim(Str(nCntView)) )

	If !(QryMestre->FILIAL $ fValidFil()) //0527/16 Isamu
	  dbSelectArea("QryMestre")
	  dbSkip()
	  Loop
    Endif         
      
    SRASRC->( RecLock( 'SRASRC',.t. ) )
	SRASRC->FILIAL  	:= QryMestre->FILIAL
	SRASRC->MATRICULA   := QryMestre->MAT
	SRASRC->NOME    	:= QryMestre->NOME
	SRASRC->CPF         := QryMestre->CPF
	SRASRC->SALARIO 	:= QryMestre->SALARIO
	SRASRC->HR_MES 		:= QryMestre->HRMES
	SRASRC->ADMISSAO 	:= Stod(QryMestre->ADMISSA)
	SRASRC->DEMISSAO 	:= Stod(QryMestre->DEMISSA)
	SRASRC->SITUACAO 	:= QryMestre->SITFOLH
	SRASRC->CC			:= QryMestre->CC
	SRASRC->DESC_CC 	:= Posicione("CTT", 1, xFilial("CTT")+QryMestre->CC, "CTT_DESC01" )
	SRASRC->DESC_CARGO	:= Posicione("SRJ", 1, xFilial("SRJ")+QryMestre->CODFUNC, "RJ_DESC" )
	SRASRC->MOTIVO		:= Posicione("SX5", 1, xFilial("SX5")+"27"+QryMestre->RESCRAI, "X5_DESCRI" )
	SRASRC->UNIDADE     := QryMestre->UNIDAD
	SRASRC->OPERACAO	:= QryMestre->OPERAC
	SRASRC->DESC_OPER:= Posicione("CTH", 1, xFilial("CTH")+QryMestre->OPERAC, "CTH_DESC01" )
   
		if MV_PAR07 == 2
		SRASRC->PERIODO		:= QryMestre->DATARQ
	Endif

    If mv_par07 == 1
		cFunc := " SELECT RC_PD PD, SUM(RC_HORAS) HORAS, SUM(RC_VALOR) VALOR"
		cFunc += " FROM SRC050 "
		cFunc += " WHERE RC_FILIAL  = '"+QryMestre->FILIAL+"' "
		cFunc += " AND   RC_MAT     = '"+QryMestre->MAT+"' "
		cFunc += " AND   D_E_L_E_T_ = ' ' " 
		cFunc += " GROUP BY RC_PD "
	Else
		cFunc := " SELECT RD_PD PD, SUM(RD_HORAS) HORAS, SUM(RD_VALOR) VALOR" //, RD_DATARQ DATARQ"
		cFunc += " FROM SRD050 "
		cFunc += " WHERE RD_FILIAL  = '"+QryMestre->FILIAL+"' "
		cFunc += " 	AND   RD_MAT     = '"+QryMestre->MAT+"' "
		cFunc += " 	AND   RD_DATARQ  = '"+QryMestre->DATARQ+"' "
		cFunc += " 	AND   D_E_L_E_T_ = ' ' "
	    cFunc += " GROUP BY RD_PD "
	Endif
	
	U_MontaView( cFunc, "cFunc" )
	
	cFunc->( DbGoTop() )

	While !cFunc->( Eof() )
	
        cCpoGrv := cFunc->PD
        //ALTERADO PELA OS 0835/11
        //cTipo   := Posicione("SRV", 1, xFilial("SRV")+cCpoGrv, "RV_TIPO")
	   //	If  (cTipo$ "HD") .or. (cCpoGrv == '101')
		 //	SRASRC->&( cTipo+cCpoGrv ) := cFunc->HORAS
	    //Endif
        SRASRC->&( "H"+cCpoGrv ) := cFunc->HORAS
        SRASRC->&( "V"+cCpoGrv ) := cFunc->VALOR

		cFunc->( DbSkip() )

	EndDo

    SRASRC->( MsUnLock() )
	    
	QryMestre->( DbSkip() )

EndDo

SRASRC->( DbCloseArea() )

__CopyFile( GetSrvProfString("StartPath","")+cArquivo, AllTrim(MV_PAR14)+"Folha.xls" )

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(MV_PAR14)+"Folha.xls")
oExcelApp:SetVisible(.T.)

Return