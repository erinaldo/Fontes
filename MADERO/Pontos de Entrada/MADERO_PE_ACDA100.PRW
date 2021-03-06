/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! ACD - ALTOMA��O E COLETA DE DADOS (ORDEM DE SEPARA��O)  !
+------------------+---------------------------------------------------------+
!Nome              ! ACD100M                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! P.E. que ir� chamar a Impress�o de Etiquetas            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 17/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
#include "protheus.ch"
//MENU BROWSE....
User Function ACD100M()

AAdd(aRotina,{"Etiquetas", "U_ETQEXP()", 0, 6} )

Return(aRotina) 

//ROTINA VISUALIZA��O.... 
User Function ACD100BUT()
Local aButtons := {} 
Local _CSEP:=CB7->CB7_ORDSEP
Local _NQTDE:=1
Local _cImp:= ALLTRIM(GETMV('MV_IACD01'))
Local _aetqauto:={} 

aadd(_aEtqAuto,{_cSEP,_nQtde,_cImp,})

//U_ETQ015(_aEtqAuto)

IF !INCLUI .and. !ALTERA
	Aadd(aButtons, {"RELATORIO", { || U_ETQ015(_aEtqAuto) }, OemToAnsi( 'Etiquetas' ) } )
ENDIF	

Return(aButtons)