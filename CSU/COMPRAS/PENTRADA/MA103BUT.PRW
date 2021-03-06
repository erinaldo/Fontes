#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  �Ma125But  �Autor  �Leonardo Soncin        �Data  �07/12/2006���
���Entrada   �          �       �                       �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �MA103BUT                                                    ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Adiciona botao na tela de Nota Fiscal de Entrada            ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao�Chamada de rotinas                                          ���
�������������������������������������������������������������������������Ĵ��
���           Atualizacoes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���	     	   |          |	                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA103BUT()

Local aButtons := {}

If !Inclui
	AAdd( aButtons, { "USER"	, { || xConUser() }, "Usu�rio" } )
	// Incluido por Flavio Novaes em 04/04/07 - Chamado 000000000923.
	AAdd( aButtons, { "S4WB013N", { || xConRate() }, "Rateio CSU" } )
Endif

Return( aButtons )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ConAprov  � Autor � Sergio Oliveira       � Data � Out/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta os aprovadores do Documento.                      ���
�������������������������������������������������������������������������Ĵ��
���Altera��es� OS 0236/17 - Consulta usu�rio (Douglas David)              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ma110bar.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xConUser()

Local cUsu	:= SF1->F1_USERLGI
Local cNome := ""
Local cCodigo := ""
Local cUsuInc  := ""
Local cUsuAlt  := ""
Local aArea 	:= GetArea()

SD1->( DbSetOrder(1), DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA) )

cUsuInc := SD1->D1_USERLGI
cUsuAlt := SD1->D1_USERLGA

If !Empty(cUsuInc)
	
	cCodInc := Substr(Embaralha(cUsuInc,1),1,15)
	cNomeInc:= UsrFullName(xRetInc(cCodInc))
	cUsuInc := FWLeUserLg("D1_USERLGI", 1)
	
	cCodAlt := Substr(Embaralha(cUsuAlt,1),1,15)
	cNomeAlt:= UsrFullName(xRetAlt(cCodAlt))
	cUsuAlt := FWLeUserLg("D1_USERLGA", 1)
	
	If Empty(SD1->D1_TES)
		Aviso("Consulta - Usu�rio",+"Inclus�o:"+Alltrim(cUsuInc)+" - "+Alltrim(cNomeInc)+Chr(13)+Chr(10)+;
		"Documento n�o classificado",{'OK'})
	Else
		Aviso("Consulta - Usu�rio",+"Inclus�o:"+Alltrim(cUsuInc)+" - "+Alltrim(cNomeInc)+Chr(13)+Chr(10)+;
		"Classifica��o:"+Alltrim(cUsuAlt)+" - "+Alltrim(cNomeAlt),{'OK'})
	Endif
	
	RestArea(aArea)
Else
	cCodigo := Substr(Embaralha(cUsu,1),1,15)
	cNome := UsrFullName(xRetCUsr(cCodigo))
	
	Aviso("Nome do Usu�rio da Inclus�o:",Alltrim(cCodigo)+" - "+Alltrim(cNome),{'OK'})
Endif

Return

// Retorna Codigo de Usuario
Static Function xRetCUsr(cCodigo)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cCodUser := CriaVar("AN_USER")

// OS 1027-12
PswOrder(2)
If PswSeek(cCodigo)
	cCodUser := PswRet(1)[1][1]
ElseIf PswSeek(Alltrim(cCodigo)+"*")
	cCodUser := PswRet(1)[1][1]
Else
	PswOrder(1)
	If PswSeek(ALLTRIM(substr(cCodigo,3,6)))
		cCodUser := PswRet(1)[1][1]
	EndIf
EndIf
// FIM OS 1027-12

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return cCodUser

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �xRetInc   � Autor � Sergio Oliveira       � Data � Out/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Codigo de Usuario - Inclus�o                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MA103BUT.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xRetInc(cCodInc)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cCodUser := CriaVar("AN_USER")

// OS 1027-12
PswOrder(2)
If PswSeek(cCodInc)
	cCodUser := PswRet(1)[1][1]
ElseIf PswSeek(Alltrim(cCodInc)+"*")
	cCodUser := PswRet(1)[1][1]
Else
	PswOrder(1)
	If PswSeek(ALLTRIM(substr(cCodInc,3,6)))
		cCodUser := PswRet(1)[1][1]
	EndIf
EndIf
// FIM OS 1027-12

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return cCodUser

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �xRetAlt   � Autor � Douglas David         � Data � Fev/2017 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna Codigo de Usuario - Altera��o OS 0236-17           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MA103BUT.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xRetAlt(cCodAlt)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cCodUser := CriaVar("AN_USER")

PswOrder(2)
If PswSeek(cCodAlt)
	cCodUser := PswRet(1)[1][1]
ElseIf PswSeek(Alltrim(cCodAlt)+"*")
	cCodUser := PswRet(1)[1][1]
Else
	PswOrder(1)
	If PswSeek(ALLTRIM(substr(cCodAlt,3,6)))
		cCodUser := PswRet(1)[1][1]
	EndIf
EndIf

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return cCodUser

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� Programa   � xConRate()   � Autor � Flavio Novaes   � Data � 04/04/2007 ���
���������������������������������������������������������������������������Ĵ��
��� Descricao  � Consulta ao Rateio Exclusivo da CSU: Rotina u_A91RATEI().  ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � Exclusivo CSU.                                             ���
���������������������������������������������������������������������������Ĵ��
��� Observacao �                                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
STATIC FUNCTION xConRate()
LOCAL _aArea    := GETAREA()
LOCAL _aHeadAux := ACLONE(aHeader)
LOCAL _aColsAux := ACLONE(aCols)
LOCAL _nAux     := n
dbSelectArea('SF1')
U_A91RATEI()
RESTAREA(_aArea)
aHeader := ACLONE(_aHeadAux)
aCols   := ACLONE(_aColsAux)
n       := _nAux
RETURN
