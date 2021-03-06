#Include "RwMake.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �F340Brow()� Autor � Cesar Moura         � Data � 08/11/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Apresenta para Compensa��o somente os titulos conferidos    ���
���          � onde o Campo XLIBNIV estiver igual a '2'                    ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function F340Brow()

/*����������������������������������������������������������������������������Ŀ
�              Declara��o de Variaveis                                       �
������������������������������������������������������������������������������*/
local cfiltro:= "SE2->E2_XLIBNIV $ '2/3'"

// 3050

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
	�              Executa o Filtro                                              �
	������������������������������������������������������������������������������*/
	Aviso( "Aten��o !" , "Esta rotina somente permitira a compensa��o dos titulos a pagar previamente conferidos. Caso n�o seja exibido o t�tulos desejado, solicite a conferencia do mesmo !" , {"Ok"} , 1 , "Titulos Conferidos" )
EndIf

DbSelectArea("SE2")

Set Filter to &cFiltro

Return