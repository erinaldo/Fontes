#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410MNU  ºAutor  ³Daniel G.Jr.TI1239  º Data ³  Abril/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada da rotina MATA410-Pedido de Vendas        º±±
±±º          ³ Incluir opções no menu da rotina (aRotina)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA410MNU()

Local cDirect := ""
Local aDirect := {}

If alltrim(FunName()) == "MATA410"

	// Verifica se há carga de bens do Ativo Fixo do SOE para ser feita
	If ExistBlock("CATFA01")
		If cEmpant == '01' //SP
			cDirect    := "arq_txt\contabilidade\Ativo\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\contabilidade\Ativo\"
		EndIf
		aDirect    := Directory(cDirect+"*.TXT")

		If Len(aDirect)>0
			ExecBlock("CATFA01",.F.,.F.)
		EndIf
	EndIf
	
	// Inclui opção de Alteração de cabeçalho do Pedido de Vendas
	If ExistBlock("CFATA01")
		aAdd(aRotina, { "Altera Cabeçalho PV", 'ExecBlock("CFATA01",.F.,.F.)' , 0, 4, 0, NIL})
	EndIf
EndIf

Return