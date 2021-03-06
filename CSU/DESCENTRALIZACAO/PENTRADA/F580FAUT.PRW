#Include "RwMake.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � F580FAUT � Autor � Cesar Moura         � Data � 26/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Apresenta para liberacao somente os titulos conferidos      ���
���          � Inclui a condi�ao ao filtro padr�o do sistema               ���
���          � Rotina de Libera��o p/ Baixa (Botao Autom�tica)             ���
��������������������������������������������������������������������������͹��
���Uso       � MP8.11 - Csu CardSystem                                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function F580FAUT()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

// 3050

Local cFiltro 

/*����������������������������������������������������������������������������Ŀ
  �                  Recebe o Filtro do Proprio Browse                         �
  ������������������������������������������������������������������������������*/

cFiltro := Paramixb[1]						// Atribui o Filtro dos parametros

/*����������������������������������������������������������������������������Ŀ
  �                  Monta o Filtro e Retorna ao Sistema                       �
  ������������������������������������������������������������������������������*/

cFiltro += " And E2_XLIBNIV IN ('2','3') And E2_SALDO <> 0 And E2_DATALIB = '' "    // Soma ao Filtro dos parametros

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
	cFiltro += "And E2_FILIAL = 'WX'"
EndIf

Return(cFiltro)