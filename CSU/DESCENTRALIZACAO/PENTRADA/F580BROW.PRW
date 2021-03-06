#Include "RwMake.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � F580BROW � Autor � Ricardo Beraldo     � Data � 10/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Apresenta para liberacao somente os titulos conferidos      ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function F580Brow()

/*����������������������������������������������������������������������������Ŀ
�              Declara as Variaveis Locais Utilizadas na Rotina              �
������������������������������������������������������������������������������*/

// 3050

Local cAlias  := "SE2"
Local aAreatu := GetArea()
Local cFiltro := "SE2->E2_XLIBNIV $ '2/3' .And. Empty( SE2->E2_DATALIB ) .And. SE2->E2_SALDO <> 0 "

/*
����������������������������������������������������������������������������Ŀ
� OS 2136/08: Se a data base for superior a data do dia, nao permitir:       �
������������������������������������������������������������������������������
*/
If dDataBase > Date()
	cTxtBlq := "A data base � superior a data de Hoje. Opera��o n�o permitida. "
	Aviso("DATA BASE INVALIDA",cTxtBlq,;
	{"&Fechar"},3,"DataBase Superior",,;
	"PCOLOCK")
	cFiltro += ".And. SE2->E2_FILIAL == 'WX'"
Else
	/*����������������������������������������������������������������������������Ŀ
	�                         Executa Filtro de Bloqueio                         �
	������������������������������������������������������������������������������*/
	
	Aviso( "Aten��o ! - Conferidos e n�o Baixados" , "Esta rotina somente permitira a liberacao dos titulos a pagar previamente conferidos. Caso n�o seja exibido o t�tulos desejado, solicite a conferencia do mesmo !" , {"Ok"} , 1 , "Titulos Conferidos" )
EndIf

/*����������������������������������������������������������������������������Ŀ
�                         Executa Filtro de Bloqueio                         �
������������������������������������������������������������������������������*/

DbSelectArea(cALIAS)
bFILBRW := { || FilBrowse( cALIAS , {} , @cFILTRO ) }
Eval(bFILBRW)

/*����������������������������������������������������������������������������Ŀ
�                         Retorna a Area Atual                               �
������������������������������������������������������������������������������*/

RestArea(aAreatu)

Return