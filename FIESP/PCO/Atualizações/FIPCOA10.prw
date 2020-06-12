#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "ap5mail.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIPCOA10  �Autor  �TOTVS               � Data �  10/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para executar a finalizacao da Digitacao			  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAPID048)                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FIPCOA10
Local lRet		:= .T.
Local lAchou	:= .F.
Local aVet		:= {}
Local nPosRespCC:= 0
Local _aArea	:= GetArea()
Local _aAreaCTT	:= CTT->(GetArea())
Local aPergs	:= {}
Local nTamCC	:= Space(TamSx3("CTT_CUSTO")[1])
Local _aRet 	:= {}
Local CTG    	:= '' 
Private _aCTT   := {}

//����������������������������������������������������������Ŀ
//�Executa validacao para prosseguir finalizacao da Digitacao�
//������������������������������������������������������������

//������������������������������������������������������������
//�Verifica se Acols dos itens AK2 nao esta em modo de edicao�
//������������������������������������������������������������
If Eval(oWrite:bWhen)
	MsgStop("Existe itens que n�o foram gravados, grave os itens para Finaliza��o da Digita��o","Atencao")
	lRet:= .F.
Else
	aAdd(aPergs,{1,"CC De : ",nTamCC,"@!","","CTT","",nTamCC,.F.})
	aAdd(aPergs,{1,"CC At�: ",Replicate("Z",TamSx3("CTT_CUSTO")[1]),"@!","","CTT","",nTamCC,.T.})
	
	If  ParamBox(aPergs,"Selecione a CC para finaliza��o",@_aRet)		
		/*
		lRet:= .F.		
	
		//������������������������������������������������������������������
		//�Posiciona na CTT para verificar se usuario e resp. de C.Custo   �
		//������������������������������������������������������������������
		CTT->(DBCloseArea())
		dbSelectArea('CTT')
		CTT->(dbSetOrder(1))
		
		//����������������������������Ŀ
		//�Carrega o Vetor do LISTBOX  �
		//������������������������������
		CTT->(dbEval({|| AADD(aVet, {CTT->(CTT_CUSTO),;
		CTT->(CTT_DESC01),;
		CTT->(CTT_XUSER)})},, {|| !EOF() }))
		CTT->(dbCloseArea())
		
		//������������������������������������������������������Ŀ
		//�Valida se existe registros como responsavel de um CTT |
		//��������������������������������������������������������
		nPosRespCC:= aScan(aVet,{|x| AllTrim(x[3])==__CUSERID})
		
		If nPosRespCC == 0 .and. __CUSERID <> "000000"
			MsgStop("Somente o usuario responsavel por Centro de Custo poder� executar a rotina para Finalizar Digita��o!","Atencao")
			lRet:= .F.
			Return
		Endif     
		*/
		
		IF SELECT("TRB1")>0
			DbSelectArea("TRB1")
			DbCloseArea()
		EndIf                
		
		CTG  := " Select CTT_CUSTO  "
		CTG  += " FROM " + RetSqlName("CTT")
		CTG  += "   Where CTT_XUSER   = '" + __CUSERID  +"' "
		CTG  += "   and   CTT_CUSTO >= '" + _aRet[1]   +"' "
		CTG  += "   and   CTT_CUSTO <= '" + _aRet[2]   +"' "
		CTG  += "   and   D_E_L_E_T_ = ' '     "
		DBUseArea(.T.,"TOPCONN",TCGENQRY(,,CTG),"TRB1",.F.)          
		
		If Empty(TRB1->CTT_CUSTO)
			MsgAlert("Conforme Faixa de Centro de Custo mencionada, foi identificado que o seu Usu�rio n�o � o respos�vel por nenhum dos Centros de Custos. A rotina para Finalizar Digita��o, n�o poder� ser executada!","Atencao")
			lRet:= .F.
			Return    
		Else
		    	DbGoTop("TRB1")
				While !TRB1->(Eof())				   	  
			        aAdd(_aCTT,{TRB1->CTT_CUSTO})				    
					TRB1->(DBSkip())
				EndDO   	
				TRB1->(Dbclosearea())		  	
		Endif
		 
	Endif    
	
		
	//������������������������������������������������Ŀ
	//�Executa Gravacao para finalizar item da Planilha�
	//��������������������������������������������������
	If lRet
		Processa({|| GrvFlzDig(_aRet) },"Aguarde","Processando itens...")
	Endif
	
