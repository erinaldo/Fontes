#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPRJR01   บAutor  ณCristiano Giardini  บ Data ณ  13/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio das Solicitacoes de Servico a Informatica - SSI  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CPRJR01()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local titulo  := "Relatorio Solicitacoes de Servicos a Informatica - SSI"
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Relatorio Solicitacoes de Servicos a Informatica - SSI"
Local nLin    := 80
Local Cabec1  := " Nr SSI  Emissao     CR     Departamento          Servico                                                       Tipo     Analista       Inicio      Previsto    Concluido   Aceite      Arquivo  Sistemas   Ident."
Local Cabec2  := ""

Private lAbortPrint := .F.
Private limite      := 132    //80 / 132 / 220 Colunas
Private tamanho     := "G"
Private nomeprog    := "CPRJR01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CPRJR01"
Private cString     := "SZP"
Private cPerg       := "CPRJ01    "

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

dbSelectArea("SZP")
dbSetOrder(1)        

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

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

Do Case
	Case mv_par08 == 1 	/* pendente (SIM) */ .and. mv_par13 == 2	// cancelado (NAO)
		Titulo := Alltrim(Titulo) + "  (Pendentes)"				
	Case mv_par08 == 2	/*pendente (NAO)*/ .and. mv_par11 == 2	/*aceite (NAO)*/ .and. mv_par13 == 2 //cancelado (NAO)
		Titulo := Alltrim(Titulo) + "  (Sem Aceite)"				
	Case mv_par08 == 2	// pendente (NAO)
		Titulo := Alltrim(Titulo) + "  (Concluidas)"
	Case mv_par13 == 1	// cancelado (SIM)
		Titulo := Alltrim(Titulo) + "  (Canceladas)"
		Cabec1 := Cabec1 + "   Motivo Cancelamento"
EndCase		

Titulo	:= Titulo + " " + dtoc(mv_par01) + " a "+ dtoc(mv_par02)

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

Private _cSegmento

cQuery := "SELECT SZP.R_E_C_N_O_ ZPRECNO, *"
cQuery += " FROM "+RetSQLname('SZP')+" SZP "
cQuery += " WHERE SZP.D_E_L_E_T_ <> '*' "
cQuery += " AND ZP_EMISSAO BETWEEN '" +DTOS(mv_par01)+ "' AND '" +DTOS(mv_par02)+ "'"
cQuery += " AND ZP_NRSSI BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND ZP_CR BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
If mv_par07 <> '99'
	cQuery += " AND ZP_CODANAL = '" + mv_par07 + "'"
EndIf

If  mv_par19 = 1	//Pendente Geral (SIM)
	cQuery += " AND ((ZP_CONCLUS = ' ' OR ZP_CONCLUS <> ' ') AND (ZP_ACEITE = ' ' OR ZP_ACEITE <> ' ') AND ZP_ARQUIVO = '2') "
Else
	If mv_par08 == 1 	// pendente (SIM)
		cQuery += " AND ZP_CONCLUS = ' '"
		If mv_par13 == 1	// cancelado (SIM)
			cQuery += " AND ZP_CANCEL = '1'"
		ElseIf mv_par13 == 2
			cQuery += " AND ZP_CANCEL = '2'"
		EndIf
	ElseIf mv_par08 == 2	// pendente (NAO)
		cQuery += " AND ZP_CONCLUS BETWEEN '" +DTOS(mv_par09)+ "' AND '" +DTOS(mv_par10)+ "'"
		If mv_par11 == 1	// aceite (SIM)
			cQuery += " AND ZP_ACEITE <> ' '"
			If mv_par12 == 1	// arquivo (SIM)
				cQuery += " AND ZP_ARQUIVO = '1'"
			ElseIf mv_par12 == 2	// arquivo (NAO)
				cQuery += " AND ZP_ARQUIVO = '2'" 
			EndIf
		ElseIf mv_par11 == 2	// aceite (NAO)
			cQuery += " AND ZP_ACEITE = ' '"
		EndIf
	Else
		If mv_par13 == 1	// cancelado (SIM)
			cQuery += " AND ZP_CANCEL = '1'"
		ElseIf mv_par13 == 2
			cQuery += " AND ZP_CANCEL = '2'"
		EndIf
	EndIf
EndIf

If mv_par14 == 1	// Projeto
	cQuery += " AND ZP_TIPO = '1'"
ElseIf mv_par14 == 2	// Tarefa
	cQuery += " AND ZP_TIPO = '2'"
EndIf
If mv_par15 <> '99'
	cQuery += " AND ZP_GERENCI = '" + mv_par15 + "'"
EndIf
If mv_par16 <> '99'
	cQuery += " AND ZP_SUPERIN = '" + mv_par16 + "'"
EndIf
cQuery += " AND ZP_DTPREV BETWEEN '" + DTOS(mv_par17) + "' AND '" + DTOS(mv_par18) + "'"

