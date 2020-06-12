
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DELCTRC   ºAutor  ³Microsiga           º Data ³  07/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DelCTRC()
Local cFilWrk       := cFilAnt
Local dDatBkp       := dDataBase  
Local cFilDoc       := ""
Local cDoc          := ""
Local cSerie        := ""
Local aDelDocto     := {}
Local nPosFildoc    := 0
Local nPosDoc       := 0
Local nPosSerie     := 0
Local nPosDt        := 0
Local lRet          := .F.        
Local cLotEst       := ""   
Local lEmFat        := .F.
Local cPrefix       := ""
Local cNum          := ""
Local cCliDev       := ""
Local cLojDev       := ""              
Local nValor        := 0            
Local cNumFat       := ""            
Local cTipCli       := ""         
Local cIDNWST       := ""
Local cChvcte       := ""    
Local cSeekSF3      := ""
Local cSeekSFT      := "" 
Local aArea         := {}
Local cTipMov       := "S"
Local aRecDTC       := {} 
Local nCount        := 0
Local nX            := 0
 
Private lMsErroAuto := .F.
Private lTmsCFec           := TmsCFec()  
Private aLoteNfc           := {}
 
/*
If ( nPosFildoc     := Ascan( __ACPOSINC, { |x| x[1] == 'DT6_FILDOC'      }) ) == 0 .Or. ;
   ( nPosDoc        := Ascan( __ACPOSINC, { |x| x[1] == 'DT6_DOC' }) ) == 0 .Or. ;
   ( nPosSerie      := Ascan( __ACPOSINC, { |x| x[1] == 'DT6_SERIE'       }) ) == 0 .Or. ; 
   ( nPosDt         := Ascan( __ACPOSINC, { |x| x[1] == 'DT_CANCEL'       }) ) == 0 
       Return
EndIf
 
cFildoc      := __ACPOSINC[nPosFilDoc][5]      //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
cDoc         := __ACPOSINC[nPosDoc][5]         //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
cSerie       := __ACPOSINC[nPosSerie][5]       //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
dDtCanc      := __ACPOSINC[nPosDt][5]          //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
*/
 
cFildoc      := DT6->DT6_FILDOC      //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
cDoc         := DT6->DT6_DOC         //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
cSerie       := DT6->DT6_SERIE       //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
//dDtCanc      := DT_CANCEL          //-- [05] CONTEUDO DA TABELA INERMEDIARIA OU MACRO DO CAMPO CONTEUDO 
dDtCanc		 := ctod("//")

DT6->(dbSetOrder(1))
cFilAnt := cFilDoc
 
If DT6->( dbSeek(xFilial('DT6') + cFilDoc + cDoc + cSerie) )
      DTP->(DbSetOrder(2)) //-- DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
       If !DTP->(DbSeek(xFilial("DTP") + DT6->DT6_FILORI + DT6->DT6_LOTNFC))
//             U_SetLog(@aLog,"Cancelamento Docto","Lote " + cFilAnt + '-' + DT6->DT6_LOTNFC + " do documento " + cFilDoc + "/" + cDoc + "/" + cSerie + " não localizado para cancelamento." )
       Else
 
             aDelDocto    := {}
//           aRecDTC      := RetNFC(cFildoc,cDoc,cSerie)
			 DTC->(DbSetOrder(3))
			 DTC->(dbseek(xFilial("DTC")+cFildoc+cDoc+cSerie))
			 Do While !EOF() .and. DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == cFildoc+cDoc+cSerie
			 	AADD(aRecDTC,DTC->(Recno()))
			 	DTC->(DbSkip())
			 EndDo
//           cIDNWST      := AllTrim(Str(DT6->DT6_IDNWST))
             cChvcte      := DT6->DT6_CHVCTE
             lRet         := TmsA200Mrk(aDelDocto,cFilDoc,cDoc,cSerie)
 
             If !lRet
//                    U_SetLog(@aLog,"Cancelamento Docto","Documento " + cFilDoc + "/" + cDoc + "/" + cSerie + " não foi marcado." )
             Else
                    If !Empty(DT6->DT6_NUM)
//                           U_SetLog(@aLog,"Cancelamento Docto","Documento " + cFilDoc + "/" + cDoc + "/" + cSerie + " pertence a fatura " + DT6->DT6_PREFIX + "/" + DT6->DT6_NUM + " e foi excluido." )
                           lEmFat       := .T.
                           cPrefix      := DT6->DT6_PREFIX
                           cNum         := DT6->DT6_NUM
                           cCliDev      := DT6->DT6_CLIDEV
                           cLojDev      := DT6->DT6_LOJDEV
                           nValor := DT6->DT6_VALFAT + DT6->DT6_ACRESC - DT6->DT6_DECRES
                    EndIf
                    
                    lRet := TMSA200Exc(aDelDocto,DT6->DT6_LOTNFC,.F.,.T.,@cLotEst,.F.,.F.)
                    If !lRet
