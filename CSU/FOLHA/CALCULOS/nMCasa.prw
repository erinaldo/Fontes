#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MesesCasa � Autor � Sandra R. Prada 	 � Data �  10/05/2004 ���
�������������������������������������������������������������������������͹��
���Descricao � Calc. Meses de Casa, qdo. houver afastamentos              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function nMCasa()

SetPrvt("_DataIni,_nMCasaAfast,_nMesesAfast")

_DataIni := Ctod("  /  /    ")
_nMCasaAfast := 0
_nMesesAfast := 0

dbSelectArea( "SR8" )
dbSetOrder(1)
   dbSeek( SRA->(RA_FILIAL+RA_MAT) )
   Do While !Eof() .And. SR8->(R8_FILIAL+R8_MAT) == SRA->(RA_FILIAL+RA_MAT)
      _dataini := SR8->R8_DATAINI
   dbSkip()
   EndDo

If !Empty(_dataini) 
  _nmcasaafast := (_dataini - SRA->RA_ADMISSA)/30
  _nmesesafast := (dDatabase-_dataini) /30
Endif             

  M_MCASAAFA := _nmcasaafast                                     
  M_NMAFAST  := _nmesesafast 
  M_DTINIAFA := _dataini
  
  If Month(ddatabase) == 1
     _DDTMESANT := CTOD("01/12/"+STRZERO(YEAR(DDATABASE)-1,4))
  Else 
	 _DDTMESANT := Ctod("01/"+StrZero(Month(dDatabase)-1,2)+"/"+StrZero(Year(dDataBase),4))     
  Endif  
  
	M_DTMESANT := _DDTMESANT
	

  If Month(ddatabase) == 1
     _DTPMESANT := CTOD("31/12/"+STRZERO(YEAR(DDATABASE)-1,4))
  ElseIF Month(ddatabase) == 3
  	 _DTPMESANT := Ctod("28/"+StrZero(Month(dDatabase)-1,2)+"/"+StrZero(Year(dDataBase),4))     
  Else 
	 _DTPMESANT := Ctod("30/"+StrZero(Month(dDatabase)-1,2)+"/"+StrZero(Year(dDataBase),4))     
  Endif
	  
	M_PERAFAST := INT((_DTPMESANT - M_DTINIAFA)/30)+1
  	
return(" ")