/*/
_____________________________________________________________________________
������������������������������������������������������������������������������
��Fun�ao � NNOTA m� Autor � Luiz Alberto � Data � 19/10/16                 ���
������������������������������������������������������������������������������
���Descri��o � Programa Para Preenchimento da Nota Fiscal de Entrada       ���
���com zeros a esquerda e complete o campo com base no seu tamanho         ���
������������������������������������������������������������������������������
��� Uso � GJP                                                              ���
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NNota()

If Len(AllTrim(M->CNFISCAL)) < TAMSX3("F1_DOC")[1]
M->CNFISCAL := StrZero(Val(M->CNFISCAL),TAMSX3("F1_DOC")[1])
Endif

If Empty(Val(M->CNFISCAL))
Alert("Atencao preencha o Campo do Documento de Entrada Corretamente, Apenas N�meros !")
Return .f.
Endif
Return .t.