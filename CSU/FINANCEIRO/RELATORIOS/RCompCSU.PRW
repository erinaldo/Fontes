#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"      
#INCLUDE "report.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ RCompCSU   บAutor  ณ 	Eduardo Dias     บ Data ณ 17/03/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณ Relatorio de COMPENSAวรO CARTEIRA							  บฑฑ
ฑฑบ         ณ 													        

  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OAB-SP                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCompCSU()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aRegs	:= {}
Local cPerg := PadR ("RCompCSU", Len (SX1->X1_GRUPO))   
Private aArrayRe	
Private aArrayPa	
Private nConComp
Private nVlrRec
Private nXCSU
Private nCalcSld


 Private aHELPER := {}
Private Qry	 	:= GetNextAlias()
Private cPedido := ""
//Private Qry2 := GetNextAlias()
//Private Qry3 := GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  HELP das perguntas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd(aHELPER,{"Data da Mov. Bancaria inicial."})
AAdd(aHELPER,{"Data da Mov. Bancaria final."})
AAdd(aHELPER,{"Imprime Titulo Compensado? " })

AAdd(aHELPER,{"Numero da Compensacao inicial."})
AAdd(aHELPER,{"Numero da Compensacao final."})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os parametros da rotina                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
aAdd(aRegs,{cPerg,"01","Dt. Mov.Bancaria De  ? ","Dt. Mov.Bancaria De  ? ","Dt. Mov.Bancaria De  ? ","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","",""}) 

//aHELPER[3],aHELPER[3],aHELPER[3] })
aAdd(aRegs,{cPerg,"02","Dt. Mov.Bancaria Ate ? ","Dt. Mov.Bancaria Ate ? ","Dt. Mov.Bancaria Ate ? ","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","",""}) 

