#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110LEG  �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para definir o descritivo da nova opcao de���
���          � legenda customizada.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Modulo de Compras                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110LEG()

Local aLegCor := aClone( ParamIxb[1] )
Local aColors := {}

Aadd( aColors, {"TRILEFT",'Devolvida por Procurement' } )

For w7 := 1 To Len( aLegCor )
    Aadd( aColors, { aLegCor[w7][1], aLegCor[w7][2] } )
Next

Return( aColors )