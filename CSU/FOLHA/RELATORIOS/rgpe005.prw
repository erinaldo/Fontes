#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPE005   º Autor ³Ricardo Duarte Costaº Data ³  03/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio / Exportacao de Demitidos.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CARDSYSTEM S/A                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGPE005


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELATORIO DE DEMITIDOS"
Local cPict          := ""
Local titulo       := "RELATORIO DE DEMITIDOS"
Local nLin         := 80
Local Cabec2		:= "Fl Matric Nome                            Funcao                          Secao           Demissao       Motivo              Causa        Tipo  Salario     Aviso     Multa    B.Inss    B.Inss 13 B.Fgts  B.Fgts 13"
Local Cabec1       := ""
Local imprime      := .T.
Local aOrd := {}
Local aOld	:= getarea()
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RGPE005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private _CPERG       := PADR("RGP005",LEN(SX1->X1_GRUPO))
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private cDet		:= ""
Private nTotSal		:= 0
Private nTotAviso	:= 0
Private nTotMulta	:= 0
Private nTotBInss	:= 0
Private nTotBIn13	:= 0
Private nTotBFgts	:= 0
Private nTotBFg13	:= 0
Private nTotFunc	:= 0
Private nTotSalG	:= 0
Private nTotAvisoG	:= 0
Private nTotMultaG	:= 0
Private nTotBInssG	:= 0
Private nTotBIn13G	:= 0
Private nTotBFgtsG	:= 0
Private nTotBFg13G	:= 0
Private nTotFuncG	:= 0
Private cFilAnt		:= ""
Private aInfo		:= {}
Private aStru		:= {}
Private cArqTrab	:= ""
Private cArqTrab1	:= ""
Private wnrel		:= "RGPE005" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRG"
fPerg()
pergunte(_CPERG,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_CPERG,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

// Carrega os parametros
dDtDemDe	:= mv_par01		//	Data de demissao de
dDtDemAte	:= mv_par02		//	Data de demissao ate
dDtGerDe	:= mv_par03		//	Data de geracao de
dDtGerAte	:= mv_par04		//	Data de geracao ate
cFilde		:= mv_par05		//	Filial De
cFilAte		:= mv_par06		//	Filial Ate
cCCDe		:= mv_par07		//	Centro de Custos De
cCCAte		:= mv_par08 	//	Centro de Custos Ate
cMatDe		:= mv_par09		//	Matricula De
cMatAte		:= mv_par10 	//	Matricula Ate
cSitFolha	:= mv_par11		//	Situacoes a imprimir
cCategoria	:= mv_par12		//	Categorias a imprimir
lImprime	:= mv_par13==1	//	Tipo de Saida
cCaminho	:= mv_par14		//	Caminho e nome do arquivo a exportar.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca as informacoes a imprimir no relatorio de reajustes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|lEnd| fDet()}, 'Criando arquivo temporario...')

if lImprime
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
else
	Processa({|lEnd| RunProc()}, 'Gerando arquivo...')
endif

//Fecha e exclui os arquivos temporarios de trabalho.
//close TRB
dbCloseArea("TRB")
fErase(cArqTrab)

RESTAREA( aOld )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  27/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea("TRB")
dbgotop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := TRB->FILIAL
fInfo(@aInfo,TRB->FILIAL)
cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()

	incregua()
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If cFilAnt <> TRB->FILIAL
		@nLin,30 PSAY	"Filial: "+transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(74) +;
						"Total : " + transform(nTotSal,"@E 999999999.99")+" "+;
						transform(nTotAviso,"@E 999999999.99")+" "+;
						transform(nTotMulta,"@E 999999999.99")+" "+;
						transform(nTotBInss,"@E 999999999.99")+" "+;
						transform(nTotBIn13,"@E 999999999.99")+" "+;
						transform(nTotBFgts,"@E 999999999.99")+" "+;
						transform(nTotBFg13,"@E 999999999.99")
		nTotFunc	:= 0
		nTotSal		:= 0
		nTotAviso	:= 0
		nTotMulta	:= 0
		nTotBInss	:= 0
		nTotBIn13	:= 0
		nTotBFgts	:= 0
		nTotBFg13	:= 0
		nLin		:= 80
		fInfo(@aInfo,TRB->FILIAL)
		cFilAnt		:= TRB->FILIAL
		cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
   Endif
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
      nLin := 9
   Endif
   
   If TRB->CODMOTIVO == "H" 
      _DescMotivo := "Dem.C/J.C.In.Empresa " 
   Elseif TRB->CODMOTIVO == "I" 
      _DescMotivo := "Dem.S/J.C.In.Empresa " 
   Elseif TRB->CODMOTIVO == "J" 
      _DescMotivo := "Pedido de Demissao   "    
   Elseif TRB->CODMOTIVO == "K" 
      _DescMotivo := "Dem.C/J. C.Inic.Func."          
   Elseif TRB->CODMOTIVO == "L" 
      _DescMotivo := "Outros Motivos Resc. "         
   Elseif TRB->CODMOTIVO == "M" 
      _DescMotivo := "Mudanca Regime Estat."              
   Elseif TRB->CODMOTIVO == "N" 
      _DescMotivo := "Transferencia	        "    
   Elseif TRB->CODMOTIVO == "S" 
      _DescMotivo := "Falecimento          " 
   Elseif TRB->CODMOTIVO == "U" 
      _DescMotivo := "Apos.C/ Resc.Contrato"         
   Elseif TRB->CODMOTIVO == "V" 
      _DescMotivo := "Apos.S/ Resc.Contrato"     
   Elseif TRB->CODMOTIVO == "1" 
      _DescMotivo := "Apos.Por Invalidez   "     
   Elseif TRB->CODMOTIVO == "2" 
      _DescMotivo := "Resc.P/Culpa Recipr. "
   Elseif TRB->CODMOTIVO == "3" 
      _DescMotivo := "Termino de Contrato  "                
   Elseif TRB->CODMOTIVO == "9" 
      _DescMotivo := "Falec Motiv P/Ac.Trab"                
   Endif    
      
	cDet	:= TRB->FILIAL
	cDet	:= cDet + " " + TRB->MAT
	cDet	:= cDet + " " + SUBS(TRB->NOME,1,30)
	cDet	:= cDet + " " + substr(TRB->FUNCAO,1,22)
//	cDet	:= cDet + "  " + TRB->CC
  	cDet	:= cDet + " " + SUBS(TRB->DESCCC,1,25)
	set century on
	cDet	:= cDet + " " + DTOC(TRB->DEMISSA)
	set century off
//	cDet	:= cDet + "  " + TRB->CODMOTIVO             
	cdet	:= cDet + "  " + _DescMotivo
	cdet    := cdet + "  " + TRB->CAUSADESL
	cDet 	:= cDet + "  " +Trb->Tipo
	cDet	:= cDet + "  " + transform(TRB->SALARIO,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->AVISO,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->MULTA,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->BINSS,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->BINSS13,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->BFGTS,"@E 999999.99")
	cDet	:= cDet + " " + transform(TRB->BFGTS13,"@E 999999.99")

	nTotFunc	:= nTotFunc + 1
	nTotSal		:= nTotSal + TRB->SALARIO
	nTotAviso	:= nTotAviso + TRB->AVISO
	nTotMulta	:= nTotMulta + TRB->MULTA
	nTotBInss	:= nTotBInss + TRB->BINSS
	nTotBIn13	:= nTotBIn13 + TRB->BINSS13
	nTotBFgts	:= nTotBFgts + TRB->BFGTS
	nTotBFg13	:= nTotBFg13 + TRB->BFGTS13

	nTotFuncG	:= nTotFuncG + 1
	nTotSalG	:= nTotSalG + TRB->SALARIO
	nTotAvisoG	:= nTotAvisoG + TRB->AVISO
	nTotMultaG	:= nTotMultaG + TRB->MULTA
	nTotBInssG	:= nTotBInssG + TRB->BINSS
	nTotBIn13G	:= nTotBIn13G + TRB->BINSS13
	nTotBFgtsG	:= nTotBFgtsG + TRB->BFGTS
	nTotBFg13G	:= nTotBFg13G + TRB->BFGTS13

   // Impressao do documento
   @nLin,00 PSAY cDet
   cDet	:= ""

   nLin := nLin + 1 // Avanca a linha de impressao

   dbselectarea("TRB")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   nLin := 9
Endif

// Impressao dos totais de funcionarios
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,30 PSAY	"Filial: "+transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(74) +;
				"Total : " + transform(nTotSal,"@E 999999.99")+" "+;
				transform(nTotAviso,"@E 999999.99")+" "+;
				transform(nTotMulta,"@E 999999.99")+" "+;
				transform(nTotBInss,"@E 999999.99")+" "+;
				transform(nTotBIn13,"@E 999999.99")+" "+;
				transform(nTotBFgts,"@E 999999.99")+" "+;
				transform(nTotBFg13,"@E 999999.99")
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,30 PSAY	"Geral:  "+transform(nTotFuncG,"@E 99,999") + " Funcionario(s) " + space(74) +;
				"Total : " + transform(nTotSalG,"@E 999999.99")+" "+;
				transform(nTotAviso,"@E 999999.99")+" "+;
				transform(nTotMulta,"@E 999999.99")+" "+;
				transform(nTotBInss,"@E 999999.99")+" "+;
				transform(nTotBIn13,"@E 999999.99")+" "+;
				transform(nTotBFgts,"@E 999999.99")+" "+;
				transform(nTotBFg13,"@E 999999.99")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fPerg     ³ Autor ³Ricardo Duarte Costa   ³ Data ³26/08/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Grava as Perguntas utilizadas no Programa no SX1            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fPerg()

Local aRegs     := {}

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aAdd(aRegs,{_CPERG,'01' ,'Data Demissao de   ?',''				 ,''			 ,'mv_ch1','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'02' ,'Data Demissao ate  ?',''				 ,''			 ,'mv_ch2','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'03' ,'Data Geracao de    ?',''				 ,''			 ,'mv_ch3','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'04' ,'Data Geracao ate   ?',''				 ,''			 ,'mv_ch4','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'05' ,'Filial De          ?',''				 ,''			 ,'mv_ch5','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0','','',''})
aAdd(aRegs,{_CPERG,'06' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch6','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0','','',''})
aAdd(aRegs,{_CPERG,'07' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch7','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT','','',''})
aAdd(aRegs,{_CPERG,'08' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch8','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par08','               '  ,''		 ,''	 ,REPLICATE('Z',20) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT','','',''})
aAdd(aRegs,{_CPERG,'09' ,'Matricula De       ?',''				 ,''			 ,'mv_ch9','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par09','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA','','',''})
aAdd(aRegs,{_CPERG,'10' ,'Matricula Ate      ?',''				 ,''			 ,'mv_cha','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA','','',''})
aAdd(aRegs,{_CPERG,'11' ,'Situa‡”es  a Impr. ?',''				 ,''			 ,'mv_chb','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par11','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'12' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_chc','C'  ,12     ,0      ,0     ,'G','fCategoria                      ','mv_par12','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'13' ,'Tipo de Saida      ?',''				 ,''			 ,'mv_chd','C'  ,01     ,0      ,1     ,'C','                                ','mv_par13','Relatorio      '  ,''		 ,''	 ,'                ',''   ,'Arquivo 	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})
aAdd(aRegs,{_CPERG,'14' ,'Caminho do Arquivo ?',''				 ,''			 ,'mv_che','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par14','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ','','',''})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas no SX1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg(aRegs,_CPERG)

Return NIL

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fDet      ³ Autor ³Ricardo Duarte Costa   ³ Data ³03/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Cria o arquivo temporario para impressao ou gravacao arquivo³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function fDet()

Local nSalAnt	:= 0
Local nSalAtu	:= 0
Local nPerc		:= 0               
Local nVezes    := 0     
Local _Tipo     := ""	

aAdd(aStru,{"FILIAL"	,"C",02,0})
aAdd(aStru,{"MAT"		,"C",06,0})
aAdd(aStru,{"NOME"		,"C",50,0})
aAdd(aStru,{"FUNCAO"	,"C",40,0})
aAdd(aStru,{"CC"		,"C",20,0})
aAdd(aStru,{"DESCCC"	,"C",40,0})
aAdd(aStru,{"DEMISSA"	,"D",08,0})
aAdd(aStru,{"CODMOTIVO"	,"C",01,0})
aAdd(aStru,{"MOTIVO"	,"C",55,0})
aAdd(aStru,{"CAUSADESL","C",12,0}) 
aAdd(aStru,{"TIPO"        ,"C",1,0})
aAdd(aStru,{"SALARIO"	,"N",12,2})
aAdd(aStru,{"AVISO"		,"N",12,2})
aAdd(aStru,{"MULTA"		,"N",12,2})
aAdd(aStru,{"BINSS"		,"N",12,2})
aAdd(aStru,{"BINSS13"	,"N",12,2})
aAdd(aStru,{"BFGTS"		,"N",12,2})
aAdd(aStru,{"BFGTS13"	,"N",12,2})
cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

dbselectarea("SRG")
dbsetorder(1)
dbseek(cFilDe+cMatDe+dtos(dDtGerDe),.t.) // primeiro registro selecionado nos parametros
cFilAnt := SRG->RG_FILIAL
vMatAdal := "xx"
While !EOF() .and. SRG->RG_FILIAL <= cFilAte

	incproc()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o cadastro do funcionario....                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! SRA->(DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT))
		dbselectarea("SRG")
		dbskip()
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra os parametros selecionados......                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SRG->RG_FILIAL < cFilDe .or. SRG->RG_FILIAL > cFilAte .or. ;
		SRA->RA_CC < cCCde .or. SRA->RA_CC > cCCAte .or. ;
		SRG->RG_MAT < cMatDe .or. SRG->RG_MAT > cMatAte .or. ;
		! SRA->RA_SITFOLH $cSitFolha .or. ! SRA->RA_CATFUNC $cCategoria .or. ;
		DTOS(SRG->RG_DATADEM) < DTOS(dDtDemDe) .or. DTOS(SRG->RG_DATADEM) > DTOS(dDtDemAte) .or. ;
		DTOS(SRG->RG_DTGERAR) < DTOS(dDtGerDe) .or. DTOS(SRG->RG_DTGERAR) > DTOS(dDtGerAte)
		dbselectarea("SRG")
		dbskip()
		loop
	Endif
  
	if vMatAdal = SRG->RG_MAT	
		nSalAtu := 0
		_Tipo    := "C."
	else
		nSalAtu		:= IF(SRA->RA_CATFUNC $"G,H",SRA->RA_SALARIO*SRA->RA_HRSMES,SRA->RA_SALARIO)
		_Tipo   := "N"
		vMatAdal := SRG->RG_MAT
	endif	
	
	reclock("TRB",.t.)
	TRB->FILIAL		:= SRG->RG_FILIAL
	TRB->MAT		:= SRG->RG_MAT
	TRB->NOME		:= SRA->RA_NOME
	TRB->FUNCAO		:= POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	TRB->CC			:= SRA->RA_CC
	TRB->DESCCC		:= POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
	TRB->DEMISSA	:= SRG->RG_DATADEM
	TRB->CODMOTIVO	:= SRA->RA_AFASFGT
	TRB->MOTIVO		:= TABELA("30",SRA->RA_AFASFGT,.F.)
	TRB->CAUSADESL  := IF(SRG->RG_MOTDEM==" ","            ",IF(SRG->RG_MOTDEM=="R","Red.  Quadro","Substituicao"))
	TRB->TIPO       := _Tipo
	TRB->SALARIO	:= nSalAtu
	TRB->AVISO		:= fBusca("1")
	TRB->MULTA		:= fBusca("2")
	TRB->BINSS		:= fBusca("3")
	TRB->BINSS13	:= fBusca("4")
	TRB->BFGTS		:= fBusca("5")
	TRB->BFGTS13	:= fBusca("6")
	MSUNLOCK()
    
	dbselectarea("SRG")
	dbskip()
enddo
	
return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³RUNPROC   ³ Autor ³Ricardo Duarte Costa   ³ Data ³03/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Grava o arquivo temporario em disco.                        ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function RunProc()

Local cFil		:= ""
Local aInfoF	:= {}

//Apaga Arquivo Gravado anteriormente
If File(alltrim(cCaminho))
	If !fErase(alltrim(cCaminho)) == 0
		MsgAlert('O arquivo '+AllTrim(cCaminho)+'esta em uso por outra estacao !!! Libere o arquivo antes de tentar novamente . ')
		return
	EndIf	
Endif

aStru := {}
aAdd(aStru,{"FILIAL"	,"C",15,0})
aAdd(aStru,{"MAT"		,"C",06,0})
aAdd(aStru,{"NOME"		,"C",50,0})
aAdd(aStru,{"FUNCAO"	,"C",40,0})
aAdd(aStru,{"CC"		,"C",20,0})
aAdd(aStru,{"DESCCC"	,"C",40,0})
aAdd(aStru,{"DEMISSA"	,"C",08,0})
aAdd(aStru,{"MOTIVO"	,"C",55,0})
aAdd(aStru,{"CAUSADESL","C",12,0})
aAdd(aStru,{"TIPO"	,"C",1,0})
aAdd(aStru,{"SALARIO"	,"C",12,0})
aAdd(aStru,{"AVISO"		,"C",12,0})
aAdd(aStru,{"MULTA"		,"C",12,0})
aAdd(aStru,{"BINSS"		,"C",12,0})
aAdd(aStru,{"BINSS13"	,"C",12,0})
aAdd(aStru,{"BFGTS"		,"C",12,0})
aAdd(aStru,{"BFGTS13"	,"C",12,0})
cArqTrab1	:= CriaTrab(aStru,.t.)
use &cArqTrab1 ALIAS TRB1 NEW

dbselectarea("TRB")
dbgotop()
cFil	:= TRB->FILIAL
fInfo(@aInfoF,TRB->FILIAL)
do while !eof()
	incproc()
	reclock("TRB1",.t.)

	If cFil <> TRB->FILIAL
		fInfo(@aInfoF,TRB->FILIAL)
		cFil	:= TRB->FILIAL
	endif
	TRB1->FILIAL	:= aInfoF[1]
	TRB1->MAT		:= 	TRB->MAT
	TRB1->NOME		:= 	TRB->NOME
	TRB1->FUNCAO	:= 	TRB->FUNCAO
	TRB1->CC		:=	TRB->CC
	TRB1->DESCCC	:=	TRB->DESCCC
	TRB1->DEMISSA	:= 	SUBSTR(DTOS(TRB->DEMISSA),7,2)+SUBSTR(DTOS(TRB->DEMISSA),5,2)+SUBSTR(DTOS(TRB->DEMISSA),1,4)
	TRB1->MOTIVO	:= 	TRB->MOTIVO  
	TRB1->CAUSADESL := TRB->CAUSADESL
	TRB1->TIPO      := TRB->Tipo
	TRB1->SALARIO	:= 	transform(TRB->SALARIO,"@E 999999.99")
	TRB1->AVISO		:= transform(TRB->AVISO,"@E 999999.99")
	TRB1->MULTA		:= transform(TRB->MULTA,"@E 999999.99")
	TRB1->BINSS		:= transform(TRB->BINSS,"@E 999999.99")
	TRB1->BINSS13	:= transform(TRB->BINSS13,"@E 999999.99")
	TRB1->BFGTS		:= transform(TRB->BFGTS,"@E 999999.99")
	TRB1->BFGTS13	:= transform(TRB->BFGTS13,"@E 999999.99")
	MSUNLOCK()
	dbselectarea("TRB")
	dbskip()
enddo

//Copia o arquivo com o nome e o caminho indicados.
dbselectarea("TRB1")
copy to &(cCaminho) DELIMITED WITH ('"')

//close TRB1
fErase(cArqTrab1)

return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fBusca    ³ Autor ³Ricardo Duarte Costa   ³ Data ³03/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Busca as Verbas Correspondentes a Aviso Previo, Multa FGTS, ³
³          ³Base de Inss, Base Inss 13o, Base FGTS e Base FGTS 13o.     ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function fBusca(tp)

Local nValAux	:= 0           
Local nValAux1 := 0
Local nValAux2 := 0
Local nValTot   := 0
Local aArea		:= getarea()	// Salva o ambiente
Local cPd		:= ""
Local cPd2		:= ""                               
Local cPd3		:= ""
Local cPd4		:= ""
Local cPd5		:= ""
Local cPd6		:= ""
Local cPd7		:= ""

if tp == "1"	// Aviso Previo
	cPd		:= posicione("SRV",2,xfilial("SRV")+"111","RV_COD")
elseif tp == "2"	// Multa FGTS
	cPd3	:= posicione("SRV",2,xfilial("SRV")+"293","RV_COD")
	cpd4    := posicione("SRV",2,xfilial("SRV")+"294","RV_COD")
	cpd5    := posicione("SRV",2,xfilial("SRV")+"118","RV_COD")
	cpd6    := posicione("SRV",2,xfilial("SRV")+"119","RV_COD")
	cpd7    := posicione("SRV",2,xfilial("SRV")+"214","RV_COD")
elseif tp == "3"	// Base Inss
	cPd		:= posicione("SRV",2,xfilial("SRV")+"013","RV_COD")
	cPd2	:= posicione("SRV",2,xfilial("SRV")+"014","RV_COD")
elseif tp == "4"	// Base Inss 13o salario
	cPd		:= posicione("SRV",2,xfilial("SRV")+"019","RV_COD")
	cPd2	:= posicione("SRV",2,xfilial("SRV")+"020","RV_COD")
elseif tp == "5"	// Base FGTS
	cPd		:= posicione("SRV",2,xfilial("SRV")+"017","RV_COD")
	cPd2	:= posicione("SRV",2,xfilial("SRV")+"293","RV_COD")
elseif tp == "6"	// Base FGTS 13o salario
	cPd		:= posicione("SRV",2,xfilial("SRV")+"108","RV_COD")
	cPd2	:= posicione("SRV",2,xfilial("SRV")+"294","RV_COD")
endif

dbselectarea("SRR")
dbsetorder(1)
// Primeira Verba
dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd)
if Found()
	do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd == ;
						 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
		nValAux		:= nValAux + SRR->RR_VALOR
		dbskip()
	enddo
endif
// Segunda Verba
if cPd2 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd2)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd2 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux		:= nValAux + SRR->RR_VALOR
			dbskip()
		enddo
	endif
endif

// 3a Verba - utilizado apenas para calculo de Multa
if cPd3 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd3)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd3 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux1		:= nValAux1 + NoRound((SRR->RR_VALOR*0.08),2)//Alterado o fator de multiplicacao de 0.85 para 0.8 conforme CLT.
			dbskip()
		enddo
	endif
endif
                                                                                                                         
// 4a Verba - utilizado apenas para calculo de Multa
if cPd4 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd4)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd4 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux1		:= nValAux1 +NoRound((SRR->RR_VALOR*0.08),2)//Alterado o fator de multiplicacao de 0.85 para 0.8 conforme CLT.
			dbskip()
		enddo
	endif
endif                                                                                                                  

// 5a Verba - utilizado apenas para calculo de Multa
if cPd5 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd5)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd5 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux2		:= nValAux2 + NoRound((SRR->RR_VALOR*0.50),2)
			dbskip()
		enddo
	endif
endif
                                                                                                                         
// 6a Verba - utilizado apenas para calculo de Multa
if cPd6 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd6)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd6 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux2		:= nValAux2 + NoRound((SRR->RR_VALOR*0.50),2)
			dbskip()
		enddo
	endif
endif
                                   
// 7a Verba - utilizado apenas para calculo de Multa
if cPd7 <> ""
	dbseek(SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd7)
	if Found()
		do while !eof() .and. SRG->RG_FILIAL+SRG->RG_MAT+"R"+DTOS(SRG->RG_DTGERAR)+cPd7 == ;
							 SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)+SRR->RR_PD
			nValAux2		:= nValAux2 + NoRound((SRR->RR_VALOR*0.50),2)
			dbskip()
		enddo
	endif
endif

nValtot := nValAux+nValAux1+nValAux2
// Retorna o ambiente
restarea(aArea)

return(nValTot)