#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RcomW06  �Autor  � Sergio Oliveira    � Data �  Out/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Emite as notificacoes e envia por e-mail.                  ���
�������������������������������������������������������������������������͹��
���          � U_RcomW06( <ExpC1>, <ExpC2>, <ExpC3>, <ExpC4>, <ExpC5> )   ���
��� Sintaxe  �                                                            ���
���          � 1. Linha do Assunto do E-mail;                             ���
���          � 2. Titulo da Notitifacao;                                  ���
���          � 3. Descricao Detalhada da Notificacao;                     ���
���          � 4. Usuario a Enviar a Notificacao ou e-Mail Direto;        ���
���          � 5. Path + Arquivo a Atachar.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RcomW06(pcAssunto, pcTitulo, pcDetalhe, pcUsuario, pcAtachar)
                  
Local nLineSize := 90, nTabSize  := 2
Local lWrap     := .f.
Local cTexto    := ""

oProcess          	:= TWFProcess():New( "000001", "Notificacao Avulsa" )
oProcess          	:NewTask( "Notificacao Avulsa", "\workflow\HTML\Notificacoes.htm" )
oProcess:cSubject 	:= pcAssunto
If '@' $ pcUsuario
	oProcess:cTo   	:= pcUsuario
Else
	oProcess:cTo    := UsrRetMail(pcUsuario)
EndIf
oProcess:UserSiga	:= '000000'  // Fixo Administrador
oProcess:NewVersion(.T.)
oHtml     			:= oProcess:oHTML
oHtml:ValByName( "REFERENTE", pcTitulo)
nLines := MlCount(pcDetalhe, nLineSize, nTabSize, lWrap)
For nCurrLine := 1 To nLines
	cTexto += "<p><font color='#0000FF'>"+MemoLine(pcDetalhe, nLineSize, nCurrLine, nTabSize, lWrap)+"</font></p>"
Next
oHtml:ValByName( "DESCRICAO", cTexto)
If pcAtachar # Nil    
	oProcess:AttachFile(Upper(pcAtachar))
EndIf        

_cID := oProcess:fProcessId

oProcess:Start()

Return(_cID)