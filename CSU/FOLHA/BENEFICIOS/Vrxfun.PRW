#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrAfast บ Autor ณ Adilson Silva      บ Data ณ  17/10/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica Afastamentos do Periodo.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
//OS 0047/06-INCLUI cParam
User Function fAsrAfast(dDtDe,dDtAte,nDAtual,nDTrab,cParam)

Local aOld   := GETAREA()

Local aAfas   := {}
Local aDatas  := {}
Local dIni    := dDtDe
Local nDAfas  := 0
Local nDMes   := 0
Local cMesAnt, nDiasFal, nDia
Local i, nPos, nMes, nAno
Local nAux
Local cMesAnoBH := GETMV("CS_BHOMES")

Do While dIni <= dDtAte
   Aadd(aDatas,{dIni,""})
   dIni++
   nDMes++
EndDo

dbSelectArea( "SR8" )
dbSetOrder(1)
dbSeek( SRA->(RA_FILIAL+RA_MAT) )
Do While !Eof() .And. SR8->(R8_FILIAL+R8_MAT) == SRA->(RA_FILIAL+RA_MAT)
   Aadd(aAfas,{SR8->R8_TIPO,    ;
                SR8->R8_DATAINI, ;
                If(SR8->R8_DATAFIM==Ctod("//"),Ctod("31/12/2050"),SR8->R8_DATAFIM) }   )
   dbSkip()
EndDo

If Len(aAfas) > 0 .And. Len(aDatas) > 0
   For i := 1 To Len(aDatas)
      If ( nPos := Ascan(aAfas,{|x| aDatas[i,1] >= x[2] .And. aDatas[i,1] <= x[3]}) ) > 0
         aDatas[i,2] := "A"
      EndIf
   Next
EndIf        

Aeval(aDatas,{|x| nDAfas := nDAfas + If(x[2]=="A",1,0)})

// Dias Trabalhados no Mes
nDTrab := nDMes - nDAfas     // Substituido 30 por nDmes

// Calcula Quantidade de Dias do Vale Refeicao e do Vale Transporte
If lAdm
   //ALTERADO ROUND POR INT, CONF. O.S. 1025-12
   nDAtual := Int((nDAtual / nUlt_Dia) * (nDMes-nDAfas))  //Round( (nDAtual / nUlt_Dia) * (nDMes-nDAfas),0 )      
Else
   If nDAfas > 0   
   //ALTERADO ROUND POR INT, CONF. O.S. 1025-12
      nDAtual := Round( (nDAtual / nDMes) * (nDMes-nDAfas),0 )      //nDAtual :=  Int((nDAtual / nDMes) * (nDMes-nDAfas))+1
      nAux   := Int( nDAtual )
   
      If nDAtual - nAux > 0 
         nDAtual += 1
      EndIf

   // Proporcionaliza para funcionarios admitidos no mes
   elseif day(dDtde) <> val(substr(cperiodo,1,2))
      nDAtual := int((nDAtual / nUlt_Dia) * (nDMes-nDAfas))     //Round( (nDAtual / nUlt_Dia) * (nDMes-nDAfas),0 ) 
   EndIf                               

   // Busca Faltas no Mes Anterior
   nMes    := Month(dDtDe)

   nAno    := Year(dDtDe)
   /*
   nMes--
   If nMes == 0
      nMes := 12
      nAno--
   EndIf
   */
   // Estou retirando 2 meses da data de referencia pois na 
   // geracao do kit eu estou sem o mes anterior fechado.
   nMes := nMes - 2
   If nMes == 0
      nMes := 12
      nAno--
   elseif nMes == -1
      nMes := 11
      nAno--
   EndIf
   cMesAnt := Str(nAno,4)+StrZero(nMes,2)

   nDiasFal := 0
  /* COMENTADO PARA GERACAO DO KIT BENEFICIO DO MES 01/2004
      RETORNADO EM 12/02/2004 PARA GERACAO DO PEDIDO DO MES 03/2004 */
   For i := 1 To 2
       
       If cMesAnt > cMesAnoBH
          If SRD->(dbSeek( SRA->(RA_FILIAL+RA_MAT)+cMesAnt+If(i==1,"725","713") ))
             If SRD->RD_TIPO1 == "D"
                nDiasFal += SRD->RD_HORAS
             ElseIf SRD->RD_TIPO1 == "V" .And. SRD->RD_HORAS > 0
                nDiasFal += SRD->RD_HORAS
             ElseIf SRD->RD_TIPO1 == "H"
                nDia := (SRD->RD_HORAS/(SRA->RA_HRSMES/30)) - Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
                If nDia < 0.5
                   nDiasFal += Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
                Else
                   nDiasFal += (Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30)) + 1)
                Endif
             Endif
          Endif
       
       Else
       //incluso por isamu conf OS 1431/12, pois podem existir verbas 409 ou 725
          If SRD->(dbSeek( SRA->(RA_FILIAL+RA_MAT)+cMesAnt+If(i==1,"409","713") ))
             If SRD->RD_TIPO1 == "D"
                nDiasFal += SRD->RD_HORAS
             ElseIf SRD->RD_TIPO1 == "V" .And. SRD->RD_HORAS > 0
                nDiasFal += SRD->RD_HORAS
             ElseIf SRD->RD_TIPO1 == "H"
                nDia := (SRD->RD_HORAS/(SRA->RA_HRSMES/30)) - Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
                If nDia < 0.5
                   nDiasFal += Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
                Else
                   nDiasFal += (Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30)) + 1)
                Endif
             Endif
          Endif 
       Endif   
   Next

   // Abate Faltas
 //OS 0047/06
 If cParam==1  
 	nDAtual -= nDiasFal
   	nDAtual := If(nDAtual < 0,0,nDAtual)
 Else
    nDAtual := If(nDAtual < 0,0,nDAtual) 

 Endif
