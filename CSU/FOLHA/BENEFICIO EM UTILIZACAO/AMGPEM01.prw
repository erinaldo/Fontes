#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMGPEM01 บ Autor ณ Adilson Silva      บ Data ณ 10/01/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carga dos Historicos de Assistencia Medica e Odontologica  บฑฑ
ฑฑบ          ณ e das co-participacoes.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AMGPEM01()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}
 Local cTexto    := "Op็ใo para processamento dos Hist๓ricos"

 Private cCadastro  := "Carga dos Hist๓ricos"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao := ""
 Private cPerg      := ""
 Private nEsc       := 0

 cDescricao := "Esta rotina irแ montar a carga inicial dos hist๓ricos das assist๊ncias m้dicas" + Chr(13) + Chr(10)
 cDescricao += "e odontol๓gicas, e das co-participa็๕es que houverem. "

 If fOpcRadio( @nEsc, "Aten็ใo", cTexto, "Por Rateio", "Por Dependente", "Cancelar" ) == 3
    Return
 EndIf

 If nEsc == 1
    cDescricao += "POR RATEIO"
    cPerg := "AMGPEM10"
 ElseIf nEsc == 2
    cDescricao += "POR DEPENDENTE"
    cPerg := "AMGPEM20"
 EndIf

 fAsrPerg()
 Pergunte(cPerg,.F.)

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. ) 	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fProcessa( oSelf )

 If nEsc == 1
    U_AMGPEM10( oSelf )
 ElseIf nEsc == 2
    U_AMGPEM20( oSelf )
 EndIf
 
Return

//----------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------- POR RATEIO ---------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMGPEM10 บ Autor ณ Adilson Silva      บ Data ณ 10/01/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carga dos Historicos de Assistencia Medica e Odontologica  บฑฑ
ฑฑบ          ณ e das co-participacoes - POR RATEIO.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AMGPEM10( oSelf )

Local dDataDe, dDataAte
Local cPdAsMed, cCoAsMed
Local cPdAsOdo, cCoAsOdo
Local cPdCopAm, cPdCopAo
Local cOrigem, cTPlan
Local cTipForn
Local lRatCop
Local lCopOnly
Local cPdGrava

Local aQdeMed, aQdeOdo
Local aTemp
Local nValor
Local nQdeMed, nQdeOdo
Local nSaldo
Local cChave
Local dDataMov
Local dPagto

Local cPerDe, cPerAte
Local nX, nY, nZ

Local nAsMed, nCoMed
Local nAsOdo, nCoOdo

Pergunte(cPerg,.F.)
 dDataDe  := mv_par01
 dDataAte := mv_par02
 cPdAsMed := Alltrim(mv_par03) + Alltrim(mv_par04)
 cCoAsMed := Alltrim(mv_par05) + Alltrim(mv_par06)
 cPdAsOdo := Alltrim(mv_par07) + Alltrim(mv_par08)
 cCoAsOdo := Alltrim(mv_par09) + Alltrim(mv_par10)
 lRatCop  := mv_par11 == 1
 lCopOnly := mv_par12 == 1
 cPdCopAm := mv_par13
 cPdCopAo := mv_par14

cPdAsMed := Transform( cPdAsMed,"@R " + Replicate("!!!-",Len( cPdAsMed )/3) )
cCoAsMed := Transform( cCoAsMed,"@R " + Replicate("!!!-",Len( cCoAsMed )/3) )
cPdAsOdo := Transform( cPdAsOdo,"@R " + Replicate("!!!-",Len( cPdAsOdo )/3) )
cCoAsOdo := Transform( cCoAsOdo,"@R " + Replicate("!!!-",Len( cCoAsOdo )/3) )

SRD->(dbSetOrder( 1 ))
RHK->(dbSetOrder( 1 ))		// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
RHL->(dbSetOrder( 1 ))		// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
RHM->(dbSetOrder( 1 ))		// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO

dbSelectArea( "SRA" )
dbSetOrder( 1 )
dbGoTop()
oSelf:SetRegua1( RecCount() )