//aHELPER[4],aHELPER[4],aHELPER[4] })
aAdd(aRegs,{cPerg,"03","Nบ da Compensa็ใo De ?  ","Nบ da Compensa็ใo De ? ","Nบ da Compensa็ใo De  ? ","mv_ch3","C",06,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","",""}) 

//aHELPER[5],aHELPER[5],aHELPER[5] })
aAdd(aRegs,{cPerg,"04","Nบ da Compensa็ใo Ate ? ","Nบ da Compensa็ใo Ate ?","Nบ da Compensa็ใo Ate ? ","mv_ch4","C",06,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","",""}) 

//aHELPER[6],aHELPER[6],aHELPER[6] })
aAdd(aRegs,{cPerg,"05","Somente Titulo Compensado ? ","Somente Titulo Compensado ? ","Somente Titulo Compensado ? ","mv_ch5","C",01,0,2,"C","","","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","",""}) //aHELPER[1],aHELPER[1],aHELPER[1] })

CriaSx1(aRegs)                 

If !Pergunte(cPerg,.T.)  
	Return .F.                                                      
Endif
       
CompTit1()


Return .T.                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CompTit1 บ Autor ณ    Eduardo Dias    บ Data ณ  17/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 		  Processamento do relatorio de Medi็๕es x 	    	  บฑฑ
ฑฑบ          ณ   		Medi็๕es Encerradas x Titulo a Pagar              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
Static Function CompTit1()
//Static Function RCTBR99A()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oReport
Local oBreak
Local oSection                  
Local cTitulo 	:= "Este relatorio ira imprimir informa็๕es sobre Compensa็ใo em Carteira"
Private oSecCab                                
Private nCompensa

//oReport := TReport():New("REPORT",cTitulo,,{|oReport| PrintReport(oReport)},"Imprime Relatorio de Rateio")
oReport := TReport():New("REPORT",cTitulo,,{|oReport| PrintReport(oReport)},"Relat๓rico Especifico CSU - COMPENSAวรO CARTEIRA")
oReport:HideParamPage(.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGarantir a impressใo em paisagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:SetLandScape(.T.)

DEFINE SECTION oSection OF oReport TABLES "SE1","SE2","SE5" TITLE "Relat๓rico Especifico CSU - ROTINA DE COMPENSAวรO CARTEIRA"

DEFINE CELL NAME "E5_DATA" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_DATA")[1]	TITLE OemToAnsi("Data Movimento")		BLOCK {|| impLinha("E5_DATA")	}
	DEFINE CELL NAME "E5_CLIENTE" 		OF oSection ALIAS "SE5" SIZE TAMSX3("E5_CLIENTE")[1] TITLE OemToAnsi("Cod. Cliente")		BLOCK {|| impLinha("E5_CLIENTE")	}
	DEFINE CELL NAME "A1_NREDUZ" 	OF oSection ALIAS "SE5" SIZE TAMSX3("A1_NREDUZ")[1]	TITLE OemToAnsi("Nome Cliente")		BLOCK {|| impLinha("NomeCli")	}	// ver qual o campo correto	
	DEFINE CELL NAME "E5_FORNECE" 		OF oSection ALIAS "SE5" SIZE TAMSX3("E5_FORNECE")[1] TITLE OemToAnsi("Cod. Fornecedor")		BLOCK {|| impLinha("E5_FORNECE") }	
	DEFINE CELL NAME "A2_NREDUZ" 	OF oSection ALIAS "SE5" SIZE TAMSX3("A2_NREDUZ")[1]	TITLE OemToAnsi("Nome Fornecedor")		BLOCK {|| impLinha("NomeFor")	}	// ver qual o campo correto	
	DEFINE CELL NAME "E5_IDENTEE" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_IDENTEE")[1]	TITLE OemToAnsi("Nบ da Compensa็ใo")		BLOCK {|| impLinha("E5_IDENTEE")	}	
	DEFINE CELL NAME "E5_RECPAG" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_RECPAG")[1]	TITLE OemToAnsi("Finalidade do Titulo")	BLOCK {|| impLinha("E5_RECPAG")	}	//E5_RECPAG = P=PAGAMENTO / R=RECEBIMENTO
	DEFINE CELL NAME "E5_NUMERO" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_NUMERO")[1]	TITLE OemToAnsi("Nบ do Tํtulo Pagto")		BLOCK {|| impLinha("E5_NUMERO")	}	//E5_RECPAG = P=PAGAMENTO / R=RECEBIMENTO
	DEFINE CELL NAME "E5_TIPO" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_TIPO")[1]	TITLE OemToAnsi("Tipo Titulo")		BLOCK {|| impLinha("E5_TIPO")	}	//E5_RECPAG = P=PAGAMENTO / R=RECEBIMENTO
	DEFINE CELL NAME "E1_VALOR" 	OF oSection ALIAS "SE1" SIZE TAMSX3("E1_VALOR")[1]	TITLE OemToAnsi("Total a Receber")		BLOCK {|| impLinha("E1_VALOR")	}		
	DEFINE CELL NAME "E2_VALOR" 	OF oSection ALIAS "SE2" SIZE TAMSX3("E2_VALOR")[1]	TITLE OemToAnsi("Total a Pagar")		BLOCK {|| impLinha("E2_VALOR")	}		
		
//	DEFINE CELL NAME "E5_VALOR" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_VALOR")[1]	TITLE OemToAnsi("Vlr Total Compensado")		BLOCK {|| impLinha("E5_VALOR")	}	
//	DEFINE CELL NAME "E5_VALOR" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_VALOR")[1]	TITLE OemToAnsi("Total a Receber")		BLOCK {|| impLinha("E1_VALOR")	}	
//	DEFINE CELL NAME "E5_VALOR" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_VALOR")[1]	TITLE OemToAnsi("Total a Pagar")		BLOCK {|| impLinha("E2_VALOR")	}	
		
	DEFINE CELL NAME "E1_SALDO" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E1_SALDO")[1]	TITLE OemToAnsi("Vlr Total Compensado")		BLOCK {|| impLinha("nSaldo")	}		
//	DEFINE CELL NAME "E5_IDENTEE" 	OF oSection ALIAS "SE5" SIZE TAMSX3("E5_IDENTEE")[1]	TITLE OemToAnsi("Nบ da Compensa็ใo")		BLOCK {|| impLinha("E5_IDENTEE")	}	

//	oBreak := TRBreak():New(oSection,oSection:Cell("E5_IDENTEE"),"Sub-Total")  //Quebra linha
//	oReport:SkipLine(5) //pula 3 linhas de uma se็ใo para outra
//	TRFunction():New(oSection:Cell(impLinha("nSaldo")),"2","SUM",oBreak,,,,.F.,.T.)  // Totalizador Saldo Valor
		
oReport:PrintDialog()
                                                                       
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ     Eduardo Dias   บ Data ณ  21/03/17   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da query relatorio de rateio.                 บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OAB                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport) 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Local cDataDe	:= DtoS(MV_PAR01)
Local cDataAte	:= DtoS(MV_PAR02)
Local cCompDe	:= MV_PAR03
Local cCompAte	:= MV_PAR04
Local cTitComp	:= LTRIM(STR(MV_PAR05))
Local cQRYTMP	:= ""     
local cQuery	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGarantir a impressใo em paisagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
oReport:SetLandScape(.T.)
 
#IFDEF TOP
	oSection := oReport:Section(1)

	MakeSqlExp("REPORT")		

	oSection:BeginQuery()		
  
  		If cTitComp == "1"       		
			BeginSql alias Qry  
		    			
				SELECT DISTINCT E5_DATA, E5_FORNECE, E5_CLIENTE, E5_IDENTEE, E5_NUMERO, E5_VALOR, E5_LOJA, E5_RECPAG, E5_PREFIXO, E5_PARCELA, E5_TIPO								
				FROM %table:SE5% SE5(NOLOCK) //,%table:CNF% CNF(NOLOCK)               
				LEFT JOIN %table:SE1% SE1
				ON SE1.E1_NUM = SE5.E5_NUMERO 
					AND SE1.E1_TIPO = SE5.E5_TIPO
					AND SE1.D_E_L_E_T_=''			                              
				LEFT JOIN %table:SE2% SE2
				ON SE2.E2_NUM = SE5.E5_NUMERO
					AND SE2.E2_TIPO = SE5.E5_TIPO
					AND SE2.D_E_L_E_T_ = ' ' 
					
				WHERE E5_DATA BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
					AND E5_IDENTEE BETWEEN %Exp:cCompDe% AND %Exp:cCompAte%     
					AND E5_IDENTEE <> ' ' //= CASE WHEN %Exp:cTitComp% = '2' THEN %Exp:cTitComp% ELSE E5_IDENTEE   END 
					AND E5_TIPO = 'NF'
					AND SE5.D_E_L_E_T_ = ' '
				ORDER BY E5_IDENTEE, E5_DATA, E5_FORNECE, E5_CLIENTE
						
			EndSql 
			
		Else
	
			BeginSql alias Qry  
		    			
				SELECT DISTINCT E5_DATA, E5_FORNECE, E5_CLIENTE, E5_IDENTEE, E5_NUMERO, E5_VALOR, E5_LOJA, E5_RECPAG, E5_PREFIXO, E5_PARCELA, E5_TIPO								
				FROM %table:SE5% SE5(NOLOCK) //,%table:CNF% CNF(NOLOCK)               
				LEFT JOIN %table:SE1% SE1
				ON SE1.E1_NUM = SE5.E5_NUMERO 
					AND SE1.E1_TIPO = SE5.E5_TIPO
					AND SE1.D_E_L_E_T_=''			                              
				LEFT JOIN %table:SE2% SE2
				ON SE2.E2_NUM = SE5.E5_NUMERO
					AND SE2.E2_TIPO = SE5.E5_TIPO
					AND SE2.D_E_L_E_T_ = ' ' 					
				WHERE E5_DATA BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
					AND E5_IDENTEE BETWEEN %Exp:cCompDe% AND %Exp:cCompAte%     
					AND E5_TIPO != 'TX'
					AND SE5.D_E_L_E_T_ = ' '
				ORDER BY E5_IDENTEE, E5_DATA, E5_FORNECE, E5_CLIENTE
						
			EndSql 		
		
		EndIf		
		oSection:EndQuery({})

#ENDIF 

	
MemoWrite("OABCNTR1.QRY",GETLastQuery()[2])

oSection:Print()                                  
 
Return                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณimpLinha  บAutor  ณ   Eduardo Dias     บ Data ณ  21/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณQuery                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function impLinha(_cCampo)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cRet   		:= " "
Local cAnoMes		:= ""
Local cUltRev		:= ""
Local cConta		:= ""
Local cAliasRec 	:= ""  
Local cAliasPag 	:= ""  
Local nVlrPag		:= 0
Default nVlrRec		:= 0 
Default nCalcSld	:= 0
Default aArrayRe	:= {}
Default aArrayPa	:= {}
Default nXCSU		:= 1
Default nCalcSld	:= 0
Default nConComp	:= 1
Default nCompensa	:= "000000"


If _cCampo == "E5_DATA"
	_cRet := (Qry)->E5_DATA
	
ElseIf _cCampo == "E5_CLIENTE"  
	
	If !Empty((Qry)->E5_CLIENTE)
		_cRet := (Qry)->E5_CLIENTE //Posicionar no SB1
	Else
		_cRet	:= "******"
	EndIf
		
ElseIf _cCampo == "NomeCli" //"A1_NREDUZ"      
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	DbSeek(xFilial("SA1")+(Qry)->E5_CLIENTE+(Qry)->E5_LOJA) 
	                            
	If !Empty((Qry)->E5_CLIENTE)	
		_cRet	:= ALLTrim(SA1->A1_NREDUZ)
	Else
		_cRet	:= "***************"
	EndIf
	
ElseIf _cCampo == "E5_FORNECE"
	
	If !Empty((Qry)->E5_FORNECE)
		_cRet	:= (Qry)->E5_FORNECE
	Else
		_cRet	:= "******"
	EndIf
	
ElseIf _cCampo == "NomeFor" //"A2_NREDUZ"                                                                               

                             
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	DbSeek(xFilial("SA2")+(Qry)->E5_FORNECE+(Qry)->E5_LOJA) 

	If !Empty((Qry)->E5_FORNECE)
		_cRet	:= ALLTrim(SA2->A2_NREDUZ)  
	Else
		_cRet	:= "***************"
	EndIf
	
ElseIf _cCampo == "E5_IDENTEE"
	
	If !Empty((Qry)->E5_IDENTEE)
		_cRet	:= (Qry)->E5_IDENTEE 
	Else
		_cRet	:= "******"
	EndIf
		
ElseIf _cCampo == "E5_RECPAG"
	_cRet	:= IIf((Qry)->E5_RECPAG == "R", "RECEBIMENTO", "PAGAMENTO") 
	cRecPag := _cRet 
	
ElseIf _cCampo == "E5_NUMERO"   
	
	If !Empty((Qry)->E5_NUMERO)
		_cRet	:= (Qry)->E5_NUMERO 
	Else
		_cRet	:= "******"
	EndIf
                
ElseIf _cCampo == "E5_TIPO"
	_cRet	:= (Qry)->E5_TIPO

ElseIf _cCampo == "E1_VALOR"

	If !Empty((Qry)->E5_CLIENTE)         
		dbSelectArea("SE1")
		dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		DbSeek(xFilial("SE1")+(Qry)->E5_CLIENTE+(Qry)->E5_LOJA+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO) 

		_cRet	:= SE1->E1_VALOR // SE1->E1_VALOR 
//		_cRet	:= (Qry)->E5_VALOR 
	Else
		_cRet	:= ""
	EndIf

ElseIf _cCampo == "E2_VALOR"
	If !Empty((Qry)->E5_FORNECE)         
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

   		DbSeek(xFilial("SE2")+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO+(Qry)->E5_FORNECE+(Qry)->E5_LOJA) 

		_cRet	:= SE2->E2_VALOR 
//		_cRet	:= (Qry)->E5_VALOR 
	Else
		_cRet	:= ""
	EndIf

	
ElseIf _cCampo == "E5_VALOR"
  	_cRet	:= (Qry)->E5_VALOR    

ElseIf _cCampo == "nSaldo"

	cAliasRec := GetNextAlias()

	cQueryRe := " SELECT DISTINCT E5_DATA, E5_FORNECE, E5_CLIENTE, E5_IDENTEE, E5_NUMERO, E5_VALOR, E5_LOJA, E5_RECPAG, E5_PREFIXO,E5_PARCELA, E5_TIPO, E1_VALOR, E1_VALLIQ, E2_VALOR, E2_VALLIQ"
	cQueryRe += " FROM " + RetSqlName("SE5") + " SE5 " 
	cQueryRe += " LEFT JOIN SE1050 SE1
	cQueryRe += " ON SE1.E1_NUM = SE5.E5_NUMERO"
	cQueryRe += " AND SE1.E1_TIPO = SE5.E5_TIPO"
	cQueryRe += " AND SE1.E1_PREFIXO = SE5.E5_PREFIXO"
	cQueryRe += " AND SE1.D_E_L_E_T_=''"
	cQueryRe += " LEFT JOIN SE2050 SE2"
	cQueryRe += " ON SE2.E2_NUM = SE5.E5_NUMERO"
	cQueryRe += " AND SE2.E2_TIPO = SE5.E5_TIPO"
	cQueryRe += " AND SE2.E2_PREFIXO = SE5.E5_PREFIXO"
	cQueryRe += " AND SE2.D_E_L_E_T_ = ' '"
	cQueryRe += " WHERE "
	cQueryRe += " E5_FILIAL = '"+xFilial("SE5")+"' "   
	cQueryRe += " AND E5_IDENTEE = '"+(Qry)->E5_IDENTEE+"'"
	cQueryRe += " AND E5_TIPO = '"+(Qry)->E5_TIPO +"'" 
	cQueryRe += " AND E5_TIPO != 'TX'"
	cQueryRe += " AND SE5.D_E_L_E_T_ = ' ' "      

	TCQUERY cQueryRe NEW ALIAS 'cAliasRec'
	
//	cQueryRe := ChangeQuery(cQueryRe)
	
//	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryRe), cAliasRec , .F., .T.)
          
                                               
//////////////////////////////////////////// 01/06
   
    Count To nReccAliasRec       
    
    cAliasRec->(DbGoTop() )
    
	If (Qry)->E5_IDENTEE <> nCompensa
		
		nXCSU := 1     
		nVlrRec := 0
		aArrayPa := {}
		
		While !("cAliasRec")->(Eof() )
			
			If ("cAliasRec")->E5_RECPAG == "R"	
				nVlrRec += ("cAliasRec")->E1_VALLIQ //E1_VALOR	    
				AADD(aArrayRe, ("cAliasRec")->E1_VALLIQ) //E1_VALOR)	
			Else
				nVlrPag += ("cAliasRec")->E2_VALOR	
				AADD(aArrayPa, ("cAliasRec")->E2_VALOR)
			EndIf 
			
		("cAliasRec")->(dbSkip()) 
	
		EndDo 
		
    	nCompensa := (Qry)->E5_IDENTEE
    
    EndIf
              
	If !Empty((Qry)->E5_CLIENTE) //Valor Recebimento  
	    
//RECEBIMENTO
		dbSelectArea("SE1")
		dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		DbSeek(xFilial("SE1")+(Qry)->E5_CLIENTE+(Qry)->E5_LOJA+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO) 


//PAGAR
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

   		DbSeek(xFilial("SE2")+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO+(Qry)->E5_FORNECE+(Qry)->E5_LOJA) 
   		 
		For nY := 1 To Len(aArrayPa)
			If nY == 1
				nVlrPag := aArrayPa[nY]
			Else
				nVlrPag += aArrayPa[nY]
			EndIf
		Next
		
//		nVlrRec	:= SE1->E1_VALOR 
//		nVlrPag	:= SE2->E2_VALOR
//		nCalcSld := nVlrRec 		         //Solicitado pelo levi para retirar o Saldo do titulo (Recebimento - Pagamento)
		//If nReccAliasRec == 1
		//	nCalcSld := nVlrRec 		         //Solicitado pelo levi para deixar somente o total do recebimento
		If nConComp == Len(aArrayRe)
			nCalcSld += aArrayRe[nConComp]//nVlrRec
			nConComp := 1
			aArrayRe := {}
		ElseIf nConComp >= 1 .And. nConComp <= Len(aArrayRe)
			nCalcSld += aArrayRe[nConComp] //nVlrRec
//		Else
			nConComp++
		EndIf
        //
	    //Calcula Recebimento
//		nCalcSld := nVlrRec - nVlrPag

		_cRet	:= IIF(nCalcSld >= 0, nCalcSld, 0)    //SE1->E1_SALDO //E1_VALLIQ 
		
		If nConComp > Len(aArrayRe) .Or. Empty(aArrayRe)
			nCalcSld := 0  
		EndIf
	/*
	ElseIf !Empty((Qry)->E5_FORNECE) //Valor pagamento   // Solicitado pelo levi para retirar o Saldo do titulo (Recebimento - Pagamento )
        
        
//RECEBIMENTO
		dbSelectArea("SE1")
		dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

		DbSeek(xFilial("SE1")+(Qry)->E5_CLIENTE+(Qry)->E5_LOJA+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO) 


//PAGAR
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

   		DbSeek(xFilial("SE2")+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO+(Qry)->E5_FORNECE+(Qry)->E5_LOJA)         
        
        
        
        
                                     
		//Calcula valor do Pagamento
		If !Empty(nVlrRec) // Abater o saldo recebido
			If nXCSU == 1
				nCalcSld := 0
				nCalcSld := aArrayPa[nXCSU] - (nVlrRec + nCalcSld) //(aArrayRe[nX] + nCalcSld)

				If NEGATIVO(nCalcSld)
					nCalcSld := -(nCalcSld)
				EndIf

			Else
				nCalcSld := aArrayPa[nXCSU] - nCalcSld 
				
				If NEGATIVO(nCalcSld)
					nCalcSld := -(nCalcSld)
				EndIf
			EndIf
			  
		Else // Se nao tiver saldo recebido, somar todo o saldo para pagamento
			nCalcSld := nVlrPag 
		EndIf

		_cRet	:= nCalcSld //E2_VALLIQ 
		
		nXCSU++
		
		
	*/	
	EndIf	
    
    If Select("cAliasRec") > 0
    	DBSelectArea("cAliasRec")
    	DBCloseArea()
    EndIf       


///////////////////////////////////////////////  01/06
/*                                                                        

	While !(cAliasRec)->(Eof() )
		
		If (cAliasRec)->E5_RECPAG == "R"	
			nVlrRec += (cAliasRec)->E5_VALOR	
		Else
			nVlrPag += (cAliasRec)->E5_VALOR	
		EndIf 
		
	(cAliasRec)->(dbSkip()) 

	EndDo 

//	(cAliasRec)->(dbGotop())
	
	If !Empty((Qry)->E5_CLIENTE) //Valor Recebimento         

	    //Calcula Recebimento
		nCalcSld := nVlrRec - nVlrPag

		_cRet	:= IIF(nCalcSld >= 0, nCalcSld, 0)    //SE1->E1_SALDO //E1_VALLIQ 
		
	ElseIf !Empty((Qry)->E5_FORNECE) //Valor pagamento 
                                     
		//Calcula valor do Pagamento
		nCalcSld := nVlrPag - nVlrRec

		_cRet	:= nCalcSld //E2_VALLIQ 
		
	EndIf	
                                                               
	
 		     
 /*	

	If !Empty((Qry)->E5_CLIENTE)         
		dbSelectArea("SE1")
		dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		

DbSeek(xFilial("SE1")+(Qry)->E5_CLIENTE+(Qry)->E5_LOJA+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_T

IPO) 

		_cRet	:= SE1->E1_SALDO //E1_VALLIQ 
		
	ElseIf !Empty((Qry)->E5_FORNECE) 
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		

DbSeek(xFilial("SE2")+(Qry)->E5_PREFIXO+(Qry)->E5_NUMERO+(Qry)->E5_PARCELA+(Qry)->E5_TIPO+(Qry)->E5_FORNECE+(Qry)->E5_L

OJA) 

		_cRet	:= SE2->E2_SALDO //E2_VALLIQ 
		
	EndIf
	*/
Endif               


Return _cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัอออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ  CriaSx1  บAutor  ณ  Eduardo Dias     บ Data ณ  08/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ CriaSx1: Verifica e cria um novo grupo de perguntas com บฑฑ
ฑฑบ             ณ base nos parโmetros fornecidos                          บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)
             
For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)
                                                             
RETURN