#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240CAN   � Autor � Claudio Barros     � Data �  09/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para validar a exclus�o do titulo         ���
���          � quando o movimento contabil for Real ou efetivado          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - FINA240 - Excluir o lancamento Contabil          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F240CAN


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := .T.
Local _cAlias := GetArea()
Private cString := "CT2"

dbSelectArea("SE2")

dbSelectArea("CT2")
dbSetOrder(1)


_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)


TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	
	CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC))	

    _cData   := TRV->CT2_DATA
    _cLote   := TRV->CT2_LOTE
    _cSblote := TRV->CT2_SBLOTE
    _cDoc    := TRV->CT2_DOC
    _cLinha  := TRV->CT2_LINHA
		

	While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
	      CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc 
	      
		RecLock("CT2",.F.)
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		CT2->(DBSKIP())
	End


U_TFina080()
//    fa080Can("SE2",SE2->(RECNO()),5)

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
���Programa  �TFINA050  �Autor  �    Suporte Rdmake  � Data �  04/10/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exemplo Utilizacao rotina automatica-Titulos a Pagar       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Devem ser passados no array(s) todos os campos obrigatorios

User Function TFina080()
Local aVetor := {}

lMsErroAuto := .F.



aVetor :={	{"E2_PREFIXO"	,'999',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'1',Nil},;
				{"E2_TIPO"		,'NDF',Nil},;			
				{"E2_NATUREZ"	,'001',Nil}}

MSExecAuto({|x,y,z| Fina080(x,y,z)},aVetor,,5) //Exclusao


If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif

Return