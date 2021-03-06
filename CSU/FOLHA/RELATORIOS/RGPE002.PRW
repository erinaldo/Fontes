#INCLUDE "rwmake.ch"

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  �RGPE002   � Autor �Ricardo Duarte Costa� Data �  27/08/03   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Descricao �Relatorio de Salarios.                                      艮�
臼�          �                                                            艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � CSU CARDSYSTEM S/A                                         艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
臼 Importante:  Tratar salario para aparecer apenas no relatorio do modulo
                Gestao de pessoal.
   Data: 20/07/07: Claudinei E.N.
   					 incluido os campos RA_ITEMD=und.negocio RA_CLVLDB=operacoes,
                   no relatorio e no arquivo. Ajustes no layout do relatorio.
                   Melhoria no tratamento quando modulo == GPE ou == MDT.
烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝�*/

User Function RGPE002
//� Declaracao de Variaveis                                             �
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "RELATORIO DE SALARIOS"
Local cPict         := ""
Local titulo       	:= ""
Local nLin         	:= 80  
Local Cabec2		:="Fil Secao          Descricao Secao                       Matric  CPF           RG                      Nome                             Data Adm.  Cargo                              Salario  GS Nasc.    Sexo Sit Hr M�s"
Local Cabec1       	:= ""
Local imprime      	:= .T.
Local aOrd 	:= {}
Local aOld	:= getarea()
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RGPE002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private _CPERG       := PADR("RGP002",LEN(SX1->X1_GRUPO))
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
Private wnrel		 := "RGPE002" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := "SRA"   

fPerg()
pergunte(_CPERG,.F.)

if allTrim(cModulo) == "GPE"
	titulo := "RELATORIO DE SALARIOS"
else
	if allTrim(cModulo) == "MDT"
		titulo := "RELATORIO DE ATIVOS"
	end
end

//Monta a interface padrao com o usuario...                           �
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
lCodFuncao	:= mv_par11==1	//	Lista ou nao lista o codigo da funcao.

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
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  27/08/03   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 艮�
臼�          � monta a janela com a regua de processamento.               艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � Programa principal                                         艮�
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//local nOrdem  //inibido por Claudinei em 30/07/07: nao esta sendo utilizado em lugar algum do programa

if lCodFuncao    //por Claudinei E.N.: melhoria no tratamento da impressao do cabecalho - Alterado em 30/07/07
	if allTrim(cModulo) == "GPE"
		Cabec2		:= "Fil C.Custo           Descricao                  Matric CPF         RG          Nome                                   Data Adm.  Funcao                                 Salario   GS Dt.Nasc.   Sexo Sit Hr.Mes Oper Und.Neg."
	elseif allTrim(cModulo) == "MDT"
		Cabec2		:= "Fil C.Custo           Descricao                  Matric CPF         RG          Nome                                   Data Adm.  Funcao                                 Salario   GS Dt.Nasc.   Sexo Sit Hr.Mes Oper Und.Neg."
	endif
else
	if allTrim(cModulo) == "GPE"
		Cabec2		:= "Fil C.Custo           Descricao                  Matric CPF         RG          Nome                                   Data Adm.  Funcao                                 Salario   GS Dt.Nasc.   Sexo Sit Hr.Mes Oper Und.Neg."
	elseif allTrim(cModulo) == "MDT"
		Cabec2		:= "Fil C.Custo           Descricao                  Matric CPF         RG          Nome                                   Data Adm.  Funcao                                 Salario   GS Dt.Nasc.   Sexo Sit Hr.Mes Oper Und.Neg."
	endif
endif   

//inibido por Claudinei E.N. em 20.07.07: substituido pela rotina acima
//*-----------\/--------- aaj290904 OS 2564/04
//if alltrim(cModulo) != "GPE"

//	Cabec2		:= "Fil Secao            Descricao Secao                          Matric CPF         RG    Doc.Ident.(RG)  Nome                                          Data Adm.  Funcao                              GS Nascimento Sexo Sit Hr Mes"
//endif                                             
//*-----------/\--------- aaj290904 OS 2564/04

