#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RRICFG001 ºAutor  ³Microsiga           º Data ³  06/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RRICFG001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := ""
Local titulo := ""
Local nLin   := 80
Local Cabec1 := ""
Local Cabec2 := ""
Local aOrd   := {}

Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "RRICFG001"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "RRICFG001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SA1"
Private cPerg       := "RRICFG001"

_fCriaSX1() //Cria SX1 Perguntas (parametros)

dbSelectArea("SA1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

pergunte(cperg,.F.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/06/14   º±±
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

dbSelectArea(cString)
dbSetOrder(1)

//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³

_cQuery := ""

_cQuery := "SELECT 	ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') AS XXE_ERROR, "
_cQuery += "ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_COMPLE)),'') AS XXE_COMPLE, "
_cQuery += "ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_XML)),'') AS XXE_XML, * "
_cQuery += "FROM XXE110 XXE "

If mv_par01 == 1 //Produto
	_cQuery += "WHERE XXE_ADAPT = 'MATA010' "
	If mv_par02 == 2 //Nao
		_cQuery += "AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') NOT LIKE '%JAGRAVADO%' "
	EndIf
ElseIf mv_par01 == 2 //Fornecedor
	_cQuery += "WHERE XXE_ADAPT = 'MATA020' "
	If mv_par02 == 2 //Nao
		_cQuery += "AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') NOT LIKE '%EXISTFOR%' "
	EndIf
ElseIf mv_par01 == 3 //Cliente
	_cQuery += "WHERE XXE_ADAPT = 'MATA030' "
	If mv_par02 == 2 //Nao
		_cQuery += "AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') NOT LIKE '%EXISTCLI%' "
	EndIf
ElseIf mv_par01 == 4 //NF Entrada
	_cQuery += "WHERE XXE_ADAPT = 'MATA103' "
ElseIf mv_par01 == 5 //NF Saida
	_cQuery += "WHERE XXE_ADAPT = 'MATA018' " //MATA920
	If mv_par02 == 2 //Nao
		_cQuery += "AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') NOT LIKE '%A920EXIST%' "
	EndIf
ElseIf mv_par01 == 6 //SBZ
	_cQuery += "WHERE XXE_ADAPT = 'MATA018' "
	If mv_par02 == 2 //Nao
		_cQuery += "AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),XXE.XXE_ERROR)),'') NOT LIKE '%EXISTFOR%' "
	EndIf
EndIf

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery), cAliasTop := GetNextAlias(), .F., .T.)
TCSetField( cAliasTop, 'XXE_DATE', 'D',8, 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

If !(cAliasTop)->(Eof())

	dbGoTop()
	While !EOF()
		
		ProcRegua(RecCount())

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
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		IncProc()
/*
		@nLin,00 PSAY "Registro: "+ XXE_ID
		nLin++
		@nLin,00 PSAY "Adapter: "+ XXE_ADAPT
		nLin++
		@nLin,00 PSAY "Arquivo: "+ XXE_FILE
		nLin++
		@nLin,00 PSAY "Layout: "+ XXE_LAYOUT
		nLin++
		@nLin,00 PSAY "Descrição: "+ XXE_DESC
		nLin++
		@nLin,00 PSAY "Data: "+ DTOC(XXE_DATE)
		nLin++
		@nLin,00 PSAY "Hora: "+ XXE_TIME
		nLin++
		@nLin,00 PSAY "Tipo: "+ XXE_TYPE
		nLin++
		@nLin,00 PSAY "Usuario: "+ XXE_USRID
		nLin++
		@nLin,00 PSAY "Nome: "+ XXE_USRNAM
		nLin++
		@nLin,00 PSAY "Origem: "+ XXE_ORIGIN
		nLin++
*/		@nLin,00 PSAY "Erro: "+ XXE_ERROR
		nLin++
//		@nLin,00 PSAY "Complemento: "+ XXE_COMPLE
//		nLin++
//		@nLin,00 PSAY XXE_XML
//		nLin++
		
		nLin++
		
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
Else

	alert("Sem dados no Relatorio")
	SET DEVICE TO SCREEN
	MS_FLUSH()
	Return	

EndIf


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
±±ºPrograma  ³RRICFG001 ºAutor  ³Microsiga           º Data ³  06/05/14   º±±
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

Local nY, nX
aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Padr(cPerg,10)

/*
             grupo ,ordem,pergunt          ,perg spa       ,perg eng        , variav ,tipo ,tam,dec,pres,gsc,valid                      ,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02       ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04         ,defspa04,defeng04,cnt04,var05,def05        ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Adapter"        ,"             ","              ","mv_ch1","C"  ,01 ,00 ,0  ,"C" ,""                         ,"mv_par01","Produto",""       ,""       ,""   ,""   ,"Fornecedor",""        ,""        ,""   ,""   ,"Cliente"    ,""           ,""           ,""   ,""   ,"NF Entrada"   ,""      ,""      ,""   ,""   ,"NF Saida"   ,""      ,""      ,""   ,""   ,"","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Consid.Dupl.?"  ,"             ","              ","mv_ch2","C"  ,01 ,00 ,0  ,"C" ,""                         ,"mv_par02","Sim"    ,""       ,""       ,""   ,""   ,"Nao"       ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""           ,""      ,""      ,""   ,""   ,"","","",""  })

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
