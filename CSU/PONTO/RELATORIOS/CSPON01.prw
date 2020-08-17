#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSPON01  บ Autor ณ Isamu Kawakami     บ Data ณ  04/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo xls com informacoes dos motivos de abono por  บฑฑ
ฑฑบ          ณ Equipe                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CSPON01

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private oExcelApp
Private _cPerg       := PADR("CSPN01",LEN(SX1->X1_GRUPO))
Private oGeraXls
Private oExcelApp

dbSelectArea("SRA")
dbSetOrder(1)

ValidPerg(_cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 380,400 DIALOG oGeraXls TITLE OemToAnsi("Arquivo Excel - Motivos de Abonos")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo no Excel conforme os parametros "
@ 18,018 Say " definidos  pelo  usuario, com informacoes de Motivos de Abonos.    "

@ 60,098 BMPBUTTON TYPE 01 ACTION OkGeraXls()
@ 60,128 BMPBUTTON TYPE 02 ACTION( &( cVldExcel ), oGeraXls:End() )
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog oGeraXls Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERAXLSบ Autor ณ AP5 IDE            บ Data ณ  13/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo XLS.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OkGeraXls

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| RunCont() },"Processando...Aguarde !!! ")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  13/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunCont

Local cPonMes     := Subs(GetMv("MV_PONMES"),1,8)
Local aCampos := {}

If Mv_Par01 == 1 //analitico
	AADD(aCampos,{"FILIAL"      ,"C", 002,0})
	AADD(aCampos,{"MATRICULA"   ,"C", 006,0})
	AADD(aCampos,{"NOME"        ,"C", 030,0})
	AADD(aCampos,{"COD_CC"      ,"C", 020,0})
	AADD(aCampos,{"DESC_CC"     ,"C", 025,0})
	AADD(aCampos,{"EQUIPE"      ,"C", 005,0})
	AADD(aCampos,{"SUPERV"      ,"C", 030,0})
	AADD(aCampos,{"AT_MEDICO"    ,"N", 008,2})
	AADD(aCampos,{"ATRASO_AB"   ,"N", 008,2})
	AADD(aCampos,{"LIC_PATERN"  ,"N", 008,2})
	AADD(aCampos,{"FALTA_AB"    ,"N", 008,2})
	AADD(aCampos,{"DOA_SANGUE"    ,"N", 008,2})
	AADD(aCampos,{"SAIDA_ANT"    ,"N", 008,2})
	AADD(aCampos,{"OUTROS_AB"    ,"N", 008,2})
ElseIf Mv_Par01 == 2
	AADD(aCampos,{"FILIAL"      ,"C", 002,0})
	AADD(aCampos,{"COD_CC"      ,"C", 020,0})
	AADD(aCampos,{"DESC_CC"     ,"C", 025,0})
	AADD(aCampos,{"EQUIPE"      ,"C", 005,0})
	AADD(aCampos,{"SUPERV"      ,"C", 030,0})
	AADD(aCampos,{"AT_MEDICO"    ,"N", 008,2})
	AADD(aCampos,{"ATRASO_AB"   ,"N", 008,2})
	AADD(aCampos,{"LIC_PATERN"  ,"N", 008,2})
	AADD(aCampos,{"FALTA_AB"    ,"N", 008,2})
	AADD(aCampos,{"DOA_SANGUE"    ,"N", 008,2})
	AADD(aCampos,{"SAIDA_ANT"    ,"N", 008,2})
	AADD(aCampos,{"OUTROS_AB"    ,"N", 008,2})
Endif

cArqEXC := CriaTrab(aCampos,.t.)
dbUseArea(.T.,,cArqEXC,"EXC",.T.)

dbSelectArea("EXC")
dbGotop()

