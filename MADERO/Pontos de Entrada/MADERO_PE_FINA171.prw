#include "protheus.ch"
/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! PE                                                      !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN                                                     !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada da rotina de empréstimo FINA171        !
+------------------+---------------------------------------------------------+
*/

Static cUltRot := ""
User Function F171OK
Local lGrava := .T.

//Alert("Antes de Gravar")

If Type("cChvMad") == "C"
	cUltRot := cChvMad
EndIf
Return lGrava

User Function Chave171
Return (cChvMad == cUltRot)

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!Tipo              ! PE                                                      !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN                                                     !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada da rotina de empréstimo FINA171        !
!                  ! ao executar a exclusao do emprestimo  F171EXCL()        !
+------------------+---------------------------------------------------------+
*/

User function F171EXCL()
Local cQ1 := ""
Local xDoc := Alltrim(SEH->EH_NUMERO) + Alltrim(SEH->EH_REVISAO)

	cQ1 := " UPDATE "
	cQ1 += RetSqlName("SE5")
	cQ1 += " SET D_E_L_E_T_ = '*' "
	cQ1 += " WHERE "
	cQ1 += " E5_FILIAL = '"+xFilial("SE5")+"' AND "  
	cQ1 += " E5_DOCUMEN = '" +xDoc+"' AND "
	cQ1 += " E5_VALOR = '"+STR(SEH->EH_VLCRUZ)+"' AND "
	cQ1 += " E5_DATA = '"+DTOS(SEH->EH_DATA)+"' "
	TcSqlExec(cQ1)

	cQ1 := " UPDATE "
	cQ1 += RetSqlName("SE2")
	cQ1 += " SET D_E_L_E_T_ = '*' "
	cQ1 += " WHERE "
	cQ1 += " E2_FILIAL = '"+xFilial("SE2")+"' AND "  
	cQ1 += " E2_NUM = '"+ SEH->EH_NUMERO +"' AND "
	cQ1 += " E2_PREFIXO = 'EMP' AND "	
	cQ1 += " E2_EMISSAO = '"+DTOS(SEH->EH_DATA)+"' "
	TcSqlExec(cQ1)
	
	cQ1 := " UPDATE "
	cQ1 += RetSqlName("FK5")
	cQ1 += " SET D_E_L_E_T_ = '*' "
	cQ1 += " WHERE "
	cQ1 += " FK5_FILIAL = '"+xFilial("FK5")+"' AND "  
	cQ1 += " FK5_DOC = '" +xDoc+"' AND "
	cQ1 += " FK5_VALOR = '"+STR(SEH->EH_VLCRUZ)+"' AND "
	cQ1 += " FK5_DATA = '"+DTOS(SEH->EH_DATA)+"' "
	TcSqlExec(cQ1)
	
Return()

