#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CARGASEQ º Autor ³ Adilson Silva      º Data ³ 14/08/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetuar a Carga Inicial do Campo RA_CODSEQ Conforme Data   º±±
±±º          ³ de Admissao.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CARGASEQ()		// U_CARGASEQ()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Carga Inicial - RA_CODSEQ"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 cDescricao := "Este programa irá realizar a carga inicial do campo RA_CODSEQ nos " + Chr(13) + Chr(10)
 cDescricao += "registros do cadastro de funcionarios."

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , ,,,,,.T.,.F. ) 	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  04/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fProcessa( oSelf )

Local cQuery   := ""
Local nTotReg  := 0
Local nContad  := 0
Local cCateg   := GETMV( "GP_SQCATE",,"ACDEGHIJMPST" )
Local nTamanho := Len( SRA->RA_CODSEQ )

// Converte as Categorias para Sintaxe SQL
cCateg := fSqlIN( cCateg, 1 )

cQuery := " SELECT SRA.RA_FILIAL,"
cQuery += "        SRA.RA_MAT,"
cQuery += "        SRA.RA_ADMISSA,"
cQuery += "        SRA.R_E_C_N_O_ AS RA_RECNO"
cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
cQuery += "   AND SRA.RA_CATFUNC IN (" + cCateg + ")"
cQuery += "   AND SRA.RA_RESCRAI NOT IN ('30','31')"
//	cQuery += "   AND SRA.RA_FILIAL = '02' AND SRA.RA_MAT = '024618'"
cQuery += " ORDER BY SRA.RA_ADMISSA, SRA.RA_MAT"

cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA" , "RA_RECNO"   , "N" , 10 , 0 )
TcSetField( "WSRA" , "RA_ADMISSA" , "D" , 08 , 0 )
dbSelectArea( "WSRA" )
Count To nTotReg
dbGoTop()
oSelf:SetRegua1( nTotReg )
Do While !Eof()
   SRA->(dbGoTo( WSRA->RA_RECNO ))
	   oSelf:IncRegua1( "Processando Funcionários.: " + SRA->RA_FILIAL + " - " + SRA->RA_MAT + " - " + SRA->RA_NOME )
	
	   If oSelf:lEnd 
	      Break
	   EndIf
   
   // Incrementa e Grava o Campo
   dbSelectArea( "SRA" )
   nContad++
   RecLock("SRA",.F.)
    SRA->RA_CODSEQ := StrZero( nContad, nTamanho )
   MsUnlock()

   dbSelectArea( "WSRA" )
   dbSkip()
EndDo
WSRA->(dbCloseArea())

// Acerta os Registros das transferencias
cQuery := " SELECT SRA.RA_FILIAL,"
cQuery += "        SRA.RA_MAT,"
cQuery += "        SRA.RA_ADMISSA,"
cQuery += "        SRA.R_E_C_N_O_ AS RA_RECNO"
cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"
cQuery += " WHERE D_E_L_E_T_ <> '*'"
cQuery += "   AND SRA.RA_CATFUNC IN (" + cCateg + ")"
cQuery += "   AND SRA.RA_RESCRAI IN ('30','31')" 
//	cQuery += " AND ( RA_FILIAL = '02' AND RA_MAT = '016898' ) OR ( RA_FILIAL = '09' AND RA_MAT = '007935' ) OR ( RA_FILIAL = '91' AND RA_MAT = '008451' ) OR ( RA_FILIAL = '04' AND RA_MAT = '010390' ) OR ( RA_FILIAL = '03' AND RA_MAT = '021406' ) OR ( RA_FILIAL = '02' AND RA_MAT = '024618' )"
cQuery += " ORDER BY SRA.RA_ADMISSA, SRA.RA_MAT"

cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA" , "RA_RECNO"   , "N" , 10 , 0 )
TcSetField( "WSRA" , "RA_ADMISSA" , "D" , 08 , 0 )
dbSelectArea( "WSRA" )
Count To nTotReg
dbGoTop()
oSelf:SetRegua2( nTotReg )
Do While !Eof()
   SRA->(dbGoTo( WSRA->RA_RECNO ))
   oSelf:IncRegua2( "Processando Transferências.: " + SRA->RA_FILIAL + " - " + SRA->RA_MAT + " - " + SRA->RA_NOME )

   If oSelf:lEnd 
      Break
   EndIf
   
   cQuery := " SELECT SRA.RA_CODSEQ"
   cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"
   cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
   cQuery += "   AND SRA.RA_CIC = '" + SRA->RA_CIC + "'"
   cQuery += "   AND SRA.RA_ADMISSA = '" + Dtos( SRA->RA_ADMISSA ) + "'"
   cQuery += "   AND SRA.RA_RESCRAI NOT IN ('30','31')"
   TCQuery cQuery New Alias "WTMP"
   nContad := Val( WTMP->RA_CODSEQ )
   WTMP->(dbCloseArea())
   
   // Grava o Campo
   dbSelectArea( "SRA" )
   RecLock("SRA",.F.)
    SRA->RA_CODSEQ := StrZero( nContad, nTamanho )
   MsUnlock()

   dbSelectArea( "WSRA" )
   dbSkip()
EndDo
WSRA->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FSQLIN   ºAutor  ³ Adilson Silva      º Data ³  04/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Montar a Selecao da Clausula IN do SQL.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fSqlIN( cTexto, nStep )

 Local cRet := ""
 Local i
 
 cTexto := Rtrim( cTexto )
 If Len( cTexto ) > 0
    For i := 1 To Len( cTexto ) Step nStep
        cRet += "'" + SubStr( cTexto, i, nStep ) + "'"
        If i + nStep <= Len( cTexto )
           cRet += ","
        EndIf
    Next
 EndIf

Return( cRet )