If cPonMes <= Dtos(Mv_Par10)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณQuery SPC (Mensal) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRIC, RA_NOME AS NOME, RA_CC AS CODCC, "
	_cQuery += "CTT_DESC01 AS DESCCC, RA_EQUIPE AS EQUIPE, ZM_DESCR AS SUPERV, PC_PD AS EVENTO, "
	_cQuery += "PC_ABONO AS ABONO, P6_DESC AS DESCABO, PC_QTABONO AS QTABO "
	
	_cQuery += "FROM "+RETSQLNAME('SRA')+","+RETSQLNAME('CTT')+","+RETSQLNAME('SZM')+","+RETSQLNAME('SPC')+","+RETSQLNAME('SP6')+" "
	
	_cQuery += "WHERE RA_CC = CTT_CUSTO AND "
	_cQuery += "RA_EQUIPE = ZM_COD AND "
	_cQuery += "RA_FILIAL = PC_FILIAL AND "
	_cQuery += "RA_MAT = PC_MAT AND "
	_cQuery += "PC_ABONO = P6_CODIGO "
	_cQuery += "AND "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SZM")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("CTT")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SPC")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SP6")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	_cQuery += "AND RA_MAT    BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	_cQuery += "AND RA_CC     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
	_cQuery += "AND RA_EQUIPE BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
    _cQuery += "AND PC_PD IN('"+ALLTRIM(MV_PAR12)+"') "    
    _cQuery += "AND PC_ABONO <> '  ' "

Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณQuery SPH (Acumulado) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRIC, RA_NOME AS NOME, RA_CC AS CODCC, "
	_cQuery += "CTT_DESC01 AS DESCCC, RA_EQUIPE AS EQUIPE, ZM_DESCR AS SUPERV, PH_PD AS EVENTO, "
	_cQuery += "PH_ABONO AS ABONO, P6_DESC AS DESCABO, PH_QTABONO AS QTABO "
	
	_cQuery += "FROM "+RETSQLNAME('SRA')+","+RETSQLNAME('CTT')+","+RETSQLNAME('SZM')+","+RETSQLNAME('SPH')+","+RETSQLNAME('SP6')+" "
	
	_cQuery += "WHERE RA_CC = CTT_CUSTO AND "
	_cQuery += "RA_EQUIPE = ZM_COD AND "
	_cQuery += "RA_FILIAL = PH_FILIAL AND "
	_cQuery += "RA_MAT = PH_MAT AND "  
	_cQuery += "PH_ABONO = P6_CODIGO "
	_cQuery += "AND "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SZM")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("CTT")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SPH")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND "+RETSQLNAME("SP6")+".D_E_L_E_T_ <> '*' "
	_cQuery += "AND RA_FILIAL BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	_cQuery += "AND RA_MAT    BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	_cQuery += "AND RA_CC     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
	_cQuery += "AND RA_EQUIPE BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
    _cQuery += "AND PH_DATA >= '"+DTOS(MV_PAR10)+"' AND PH_DATA <= '"+DTOS(MV_PAR11)+"' "
	_cQuery += "AND PH_PD IN('"+ALLTRIM(MV_PAR12)+"') "
    _cQuery += "AND PH_ABONO <> '  ' "

Endif

If Mv_par01 == 1
   _cQuery += "ORDER BY FILIAL,EQUIPE,MATRIC,CODCC,ABONO "
Elseif Mv_Par01 == 2
   _cQuery += "ORDER BY FILIAL,EQUIPE,CODCC,ABONO "
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TRBAAJ") > 0
	DBSelectArea("TRBAAJ")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCQUERY _cQuery NEW ALIAS "TRBAAJ"

