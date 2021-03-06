/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRecarga� Autor � Isamu Kawakami          � Data �25/09/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Regrava lan�amento de Valores Futuros - Recarga VT/VR       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �fMatriz()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function fRecarga

//��������������������������������������������������������������Ŀ
//� Declara Variaveis                                             
//����������������������������������������������������������������
Local cRecVT    := "952"
Local cRecVR    := "953"
Local nVRecVt 	:= 0
Local nVRecVR	:= 0
Local dRefer	:= Stod( Getmv("MV_FOLMES")+Alltrim(Str(f_UltDia(dDataBase))) )+1
Local cOrigem   := " "
Local cTipo     := "V"
Local dVencVT   := Ctod("")
Local dVencVR   := Ctod("")

//��������������������������������������������������������������Ŀ
//� Pesquisa no SRK os valores de Recarga VT e VR                �
//����������������������������������������������������������������
dbSelectArea("SRK")
dbSetOrder(1)

Srk->(dbSeek(Sra->Ra_Filial+Sra->Ra_Mat))

While !Eof() .and. Srk->Rk_Filial+Srk->Rk_Mat == Sra->Ra_Filial+Sra->Ra_Mat
  If Srk->Rk_PD == cRecVT .and. AnoMes(Srk->Rk_DtVenc) == AnoMes(dRefer)
     nVRecVT := Srk->Rk_ValorPA
     dVencVT := Srk->Rk_DtVenc
  ElseIf Srk->Rk_PD == cRecVR .and. AnoMes(Srk->Rk_DtVenc) == AnoMes(dRefer)
     nVRecVR := Srk->Rk_ValorPA
     dVencVR := Srk->Rk_DtVenc   
  Endif
  
  Srk->(dbSkip())
EndDo  
  
//��������������������������������������������������������������Ŀ
//� Regrava no SRC os valores de recarga utilizando fMatriz      �
//����������������������������������������������������������������
FMatriz(cRecVT,nVRecVT,,,,cTipo,cOrigem,,,dVencVT,.T.)	//Gera pelo Teto de Desconto
FMatriz(cRecVR,nVRecVR,,,,cTipo,cOrigem,,,dVencVR,.T.)	//Gera pelo Teto de Desconto

Return() 