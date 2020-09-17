#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} MTA040MNU
                 
Tela para inclusao de Regiões x tabelas que o vendedor pode trabalhar

@author  Milton J.dos Santos
@since   14/07/20
@version 1.0

/*/

//Ponto de entrada inclusao botao dentro do cadastro de Vendedores
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTA040MNU
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

If GetMV('FS_REGRATB',,.F.)

    aAdd(aRotina,{ "Regras de Precos" , "U_CADREGRA", 0 , 6} )	

Endif

Return(aRotina)