Do While !Eof()
   oSelf:IncRegua1( SRA->(RA_FILIAL + "-" + RA_MAT + "-" + RA_NOME) )

   If oSelf:lEnd 
      Break
   EndIf
   
   cPerDe  := if( mesano(SRA->RA_ADMISSA)>MesAno(dDataDe),mesano(SRA->RA_ADMISSA),MesAno(dDataDe) )
   cPerAte := MesAno( dDataAte )
   
   Do While cPerDe <= cPerAte
      nAsMed  := 0  ; nCoMed  := 0
      nAsOdo  := 0  ; nCoOdo  := 0
      aQdeMed := {} ; aQdeOdo := {}
      
      // Busca a Quantidade de Beneficiarios dos Planos
      fBscBenef( cPerDe, @aQdeMed, @aQdeOdo )

      dbSelectArea( "SRD" )
      dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerDe )
      Do While !Eof() .And. SRD->(RD_FILIAL + RD_MAT + RD_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cPerDe
         
		 If dtos(SRD->RD_DATPGT) < (left(cPerAte,4)+'0101') .or. dtos(SRD->RD_DATPGT) > (left(cPerAte,4)+'1231')
		 	dbskip()
		 	Loop
		 Endif
         If SRD->RD_PD $ cPdAsMed
            nAsMed += SRD->RD_VALOR
            dPagto := SRD->RD_DATPGT
         ElseIf SRD->RD_PD $ cCoAsMed
            nCoMed += SRD->RD_VALOR 
            dPagto := SRD->RD_DATPGT
         ElseIf SRD->RD_PD $ cPdAsOdo
            nAsOdo += SRD->RD_VALOR 
            dPagto := SRD->RD_DATPGT
         ElseIf SRD->RD_PD $ cCoAsOdo
            nCoOdo += SRD->RD_VALOR
            dPagto := SRD->RD_DATPGT
         EndIf
                  
         dbSkip()
      EndDo
      // Compor as Regras de Cadastro dos Planos
      nQdeMed := Len( aQdeMed )
      nQdeOdo := Len( aQdeOdo )
      
      // Assistencia Medica
      If !lCopOnly .And. nAsMed > 0 .And. nQdeMed > 0
         nValor  := Round(nAsMed / nQdeMed,2)
         For nX := 1 To Len( aQdeMed )
             If nX == Len( aQdeMed )
                aQdeMed[nX,08] := nAsMed
             Else
                aQdeMed[nX,08] := nValor
                nAsMed -= nValor
             EndIf
             aQdeMed[nX,10] := dPagto
         Next nX
      EndIf
      // Co-part Assistencia Medica
      If nCoMed > 0 .And. nQdeMed > 0
         If lRatCop
            nValor  := Round(nCoMed / nQdeMed,2)
            For nX := 1 To Len( aQdeMed )
                If nX == Len( aQdeMed )
                   aQdeMed[nX,09] := nCoMed
                Else
                   aQdeMed[nX,09] := nValor
                   nCoMed -= nValor
                EndIf
                aQdeMed[nX,10] := dPagto
            Next nX
         Else
            If ( nPos := Ascan(aQdeMed,{|x| x[5]=="  "}) ) > 0
               aQdeMed[nPos,09] := nCoMed
               aQdeMed[nPos,10] := dPagto
            EndIf
         EndIf
      EndIf
      // Assistencia Odontologica
      If !lCopOnly .And. nAsOdo > 0 .And. nQdeOdo > 0
         nValor  := Round(nAsOdo / nQdeOdo,2)
         For nX := 1 To Len( aQdeOdo )
             If nX == Len( aQdeOdo )
                aQdeOdo[nX,08] := nAsOdo
             Else
                aQdeOdo[nX,08] := nValor
                nAsOdo -= nValor
             EndIf
             aQdeOdo[nX,10] := dPagto
         Next nX
      EndIf
      // Co-part Assistencia Odontologica
      If nCoOdo > 0 .And. nQdeOdo > 0
         If lRatCop
            nValor  := Round(nCoOdo / nQdeOdo,2)
            For nX := 1 To Len( aQdeOdo )
                If nX == Len( aQdeOdo )
                   aQdeOdo[nX,09] := nCoOdo
                Else
                   aQdeOdo[nX,09] := nValor
                   nCoOdo -= nValor
                EndIf
                aQdeOdo[nX,10] := dPagto
            Next nX
         Else
            If ( nPos := Ascan(aQdeOdo,{|x| x[5]=="  "}) ) > 0
               aQdeOdo[nPos,09] := nCoOdo
               aQdeOdo[nPos,10] := dPagto
            EndIf
         EndIf
      EndIf

      // Gravar o Historico RHS
      dbSelectArea( "RHS" )		// RHS_FILIAL+RHS_MAT+RHS_COMPPG+RHS_ORIGEM+RHS_CODIGO+RHS_TPLAN+RHS_TPFORN+RHS_CODFOR+RHS_TPPLAN+RHS_PLANO+RHS_PD
      For nZ := 1 To 2
          If nZ == 1
             aTemp := Aclone( aQdeMed )
          Else
             aTemp := Aclone( aQdeOdo )
          EndIf
          cTipForn := Str(nZ,1)
          
          For nX := 1 To Len( aTemp )
              If aTemp[nX,06] == "RHK"
                 cOrigem := "1"
              ElseIf aTemp[nX,06] == "RHL"
                 cOrigem := "2"
              ElseIf aTemp[nX,06] == "RHM"
                 cOrigem := "3"
              EndIf
          
              dDataMov := Stod( cPerDe + "28" )
              For nY := 1 To 2
                  nValor   := 0
                  cPdGrava := ""
                  If nZ == 1 .And. nY == 1 .And. aTemp[nX,08] > 0		// Assistencia Medica
                     nValor   := aTemp[nX,08]
                     cTPlan   := "1"
                     cPdGrava := aTemp[nX,03]
                  ElseIf nZ == 1 .And. nY == 2 .And. aTemp[nX,09] > 0	// Assistencia Medica - Co-Participacao
                     nValor   := aTemp[nX,09]
                     cTPlan   := "2"
                     cPdGrava := cPdCopAm
                  ElseIf nZ == 2 .And. nY == 1 .And. aTemp[nX,08] > 0	// Assistencia Odontologica
                     nValor   := aTemp[nX,08]
                     cTPlan   := "1"
                     cPdGrava := aTemp[nX,03]
                  ElseIf nZ == 2 .And. nY == 2 .And. aTemp[nX,09] > 0	// Assistencia Odontologica - Co-Participacao
                     nValor   := aTemp[nX,09]
                     cTPlan   := "2"
                     cPdGrava := cPdCopAo
                  EndIf
          
                  If nValor > 0 .And. !Empty( cPdGrava )
                     // Compoe a Chave de Pesquisa
                     cChave := SRA->RA_FILIAL		// RHS_FILIAL
                     cChave += SRA->RA_MAT			// RHS_MAT
                     cChave += cPerDe				// RHS_COMPPG
                     cChave += cOrigem				// RHS_ORIGEM
                     cChave += aTemp[nX,05]	   		// RHS_CODIGO
                     cChave += cTPlan				// RHS_TPLAN
                     cChave += cTipForn		  		// RHS_TPFORN
                     cChave += aTemp[nX,01]	   		// RHS_CODFOR
                     cChave += aTemp[nX,04]	   		// RHS_TPPLAN
                     cChave += aTemp[nX,02]	   		// RHS_PLANO
                     cChave += cPdGrava	 	  		// RHS_PD

                     If dbSeek( cChave )
                        RecLock("RHS",.F.)
                     Else
                        RecLock("RHS",.T.)
                     EndIf
                      RHS->RHS_FILIAL := SRA->RA_FILIAL
                      RHS->RHS_MAT    := SRA->RA_MAT
                      RHS->RHS_DATA   := dDataMov
                      RHS->RHS_ORIGEM := cOrigem				// 1=Titular        - 2=Dependente          - 3=Agregado
                      RHS->RHS_CODIGO := aTemp[nX,05]
                      RHS->RHS_TPLAN  := cTPlan			 		// 1=Plano          - 2=Co-participacao     - 3=Reembolso
                      RHS->RHS_TPFORN := cTipForn				// 1=Assist Medica  - 2=Assist Odontologica
                      RHS->RHS_CODFOR := aTemp[nX,01]
                      RHS->RHS_TPPLAN := aTemp[nX,04]	  		// 1=Faixa Salarial -  2=Faixa Etaria       - 3=Valor Fixo -  4=% sobre Salario
                      RHS->RHS_PLANO  := aTemp[nX,02]
                      RHS->RHS_PD     := cPdGrava
                      RHS->RHS_VLRFUN := nValor
                      RHS->RHS_VLREMP := 0
                      RHS->RHS_COMPPG := cPerDe
                      RHS->RHS_DATPGT := aTemp[nX,10]
                     MsUnlock()
                  EndIf
              Next nY
          Next nX
      Next nZ

      U_fSmaMesAno( @cPerDe )
   EndDo

   dbSelectArea( "SRA" )
   dbSkip()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMGPEM01  บAutor  ณMicrosiga           บ Data ณ  01/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fBscBenef( cPeriodo, aQdeMed, aQdeOdo )

 Local cPdAm  := "@@"
 Local cPdAmA := "@@"
 Local cPdAo  := "@@"
 Local cPdAoA := "@@"
 Local nPos   := 0

 // Busca o Titular
 dbSelectArea( "RHK" )		// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
 dbSeek( SRA->(RA_FILIAL + RA_MAT) )
 Do While !Eof() .And. RHK->(RHK_FILIAL + RHK_MAT) == SRA->(RA_FILIAL + RA_MAT)
    //If cPeriodo < Right(RHK->RHK_PERINI,4)+Left(RHK->RHK_PERINI,2) .Or. ( !Empty(RHK->RHK_PERFIM) .And. cPeriodo > Right(RHK->RHK_PERFIM,4)+Left(RHK->RHK_PERFIM,2) )
    //   dbSkip()
    //   Loop
    //EndIf
 
    If RHK->RHK_TPFORN == "1"			// 1=Assist Medica
       cPdAm  := RHK->RHK_PD
       cPdAmA := RHK->RHK_PDDAGR
       Aadd(aQdeMed,{RHK->RHK_CODFOR, 		;	// 01 - Codigo do Fornecedor
                     RHK->RHK_PLANO,		;	// 02 - Codigo do Plano
                     RHK->RHK_PD,			;	// 03 - Codigo da Verba
                     RHK->RHK_TPPLAN,		;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                     "  ",					;	// 05 - Sequencia do Dependente - 00=Titular
                     "RHK",					;	// 06 - Tabela
                     RHK->(Recno()),		;	// 07 - Recno
                     0,						;	// 08 - Valor da Assistencia Medica
                     0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                     Ctod( "" )}			)	// 10 - Data do Pagamento
    ElseIf RHK->RHK_TPFORN == "2"		// 2=Assist Odontologica
       cPdAo  := RHK->RHK_PD
       cPdAoA := RHK->RHK_PDDAGR
       Aadd(aQdeOdo,{RHK->RHK_CODFOR, 		;	// 01 - Codigo do Fornecedor
                     RHK->RHK_PLANO,		;	// 02 - Codigo do Plano
                     RHK->RHK_PD,			;	// 03 - Codigo da Verba
                     RHK->RHK_TPPLAN,		;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                     "  ",					;	// 05 - Sequencia do Dependente - 00=Titular
                     "RHK",					;	// 06 - Tabela
                     RHK->(Recno()),		;	// 07 - Recno
                     0,						;	// 08 - Valor da Assistencia Odontologica
                     0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                     Ctod( "" )}			)	// 10 - Data do Pagamento
    EndIf
    
    dbSkip()
 EndDo
 
 // Busca os Dependentes
 If cPdAm <> "@@"
    dbSelectArea( "RHL" )		// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
    dbSeek( SRA->(RA_FILIAL + RA_MAT) )
    Do While !Eof() .And. RHL->(RHL_FILIAL + RHL_MAT) == SRA->(RA_FILIAL + RA_MAT)
       //If cPeriodo < Right(RHL->RHL_PERINI,4)+Left(RHL->RHL_PERINI,2) .Or. ( !Empty(RHL->RHL_PERFIM) .And. cPeriodo > Right(RHL->RHL_PERFIM,4)+Left(RHL->RHL_PERFIM,2) )
       //   dbSkip()
       //   Loop
       //EndIf
 
       If RHL->RHL_TPFORN == "1"			// 1=Assist Medica
          Aadd(aQdeMed,{RHL->RHL_CODFOR, 		;	// 01 - Codigo do Fornecedor
                        RHL->RHL_PLANO,			;	// 02 - Codigo do Plano
                        cPdAm,					;	// 03 - Codigo da Verba
                        RHL->RHL_TPPLAN,	   	;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                        RHL->RHL_CODIGO,		;	// 05 - Sequencia do Dependente - 00=Titular
                        "RHL",					;	// 06 - Tabela
                        RHL->(Recno()),			;	// 07 - Recno
                        0,						;	// 08 - Valor da Assistencia Medica
                        0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                        Ctod( "" )}				)	// 10 - Data do Pagamento
       ElseIf RHL->RHL_TPFORN == "2"		// 2=Assist Odontologica
          Aadd(aQdeOdo,{RHL->RHL_CODFOR, 		;	// 01 - Codigo do Fornecedor
                        RHL->RHL_PLANO,			;	// 02 - Codigo do Plano
                        cPdAo,					;	// 03 - Codigo da Verba
                        RHL->RHL_TPPLAN,	   	;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                        RHL->RHL_CODIGO,		;	// 05 - Sequencia do Dependente - 00=Titular
                        "RHL",					;	// 06 - Tabela
                        RHL->(Recno()),			;	// 07 - Recno
                        0,						;	// 08 - Valor da Assistencia Medica
                        0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                        Ctod( "" )}				)	// 10 - Data do Pagamento
       EndIf
    
       dbSkip()
    EndDo
 EndIf
 
 // Busca os Agregados
 If cPdAo <> "@@"
    dbSelectArea( "RHM" )		// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
    dbSeek( SRA->(RA_FILIAL + RA_MAT) )
    Do While !Eof() .And. RHM->(RHM_FILIAL + RHM_MAT) == SRA->(RA_FILIAL + RA_MAT)
       //If cPeriodo < Right(RHM->RHM_PERINI,4)+Left(RHM->RHM_PERINI,2) .Or. ( !Empty(RHM->RHM_PERFIM) .And. cPeriodo > Right(RHM->RHM_PERFIM,4)+Left(RHM->RHM_PERFIM,2) )
       //   dbSkip()
       //   Loop
       //EndIf
 
       If RHM->RHM_TPFORN == "1"			// 1=Assist Medica
          Aadd(aQdeMed,{RHM->RHM_CODFOR, 		;	// 01 - Codigo do Fornecedor
                        RHM->RHM_PLANO,			;	// 02 - Codigo do Plano
                        cPdAo,					;	// 03 - Codigo da Verba
                        RHM->RHM_TPPLAN,	   	;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                        RHM->RHM_CODIGO,		;	// 05 - Sequencia do Dependente - 00=Titular
                        "RHM",					;	// 06 - Tabela
                        RHM->(Recno()),			;	// 07 - Recno
                        0,						;	// 08 - Valor da Assistencia Medica
                        0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                        Ctod( "" )}				)	// 10 - Data do Pagamento
       ElseIf RHM->RHM_TPFORN == "2"		// 2=Assist Odontologica
          Aadd(aQdeOdo,{RHM->RHM_CODFOR, 		;	// 01 - Codigo do Fornecedor
                        RHM->RHM_PLANO,			;	// 02 - Codigo do Plano
                        cPdAo,					;	// 03 - Codigo da Verba
                        RHM->RHM_TPPLAN,	   	;	// 04 - Tipo do Plano - 1=Faixa Salarial - 2=Faixa Etaria - 3=Valor Fixo - 4=% sobre Salario
                        RHM->RHM_CODIGO,		;	// 05 - Sequencia do Dependente - 00=Titular
                        "RHM",					;	// 06 - Tabela
                        RHM->(Recno()),			;	// 07 - Recno
                        0,						;	// 08 - Valor da Assistencia Odontologica
                        0,						;	// 09 - Valor da Co-Participacao da Assistencia Medica
                        Ctod( "" )}				)	// 10 - Data do Pagamento
       EndIf
    
       dbSkip()
    EndDo
 EndIf
 
Return

//----------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------- POR DEPENDENTE ---------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMGPEM10 บ Autor ณ Adilson Silva      บ Data ณ 10/01/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carga dos Historicos de Assistencia Medica e Odontologica  บฑฑ
ฑฑบ          ณ e das co-participacoes - POR RATEIO.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AMGPEM20( oSelf )

Local dDataDe, dDataAte
Local nX, nZ, nY

Local lProcessa
Local cPdMed, cPdOdo
Local aTit, aDep, aCop
Local aTemp
Local nValor
Local cTipForn

Local cOrigem
Local cCodigo
Local cCodFor
Local cTpPlan
Local cTPlan
Local cPlano
Local cVerba

Pergunte(cPerg,.F.)
 dDataDe  := mv_par01
 dDataAte := mv_par02
 cPdOdo   := mv_par03

SRB->(dbSetOrder( 1 ))
SRD->(dbSetOrder( 1 ))   	// RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
RHK->(dbSetOrder( 1 ))		// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
RHL->(dbSetOrder( 1 ))		// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
RHM->(dbSetOrder( 1 ))		// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO

fBscPd( @cPdMed )

dbSelectArea( "SRA" )
dbSetOrder( 1 )
dbGoTop()
//dbSeek( "01004789" )
oSelf:SetRegua1( RecCount() )

Do While !Eof() 		//.And. SRA->(RA_FILIAL + RA_MAT) == "01004789"
   oSelf:IncRegua1( SRA->(RA_FILIAL + "-" + RA_MAT + "-" + RA_NOME) )

   If oSelf:lEnd 
      Break
   EndIf
   
   aTit := {{"  ", cPdMed, 0, cPdOdo, 0, "", Ctod( "" )}}
   aDep := {}
   dbSelectArea( "SRB" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) )
   Do While !Eof() .And. SRB->(RB_FILIAL + RB_MAT) == SRA->(RA_FILIAL + RA_MAT)
      // Dependentes com Assistencia Medica e/ou Odontologica
      Aadd(aDep,{SRB->RB_COD,			;	// 01 - Codigo da Sequencia
                 SRB->RB_VBDESAM,		;	// 02 - Verba de Desconto da Assistencia Medica
                 0,				  		;	// 03 - Valor do Desconto da Assistencia Medica
                 SRB->RB_VBDESAO,		;	// 04 - Verba de Desconto da Assistencia Odontologica
                 0,                     ;	// 05 - Valor do Desconto da Assistencia Odontologica
                 "1",					;	// 06 - Tipo 1=Plano - 2=Co-Participacao
                 Ctod( "" )}	  		)	// 07 - Data de Pagamento
      
      dbSkip()
   EndDo

   cPerDe  := MesAno( dDataDe )
   cPerAte := MesAno( dDataAte )

   Do While cPerDe <= cPerAte
      dDataMov := Stod( cPerDe + "28" )
         
      Aeval(aTit,{|x| x[3] := 0, x[5] := 0})
      If Len( aDep ) > 0
         Aeval(aDep,{|x| x[3] := 0, x[5] := 0})
      EndIf
         
      // Busca o Desconto da Assistencia Medica do Titular 
      If SRD->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerDe + aTit[1,02] ))
         aTit[1,03] := SRD->RD_VALOR
         aTit[1,07] := SRD->RD_DATPGT
      EndIf
      // Busca o Desconto da Assistencia Odontologica do Titular 
      If SRD->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerDe + aTit[1,04] ))
         aTit[1,05] := SRD->RD_VALOR
         aTit[1,07] := SRD->RD_DATPGT
      EndIf

      // Busca os Valores dos Dependentes do SRD
      If Len( aDep ) > 0
         For nX := 1 To Len( aDep )
             // Busca o Desconto da Assistencia Medica
             If SRD->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerDe + aDep[nX,02] ))
                aDep[nX,03] := SRD->RD_VALOR
                aDep[nX,07] := SRD->RD_DATPGT
             EndIf
             // Busca o Desconto da Assistencia Odontologica
             If SRD->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerDe + aDep[nX,04] ))
                aDep[nX,05] := SRD->RD_VALOR
                aDep[nX,07] := SRD->RD_DATPGT
             EndIf
         Next nX
      EndIf
         
      // Grava os Historicos do Titular- RHS
      For nZ := 1 To 2
          If nZ == 1
             aTemp := Aclone( aTit )
          Else
             aTemp := Aclone( aDep )
          EndIf

          For nX := 1 To Len( aTemp )
              lProcessa := .F. 
    
              If nZ == 1		// Titular
                 dbSelectArea( "RHK" )	// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
                 dbSeek( SRA->(RA_FILIAL + RA_MAT) )
                 Do While !Eof() .And. RHK->(RHK_FILIAL + RHK_MAT) == SRA->(RA_FILIAL + RA_MAT)
                    //If cPerDe < Right(RHK->RHK_PERINI,4)+Left(RHK->RHK_PERINI,2) .Or. ( !Empty(RHK->RHK_PERFIM) .And. cPerDe > Right(RHK->RHK_PERFIM,4)+Left(RHK->RHK_PERFIM,2) )
                    //   dbSkip()
                    //   Loop
                    //EndIf
                       
                    cCodFor := RHK->RHK_CODFOR
                    cTpPlan := RHK->RHK_TPPLAN
                    cPlano  := RHK->RHK_PLANO
                    cOrigem := "1"
                    lProcessa := .T.
                    Exit
                 EndDo
              Else
                 dbSelectArea( "RHL" )	// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
                 dbSeek( SRA->(RA_FILIAL + RA_MAT) )
                 Do While !Eof() .And. RHL->(RHL_FILIAL + RHL_MAT) == SRA->(RA_FILIAL + RA_MAT)
                    //If cPerDe < Right(RHL->RHL_PERINI,4)+Left(RHL->RHL_PERINI,2) .Or. ( !Empty(RHL->RHL_PERFIM) .And. cPerDe > Right(RHL->RHL_PERFIM,4)+Left(RHL->RHL_PERFIM,2) )
                    //   dbSkip()
                    //   Loop
                    //EndIf
                       
                    If RHL->RHL_CODIGO == aTemp[nX,1]
                       cCodFor := RHL->RHL_CODFOR
                       cTpPlan := RHL->RHL_TPPLAN
                       cPlano  := RHL->RHL_PLANO
                       cOrigem := "2"
                       lProcessa := .T.
                       Exit
                    EndIf
                    dbSkip()
                 EndDo
                 If !lProcessa
                    dbSelectArea( "RHM" )	// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
                    dbSeek( SRA->(RA_FILIAL + RA_MAT) )
                    Do While !Eof() .And. RHM->(RHM_FILIAL + RHM_MAT) == SRA->(RA_FILIAL + RA_MAT)
                       //If cPerDe < Right(RHM->RHM_PERINI,4)+Left(RHM->RHM_PERINI,2) .Or. ( !Empty(RHM->RHM_PERFIM) .And. cPerDe > Right(RHM->RHM_PERFIM,4)+Left(RHM->RHM_PERFIM,2) )
                       //   dbSkip()
                       //   Loop
                       //EndIf
                         
                       cCodFor := RHM->RHM_CODFOR
                       cTpPlan := RHM->RHM_TPPLAN
                       cPlano  := RHM->RHM_PLANO
                       cOrigem := "3"
                       lProcessa := .T.
                       Exit
                    EndDo
                 EndIf
              EndIf
              If !lProcessa
                 Loop
              EndIf
                 
              cCodigo := aTemp[nX,1]

              For nY := 1 To 2
                  If nY == 1
                     cVerba   := aTemp[nX,2]
                     nValor   := aTemp[nX,3]
                     cTipForn := "1"
                  Else
                     cVerba   := aTemp[nX,4]
                     nValor   := aTemp[nX,5]
                     cTipForn := "2"
                  EndIf
                  cTPlan := "1"

                  If nValor > 0
                     // Compoe a Chave de Pesquisa
                     cChave := SRA->RA_FILIAL		// RHS_FILIAL
                     cChave += SRA->RA_MAT			// RHS_MAT
                     cChave += cPerDe				// RHS_COMPPG
                     cChave += cOrigem				// RHS_ORIGEM
                     cChave += cCodigo 		  		// RHS_CODIGO
                     cChave += cTPlan				// RHS_TPLAN
                     cChave += cTipForn		  		// RHS_TPFORN
                     cChave += cCodFor	   			// RHS_CODFOR
                     cChave += cTpPlan	 	  		// RHS_TPPLAN
                     cChave += cPlano  		 		// RHS_PLANO
                     cChave += cVerba	 	  		// RHS_PD

                     dbSelectArea( "RHS" )
                     If dbSeek( cChave )
                        RecLock("RHS",.F.)
                     Else
                        RecLock("RHS",.T.)
                     EndIf
                      RHS->RHS_FILIAL := SRA->RA_FILIAL
                      RHS->RHS_MAT    := SRA->RA_MAT
                      RHS->RHS_DATA   := dDataMov
                      RHS->RHS_ORIGEM := cOrigem			 		// 1=Titular        - 2=Dependente          - 3=Agregado
                      RHS->RHS_CODIGO := cCodigo              	
                      RHS->RHS_TPLAN  := cTPlan			 	   		// 1=Plano          - 2=Co-participacao     - 3=Reembolso
                      RHS->RHS_TPFORN := cTipForn			  		// 1=Assist Medica  - 2=Assist Odontologica
                      RHS->RHS_CODFOR := cCodFor
                      RHS->RHS_TPPLAN := cTpPlan			  		// 1=Faixa Salarial -  2=Faixa Etaria       - 3=Valor Fixo -  4=% sobre Salario
                      RHS->RHS_PLANO  := cPlano
                      RHS->RHS_PD     := cVerba
                      RHS->RHS_VLRFUN := nValor
                      RHS->RHS_VLREMP := 0
                      RHS->RHS_COMPPG := cPerDe
                      RHS->RHS_DATPGT := aTemp[nX,07]
                     MsUnlock()
                  EndIf
              Next nY
          Next nX
      Next nZ

      U_fSmaMesAno( @cPerDe )
   EndDo
   
   dbSelectArea( "SRA" )
   dbSkip()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMGPEM01  บAutor  ณMicrosiga           บ Data ณ  01/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fBscPd( cPdMed )

 Local aOldAtu := GETAREA()
 
 cPdMed := ""
 
 dbSelectArea( "SRV" )
 dbSetOrder( 2 )
 // Verba do Titular para Assistencia Medica
 If dbSeek( xFilial("SRV") + "049" )
    cPdMed := SRV->RV_COD
 EndIf   
 
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTimeToEndบAutor  ณ Adilson Silva      บ Data ณ 23/06/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Projeta Tempo Restante no Processamento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDelSx1( __cPerg, __cOrdem )

 Local aOldAtu := GETAREA()
 Local aOldSx1 := SX1->( GETAREA() )

 __cPerg := PadR( __cPerg,Len( SX1->X1_GRUPO ) )

 dbSelectArea( "SX1" )
 dbSetOrder( 1 )
 dbSeek( __cPerg + __cOrdem )
 Do While !Eof() .And. SX1->X1_GRUPO == __cPerg
    RecLock("SX1",.F.)
     dbDelete()
    MsUnlock()
    
    dbSkip()
 EndDo

 RESTAREA( aOldSx1 )
 RESTAREA( aOldAtu )

