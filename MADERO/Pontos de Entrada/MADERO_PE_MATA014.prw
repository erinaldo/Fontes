#Include "Protheus.ch"
/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! MT014MNU                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descri��o        ! Ponto de entrada para adicionar botoes a rotina MATA014.                      !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Vinicius Moreira                                                              !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 04/10/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/
User Function MT014MNU( )

Local aRet := { }

AAdd(aRet,{"Replicar","U_EST003",0,4})

Return aRet