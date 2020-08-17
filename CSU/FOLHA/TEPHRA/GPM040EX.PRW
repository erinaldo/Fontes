#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³Programa  ³ GPM040EX ³ Autor ³ 	Isamu Kawakami      ³ Data ³ 05/02/13 ³±±
±±ºPrograma  GPM040EX º Autor ³ Romay Oliveira     º Data ³  01/2015 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³ P.E. para excluir dados do campo RA_XULTDIA                ³±±
±±ºDescricao ³Ponto de Entrada ao excluir o calculo de rescisao			  º±±
±±º			 Criacao da tabela ZP1 de integracao com o Tephra			  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function GPM040EX() 
// copia de PE antigo para manter funcionalidade   
// adicionado funcionalidade de integracao com tephra
                             
Local cDescTurno 	:= ""
Local aAreaAnt 		:= GetArea()  

Local xCodUser := ""
Local xNameUser:= ""

PswOrder(1)

xCodUser := Sra->Ra_CodUsu_

If PswSeek(xCodUser)
   //Se encontrou grava o Username na variavel xNameUser                  
   xNameUser := PswRet(1)[1][2]
EndIf


MsgAlert("O USUÁRIO "+xCodUser+"-"+xNameUser + " POSSUI BLOQUEIO NO SISTEMA. " + "SOLICITE O DESBLOQUEIO JUNTO AO ADMINISTRADOR DE SEGURANÇA !!!") 

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
   RestArea(aAreaAnt)
   Return
Endif


SRA->( RecLock( "SRA" , .F.  ) )
SRA->RA_XULTDIA  := Ctod("//")
SRA->RA_MDEXC := "2"
SRA->( MsUnLock() )

cQuery := "	SELECT 	* 												" 
cQuery += " FROM   	"+retsqlname("ZP1")+" ZP1				   		"
cQuery += " WHERE 	ZP1.ZP1_FILIAL 	= '"+xFilial("ZP1")+"'			"
cQuery += " AND 	ZP1.ZP1_MAT 	= '"+SRG->RG_MAT+"'  			"
cQuery += " AND 	ZP1.ZP1_STATUS 	= '0' 							" 
cQuery += " AND 	ZP1.ZP1_DEMISS	= '"+dtos(SRG->RG_DATADEM)+"'	"
cQuery += " AND 	ZP1.D_E_L_E_T_ 	= ''							"
   
TCQUERY cQuery NEW ALIAS "TMPZP1"

dbSelectArea("TMPZP1")
TMPZP1->(dbGoTop())


            
If TMPZP1->(!EOF())  
		
		Begin Transaction
		
				cUpdate := "	UPDATE 	"+RetSQLName("ZP1")+"							"
				cUpdate += "	SET 	ZP1_STATUS 	= '1' 					,			"
			 	cUpdate += "			D_E_L_E_T_	= '*' 								"
				cUpdate += "	WHERE 	ZP1_FILIAL 	= '"+xFilial("ZP1")+"'	    		"
				cUpdate += "	AND 	ZP1_MAT 	= '"+SRG->RG_MAT+"'					"		
				cUpdate += "	AND		ZP1_STATUS 	= '0' 					  			"					    
				cUpdate += " 	AND 	ZP1_DEMISS	= '"+dtos(SRG->RG_DATADEM)+"'		"
				cUpdate += "	AND 	D_E_L_E_T_ 	= ''					   			"
								
				TCSQLEXEC(cUpdate) 
				
        End Transaction
Else          
	
	DbSelectArea("SR6")
	DbSetOrder(1)
	dbgotop()
	 
	If 	DbSeek( xFilial("SR6") + SRA->RA_TNOTRAB )

		cDescTurno := SR6->R6_DESC                                                                      

	EndIf 
	
	Begin Transaction
  	 
  	 RecLock( "ZP1", .T. )
		
		ZP1->ZP1_FILIAL := xFilial( "ZP1" )
		ZP1->ZP1_NOME 	:= SRA->RA_NOME
		ZP1->ZP1_SEXO   := SRA->RA_SEXO
		ZP1->ZP1_ESTCIV := SRA->RA_ESTCIVI
		ZP1->ZP1_NATURA := SRA->RA_NATURAL
		ZP1->ZP1_NACION := SRA->RA_NACIONA
		ZP1->ZP1_MAT    := SRA->RA_MAT
		ZP1->ZP1_SITFOL := SRA->RA_SITFOLH
		ZP1->ZP1_CATFUN := SRA->RA_CATFUNC
		ZP1->ZP1_CC 	:= SRA->RA_CC
		ZP1->ZP1_CODFUN := SRA->RA_CODFUNC
		ZP1->ZP1_ADMISS := SRA->RA_ADMISSA
		ZP1->ZP1_DEMISS := SRA->RA_DEMISSA
		ZP1->ZP1_TEL  	:= SRA->RA_TELEFON
		ZP1->ZP1_CIC    := SRA->RA_CIC
		ZP1->ZP1_RG     := SRA->RA_RG
		ZP1->ZP1_TTRAB  := SRA->RA_TNOTRAB
		ZP1->ZP1_DESCTT := cDescTurno
		ZP1->ZP1_HRSMES := SRA->RA_HRSMES 
		ZP1->ZP1_HRSSEM := SRA->RA_HRSEMAN
		ZP1->ZP1_STATUS := "0" 
		ZP1->ZP1_SEQTAB	:= ZP1->(Recno())
		ZP1->ZP1_DATA	:= dDatabase
		ZP1->ZP1_HORA	:= Time()
		ZP1->ZP1_NASC   := SRA->RA_NASC
		ZP1->ZP1_EQUIPE := SRA->RA_EQUIPE
		ZP1->ZP1_ENDERE := SRA->RA_ENDEREC
		ZP1->ZP1_NUMEND := SRA->RA_NUMENDE
		ZP1->ZP1_COMPLE := SRA->RA_COMPLEM
		ZP1->ZP1_MUNICI := SRA->RA_MUNICIP
		ZP1->ZP1_CEP    := SRA->RA_CEP
		ZP1->ZP1_BAIRRO := SRA->RA_BAIRRO
		ZP1->ZP1_ESTADO := SRA->RA_ESTADO  
		ZP1->ZP1_PAISOR := "BR   "
		
	 MsUnlock() 
	 
    End Transaction
    
EndIf

TMPZP1->(DbCloseArea())	

RestArea(aAreaAnt) // copia de PE antigo para manter funcionalidade

Return()