Return

//----------------------------------------------------------------------------------------------------------------------------------
//------------------------------------ CARGA DOS PLANOS PARA MATRICULAS TRANSFERIDAS -----------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AMGPEM30 บ Autor ณ Adilson Silva      บ Data ณ 15/02/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Carga dos Cadastros dos Planos de Saude para Matriculas    บฑฑ
ฑฑบ          ณ Transferidas.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AMGPEM30( oSelf )
 Processa({|| RunCont() },"Processando...")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMGPEM01  บAutor  ณMicrosiga           บ Data ณ  02/15/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function RunCont

 Local nTotReg := 0
 Local aRhk    := {}
 Local aRhl    := {}
 Local aRhm    := {}
 Local cQuery
 Local nX
 
 If Aviso("ATENCAO","Confirma manuten็ใo dos benefํcios de funcionแrios transferidos?",{"Continuar","Sair"}) == 2
    Return
 EndIf
 
 RHK->(dbSetOrder( 1 ))		// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
 RHL->(dbSetOrder( 1 ))		// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
 RHM->(dbSetOrder( 1 ))		// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
 
 cQuery := " SELECT SRA.R_E_C_N_O_ AS RA_RECNO"
 cQuery += " FROM " + RetSqlName( "SRA" )  + " SRA"
 cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.RA_RESCRAI IN ('30','31')"
