#include "rwmake.ch"        

User Function FICADE02()        

SetPrvt("_CMODO,_NORDSX2,_NREGSX2,NOPCX,NUSADO,AHEADER")
SetPrvt("ACOLS,ARECNO,_CTABELA,_CCODFIL,_CCHAVE,_CDESCRI")
SetPrvt("NQ,_NITEM,NLINGETD,CTITULO,AC,AR")
SetPrvt("ACGD,CLINHAOK,CTUDOOK,LRETMOD2,N,_AEMPR")
SetPrvt("_CEMPRESA,_NREGSM0,_NA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FICADE02 � Autor � Ligia Sarnauskas     � Data � 12/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Edicao da tabela SX5 - Tabela ZZ -  ID Produto             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FIESP                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Verifica se SX5 e exclusivo ou compartilhado                 �
//����������������������������������������������������������������
_cModo := " "
DbSelectArea("SX2")
_nOrdSX2 := IndexOrd()
_nRegSX2 := Recno()
DbSetOrder(1)
DbSeek("SX5")
If found()
   _cModo := SX2->X2_MODO
Endif
DbSetOrder(_nOrdSX2)
DbGoTo(_nRegSX2)

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:= 3
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
nUsado:=0
aHeader:={}
aCols := {}
aRecNo := {}
_cTabela := "ZZ"

dbSelectArea("SM0")

//��������������������������������������������������������������Ŀ
//� Posiciona a filial corrente                                  �
//����������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SX5")
While !Eof() .And. (X3_ARQUIVO == "SX5")
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL 
		If AllTrim(X3_CAMPO) $ "X5_DESCRI*X5_CHAVE"
			nUsado:=nUsado+1
			AADD(aHeader,{ TRIM(x3_titulo), X3_CAMPO, "@!",;
				X3_TAMANHO, X3_DECIMAL,"!Empty(M->"+X3_CAMPO+")",X3_USADO, X3_TIPO, X3_ARQUIVO,X3_CONTEXTO})
		EndIf
   Endif
   dbSkip()
End

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
// aCols:=Array(1,nUsado+1)    

//��������������������������������������������������������������Ŀ
//� Posiciona o Cabecalho da Tabela a ser editada (_cTabela)     �
//����������������������������������������������������������������
dbSelectArea("SX5")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Cabecalho da tabela, filial � vazio                          �
//����������������������������������������������������������������
_cCodFil := xFilial()
If !dbSeek(_cCodFil+"00"+_cTabela)
	Help(" ",1,"NOSX5")
	Return
EndIf

_cChave := AllTrim(SX5->X5_CHAVE)
_cDescri := Substr(SX5->X5_DESCRI,1,35)

//��������������������������������������������������������������Ŀ
//� Posiciona os itens da tabela conforme a filial corrente      �
//����������������������������������������������������������������
dbSeek(_cCodFil+_cTabela)
	
aCols:={}
aRecNo:= {}

While !Eof() .And. SX5->X5_FILIAL == _cCodFil .And. SX5->X5_TABELA==_cTabela
	Aadd(aCols,Array(nUsado+1))
	Aadd(aRecNo,Array(nUsado+1))
	For nQ:=1 To nUsado
		aCols[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
		aRecNo[Len(aCols),nQ]:= FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aRecNo[Len(aCols),nUsado+1] := RecNo()
	aCols[Len(aCols),nUsado+1]  := .F.      
	dbSelectArea("SX5")
	dbSkip()
EndDo

_nItem := Len(aCols)

If Len(aCols)==0
	AADD(aCols,Array(nUsado+1))
	For nQ:=1 To nUsado
		 aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.       
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0
//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo := _cDescri
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}

#IFDEF WINDOWS
          AADD(aC,{"_cChave" ,{20,05} ,"Tabela ","@!"," ","",.f.})
          AADD(aC,{"_cDescri",{20,50} ," ","@!"," ","",.f.})
#ELSE
          AADD(aC,{"_cChave" ,{5,15} ,"Tabela ","@!"," ","",.f.})
          AADD(aC,{"_cDescri",{5,50} ," ","@!"," ","",.f.})
#ENDIF
//��������������������������������������������������������������Ŀ
//� Nao utiliza o rodape, apesar de passar para Modelo 2         �
//����������������������������������������������������������������
aR:={}

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
#IFDEF WINDOWS
	aCGD:={44,5,118,315}
#ELSE
	aCGD:={07,04,19,73}
#ENDIF
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3]) .And. ExecBlock('DGENA01',.F.,.F.)"
cTudoOk := "AllwaysTrue()"
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
N:=1
lRetMod2 := .F.
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

