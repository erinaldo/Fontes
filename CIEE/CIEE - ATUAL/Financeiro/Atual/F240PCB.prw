#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   � Autor � Claudio Barros     � Data �  09/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para validar a exclus�o do bordero        ���
���          � quando o movimento contabil for Real ou efetivado          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - FINA240 - Excluir o Bordero                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA240Canc � Autor � Paulo Boschetti       � Data � 25/11/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cancela os borderos                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FA240Canc()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA240                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CFINA31()

Local cNumbor 	:= Space(6),cBordAnt,cChave
LOCAL nSavRec 	:= SE2->( Recno() )
Local lDeleta 	:= .T.

//��������������������������������������������������������������Ŀ
//� Verifica se data do movimento n�o � menor que data limite de �
//� movimentacao no financeiro    										  �
//����������������������������������������������������������������
If !DtMovFin()
	Return
Endif

//����������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                   �
//������������������������������������������������������������������������
pergunte("AFI240",.F.)
If !pergunte( "AFI240",.T.)
	Return Nil
EndIf

//����������������������������������������������������������������������Ŀ
//� Verifica se numero do bordero existe.                                �
//������������������������������������������������������������������������
If !(FA240NUMC())
	Return Nil
Endif

dbSelectArea( "SEA" )
dbSeek( cFilial+mv_par01 )
//��������������������������������������������������������������Ŀ
//� Procura os registros que compoem o bordero a ser cancelado   �
//����������������������������������������������������������������
While !Eof() .and. SEA->EA_NUMBOR == mv_par01
	IF SEA->EA_CART == "P"
		cLoja := Iif ( Empty (SEA->EA_LOJA) , "" , SEA->EA_LOJA )
		cChave := SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja
		dbSelectArea("SE2")
		dbSetOrder(1)
		dbSeek(cFilial + cChave)
		If EMPTY(SE2->E2_BAIXA)
			lDeleta := .T.
			If lDeleta
				RecLock( "SE2" )
				Replace E2_NUMBOR With Space(6)
				Replace E2_PORTADO With Space(Len(SE2->E2_PORTADO ) )
				MsUnlock( )
				dbSelectArea("SEA")
				RecLock("SEA",.F.,.T.)
				dbDelete()
				MsUnlock( )
			Endif
			
		ELSE
			IF CFINA31A() == .T.
				lDeleta := .T.
				If lDeleta
					RecLock( "SE2" )
					Replace E2_NUMBOR With Space(6)
					Replace E2_PORTADO With Space(Len(SE2->E2_PORTADO ) )
					MsUnlock( )
					dbSelectArea("SEA")
					RecLock("SEA",.F.,.T.)
					dbDelete()
					MsUnlock( )
				Endif
				fa080Can("SE2",SE2->(RECNO()),5)
			ELSE
				MsgAlert("Exclus�o n�o permitida, contabiliza��o efetivada, Informe a contabilidade!!")
				Return
			ENDIF
			
			
		Endif
		
	Endif
	dbSelectArea( "SEA" )
	dbSkip( )
Enddo

dbSelectArea("SE2")

Return

Static Function CFINA31A()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := .T.
Local _cAlias := GetArea()
Local _nOrder
Private cString := "CT2"



DBSELECTAREA("SE2")
SE2->(DBSETORDER(1))
SE2->(DBSEEK(xFILIAL("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA))



_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SEA")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)

TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	_lRet := .T.
EndIf

If Select("TRV") > 0
	TRV->(DbcloseArea())
Endif


RestArea(_cAlias)

Return(_lRet)

