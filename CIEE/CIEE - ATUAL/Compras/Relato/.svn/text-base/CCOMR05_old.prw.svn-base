#include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMR05   บAutor  ณCristiano           บ Data ณ  25/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRdmake para executar o relatorio em crystal separando       บฑฑ
ฑฑบ          ณas empresas 01 e 03                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 8                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CCOMR05()

Local cParams	:= ""
Local cOpcoes	:= ""

If cEmpant == '01'
	Pergunte("CRYAF2    ",.T.)
	cParams := mv_par01+";"+mv_par02+";"+mv_par03+";"+mv_par04+";"+dtoc(mv_par05)+";"+dtoc(mv_par06)+";"+dtoc(mv_par07)+";"+dtoc(mv_par08)+";"+Str(mv_par09,1)+";"+mv_par10+";"+mv_par11+";"+Alltrim(mv_par12)+";"+Alltrim(mv_par13)+";"
	cOpcoes := "1;0;1;Relatorio Gerencial de Autorizacao de Fornecimento"
	CALLCRYS("CRYAF2", cParams, cOpcoes)
Else
	Pergunte("CRYAF3    ",.T.)
	cParams := mv_par01+";"+mv_par02+";"+mv_par03+";"+mv_par04+";"+dtoc(mv_par05)+";"+dtoc(mv_par06)+";"+dtoc(mv_par07)+";"+dtoc(mv_par08)+";"+Str(mv_par09,1)+";"+mv_par10+";"+mv_par11+";"+Alltrim(mv_par12)+";"+Alltrim(mv_par13)+";"
	cOpcoes := "1;0;1;Relatorio Gerencial de Autorizacao de Fornecimento"
	CALLCRYS("CRYAF3", cParams, cOpcoes)
EndIf

Return(.T.)