Endif

RestArea(_aAreaCTT)
RestArea(_aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvFlzDig �Autor  �TOTVS               � Data �  15/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava campo AK2_XSTS=1 (Finalizado) conforme acesso 		  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GrvFlzDig(_aRet)
//Local lAcessOk		:= .F.
Local lVisualiza	:= .T.
Local _aArea		:= GetArea()
Local _aAreaAK2		:= AK2->(GetArea())
Local _aAreaCTT		:= CTT->(GetArea())
Local aUOFim		:= {}
Local cDescCC		:= ""

//������������������������������������������������������������������
//�Verifica se usuario possui acesso ao C.Custo e finaliza item    �
//�conforme os parametros informado de Centro de Custo			   �
//������������������������������������������������������������������
dbSelectArea('AK2')
AK2->(dbSetOrder(1))
AK2->(dbSeek(xFilial('AK2')+AK1->(AK1_CODIGO+AK1_VERSAO)))

Begin Transaction

While !Eof() .and. AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO) = AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO)
	
  	If  aScan(_aCTT,{|x| AllTrim(x[1])==AllTrim(AK2->(AK2_CC))}) > 0 
		
		RecLock("AK2", .F.)
		AK2->AK2_XSTS := '1'
		AK2->(MsUnLock())
		
		nPos := Ascan(aUOFim,{|x| AllTrim(x[1])==AllTrim(AK2->(AK2_CC))})
		
		If nPos == 0
			cDescCC:= Posicione('CTT',1,xFilial('CTT')+AK2->AK2_CC,'CTT_DESC01')
			AADD(aUOFim,{AK2->AK2_CC,cDescCC})
		Endif
		
	Endif
	AK2->(dbSkip())
Enddo

End Transaction

If !Empty(aUOFim)
	//������������������������������������������������������������������������������
	//�Enviar email para o responsavel da planilha com a finalizacao do C.Custo    �
	//������������������������������������������������������������������������������
	EmailRPlan(aUOFim)
	
	MsgAlert("CC(s) Finalizada(s) com sucesso !", "Processamento conclu�do")
Endif

// Somente para visualiza��o completa
IF MV_PAR01 == "1"
	For i := 1 to Len(oGD[1]:aCols)
		_cCC  := GDFieldGet("AK2_CC",i,,oGD[1]:aHeader,oGD[1]:aCols)
		_cID  := GDFieldGet("AK2_ID",i,,oGD[1]:aHeader,oGD[1]:aCols)
		_cOpc := Posicione("AK2",8,XFilial("AK2")+AK1->(AK1_CODIGO+AK1_VERSAO)+_cCC+_cID,"AK2_XSTS")
		GDFieldPut("AK2_XSTS",_cOpc,i,oGD[1]:aHeader,oGD[1]:aCols)
	Next
ENDIF

RestArea(_aAreaAK2)
RestArea(_aAreaCTT)
RestArea(_aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIVldAK2_CC_CV_IC �TOTVS               � Data �  15/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para validar acesso do usuario conforme registro AK2 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FIVldAK2_CC_CV_IC(lVisualiza)
Local lRet    := .T.
Local cCtaOrc := AK2->AK2_CO
Local cCCusto := AK2->AK2_CC
Local cItCtb  := AK2->AK2_ITCTB
Local cClVlr  := AK2->AK2_CLVLR
Local cRevisa := AK1->AK1_VERSAO
Local lMore

If !Empty(cCtaOrc)
	dbSelectArea("AK3")
	dbSetOrder(1)
	If MsSeek(xFilial()+AK1->AK1_CODIGO+cRevisa+cCtaOrc)
		lMore := .T.
		While lMore
			// verifica centro de custo
			lRet := !Empty(cCCusto)
			If lRet
				lRet := PcoCC_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"CCUSTO",cRevisa,cCCusto,If(lVisualiza, 1, 2) )
				If ! lRet
					Exit
				EndIf
			EndIf
			//verifica item contabil
			lRet := !Empty(cItCtb)
			If lRet
				lRet := PcoIC_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"ITMCTB",cRevisa,cItCtb,If(lVisualiza, 1, 2) )
				If ! lRet
					Exit
				EndIf
			EndIf
			//verifica classe de valor
			lRet := !Empty(cClVlr)
			If lRet
				lRet := PcoCV_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"CLAVLR",cRevisa,cClVlr,If(lVisualiza, 1, 2) )
				If 	! lRet
					Exit
				EndIf
			EndIf
			//Se nao sair em nenhum if encerra o laco e retorna .T.
			lRet  := .T.
			lMore := .F.
		End
	EndIf
