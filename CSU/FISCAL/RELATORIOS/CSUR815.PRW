#include "protheus.ch"
#include "TOPCONN.CH"   
#include "apcfg40.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUR815  ³ Autor ³ FERNANDO BARRETO      ³ Data ³ABRIL/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³      RELATÓRIO RETENÇÕES NA FONTE - EFD	     			  ³±±
±±³			 ³ com o objetivo de atender o chamado 0819/12				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUR815()
Local wnrel:= "CSURETEN"
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "RELATÓRIO RETENÇÕES NA FONTE - EFD"
Local cDesc1     := "RELATÓRIO RETENÇÕES NA FONTE - EFD"
Local cDesc2     := " " //"RELATÓRIO RETENÇÕES NA FONTE - EFD"
Local cDesc3     := " "
Local Pg		 := "CSUR815"
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administração"
Private nomeprog := "EFD"
Private nLastKey
Private cString  := ""
PRIVATE M_PAG:=1

ValidPerg(Pg)
Pergunte(Pg,.T.)
wnrel := SetPrint(cString,wnrel,Pg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,{},,tamanho,,.T.)
If nLastKey = 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
EndIf
Processa( {|lEnd| CSUR815A(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUR815A ³ Autor ³ FERNANDO BARRETO      ³ Data ³ABRIL/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CSUR815A(lEnd)
Local wnrel:= "CSURETEN"
Local titulo     := "RELATÓRIO RETENÇÕES NA FONTE - EFD"
Private cCabec1  := ''
Private cCabec2  := ''
Private cCabec3  := ""
Private nTamanho := "G"
Private ctitulo  := "RELATÓRIO RETENÇÕES NA FONTE - EFD"
Private cCli	:=''       
Private	nTitulo:=0 
Private	nTotal:=0 
Private nIRRF:=0
Private nINSS:=0
Private nPis:=0
Private nCofin:=0
Private nISS:=0
Private nCSLL:=0  
Private nPag:=0
Private nLiq:=0  
Private nRec:=0
PRIVATE aCabExcel:={}    
Private aItensExcel:={}  
Private C1:=''
Private C2:=''
Private C3:=''
Private C4:=''
Private C5:=''
Private C6:=''
Private C7:=''
Private C8:=''
Private C9:=''
Private C10:=''
Private C11:=''
Private C12:=''
Private C13:=''
Private C14:=''
Private C15:=''
Private C16:=''
Private C17:=''
Private C18:=''
Private C19:=''
Private C20:=''
Private C21:=''
Private C22:=''

/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|	RELATORIO RETENCOES NA FONTE - EFD		         |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/
	//CRIA CABECALHO
		AADD(aCabExcel, {"FILIAL" ,"C", 03, 0}) 
		AADD(aCabExcel, {"DOC" ,"C", 70, 0})               
		AADD(aCabExcel, {"DATA EMISSAO" ,"C", 11, 0})           
		AADD(aCabExcel, {"DATA VENCIMENTO" ,"C", 70, 0})        
		AADD(aCabExcel, {"DATA BAIXA" ,"C", 10, 0})   
		AADD(aCabExcel, {"CODCLI" ,"C", 06, 0})
	  	AADD(aCabExcel, {"CNPJ" ,"C", 70, 0})  
	  	AADD(aCabExcel, {"NOME" ,"C", 07, 0})	  	   		
		AADD(aCabExcel, {"UNID. NEG." ,"C", 10, 0}) 		   
		AADD(aCabExcel, {"NATUREZA" ,"C", 10, 0})             
		AADD(aCabExcel, {"VALOR BRUTO NF" ,"C", 10, 0})     		
		AADD(aCabExcel, {"ISS RET" ,"C", 10, 0})
		AADD(aCabExcel, {"INSS RET" ,"C", 10, 0})  
		AADD(aCabExcel, {"IRRF RET" ,"C", 10, 0})   
		AADD(aCabExcel, {"PIS RET" ,"C", 10, 0}) 
		AADD(aCabExcel, {"COFINS RET" ,"C", 10, 0}) 
		AADD(aCabExcel, {"CSLL RET" ,"C", 10, 0})     
		AADD(aCabExcel, {"LIQUIDO A RECEBER" ,"C", 10, 0}) 
		AADD(aCabExcel, {"VALOR RECEBIDO" ,"C", 10, 0}) 
		AADD(aCabExcel, {"A RECEBER" ,"C", 10, 0}) 
		
	IF Select("CONS")>0
		CONS->(dbCloseArea())
	Endif   
	
  /*	IF  mv_par07=='1'      
		cVar:='E1_VENCREA' 
	else
		cVar:='E1_BAIXA'    
	endif*/
		

	cCONS :="SELECT DISTINCT A1_COD,E1_TIPO,A1_LOJA,A1_NOME,A1_CGC,E1_NUM,E1_EMISSAO,E1_VENCREA,E1_BAIXA,E1_NATUREZ, "
	cCONS +="E1_INSS,E1_VRETIRF,E1_SABTPIS,E1_SABTCOF,E1_SABTCSL,E1_ISS,E1_VALOR,BM_DESC,E1_VALLIQ,(E1_VALLIQ-E1_SALDO) AS RECEBIDO, "
//   	cCONS +="(E1_VALOR-E1_IRRF-E1_INSS-E1_PIS-E1_COFINS-E1_CSLL-F2_VALISS) VALLIQ,(E1_VALOR-E1_SALDO-E1_IRRF-E1_INSS-E1_PIS-E1_COFINS-E1_CSLL-F2_VALISS)PAGO,(E1_SALDO) AS ARECEBER,
	cCONS +="E1_SALDO,F2_FILIAL "
	cCONS +="FROM "+RetSqlName('SE1')+" SE1, " +RetSqlName('SA1')+" SA1,"+RetSqlName('SF2')+" SF2, "+RetSqlName('SBM')+" SBM, "+RetSqlName('SD2')+" SD2 "
	cCONS +="WHERE E1_CLIENTE = A1_COD "
	cCONS +="AND E1_LOJA = A1_LOJA "
   	cCONS +="AND F2_FILIAL between '"+mv_par01+"' AND '"+mv_par02+"' "     
 	cCONS +="AND A1_COD between '"+mv_par03+"' AND '"+mv_par04+"' "
	cCONS +="AND E1_EMISSAO between '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"' "
  	cCONS +="AND E1_VENCREA between '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "   
  	cCONS +="AND E1_BAIXA between '"+DTOS(mv_par09)+"' AND '"+DTOS(mv_par10)+"' "   
//  	cCONS +="AND "+cVar+" between '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "   
	cCONS +="AND BM_GRUPO between '"+mv_par11+"' AND '"+mv_par12+"' " 
	cCONS +="AND E1_CLIENTE = F2_CLIENTE "
	cCONS +="AND E1_LOJA = F2_LOJA "
	cCONS +="AND E1_NUM = F2_DOC "
	cCONS +="AND E1_PREFIXO	= F2_SERIE " 
	cCONS +="AND D2_CLIENTE	= E1_CLIENTE "
	cCONS +="AND D2_DOC	= E1_NUM "
	cCONS +="AND D2_GRUPO = BM_GRUPO "
	cCONS +="AND E1_TIPO='NF'
	cCONS +="AND SF2.D_E_L_E_T_ != '*' "  
	cCONS +="AND SE1.D_E_L_E_T_ != '*' "
	cCONS +="AND SA1.D_E_L_E_T_ != '*' "
	cCONS +="ORDER BY 1"
    
	nCnt:= U_MontaView(cCons,"CONS")
	DBSELECTAREA("CONS")    
	CONS->(dbGoTop())  
	ProcRegua(nCnt)
   //	cCli:=CONS->A1_NOME          

	WHILE !CONS->(eof())
		IncProc("Processando EFD")      
	 	c1:="'"+CONS->A1_COD
	  //	C2:="'"+CONS->A1_LOJA 
	 	C3:=CONS->A1_NOME
		C4:="'"+CONS->A1_CGC
	   /*	IF C3!=cCli
	 		AADD(aItensExcel,{C1,C2,C3,C4,"Total de Titulos:",nTitulo,,nIRRF,nINSS,nPis,nCofin,nCSLL,nISS,nTotal,nLiq,nPag,nRec,})
	 		cCli:=C3
	 		nTitulo:=0               	
	 		nTotal:=0 
	 	    nIRRF:=0
	 	    nINSS:=0
	 	    nPis:=0
	 	    nCofin:=0
 	    	nISS:=0
 	    	nCSLL:=0 
 	    	nPag:=0
 	    	nLiq:=0
 	    	nRec:=0
	 	endif      */
		C5:="'"+CONS->E1_NUM
	   //	C6:=CONS->E1_TIPO
		C7:=STOD(CONS->E1_EMISSAO)
 	    C8:=STOD(CONS->E1_VENCREA)
 	    C9:=STOD(CONS->E1_BAIXA)
 	    C10:=CONS->E1_NATUREZ
 	    C11:=CONS->E1_VRETIRF
 	    C12:=CONS->E1_INSS
 	    C13:=CONS->E1_SABTPIS
 	    C14:=CONS->E1_SABTCOF 
 	    C15:=CONS->E1_SABTCSL
 	    C16:=CONS->E1_ISS
 	    C17:=CONS->BM_DESC
 	    C18:=CONS->E1_VALOR
 	    C19:=CONS->E1_VALLIQ
 	    C20:=CONS->RECEBIDO
 	    C21:=CONS->E1_SALDO
 	    C22:=CONS->F2_FILIAL	
 	    /*nTitulo++
 	    nTotal+=C18
 	    nIRRF+=C11		
 	    nINSS+=C12
 	    nPis+=C13
 	    nCofin+=C14
 	    nISS+=C16
 	    nCSLL+=C15 
    	nPag+=C20
    	nLiq+=C19
    	nRec+=C21 	    */
	  	AADD(aItensExcel,{C22,C5,C7,C8,C9,C1,C4,C3,C17,C10,C18,C16,C12,C11,C13,C14,C15,C19,C20,C21,}) 	   
		DBSKIP()
	enddo               
  //	AADD(aItensExcel,{C1,C2,C3,C4,"Total de Titulos:",nTitulo, ,nIRRF,nINSS,nPis,nCofin,nCSLL,nISS,nTotal,nLiq,nPag,nRec,})
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
	{||DlgToExcel({{"GETDADOS", "RELATÓRIO RETENÇÕES NA FONTE - EFD", aCabExcel,aItensExcel}})})  

/*If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf  */
MS_FLUSH()

Return nil  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³ Fernando Barreto      ³ Data ³ABRIL/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função para criação do SX1 da rotina                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO)) 

aRegs:={}
aAdd(aRegs,{_cPerg,"01","Filial de           		  ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{_cPerg,"02","Filial ate           		  ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{_cPerg,"03","CLIENTE DE             	  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})
aAdd(aRegs,{_cPerg,"04","CLIENTE ATÉ	        	  ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})
aAdd(aRegs,{_cPerg,"05","DATA DE EMISSÃO DE     	  ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"06","DATA DE EMISSÃO ATÉ     	  ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{_cPerg,"07","FILTAR POR DATA DE     	  ?","","","mv_ch7","N",01,0,0,"G","","mv_par07","VENCIMENTO","","","","","BAIXA","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"07","DATA DE VENCIMENTO DE     	  ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"08","DATA DE VENCIMENTO ATÉ       ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"09","DATA DE BAIXA DE		  	  ?","","","mv_ch9","D",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"10","DATA DE BAIXA ATÉ 	     	  ?","","","mv_ch10","D",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"11","UNID. DE NEGOCIO DE      	  ?","","","mv_ch11","C",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","",""})
aAdd(aRegs,{_cPerg,"12","UNID. DE NEGOCIO ATÉ   	  ?","","","mv_ch12","C",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])//SALVA O CONTEUDO DO ARRAY NO BANCO
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return