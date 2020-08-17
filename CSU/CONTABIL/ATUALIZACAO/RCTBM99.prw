#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"       
#DEFINE c_BR Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBCTTT  �Autor  �Vin�cius Greg�rio   � Data �  06/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o do c�digo do centro de custo transi- ���
���          � t�rio                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBCTTT(_cCodCTT)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()   
Local cAnoMesN	:= ""
Local lRetorno	:= .T.

//������������������������������������������������Ŀ
//�Validar se o centro de custo � mesmo transit�rio�
//��������������������������������������������������
dbSelectArea("CTT")
dbSetOrder(1)
If dbSeek(xFilial("CTT")+_cCodCTT,.F.)
	If Alltrim(CTT->CTT_XTRANS) == "N" .or. Empty(CTT->CTT_XTRANS)
		lRetorno := .F.    
		
		Aviso("Aviso","O centro de custo selecionado n�o � transit�rio. Por favor, selecione um centro de custo transit�rio.",{"OK"},,"Aten��o",,"BMPPERG")			
		
	Endif
Endif

RestArea(aArea)
Return lRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBCTTV  �Autor  �Vin�cius Greg�rio   � Data �  06/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o do c�digo do centro de custo transi- ���
���          � t�rio                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBCTTV(_cCodCTT)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()   
Local cAnoMesN	:= ""
Local lRetorno	:= .T.

//����������������������������������������������Ŀ
//�Validar se o centro de custo n�o � transit�rio�
//������������������������������������������������
dbSelectArea("CTT")
dbSetOrder(1)
If dbSeek(xFilial("CTT")+_cCodCTT,.F.)
	If Alltrim(CTT->CTT_XTRANS) == "S"
		lRetorno := .F.
		
		Aviso("Aviso","O centro de custo selecionado � transit�rio e n�o pode ser utilizado para essa opera��o. Por favor, selecione outro centro de custo.",{"OK"},,"Aten��o",,"BMPPERG")			
		
	Endif
Endif

RestArea(aArea)
Return lRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7ULTR  �Autor  �Vin�cius Greg�rio   � Data �  07/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pega a �ltima revis�o ativa da tabela de rateio para       ���
���          � determinado per�odo.                                       ���
���          �                                                            ���
���          � lAtiva = Se pega a ultima revis�o ativa ou n�o.            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7ULTR(cCodRat,cAnoMes,lAtiva)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""

Local cQry		:= ""

//�������������Ŀ
//�Monta a query�
//���������������
cQry	:= "SELECT TOP 1 (ZB7_REVISA) TOP_REVISAO FROM "+RetSqlName("ZB7")+" "+c_BR//VG - SQLServer
//cQry	:= "SELECT ZB7_REVISA TOP_REVISAO FROM "+RetSqlName("ZB7")+" "+c_BR//VG - Postgres, Mysql e Oracle
cQry	+= "WHERE ZB7_FILIAL = '"+xFilial("ZB7")+"' "+c_BR
cQry	+= "AND ZB7_CODRAT = '"+cCodRat+"' "+c_BR
cQry	+= "AND ZB7_ANOMES = '"+cAnoMes+"' "+c_BR
If lAtiva
	cQry	+= "AND ZB7_ATIVO = 'A' "+c_BR
Endif
cQry	+= "AND D_E_L_E_T_ <> '*' "+c_BR
//cQry	+= "AND ROWNUM < 1 "+c_BR//VG - Oracle
cQry	+= "ORDER  BY ZB7_FILIAL, ZB7_CODRAT, ZB7_ANOMES, ZB7_REVISA DESC "+c_BR
//cQry	+= "LIMIT 1 "+c_BR//VG - Postgres e MySql

If Select("TMPTOP") > 0
	DbSelectArea("TMPTOP")
	DbCloseArea()
Endif

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TMPTOP", .F., .T.)}, "Verificando a �ltima revis�o da tabela de rateio...")

//��������������������������������������������
//�Verifica se retornou alguma coisa na query�
//��������������������������������������������
cRetorno	:=  TMPTOP->TOP_REVISAO

RestArea(aArea)
Return cRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7REVA  �Autor  �Vin�cius Greg�rio   � Data �  08/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que verifica se existe uma revis�o ativa para o     ���
���          � c�digo de rateio e per�odo informado.                      ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7REVA(cCodRat,cAnoMes)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local lRetorno	:= .F.
Local cQry		:= ""

//�������������������������������������������������Ŀ
//�Se for utilizado na digita��o da nota de entrada.�
//���������������������������������������������������
If IsInCallStack("MATA103")
	//cAnoMes	:= SubStr(DtoS(dDemissao),1,6)	
	cAnoMes		:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
Endif

//�������������Ŀ
//�Monta a query�
//���������������
cQry	:= "SELECT COUNT(*) CONTAGEM FROM "+RetSqlName("ZB7")+" "+c_BR
cQry	+= "WHERE ZB7_FILIAL = '"+xFilial("ZB7")+"' "+c_BR
cQry	+= "AND ZB7_CODRAT = '"+cCodRat+"' "+c_BR
cQry	+= "AND ZB7_ANOMES = '"+cAnoMes+"' "+c_BR
cQry	+= "AND ZB7_ATIVO = 'A' "+c_BR
cQry	+= "AND D_E_L_E_T_ <> '*' "

If Select("TMPCON") > 0
	DbSelectArea("TMPCON")
	DbCloseArea()
Endif

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TMPCON", .F., .T.)}, "Verificando a �ltima revis�o da tabela de rateio...")

If TMPCON->CONTAGEM > 0
	lRetorno	:= .T.
