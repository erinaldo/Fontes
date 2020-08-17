#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � fSubsEsp � Autor � William Campos     � Data � 07/11/2005  ���
�������������������������������������������������������������������������͹��
���Descricao � Substitui Caracteres Especiais por Caracter comum.         ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  fSubsEsp(cCharStr)
nTamanho:= Len(RTrim(cCharStr))
cEspDe		:= "�����������ں�"
cEspAt		:= "CAAAAOOOEEIUOA"
cValidChar	:= " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
For nCont := 1 to nTamanho
	If nCont == 1
		cChar	:= Left(cCharStr,1)
		cAntes	:= ""
		cDepois	:= Subs(cCharStr,2)
		If At(cChar,cEspDe)>0 .or. !(cChar$cValidChar)
			If !(cChar$cValidChar)
				cCharStr	:= cDepois
			Else
				cCharStr	:= Subs(cEspAt,At(cChar,cEspDe),1)+cDepois
			EndIf
		EndIf
	ElseIf nCont == nTamanho
		cChar	:= Right(cCharStr,1)
		cAntes	:= Left(cCharStr,nTamanho-1)
		cDepois	:= ""
		If At(cChar,cEspDe)>0 .or. !(cChar$cValidChar)
			If !(cChar$cValidChar)
				cCharStr	:= cAntes
			Else
				cCharStr	:= cAntes+Subs(cEspAt,At(cChar,cEspDe),1)
			EndIf
		EndIf
	Else
		cChar	:= Subs(cCharStr,nCont,1)
		cAntes	:= Left(cCharStr,nCont-1)
		cDepois	:= Subs(cCharStr,nCont+1)
		If At(cChar,cEspDe)>0 .or. !(cChar$cValidChar)
			If !(cChar$cValidChar)
				cCharStr	:= cAntes+Space(1)+cDepois
			Else
				cCharStr	:= cAntes+Subs(cEspAt,At(cChar,cEspDe),1)+cDepois
			EndIf
		EndIf
	EndIf
Next
cCharStr	:= StrTran(cCharStr,CHR(10),Space(1))
cCharStr	:= StrTran(cCharStr,CHR(13),Space(1))
cCharStr	:= StrTran(cCharStr,".",Space(1))
cCharStr	:= StrTran(cCharStr,",",Space(1))
cCharStr	:= StrTran(cCharStr,";",Space(1))
cCharStr	:= StrTran(cCharStr,":",Space(1))
cCharStr	:= StrTran(cCharStr,"/",Space(1))
cCharStr	:= StrTran(cCharStr,"-",Space(1))
For nCont:=1 to 10
	cCharStr	:= StrTran(cCharStr,Space(2),Space(1))
Next
Return(cCharStr)
