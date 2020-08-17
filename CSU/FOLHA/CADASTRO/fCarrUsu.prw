#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCARRUSU  º Autor ³ Isamu K.           º Data ³ 23/10/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua Carga do campo RA_CODUSU_ com o respectivo codigo deº±±
±±º          ³ usuário                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                 3
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fCarrUsu   

Private nI
Private cQr
Private aRet   := {}  
Private aUsers := {}

MsAguarde( {|| fUsersAll()}, "Processando...", "Carregamdo matriz com codigo de usuários...Aguarde !!! " )

MsAguarde( {|| fCodUsu()}, "Processando...", "Preenchendo códigos de usuarios --> Funcionários !! " )

Return


Static Function fUsersAll

aRet := AllUsers()


Return


Static Function fCodUsu

For nI := 1 to Len(aRet)
   Aadd(aUsers,{ aRet[nI][1][1],aRet[nI][1][22]} )
Next  

cQr := " SELECT RA_FILIAL, RA_MAT, R_E_C_N_O_ AS REGSRA "
cQr += " FROM "+RetSqlName("SRA")+ " "
cQr += " WHERE RA_SITFOLH <> 'D' "
cQr += " AND "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha alias caso esteja aberto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TMA") > 0
	DBSelectArea("TMA")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"TMA",.F.,.T.)

While !Tma->(Eof())

   If ( nPos := aScan( aUsers, { |x| SubStr( x[2], 1, 2 ) == '05' .and. SubStr( x[2], 3, 2 ) == Tma->Ra_Filial .and. SubStr( x[2], 5, 6 ) == Tma->Ra_Mat } ) ) > 0
      	SRA->(dbGoto(Tma->RegSra))
        Reclock("SRA",.F.)
        Sra->Ra_CodUsu_ := aUsers[nPos,1]
        Sra->(MsUnlock())                             
   Endif
   
   Tma->(dbSkip())
  
EndDo
        
Alert("Preenchimento dos códigos de usuarios efetuado.")

Return

