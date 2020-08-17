/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CalAdNot �Autor  � William Campos     � Data � 24/10/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula Adicional Noturno conforme a Filial.               ���
�������������������������������������������������������������������������͹��
���Uso       � Roteiro de Calculo                                         ���
�������������������������������������������������������������������������͹��
���Observacao� Criar os Mnemonicos:                                       ���
���          �    M_ADN20    - Filiais com Adic. Noturno a 20%            ���
���          �    M_ADN30    - Filiais com Adic. Noturno a 30%            ���
���          �    M_ADNBASE  - Cod. Verba Base Adic. Noturno              ���
���          �    M_BASADNHE - Cod. Verba Base Adic. Noturno s/ HE        ���
���          �    M_ADNVB20  - Cod. Verba Adic. Noturno 20%               ���
���          �    M_ADNVB30  - Cod. Verba Adic. Noturno 30%               ���
���          �    M_ADNHE20  - Cod. Verba Adic. Noturno 20% s/ HE         ���
���          �    M_ADNHE30  - Cod. Verba Adic. Noturno 30% s/ HE         ���
�������������������������������������������������������������������������͹��
���Alteracao � Inclusao de novo percentual para a filial 07-BH  06/02/2012���
���Analista  � Referente a OS 0280/12							          ���
���Anderson  �  Criar os Mnemonicos:                                      ���
���Casarotti �    M_ADN50    - Filiais com Adic. Noturno a 50%            ���
���          �    M_ADNVB50  - Cod. Verba Adic. Noturno 50%               ���
���          �    M_ADNHE50  - Cod. Verba Adic. Noturno 50% s/ HE         ���
���          �    Criar as verbas A09 e A10					              ���
���          �    														  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                              
User Function CalAdNot()
//��������������������������������������������������������������������������Ŀ
//� Busca verba de Base para o calculo.                                      �
//����������������������������������������������������������������������������
_cCodBas	:= M_ADNBASE
_cCodBHE	:= M_BASADNHE
//��������������������������������������������������������������������������Ŀ
//� Define o codigo da verba para pagamento do Adicional Noturno.            �
//����������������������������������������������������������������������������
_cCodVb	:= If(SRA->RA_FILIAL$M_ADN20	,M_ADNVB20	,If(SRA->RA_FILIAL$M_ADN30	,M_ADNVB30	,	If(SRA->RA_FILIAL$M_ADN50	,M_ADNVB50	,"NNN")))
_cCodHE	:= If(SRA->RA_FILIAL$M_ADN20	,M_ADNHE20	,If(SRA->RA_FILIAL$M_ADN30	,M_ADNHE30	,	If(SRA->RA_FILIAL$M_ADN50	,M_ADNHE50	,"NNN")))

//��������������������������������������������������������������������������Ŀ
//� Tratamento para Filial 18, admitidos apos 01/11/12                       �
//����������������������������������������������������������������������������
If Sra->Ra_Filial == "18" .and. Sra->Ra_Admissa >= Stod("20121101")
   _cCodVb := M_ADNVB20
   _cCodHE := M_ADNHE20
Endif

//��������������������������������������������������������������������������Ŀ
//� Nao calcula se nao houver definicao do % para a Filial.                  �
//����������������������������������������������������������������������������
If _cCodVb=="NNN"
	MsgAlert("Definir Ad.Noturno Filial "+SRA->RA_FILIAL+".","ATEN��O")
	Return()
EndIf
_nPercAd	:= Posicione("SRV"	,1	,xFilial("SRV")+_cCodVb		,"RV_PERC")/100
_nRefAd	:= fBuscaPd(_cCodBas,"H")
_nValAd	:= _nRefAd*_nPercAd*(Salmes/SRA->RA_HRSMES)
fGeraVerba(_cCodVb,_nValAd,_nRefAd,,,,,,,,.F.)
If _cCodHE#"NNN"
	_nPercHE	:= Posicione("SRV"	,1	,xFilial("SRV")+_cCodHE	,"RV_PERC")/100
	_nRefHE	:= fBuscaPd(_cCodBHE,"H")
	_nValHE	:= _nRefHE*_nPercHE*(Salmes/SRA->RA_HRSMES)
	fGeraVerba(_cCodHE,_nValHE,_nRefHE,,,,,,,,.F.)
EndIf
Return()
