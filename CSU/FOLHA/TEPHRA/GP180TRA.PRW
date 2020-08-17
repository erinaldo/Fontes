#INCLUDE "PROTHEUS.CH"        
#INCLUDE "TOPCONN.CH"

User Function GP180TRA()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP180TRA()|Autor  ³ Alexandre Souza    º Data ³  07/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada para Alterar Alguns Campos Apos a transfe- º±±
±±º          ³rencia                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EXCLUSIVO PARA CSU                                         º±±
±±º          ³                                                            º±±
±±º 07/04/08 ³ Alexandre Souza - CHAMADO 000000003794 - Criado para sempreº±±
±±º          ³ que existir uma transferencia o sistema atualize o campo   º±±
±±º          ³ RA_CRACHA, com o conteudo a seguir: "Filial+Matrícula".    º±±
±±º          ³                                                            º±±
±±º          ³ -Ponto de Entrada para Alterar Alguns Campos Apos a trans- º±±
±±º          ³  ferencia                                                  º±±
±±º          ³ -Variaveis que podem ser Usadas                            º±±
±±º          ³ -cEmpAte = Empresa Destino                                 º±±
±±º          ³ -cFilAte = Filial Destino                                  º±±
±±º          ³ -cMatAte = Matricula Destino                               º±±
±±º          ³ -cCcuAte = C.Custo Destino                                 º±±
±±º          ³ -lMudaSra = Se havera mudanca no SRA e se ela foi efetivadaº±±
±±º          ³ -Quando transferencia C.Custo/Filial e Empresa com Cgc Di- º±±
±±º          ³ ferente fica posicionado no Funcionario                    º±±
±±º 06/06/08 ³ Isamu - existiam dois rdmakes utilizando a mesna funcao    º±±
±±º          ³ ambos foram compatibilizados, sendo que o segundo desmarca º±±
±±º          ³ os campos de inclusão e exclusão Medial, na transferencia  º±±
±±º          ³                                                            º±±
±±º----------³------------------------------------------------------------º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
Local c_Query := ""
Local c_Query2 := ""
Local _aArea     := GetArea()
Local _FilDest   := cFilAte
Local _Valida    := .T.
Local _MatDest   := cMatAte
Local _CrachaAnt := RA_CRACHA
Local _dDataTran := dDataTra	 //os 0305/10
Local _FilOrig := cFilDe //os 0305/10

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
   RestArea(_aArea)
   Return(.T.)
Endif


dBSelectArea("SRA")
dBSetOrder(1)
dBGoTop()

If dbSeek(_FilDest+_MatDest)
	
	SRA->( RecLock( "SRA" , .F. ) )
	SRA->RA_CRACHA := _FilDest+_MatDest
	SRA->RA_ITEMD  := _cUnidade
	SRA->RA_CLVLDB := _cOper
	SRA->RA_XENVALT:= ''
	SRA->( MsUnLock() )
	
	If _FilOrig <> _FilDest
		
		SRA->( RecLock( "SRA" , .F. ) )
		SRA->RA_DTTRANS := _dDataTran  //os 0305/10
		SRA->( MsUnLock() )
		
	Endif
	
Endif

If lMudaSRA
	
	If lLote
		//Registro anterior
		c_Query := " SELECT R_E_C_N_O_ AS RECSRA FROM "+RetSqlName('SRA')+" "
		c_Query += " WHERE RA_FILIAL = '"+__cSvFilAnt+"' "
		c_Query += " AND RA_MAT = '"+cMatDe+"' "
		c_Query += " AND D_E_L_E_T_ = ''" 

		U_MontaView(c_Query, "TMPSRA")
	    
	    DbSelectArea("TMPSRA")
		TMPSRA->(DbGotop())
		
		If !TMPSRA->( Eof())
			c_Query2 := "UPDATE SRA050 SET RA_MDEXC = ''   "
			c_Query2 += "WHERE R_E_C_N_O_ = "+Alltrim(Str(TMPSRA->RECSRA))+" "
			c_Query2 += "AND D_E_L_E_T_ <> '*'"
			TcSqlExec(c_Query2)
		Else
			MsgAlert("Nao foi possivel desmarcar o campo Exclusao Medial do funcionario " + cMatde + ". Proceder manualmente!")	
		EndIf
		TMPSRA->( DbCloseArea())
	Else

		if dbSeek( __cSvFilAnt+cMatDe )
			RecLock("SRA",.F.)
			SRA->RA_MDEXC := " "
			SRA->( MsUnLock() )
		Else
			MsgAlert("Nao foi possivel desmarcar o campo Exclusao Medial do funcionario " + cMatde + ". Proceder manualmente!")
		Endif
	EndIf
	// Registro atual
	dBSelectArea("SRA")
	if dbSeek( cFilAte+cMatAte )//->desabilitado pela OS 0305/10 - Isamu
		RecLock("SRA",.F.)
		SRA->RA_MDINC := " "
		SRA->( MsUnLock() )
	Else
		MsgAlert("nao foi possivel desmarcar o campo Inclusao Medial do funcionario " + cMatAte + ". Proceder manualmente!")
	Endif
	
Endif

If Type('_cUnidade') # 'U'
	_cUnidade := Nil
EndIf
If Type('_cOper') # 'U'
	_cOper    := Nil
EndIf


//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±± Autor  ³ Romay Oliveira						    º Data ³  02/15   	  º±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±± 		Gravar ZP1 para integrar a transferencia com o Tephra		  	  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

If _Valida

	cQuery4 := " SELECT 	* 												" 
	cQuery4 += " FROM   	"+retsqlname("ZP1")+" ZP1				   		"
	cQuery4 += " WHERE 	ZP1.ZP1_FILIAL 	= '"+SRA->RA_FILIAL+"' 				"
	cQuery4 += " AND 	ZP1.ZP1_MAT 	= '"+SRA->RA_MAT+"'  				"
	cQuery4 += " AND 	ZP1.ZP1_STATUS 	= '0' 		   						" 
	cQuery4 += " AND 	ZP1.D_E_L_E_T_ 	= ''	   							"
	   
	TCQUERY cQuery4 NEW ALIAS "TMPZP1"
	
	dbSelectArea("TMPZP1")
	TMPZP1->(dbGoTop())
	            
	If TMPZP1->(!EOF())
		
		_Valida1 := .T.
			
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
	
	_Valida1 := .T.
	
	End Transaction
	
	EndIf    
	
	TMPZP1->(DbCloseArea())
		
EndIf           

RestArea(_aArea) //Retorna ao ambiente inicial

Return(_Valida1)