If mv_par20 <> '9' //SISTEMAS - 9 igual a todos nao tem filtro
	cQuery += " AND ZP_SISTEMA = '"+mv_par20+"' "
EndIf

//identificacao da SSI (alteracao/ desenvolvimento/ emergencial)
If mv_par21 <> 4 //TODOS
	cQuery += " AND ZP_TPIDENT = '"+alltrim(str(mv_par21))+"' "
EndIf

cQuery += " ORDER BY ZP_ANALIST, ZP_NRSSI, ZP_CR, ZP_CRDESCR "
TcQuery cQuery New Alias "TMP"    

TcSetField("TMP","ZP_EMISSAO","D",8, 0 )
TcSetField("TMP","ZP_CONCLUS","D",8, 0 )
TcSetField("TMP","ZP_ACEITE","D",8, 0 )
TcSetField("TMP","ZP_DTPREV","D",8, 0 )
TcSetField("TMP","ZP_PREVINI","D",8, 0 )

dbSelectArea("TMP")
dbGotop()

_cSegmento	:= TMP->ZP_CODANAL

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
              
   If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...

      Titulo := Titulo + " Sistema: " + TMP->ZP_DESCSIS

      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

/*       1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Nr SSI  Emissao     CR     Departamento          Servico                                                       Tipo     Analista       Inicio      Previsto    Concluido   Aceite      Arquivo  
999999  99/99/9999  99999  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxx  xxxxxxxxxxxxx  99/99/9999  99/99/9999  99/99/9999  99/99/9999  XXX      Motivo Cancelamento
*/

