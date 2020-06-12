#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR03  º Autor ³ TOTVS              º Data ³  05/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Rentabilidade Aplicacoes Financeiras          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FIFINR03


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Relatorio Rentabilidade"
Local titulo 	:= "Relatorio Rentabilidade"
Local nLin 		:= 80
Local Cabec1 	:= " Data       Saldo Anterior Historico                         Credito     Debito  IR s/Rend           Fator C.D.I     Sld Atual"
Local Cabec2 	:= ""
Local imprime 	:= .T.
Local aOrd 		:= {}

Private lEnd 			:= .F.
Private lAbortPrint 	:= .F.
Private limite			:= 80
Private tamanho 		:= "M"
Private nomeprog 		:= "FIFINR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private cbcont 			:= 00
Private CONTFL 			:= 01
Private m_pag 			:= 01
Private wnrel 			:= "FIFINR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SZI"
Private cPerg 			:= "FIFINR03"

_fCriaSX1()

dbSelectArea("SZI")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/09/13   º±±
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

dbSelectArea(cString)
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SZI")+MV_PAR01)
SetRegua(RecCount())

_cNumApl	:= SZI->ZI_NUMERO
_lFirst		:= .T.

_nTotIrPrev	:= 0
_nTotRend	:= 0

While !EOF() .and. mv_par01 <= SZI->ZI_NUMERO .and. mv_par02 >= SZI->ZI_NUMERO 


	If mv_par03 <= SZI->ZI_DATA .and. mv_par04 >= SZI->ZI_DATA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	
		If SZI->ZI_NUMERO <> _cNumApl
			nLin++ // Avanca a linha de impressao
			nLin++ // Avanca a linha de impressao
			@nLin,001 PSAY "TOTAL"
	
			@nLin,058 PSAY _nTotRend picture "@E 99,999,999.99" 					//TOTAL - Credito . Criar campo para gravar os RENDIMENTOS
			@nLin,080 PSAY _nTotIrPrev picture "@E 9,999,999.99"				//TOTAL - IR s/Rendimento
	
			_cNumApl	:= SZI->ZI_NUMERO
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			_lFirst	:= .T.
			_nTotIrPrev	:= 0
			_nTotRend	:= 0
	
	
		EndIf
	/*
	         1         2         3         4         5         6         7         8         9        10        11        12        13        14
	12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Data       Saldo Anterior Historico                           Credito       Debito  IR s/Rend           Fator C.D.I     Sld Atual
	99/99/9999  99.999.999,99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9,999.999,99 9,999.999,99 999.999,99 99.999,99999999 99,99 99.999.999,99
	*/
	
		If _lFirst //Imprime o cabeçalho da Aplicação
			@nLin,001 PSAY "Conta:        "+alltrim(SZI->ZI_CONTA)+" - "+POSICIONE("SA6",1,xFilial("SA6")+SZI->ZI_BANCO+SZI->ZI_AGENCI+SZI->ZI_CONTA,"A6_NOME")
			nLin++ // Avanca a linha de impressao
			nLin++ // Avanca a linha de impressao
			_lFirst	:= .F.
		EndIf

		_nValCred	:= IIF(SZI->ZI_STATUS$"3|5|7",SZI->ZI_VALOR,IIF(SZI->ZI_STATUS=="1",SZI->ZI_SALDO - SZI->ZI_SALDOAN,0))
		_nValDeb	:= IIF(SZI->ZI_STATUS$"2|4|6|8",SZI->ZI_VALOR,0)
	
		@nLin,001 PSAY SZI->ZI_DATA												 //Data
		@nLin,013 PSAY SZI->ZI_SALDOAN 	picture "@E 99,999,999.99"				 //Saldo Anterior
		@nLin,027 PSAY SZI->ZI_HIST												 //Historico
		@nLin,058 PSAY _nValCred 		picture "@E 9,999,999.99" 				 //Credito . Criar campo para gravar os RENDIMENTOS
		@nLin,071 PSAY _nValDeb 		picture "@E 9,999,999.99"   			 //Debito
		@nLin,084 PSAY SZI->ZI_VALIRF 	picture "@E 999,999.99"					 //IR s/Rendimento
		@nLin,095 PSAY SZI->ZI_FATOR 	picture "@E 99,999.99999999"			 //Fator CDB
		If SZI->ZI_TIPO == "C" //CDB
			_aAreaSZI := GetArea()
			DbSelectArea("SZJ") //Cadastro de Moedas (Indices)
			DbSetOrder(1)
			DbGotop()
			If DbSeek(xFilial("SZJ")+_cNumApl+dtoS(SZI->ZI_DATA),.t.)
				@nLin,111 PSAY SZJ->ZJ_CDI picture "@E 99.99"								 //Moeda diaria. Pegar da tabela SZJ
			EndIf
			RestArea(_aAreaSZI)
		Else
			@nLin,111 PSAY "00.00" picture "@E 99.99"								 // FUNDO
		EndIF
		@nLin,117 PSAY SZI->ZI_SALDO picture "@E 99,999,999.99"					 //Saldo
		
		nLin++ // Avanca a linha de impressao
		
	
		_nTotIrPrev	:= (_nTotIrPrev + SZI->ZI_VALIRF)
		_nTotRend	:= _nTotRend + IIF(SZI->ZI_STATUS$"5|7",SZI->ZI_VALOR,IIF(SZI->ZI_STATUS=="1",SZI->ZI_SALDO - SZI->ZI_SALDOAN,0))

	EndIf
		
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
EndDo

nLin++ // Avanca a linha de impressao
nLin++ // Avanca a linha de impressao
@nLin,001 PSAY "TOTAL"

@nLin,058 PSAY _nTotRend picture "@E 99,999,999.99" 					//TOTAL - Credito . Criar campo para gravar os RENDIMENTOS
@nLin,084 PSAY _nTotIrPrev picture "@E 9,999,999.99"				//TOTAL - IR s/Rendimento

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Microsiga           º Data ³  09/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Padr(cPerg,10)

/*
             grupo ,ordem,pergunt        ,perg spa       ,perg eng        , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02      ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3  ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Aplicacao De" ,"Aplicacao De" ,"Aplicacao De"  ,"mv_ch1","C" ,06 ,00 ,0  ,"G" ,""   ,"mv_par01",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SZH","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Aplicacao Ate","Aplicacao Ate","Aplicacao Ate" ,"mv_ch2","C" ,06 ,00 ,0  ,"G" ,""   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SZH","","","",""  })
aAdd(aRegs,{cPerg  ,"03" ,"Data De      ","Data De      ","Data De       ","mv_ch3","D" ,08 ,00 ,0  ,"G",""    ,"mv_par03",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""  })
aAdd(aRegs,{cPerg  ,"04" ,"Data Ate     ","Data Ate     ","Data Ate      ","mv_ch4","D" ,08 ,00 ,0  ,"G",""    ,"mv_par04",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""     ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""  })

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

pergunte(cperg,.F.)

Return