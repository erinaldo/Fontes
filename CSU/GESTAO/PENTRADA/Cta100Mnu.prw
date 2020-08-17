#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTA100MNU �Autor  � Sergio Oliveira    � Data �  Jul/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na rotina de manutencao de contratos. Esta���
���          � sendo utilizado para incluir o botao de troca do usuario   ���
���          � do contrato.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Cta100Mnu()

aAdd(aRotina, { "Troca Solicitante","U_TrokUser()"	, 0 , 2,0,Nil})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � TrokUser �Autor  � Sergio Oliveira    � Data �  Jul/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina que processa a troca do usuario do contrato.        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TrokUser()

Local cNomSol := Space(40)
Local cIdSol  := Space(06)
Local cUsrSol := CN9->CN9_X_SOLI
Local cIdnVSol:= Space(06)
Local cNvSol  := CriaVar("CN9_X_SOLI")
Local cTrkNom := Space(40)
Local oMens3
Local oFont   := TFont():New("Tahoma",11,,,.T.,,,,,.F.) // Com Negrito

ValTrkUsr(@cUsrSol, @cNomSol, @cIdSol)

Define MsDialog oDldTrk Title "" From 208,231 To 440,877 Of oMainWnd Pixel

@ 000,002 To 116,315
@ 000,258 To 116,315
@ 029,002 To 116,259

@ 010,021 Say "Troca do Solicitante do Contrato" Color 8388608 Object oMens3 Size 216,15

@ 037,020 To 069,242 Title "Solicitante Original"
@ 050,025 Get cIdSol  Size 039,10 When .f.
@ 050,069 Get cUsrSol Size 039,10 When .f.
@ 050,112 Get cNomSol Size 114,10 When .f.

@ 072,020 To 104,242 Title "Novo Solicitante"
@ 086,025 Get cIdnVSol  F3 "US1" Size 039,10 Valid( ValTrkUsr(@cNvSol, @cTrkNom, @cIdnVSol) )
@ 086,069 Get cNvSol             Size 039,10 When .f.
@ 086,112 Get cTrkNom            Size 114,10 When .f.

@ 043,265 Button "_Confirmar" Size 44,16 Action( ( ConfTrk(cNvSol, cUsrSol), oDldTrk:End() ) )

oMens3:ofont:=ofont

Activate MsDialog oDldTrk Centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � TrokUser �Autor  � Sergio Oliveira    � Data �  Jul/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina que processa a troca do usuario do contrato.        ���
�������������������������������������������������������������������������͹��
���Uso       � CTA100Mnu.prw                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValTrkUsr(cSolict, cNmSolict, cId)

Local cTxtBlq
/*
�������������������������������������������������������������������������������������������������������������������������Ŀ
� Na CSU existe o procedimento de inlusao de um asterisco ao final do nome do usuario para identificar visualmente quando �
� um determinado usuario esta bloqueado. Se a primeira tentativa de localizacao nao tiver sucesso, testar utilizando o    �
� asterisco no final do UserName.                                                                                         �
���������������������������������������������������������������������������������������������������������������������������*/
PswOrder(2) // Ordem de nome do usuario
If !PswSeek( cSolict )
	/*
	�������������������������������������������������������������������������������������������������������������������������Ŀ
	� Na CSU existe o procedimento de inlusao de um asterisco ao final do nome do usuario para identificar visualmente quando �
	� um determinado usuario esta bloqueado. Devera estar previsto tambem este tipo de ocorrencia:                            �
	���������������������������������������������������������������������������������������������������������������������������*/
	If !PswSeek( AllTrim(cSolict)+"*" )
		
		cTxtBlq := "O usu�rio do contrato n�o est� mais cadastrado no sistema! "
		Aviso("SOLICITANTE DO CONTRATO",cTxtBlq,{"&Fechar"},3,"Solicitante Nao Encontrado",,"PCOLOCK")
		
	EndIf
	
	Return( .f. )
Else
    cId       := PswId()
    cSolict   := UsrRetName(cId)
	cNmSolict := UsrFullName( PswId() )
EndIf

Return( .t. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � ConfTrk  �Autor  � Sergio Oliveira    � Data �  Jul/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Processar a troca do solicitante.                          ���
�������������������������������������������������������������������������͹��
���Uso       � CTA100Mnu.prw                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ConfTrk(cSolict, cSolAnt)

Local cExec
Local cEol    := Chr(13)+Chr(10)
Local cMens   := "Troca do Solicitante Deste Contrato"
Local cPriLin := "Se deseja realmente efetuar esta opera��o, "
Local cTxtBlq := "Ocorreu um erro no momento da grava��o da troca do solicitante deste "
cTxtBlq += "contrato. Informe o erro abaixo para a �rea de Sistemas ERP:"+cEol+cEol

If cSolict == cSolAnt

	Aviso("SOLICITANTE IGUAIS","Os solicitantes de origem e destino n�o podem ser iguais!",;
	{"&Fechar"},3,"Grava��o do Solicitante no Contrato",,;
	"PCOLOCK")    
	
	Return

Else

	If !U_CodSegur(cMens, cPriLin)
		Aviso(cMens,"Opera��o nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		Return
	EndIf
   
EndIf

cExec := " UPDATE "+RetSqlName('CN9')+" SET CN9_X_SOLI = '"+cSolict+"' "
cExec += " WHERE R_E_C_N_O_ = "+Str( CN9->( Recno() ) )

If TcSqlExec(cExec) # 0

	cTxtBlq += TcSqlError()+cEol+cEol+"=========================================="+cEol+cEol

	Aviso("GRAVA��O DO SOLICITANTE",cTxtBlq,;
	{"&Fechar"},3,"Grava��o do Solicitante no Contrato",,;
	"PCOLOCK")    

Else

    MsgBox("Troca efetuada com sucesso!","Troca do Solicitante","Info")

EndIf

Return