// cQuery += "   AND SRA.RA_MAT = '007529'"
 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "SRA1"
 TcSetField( "SRA1" , "RA_RECNO" , "N", 10, 0 )
 Count To nTotReg

 dbSelectArea( "SRA1" )
 dbGoTop()
 ProcRegua( nTotReg )
 Do While !Eof()
    SRA->(dbGoTo( SRA1->RA_RECNO ))
    IncProc( SRA->(RA_FILIAL + "-" + RA_MAT + "-" + RA_NOME) )

    cQuery := " SELECT SRA.RA_FILIAL, SRA.RA_MAT"
    cQuery += " FROM " + RetSqlName( "SRA" )  + " SRA"
    cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
    cQuery += "   AND SRA.RA_RESCRAI NOT IN ('30','31')"
    cQuery += "   AND SRA.RA_MAT = '" + SRA->RA_MAT + "'"
    TCQuery cQuery New Alias "SRA2"

    // Processa RHK
    dbSelectArea( "RHK" )	// RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
    dbSeek( SRA2->(RA_FILIAL + RA_MAT) )
    aRhk := {}
    Do While !Eof() .And. RHK->(RHK_FILIAL + RHK_MAT) == SRA2->(RA_FILIAL + RA_MAT)
       Aadd(aRhk,{ RHK->RHK_FILIAL,  ; 		// 01
                   RHK->RHK_MAT,     ; 		// 02
                   RHK->RHK_TPFORN,  ; 		// 03
                   RHK->RHK_CODFOR,  ; 		// 04
                   RHK->RHK_TPPLAN,  ; 		// 05
                   RHK->RHK_PLANO ,  ; 		// 06
                   RHK->RHK_PD    ,  ; 		// 07
                   RHK->RHK_PDDAGR,  ; 		// 08
                   RHK->RHK_PERINI,  ; 		// 09
                   RHK->RHK_PERFIM}  )		// 10
       dbSkip()
    EndDo
    
    For nX := 1 To Len( aRhk )
        If dbSeek( SRA->(RA_FILIAL + RA_MAT) + aRhk[nX,03] + aRhk[nX,04] )
           RecLock("RHK",.F.)
        Else
           RecLock("RHK",.T.)
        EndIf
         RHK->RHK_FILIAL := SRA->RA_FILIAL
         RHK->RHK_MAT    := SRA->RA_MAT
         RHK->RHK_TPFORN := aRhk[nX,03]
         RHK->RHK_CODFOR := aRhk[nX,04]
         RHK->RHK_TPPLAN := aRhk[nX,05]
         RHK->RHK_PLANO  := aRhk[nX,06]
         RHK->RHK_PD     := aRhk[nX,07]
         RHK->RHK_PDDAGR := aRhk[nX,08]
         RHK->RHK_PERINI := aRhk[nX,09]
         RHK->RHK_PERFIM := aRhk[nX,10]
        MsUnlock()
    Next nX

    // Processa RHL
    dbSelectArea( "RHL" )	// RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
    dbSeek( SRA2->(RA_FILIAL + RA_MAT) )
    aRhl := {}
    Do While !Eof() .And. RHL->(RHL_FILIAL + RHL_MAT) == SRA2->(RA_FILIAL + RA_MAT)
       Aadd(aRhl,{ RHL->RHL_FILIAL,  ; 		// 01
                   RHL->RHL_MAT,     ; 		// 02
                   RHL->RHL_TPFORN,  ; 		// 03
                   RHL->RHL_CODFOR,  ; 		// 04
                   RHL->RHL_CODIGO,  ;		// 05
                   RHL->RHL_TPPLAN,  ; 		// 06
                   RHL->RHL_PLANO ,  ; 		// 07
                   RHL->RHL_PERINI,  ; 		// 08
                   RHL->RHL_PERFIM}  )		// 09
       dbSkip()
    EndDo
    
    For nX := 1 To Len( aRhl )
        If dbSeek( SRA->(RA_FILIAL + RA_MAT) + aRhl[nX,03] + aRhl[nX,04] + aRhl[nX,05] )
           RecLock("RHL",.F.)
        Else
           RecLock("RHL",.T.)
        EndIf
         RHL->RHL_FILIAL := SRA->RA_FILIAL
         RHL->RHL_MAT    := SRA->RA_MAT
         RHL->RHL_TPFORN := aRhl[nX,03]
         RHL->RHL_CODFOR := aRhl[nX,04]
         RHL->RHL_CODIGO := aRhl[nX,05]
         RHL->RHL_TPPLAN := aRhl[nX,06]
         RHL->RHL_PLANO  := aRhl[nX,07]
         RHL->RHL_PERINI := aRhl[nX,08]
         RHL->RHL_PERFIM := aRhl[nX,09]
        MsUnlock()
    Next nX

    // Processa RHM
    dbSelectArea( "RHM" )	// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
    dbSeek( SRA2->(RA_FILIAL + RA_MAT) )
    aRhm := {}
    Do While !Eof() .And. RHM->(RHM_FILIAL + RHM_MAT) == SRA2->(RA_FILIAL + RA_MAT)
       Aadd(aRhm,{ RHM->RHM_FILIAL,  ; 		// 01
                   RHM->RHM_MAT,     ; 		// 02
                   RHM->RHM_TPFORN,  ; 		// 03
                   RHM->RHM_CODFOR,  ; 		// 04
                   RHM->RHM_CODIGO,  ;		// 05
                   RHM->RHM_NOME,    ;		// 06
                   RHM->RHM_DTNASC,  ; 		// 07
                   RHM->RHM_CPF,     ; 		// 08
                   RHM->RHM_TPPLAN,  ; 		// 09
                   RHM->RHM_PLANO ,  ; 		// 10
                   RHM->RHM_PERINI,  ; 		// 11
                   RHM->RHM_PERFIM}  )		// 12
       dbSkip()
    EndDo
    
    For nX := 1 To Len( aRhm )
        If dbSeek( SRA->(RA_FILIAL + RA_MAT) + aRhm[nX,03] + aRhm[nX,04] + aRhm[nX,05] )
           RecLock("RHM",.F.)
        Else
           RecLock("RHM",.T.)
        EndIf
         RHM->RHM_FILIAL := SRA->RA_FILIAL
         RHM->RHM_MAT    := SRA->RA_MAT
         RHM->RHM_TPFORN := aRhm[nX,03]
         RHM->RHM_CODFOR := aRhm[nX,04]
         RHM->RHM_CODIGO := aRhm[nX,05]
         RHM->RHM_NOME   := aRhm[nX,06]
         RHM->RHM_DTNASC := aRhm[nX,07]
         RHM->RHM_CPF    := aRhm[nX,08]
         RHM->RHM_TPPLAN := aRhm[nX,09]
         RHM->RHM_PLANO  := aRhm[nX,10]
         RHM->RHM_PERINI := aRhm[nX,11]
         RHM->RHM_PERFIM := aRhm[nX,12]
        MsUnlock()
    Next nX
    SRA2->(dbCloseArea())
    
    dbSelectArea( "SRA1" )
    dbSkip()
 EndDo
 SRA1->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}

 If nEsc == 1
    // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
    aAdd(aRegs,{ cPerg,'01','Data De ?                    ','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'02','Data Ate ?                   ','','','mv_ch2','D',08,0,0,'G','NaoVazio   ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'03','Verbas Assist Medica  ?      ','','','mv_ch3','C',30,0,0,'G','fVerbas    ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'04','Verbas Assist Medica  ?      ','','','mv_ch4','C',30,0,0,'G','fVerbas    ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'05','Verbas Co-Part Ass Medica  ? ','','','mv_ch5','C',30,0,0,'G','fVerbas    ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'06','Verbas Co-Part Ass Medica  ? ','','','mv_ch6','C',30,0,0,'G','fVerbas    ','mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'07','Verbas Assist Odonto  ?      ','','','mv_ch7','C',30,0,0,'G','fVerbas    ','mv_par07','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'08','Verbas Assist Odonto  ?      ','','','mv_ch8','C',30,0,0,'G','fVerbas    ','mv_par08','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'09','Verbas Co-Part Ass Odonto  ? ','','','mv_ch9','C',30,0,0,'G','fVerbas    ','mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'10','Verbas Co-Part Ass Odonto  ? ','','','mv_cha','C',30,0,0,'G','fVerbas    ','mv_par10','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'11','Rateia Co-Participacao ?     ','','','mv_chb','N',01,0,0,'C','           ','mv_par11','Sim              ','','','','','Nao              ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'12','Somente Co-Participacao ?    ','','','mv_chc','N',01,0,0,'C','           ','mv_par12','Sim              ','','','','','Nao              ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'13','Verba CoPart Ass Medica ?    ','','','mv_chd','C',03,0,0,'G','           ','mv_par13','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRV   ','' })
    aAdd(aRegs,{ cPerg,'14','Verba CoPart Ass Odontolog ? ','','','mv_che','C',03,0,0,'G','           ','mv_par14','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRV   ','' })
    fDelSx1( cPerg, "15" )
 Else
    // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
    aAdd(aRegs,{ cPerg,'01','Data De ?                    ','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'02','Data Ate ?                   ','','','mv_ch2','D',08,0,0,'G','NaoVazio   ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
    aAdd(aRegs,{ cPerg,'03','Verba Assist Odontologica ?  ','','','mv_ch3','C',03,0,0,'G','NaoVazio   ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRV   ','' })
    fDelSx1( cPerg, "04" )
 EndIf

ValidPerg(aRegs,cPerg)

Return   
