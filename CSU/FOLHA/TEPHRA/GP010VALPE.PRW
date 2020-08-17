#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"   
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±± 
±±ºPrograma  ³ GP010VALPE   º Autor ³ Alexandre Souza º Data ³ 27/06/2007 		   º±±
±±ºPrograma  Gp010ValPE º Autor ³ Romay Oliveira     º Data ³  01/2015    		   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±            '
±±º 27/06/2007 - Alexandre Souza - Valida se em alteração o cpo RA_VALEREF         º±±
±±º              é diferente do campo ZR_CODIGO, com o conteúdo atual do           º±±
±±º              campo RA_VALEREF                                                  º±±
±±º 23/07/2007 - Alterado por Claudinei E.N. para gravar dados na tabela SZR       º±±
±±º              quando funcionaro nao existir ou alterar dados quando funcio-     º±±
±±º              nário existir. Somente quando o botao alterar for selecionado     º±±
±±º 27/07/2007 - Ajustes: tratamento quando o usuario nao possuir acesso ao campo  º±±
±±º              RA_VALEREF                                                        º±±
±±º 31/01/2008 - Incluido tratamento do campo RA_ASMANT, para armazenar plano an-  º±±
±±º              terior, e MDEXC/MDINC para SRA e SRB, nas transferências de plano.º±±
±±º 13/05/2008 - Ernani  - Incluida gravacao do flag de alteraca para a rotina de  º±±
±±º              exportacao                                                        º±±
±±º 18/12/2008 - Anderson Casarotti - Torna o campo RA_ASMEDIC "Cod.Ass.Med.       º±±
±±º              obrigatorio para categorias de funcionarios diferentes de P e A   º±±
±±º              OS 3515/08 - Linha 120                                            º±±
±±º 08/07/2009 - Isamu Kawakami   -   Torna o campo RA_VALEREF "Cod.Vale Refeicao" º±±
±±º              obrigatorio para categorias de funcionarios diferentes de P e A   º±±
±±º              OS 1088/09 - Linha 120                                            º±± 
±±º 19/01/2009 - Tania - Gravacao do campo PA6_INTEGR com "I", para formalizar a   º±±
±±º              efetivacao da admissao.                                           º±±
±±º 09/10/2017 - Isamu - OS 3197/16 - Incluso tratamento para os campos: Pais (End-º±±
±±º              ereço), RG, Sexo, Est.Civil, Naturalidade, Nacionalidade, Numero  º±±
±±º              Endereço, Estado do endereço, que serão gravados na ZP1           º±±
±±º                                                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºDescricao ³Ponto de Entrada no cadastro de funcionarios para 		  		   º±±
±±º			 Criacao da tabela ZP1 de integracao com o Tephra			  		   º±±
±±º																		  		   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      		   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function Gp010ValPE()    

// copia de PE antigo para manter funcionalidade - excluido registros comentados caso necessario olhar rdmake\folha\pentrada\Gp010ValPE 
// adicionado funcionalidade de integracao com tephra

Local aAreaGeral := GetArea()
Local lReturn    := .t.
Local c_Filial   := xFilial("SRA")
Local c_MatFunc  := ""
Local Lret := .F. 

//incluso pela OS 2816/16 - Isamu K.
If cEmpAnt == "06"
   RestArea(aAreaGeral)
   Return(.T.)
Endif
//
// Se For alteracao limpa o flag para reenviar na rotina de exportacao
//                                                   Ernani 2008.05.13
//

If ALTERA
	M->RA_XENVALT := Ctod('')
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 001214: Validar as entidades contabeis em duas fases. Na fase I  ³
³ Sergio em Abr/08: devera ser feito o De-Para entre os CC de RH e CC finan- ³
³                   ceiro. Quando for habilitada a fase II, devera ser con-  ³
³                   sistido o CC diretamente sem a ponte De-Para.            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If GetMV( 'MV_X_BLQRH' ) == '1' // Fase I Ativa
	CTT->( DbSetOrder(1), DbSeek( xFilial('CTT')+M->RA_CC ) )
	If !U_VldCTBg( 	M->RA_ITEMD, CTT->CTT_CCONTD, M->RA_CLVLDB )
		RestArea( aAreaGeral )
		Return(.f.)
	EndIf
Else                            // Fase II Ativa
	If !U_VldCTBg( 	M->RA_ITEMD, M->RA_CC, M->RA_CLVLDB )
		RestArea( aAreaGeral )
		Return(.f.)
	EndIf
EndIf

dbSelectArea("SX3")
aAreaSX3 := GetArea()
dbSetOrder(2)
dbSeek("RA_VALEREF")
if cNivel >= SX3->X3_NIVEL
	dbSelectArea("SZR")
	aAreaSZR := GetArea()
	dbSetOrder(1)
	cValeRef:= M->RA_VALEREF
	cSRX_COD1 := Posicione("SRX", 1, xFilial("SRX")+"26"+"  "+cValeRef, "RX_TXT")
	if altera															// quando clicado no botao alterar:
		if (dbSeek(xFilial("SZR")+M->RA_MAT))					// se o funcionario existir no arquivo SZR...
			
			if cValeRef <> SZR->ZR_CODIGO							// ...e se codigo de vale refeicao do SRA for diferente do SZR...
				RecLock("SZR", .F.)									// ...altera o arquivo
				SZR->ZR_CODIGO	:=	cValeRef							// atualiza o campo codigo e
				SZR->ZR_DESC	:=	SubStr(SRX->RX_TXT,1,20)	// atualiza o campo descricao
				MsUnlock()
				Aviso("ATENCAO","O campo Vale Ref. foi alterado e será necessário novo calculo do benefício",{"Sair"}) // OS 2502-11
			end
		else
			if (dbSeek(xFilial("SZR")+M->RA_MAT)) == .F. .and. (!Empty(cValeRef) .or. cValeRef == " ")	//caso o funcionario nao esta cadastrado na tabela SZR...
				RecLock("SZR", .T.)									// ...prepara arquivo SZR para receber nova linha...
				SZR->ZR_FILIAL	:=	xFilial("SRA")					// grava a filial
				SZR->ZR_MAT		:=	M->RA_MAT						// grava a matricula do funcionario
				SZR->ZR_CODIGO	:=	cValeRef							// grava o codigo do vale refeicao
				SZR->ZR_DESC	:=	SubStr(SRX->RX_TXT,1,20)	// grava descricao do vale refeicao
				MsUnlock()
			end
		end
	end
	RestArea(aAreaSZR)
