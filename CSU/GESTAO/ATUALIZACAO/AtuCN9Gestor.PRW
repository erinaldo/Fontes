#Include "rwmake.ch"  

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Program   � AtuCN9Gest � Autor � Jose Maria             � Data � 16/01/2012 ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Preencher o campo CN9_X_NGES  como nome completo do usuario     ���
���          � gestor, dos registro que estao com esse conteudo em branco      ���
������������������������������������������������������������������������������Ĵ��
���Retorno   �                                                                 ���
������������������������������������������������������������������������������Ĵ��
���Parametros�                                                                 ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe   � U_AtuCN9Gest()                                                  ���
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

User function AtuCN9Gest()                         
Local _aArea     := GetArea()    
                                       
Processa({||AtuCadCN9()},"Atualizacao Nome Completo do usuario Gestor CN9_X_NGES")
                  
RestArea( _aArea )

Return

Static Function AtuCadCN9()

dBSelectArea("CN9")   
ProcRegua( RecCount() )
dBGoTop()

While !Eof()

    IncProc("Atualizando o registro "+CN9->CN9_NUMERO) 
    
    _cRet := GETADVFVAL("ZUS","ZUS_NCOMPL",xFilial("ZUS")+CN9->CN9_X_GECN,2)
    
    RecLock("CN9",.F.)
    CN9->CN9_X_NGES := If( !Empty(_cRet) , _cRet , CN9->CN9_X_NGES )
    MsUnLock()                     

    dBSkip()
    
Enddo

Return
