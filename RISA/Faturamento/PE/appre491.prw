#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} OM010MNU
                 
Ponto de entrada de inclusao do botao dentro do cadaatro de Tabelas de precos
para permitir manutencao nos precos promocionais

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

User Function OM010MNU

If GetMV('FS_REGRATB',,.F.)

    aAdd(aRotina,{ "Precos Promocionais" , "U_CADPROMO", 0 , 6} )	

Endif

Return(aRotina)
