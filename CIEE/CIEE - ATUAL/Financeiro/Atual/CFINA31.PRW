#INCLUDE "rwmake.ch"
#include "FINA240.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   � Autor � Claudio Barros     � Data �  09/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para validar a exclus�o do bordero                ���
���          � quando o movimento contabil for Real ou efetivado          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - FINA240 - Excluir o Bordero                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFINA31()
//��������������������������������������������������������������Ŀ
//� Carrega funcao Pergunte									     �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Parametros                                                   �
//� mv_par01   Considera t�tulos    ? Normais / Adiantamentos    �
//����������������������������������������������������������������

PRIVATE cFil240

PRIVATE aRotina := {	{ OemToAnsi(STR0001), "AxPesqui"   , 0 , 1} ,; //"Pesquisar"
						{ OemToAnsi(STR0003), "U_CFINA31A"  , 0 , 1} } //"Cancelar"
Private xConteudo
Private cLoteFin	:= Space(04)
Private cPadrao 	:= ""
Private cBenef		:= CriaVar("E5_BENEF")
Private nTotAGer 	:= 0
Private nTotADesp	:= 0
Private nTotADesc	:= 0
Private nTotAMul 	:= 0
Private nTotAJur 	:= 0
Private nValPadrao	:= 0
Private nValEstrang	:= 0
Private cBanco   	:= CriaVar("E1_PORTADO")
Private cAgencia 	:= CriaVar("E1_AGEDEP")
Private cConta 		:= CriaVar("E1_CONTA")
Private cCtBaixa 	:= GetMv("MV_CTBAIXA")
Private cAgen240 	:= CriaVar("A6_AGENCIA")
Private cConta240	:= CriaVar("A6_NUMCON")
Private cModPgto  	:= CriaVar("EA_MODELO")
Private cTipoPag 	:= CriaVar("EA_TIPOPAG")
Private cMarca   	:= GetMark( )
Private cLote
Private cCadastro
Private _cBordero

//��������������������������������������������������������������Ŀ
//� Procura o Lote do Financeiro                                 �
//����������������������������������������������������������������
LoteCont( "FIN" )

cCadastro := OemToAnsi( "Border� de Pagamentos" )

dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6, 1,22,75,"SE2",,"E2_NUMBOR")

dbSelectArea("SE2")
dbSetOrder(1)  && devolve ordem principal

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   �Autor  �Microsiga           � Data �  10/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFINA31A()

Local cNumbor 	:= Space(6),cBordAnt,cChave
LOCAL nSavRec 	:= SE2->( Recno() )
Local lDeleta 	:= .T.
Local lRetCfi

Private _cBordero
//��������������������������������������������������������������Ŀ
//� Verifica se data do movimento n�o � menor que data limite de �
//� movimentacao no financeiro    								 �
//����������������������������������������������������������������
If !DtMovFin()
	Return
Endif

//����������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                   �
//������������������������������������������������������������������������
pergunte("AFI240    ",.F.)

If !pergunte( "AFI240    ",.T.)
	Return Nil
EndIf

_cBordero := MV_PAR01
//����������������������������������������������������������������������Ŀ
//� Verifica se numero do bordero existe.                                �
//������������������������������������������������������������������������
If !(FA240NUMC())
	Return Nil
Endif

dbSelectArea( "SEA" )

dbSeek( xFilial("SEA")+_cBordero )
//��������������������������������������������������������������Ŀ
//� Procura os registros que compoem o bordero a ser cancelado   �
//����������������������������������������������������������������

While !Eof()
	dbselectarea("SEA")
	If SEA->(dbSeek( xFilial("SEA")+_cBordero ))
		
		IF SEA->EA_CART == "P"
			cLoja := Iif ( Empty (SEA->EA_LOJA) , "" , SEA->EA_LOJA )
			cChave := SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja
			dbSelectArea("SE2")
			dbSetOrder(1)
			dbSeek(xFilial("SE2")+ cChave)
			If EMPTY(SE2->E2_BAIXA)
				lDeleta := .T.
				If lDeleta
					RecLock( "SE2",.f. )
					Replace E2_NUMBOR With Space(6)
					Replace E2_PORTADO With Space(Len(SE2->E2_PORTADO ) )
					MsUnlock( )
					dbSelectArea("SEA")
					RecLock("SEA",.F.)
					dbDelete()
					MsUnlock( )
				Endif
			ELSE
				DbSelectArea("SE5")
				DbSetOrder(7) //PREFIXO+TITULO+PARCELA+TIPO+FORNECE+LOJA
				If DbSeek(xFilial("SE5")+ cChave)
					If SE5->E5_RECONC == "x"
						MsgAlert("Exclus�o n�o permitida, Titulo j� conciliado!!")
						Return
					Else
						lRetCfi := CFINA31B(_cBordero)
						IF lRetCfi == .T.
							CFINA31C(_cBordero)
							TFina080()
							lDeleta := .T.
							If lDeleta
								RecLock( "SE2",.f. )
								Replace E2_NUMBOR With Space(6)
								Replace E2_PORTADO With Space(Len(SE2->E2_PORTADO ) )
								MsUnlock( )
								dbSelectArea("SEA")
								RecLock("SEA",.F.)
								dbDelete()
								MsUnlock( )
							Endif
						ELSE
							MsgAlert("Exclus�o n�o permitida, contabiliza��o efetivada, Informe a contabilidade!!")
							Return
						ENDIF
					ENDIF
				ENDIF
			Endif
		Endif
	Else
		exit
	EndIf
	dbSelectArea( "SEA" )
