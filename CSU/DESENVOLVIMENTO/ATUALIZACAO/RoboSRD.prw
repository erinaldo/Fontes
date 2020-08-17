#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณROBOSRD   บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do log de ocorrencias do acerto automatico na tabe-บฑฑ
ฑฑบ          ณ la SRD.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ROBOSRD()

Private nOpca       := 0
Private cCadastro   := "Geracao do ROBO para ajuste da tablea SRD"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cFuncao     := " Processa( { || ROBOSRDa() }, 'Lendo os movimentos....' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.
Private oExcelApp
Private cPerg := PADR('RObOrd',LEN(SX1->X1_GRUPO))
Private aRegs := {}

aAdd(aRegs,{cPerg,"01","Verba-Base p/ Verif.","","","mv_ch1","C",03,0,0,"G","ExistCpo('SRV')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRV","","","","",""})
aAdd(aRegs,{cPerg,"02","Ano de Referencia..:","","","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","9999",""})
aAdd(aRegs,{cPerg,"03","Mes / Referencia De ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","99",""})
aAdd(aRegs,{cPerg,"04","Mes / Referencia Ate","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","99",""})
aAdd(aRegs,{cPerg,"05","Filial de..........:","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","99",""})
aAdd(aRegs,{cPerg,"06","Filial Ate.........:","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","99",""})
aAdd(aRegs,{cPerg,"07","Matricula De.......:","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Matricula Ate......:","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Metodo de Processam.","","","mv_ch9","N",01,0,0,"C","","mv_par09","Listar","","","","","Ajustar","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

Pergunte( cPerg, .f. )

nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
	{"&Fechar"},3,"Geracao de Arquivo Excel",,;
	"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Ajuste automatico na tabela SRD p/ MANAD" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Esta rotina tem como objetivo gerar um arquivo no formato" Size 141,8
@ 045,015 Say "excel referente ao ajuste automatico na tabela SRD para"   Size 142,8
@ 055,015 Say "atender as especificacoes do MANAD CSU."                   Size 142,8
@ 022,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 044,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 066,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ROBOSRDa บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento do relatorio.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ROBOSRD.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ROBOSRDa()

Private nHdl, nAt1, cLine
Private cEOL := CHR(13)+CHR(10)
Private cLin := ""
Private cQuery

ChkFile("SRD")

SRD->( DbSetOrder(1) )

cQuery := " SELECT DISTINCT RD_FILIAL, RD_MAT, RD_DATARQ, RD_DATPGT "+cEol
cQuery += " FROM "+RetSqlName("SRD")+cEol
cQuery += " WHERE RD_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+cEol
cQuery += " AND   SUBSTRING( RD_DATARQ,1,4 ) = '"+MV_PAR02+"' "+cEol
cQuery += " AND   SUBSTRING( RD_DATARQ,5,2 ) BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR03+"' "+cEol
cQuery += " AND   D_E_L_E_T_ = ' ' "+cEol
cQuery += " AND   RD_MAT BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+cEol "
cQuery += " ORDER BY RD_FILIAL, RD_MAT, RD_DATARQ "+cEol

nCntView := U_MontaView( cQuery, "Work" )

Work->( DbGoTop() )

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Gerar o cabecalho do arquivo HTML + os Estilos CCS    ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

ROBOSRDb()

ProcRegua( nCntView )

While !Work->( Eof() )
	
	IncProc( Work->RD_DATARQ )
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ      ***** Inicio das Verificacoes *****              ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ I-   Obter o CC correto referente a Verba-Base:       ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	
	cVerbaBase := " SELECT RD_CC "
	cVerbaBase += " FROM "+RetSqlName("SRD")
	cVerbaBase += " WHERE RD_FILIAL  = '"+Work->RD_FILIAL+"' "
	cVerbaBase += " AND   RD_MAT     = '"+Work->RD_MAT+"' "
	cVerbaBase += " AND   RD_DATARQ  = '"+Work->RD_DATARQ+"' "
	cVerbaBase += " AND   RD_PD      = '"+MV_PAR01+"' "
	cVerbaBase += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cVerbaBase, "VerbaBase" )
	
	VerbaBase->( DbGotop() )
	
	MemoWrite("c:\transfer\logsrd.txt",cVerbaBase)
	
	If Empty( VerbaBase->RD_CC ) // Verba-Base Nao encontrada
		
		cLin += "<td class=xl3431556 style='border-left:none'>VERBA BASE NAO ENCONTRADA => "+Work->RD_FILIAL+"</td> "
		cLin += "<td class=xl3331556 style='border-left:none'>"+Work->RD_MAT+"</td> "
		cLin += "<td class=xl3431556 style='border-left:none'></td> "
		cLin += "<td class=xl3431556 style='border-left:none'></td> "
		cLin += "<td class=xl3331556 style='border-left:none'></td> "
		cLin += "<td class=xl3431556 style='border-left:none'></td> "
		cLin += "<td class=xl3431556 style='border-left:none'></td> "
		cLin += "<td class=xl3331556 style='border-left:none'></td> "
		xAddToFile( cLin, cCmd )
		
		cLin := " 	  <tr height=17 style='height:12.75pt'> "
		cLin += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "
		
		Work->( DbSkip() )
		Loop
	EndIf
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ II-  Verificar as linhas que contenham o CC diferente do CC obtido na Verba-Base:ณ
	ณ      a-) Se nao houver nenhum:                                                   ณ
	ณ      a.1-) Verificar se ha verbas duplicadas;                                    ณ
	ณ      a.1.1-) Se nao houver verbas duplicadas, ignorar;                           ณ
	ณ      a.1.2-) Se houver verbas duplicadas, somar valores e horas;                 ณ
	ณ      a.1.3-) As horas e valores somados deverao ser exibidos conforme a query    ณ
	ณ              cVerDUP.                                                            ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cCCDIF := " SELECT RD_PD, RD_HORAS, RD_VALOR, R_E_C_N_O_ AS REGS "
	cCCDIF += " FROM "+RetSqlName("SRD")
	cCCDIF += " WHERE RD_FILIAL  =  '"+Work->RD_FILIAL+"' "
	cCCDIF += " AND   RD_MAT     =  '"+Work->RD_MAT+"' "
	cCCDIF += " AND   RD_DATARQ  =  '"+Work->RD_DATARQ+"' "
	cCCDIF += " AND   RD_CC      <> '"+VerbaBase->RD_CC+"' "
	cCCDIF += " AND   D_E_L_E_T_ =  ' ' "
	
	U_MontaView( cCCDIF, "CCDif" )
	CCDif->( DbGoTop() )
	
	If CCDif->REGS > 0
		// Somar Valores:
		cVerDUP := " SELECT RD_PD, SUM(ROUND(RD_HORAS,2)) AS SOMAHORA, SUM(ROUND(RD_VALOR,2)) AS SOMAVLR "
		cVerDUP += " FROM "+RetSqlName("SRD")
		cVerDUP += " WHERE RD_FILIAL  =  '"+Work->RD_FILIAL+"' "
		cVerDUP += " AND   RD_MAT     =  '"+Work->RD_MAT+"' "
		cVerDUP += " AND   RD_DATARQ  =  '"+Work->RD_DATARQ+"' "
		//cVerDUP += " AND   RD_CC      <> '"+VerbaBase->RD_CC+"' "
		cVerDUP += " AND   D_E_L_E_T_ =  ' ' "
		cVerDUP += " GROUP BY RD_PD "
		cVerDUP += " HAVING COUNT(*) > 1 "
		U_MontaView( cVerDUP, "cVerDUP" )
		cVerDUP->( DbGoTop() )
		If cVerDUP->SOMAHORA == 0
			// Neste caso, basta alterar o CC diferente:
			If MV_PAR09 == 1
				cLin += "<td class=xl3431556 style='border-left:none'>Aj. de CC: "+Work->RD_FILIAL+"</td> "
				cLin += "<td class=xl3331556 style='border-left:none'>"+Work->RD_MAT+"</td> "
				cLin += "<td class=xl3431556 style='border-left:none'>"+CCDif->RD_PD+"</td> "
				cLin += "<td class=xl3431556 style='border-left:none'>"+Transform( CCDif->RD_HORAS, "@E 999,999,999.99" )+"</td> "
				cLin += "<td class=xl3331556 style='border-left:none'>"+Transform( CCDif->RD_VALOR, "@E 999,999,999.99" )+"</td> "
				cLin += "<td class=xl3431556 style='border-left:none'>"+Work->RD_DATARQ+"</td> "
				cLin += "<td class=xl3431556 style='border-left:none'>"+Work->RD_DATPGT+"</td> "
				cLin += "<td class=xl3331556 style='border-left:none'>"+VerbaBase->RD_CC+"</td> "
				xAddToFile( cLin, cCmd )
				
				cLin := " 	  <tr height=17 style='height:12.75pt'> "
				cLin += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "
			Else
				cExec := "UPDATE "+RetSqlName('SRD')
				cExec += " SET RD_CC = '"+VerbaBase->RD_CC+"' "
				cExec += " WHERE RD_FILIAL  =  '"+Work->RD_FILIAL+"' "
				cExec += " AND   RD_MAT     =  '"+Work->RD_MAT+"' "
				cExec += " AND   RD_DATARQ  =  '"+Work->RD_DATARQ+"' "
				cExec += " AND   RD_PD      =  '"+CCDif->RD_PD+"' "
				cExec += " AND   D_E_L_E_T_ = ' ' "
				
				TcSqlExec( cExec )
				
			EndIf
			Work->( DbSkip() )
			Loop
		Else
			aDuplis := {}
			aJaFoi  := {}
			While !cVerDUP->( Eof() )
				Aadd( aDuplis, { cVerDUP->RD_PD, cVerDup->SOMAHORA, cVerDup->SOMAVLR } )
				cVerDUP->( DbSkip() )
			EndDo
			// Obter a impressao:
			cVerImp := " SELECT RD_HORAS, RD_VALOR, RD_PD, RD_HORAS, RD_VALOR "
			cVerImp += " FROM "+RetSqlName("SRD")
			cVerImp += " WHERE RD_FILIAL  =  '"+Work->RD_FILIAL+"' "
			cVerImp += " AND   RD_MAT     =  '"+Work->RD_MAT+"' "
			cVerImp += " AND   RD_DATARQ  =  '"+Work->RD_DATARQ+"' "
			cVerImp += " AND   D_E_L_E_T_ =  ' ' "
			
			U_MontaView( cVerImp, "cVerImp" )
			
			cVerImp->( DbGoTop() )
			
			While !cVerImp->( Eof() )
				nSeek  := Ascan( aDuplis, { |x| x[1] == cVerImp->RD_PD } )
				nJaFoi := Ascan( aJaFoi, cVerImp->RD_PD )
				// Se houve ajuste, imprimir somente situacao de ajuste:
				If nSeek > 0 .And. nJaFoi == 0
					Aadd( aJaFoi, cVerImp->RD_PD )
					If MV_PAR09 == 1
						cLin += "<td class=xl3431556 style='border-left:none'>Aj. Somat๓ria: "+Work->RD_FILIAL+"</td> "
						cLin += "<td class=xl3331556 style='border-left:none'>"+Work->RD_MAT+"</td> "
						cLin += "<td class=xl3431556 style='border-left:none'>"+cVerImp->RD_PD+"</td> "
						cLin += "<td class=xl3431556 style='border-left:none'>"+Transform( aDuplis[nSeek][2], "@E 999,999,999.99" )+"</td> "
						cLin += "<td class=xl3331556 style='border-left:none'>"+Transform( aDuplis[nSeek][3], "@E 999,999,999.99" )+"</td> "
						cLin += "<td class=xl3431556 style='border-left:none'>"+Work->RD_DATARQ+"</td> "
						cLin += "<td class=xl3431556 style='border-left:none'>"+Work->RD_DATPGT+"</td> "
						cLin += "<td class=xl3331556 style='border-left:none'>"+VerbaBase->RD_CC+"</td> "
						xAddToFile( cLin, cCmd )
						
						cLin := " 	  <tr height=17 style='height:12.75pt'> "
						cLin += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "
					Else
						
						cExec := " SELECT R_E_C_N_O_ AS REGS FROM "+RetSqlName("SRD")
						cExec += " WHERE RD_FILIAL  =  '"+Work->RD_FILIAL+"' "
						cExec += " AND   RD_MAT     =  '"+Work->RD_MAT+"' "
						cExec += " AND   RD_DATARQ  =  '"+Work->RD_DATARQ+"' "
						cExec += " AND   RD_PD      =  '"+cVerImp->RD_PD+"' "
						cExec += " AND   D_E_L_E_T_ =  ' ' "
						U_MontaView( cExec, "cExec" )
						cExec->( DbGoTop() )
						If cExec->REGS > 0
							SRD->( DbGoTo( cExec->REGS ) )
							SRD->( RecLock('SRD',.f.) )
							SRD->( DbDelete() )
							SRD->( MsUnLock() )
						EndIf
						cExec->( DbSkip() )
						SRD->( DbGoTo( cExec->REGS ) )
						If !SRD->( Eof() )
							SRD->( RecLock('SRD',.f.) )
							SRD->RD_HORAS := aDuplis[nSeek][2]
							SRD->RD_VALOR := aDuplis[nSeek][3]
							SRD->( MsUnLock() )
						EndIf
						
						
					EndIf
					
				EndIf
				
				cVerImp->( DbSkip() )
				
			EndDo
			
		EndIf
	EndIf
	
	Work->( DbSkip() )
	