//                           U_SetLog(@aLog,"Cancelamento Docto","Documento " + cFilDoc + "/" + cDoc + "/" + cSerie + " não cancelado. Pode estar fora da data, com seguro fechado, ou com algum vínculo." )
                    Else
                                       //Estorna a observacao
                           If !Empty(DT6->DT6_CODOBS)
                                  MSMM(DT6->DT6_CODOBS,,,,2,,,"DT6","DT6_CODOBS")
                           EndIf
            
                           //-- Localiza documento no livro fiscal para gravar a chave CTE
                           SF3->(DbSetOrder(5)) //-- F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
                           SFT->(DbSetOrder(3)) //-- FT_FILIAL+FT_TIPOMOV+FT_CLIEFOR+FT_LOJA+FT_SERIE+FT_NFISCAL+FT_IDENTF3
                                               
                           aArea := { SF3->(GetArea()) , SFT->(GetArea()) , GetArea() }
                           If SF3->(MsSeek(cSeekSF3 := cFilDoc + cSerie + cDoc ))
                                        
								  _cCodrSEF := alltrim(SF3->F3_CODRSEF)
								  
                                  //-- Necessario corrigir a data de cancelamento, pois ocorre inconsistencia na geração do sped pis/cofins.
                                  If Month(SF3->F3_ENTRADA) <> Month(dDtCanc)
                                        dDtCanc := LastDay(SF3->F3_ENTRADA)
                                  EndIf
                                        
                                  While SF3->(!Eof()) .And. ( SF3->(F3_FILIAL+F3_SERIE+F3_NFISCAL) == cSeekSF3)
             
                                        SFT->(MsSeek(cSeekSFT := SF3->F3_FILIAL+cTipMov+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_IDENTFT))
                                        While !SFT->(Eof()) .And. SFT->(FT_FILIAL+FT_TIPOMOV+FT_CLIEFOR+FT_LOJA+FT_SERIE+FT_NFISCAL+FT_IDENTF3) == cSeekSFT
                                               RecLock("SFT",.F.)
                                               SFT->FT_CHVNFE      := IIF(_cCodrSEF == "102", "", cChvcte) 
                                               SFT->FT_DTCANC      := dDtCanc
                                               SFT->(MsUnlock())
                                               SFT->(DbSkip())
                                        EndDo
                                                            
                                        RecLock('SF3',.F.)
                                        SF3->F3_CHVNFE := IIF(_cCodrSEF == "102", "", cChvcte) 
                                        SF3->F3_DTCANC := dDtCanc
                                        SF3->(MsUnLock())
                                        SF3->(DbSkip())
                                  EndDo
                           EndIf
                           AEval(aArea,{|x,y| RestArea(x) })
                                        
                    EndIf
                    
                    DTP->(DbSetOrder(2)) //-- DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
                    For nX := 1 To Len(aRecDTC)
                           DTC->(dbGoto(aRecDTC[nX]))
                           If DTP->(DbSeek(xFilial("DTP") + DTC->DTC_FILORI + DTC->DTC_LOTNFC)) .And. Empty(DTC->DTC_DOC)
                                  RecLock('DTP',.F.)
                                  DTP->DTP_QTDLOT := DTP->DTP_QTDLOT - 1
                                  DTP->DTP_QTDDIG := DTP->DTP_QTDDIG - 1
 
                                  If DTP->DTP_QTDLOT <= 0
                                        DTP->( DbDelete() )
                                  EndIf
 
                                  DTP->( MsUnlock() )
                           EndIf
                           
                           If Empty(DTC->DTC_DOC)
                                  RecLock('DTC',.F.)
                                  DTC->( DbDelete() )
                                  nCount++
                           EndIf
                    Next nX
 
                    If Len(aRecDTC) <> nCount
//                           U_SetLog(@aLog,"Cancelamento Docto","Quantidade de Notas (DTC) divergente no cancelamento: Documento " + cFilDoc + "/" + cDoc + "/" + cSerie  )
                    EndIf
                    
                    If lRet

                          DT6->(dbSetOrder(1))
                           If DT6->( dbSeek(xFilial('DT6') + cFilDoc + cDoc + cSerie) )
//                                 U_SetLog(@aLog,"Cancelamento Docto","Documento " + cFilDoc + "/" + cDoc + "/" + cSerie + " não cancelado. Favor Verificar." )
                           EndIf
                    EndIf
                    
             EndIf
       EndIf
EndIf
 
cFilAnt   := cFilWrk
Return
