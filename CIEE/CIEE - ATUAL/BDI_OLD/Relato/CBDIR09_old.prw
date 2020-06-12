#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIR09   บAutor  ณEmerson Natali      บ Data ณ  22/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacao de Eventos por Contato                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIR09()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relacao de Eventos por Contatos"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relacao de Eventos por Contato"
Local Cabec1  := " Codigo  Nome Contato"
Local Cabec2  := "  Cod Evento Descricao Evento                        Dt Evento Dt Solic Dt Saida"

Private nLin    	:= 80
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "CBDIR09"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CBDIR09"
Private cString     := "SZZ"
Private cPerg       := "CBDIR9"
Private aOrd        := {"Contato","Eventos"}

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SZZ") // Cadastro Eventos X Contatos 
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

pergunte(cperg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Private _cCod

nOrdem := aReturn[8]

cQuery  := "SELECT * "
cQuery  += " FROM "+RetSQLname('SZZ')+" SZZ "
cQuery  += " WHERE SZZ.D_E_L_E_T_ <> '*' "
cQuery  += " AND ZZ_CODCONT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery  += " AND ZZ_CODEVEN BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery  += " AND ZZ_DTEVENT BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"' "

If nOrdem == 1
	cQuery  += "ORDER BY ZZ_CODCONT,ZZ_CODEVEN"
Else
	cQuery  += "ORDER BY ZZ_CODEVEN,ZZ_CODCONT"
EndIf

TcQuery cQuery New Alias "TMP"

TcSetField("TMP","ZZ_DTEVENT","D",8, 0 )

dbSelectArea("TMP")
dbGotop()

If nOrdem == 1
	_cCod  := TMP->ZZ_CODCONT
Else
	_cCod  := TMP->ZZ_CODEVEN
EndIf

lFirst     := .T.

If nOrdem == 1
	titulo	:= "Relatorio de Contatos por Eventos"
Else
	titulo	:= "Relatorio de Eventos por Contatos"
EndIf

While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 09
   Endif

	If nOrdem == 1
		/*       1         2         3         4         5         6         7         8
		12345678901234567890123456789012345678901234567890123456789012345678901234567890
		 Codigo  Nome Contato
		   Cod Evento Descricao Evento                        Dt Evento Dt Solic Dt Saida
		 xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		   xxxxxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99/99/99 99/99/99 99/99/99
		*/
	
		If _cCod <> TMP->ZZ_CODCONT
			nLin++
			@ nLin, 000 PSAY __PrtThinLine()
			nLin++
			nLin++
			_cCod  := TMP->ZZ_CODCONT
			lFirst := .T.
		EndIf

		If lFirst
			lFirst     := .F.
			@ nLin, 002 PSAY TMP->ZZ_CODCONT
			@ nLin, 010 PSAY TMP->ZZ_NOME
			nLin++
			nLin++
		EndIf

		@ nLin, 004 PSAY TMP->ZZ_CODEVEN
		DbSelectArea("SZO")
		DbSetOrder(1)
		DbSeek(xFilial("SZO")+TMP->ZZ_CODEVEN)
		@ nLin, 015 PSAY Substr(SZO->ZO_DESCR,1,38)
		@ nLin, 055 PSAY TMP->ZZ_DTEVENT
		@ nLin, 064 PSAY SZO->ZO_EMISSAO
		@ nLin, 073 PSAY SZO->ZO_DTSAIDA
		nLin++
	
	Else
	
		/*       1         2         3         4         5         6         7         8
		12345678901234567890123456789012345678901234567890123456789012345678901234567890
		 Codigo  Descricao do  Evento
		   Cod Cont Nome Contato                            Dt Evento Dt Solic Dt Saida
		 xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		     xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99/99/99 99/99/99 99/99/99
		*/
	
		If _cCod <> TMP->ZZ_CODEVEN
			nLin++
			@ nLin, 000 PSAY __PrtThinLine()
			nLin++
			nLin++
			_cCod  := TMP->ZZ_CODEVEN
			lFirst := .T.
		EndIf

		If lFirst
			lFirst     := .F.
			@ nLin, 002 PSAY TMP->ZZ_CODEVEN
			@ nLin, 010 PSAY SZO->ZO_DESCR
			nLin++
			nLin++
		EndIf

		DbSelectArea("SZO")
		DbSetOrder(1)
		DbSeek(xFilial("SZO")+TMP->ZZ_CODEVEN)
		@ nLin, 004 PSAY TMP->ZZ_CODCONT
		@ nLin, 014 PSAY TMP->ZZ_NOME
		@ nLin, 054 PSAY TMP->ZZ_DTEVENT
		@ nLin, 064 PSAY SZO->ZO_EMISSAO
		@ nLin, 073 PSAY SZO->ZO_DTSAIDA
		nLin++

	EndIf
	
	DbSelectArea("TMP")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

DbSelectArea("TMP")
DbCloseArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,6)

/*
             grupo ,ordem,pergunt       ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01,defspa01,defeng01,cnt01,var02,def02,defspa02,defeng02,cnt02,var03,def03,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Contato De   ","      ","       ","mv_ch1","C" ,06 ,00 ,0  ,"G",""   ,"mv_par01",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SU5","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Contato Ate  ","      ","       ","mv_ch2","C" ,06 ,00 ,0  ,"G",""   ,"mv_par02",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SU5","","","","@!"})
aAdd(aRegs,{cPerg  ,"03" ,"Evento De    ","      ","       ","mv_ch3","C" ,06 ,00 ,0  ,"G",""   ,"mv_par03",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","","@!"})
aAdd(aRegs,{cPerg  ,"04" ,"Evento Ate   ","      ","       ","mv_ch4","C" ,06 ,00 ,0  ,"G",""   ,"mv_par04",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","","@!"})
aAdd(aRegs,{cPerg  ,"05" ,"Dt Evento De ","      ","       ","mv_ch5","D" ,08 ,00 ,0  ,"G",""   ,"mv_par05",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Dt Evento Ate","      ","       ","mv_ch6","D" ,08 ,00 ,0  ,"G",""   ,"mv_par06",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""})

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

Return