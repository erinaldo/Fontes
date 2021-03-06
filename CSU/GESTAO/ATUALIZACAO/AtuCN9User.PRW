
#Include "rwmake.ch"  

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Program   � AtuCN9User � Autor � Jose Maria             � Data � 03/10/2011 ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Preencher o campo CN9_X_NSOL como nome completo do usuario      ���
���          � solicitante, dos registro que estao com esse conteudo em branco ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���Parametros�                                                                 ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe   � U_AtuCN9User()                                                  ���
������������������������������������������������������������������������������Ĵ��
���Aplicacao � Gestao de contratos - CSU                                       ���
������������������������������������������������������������������������������Ĵ��
���Uso       �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���Analista Resp.  �  Data  � Bops � Manutencao Efetuada                       ���
������������������������������������������������������������������������������Ĵ��
���                �  /  /  �      �                                           ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/

User function AtuCN9User()                         
Local _aArea     := GetArea()    
                                       
Processa({||AtuCadCN9()},"Atualizacao Nome Completo do usuario Solicitante CN9_X_NSOL")
                  
RestArea( _aArea )

Return

Static Function AtuCadCN9()

dBSelectArea("CN9")   
ProcRegua( RecCount() )
dBGoTop()

While !Eof()

    IncProc("Atualizando o registro "+CN9->CN9_NUMERO) 
    
    _cRet := GETADVFVAL("ZUS","ZUS_NCOMPL",xFilial("ZUS")+CN9->CN9_X_SOLI,2)
    
    RecLock("CN9",.F.)
    CN9->CN9_X_NSOL := If( !Empty(_cRet) , _cRet , CN9->CN9_X_NSOL )
    MsUnLock()                     

    dBSkip()
    
Enddo

Return