EndIf

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EmailRespPlan   �TOTVS                 � Data �  22/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia email para o responsavel da planilha referente ao  	  ���
���          �ao fechamento de um C.Custo (CC)							  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EmailRPlan(aUOFim)
Local cEmailRPlan:= ""

cEmailRPlan:=UsrRetMail(AK1->(AK1_XRESPP))

if !VldMail(cEmailRPlan)
	MsgStop("E-Mail do responsavel pela planilha inv�lido " + ALLTRIM(cEmailRPlan),"Aten��o")
Else
	SendMail(cEmailRPlan,aUOFim)
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldMail   �Autor  �TOTVS               � Data �  23/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o E-mail do responsavel pela planilha				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldMail(cEMail)
Local nI
Local cChar      := ""
Local lOK 		 := .F.
Local nQtdArrba  := 0
Local aPto       := {}
Local cConteudo  := AllTrim(LOWER(cEMail))
Local nP1Arrba   := At('@',cConteudo)

//������������������������������������������������������Ŀ
//�Carrega Vetor com caracteres especiais nao permitidos �
//��������������������������������������������������������
Local aNoChar    := {",","\","/","*","+","=","(",")","[","]",;
"{","}",";",":","?","!","&","%","#","$","%","�",;
"'",'"',"|","<",">","~","^"}

//������������������������������������������������������Ŀ
//�Carrega Vetor aChar com as LETRAS ALFABETO exigida 	 �
//��������������������������������������������������������
Local aChar    := {"a","b","c","d","e","f","g","h","i","j","k","l","m",;
"n","o","p","q","r","s","t","u","v","w","x","y","z",;
"0",'1',"2","3","4","5","6","7","8","9"}

//�����������������������������������Ŀ
//�Verifica se o campo esta em branco �
//�������������������������������������
If Empty(cConteudo)
	Return .F.
Endif

//��������������������������������������Ŀ
//�Valida se a String eh menor do que 7  �
//����������������������������������������
If Len(cConteudo) < 7
	Return .F.
Endif

//������������������������������������������������Ŀ
//�Verifica se possui caracter especial preenchido �
//��������������������������������������������������
For nI:=1 to Len(AllTrim(cConteudo))
	cChar := SubStr(cConteudo,nI,1)
	If aScan(aNoChar, cChar) > 0
		Return .F.
	Endif
Next nI

//���������������������������������������������Ŀ
//�Verifica a QTD de pontos e arrobas na string �
//�����������������������������������������������
For nI:=1 to Len(cConteudo)
	// Soma a QTD de Pontos
	If SubStr(cConteudo,nI,1) == '.'
		AADD(aPto, nI)
		Loop
	Endif
	
	// Valida a QTD de @
	If SubStr(cConteudo,nI,1) == '@'
		If nQtdArrba == 0
			nQtdArrba++
			Loop
		Else
			Return .F.
		Endif
	Endif
Next nI

//��������������������������������������Ŀ
//�Valida a posicao do ARROBA na STRING  �
//����������������������������������������
For nI:=1 to Len(SubStr(cConteudo,1,nP1Arrba))
	cChar := SubStr(cConteudo,nI,1)
	If aScan(aChar, cChar) > 0
		lOK := .T.
		Exit
	Endif
Next nI
If !lOK
	Return .F.
Endif

//��������������������������������������Ŀ
//�Valida a posicao dos pontos na STRING �
//����������������������������������������
For nI:=1 to Len(aPto)
	If aPto[nI] <= 1
		Loop
	Endif
	
	cChar := SubStr(cConteudo,aPto[nI]-1,1)
	If aScan(aChar, cChar) == 0
		lOK := .F.
		Exit
	Endif
Next nI
If SubStr(cConteudo,Len(cConteudo),1) == '.'
	lOk := .F.
Endif

If !lOK
	Return .F.
