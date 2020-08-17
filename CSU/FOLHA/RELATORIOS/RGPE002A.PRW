#INCLUDE "rwmake.ch"

/*
±±ºPrograma  ³RGPE002   º Autor ³Ricardo Duarte Costaº Data ³  27/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de Salarios.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CARDSYSTEM S/A                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Importante:  Tratar salario para aparecer apenas no relatorio do modulo
                Gestao de pessoal.
   Data: 03/08/07: Claudinei E.N. : especifico somente para Sra.Aline
                   Foram substituidos os campos unid.negoci, operacoes e
                   data de nascimento por cod e descricao de cargo
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RGPE002A()
//Declaracao de variaveis
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "CARGOS X FUNÇÕES"
Local cPict         := ""
Local titulo       	:= ""
Local nLin         	:= 80  
Local Cabec2		:="Fil Secao          Descricao Secao                       Matric  CPF           RG                      Nome                             Data Adm.  Cargo                              Salario  GS Nasc.    Sexo Sit Hr Mês"
Local Cabec1       	:= ""
Local imprime      	:= .T.
Local aOrd 	:= {}
Local aOld	:= getarea()
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RGPE002A"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private _CPERG       := PADR("RGP02A",LEN(SX1->X1_GRUPO))
Private cbtxt	   	 := Space(10)
Private cbcont		 := 00
Private CONTFL		 := 01
Private m_pag		 := 01
Private cDet		 := ""
Private nTotSal		 := 0
Private nTotFunc	 := 0
Private nTotSalG	 := 0
Private nTotFuncG	 := 0
Private cFilAnt		 := ""   
Private CodCargo		 := ""
Private aInfo		 := {}
Private aStru		 := {}
Private cArqTrab	 := ""
Private cArqTrab1	 := ""
Private wnrel		 := "RGPE02A"
Private cString 	 := "SRA"   

fPerg()
pergunte(_CPERG,.F.)

if allTrim(cModulo) == "GPE"
	titulo := "CARGOS x FUNÇÕES"
else
	if allTrim(cModulo) == "MDT"
		titulo := "CARGOS x FUNÇÕES"
	end
end

//Monta a interface padrao com o usuario...                           ³
wnrel := SetPrint(cString,NomeProg,_CPERG,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
  Return
Endif

nTipo := If(aReturn[4]==1, 15, 18)

// Carrega os parametros
cFilde		:= mv_par01		//	Filial De
cFilAte		:= mv_par02		//	Filial Ate
cCCDe		:= mv_par03		//	Centro de Custos De
cCCAte		:= mv_par04 	//	Centro de Custos Ate
cMatDe		:= mv_par05		//	Matricula De
cMatAte		:= mv_par06 	//	Matricula Ate
cSitFolha	:= mv_par07		//	Situacoes a imprimir
cCategoria	:= mv_par08		//	Categorias a imprimir
lImprime	:= mv_par09==1	//	Tipo de Saida
cCaminho	:= mv_par10		//	Caminho e nome do arquivo a exportar.
//lCodFuncao	:= mv_par11==1	//	Lista ou nao lista o codigo da funcao.

//Busca as informacoes a imprimir no relatorio de reajustes
Processa({|lEnd| fDet()}, 'Criando arquivo temporario...')

if lImprime == .T.
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
else
	if lImprime == .F.
		Processa({|lEnd| RunProc()}, 'Gerando arquivo...')
	end
endif

//Fecha e exclui os arquivos temporarios de trabalho.
//close TRB
dbCloseArea("TRB")
fErase(cArqTrab)

RESTAREA( aOld )

Return

/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  27/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//local nOrdem  //inibido por Claudinei em 30/07/07: nao esta sendo utilizado em lugar algum do programa
	Cabec2		:= "Fil C.Custo           Descricao                  Matric CPF         RG          Nome                                   Data Adm.  Cargo                               Funcao                                 Salario   GS Sexo Sit Hr.Mes"

dbSelectArea("TRB")
dbgotop()

//SETREGUA -> Indica quantos registros serao processados para a regua
cFilAnt := TRB->FILIAL

//cCCAnt:=TRB->CC
fInfo(@aInfo,TRB->FILIAL)
cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()
	incregua()
   //Verifica o cancelamento pelo usuario...
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If cFilAnt <> TRB->FILIAL
		@nLin,17 PSAY	"Filial: " + transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(57) +;
						"Total : " + transform(nTotSal, "@E 999,999,999.99")
		nTotFunc	:= 0
		nTotSal		:= 0
		nLin		:= 80
		fInfo(@aInfo,TRB->FILIAL)
		cFilAnt		:= TRB->FILIAL
		cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)  
   Endif                 

   //Impressao do cabecalho do relatorio. . .
   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
      nLin := 9
   Endif    
	cDet	:= TRB->FILIAL+ " "
	cDet	:= cDet + " " + TRB->CC
	cDet	:= cDet + " "  + TRB->DESCCC
	cDet	:= cDet + " "  + TRB->MAT
	cDet	:= cDet + " "  + TRB->CIC
  cDet := cDet + " " + TRB->CODRG	 //Alterado sobre solicitacao 551 250107

	*-----------\/---------  OS 3232/04
	cDet	:= cDet + " "  + TRB->NOME
	set century on
	cDet	:= cDet + " "  + DTOC(TRB->ADMISSA)
	set century off
  cDet  := cDet + " " + TRB->CODCAR
  cDet  := cDet + "" + TRB->DESCAR
	cDet	:= cDet + " " + TRB->CODFUN   //incluido por Claudinei E.N. em 19/07/07:imprimir codigo da funcao quando selecionado parametro mv_par09 "Funcao"
	cDet	:= cDet + "" + TRB->DCARGO  //03/08/07 Claudinei E.N.: 

 *-----------\/--------- aaj011004 OS 2564/04
	if alltrim(cModulo) == "GPE"                                   
		cDet	:= cDet + " " + transform(TRB->SALARIO,"@E 9,999,999.99")
	ELSE
		cDet	:= cDet + " " + transform(TRB->SALARIO,"@E 9,999,999.99")
    ENDIF
    *-----------/\--------- aaj011004 OS 2564/04
	cDet	:= cDet + " "   + TRB->GS
	set century on
	cDet	:= cDet + " "   + DTOC(TRB->NASC)
	set century off
	cDet	:= cDet + " " + TRB->SEXO
	cDet	:= cDet + " " + TRB->SITFOLH + "  "
	cDet	:= cDet + " "  + transform(TRB->HRSMES,"@E 999.99")
	
	nTotFunc	:= nTotFunc  + 1
	nTotFuncG	:= nTotFuncG + 1
	nTotSal		:= nTotSal   + TRB->SALARIO
	nTotSalG	:= nTotSalG  + TRB->SALARIO

   // Impressao do documento
   @nLin,00 PSAY cDet
   cDet	:= ""

   nLin := nLin + 1 // Avanca a linha de impressao

   dbselectarea("TRB")
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//Impressao do cabecalho do relatorio. . .
If nLin > 60 // Salto de Página. 
   Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   nLin := 9
Endif

//Impressao dos totais de funcionarios
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,17 PSAY	"Filial: " + transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Total : " + transform(nTotSal, "@E 999,999,999.99")
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,17 PSAY	"Geral:  " + transform(nTotFuncG,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Total : " + transform(nTotSalG, "@E 999,999,999.99")
				
nLin := nLin +3
@nLin, 03 PSAY "Legenda/Sit.: N=Normal, A=Afastado, D=Demitido, F=Ferias e T=Transferido

//Finaliza a execucao do relatorio...
SET DEVICE TO SCREEN

//Se impressao em disco, chama o gerenciador de impressao...
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

/*Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg*/
aAdd(aRegs,{_CPERG,'01' ,'Filial De          ?',''				 ,''			 ,'mv_ch1','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'02' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch2','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'03' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch3','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'04' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch4','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,REPLICATE('Z',09) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'05' ,'Matricula De       ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'06' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'07' ,'Situa‡”es  a Impr. ?',''				 ,''			 ,'mv_ch7','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'08' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_ch8','C'  ,12     ,0      ,0     ,'G','fCategoria                      ','mv_par08','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'09' ,'Tipo de Saida      ?',''				 ,''			 ,'mv_ch9','C'  ,01     ,0      ,1     ,'C','                                ','mv_par09','Relatorio      '  ,''		 ,''	 ,'                ',''   ,'Arquivo',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'10' ,'Caminho do Arquivo ?',''				 ,''			 ,'mv_cha','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
//aAdd(aRegs,{_CPERG,'11' ,'Lista Codigo Funcao?',''				 ,''			 ,'mv_chb','C'  ,01     ,0      ,1     ,'C','                                ','mv_par11','Sim            '  ,''		 ,''	 ,'                ',''   ,'Nao',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})

//³ Carrega as Perguntas no SX1                                  ³
ValidPerg(aRegs,_CPERG)

Return NIL

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fDet      ³ Autor ³Ricardo Duarte Costa   ³ Data ³27/08/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Cria o arquivo temporario para impressao ou gravacao arquivo³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function fDet()

Local nSalAnt	:= 0
Local nSalAtu	:= 0
Local nPerc		:= 0

aAdd(aStru,{"FILIAL"	,"C",02,0})
aAdd(aStru,{"CC"		,"C",17,0})    //alterado por Claudinei em 19/07/07: campo estava trazendo 17 caracteres -07 espacos desnecessarios
aAdd(aStru,{"DESCCC"	,"C",26,0})  //alterado por Claudinei em 19/07/07: campo estava trazendo 40 caracteres -10 espacos desnecessarios
aAdd(aStru,{"CCONTD", "C",09,0})  //09/08/07-Claudinei E.N.: incluido para gravar centro de custo novo
aAdd(aStru,{"MAT"		,"C",06,0})   
aAdd(aStru,{"CIC"		,"C",11,0})
aAdd(aStru,{"CODRG"      ,"C",11,0})  //alterado por Claudinei em 19/07/07: campo estava trazendo 15 caracteres -4 espacos desnecessarios
aAdd(aStru,{"NOME"		,"C",38,0})    //alterado dia 26/01/07
aAdd(aStru,{"ADMISSA"	,"D",08,0})
aAdd(aStru,{"CODFUN"	,"C",05,0})  //alterado por Claudinei E.N. em 19/07/07: campo estava trazendo apenas 04 caracteres, mas há 5 caracteres cadastrados
aAdd(aStru,{"CODCAR"	,"C",06,0})  //incluido por Claudinei E.N. em 03/08/07: para atender a usuaria Aline
aAdd(aStru,{"DESCAR"	,"C",30,0})
aAdd(aStru,{"SALARIO"	,"N",12,2})
aAdd(aStru,{"GS"		,"C",02,0})
aAdd(aStru,{"NASC"		,"D",08,2})
aAdd(aStru,{"SEXO"		,"C",04,0})  //alterado por Claudinei E.N. em 19/07/07: melhor adequacao da informacao
aAdd(aStru,{"SITFOLH"	,"C",01,0})
aAdd(aStru,{"HRSMES"	,"N",06,2})
aAdd(aStru,{"DCARGO"	,"C",30,0}) //Incluido sob solicitação do sr. Kiti
cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

dbselectarea("SRA")
dbsetorder(2)
dbseek(cFilDe,.t.) // primeiro registro selecionado nos parametros
cFilAnt := SRA->RA_FILIAL

While !EOF() .and. SRA->RA_FILIAL <= cFilAte
	incproc()
	//Filtra os parametros selecionados......
	If	SRA->RA_FILIAL < cFilDe .or. SRA->RA_FILIAL > cFilAte .or. ;
		SRA->RA_CC < cCCde .or. SRA->RA_CC > cCCAte .or. ;
		SRA->RA_MAT < cMatDe .or. SRA->RA_MAT > cMatAte .or. ;
		! SRA->RA_SITFOLH $cSitFolha .or. ! SRA->RA_CATFUNC $cCategoria
		dbskip()
		loop
	Endif
            
	nSalAtu	:= IF(SRA->RA_CATFUNC $"G,H",SRA->RA_SALARIO*SRA->RA_HRSMES,SRA->RA_SALARIO)
	nPerc		:= noround( ( ( nSalAtu / nSalAnt ) - 1 ) * 100, 2 )
	
	reclock("TRB",.t.)
	TRB->FILIAL		:= SRA->RA_FILIAL
	TRB->CC			:= SRA->RA_CC
	TRB->DESCCC		:= POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
	TRB->CCONTD		:= POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_CCONTD")	//09/08/07 - Claudinei E.N.: grava no arquivo o centro de custo novo
	TRB->MAT		:= SRA->RA_MAT
	TRB->CIC		:= SRA->RA_CIC      
  TRB->CODRG   := SUBSTR(SRA->RA_RG,1,11)  //alterado mediante solicitacao 551 250107
	TRB->NOME		:= SUBS(SRA->RA_NOME,1,38)
	TRB->ADMISSA	:= SRA->RA_ADMISSA
	TRB->CODFUN		:= SRA->RA_CODFUNC
	TRB->DCARGO		:= POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	CODCARG := POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_CARGO")
	TRB->CODCAR := CODCARG  //03/08/07 Claudinei E.N.: incluido para atender solicitacao da usuaria Aline
	TRB->DESCAR := POSICIONE("SQ3",1,xfilial("SQ3")+CODCARG,"Q3_DESCSUM")  //03/08/07 Claudinei E.N.:

	if alltrim(cModulo) == "GPE"
		TRB->SALARIO	:= nSalAtu
	end

	if allTrim(cModulo) == "MDT"
		TRB->SALARIO	:= 00.00
	end

	*-----------/\--------- aaj290904 OS 2564/04
	TRB->GS			:= SRA->RA_GS
	TRB->NASC		:= SRA->RA_NASC
	TRB->SEXO		:= IIF(SRA->RA_SEXO == "M", "M  ", "F  ")  //30/07/07-Claudinei E.N.: adequacao para caber mais 6 caracteres do centro de custo
	TRB->SITFOLH	:= if(SRA->RA_SITFOLH==" ","N",SRA->RA_SITFOLH)
	TRB->HRSMES 	:= SRA->RA_HRSMES
	
	MSUNLOCK()
    
	dbselectarea("SRA")
	dbskip()
enddo

return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³RUNPROC   ³ Autor ³Ricardo Duarte Costa   ³ Data ³27/08/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Grava o arquivo temporario em disco.                        ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function RunProc()

Local aInfoF	:= {}
Local cFil		:= ""
//Apaga Arquivo Gravado anteriormente
If File(alltrim(cCaminho))
	If !fErase(alltrim(cCaminho)) == 0
		MsgAlert('O arquivo '+AllTrim(cCaminho)+'esta em uso por outra estacao !!! Libere o arquivo antes de tentar novamente . ')
		return
	EndIf	
Endif

aStru := {}
aAdd(aStru,{"FILIAL"	,"C",15,0})
aAdd(aStru,{"CC"		,"C",17,0})
aAdd(aStru,{"DESCCC"	,"C",40,0})
aAdd(aStru,{"CCONTD","C",09,0})
aAdd(aStru,{"CIC"		,"C",11,0})
aAdd(aStru,{"MAT"		,"C",06,0})
aAdd(aStru,{"NOME"		,"C",45,0})
aAdd(aStru,{"ADMISSA"	,"C",08,0})
aAdd(aStru,{"CODCAR"	,"C",06,0})
aAdd(aStru,{"DESCAR"	,"C",37,0})
aAdd(aStru,{"CODFUN"	,"C",05,0})  //alterado por Claudinei E.N. em 19/07/07: campo estava trazendo apenas 04 caracteres, mas há 5 caracteres cadastrados
aAdd(aStru,{"FUNCAO"	,"C",37,0})  //alterado por Claudinei E.N. em 23/07/07: imprime descricao da funcao em arquivo .txt
aAdd(aStru,{"SALARIO"	,"C",12,0})
aAdd(aStru,{"GS"		,"C",02,0})
aAdd(aStru,{"NASC"		,"C",08,0})
aAdd(aStru,{"SEXO"		,"C",04,0})
aAdd(aStru,{"SITFOLH"	,"C",06,0})
aAdd(aStru,{"HRSMES"	,"C",07,2})
//aAdd(aStru,{"ESCALA"	,"C",07,2}) esta no relatorio que a Melissa me enviou no dia 03/08/07
//aAdd(aStru,{"X"	,"C",07,2})
cArqTrab1	:= CriaTrab(aStru,.t.)
use &cArqTrab1 ALIAS TRB1 NEW

dbselectarea("TRB")
dbgotop()
cFil	:= TRB->FILIAL
fInfo(@aInfoF,TRB->FILIAL)

//Grava cabeçalho
reclock("TRB1",.t.)
	TRB1->FILIAL	:= "FILIAL"
	TRB1->CC		:= "CENTRO DE CUSTO"
	TRB1->DESCCC	:= "DESCR. C.C."
	TRB1->CCONTD := "CC Novo"
	TRB1->CIC		:= "CPF"
	TRB1->MAT		:= "MATR."
	TRB1->NOME		:= "NOME FUNC"
	TRB1->ADMISSA	:= "DT. ADM."
	TRB1->CODCAR	:= "COD.CARGO"
	TRB1->DESCAR	:= "DESCR. CARGO"
	TRB1->CODFUN	:= "COD.FUNCAO"
	TRB1->FUNCAO	:= "DESCR. FUNCAO"
	TRB1->SALARIO	:= "SALARIO"
	TRB1->GS	    := "GS"
	TRB1->NASC		:= "DT.NASC."
	TRB1->SEXO    := "SEXO"
	TRB1->SITFOLH := "STATUS"  //SITUAÇÃO DA FOLHA
	TRB1->HRSMES  := "HRS.MES"
//	TRB1->ESCALA  := "ESCALA"
//	TRB1->X  := "X"
TRB1->(msunlock())

do while !eof()
	incproc()
	reclock("TRB1",.t.)
		If cFil <> TRB->FILIAL
			fInfo(@aInfoF,TRB->FILIAL)
			cFil	:= TRB->FILIAL
		endif
		TRB1->FILIAL	:= aInfoF[1]
		TRB1->CC		:= TRB->CC
		TRB1->DESCCC	:= TRB->DESCCC
		TRB1->CCONTD := TRB->CCONTD //09/08/07-Claudinei: incluido para gravar o centro de custo novo no arquivo texto
		TRB1->CIC		:= TRB->CIC    
		TRB1->MAT		:= TRB->MAT
		TRB1->NOME		:= TRB->NOME
		TRB1->ADMISSA	:= SUBSTR(DTOS(TRB->ADMISSA),7,2)+SUBSTR(DTOS(TRB->ADMISSA),5,2)+SUBSTR(DTOS(TRB->ADMISSA),1,4)
		TRB1->CODCAR := TRB->CODCAR  //03/08/07 Claudinei E.N.: incluido para atender solicitacao da usuaria Aline
		TRB1->DESCAR := TRB->DESCAR
		TRB1->CODFUN	:= TRB->CODFUN
		TRB1->FUNCAO	:= TRB->DCARGO  //alterado por Claudinei E.N. em 23/07/07: TRB->FUNCAO substituido, por que nao existe na tabela TRB
		TRB1->SALARIO	:= transform(TRB->SALARIO,"@E 999999999.99")
		TRB1->GS		:= TRB->GS
		TRB1->NASC		:= SUBSTR(DTOS(TRB->NASC),7,2)+SUBSTR(DTOS(TRB->NASC),5,2)+SUBSTR(DTOS(TRB->NASC),1,4)
		TRB1->SEXO		:= TRB->SEXO
		TRB1->SITFOLH	:= TRB->SITFOLH
		TRB1->HRSMES	:= transform(TRB->HRSMES,"@E 999.99")
//		TRB1->ESCALA  := 
//		TRB1->X  := 
	MSUNLOCK()
	dbselectarea("TRB")
	dbskip()
enddo

dbclosearea("TRB")

//Copia o arquivo com o nome e o caminho indicados.
dbselectarea("TRB1")
copy to &(cCaminho) DELIMITED WITH ('"')

//close TRB1
fErase(cArqTrab1)

return