Else
	Aviso("Aviso","N�o existe revis�o ativa para a tabela de rateio selecionada nesse per�odo. Por favor, verifique o cadastro de tabelas de rateio.",{"OK"},,"Aten��o",,"BMPPERG")				
Endif

RestArea(aArea)
Return lRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7CTRA  �Autor  �Vin�cius Greg�rio   � Data �  10/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna o centro de custo transit�rio da tabela ���
���          � de rateio.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7CTRA(cCodRat)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""
Local cAnoMes	:= ""
Local cUltRev	:= ""

If IsInCallStack("MATA103")

	//cAnoMes	:= SubStr(DtoS(dDemissao),1,6)                                                      
	//���������������Ŀ
	//�VG - 2011.06.06�
	//�����������������
	cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	cUltRev	:= U_RZB7ULTR(cCodRat,cAnoMes,.T.)

	dbSelectArea("ZB7")
	dbSetOrder(1)             
	If dbSeek(xFilial("ZB7")+cCodRat+cAnoMes+cUltRev,.F.)
		cRetorno	:= ZB7->ZB7_CCTRAN	
	Endif

Endif

RestArea(aArea)
Return cRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7ITRA  �Autor  �Vin�cius Greg�rio   � Data �  21/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna a unidade de neg�rio transit�ria da     ���
���          � tabela de rateio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7ITRA(cCodRat)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""
Local cAnoMes	:= ""
Local cUltRev	:= ""

If IsInCallStack("MATA103")

//	cAnoMes	:= SubStr(DtoS(dDemissao),1,6)
	//���������������Ŀ
	//�VG - 2011.06.06�
	//�����������������
	cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	cUltRev	:= U_RZB7ULTR(cCodRat,cAnoMes,.T.)

	dbSelectArea("ZB7")
	dbSetOrder(1)             
	If dbSeek(xFilial("ZB7")+cCodRat+cAnoMes+cUltRev,.F.)
		cRetorno	:= ZB7->ZB7_ITTRAN
	Endif

Endif

RestArea(aArea)
Return cRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7CLRA  �Autor  �Vin�cius Greg�rio   � Data �  21/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna a opera��o transit�ria da               ���
���          � tabela de rateio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7CLRA(cCodRat)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""
Local cAnoMes	:= ""
Local cUltRev	:= ""

If IsInCallStack("MATA103")

//	cAnoMes	:= SubStr(DtoS(dDemissao),1,6)
	//���������������Ŀ
	//�VG - 2011.06.06�
	//�����������������
	cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	cUltRev	:= U_RZB7ULTR(cCodRat,cAnoMes,.T.)

	dbSelectArea("ZB7")
	dbSetOrder(1)             
	If dbSeek(xFilial("ZB7")+cCodRat+cAnoMes+cUltRev,.F.)
		cRetorno	:= ZB7->ZB7_CLTRAN
	Endif

Endif

RestArea(aArea)
Return cRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RZB7LCUS  �Autor  �V. Greg�rio         � Data �  10/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para limpar o o rateio digitado anteriormente       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RZB7LCUS(cCodRat)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= cCodRat

If IsInCallStack("MATA103") .and. IsInCallStack("U_RFINA06")
	//�����������������������������������������������Ŀ
	//�Limpar a tabela de rateios por centro de custo.�
	//�������������������������������������������������
	dbSelectArea("CUS")
	dbGoTop()
	If DbSeek ( aCols[n][nPosNaturez] )
		Do While CUS->( !Eof() ) .And. CUS->NATUREZ == aCols[n][nPosNaturez]
			RecLock("CUS",.F.)
			CUS->(dbDelete())
			MsUnlock()	     
			CUS->(dbSkip())
		EndDo
	Endif

Endif
	
RestArea(aArea)
Return cRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSF1EXC   �Autor  �V. Greg�rio         � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que encapsula a exclus�o de documento de entrada.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*User Function RSF1EXC()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local nRecNo	:= SF1->(RecNo())
Private nOpcX	:= 5       
Private nOpc	:= 5

MsgStop(Alltrim(STR(nRecNo)))
//����������������������������������������������������������������Ŀ
//�Verifica se a nota cont�m rateio externo e se foi contabilizada.�
//������������������������������������������������������������������
If SF1->F1_XPRORAT	== '1'
	Aviso("Aviso","O documento de entrada j� teve o seu rateio processado. Por favor, estorne os lan�amentos antes de excluir a nota.",{"OK"},,"Aten��o",,"BMPPERG")
Else
//	A103NFISCAL("SF1",SF1->(RecNo()),5)
	A103NFISCAL("SF1",nRecno,nOpcX)
Endif

Return*/


/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �GetCompetencia �Autor  �Vin�cius Greg�rio � Data �  06/06/11   ���
����������������������������������������������������������������������������͹��
���Desc.     � Fun��o utilit�ria para pegar a compet�ncia de um documento de ���
���          � entrada.                                                      ���
����������������������������������������������������������������������������͹��
���Uso       � Gen�rico                                                      ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function GetCompetencia(cChave)
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������
Local aArea		:= GetArea()
Local cRetorno	:= ""

//������������������������������������������������Ŀ
//�Procura o primeiro item do documento de entrada.�
//��������������������������������������������������   
dbSelectArea("SD1")
dbSetOrder(1)//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
If dbSeek(cChave,.F.)
	cRetorno	:= STRTRAN(SD1->D1_XDTAQUI,"/","")
	cRetorno	:= Substr(cRetorno,3,4)+Substr(cRetorno,1,2)
Endif

RestArea(aArea)
Return cRetorno