#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � AP6 IDE            � Data �  30/10/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TESTEP8


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local Regant
Local cHora
Local aDados := {}

dbSelectArea("SP8")
dbSetOrder(1)
DbGotop()  

Regant := P8_FILIAL+P8_MAT+P8_ORDEM

While !EOF()

	if Regant <> SP8->P8_FILIAL + SP8->P8_MAT + SP8->P8_ORDEM
       aAdd(Adados,{cInd,nHoraAnt})
	Endif
	Regant   := P8_FILIAL+P8_MAT+P8_ORDEM
	cInd     := P8_FILIAL+P8_MAT+P8_ORDEM+Dtos(P8_DATA)+Str(P8_HORA,5,2)
	nHoraAnt := SP8->P8_HORA
	SP8->(DbSkip())
Enddo

For nX := 1 To Len(aDados)
	if SP8->(DbSeek(aDados[nX][1]))
		RecLock("SP8",.F.)
			cHora := PADR(AllTrim(Str(aDados[nX][2])),5,"0")
			If Left( cHora,2 ) == '00'
				cHoraX := '23'    
				cMin  := Right( cHora,2 )
				SP8->P8_HORA := Val(cHoraX +'.'+ cMin)
			Else
				SP8->P8_HORA := SP8->P8_HORA - 1
			EndIf
		SP8->(MsUnLock())
	Endif	
Next nX


Return