If Mv_Par01 == 1  //analitico
   
   DBSelectArea("TRBAAJ")
   If Eof() .and. Bof()
      MsgAlert("Nใo existem dados a serem gerados !!!")
      Return
   Endif   

   dbGotop()

   ProcRegua(TRBAAJ->(LastRec()))

   While !Eof()
  
      cFilAtu   := TRBAAJ->Filial
      cNomeAtu  := TRBAAJ->Nome
      cEquipeAtu:= TRBAAJ->Equipe	
      cMatAtu   := TRBAAJ->Matric
      cCodCCAtu := TRBAAJ->CodCC
      cDescCCAtu:= TRBAAJ->DescCC
      cSupervAtu:= TRBAAJ->Superv
      cEventoAtu:= TRBAAJ->Evento
      cAbonoAtu := TRBAAJ->Abono
      nQtMedico := 0
      nQtAtraso := 0
      nQtPater  := 0
      nQtFalta  := 0
      nQtDoacao := 0
      nQtSaida  := 0
      nQtOutros := 0
     
     While !Eof() .and. cFilAtu+cEquipeAtu+cMatAtu+cCodCCAtu+cAbonoAtu == TRBAAJ->Filial+TRBAAJ->Equipe+TRBAAJ->Matric+TRBAAJ->CodCC+TRBAAJ->Abono
     
       IncProc("Processando: " + Trbaaj->filial+ " - "+Trbaaj->matric+"-"+Subs(Trbaaj->Nome,1,15) )

       cFilFun   := cFilAtu
       cMatFun   := cMatAtu
       cNomeFun  := cNomeAtu
       cEquipeFun:= cEquipeAtu
       cCodCCFun := cCodCCAtu
       cDesCCFun := cDescCCAtu
       cSupervFun:= cSupervAtu 
       cEventoFun:= cEventoAtu
       cAbonoFun := cAbonoAtu

      If cAbonoFun == "001"
         nQtMedico += TRBAAJ->QtAbo 
      ElseIf cAbonoFun == "002"
         nQtAtraso += TRBAAJ->QtAbo
      ElseIf cAbonoFun == "003"
         nQtPater  += TRBAAJ->QtAbo
      ElseIf cAbonoFun == "006"
         nQtFalta  += TRBAAJ->QtAbo
      ElseIf cAbonoFun == "007"
         nQtDoacao += TRBAAJ->QtAbo
      ElseIf cAbonoFun == "017"
         nQtSaida  += TRBAAJ->QtAbo
      Else
         nQtOutros += TRBAAJ->QtAbo
      Endif       
     
      TrbAAJ->(dbSkip())

     EndDo

     dbSelectArea("EXC")
  
     RecLock("EXC",.T.)
     EXC->FILIAL    := cFilFun
     EXC->MATRICULA := cMatFun
     EXC->NOME      := cNomeFun
     EXC->COD_CC    := cCodCCFun
     EXC->DESC_CC   := cDesCCFun
     EXC->EQUIPE    := cEquipeFun
     EXC->SUPERV    := cSupervFun
     EXC->AT_MEDICO := nQtMedico
     EXC->ATRASO_AB := nQtAtraso 
     EXC->LIC_PATERN:= nQtPater
     EXC->FALTA_AB  := nQtFalta
     EXC->DOA_SANGUE:= nQtDoacao
     EXC->SAIDA_ANT := nQtSaida
     EXC->OUTROS_AB := nQtOutros
     MsUnlock()

     dbSelectArea("TRBAAJ")
      cFilAtu   := ""
      cNomeAtu  := ""
      cEquipeAtu:= ""	
      cMatAtu   := ""
      cCodCCAtu := ""
      cDescCCAtu:= ""
      cSupervAtu:= ""
      cEventoAtu:= ""
      cAbonoAtu := ""
      nQtMedico := 0
      nQtAtraso := 0
      nQtPater  := 0
      nQtFalta  := 0
      nQtDoacao := 0
      nQtSaida  := 0
      nQtOutros := 0

   EndDo  
  
ElseIf Mv_par02 == 2 //sintetico

   dbSelectArea("TRBAAJ")
   If Eof() .and. Bof()
      MsgAlert("Nใo existem dados a serem gerados !!!")
      Return
   Endif   
   cIndex := CriaTrab(nil,.f.)
   cChave  := "FILIAL+EQUIPE+CODCC+ABONO"
   
   IndRegua("TRBAAJ",cIndex,cChave,,,"Selecionando Registros...")

   dbGotop()

   ProcRegua(TRBAAJ->(LastRec()))

   While !Eof()
   
     cFilAtu   := TRBAAJ->Filial
     cNomeAtu  := TRBAAJ->Nome
     cEquipeAtu:= TRBAAJ->Equipe	
     cMatAtu   := TRBAAJ->Matric
     cCodCCAtu := TRBAAJ->CodCC
     cDescCCAtu:= TRBAAJ->DescCC
     cEquipeAtu:= TRBAAJ->Equipe
     cSupervAtu:= TRBAAJ->Superv
     cEventoAtu:= TRBAAJ->Evento
     cAbonoAtu := TRBAAJ->Abono
     nQtMedico := 0
     nQtAtraso := 0
     nQtPater  := 0
     nQtFalta  := 0
     nQtDoacao := 0
     nQtSaida  := 0
     nQtOutros := 0
   
     While !Eof() .and. cFilAtu+cEquipeAtu+cCodCCAtu+cAbonoAtu == TRBAAJ->Filial+TRBAAJ->Equipe+TRBAAJ->CodCC+TRBAAJ->Abono
      
     IncProc("Processando: " + "Filial: "+TRBAAJ->Filial+"-"+"Equipe: "+TRBAAJ->Equipe )

       cFilFun   := cFilAtu
       cCodCCFun := cCodCCAtu
       cDesCCFun := cDescCCAtu
       cEquipeFun:= cEquipeAtu
       cSupervFun:= cSupervAtu  
       cEventoFun:= cEventoAtu 
       cAbonoFun := cAbonoAtu
    
      If cAbonoAtu == "001"
         nQtMedico += TRBAAJ->QtAbo 
      ElseIf cAbonoAtu == "002"
         nQtAtraso += TRBAAJ->QtAbo
      ElseIf cAbonoAtu == "003"
         nQtPater  += TRBAAJ->QtAbo
      ElseIf cAbonoAtu == "006"
         nQtFalta  += TRBAAJ->QtAbo
      ElseIf cAbonoAtu == "007"
         nQtDoacao += TRBAAJ->QtAbo
      ElseIf cAbonoAtu == "017"
         nQtSaida  += TRBAAJ->QtAbo
      Else
         nQtOutros += TRBAAJ->QtAbo
      Endif       
  
      TRBAAJ->(dbSkip())
     
     EndDo  
    
     dbSelectArea("EXC")
  
     RecLock("EXC",.T.)
     EXC->FILIAL    := cFilFun
     EXC->COD_CC    := cCodCCFun
     EXC->DESC_CC   := cDesCCFun
     EXC->EQUIPE    := cEquipeFun
     EXC->SUPERV    := cSupervFun
     EXC->AT_MEDICO := nQtMedico
     EXC->ATRASO_AB := nQtAtraso 
     EXC->LIC_PATERN:= nQtPater
     EXC->FALTA_AB  := nQtFalta
     EXC->DOA_SANGUE:= nQtDoacao
     EXC->SAIDA_ANT := nQtSaida
     EXC->OUTROS_AB := nQtOutros
     MsUnlock()
  
     dbSelectArea("TRBAAJ")
     cFilAtu   := ""
     cNomeAtu  := ""
     cEquipeAtu:= ""	
     cMatAtu   := ""
     cCodCCAtu := ""
     cDescCCAtu:= ""     
     cEquipeAtu:= ""
     cSupervAtu:= ""
     cEventoAtu:= ""
     cAbonoAtu := ""
     nQtMedico := 0
     nQtAtraso := 0
     nQtPater  := 0
     nQtFalta  := 0
     nQtDoacao := 0
     nQtSaida  := 0
     nQtOutros := 0 
   EndDo    