EndDo

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Finalizar a gravacao do Excel                         ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

cLin += " </table> "
cLin += " </div> "
cLin += " </body> "
cLin += " </html> "

xAddToFile( cLin, cCmd )

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

Ferase( cDirDocs+"\"+cArquivo+".xls" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAddToFileบAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona a linha de log ao fim de um arquivo.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ROBOSRD.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

Static Function xAddToFile( cLog, cToFile )

Local nHdl  := -1
Local cBuff := cLog

If File( cToFile )
	
	nHdl := FOpen( cToFile, 1 )
	
	If nHdl >= 0
		
		FSeek( nHdl, 0, 2 )
		
	EndIf
	
Else
	
	nHdl := FCreate( cToFile )
	
EndIf

If nHdl >= 0
	
	FWrite( nHdl,  cBuff, Len( cBuff ) )
	
EndIf

FClose( nHdl )

Return

Static Function ROBOSRDb()

Local cGrvBuff := ''

cGrvBuff += ' <html xmlns:v="urn:schemas-microsoft-com:vml" ' '
cGrvBuff += ' xmlns:o="urn:schemas-microsoft-com:office:office" '
cGrvBuff += ' xmlns:x="urn:schemas-microsoft-com:office:excel" '
cGrvBuff += ' xmlns="http://www.w3.org/TR/REC-html40"> '
cGrvBuff += ' <head> '
cGrvBuff += ' <meta http-equiv=Content-Type content="text/html; charset=windows-1252"> '
cGrvBuff += ' <meta name=ProgId content=Excel.Sheet> '
cGrvBuff += ' <meta name=Generator content="Microsoft Excel 11"> '
cGrvBuff += ' <link rel=File-List href="sc356290_arquivos/filelist.xml"> '
cGrvBuff += ' <style> '
cGrvBuff += ' v\:* {behavior:url(#default#VML);} '
cGrvBuff += ' o\:* {behavior:url(#default#VML);} '
cGrvBuff += ' x\:* {behavior:url(#default#VML);} '
cGrvBuff += ' .shape {behavior:url(#default#VML);} '
cGrvBuff += ' </style> '
cGrvBuff += ' <style id="Pedidos  BackLog1_31556_Styles"> '
cGrvBuff += ' <!--table '
cGrvBuff += ' 	{mso-displayed-decimal-separator:"\,"; '
cGrvBuff += ' 	mso-displayed-thousand-separator:"\.";} '
cGrvBuff += ' .xl1531556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl2231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '
cGrvBuff += ' .xl2331556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"Short Date"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl2431556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;}  '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2831556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; ' '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2931556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl3031556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl3131556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3231556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom;  '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3331556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3431556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3531556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:general; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3631556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 			text-align:right; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3731556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:700; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial, sans-serif; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:middle; '
cGrvBuff += ' 			border-top:1.0pt solid windowtext; '
cGrvBuff += ' 			border-right:.5pt solid windowtext; '
cGrvBuff += ' 			border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 			border-left:1.0pt solid windowtext; '
cGrvBuff += ' 			background:#99CCFF; '
cGrvBuff += ' 			mso-pattern:auto none; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 			.xl3831556 '
cGrvBuff += ' 				{padding:0px; '
cGrvBuff += ' 				mso-ignore:padding; '
cGrvBuff += ' 				color:windowtext; '
cGrvBuff += ' 				font-size:10.0pt; '
cGrvBuff += ' 				font-weight:700; '
cGrvBuff += ' 				font-style:normal; '
cGrvBuff += ' 				text-decoration:none; '
cGrvBuff += ' 				font-family:Arial, sans-serif; '
cGrvBuff += ' 				mso-font-charset:0; '
cGrvBuff += ' 				mso-number-format:General; '
cGrvBuff += ' 				text-align:center; '
cGrvBuff += ' 				vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl3931556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 				.xl4031556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl4131556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:General; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:1.0pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl4231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:center; '
cGrvBuff += ' 		vertical-align:middle; '
cGrvBuff += ' 		border-top:1.0pt solid windowtext; '
cGrvBuff += ' 		border-right:.5pt solid windowtext; '
cGrvBuff += ' 		border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 		border-left:.5pt solid windowtext; '
cGrvBuff += ' 		background:#99CCFF; '
cGrvBuff += ' 		mso-pattern:auto none; '
cGrvBuff += ' 		white-space:normal;} '
cGrvBuff += ' 	.xl4331556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border-top:none; '
cGrvBuff += ' 		border-right:.5pt solid silver; '
cGrvBuff += ' 		border-bottom:.5pt solid silver; '
cGrvBuff += ' 		border-left:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4431556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:18.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl4531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0_\)\;_\(* \\\(\#\,\#\#0\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"0\.0%"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	--> '
cGrvBuff += ' 	</style> '
cGrvBuff += ' 	</head> '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	<body> "
cGrvBuff += " 	<table x:str border=0 cellpadding=0 cellspacing=0 width=1171 style='border-collapse: "
cGrvBuff += " 	 collapse;table-layout:fixed;width:880pt'> "
cGrvBuff += " 	 <col class=xl2531556 width=26 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 950;width:20pt'> "
cGrvBuff += " 	 <col width=90 span=2 style='mso-width-source:userset;mso-width-alt:3291; "
cGrvBuff += " 	 width:68pt'> "
cGrvBuff += " 	 <col width=306 style='mso-width-source:userset;mso-width-alt:11190;width:230pt'> "
cGrvBuff += " 	 <col width=80 style='mso-width-source:userset;mso-width-alt:2925;width:60pt'> "
cGrvBuff += " 	 <col width=92 style='mso-width-source:userset;mso-width-alt:3364;width:69pt'> "
cGrvBuff += " 	 <col class=xl2631556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col width=89 style='mso-width-source:userset;mso-width-alt:3254;width:67pt'> "
cGrvBuff += " 	 <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 span=2 style='mso-width-source:userset; "
cGrvBuff += " 	 mso-width-alt:3474;width:71pt'> "

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	 <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	  <td height=17 class=xl2531556 width=26 style='height:12.75pt;width:20pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=306 style='width:230pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=80 style='width:60pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=92 style='width:69pt'></td> "
cGrvBuff += " 	  <td class=xl2631556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=89 style='width:67pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=18 style='width:14pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=31 style='height:23.25pt'> "
cGrvBuff += " 	  <td height=31 class=xl2531556 style='height:23.25pt'></td> "

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += " 	  <td class=xl4431556 colspan=3>LOG DE OCORRสNCIAS DO AJUSTE DA SRD PARA O MANAD</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=20 style='mso-height-source:userset;height:15.0pt'> "
cGrvBuff += " 	  <td height=20 class=xl2531556 style='height:15.0pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=18 style='height:13.5pt'> "
cGrvBuff += " 	  <td height=18 class=xl2531556 style='height:13.5pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr class=xl2231556 height=44 style='mso-height-source:userset;height:33.0pt'> "
cGrvBuff += " 	  <td height=44 class=xl2531556 style='height:33.0pt'></td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Filial</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Matricula</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Verba</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Horas</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Valor</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Ano/Mes</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Dt.Pgto.</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>C. de Custo</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	  <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

xAddToFile( cGrvBuff, cCmd )

Return