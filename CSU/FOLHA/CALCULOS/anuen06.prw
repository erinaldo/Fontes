#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ANUEN06  ³ Autor ³ Isamu Kawakami        ³ Data ³ 11.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Anuenio da Filial Recife para Admitidos Apos 04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para CSU                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Anuen06()

SetPrvt("_cCodAnu,_nValAnu,_dBaseAnu,_cAcumula,_nAnosTrab,")

//Montando Variaveis de Trabalho
_cCodAnu  := aCodFol[001,1]
_nValAnu  := 0
_dBaseAnu := Ctod("01/04/2002")              
_cAcumula := ""
_nAnosTrab:= (Int((dDataBase - Sra->Ra_Admissa)/365.25))-1 //considera 01 ano de carencia 
_nVSalMat := fBuscaPD("131")
_nQtSalMat:= fBuscaPD("131","H")

//Valor do Anuenio da filial 06
Srx->(dbSeek("  20            0601     "))
_nValAnu := VAL(SUBST(SRX->RX_TXT,1,12))

//Acumula ?
Srx->(dbSeek("  20            0604     "))
_cAcumula := SUBST(SRX->RX_TXT,41,1)


//Caso o funcionario tenha -02 anos e existir calculo de anuenio, deleta-o  
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± FEITO A ALTERACAO DE 06 PARA 08 CONFORME OS-2041/12±±           
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//If Sra->Ra_Sindica=="06"
If Sra->Ra_Sindica=="08"
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataBase - Sra->Ra_Admissa)/365.25) < 2
      fDelPD("046")
   Endif

//Caso o funcionario tenha 02 ou + anos de trabalho, paga 

   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataBase - Sra->Ra_Admissa)/365.25) >= 2
     If _cAcumula=="S" 
       If fBuscaPD("131") > 0 .and. _nQtSalMat < 30
          fGeraVerba("131",_nVSalMat+(((_nValAnu*_nAnosTrab)/30)*_nQtSalMat),_nQtSalMat,,,,,,,,.T.)
          fGeraVerba(_cCodAnu,((_nValAnu*_nAnosTrab)/30)*DiasTrab,_nAnosTrab,,,,,,,,.T.)
       ElseIf fBuscaPD("131") > 0 .and. _nQtSalMat == 30
          fGeraVerba("131",_nVSalMat+(_nValAnu*_nAnosTrab),_nQtSalMat,,,,,,,,.T.)        
       Else   
          fGeraVerba(_cCodAnu,((_nValAnu*_nAnosTrab)/30)*DiasTrab,_nAnosTrab,,,,,,,,.T.)
       Endif
     Else
       fGeraverba(_cCodAnu,(_nValAnu/30)*DiasTrab,_nAnosTrab,,,,,,,,.T.)
     Endif
   ElseIf Sra->Ra_Admissa <= _dBaseAnu 
     If _cAcumula=="S" .and. fBuscaPd("131")>0 .and. _nQtSalMat == 30
          fGeraVerba("131",_nVSalMat+(_nValAnu*(_nAnosTrab+1)),_nQtSalMat,,,,,,,,.T.)
     Endif
   Endif    
Endif

Return(" ")                                


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ANUEFER  ³ Autor ³ Isamu Kawakami        ³ Data ³ 11.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Anuenio da Filial Recife para Admitidos Apos 04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para CSU                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AnueFer()

SetPrvt("_cCodAnu,_nValAnu,_dBaseAnu,_cAcumula,_nAnosTrab,_nDiasFer")

//Montando Variaveis de Trabalho
_cCodAnu  := aCodFol[001,1]
_nValAnu  := 0
_dBaseAnu := Ctod("01/04/2002")              
_cAcumula := ""
_nAnosTrab:= (Int((dDataBase - Sra->Ra_Admissa)/365.25))-1   
_nDiasFer := fBuscaPD("126","H")

//Valor do Anuenio da filial 06
Srx->(dbSeek("  20            0601     "))
_nValAnu := VAL(SUBST(SRX->RX_TXT,1,12))

//Acumula ?
Srx->(dbSeek("  20            0604     "))
_cAcumula := SUBST(SRX->RX_TXT,41,1)


//Caso o funcionario tenha -02 anos e existir calculo de anuenio, deleta-o
//If Sra->Ra_Sindica=="06"
If Sra->Ra_Sindica=="08"
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataBase - Sra->Ra_Admissa)/365.25) < 2
      fDelPD("046")
   Endif

//Caso o funcionario tenha 02 ou + anos de trabalho, paga
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataBase - Sra->Ra_Admissa)/365.25) >= 2
     If _cAcumula=="S" 
       fGeraVerba(_cCodAnu,((_nValAnu*_nAnosTrab)/30)*_nDiasFer,_nDiasFer,,,,,,,,.T.)
     Else
       fGeraverba(_cCodAnu,(_nValAnu/30)*_nDiasFer,_nDiasFer,,,,,,,,.T.)
     Endif
   Endif    
Endif