EndIf

RESTAREA( aOld )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrPeri  บAutor  ณMicrosiga           บ Data ณ  10/17/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Periodo de Processamento.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fAsrPeri(dDtRef,cPeriodo)
 
 Local nMes, nAno, cDiaIni, cDiaFim

 nMes    := Month(dDtRef)
 nAno    := Year(dDtRef)
 cDiaIni := Left(cPeriodo,2)
 cDiaFim := Right(cPeriodo,2)
 
 dDtDe   := Ctod( cDiaIni+"/"+StrZero(nMes,2)+"/"+Str(nAno,4) )
 // Verifica se e' Admissao no Mes
 If MesAno(SRA->RA_ADMISSA) == MesAno(dDtRef)
    dDtDe := If(SRA->RA_ADMISSA > dDtDe,SRA->RA_ADMISSA,dDtDe)
 EndIf

 If Val(cDiaIni) == 1
    cDiaFim := StrZero(f_UltDia(dDtRef),2)
 Else
    nMes++
    If nMes == 13
       nMes := 1
       nAno++
    EndIf
 EndIf

 dDtAte  := Ctod( cDiaFim+"/"+StrZero(nMes,2)+"/"+Str(nAno,4) )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBscaPeri บAutor  ณMicrosiga           บ Data ณ  10/23/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca Periodo de Calculo do Vale Refeicao.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fBscaPeri(cPeriodo)

 Local aOld := GETAREA()
 Local lRet := .F.
 
 dbSelectArea( "SZU" )
 If dbSeek( xFilial("SZU")+"05"+SRA->RA_FILIAL )
    cPeriodo := SubStr(SZU->ZU_TXT,108,4)
    If !Empty(cPeriodo)
       lRet := .T.
    EndIf
 EndIf
 
 RESTAREA( aOld )     
 
Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVRXFUN    บAutor  ณMicrosiga           บ Data ณ  07/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAsrExtra( nValor, nDias, dDtExtra, cPd )

Local aOld := GETAREA()

dbSelectArea( "SR1" )
dbSetOrder(1)

If !dbSeek( SRA->(RA_FILIAL+RA_MAT) + "  " + cPd )
   RecLock("SR1",.T.)
    SR1->R1_FILIAL := SRA->RA_FILIAL
    SR1->R1_MAT    := SRA->RA_MAT
    SR1->R1_SEMANA := "  "
    SR1->R1_PD     := cPd
Else
   RecLock("SR1",.F.)
EndIf
 SR1->R1_TIPO1   := "V"
 SR1->R1_HORAS   := nDias
 SR1->R1_VALOR   := nValor
 SR1->R1_DATA    := dDtExtra
 SR1->R1_CC      := SRA->RA_CC
 SR1->R1_PARCELA := 0
 SR1->R1_TIPO2   := "G"
MsUnlock()

RESTAREA( aOld )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVRXFUN    บAutor  ณMicrosiga           บ Data ณ  07/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAsrFutur( nValor, nDias, dDtExtra, cPd )

Local aOld := GETAREA()

dbSelectArea( "SRK" )
dbSetOrder(1)
//->As linhas comentadas com * correspondem a OS 0926/05, que solicitou melhoria no sentido de poder gravar duas informa็๕es de
//->V.Refei็ใo e V.Transporte no arquivo SRK (Futuros)
//*If !dbSeek( SRA->(RA_FILIAL+RA_MAT) + cPd )
   RecLock("SRK",.T.)
    SRK->RK_FILIAL := SRA->RA_FILIAL
    SRK->RK_MAT    := SRA->RA_MAT
    SRK->RK_PD     := cPd
//*Else
   //*RecLock("SRK",.F.)
//*EndIf
 SRK->RK_VALORTO := nValor
 SRK->RK_PARCELA := 1
 SRK->RK_VALORPA := nValor
 SRK->RK_DTVENC  := dDtExtra
 SRK->RK_DTMOVI  := dDtExtra
// SRK->RK_DOCUMEN := SRA->RA_MAT    // SRP MIGRACAO 710 x 811
 SRK->RK_DOCUMEN := cPd + SUBS(MESANO(dDtExtra),5,2) + SUBS(MESANO(dDtExtra),4,1)
 SRK->RK_CC      := SRA->RA_CC
 SRK->RK_DATARQ  := MesAno( dDtExtra )
MsUnlock()

RESTAREA( aOld )

Return
