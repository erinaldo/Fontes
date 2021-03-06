#Include "Protheus.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � CSATUSZJ � Autor � Renato Carlos          � Data � 30/03/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �ATUALIZA AMARRA��O USER X PRODUTO COM OS PEDIDOS DO FULLFIL  ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Especifico CSU                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function CSATUSZJ()

	Processa( { || ProcAtu() }, 'Efetuando atualiza��o SZJ.....' )
	
Return()

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � ProcAtu  � Autor � Renato Carlos          � Data � 30/03/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Processa  ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Especifico CSU                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function ProcAtu()

Local _cQuery  := ""
Local _cQuery2 := ""
Local _cGrupo  := '000074'
Local _cAliasSB1 := GetNextAlias()
Local _cAliasSZJ := GetNextAlias()
Local _cItem := Nil
Local _nCont := 0

_cQuery := ""
_cQuery += "SELECT B1_COD, B1_DESC FROM "+RetSqlName("SB1")+" "
_cQuery += "WHERE B1_COD LIKE '%F%' "
_cQuery += "AND D_E_L_E_T_ = ''"

_nCont := U_MontaView( _cQuery, _cAliasSB1 )

dbSelectArea(_cAliasSB1)
(_cAliasSB1)->( DbGoTop() )

_cQuery2 := ""
_cQuery2 += "SELECT TOP 1 ZJ_ITEM FROM "+RetSqlName("SZJ")+" "
_cQuery2 += "WHERE ZJ_GRUSER = '000074' "
_cQuery2 += "AND D_E_L_E_T_ = ''  "
_cQuery2 += "ORDER BY ZJ_ITEM DESC "

U_MontaView( _cQuery2, _cAliasSZJ )

dbSelectArea(_cAliasSZJ)
(_cAliasSZJ)->( DbGoTop() )

_cItem := ALLTRIM((_cAliasSZJ)->ZJ_ITEM)
_cItem := "0"+_cItem

dbSelectArea("SZJ")
SZJ->( DbSetOrder(1) )
SZJ->( DbGoTop() )

ProcRegua( _nCont )
BEGIN TRANSACTION

While (_cAliasSB1)->( !Eof() )
	IncProc()
	_cItem := Soma1( _cItem )
	//If SZJ->(!DbSeek(xFilial("SZJ")+_cGrupo)
	RecLock("SZJ", .T.)
	SZJ->ZJ_FILIAL   := xFilial("SZJ")
	SZJ->ZJ_ITEM     := Alltrim(_cItem)
	SZJ->ZJ_USER     := "******"
	SZJ->ZJ_PRODUTO  := (_cAliasSB1)->B1_COD
	SZJ->ZJ_GRUSER   := _cGrupo
	SZJ->ZJ_PRONAME	 :=(_cAliasSB1)->B1_DESC
	MsUnlock()

	(_cAliasSB1)->( DbSkip() )
EndDo

END TRANSACTION

dbCloseArea(_cAliasSZJ)
dbCloseArea(_cAliasSB1)

Return()


