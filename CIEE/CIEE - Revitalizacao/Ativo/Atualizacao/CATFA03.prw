#Include 'Protheus.ch'
#include "rwmake.ch"
#include "TOPCONN.ch"
#include "colors.ch"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFA03
COnsulta de Entidade Setor (05).
@author     Otacilio A. Junior
@since      17/04/2015
@version    P.11.8      
@return     Nenhum
@obs        Nenhum
Alterações  Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data         |Desenvolvedor     |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
              |                   |  
------------+-----------------+----------------------------------------------------------
             |                    |                                                                  
------------+-----------------+----------------------------------------------------------

//---------------------------------------------------------------------------------------

/*/
User Function CATFA03()

//Declaracao de variaveis.
Private _cString    := "CV0"
Private cCadastro
Private aIndexCV0   := {}
Private _cFilCV0    := 'CV0_PLANO == "05" ' //Mostra Somente Entidade 05 (Setor)

Private aRotina   := MenuDef()


DEFINE FONT oFnt     NAME "ARIAL" SIZE 08,23 BOLD

CV0->(dbSetOrder(1))


//Exibe a tela de cadastro.
cCadastro := "Consulta Entidade Setor"

bFiltraBrw := {|| FilBrowse("CV0", @aIndexCV0, @_cFilCV0)}
Eval(bFiltraBrw)

mBrowse(06, 01, 22, 75, _cString,,,,,,)

Return

Static Function MenuDef
aRotina   := {  {"Pesquisar"  ,"AxPesqui"   , 0 , 1},;
                {"Visualizar" ,"AxVisual"   , 0 , 2} }//,;
                //{"Incluir"    ,"AxInclui"   , 0 , 3},;
                //{"Alterar"    ,"AxAltera"   , 0 , 4},;
                //{"Cancelar"   ,"AxExlcui"   , 0 , 5}}
                        
Return(aRotina)