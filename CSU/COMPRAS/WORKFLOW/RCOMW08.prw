#Include 'RWMAKE.CH'
#Include 'TBICONN.CH'
#include 'Ap5Mail.ch'
#Include 'TOPCONN.CH'

#DEFINE ENTER CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMW08   �Autor  �Renato Lucena Neves � Data �  02/16/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail quando a NF de entrada estiver digitada a mais���
���          � de 2 dias sem conferencia do contabil e/ou custos          ���
�������������������������������������������������������������������������͹��
���Uso       � AP8-CSU Scheduller                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCOMW08(_aPar)

Private _aUsuarios	:= {}  


//PREPARE ENVIRONMENT EMPRESA _aPar[1] FILIAL _aPar[2]	//abre a empresa e filial passada por paramtro
RpcSetEnv ( _aPar[1],_aPar[2])

_aUsuario	:= AllUsers()
SM0->(DbGoTop())

WHILE !SM0->(EOF())
	If SM0->M0_CODIGO == _aPar[1]
		DocAtrasado({SM0->M0_CODIGO,SM0->M0_CODFIL})
	endif
	SM0->(DBSkip())
ENDDO

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DocAtrasadoAutor  �Renato Lucena Neves � Data �  14/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona os documentos que est�o atrasados e chama a funcao��
���          � de envio de e-mail                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DocAtrasado(_aPar)

Local _cQuery		:= ""
Local _cUsuario		:= ""
Local _cEmail		:= ""
Local _cNome		:= ""
Local _cTo			:= ""
Local _nTempo		:= 0

//PREPARE ENVIRONMENT EMPRESA _aPar[1] FILIAL _aPar[2]	//abre a empresa e filial passada por paramtro
RpcSetEnv ( _aPar[1],_aPar[2])

//F1_XCONF01	conferido pelo fiscal
//F1_XCONF02	conferido pelo custo
//F1_XCONF03	conferido pelo pagos

_nTempo:=GetMV("MV_XTPCONF")

_cQuery := " select F1_DTDIGIT,F1_XCONF02, F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_USERLGI "
_cQuery += " from "+RetSQLName('SF1')
_cQuery += " where ( F1_FILIAL='"+xFilial('SF1')+"' and F1_XCONF02='' and F1_XCONF03='' and F1_XCONF01='' and D_E_L_E_T_='' and "
_cQuery += " F1_DUPL<>'' and F1_DTDIGIT<='"+dtos(Date()-_nTempo)+"') "
_cQuery += " or (F1_FILIAL='"+xFilial('SF1')+"' and F1_XCONF02<>'' and F1_XCONF03='' and F1_XCONF01='' and D_E_L_E_T_='' and F1_DUPL<>'' and "
_cQuery += " cast(substring(F1_XCONF02,4,3)+substring(F1_XCONF02,1,3)+substring(F1_XCONF02,7,2) as datetime)<='"+dtos(date()-_nTempo)+"') "

memowrit('RCOMW08.sql',_cQuery)

TcQuery _cQuery New Alias "QRY1"
DbselectArea('QRY1')
DbGoTop()

While QRY1->(!EOF())
	
	//�����������������������������������������������������Ŀ
	//�Monta array com os e-mails que receber�o as mensagens�
	//�������������������������������������������������������
	_cUsuario := Substr(Embaralha(QRY1->F1_USERLGI,1),1,15)
	_cTo := _fEnvia(_cUsuario)  //monta array com lista de e-mails para ser enviado.
	//	qout('PARA: '+_cto)
	
	//��������������������������������Ŀ
	//�Mensagem a ser enviada no e-mail�
	//����������������������������������
	_cFornece := GetAdvFVal('SA2','A2_NREDUZ',xFilial('SA2')+QRY1->(F1_FORNECE+F1_LOJA),1,'')
	_cMensagem := "Aten��o:"+ENTER
	_cMensagem += ENTER
	_cMensagem += "At� o presente momento n�o foi acusado, pela �rea Fiscal e Contas a Pagar o recebimento do documento de entrada "+QRY1->F1_DOC+" s�rie "+QRY1->F1_SERIE
	_cMensagem += "do fornecedor "+QRY1->F1_FORNECE+"/"+QRY1->F1_LOJA+" - "+alltrim(_cFornece)+", digitado em "+dtoc(stod(QRY1->F1_DTDIGIT))+"."+ENTER
	_cMensagem += "Favor enviar o referido documento o mais r�pido poss�vel � �rea Fiscal. Evitando assim, atraso no prazo de pagamento e fechamento cont�bil."+ENTER
	_cMensagem += ENTER
	_cMensagem += "CONTABILIDADE/FISCAL "+ENTER
	_cMensagem += ENTER
	_cMensagem += ENTER
	_cMensagem += ENTER
	_cMensagem += "Este E-Mail � gerado automaticamente pelo sistema. N�o responda o mesmo!"
	
	u_EnviaEMail(_cTo,_cMensagem,'Conferencia em atraso!') //envia o e-mail
	
	QRY1->(DbSkip())
enddo

DbCloseArea('QRY1')

DbCloseAll()
//RESET ENVIRONMENT

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fEnvia   �Autor  �Renato Lucena Neves � Data �  22/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para montar o array com os e-mails que ir�o receber ���
���          � o workflow                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP8-CSU                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _fEnvia(_cUsua)

Local _cEMail:= ""
Local _nPos	 := 0
Local _cCodUser:=""

//���������������������������
//�Busca o codigo do usu�rio�
//���������������������������
_nPos:=0
_nPos:=aScan(_aUsuario,{|x| alltrim(x[1][2])==alltrim(_cUsua) })
If _nPos>0
	_cCodUser:=_aUsuario[_nPos][1][1]
endif

//����������������������������������������������������Ŀ
//�Pega o e-mail do usu�rio que incluiu a NF de entrada�
//������������������������������������������������������
_cEmail:=UsrRetMail(_cCodUser)

If !Empty(_cEmail)
	_cEmail := alltrim(_cEmail)+";"+GetMV("MV_XMAILCO")
else
	_cEMail	:= GetMV("MV_XMAILCO")
endif

Return _cEMail

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENVIAEMAIL�Autor  �Renato Lucena Neves � Data �  22/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para envio de e-mail                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8 - CSU                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EnviaEMail(cTo,cMensag,cAssunto)
Local cServer   := GetMV("MV_RELSERV")
Local cAccount  := GetMV("MV_RELACNT")
Local cEnvia    := GetMV("MV_RELACNT")
Local cPassword := GetMV("MV_RELPSW")
Local _cError	:= ""
Local _cRecebe   := cTo
Local cMensagem := cMensag

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	lAutorizou:=MAILAUTH(cAccount,cPassword)
	
	If lAutorizou
		SEND MAIL FROM alltrim(cEnvia) TO alltrim(_cRecebe) SUBJECT cAssunto BODY cMensagem RESULT lEnviado
		If !lEnviado
			Get Mail Error _cError
			qOut(_cError)
		endif
	else
		qOut('N�o foi poss�vel enviar o e-mail com a conta'+alltrim(cAccount)+'. Verifique o usu�rio e senha configurado no Workflow!')
	endif
	DISCONNECT SMTP SERVER Result lDisConectou
	
	If !lDisconectou
		qOut('N�o foi poss�vel desconectar do servidor de e-mail!')
	endif
else
	qOut('N�o foi possivel se conectar ao servidor '+alltrim(cServer))
endif

Return
