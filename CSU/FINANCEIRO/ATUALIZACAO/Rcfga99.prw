#Include 'Rwmake.ch'
#Include 'Topconn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Rcfga99  �Autor  � Sergio Oliveira    � Data �  Set/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gerar arquivos TXT's conforme a configuracao escolhida.    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Rcfga99( aParam )

Local cPerg       := PADR('rcfga9',LEN(SX1->X1_GRUPO))
Local aRegs       := {}

If Valtype( aParam ) == 'A'
    lViaWorkflow := .t.
	WfPrepEnv( aParam[1], aParam[2] )
Else
    lViaWorkflow := .f.  	
EndIf

aAdd(aRegs,{cPerg,"01","Codigo da Configur.?","","","mv_chd","C",06,0,0,"G","ExistCpo('ZAY')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

If !Pergunte( cPerg, !lViaWorkflow )
	Return
EndIf

If Valtype( aParam ) == 'A'
	MV_PAR01 := aParam[3]
EndIf
	
// Controle de Semaforo por empresa:
nHdl := FCreate("\workflow\Rcfga99"+cEmpAnt+MV_PAR01+".txt",4)
If nHdl < 0
	// Esta rotina ja esta sendo executada para esta empresa por outra conexao do Protheus
	cDetalhe := "J� est� sendo executada [ "+AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_DESCRI'))+" ] em "+Trim(SM0->M0_NOME)+" / "+Trim(SM0->M0_FILIAL)
	If !lViaWorkflow
		Aviso("Controle de Semaforo",cDetalhe,;
						{"&Fechar"},3,"Semaforo",,;
						"PCOLOCK") 	
	Else
		cAssunto := "Controle de Semaforo"
		cTitulo  := "Execucao da exporta��o => " +AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_PATH'))
		U_Rcomw06( cAssunto, cTitulo, cDetalhe, GetMV("MV_WFADMIN") )
	EndIf
	Return
EndIf

If !lViaWorkflow

	If Aviso("ARQUIVO TXT","Deseja gerar este TXT ["+AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_DESCRI'))+"] ?",;
						{"&Prosseguir", "&Fechar"},3,"Gera��o de Arquivo TXT",,;
						"PCOLOCK") == 1
		Processa( { || Rcfga99a() },'Gerando Txt...' )
	EndIf

Else
    
    MV_PAR01 := aParam[3]
    
    Rcfga99a()

	cAssunto := "Exportacao "+AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_DESCRI'))
	cTitulo  := "Execucao da exporta��o => " +AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_PATH'))
	cDetalhe := "Esta exporta��o acabou de ser executada. Verifique o arquivo "+AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_PATH'))
	U_Rcomw06( cAssunto, cTitulo, cDetalhe, GetMV("MV_WFADMIN") )

EndIf

Fclose( nHdl )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Rcfga99a �Autor  � Sergio Oliveira    � Data �  Jun/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento da rotina.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Rcfga99.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Rcfga99a()

Private cEol     := Chr(13)+Chr(10)
Private nHdlPre, cArquivo
Private nCntView 

If !lViaWorkflow

	ProcRegua(1)
	cArquivo := cGetFile("", "Informe o Diretorio e o nome do Arquivo em TXT",,,,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)
	IncProc('Gerando informacoes...')
	
	If Empty( cArquivo )
		MsgBox('Informe o caminho e nome do arquivo.','Erro','Alert')
		Return
	EndIf

Else

    cArquivo := Lower( AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_PATH')) )

EndIf

nHdlPre := FCreate(cArquivo,0)
    
If nHdlPre < 0
    If !lViaWorkflow
		MsgBox('N�o est� sendo poss�vel criar o arquivo '+cArquivo,'Erro','Alert')
	Else
		cAssunto := AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_DESCRI'))+" - Erro na Criacao do Arquivo"
		cTitulo  := "Nao esta sendo possivel criar o arquivo "+cArquivo+"."
		cDetalhe := "Execucao da exporta��o => " +AllTrim(Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_PATH'))		
		U_Rcomw06( cAssunto, cTitulo, cDetalhe, GetMV("MV_WFADMIN") )
	EndIf
	Fclose( nHdlPre )
	Return
EndIf

cNextAlias := Rcfga99b() // Monta a Query do TXT conforme o campo memo

Rcfga99c( cNextAlias ) // Monta o arquivo TXT de acordo com as coordenadas da configuracao do parametro

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Rcfga99c �Autor  � Sergio Oliveira    � Data �  Jun/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a montagem e execucao da query do TXT.              ���
�������������������������������������������������������������������������͹��
���Uso       � Rcfga99.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Rcfga99b()

Local cSelect    := " ", cSelect2 := " "
Local cNextAlias := GetNextAlias()
Local aStruNext  := {}
Local cSubs1     := Chr(13), cSubs2 := Chr(10)

cSelect += Posicione('ZAY',1,xFilial('ZAY')+MV_PAR01,'ZAY_FILTRO')

// Tratamento especial para eliminar os Chr(13) e ou Chr(10):

If Empty( cSelect ) .And. !lViaWorkflow

	Aviso("FILTRO SQL","N�o existe filtro definido para esta configura��o.",;
					{"&Fechar"},3,"Filtro Invalido",,;
					"PCOLOCK")   
					
    Return    

EndIf
/*
cSelect := StrTran( cSelect, cSubs1, "" )
cSelect := StrTran( cSelect, cSubs2, "" )
cSelect := StrTran( cSelect, cSubs1+cSubs2, "" )
*/
					
cSelect := cSelect

nCntView := U_MontaView(cSelect, cNextAlias)

aStruNext := ( cNextAlias )->( DbStruct() )

SX3->( DbSetOrder(2) )

For _xp := 1 To Len( aStruNext )

    If SX3->( DbSeek( aStruNext[_xp][1] ) )
	
		If SX3->X3_TIPO $ 'N/D' .And. SX3->X3_CONTEXT # 'V' // Campos numericos + data devem ser ajustados
			TcSetField(cNextAlias,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
		EndIf
	
	EndIf
	
Next


Return( cNextAlias )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Rcfga99c �Autor  � Sergio Oliveira    � Data �  Jun/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava o arquivo TXT.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Rcfga99.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Rcfga99c(pcNextAlias)

Local _nFator, _cConteudo
Local _cGrava  := ''
Local _lPriDlm := .t., _lJaLabel := .f., _lPriLbl := .t.

( pcNextAlias )->( DbGoTop() )

If !lViaWorkflow
	ProcRegua( nCntView )
EndIf

While !( pcNextAlias )->( Eof() )
	
	ZAZ->( DbSeek(xFilial('ZAZ')+MV_PAR01) )
	
	While !ZAZ->( Eof() ) .And. ZAZ->(ZAZ_FILIAL+ZAZ_CODIGO) == xFilial('ZAZ')+MV_PAR01
	
		// Tratamento para enviar o Label ou n�o:
		
		If ZAY->ZAY_LABEL $ 'S' .And. !_lJaLabel
		
		   _nRegZAZ := ZAZ->( Recno() )
		   
		   While !ZAZ->( Eof() ) .And. ZAZ->(ZAZ_FILIAL+ZAZ_CODIGO) == xFilial('ZAZ')+MV_PAR01
		                        
				If _lPriLbl
				
					_cGrava  := Left(AllTrim(ZAZ->ZAZ_ALIAS),1)+AllTrim(ZAZ->ZAZ_DESCPOS)
			
					_lPriLbl := .f.
		
				Else
		       
				    ZAZ->( DbSkip() )
		    
				    If ZAZ->( Eof() ) .Or. ZAZ->(ZAZ_FILIAL+ZAZ_CODIGO) # xFilial('ZAZ')+MV_PAR01
		    
					    ZAZ->( DbSkip(-1) )

						_cGrava  := AllTrim(ZAZ->ZAZ_ALIAS)+AllTrim(ZAZ->ZAZ_DESCPOS)+Left(AllTrim(ZAZ->ZAZ_ALIAS),1)
				
				    Else
		    
					    ZAZ->( DbSkip(-1) )
		
				        _cGrava  := AllTrim(ZAZ->ZAZ_ALIAS)+AllTrim(ZAZ->ZAZ_DESCPOS)
			
					EndIf
		
				EndIf

				FWrite( nHdlPre, _cGrava )
		   
		        ZAZ->( DbSkip() )
		   
		   EndDo
		   
		   FWrite( nHdlPre, cEol )
		   
		   ZAZ->( DbGoTo( _nRegZAZ ) )
		
		   _lJaLabel := .t.
	   	   _cGrava   := ''
		   
		EndIf
		
		DbSelectarea( pcNextAlias )
		
        _cMetodo   := ZAZ->ZAZ_METODO		
		_nFator    := ZAZ->ZAZ_POSFIM - ZAZ->ZAZ_POSINI + 1
		_cConteudo := SubStr( &( _cMetodo ) ,1 ,_nFator)
		
		// Tratamento para o Delimitador:
		
		If _lPriDlm
		
			_cGrava  += Left(AllTrim(ZAZ->ZAZ_ALIAS),1)+_cConteudo
			
			_lPriDlm := .f.
		
		Else
		       
		    ZAZ->( DbSkip() )
		    
		    If ZAZ->( Eof() ) .Or. ZAZ->(ZAZ_FILIAL+ZAZ_CODIGO) # xFilial('ZAZ')+MV_PAR01
		    
			    ZAZ->( DbSkip(-1) )

				_cGrava  += AllTrim(ZAZ->ZAZ_ALIAS)+_cConteudo+Left(AllTrim(ZAZ->ZAZ_ALIAS),1)
				
		    Else
		    
			    ZAZ->( DbSkip(-1) )
			    
		        _cGrava  += AllTrim(ZAZ->ZAZ_ALIAS)+_cConteudo
			
			EndIf
		
		EndIf
			    
		ZAZ->( DbSkip() )
		
	EndDo
	      
	FWrite( nHdlPre, _cGrava+cEol )
	
	_cGrava  := ''
	_lPriDlm := .t.
		
	If !lViaWorkflow
		IncProc('Gerando movimentos....')
	EndIf
	
	( pcNextAlias )->( DbSkip() )
	
EndDo

If !lViaWorkflow
	MsgBox('Verificar o arquivo '+cArquivo,'Termino do processo.','Info')
EndIf

Fclose( nHdlPre )

( pcNextAlias )->( DbCloseArea() )

Return