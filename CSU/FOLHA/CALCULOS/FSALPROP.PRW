/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FSALPROP  º Autor ³ Isamu Kawakami     º Data ³  22/04/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fórmula que calcula o salario proporcional para admitidos   ±±
±±º          ³ no mês, conforme regra da CSU.                              ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