Endif

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Sendmail  �Autor  �TOTVS               � Data �  23/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia o e-mail para o responsavel pela planilha			  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Sendmail(cEmail,aUOFim)

Local cMensagem		:= ""
Local lOk			:= .F.
Local lSendOk		:= .T.
Local cError		:= ""
Local cPassword 	:= AllTrim(GetNewPar("MV_RELPSW"," "))
Local lAutentica	:= GetMv("MV_RELAUTH",,.F.)         //Determina se o Servidor de Email necessita de Autentica��o
Local cAccount  	:= AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Local cUserAut  	:= Alltrim(GetNewPar("MV_RELAUSR",cAccount))//Usuario para Autentica��o no Servidor de Email
Local cPassAut  	:= Alltrim(GetNewPar("MV_RELAPSW",cPassword))//Senha para Autentica��o no Servidor de Email
Local cServer   	:= AllTrim(GetNewPar("MV_RELSERV",""))
Local nTimeOut  	:= GetNewPar("MV_RELTIME",120)
Local cMailConta	:= ""
Local cSubject  	:= ""
Local cMailTo 		:= ""

//�����������������������������������������������������������
//�Gera HTML com todos os itens da planilha foram finalizado�
//�����������������������������������������������������������
cMensagem:= Geramail(aUOFim)

//��������������
//�Envia Email �
//��������������
If !Empty(cServer) .And. !Empty(cAccount) .And. (!Empty(cPassword) .OR. !Empty(cPassAut))
	
	// Conecta uma vez com o servidor de e-mails
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk
	
	If !lOK
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgStop("N�o foi poss�vel efetuar a conex�o com o servidor de e-mail !" + cError,"Aten��o")
	Else		//Envio de e-mail HTML
		cSubject	:="CC Finalizada: "+AllTrim(AK1->AK1_CODIGO) +'/'+ AK1->AK1_VERSAO
		cMailConta	:= UsrRetMail(__CUSERID)
		
		If lAutentica
			If !MailAuth(cAccount,cPassword)
				GET MAIL ERROR cError
				MsgStop("Erro de autentica��o no servidor SMTP:" + cError,"Aten��o")
			Endif
		Endif
		
		SEND MAIL FROM cMailConta to cEMail SUBJECT cSubject BODY cMensagem RESULT lSendOk
		
		If !lSendOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgStop("Erro ao enviar e-mail para Respons�avel da Planilha!" + cError,"Aten��o")
		EndIf
	EndIf
EndIf

// Desconecta com o servidor de e-mails
If lOk
	DISCONNECT SMTP SERVER
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Geramail  �Autor  �TOTVS               � Data �  23/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o e-mail para o responsavel pela planilha avisando	  ���
���          � finalizacao da digitacao de um C.Custo (CC)                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP(GAP   )                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Geramail(aUOFim)

Local nI
Local cMsg      := ""

// Texto
cMsg := "<HTML><TABLE BORDER=0>"+CRLF
cMsg += "<TR><TD>A(s) CC(s) abaixo finalizou(aram) seu or�amento "
cMsg += "<TR><TD>&nbsp</TD></TR>" + CRLF
cMsg += "</TABLE>"+CRLF

//Cabecalho
cMsg += '<table id="" style="border-collapse: collapse" cellSpacing="1" borderColorDark="#000000" width="450" borderColorLight="#000000" border="1">'
cMsg += '    <tr><th colspan="8"><font face="Verdana" size="2"><b>Planilha: ' + AK1->AK1_CODIGO + ' - Revis�o: ' + AK1->AK1_VERSAO + ' </b></font></th></tr>'
cMsg += '      <td bgcolor="#99ccff" align="Left" ><font face="Verdana" size="1"><b>CC</b></font></td>'
cMsg += '      <td bgcolor="#99ccff" align="Left" ><font face="Verdana" size="1"><b>Descri��o</b></font></td>'

//Adiciona Itens na tabela
For nI := 1 to Len(aUOFim)
	cMsg += '<tr>'
	cMsg += '<td align=left><font face="Arial" size="2">' + aUOFim[nI,01] + '</td>'
	cMsg += '<td align=left><font face="Arial" size="2">' + aUOFim[nI,02] + '</td>'
	cMsg += '</tr>'
Next nI

cMsg += "</TABLE/HTML>"

Return(cMsg)