Endif  
  
  //Atualiza Regua	
  IncProc("Gerando Planilha......")
  
  EXC->(dbclosearea())

  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณAbre DBF no Excel ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  Processa({||OpExcel(cArqExc)},"Abrindo Excel.....")			

  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณApaga DBF do Sigaadv ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  fErase(cArqExc+".dbf")

  //Close(oGeraXls)
  Return
  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OpExcel  บ Autor ณ Adilson Gomes      บ Data ณ  08/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ OLE para uso do excel com o microsiga.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OpExcel(cArqEXC) 

Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia DBF para pasta TEMP do sistema operacional da estacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If FILE(cArqEXC+".DBF")
	COPY FILE (cArqEXC+".DBF") TO (cPath+cArqEXC+".DBF")
EndIf

If !ApOleClient("MsExcel")
	MsgStop("MsExcel nao instalado.")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria link com o excelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp := MsExcel():New()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre uma planilhaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oExcelApp:WorkBooks:Open(cPath+cArqEXC+".DBF")
oExcelApp:SetVisible(.T.)       

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ VALIDPERGบ Autor ณ Adalberto Althoff  บ Data ณ  15/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar, VALIDADA PARA AP7                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Analitico/Sintetico:","","","mv_ch1","N",01,0,0,"C","            ","mv_par01","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","   ","",""," "})
aAdd(aRegs,{_cPerg,"02","Filial de       ","","","mv_ch2","C",02,0,0,"G","            ","mv_par02","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","Filial ate      ","","","mv_ch3","C",02,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"04","Matricula de    ","","","mv_ch4","C",06,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"05","Matricula ate   ","","","mv_ch5","C",06,0,0,"G","            ","mv_par05","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"06","CCusto de       ","","","mv_ch6","C",20,0,0,"G","            ","mv_par06","         ","","","","","         ","","","","","","","","","","","","","","","","","","","CTT","","","          "})
aAdd(aRegs,{_cPerg,"07","CCusto ate      ","","","mv_ch7","C",20,0,0,"G","            ","mv_par07","         ","","","","","         ","","","","","","","","","","","","","","","","","","","CTT","","","          "})
aAdd(aRegs,{_cPerg,"08","Equipe de       ","","","mv_ch8","C",05,0,0,"G","            ","mv_par08","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"09","Equipe ate      ","","","mv_ch9","C",05,0,0,"G","            ","mv_par09","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SRA","","","          "})
aAdd(aRegs,{_cPerg,"10","Dt.Inic.Apontamento","","","mv_chA","D",08,0,0,"G","            ","mv_par10","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"11","Dt.Fim Apontamento","","","mv_chB","D",08,0,0,"G","            ","mv_par11","         ","","","","","         ","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"12","Codigo Evento Abonado ","","","mv_chC","C",30,0,0,"G","fEventos('P9_CODIGO')","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return