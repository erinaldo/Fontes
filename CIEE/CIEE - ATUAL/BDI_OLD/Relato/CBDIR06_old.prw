#include "rwmake.ch"
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIR06   บAutor  ณMicrosiga           บ Data ณ  10/19/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIR06()

// Declara variaveis
Local cParams	:= ""
Local cOpcoes	:= "1;0;1;Etiqueta"
Local _nValREG  := 0

Local aArea := GetArea()

If _cProg <> "U_CBDIR08"
	DbSelectArea("SZO")
	If SZO->ZO_IMPRES == "S"
		MsgBox(OemToAnsi("Etiquetas jแ impressas"))
		Return()
	EndIf

	cQuery  := "SELECT COUNT(Z0_OK) AS COUNTOK "
	cQuery  += "FROM "+RetSQLname('SZ0')+" "
	cQuery  += "GROUP BY Z0_OK "
	cQuery  += "HAVING Z0_OK <> '' "
	TcQuery cQuery New Alias "VALTMP"

	DbSelectArea("VALTMP")
	If VALTMP->COUNTOK <= 0
		MsgBox(OemToAnsi("Sem Registros"))
		DbSelectArea("VALTMP")
		DbCloseArea("VALTMP")
		Return()
	EndIf
	DbSelectArea("VALTMP")
	DbCloseArea("VALTMP")

	DbSelectArea("SZO")
	_dData := DATE()
	_cTime := TIME()

	M->ZO_DTSAIDA := _dData
	M->ZO_HRSAIDA := _cTime
	M->ZO_IMPRES  := "S"
	
	RecLock("SZO",.F.)
	SZO->ZO_DTSAIDA := _dData
	SZO->ZO_HRSAIDA := _cTime
	SZO->ZO_IMPRES  := "S"
	MsUnLock()
EndIf

RestArea(aArea)

cParams   := SZO->ZO_CODEVEN  //Codigo do Evento para Filtro
_dDtEven  := SZO->ZO_DTEVENT  //Data do Evento
If !Empty(SZO->ZO_DTSAIDA)
	_dSaiEven := Substr(dtos(SZO->ZO_DTSAIDA),7,2)+Substr(dtos(SZO->ZO_DTSAIDA),5,2)+Substr(dtos(SZO->ZO_DTSAIDA),1,4) //Data de Saida do Evento (Validacao)
Else
	_dSaiEven := ""
EndIf
/*
DbSelectArea("SZZ") //Limpa conteudo da Tabela SZZ antes de imprimir Etiquetas
cTabela := RetArq("TOPCONN","SZZ020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE ZZ_CODEVEN = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)
*/
DbSelectarea("SZ0")
DbGotop()

nQtdBens := 0

Do While !EOF()

	If _cProg == "U_CBDIR08"
//		GrvSZZ()
	Else
		Do Case
			Case marked(SZ0->Z0_OK)
				If Empty(SZ0->Z0_OK)
					 GrvSZZ()
					 _nValREG++
			    EndIf
			Case SZ0->Z0_OK == cMarca
				 GrvSZZ()
				 _nValREG++
		EndCase
	EndIf

	DbSelectArea("SZ0")
	SZ0->(DBSkip())
	
EndDo

If _cProg <> "U_CBDIR08"

	DbSelectArea("SZO")

	M->ZO_NREGIMP := ALLTRIM(STR(_nValREG))

	RecLock("SZO",.F.)
	SZO->ZO_NREGIMP := ALLTRIM(STR(_nValREG))
	MsUnLock()

EndIf

If _cProg == "U_CBDIR08"
	CALLCRYS("ETIQ2", cParams, cOpcoes)
Else
	CALLCRYS("ETIQUETA", cParams, cOpcoes)
EndIf

DbSelectArea("SZ0")
DbGotop()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIR06   บAutor  ณMicrosiga           บ Data ณ  11/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvSZZ()
	Begin Transaction
		DbSelectArea("SZZ")
		DbSetOrder(1)
		RecLock("SZZ",.T.)
		SZZ->ZZ_CODEVEN	:= ALLTRIM(SZO->ZO_CODEVEN)		//Codigo do Evento para Filtro
		SZZ->ZZ_DTSAIDA	:= _dSaiEven
		SZZ->ZZ_FORMALI	:= SZ0->Z0_FORMALI		//Formalidade (A/ AO)
		SZZ->ZZ_NOME	:= SZ0->Z0_NOME			//Nome do Contato
		SZZ->ZZ_END		:= SZ0->Z0_END     		//Endereco Padrao
		SZZ->ZZ_BAIRRO	:= SZ0->Z0_BAIRRO			//Bairro
		SZZ->ZZ_MUN		:= SZ0->Z0_MUN			//Municipio
		SZZ->ZZ_EST		:= SZ0->Z0_EST			//Estado
		SZZ->ZZ_CEP		:= Substr(SZ0->Z0_CEP,1,5)+"-"+Substr(SZ0->Z0_CEP,6,3) //CEP /  99999999
		SZZ->ZZ_NOME1	:= SZ0->Z0_NOME1			//Nome da Entidade
		SZZ->ZZ_DESCR	:= SZ0->Z0_DESCR			//Descricao do Grupo
		SZZ->ZZ_CARGO	:= SZ0->Z0_CARGO			//Descricao do Cargo
		SZZ->ZZ_CARTRAT	:= SZ0->Z0_CARTRAT		//Descricao do Tratamento do Cargo "do, da, de"
		SZZ->ZZ_TRAT	:= SZ0->Z0_TRATAME		//Descricao do Tratamento
		SZZ->ZZ_AC		:= SZ0->Z0_AC				//A/C
		SZZ->ZZ_CODCONT := SZ0->Z0_CONTAT		//Codigo do Contato
		SZZ->ZZ_TRTCARG := SZ0->Z0_TRTCARG       //Tratamento Cargo (Dignissimo(a))
		SZZ->ZZ_DTEVENT := _dDtEven
		MsUnLock()
	End Transaction
Return