If lRetMod2
    If _cModo == "E"
       GravExc()
    ElseIf _cModo == "C"
       GravCom()
    Endif
EndIf

DbCommitAll()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GravCom   � Autora� Ligia Sarnauskas      � Data � 12.11.13 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

Static Function GravCom()
	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 To Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.  
			//����������������������������������������������������������Ŀ
            //� Filial e Chave e a chave independente da descricao       �
            //� que pode ter sido alterada                               �
			//������������������������������������������������������������
			If dbSeek(_cCodFil+_cTabela+aCols[n,1])
				RecLock("SX5",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
		  If dbSeek(xFilial()+_cTabela+aCols[n,1])
				If aCols[n,2] != SX5->X5_DESCRI
					RecLock("SX5",.F.)
					Replace X5_CHAVE  with aCols[n,1]
					Replace X5_DESCRI with aCols[n,2]
					MsUnlock()
				EndIf
          Else
				If _nItem >= n
					dbGoto(aRecNo[n,3]) 
					RecLock("SX5",.F.)
					Replace X5_CHAVE  with aCols[n,1]
					Replace X5_DESCRI with aCols[n,2]
					MsUnlock()
				ElseIf (!Empty(aCols[n,1]))
					RecLock("SX5",.T.)
                    Replace X5_FILIAL with _cCodFil
					Replace X5_TABELA with _cTabela 
					Replace X5_CHAVE  with aCols[n,1]
					Replace X5_DESCRI with aCols[n,2]
					MsUnlock()              
				EndIf                   
          EndIf
		EndIf
	Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GravExc   � Autora� Ligia Sarnauskas      � Data � 12.11.13 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

Static Function GravExc()

    //����������������������������������������������������������Ŀ
    //� Verifica as filiais que devem ser atualizadas no SX5     �
    //������������������������������������������������������������
    _aEmpr     := {}
    DbSelectArea("SM0")
    _cEmpresa:= SM0->M0_CODIGO
    _nRegSM0 := Recno()
    DbGoTop()
    While ! EOF()
        If _cEmpresa == SM0->M0_CODIGO
             AADD(_aEmpr,SM0->M0_CODFIL)
        Endif
        dbskip()
    EndDo
    DbGoTo(_nRegSM0)


	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 To Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.  
			//����������������������������������������������������������Ŀ
            //� Filial e Chave e a chave independente da descricao       �
            //� que pode ter sido alterada                               �
			//������������������������������������������������������������
            For _nA:=1 to len(_aEmpr)
                If dbSeek(_aEmpr[_nA]+_cTabela+aCols[n,1])
                    RecLock("SX5",.F.,.T.)
                    dbDelete()
                    MsUnlock()
                EndIf
            Next
		Else
          For _nA:=1 to len(_aEmpr)
               dbSeek(_aEmpr[_nA]+_cTabela+aCols[n,1])
               If found()
                     If aCols[n,2] != SX5->X5_DESCRI
                         RecLock("SX5",.F.)
                         Replace X5_CHAVE  with aCols[n,1]
                         Replace X5_DESCRI with aCols[n,2]
                         MsUnlock()
                     EndIf
               Else
                     If _nItem >= n
                         dbGoto(aRecNo[n,3])
                         RecLock("SX5",.F.)
                         Replace X5_CHAVE  with aCols[n,1]
                         Replace X5_DESCRI with aCols[n,2]
                         MsUnlock()
                     ElseIf (!Empty(aCols[n,1]))
                         RecLock("SX5",.T.)
                         Replace X5_FILIAL with _aEmpr[_nA]
                         Replace X5_TABELA with _cTabela
                         Replace X5_CHAVE  with aCols[n,1]
                         Replace X5_DESCRI with aCols[n,2]
                         MsUnlock()
                     EndIf
               EndIf
          Next

		EndIf
	Next

Return   


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � DGENA01 � Autor � Ligia Sarnauskas       � Data � 12/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao da rotina FICADE02                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico FIESP                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
uSER Function DGENA01()        

SetPrvt("_LRETURN,Y,")


_lReturn := .T.
For y := 1 To Len(aCols) 
	If aCols[n,1] == aCols[y,1] .And. (n != y) .And. (aCols[n,Len(aHeader)+1] == .f. ;
			  .And. aCols[y,Len(aHeader)+1] == .f.) 
			HELP(" ",1,"C16003")
			_lReturn := .F.
			Exit
	EndIf
Next
Return(_lReturn) 

