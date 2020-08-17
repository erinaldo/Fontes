#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120LEG � Autor � Carlos A. Queiroz  � Data �  30/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclusaso de nova cor na legenda no Pedido de Compras.     ���
�������������������������������������������������������������������������͹��
���Uso       � GJP Hotels & Resort                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120COR()
Local aAuxCores := PARAMIXB[1]

aAuxCores[aScan( aAuxCores, { |x| AllTrim( x[2] ) == "ENABLE" } )][1]  := ' C7_QUJE==0 .And. C7_QTDACLA==0 .And. C7_APROV<>"XXXXXX"' //-- Pendente
aAuxCores[aScan( aAuxCores, { |x| AllTrim( x[2] ) == "BR_AZUL" } )][1]  := ' C7_ACCPROC<>"1" .And. C7_CONAPRO=="B" .And. C7_QUJE < C7_QUANT .And. C7_APROV<>"XXXXXX" ' //-- Pendente

aAdd(aAuxCores, { ' C7_ACCPROC<>"1" .And. C7_CONAPRO=="B" .And. C7_QUJE < C7_QUANT .And. C7_APROV=="XXXXXX"'   		, 'BR_PINK'})	         //-- Rejeitado

Return aAuxCores