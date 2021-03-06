#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA080CHK  � Autor �CLAUDIO BARROS      � Data �  26/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada acionado no momento da selecao da baixa   ���
���          � do titulo a pagar manual.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - FINA080                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA080CHK()

Local _cPref	:= SE2->E2_PREFIXO
Local _dDtEmi	:= SE2->E2_EMISSAO
Local _dDtIni	:= StoD('13/03/01') //Data que a rotina entrou em Produ��o
Local _lRet := .T.

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
IF cEmpAnt == '01'	// Somente CIEE-SP tem o novo controle das FLs
	IF ALLTRIM(FUNNAME()) <> 'AFIN050TP'
		IF _dDtEmi >= _dDtIni
			IF _cPref == 'FL '
				Alert("T�tulos FL n�o poder�o ser Baixados por esta Rotina") 
				_lRet	:= .F.
			ENDIF 
		ENDIF
	Endif
ENDIF
 
IF ALLTRIM(SE2->E2_NATUREZ) == "9.99.99"
		MsgAlert("Titulo nao reclassificado, Reclassifique a natureza 9.99.99!!!",SE2->E2_PREFIXO+" "+SE2->E2_NUM)
	_lRet := .F.
Endif

Return(_lRet)