//	dbSkip()
	SEA->(DBGOTOP())
Enddo

dbSelectArea("SE2")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   �Autor  �Microsiga           � Data �  10/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CFINA31B()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cQuery 	:= " "
Local _cFl 		:= CHR(13)+CHR(10)
Local _lRet 	:= .T.
Local _cAlias 	:= GetArea()
Local _nOrder

Private cString := "CT2"

/*
_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND SUBSTRING(CT2_KEY,1,23) = '"+xFilial("SEA")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+"' "+_cFl
*/

_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "
_cQuery += " FROM "+RetSqlName("CT2")+"  "
_cQuery += " WHERE D_E_L_E_T_ = ''  "
_cQuery += " AND CT2_ORIGEM LIKE '%"+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+_cBordero+"%' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)

TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	_lRet := .F.
EndIf

If Select("TRV") > 0
	TRV->(DbcloseArea())
Endif

RestArea(_cAlias)

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   �Autor  �Microsiga           � Data �  10/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function TFina080

Local _cAlias := GetArea()
Local aVetor := {}

lMsErroAuto := .F.

aVetor :={	{"E2_PREFIXO"	    ,SEA->EA_PREFIXO,Nil},;
			{"E2_NUM"	 	,SEA->EA_NUM,Nil},;
			{"E2_PARCELA"	,SEA->EA_PARCELA,Nil},;
			{"E2_TIPO"		,SEA->EA_TIPO,Nil},;
			{"E2_FORNECE"	,SEA->EA_FORNECE,Nil},;
			{"E2_LOJA"  	,SEA->EA_LOJA,Nil}}

MSExecAuto({|x,y| Fina080(x,y)},aVetor,5) //Exclusao

RestArea(_cAlias)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA31   �Autor  �Microsiga           � Data �  10/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CFINA31C(_cBordero)


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cQuery 	:= " "
Local _cFl 		:= CHR(13)+CHR(10)
Local _lRet 	:= .T.
Local _cAlias 	:= GetArea()

Private cString := "CT2"

dbSelectArea("SEA")

dbSelectArea("CT2")
dbSetOrder(1)
/*
_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND SUBSTRING(CT2_KEY,1,23) = '"+xFilial("SEA")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+"' "+_cFl
_cQuery += " ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC "+_cFl
*/

_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "
_cQuery += " FROM "+RetSqlName("CT2")+"  "
_cQuery += " WHERE D_E_L_E_T_ = ''  "
_cQuery += " AND CT2_ORIGEM LIKE '%"+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA+_cBordero+"%' "
_cQuery += " ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC "

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)

TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "9"
	
	While !TRV->(EOF())
		
		Dbselectarea("CT2")
		CT2->(DbSetorder(1))
		CT2->(Dbgotop())
		If CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC+TRV->CT2_LINHA))

			_cData   := TRV->CT2_DATA
			_cLote   := TRV->CT2_LOTE
			_cSblote := TRV->CT2_SBLOTE
			_cDoc    := TRV->CT2_DOC
			_cLinha  := TRV->CT2_LINHA
/*
		While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
			CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc
*/			
			RecLock("CT2",.F.)
			CT2->CT2_XUSER	:= cUserName
			CT2->CT2_XDTEXL	:= dDataBase
			CT2->(DbDeLete())
			CT2->(MsUnlock())
//			CT2->(DBSKIP())
//		End
		EndIf
		TRV->(DBSKIP())
	End
	
EndIf

If Select("TRV") > 0
	TRV->(DbcloseArea())
Endif

RestArea(_cAlias)

Return
