/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FSALPROP  � Autor � Isamu Kawakami     � Data �  22/04/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � F�rmula que calcula o salario proporcional para admitidos   ��
���          � no m�s, conforme regra da CSU.                              ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function fSalProp

Local nDTrab
Local ni

If MesAno(Sra->Ra_Admissa) == MesAno(dDataBase)
	
	If f_UltDia(dDataBase) > 30 .or. f_UltDia(dDataBase) < 30
		
		If Day(Sra->Ra_Admissa) > 1
			
			nDTrab := ( f_UltDia(dDataBase) - Day(Sra->Ra_Admissa) ) + 1
			
			For ni := 1 to Len(Apd)
				
				If apd[ni,9] != "D"
					
					If aPd[ni,1] = "101"  .and. SRA->RA_CATFUNC == "M"
						aPd[ni,4] := nDTrab
						aPd[ni,5] := ( Salario/f_UltDia(dDataBase) ) * nDTrab
					Endif
					
				Endif
				
			Next
			
		Endif
		
	Endif
	
Endif


Return       
