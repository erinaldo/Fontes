#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FCOPART  � Autor � Isamu K.           � Data � 26/03/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Importacao da Co-Participacao da Assistencia Medica.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fCopart

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "IMPORTA��O DA CO-PARTICIPA��O "
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao
Private cPerg      := "FCOPART"


fPerg()
Pergunte(cPerg,.F.)

cDescricao := "Este programa ir� importar de um arquivo texto contendo os  " + Chr(13) + Chr(10)
cDescricao += "valores da co-participa��o de assist�ncia m�dica.           " + Chr(13) + Chr(10)
cDescricao += "Preencha o Par�metro. Ap�s confirmar a opera��o, ser� aberta" + Chr(13) + Chr(10)
cDescricao += "um tela para escolher o local e o arquivo a ser importado."

tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. )

Return

/*/
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  15/08/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fProcessa( oSelf )

Local cPath    := ""
Local cArquivo := ""
Local nTamFile := 0
Local nTamLin  := 0
Local cBuffer  := ""
Local nBtLidos := 0
Local lImport  := .F.
Local dDtMov   := Ctod( "" )
Local cTitulo1  := "Selecione o arquivo"
Local cExtens	:= "Arquivo CSV | *.csv"
Local cFileOpen := ""
Local nContad   := 0  
Local nConta2   := 0
Local cSeqTxt   := ""
Local aLogTitle  := {}
Local aLogDetail := {}      
Local aStru := {}
Local nVTitGrv  := 0
Local nVDepGrv  := 0 

Private nPosImpOk  := 1
Private nPosImpNo  := 2
Private nPosImpDem := 3
Private nPosImpAfa := 4
Private nPosImpSub := 5
Private nPosImpFil := 6
Private nExc       := 0 

//Criar arquivo temporario
AADD(aStru,{"FILIAL"         ,"C", 002,0})
AADD(aSTru,{"MATRICULA"      ,"C", 006,0})
AADD(aStru,{"TITDEP"         ,"C", 001,0})
AADD(aStru,{"SEQDEP"         ,"C", 002,0})
AADD(aStru,{"ORIGEM"         ,"C", 001,0})
AADD(aStru,{"FORNEC"         ,"C", 002,0})
AADD(aStru,{"VERBA"          ,"C", 003,0})
AADD(aStru,{"VALOR"          ,"N", 009,2})
AADD(aStru,{"OBSERVA"        ,"C", 120,0})
                      
If ( Select ("EXC") <> 0 )
	dbSelectArea ("EXC")
	dbCloseArea ()
End

cArqEXC := CriaTrab(aStru,.t.)
dbUseArea(.T.,,cArqEXC,"EXC",.T.)


Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - REGISTROS IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - REGISTROS NAO IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - FUNCION�RIOS DEMITIDOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - FUNCION�RIOS AFASTADOS" )
Aadd(aLogDetail,{})

//INDEXANDO RHO POR FILIAL,MAT,COMPET, ORIGEM
cIndCond:= "RHO->RHO_FILIAL + RHO->RHO_MAT + RHO->RHO_COMPPG + RHO->RHO_ORIGEM + RHO->RHO_CODIGO"
cArqNtx  := CriaTrab(Nil,.F.)
IndRegua("RHO",cArqNtx,cIndCond,,,"Selecionando Registros...")  //"Selecionando Registros..."
//RHO->(dbSetOrder( 2 ))		// RHO_FILIAL+RHO_MAT+DTOS(RHO_COMPPG)
SRA->(dbSetOrder( 1 ))

cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" n�o localizado",cCadastro)
	Return(.F.)
EndIf


nRegs := fContaReg(cFileOpen)

oSelf:SetRegua1(nRegs)//( nTamFile/(nTamLin) )

FT_FUSE(cFileOpen)   //ABRIR
FT_FGOTOP()          //PONTO NO TOPO

While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	
	nContad++
	
	oSelf:IncRegua1( "Processando Registros -> " + StrZero(nContad,8) + " de " + StrZero(nRegs,8) )
	
	// Capturar dados
	cBuffer := FT_FREADLN() //LENDO LINHA
	
	nPos1 := at(";",cBuffer)              //filial
	nPos2 := at(";",subs(cBuffer,nPos1+1)) + nPos1 //matricula
	nPos3 := at(";",subs(cBuffer,nPos2+1)) + nPos2 //fornecedor
	nPos4 := at(";",subs(cBuffer,nPos3+1)) + nPos3 //verba
	nPos5 := at(";",subs(cBuffer,nPOs4+1)) + nPos4 //valor
	nPos6 := at(";",subs(cBuffer,nPos5+1)) + nPos5 //titular/dependente
	nPos7 := at(";",subs(cBuffer,nPos6+1)) + nPos6 //nome
	//nPos8 := at(";",subs(cBuffer,nPos7+1)) + nPos7 //tipo da consulta
	//nPos9 := at(";",subs(cBuffer,nPos8+1)) + nPos8 //observacoes
	//nPos10:= at(";",subs(cBuffer,nPos9+1)) + nPos9 //nome da clinica
	
	cFilTxt   := StrZero(Val(subs(cBuffer,01,nPos1-1)),2)
	cMatTxt   := StrZero(Val(subs(cBuffer,nPos1+1,nPos2-nPos1-1)),6)
	cFornTxt  := StrZero(Val(subs(cBuffer,nPos2+1,nPos3-nPos2-1)),2)
	cPdTxt    := subs(cBuffer,nPos3+1,nPos4-nPos3-1)
	cValTxt   := subs(cBuffer,nPos4+1,nPos5-nPos4-1)
	cTitDepTxt:= subs(cBuffer,nPos5+1,nPos6-nPos5-1)
	cNomeTxt  := Alltrim(subs(cBuffer,nPos6+1))
	//cTipoCon  := Alltrim(subs(cBuffer,nPos7+1,nPos8-nPos7-1))
	//cObsTxt   := Alltrim(subs(cBuffer,nPos8+1,nPos9-nPos8-1))
	//cNomeClin := Alltrim(subs(cBuffer,nPos9+1,nPos10-nPos9-1))            
	
	//cObsTxt   := If(Len(cObsTxt) > 2,Padr(cObsTxt+"/"+cNomeClin,120),Padr(cNomeClin,120))
	//se for dependente, preciso da sequencia dele
	If Subs(Alltrim(cTitDepTxt),1,1) == "D"
		cSeqTxt := fBuscaSeq(cFilTxt,cMatTxt,cNomeTxt)
		cOrigTxt:= "2"
	Else
		cSeqTxt  := ""
		cOrigTxt := "1"
	Endif
	
	// Posiciona o Funcionario
	If !(SRA->(dbSeek( cFilTxt + cMatTxt )))
		fGeraLog( @aLogDetail, nPosImpNo, cFilTxt, cMatTxt, "Registro N�o Encontrado no Cadastro de Funcion�rios ! Valor: " + Transform(Val(StrTran(cValTxt,",",".")),'@E 999,999.99'))
		FT_FSKIP()
		LOOP
	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Aqui carrego array para depois indexa pelo numero da carteirinha    �
	//�����������������������������������������������������������������������
	fCarTmp(cFilTxt,cMatTxt,cFornTxt,cPdTxt,Val(StrTran(cValTxt,",",".")),cTitDepTxt,cSeqTxt,cOrigTxt)
	
	// Log para Funcionario Demitido
	If SRA->RA_SITFOLH == "D"
		fGeraLog( @aLogDetail, nPosImpDem, cFilTxt, cMatTxt, SRA->RA_NOME + " - Registro Importado para Funcion�rio Demitido. Valor: " + Transform(Val(StrTran(cValTxt,",",".")),'@E 999,999.99')+" - "+If(Subs(Alltrim(cTitDepTxt),1,1)=="T","TITULAR","DEPENDENTE")   )
		FT_FSKIP()
		LOOP
	EndIf
	// Log para Funcionario Afastado
	If SRA->RA_SITFOLH == "A"
		fGeraLog( @aLogDetail, nPosImpAfa, cFilTxt,cMatTxt, SRA->RA_NOME + " - Registro Importado para Funcion�rio Afastado. Valor: " + Transform(Val(StrTran(cValTxt,",",".")),'@E 999,999.99')+" - "+If(Subs(Alltrim(cTitDepTxt),1,1)=="T","TITULAR","DEPENDENTE")   )
	Else
		fGeraLog( @aLogDetail, nPosImpOk, cFilTxt, cMatTxt, SRA->RA_NOME + " - Registro Importado com Sucesso. Valor: " +  Transform(Val(StrTran(cValTxt,",",".")),'@E 999,999.99')+" - "+If(Subs(Alltrim(cTitDepTxt),1,1)=="T","TITULAR","DEPENDENTE")   )
	EndIf
	
	FT_FSKIP()   //proximo registro no arquivo txt
	
EndDo

FT_FUSE() //fecha o arquivo txt

dbSelectArea("EXC")
//INDEXANDO TEMP POR FILIAL,MAT,TITDEP, SEQ
cIndCond:= "EXC->FILIAL+EXC->MATRICULA+EXC->TITDEP+EXC->SEQDEP"
cArqNtx  := CriaTrab(Nil,.F.)
IndRegua("EXC",cArqNtx,cIndCond,,,"Selecionando Registros...")  //"Selecionando Registros..."
dbGoTop()

nReg2 := nExc

oSelf:SetRegua2(nReg2)//( nTamFile/(nTamLin) )

While Exc->(!Eof())
	
	nConta2++
	
	oSelf:IncRegua2( "Gravando Registros -> " + StrZero(nConta2,8)  )

	cChaveAtu := EXC->(FILIAL+MATRICULA+TITDEP+SEQDEP)
	
	While cChaveAtu == EXC->(FILIAL+MATRICULA+TITDEP+SEQDEP)
		
		cFilGrv   := EXC->FILIAL
		cMatGrv   := EXC->MATRICULA
		cFornGRv  := EXC->FORNEC
		cVerbaGrv := EXC->VERBA
		
		If Subs(EXC->TITDEP,1,1) == "T"
			nVTitGrv += EXC->VALOR
		Else
			nVDepGrv += EXC->VALOR
			cSeqGrv  := EXC->SEQDEP
		Endif
		
		EXC->(dbSkip())
		
	EndDo
	
	If nVTitGrv > 0
		fGRavaRHO(cFilGrv,cMatGrv,cFornGrv,"1","  ",cVerbaGrv,nVTitGrv)
	Endif
	
	If nVDepGrv > 0
		fGRavaRHO(cFilGrv,cMatGrv,cFornGrv,"2",cSeqGrv,cVerbaGrv,nVDepGrv)
	Endif
	
	cFilGrv   := ""
	cMatGrv   := ""
	cSeqGrv   := ""
	nVTitGrv  := nVDepGrv := 0
	
	dbSelectArea("EXC")
	
EndDo

//���������������������������������������������������������������������Ŀ
//� Mostra os Logs gerados                                              �
//�����������������������������������������������������������������������
fMakeLog( aLogDetail, aLogTitle, NIL, NIL, FunName(), NIL, NIL, NIL, NIL, .F. )


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fgeralog  �Autor  �Microsiga           � Data �  06/26/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraLog( aLogDetail, nPos, c_Filial, c_Matric, cOcorrencia )

Aadd(aLogDetail[nPos],c_Filial + " - " + c_Matric + " - " + cOcorrencia )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCriaPerg �Autor  �Microsiga           � Data �  11/21/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Perguntas do Sistema.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fPerg()

Local aRegs := {}

aAdd(aRegs,{cPerg,'01','Competencia (MMAAAA) ?       ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})

ValidPerg(aRegs,cPerg)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FDEPAFIL  �Autor  �Microsiga           � Data �  08/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fContaReg(cFileX)

Local nNumX  := 0
Local nCount := 0

FT_FUSE(cFileX)   //ABRIR
FT_FGOTOP()       //PONTO NO TOPO


While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	IncProc("Aguarde, efetuando contagem dos registros ......")
	nCount++
	
	FT_FSKIP()   //proximo registro no arquivo txt
	
EndDo

nNumX := nCount

Return(nNumX)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FDEPAFIL  �Autor  �Microsiga           � Data �  08/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fBuscaSeq(cFilx,cMatx,cNomex)


Local cQr
Local cSeqx := ""
cNomex := Alltrim(Subs(cNomex,1,at(" ",cNomex)))

cQr := " SELECT RB_COD AS SEQDEP "
cQr += " FROM "+RetSqlName("SRB")+ " "
cQr += " WHERE RB_FILIAL = '"+cFilx+"' AND "
cQr += " RB_MAT = '"+cMatx+"' AND "
cQr += " RB_NOME LIKE '"+cNomex+"%' "
cQr += " AND "+RETSQLNAME("SRB")+".D_E_L_E_T_ <> '*' "

//�������������������������������Ŀ
//�Fecha alias caso esteja aberto �
//���������������������������������
If Select("TMB") > 0
	DBSelectArea("TMB")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"TMB",.F.,.T.)

If TMB->(Eof())
	cSeqx := "01"
Else
	cSeqx := TMB->SEQDEP
Endif



Return(cSeqx)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fGravaRHO� Autor � Isamu K.           � Data �  07/01/2012 ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function	fCarTmp(cFil_,cMat_,cForn_,cPd_,nVal_,cTitDep_,cSeq_,cOrig_)


Local aAreaExc := GetArea()

dbSelectArea("EXC")

RecLock("EXC",.T.)
EXC->FILIAL    := cFil_
EXC->MATRICULA := cMat_
EXC->TITDEP    := cTitDep_
EXC->SEQDEP    := cSeq_
EXC->ORIGEM    := cOrig_
EXC->FORNEC    := cForn_
EXC->VERBA     := cPd_
EXC->VALOR     := nVal_ 
EXC->OBSERVA   := ""
MsUnlock()

nExc++

RestArea(aAreaExc)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fGravaRHO� Autor � Isamu K.           � Data �  07/01/2012 ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fGRavaRHO(cFilx,cMatx,cFornecx,cOrigx,cSeqx,cVerbax,nValx)

Local aOldAtu := GETAREA()

//���������������������������������������������������������������������Ŀ
//� Gravo o lancamento                                                  �
//�����������������������������������������������������������������������
dbSelectArea( "RHO" )
If !dbSeek( cFilx + cMatx + (Subs(mv_par01,3,4)+Subs(mv_par01,1,2)) + cOrigx + cSeqx)
	RecLock("RHO",.T.)
	RHO->RHO_FILIAL := cFilx
	RHO->RHO_MAT    := cMatx
	RHO->RHO_DTOCOR := dDataBase
	RHO->RHO_ORIGEM := cOrigx
	RHO->RHO_TPFORN := "1"
	RHO->RHO_CODFOR := cFornecx
	RHO->RHO_CODIGO := cSeqx
	RHO->RHO_TPLAN  := "1"
	RHO->RHO_PD     := cVerbax
	RHO->RHO_COMPPG := Subs(mv_par01,3,4)+Subs(mv_par01,1,2)
	RHO->RHO_OBSERV := Padr("SOMA DAS CO-PARTICIPACOES REF. MES "+Subs(mv_par01,1,2)+"/"+Subs(mv_par01,3,4),120)
Else
	RecLock("RHO",.F.)
EndIf
RHO->RHO_VLRFUN := nValx
RHO->RHO_VLREMP := 0
MsUnLock()

RestArea(aOldAtu)


Return