EndIf

RestArea(aAreaSX3)


/* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³Silvano Franca - 09/09/09 - OS 2053/09 ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If M->RA_VALEREF $ "29/30"
		If !Empty(M->RA_VA)
			Aviso("ATENCAO","O campo 'Optante VA' não pode ser informado quando o código da refeição for 29 (Brasvending) ou 30 (Sodexo).",{"Voltar"})
	        Return(.F.)
		Endif
	Endif


RestArea(aAreaGeral)

aAreaSRA   := SRA->(GetArea())      // Incluso por Anderson Casarotti Ref.Chamado 3235/08
aAreaSRF   := SRF->(GetArea())


cQuery := "	SELECT 	* 												" 
cQuery += " FROM   	"+retsqlname("ZP1")+" ZP1				   		"
cQuery += " WHERE 	ZP1.ZP1_FILIAL 	= '"+xFilial("ZP1")+"'			"
cQuery += " AND 	ZP1.ZP1_MAT 	= '"+M->RA_MAT+"'  				"
cQuery += " AND 	ZP1.ZP1_STATUS 	= '0' 							" 
cQuery += " AND 	ZP1.D_E_L_E_T_ 	= ''							"
   
TCQUERY cQuery NEW ALIAS "TMPZP1"

dbSelectArea("TMPZP1")
TMPZP1->(dbGoTop())
            
If TMPZP1->(!EOF())
	
	Lret := .T.
		
Else		
	DbSelectArea("SR6")
	DbSetOrder(1)
	dbgotop()
	 
	If 	DbSeek( xFilial("SR6") + M->RA_TNOTRAB )

		cDescTurno := SR6->R6_DESC                                                                      

	EndIf         


Begin Transaction

  	RecLock( "ZP1", .T. )
		
		ZP1->ZP1_FILIAL := xFilial( "ZP1" )
		ZP1->ZP1_NOME 	:= M->RA_NOME
		ZP1->ZP1_SEXO   := M->RA_SEXO
		ZP1->ZP1_ESTCIV := M->RA_ESTCIVI
		ZP1->ZP1_NATURA := M->RA_NATURAL
		ZP1->ZP1_NACION := M->RA_NACIONA
		ZP1->ZP1_MAT    := M->RA_MAT
		ZP1->ZP1_SITFOL := M->RA_SITFOLH
		ZP1->ZP1_CATFUN := M->RA_CATFUNC
		ZP1->ZP1_CC 	:= M->RA_CC
		ZP1->ZP1_CODFUN := M->RA_CODFUNC
		ZP1->ZP1_ADMISS := M->RA_ADMISSA
		ZP1->ZP1_DEMISS := M->RA_DEMISSA
		ZP1->ZP1_TEL  	:= M->RA_TELEFON
		ZP1->ZP1_RG     := M->RA_RG
		ZP1->ZP1_CIC    := M->RA_CIC
		ZP1->ZP1_RG     := M->RA_RG
		ZP1->ZP1_TTRAB  := M->RA_TNOTRAB
		ZP1->ZP1_DESCTT := cDescTurno
		ZP1->ZP1_HRSMES := M->RA_HRSMES 
		ZP1->ZP1_HRSSEM := M->RA_HRSEMAN
		ZP1->ZP1_STATUS := "0" 
		ZP1->ZP1_SEQTAB	:= ZP1->(Recno())
		ZP1->ZP1_DATA	:= dDatabase
		ZP1->ZP1_HORA	:= Time()
		ZP1->ZP1_NASC   := M->RA_NASC
		ZP1->ZP1_EQUIPE := M->RA_EQUIPE
		ZP1->ZP1_ENDERE := M->RA_ENDEREC
		ZP1->ZP1_NUMEND := M->RA_NUMENDE
		ZP1->ZP1_COMPLE := M->RA_COMPLEM
		ZP1->ZP1_MUNICI := M->RA_MUNICIP
		ZP1->ZP1_CEP    := M->RA_CEP
		ZP1->ZP1_BAIRRO := M->RA_BAIRRO 
		ZP1->ZP1_ESTADO := M->RA_ESTADO  
		ZP1->ZP1_PAISOR := "BR   "
				
	MsUnlock()

Lret := .T.

End Transaction

EndIf    

TMPZP1->(DbCloseArea())

RestArea(aAreaSRA)
RestArea(aAreaSRF)
RestArea(aAreaGeral)

//Return(.T.)
Return(Lret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fEfetivaAdmissao º Autor  ³ Tania Bronzeri        º Data ³ 19/01/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava a efetivacao da Pre-Admissao na PA6.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - Rotina Pre-Admissao                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fEfetivaAdmissao()
Local aAreaPA6	:= GetArea()
                 
DBSelectArea("PA6")
DbSetOrder(1)
If PA6->(DbSeek(xFilial("PA6")+M->RA_MAT))
	Reclock("PA6")
	PA6->PA6_INTEGR := "I"
	PA6->(MsUnlock())
EndIf

RestArea(aAreaPA6)
Return



