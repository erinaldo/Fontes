#include "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM130FIL   บAutor  ณ Felipe Raposo      บ Data ณ  11/11/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PROGRAMA....: MATA130                                      บฑฑ
ฑฑบ          ณ Filtra as solicitacoes de compras para o comprador no mo-  บฑฑ
ฑฑบ          ณ mento da geracao da cotacao.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ O filtro.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M130FIL()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aSX1, _aSXb, _cUser, _mFilComp, _cFilSC, _cPerg

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNao apagar essa linha de comando. Ela serve para indicar             ณ
//ณao ponto MT130FOR que eh a primeira vez que ele esta sendo           ณ
//ณexecutado, sendo assim ele tera que perguntar quais forne-           ณ
//ณcedores farao parte da cotacao.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _PARAMIXB2 := nil

// Perguntas incluidas no sistema.
_cPerg := "MT130a    "
_aSX1  := {;
{_cPerg,"01","Exibe p/ comprador  ","Exibe p/ comprador  ","Exibe p/ comprador  ","mv_ch1","N",01,0,1,"C","","mv_par01","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""},;
{_cPerg,"02","Comprador           ","Comprador           ","Comprador           ","mv_ch2","C",15,0,1,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","USC","",""}}
AjustaSX1(_aSX1)
If !Pergunte(_cPerg, .T.); Pergunte("MTA130    ", .F.); Return (".F."); Endif

// O bloco de comandos abaixo atualiza a tabela SXB antes de
// executar o programa.
_aSXb := {;
{"USC","1","01","US","Usuarios","Usuarios","Users",""},;
{"USC","5","01","","","","","NAME"}}
//AjustaSXB(_aSXb) // _FixSX.ch    // Favor dar tratamento na fun็ใo CLAUDIO BARROS 31/03/06 AS 17H19

// Considera os parametros digitados pelo usuario.
_mFilComp := (mv_par01 == 1)
//_cUser    := IIf(empty(mv_par02), SubStr(cUsuario, 7, 15), mv_par02)
_cUser    := IIf(empty(mv_par02), cUserName, mv_par02)
_cUser    := Upper(AllTrim(_cUser))

// Retorna os parametros originais.
Pergunte("MTA130    ", .F.)

// Filtra por comprador.
_cFilSC := IIf (_mFilComp, "Upper(AllTrim(C1_SOLICIT)) == '" + _cUser + "'", "")

// Retorna o filtro.
Return(_cFilSC)