dbSelectArea("TRB")
dbgotop()
//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
cFilAnt := TRB->FILIAL
//cCCAnt:=TRB->CC
fInfo(@aInfo,TRB->FILIAL)
cabec1	:= padc(TRB->FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
SetRegua(RecCount())

do while !eof()

	incregua()
   //敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
   //� Verifica o cancelamento pelo usuario...                             �
   //青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
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
 

   //敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
   //� Impressao do cabecalho do relatorio. . .                            �
   //青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
   If nLin > 60 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
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
//	If alltrim(cModulo) != "GPE"      //alterado por Claudinei E.N. em 19/07/07
//	   cDet := cDet + " " + TRB->CODRG  //  alterado por Claudinei E.N. em 19/07/07
//	Endif                               //alterado por Claudinei E.N. em 19/07/07
	
	*-----------\/---------  OS 3232/04
	cDet	:= cDet + " "  + TRB->NOME
	set century on
	cDet	:= cDet + " "  + DTOC(TRB->ADMISSA)
	set century off

/*	if lCodFuncao
		cDet	:= cDet + " " + TRB->CODFUN
		cDet	:= cDet + " " + substr(TRB->FUNCAO,1,30)
	else
		cDet	:= cDet + " " + substr(TRB->FUNCAO,1,35)
	endif*/
	
//	If mv_par09==2   //S� quando for gera艫o de arquivo   //alterado por Claudinei E.N. em 20/07/07: para gerar os dados unidade de negocio e opera苺es em relat�rio e em arquivo
//		cDet	:= cDet + " "  + TRB->UN
//		cDet	:= cDet + " "  + TRB->OP
//	EndIf

	if lCodFuncao                          //incluido por Claudinei E.N. em 20/07/07: quando selecionado para imprmir "Cod.Funcao" (mv_par09)
		cDet	:= cDet + " " + TRB->CODFUN   //incluido por Claudinei E.N. em 19/07/07:imprimir codigo da funcao quando selecionado parametro mv_par09 "Funcao"
		cDet	:= cDet + TRB->DCARGO    //alterado por Claudinei E.N. em 19/07/07: imprimir descricao do cargo
	else
		cDet	:= cDet + " " + TRB->DCARGO + "      " //alterado por Claudinei E.N. em 19/07/07: caso selecionado que nao deseja imprimir o codigo da funcao sera impresso apenas a descricao da funcao
	endif

//	cDet	:= cDet + " " + transform(TRB->SALARIO,"@E 9,999,999.99") // aaj011004 OS 2564/04
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
	cDet	:= cDet + " "  + TRB->UN  //incluido por Claudinei E.N. em 19/07/07: imprimir unidade de negocio relacionada ao funcionario
	cDet	:= cDet + " "  + TRB->OP  //incluido por Claudinei E.N. em 19/07/07: imprimir  operacao relacionada ao funcionario

	
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

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� Impressao do cabecalho do relatorio. . .                            �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
If nLin > 60 // Salto de P�gina. 
   Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   nLin := 9
Endif

// Impressao dos totais de funcionarios
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,17 PSAY	"Filial: " + transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Total : " + transform(nTotSal, "@E 999,999,999.99")
nLin := nLin + 2 // Avanca a linha de impressao
@nLin,17 PSAY	"Geral:  " + transform(nTotFuncG,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Total : " + transform(nTotSalG, "@E 999,999,999.99")
				
nLin := nLin +3
@nLin, 03 PSAY "Legenda/Sit.: N=Normal, A=Afastado, D=Demitido, F=Ferias e T=Transferido

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� Finaliza a execucao do relatorio...                                 �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�

SET DEVICE TO SCREEN

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
敖陳陳陳陳賃陳陳陳陳陳堕陳陳陳堕陳陳陳陳陳陳陳陳陳陳陳堕陳陳賃陳陳陳陳陳�
�Fun��o    �fPerg     � Autor �Ricardo Duarte Costa   � Data �26/08/2003�
団陳陳陳陳津陳陳陳陳陳祖陳陳陳祖陳陳陳陳陳陳陳陳陳陳陳祖陳陳珍陳陳陳陳陳�
�Descri��o �Grava as Perguntas utilizadas no Programa no SX1            �
青陳陳陳陳珍陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�*/
Static Function fPerg()

Local aRegs     := {}

/*
敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
�           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg �
青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰*/
aAdd(aRegs,{_CPERG,'01' ,'Filial De          ?',''				 ,''			 ,'mv_ch1','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'02' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch2','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{_CPERG,'03' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch3','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'04' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch4','C'  ,20     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,REPLICATE('Z',09) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'CTT',''})
aAdd(aRegs,{_CPERG,'05' ,'Matricula De       ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'06' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{_CPERG,'07' ,'Situa��es  a Impr. ?',''				 ,''			 ,'mv_ch7','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'08' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_ch8','C'  ,12     ,0      ,0     ,'G','fCategoria                      ','mv_par08','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'09' ,'Tipo de Saida      ?',''				 ,''			 ,'mv_ch9','C'  ,01     ,0      ,1     ,'C','                                ','mv_par09','Relatorio      '  ,''		 ,''	 ,'                ',''   ,'Arquivo',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'10' ,'Caminho do Arquivo ?',''				 ,''			 ,'mv_cha','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{_CPERG,'11' ,'Lista Codigo Funcao?',''				 ,''			 ,'mv_chb','C'  ,01     ,0      ,1     ,'C','                                ','mv_par11','Sim            '  ,''		 ,''	 ,'                ',''   ,'Nao',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})

//� Carrega as Perguntas no SX1                                  �
ValidPerg(aRegs,_CPERG)

Return NIL

/*
敖陳陳陳陳賃陳陳陳陳陳堕陳陳陳堕陳陳陳陳陳陳陳陳陳陳陳堕陳陳賃陳陳陳陳陳�
�Fun��o    �fDet      � Autor �Ricardo Duarte Costa   � Data �27/08/2003�
団陳陳陳陳津陳陳陳陳陳祖陳陳陳祖陳陳陳陳陳陳陳陳陳陳陳祖陳陳珍陳陳陳陳陳�
�Descri��o �Cria o arquivo temporario para impressao ou gravacao arquivo�
青陳陳陳陳珍陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�*/
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
*-----------\/---------  OS 3232/04
//If AllTrim(cModulo) != "GPE"           //alterado por Claudinei em 20/0/07: para deixar de gerrar error.log: Fiedl name duplicated CODRG
//  aAdd(aStru,{"CODRG"      ,"C",15,0})
//Endif                              
*-----------\/---------  OS 3232/04
aAdd(aStru,{"NOME"		,"C",38,0})    //alterado dia 26/01/07
aAdd(aStru,{"ADMISSA"	,"D",08,0})
if lCodFuncao
	aAdd(aStru,{"CODFUN"	,"C",05,0})  //alterado por Claudinei E.N. em 19/07/07: campo estava trazendo apenas 04 caracteres, mas h� 5 caracteres cadastrados
endif
//aAdd(aStru,{"FUNCAO"	,"C",31,0})      //alterado dia 26/01/07   //alterado por Claudinei E.N. em 19/07/07: campo reduzido em 4 caracteres para adequar mais duas informacoes solicitadas pela usu�ria Marcia

//If mv_par09==2 //S� quando for gera艫o de arquivo
	aAdd(aStru,{"UN"	,"C",06,0})  //alterado por Claudinei E.N. em 19/07/07: imprimira 6 caracteres da unidade de negocio
	aAdd(aStru,{"OP"	,"C",09,0})
//EndIf

aAdd(aStru,{"SALARIO"	,"N",12,2})
aAdd(aStru,{"GS"		,"C",02,0})
aAdd(aStru,{"NASC"		,"D",08,2})
aAdd(aStru,{"SEXO"		,"C",04,0})  //alterado por Claudinei E.N. em 19/07/07: melhor adequacao da informacao
aAdd(aStru,{"SITFOLH"	,"C",01,0})
aAdd(aStru,{"HRSMES"	,"N",06,2})
aAdd(aStru,{"DCARGO"	,"C",30,0}) //Incluido sob solicita艫o do sr. Kiti
cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

dbselectarea("SRA")
dbsetorder(2)
dbseek(cFilDe,.t.) // primeiro registro selecionado nos parametros
cFilAnt := SRA->RA_FILIAL

While !EOF() .and. SRA->RA_FILIAL <= cFilAte

	incproc()
	//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
	//� Filtra os parametros selecionados......                             �
	//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
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
	*-----------\/---------  OS 3232/04

//	If Alltrim(cModulo) != "GPE"
//	   TRB->CODRG   := SRA->RA_RG
//	Endif
   *-----------\/---------  OS 3232/04
	TRB->NOME		:= SUBS(SRA->RA_NOME,1,38)
	TRB->ADMISSA	:= SRA->RA_ADMISSA
	if lCodFuncao
		TRB->CODFUN		:= SRA->RA_CODFUNC
	endif
//	TRB->FUNCAO		:= POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") //Retirado sob autoriza艫o do Sr. Kiti
	CODCARG			:= POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_CARGO")
	TRB->DCARGO		:= POSICIONE("SQ3",1,xfilial("SQ3")+CODCARG,"Q3_DESCSUM")

//	If mv_par09==2 //S� quando for gera艫o de arquivo
		TRB->UN	:= SUBSTR(SRA->RA_ITEMD,1,6)  //alterado por Claudinei E.N. em 19/07/07: trara ate 6 caracteres da unidade de negocio
		TRB->OP	:= SRA->RA_CLVLDB
//	EndIf
	
//	TRB->SALARIO	:= nSalAtu // aaj290904 OS 2564/04 
	*-----------\/--------- aaj290904 OS 2564/04
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
敖陳陳陳陳賃陳陳陳陳陳堕陳陳陳堕陳陳陳陳陳陳陳陳陳陳陳堕陳陳賃陳陳陳陳陳�
�Fun��o    �RUNPROC   � Autor �Ricardo Duarte Costa   � Data �27/08/2003�
団陳陳陳陳津陳陳陳陳陳祖陳陳陳祖陳陳陳陳陳陳陳陳陳陳陳祖陳陳珍陳陳陳陳陳�
�Descri��o �Grava o arquivo temporario em disco.                        �
青陳陳陳陳珍陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�*/
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
aAdd(aStru,{"MAT"		,"C",06,0})
aAdd(aStru,{"CIC"		,"C",11,0})
aAdd(aStru,{"CODRG"       ,"C",15,0}) //alterado mediante solicitacao 551 250107
*-----------\/---------  OS 3232/04
//If Alltrim(cModulo) != "GPE"             //alterado por Claudinei em 20/07/07: para deixar de gerrar error.log: Fiedl name duplicated CODRG
//  aAdd(aStru,{"CODRG"       ,"C",15,0})
//Endif
*-----------\/---------  OS 3232/04  
aAdd(aStru,{"NOME"		,"C",45,0})
aAdd(aStru,{"ADMISSA"	,"C",08,0})
//if lCodFuncao
	aAdd(aStru,{"CODFUN"	,"C",05,0})  //alterado por Claudinei E.N. em 19/07/07: campo estava trazendo apenas 04 caracteres, mas h� 5 caracteres cadastrados
	aAdd(aStru,{"FUNCAO"	,"C",37,0})  //alterado por Claudinei E.N. em 23/07/07: imprime descricao da funcao em arquivo .txt
//endif


//If mv_par09==2 //S� quando for gera艫o de arquivo  //alterado por Claudinei E.N. em 20/07/07: gravar dados no arquivo texto gerado
	aAdd(aStru,{"UN"	,"C",06,0})
	aAdd(aStru,{"OP"	,"C",09,0})
//EndIf

//aAdd(aStru,{"SALARIO"	,"C",12,0}) // aaj290904 OS 2564/04
*-----------\/--------- aaj290904 OS 2564/04
if alltrim(cModulo) == "GPE"
	aAdd(aStru,{"SALARIO"	,"C",12,0})
endif
*-----------/\--------- aaj290904 OS 2564/04
aAdd(aStru,{"GS"		,"C",02,0})
aAdd(aStru,{"NASC"		,"C",08,0})
aAdd(aStru,{"SEXO"		,"C",04,0})
aAdd(aStru,{"SITFOLH"	,"C",01,0})
aAdd(aStru,{"HRSMES"	,"C",06,2})
cArqTrab1	:= CriaTrab(aStru,.t.)
use &cArqTrab1 ALIAS TRB1 NEW

dbselectarea("TRB")
dbgotop()
cFil	:= TRB->FILIAL
fInfo(@aInfoF,TRB->FILIAL)

reclock("TRB1",.t.)    //09/08/07-Claudinei E.N.: incluido para gerar cabe�alho ao importar para excel
	TRB1->FILIAL	:= "FILIAL"
	TRB1->CC		:= "CENTRO DE CUSTO"
	TRB1->DESCCC	:= "DESCR. C.C."
	TRB1->CCONTD := "CC Novo"
	TRB1->MAT		:= "MATR"
	TRB1->CIC		:= "CPF"
	TRB1->CODRG		:= "RG"
	TRB1->NOME		:= "NOME FUNC"
	TRB1->ADMISSA	:= "DT.ADM."
	TRB1->CODFUN	:= "CODFUN"
	TRB1->FUNCAO	:= "DESCRFUNCAO"
	TRB1->UN	:= "UN"
	TRB1->OP	:= "OP"
	if alltrim(cModulo) == "GPE"
		TRB1->SALARIO	:= "SALARIO"
	endif
	TRB1->GS	    := "GS"
	TRB1->NASC		:= "DT.NASC."
	TRB1->SEXO    := "SEXO"
	TRB1->SITFOLH := "STATUS"  //SITUA巴O DA FOLHA
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
//	TRB1->FILIAL	:= TRB->FILIAL
	TRB1->CC		:= TRB->CC
	TRB1->DESCCC	:= TRB->DESCCC
	TRB1->CCONTD := TRB->CCONTD //09/08/07-Claudinei: incluido para gravar o centro de custo novo no arquivo texto
	TRB1->MAT		:= TRB->MAT
	TRB1->CIC		:= TRB->CIC    
  TRB1->CODRG      := TRB->CODRG //alterado mediante solicitacao 551 250107
//	*-----------\/---------  OS 3232/04  //alterado por Claudinei E.N. em 23/07/07: permitir a gravacao do RG no arquivo texto
//	If Alltrim(cModulo) != "GPE"
//	  TRB1->CODRG      := TRB->CODRG
//	Endif
	*-----------\/---------  OS 3232/04
	TRB1->NOME		:= TRB->NOME
	TRB1->ADMISSA	:= SUBSTR(DTOS(TRB->ADMISSA),7,2)+SUBSTR(DTOS(TRB->ADMISSA),5,2)+SUBSTR(DTOS(TRB->ADMISSA),1,4)

	if lCodFuncao
		TRB1->CODFUN	:= TRB->CODFUN
	end
	TRB1->FUNCAO	:= TRB->DCARGO  //alterado por Claudinei E.N. em 23/07/07: TRB->FUNCAO substituido, por que nao existe na tabela TRB
//	If mv_par09==2          //alterado por Claudinei E.N. em 19/07/07: Inibido para considerar geracao de informa艫o na gera艫o do arquivo ou do relatorio 
	TRB1->UN		:= TRB->UN  
	TRB1->OP		:= TRB->OP
//	EndIf	                  //alterado por Claudinei E.N. em 19/07/07: Inibido para considerar geracao de informa艫o na gera艫o do arquivo ou do relatorio
	
//TRB1->SALARIO	:= transform(TRB->SALARIO,"@E 999999999.99") //	aaj290904 OS 2564/04		
	*-----------\/--------- aaj290904 OS 2564/04
	if alltrim(cModulo) == "GPE"                                   
		TRB1->SALARIO	:= transform(TRB->SALARIO,"@E 999999999.99")
	ENDIF
	*-----------/\--------- aaj290904 OS 2564/04	

	TRB1->GS		:= TRB->GS
	TRB1->NASC		:= SUBSTR(DTOS(TRB->NASC),7,2)+SUBSTR(DTOS(TRB->NASC),5,2)+SUBSTR(DTOS(TRB->NASC),1,4)
	TRB1->SEXO		:= TRB->SEXO
	TRB1->SITFOLH	:= TRB->SITFOLH
	TRB1->HRSMES	:= transform(TRB->HRSMES,"@E 999.99")
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