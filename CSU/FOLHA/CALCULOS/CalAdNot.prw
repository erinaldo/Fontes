/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CalAdNot ºAutor  ³ William Campos     º Data ³ 24/10/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula Adicional Noturno conforme a Filial.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Roteiro de Calculo                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Criar os Mnemonicos:                                       º±±
±±º          ³    M_ADN20    - Filiais com Adic. Noturno a 20%            º±±
±±º          ³    M_ADN30    - Filiais com Adic. Noturno a 30%            º±±
±±º          ³    M_ADNBASE  - Cod. Verba Base Adic. Noturno              º±±
±±º          ³    M_BASADNHE - Cod. Verba Base Adic. Noturno s/ HE        º±±
±±º          ³    M_ADNVB20  - Cod. Verba Adic. Noturno 20%               º±±
±±º          ³    M_ADNVB30  - Cod. Verba Adic. Noturno 30%               º±±
±±º          ³    M_ADNHE20  - Cod. Verba Adic. Noturno 20% s/ HE         º±±
±±º          ³    M_ADNHE30  - Cod. Verba Adic. Noturno 30% s/ HE         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ Inclusao de novo percentual para a filial 07-BH  06/02/2012º±±
±±ºAnalista  ³ Referente a OS 0280/12							          º±±
±±ºAnderson  ³  Criar os Mnemonicos:                                      º±±
±±ºCasarotti ³    M_ADN50    - Filiais com Adic. Noturno a 50%            º±±
±±º          ³    M_ADNVB50  - Cod. Verba Adic. Noturno 50%               º±±
±±º          ³    M_ADNHE50  - Cod. Verba Adic. Noturno 50% s/ HE         º±±
±±º          ³    Criar as verbas A09 e A10					              º±±
±±º          ³    														  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              
User Function CalAdNot()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca verba de Base para o calculo.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cCodBas	:= M_ADNBASE
_cCodBHE	:= M_BASADNHE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o codigo da verba para pagamento do Adicional Noturno.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cCodVb	:= If(SRA->RA_FILIAL$M_ADN20	,M_ADNVB20	,If(SRA->RA_FILIAL$M_ADN30	,M_ADNVB30	,	If(SRA->RA_FILIAL$M_ADN50	,M_ADNVB50	,"NNN")))
_cCodHE	:= If(SRA->RA_FILIAL$M_ADN20	,M_ADNHE20	,If(SRA->RA_FILIAL$M_ADN30	,M_ADNHE30	,	If(SRA->RA_FILIAL$M_ADN50	,M_ADNHE50	,"NNN")))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para Filial 18, admitidos apos 01/11/12                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Sra->Ra_Filial == "18" .and. Sra->Ra_Admissa >= Stod("20121101")
   _cCodVb := M_ADNVB20
   _cCodHE := M_ADNHE20
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao calcula se nao houver definicao do % para a Filial.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _cCodVb=="NNN"
	MsgAlert("Definir Ad.Noturno Filial "+SRA->RA_FILIAL+".","ATENÇÃO")
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