//Quebra de linha	     

	If _cSegmento <> TMP->ZP_CODANAL
		@ nLin, 000 PSAY __PrtThinLine()
		nLin++
		_cSegmento  := TMP->ZP_CODANAL
	EndIf

	@ nLin, 001 PSAY TMP->ZP_NRSSI
	@ nLin, 009 PSAY TMP->ZP_EMISSAO
	@ nLin, 021 PSAY TMP->ZP_CR
	@ nLin, 028 PSAY TMP->ZP_CRDESCR
	
	SZP->(DbGoTo(TMP->ZPRECNO))
	
	nLinServ  := MlCount( SZP->ZP_SERVICO, 60 )
	nLinCanc  := MlCount( SZP->ZP_MOTIVO, 40 )
	
	If nLinServ > nLinCanc
		nLinhas := nLinServ
	Else
		nLinhas := nLinCanc
	EndIf

	If nLinhas > 0
		
		@ nLin, 050 PSay MemoLine( SZP->ZP_SERVICO, 60, 1 )
		
		_cTipo := ""
		Do Case
			Case TMP->ZP_TIPO == "1"
				_cTipo := "PROJETO"
			Case TMP->ZP_TIPO == "2"
				_cTipo := "TAREFA"
		EndCase

		@ nLin, 112 PSAY _cTipo
		@ nLin, 121 PSAY SUBSTR(TMP->ZP_ANALIST,1,13)
		@ nLin, 136 PSAY TMP->ZP_PREVINI
		@ nLin, 148 PSAY TMP->ZP_DTPREV
		@ nLin, 160 PSAY TMP->ZP_CONCLUS
		@ nLin, 172 PSAY TMP->ZP_ACEITE

		_cArquivo := ""
		Do Case
			Case TMP->ZP_ARQUIVO == "1"
				_cArquivo := "Sim"
			Case TMP->ZP_ARQUIVO == "2"
				_cArquivo := "Nao"
		EndCase

		@ nLin, 184 PSAY _cArquivo
		
		If mv_par13 == 1	// cancelado (SIM)
			@ nLin, 193 PSay MemoLine( SZP->ZP_MOTIVO, 40, 1 )
		Else
			@ nLin, 193 PSAY substr(TMP->ZP_DESCSIS,1,9)
			Do Case
				Case TMP->ZP_TPIDENT == "1"
					_cTpIdent	:= "Alteracao"
				Case TMP->ZP_TPIDENT == "2"
					_cTpIdent	:= "Desenvolvimento"
				Case TMP->ZP_TPIDENT == "3"
					_cTpIdent	:= "Emergencial"
			EndCase

			@ nLin, 204 PSAY _cTpIdent
		EndIf

		For nI := 2 to nLinhas  
	
			nLin++
			If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
				nLin := 8
			EndIf
		    
			If !Empty(MemoLine(SZP->ZP_SERVICO, 60, nI))
				@ nLin,050 PSay MemoLine( SZP->ZP_SERVICO, 60, nI)
				@ nLin,193 PSay MemoLine( SZP->ZP_MOTIVO, 40, nI)
			Else
				@ nLin,050 PSay Space(60)
				@ nLin,193 PSay MemoLine( SZP->ZP_MOTIVO, 40, nI)				
			EndIf

		Next nI
		
	EndIf

	nLin+=2
	
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

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt                  ,perg spa,perg eng , variav ,tipo,tam,dec,pres  ,gsc,valid,var01     ,def01       ,defspa01,defeng01,cnt01   ,var02,def02              ,defspa02,defeng02,cnt02   ,var03,def03         ,defspa03,defeng03,cnt03    ,var04,def04    ,defspa04,defeng04,cnt04,var05,def05   ,defspa05,defeng05,cnt05,f3,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data Emissao de     ?  ","      ","       ","mv_ch1","D" ,08 ,00 ,0    ,"G",""   ,"mv_par01",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Data Emissao ate    ?  ","      ","       ","mv_ch2","D" ,08 ,00 ,0    ,"G",""   ,"mv_par02",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Numero SSI de       ?  ","      ","       ","mv_ch3","C" ,06 ,00 ,0    ,"G",""   ,"mv_par03",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Numero SSI ate      ?  ","      ","       ","mv_ch4","C" ,06 ,00 ,0    ,"G",""   ,"mv_par04",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"CR de               ?  ","      ","       ","mv_ch5","C" ,05 ,00 ,0    ,"G",""   ,"mv_par05",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"CTT","","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"CR ate              ?  ","      ","       ","mv_ch6","C" ,05 ,00 ,0    ,"G",""   ,"mv_par06",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"CTT","","","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Analista            ?  ","      ","       ","mv_ch7","C" ,02 ,00 ,0    ,"G",""   ,"mv_par07",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"SI" ,"","","","",""})
aAdd(aRegs,{cPerg  ,"08" ,"Pendente            ?  ","      ","       ","mv_ch8","N" ,01 ,00 ,0    ,"C",""   ,"mv_par08","Sim"       ,""      ,""      ,""     ,""   ,"Nao"              ,""      ,""      ,""      ,""   ,"Todos"       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"09" ,"Data Conclusao de   ?  ","      ","       ","mv_ch9","D" ,08 ,00 ,0    ,"G",""   ,"mv_par09",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"10" ,"Data Conclusao ate  ?  ","      ","       ","mv_chA","D" ,08 ,00 ,0    ,"G",""   ,"mv_par10",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""   	       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"11" ,"Aceite              ?  ","      ","       ","mv_chB","N" ,01 ,00 ,0    ,"C",""   ,"mv_par11","Sim"       ,""      ,""      ,""     ,""   ,"Nao"              ,""      ,""      ,""      ,""   ,"Todos"       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"12" ,"Arquivo             ?  ","      ","       ","mv_chC","N" ,01 ,00 ,0    ,"C",""   ,"mv_par12","Sim"       ,""      ,""      ,""     ,""   ,"Nao"              ,""      ,""      ,""      ,""   ,"Todos"       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"13" ,"Cancelado           ?  ","      ","       ","mv_chD","N" ,01 ,00 ,0    ,"C",""   ,"mv_par13","Sim"       ,""      ,""      ,""     ,""   ,"Nao"              ,""      ,""      ,""      ,""   ,"Todos"       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"14" ,"Tipo                ?  ","      ","       ","mv_chE","N" ,01 ,00 ,0    ,"C",""   ,"mv_par14","Projeto"   ,""      ,""      ,""     ,""   ,"Tarefa"           ,""      ,""      ,""      ,""   ,"Todos"       ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"15" ,"Gerencia            ?  ","      ","       ","mv_chF","C" ,02 ,00 ,0    ,"G",""   ,"mv_par15",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"GR" ,"","","","",""})
aAdd(aRegs,{cPerg  ,"16" ,"Superintendencia    ?  ","      ","       ","mv_chG","C" ,02 ,00 ,0    ,"G",""   ,"mv_par16",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"SU" ,"","","","",""})
aAdd(aRegs,{cPerg  ,"17" ,"Data Prevista de    ?  ","      ","       ","mv_chH","D" ,08 ,00 ,0    ,"G",""   ,"mv_par17",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"18" ,"Data Prevista ate   ?  ","      ","       ","mv_chI","D" ,08 ,00 ,0    ,"G",""   ,"mv_par18",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"19" ,"Pendente Geral      ?  ","      ","       ","mv_chJ","N" ,01 ,00 ,0    ,"C",""   ,"mv_par19","Sim"       ,""      ,""      ,""     ,""   ,"Nao"              ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"20" ,"Sistemas            ?  ","      ","       ","mv_chK","C" ,01 ,00 ,0    ,"G",""   ,"mv_par20",""          ,""      ,""      ,""     ,""   ,""                 ,""      ,""      ,""      ,""   ,""            ,""      ,""     ,""       ,""   ,""       ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,"98" ,"","","","",""})
aAdd(aRegs,{cPerg  ,"21" ,"Identificacao       ?  ","      ","       ","mv_chL","N" ,01 ,00 ,0    ,"C",""   ,"mv_par21","Alteracao" ,""      ,""      ,""     ,""   ,"Desenvolvimento"  ,""      ,""      ,""      ,""   ,"Emergencial" ,""      ,""     ,""       ,""   ,"Todos"  ,""      ,""      ,""      ,""   ,""   ,""      ,""     ,""      ,""   ,"","","","",""})

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