Return(" ")


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ANUERES  ³ Autor ³ Isamu Kawakami        ³ Data ³ 11.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Anuenio da Filial Recife para Admitidos Apos 04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para CSU                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AnueRes()

SetPrvt("_cCodAnu,_nValAnu,_dBaseAnu,_cAcumula,_nAnosTrab,_nDiasSal")

//Montando Variaveis de Trabalho
_cCodAnu  := aCodFol[001,1]
_nValAnu  := 0
_dBaseAnu := Ctod("01/04/2002")              
_cAcumula := ""
_nAnosTrab:= (Int((dDataDem - Sra->Ra_Admissa)/365.25))-1   
_nDiasSal  := DiasTrab //fBuscaPD("161","H") 
//If Sra->Ra_Sindica=="06" .and. Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) >= 2
If Sra->Ra_Sindica=="08" .and. Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) >= 2
     nAdtServ := 0
Endif 

//Valor do Anuenio da filial 06
Srx->(dbSeek("  20            0601     "))
_nValAnu := VAL(SUBST(SRX->RX_TXT,1,12))

//Acumula ?
Srx->(dbSeek("  20            0604     "))
_cAcumula := SUBST(SRX->RX_TXT,41,1)

//If Sra->Ra_Sindica=="06"
If Sra->Ra_Sindica=="08"

//Caso o funcionario tenha -02 anos e existir calculo de anuenio, deleta-o
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) < 2
      fDelPD("046")
   Endif

//Caso o funcionario tenha 02 ou + anos de trabalho, paga
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) >= 2
     If _cAcumula=="S" 
       fGeraVerba(_cCodAnu,((_nValAnu*_nAnosTrab)/30)*_nDiasSal,_nDiasSal,,,,,,,,.T.)
     Else
       fGeraverba(_cCodAnu,(_nValAnu/30)*_nDiasSal,_nDiasSal,,,,,,,,.T.)
     Endif
   Endif    

Endif

//If Sra->Ra_Sindica=="06" .and. Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) >= 2
If Sra->Ra_Sindica=="08" .and. Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataDem - Sra->Ra_Admissa)/365.25) >= 2
     nAdtServ := _nValAnu*_nAnosTrab
Endif 

Return(" ")


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ANUE13O  ³ Autor ³ Isamu Kawakami        ³ Data ³ 11.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Anuenio da Filial Recife para Admitidos Apos 04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMake ( DOS e Windows )                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para CSU                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Anue13O()

SetPrvt("_cCodAnu,_nValAnu,_dBaseAnu,_cAcumula,_nAnosTrab,_nDiasSal")

//Montando Variaveis de Trabalho
_cCodAnu  := aCodFol[001,1]
_nValAnu  := 0
_dBaseAnu := Ctod("01/04/2002")              
_cAcumula := ""
If c__Roteiro == "132"  
   _nAnosTrab:= (Int((dDataRef - Sra->Ra_Admissa)/365.25))-1
ElseIf c__Roteiro =="131"
   _nAnosTrab:= (Int((mv_par14 - Sra->Ra_Admissa)/365.25))-1
Endif
_dDataRef := mv_par14   

//Valor do Anuenio da filial 06
Srx->(dbSeek("  20            0601     "))
_nValAnu := VAL(SUBST(SRX->RX_TXT,1,12))

//Acumula ?
Srx->(dbSeek("  20            0604     "))
_cAcumula := SUBST(SRX->RX_TXT,41,1)


//If Sra->Ra_Sindica=="06"
If Sra->Ra_Sindica=="08"

 If c__Roteiro == "132" 	
//Caso o funcionario tenha -02 anos e existir calculo de anuenio, deleta-o
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataRef - Sra->Ra_Admissa)/365.25) < 2
      fDelPD("046")
   Endif

//Caso o funcionario tenha 02 ou + anos de trabalho, paga
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((dDataRef - Sra->Ra_Admissa)/365.25) >= 2
     If _cAcumula=="S" 
       fGeraVerba(_cCodAnu,((_nValAnu*_nAnosTrab)/12)*nAvos,nAvos,,,,,,,,.T.)
     Else
       fGeraverba(_cCodAnu,(_nValAnu/12)*nAvos,nAvos,,,,,,,,.T.)
     Endif
   Endif    
 
 ElseIf c__Roteiro == "131"

   fAvos13(@nAvos,dDataRef,nAvosFal13,0,"1")

//Caso o funcionario tenha -02 anos e existir calculo de anuenio, deleta-o
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((_dDataRef - Sra->Ra_Admissa)/365.25) < 2
      nAdtServ := 0
   Endif

//Caso o funcionario tenha 02 ou + anos de trabalho, paga
   If Sra->Ra_Admissa >= _dBaseAnu .and. Int((_dDataRef - Sra->Ra_Admissa)/365.25) >= 2
     If _cAcumula=="S" 
       nAdtServ := _nValAnu*_nAnosTrab
     Else
       nAdtServ := _nValAnu
     Endif
   Endif 
 Endif

Endif


Return(" ")
