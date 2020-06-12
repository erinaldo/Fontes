#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA10   º Autor ³ Andy               º Data ³  26/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Classificaco da Natureza do SE2 Contas a Pagar             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA10()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   aArea := GetArea() 
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private aAcho := {}
Private aCpos := {}                        
lAltera:=.T.
aMemos := {}                                           

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SE2")
aHeader:={}

/*
While !Eof() .And. (x3_arquivo == "SE2")
//	IF X3USO(x3_usado).And. AllTrim(x3_campo)$"E2_NATUREZ/E2_MULTNAT/E2_NATDESC/E2_LD/E2_BANCO/E2_AGEFOR/E2_DVFOR/E2_CTAFOR" 
IF X3USO(x3_usado) //.And. AllTrim(x3_campo) 
		AADD(aAcho, AllTrim(x3_campo))
	Endif
	dbSkip()
EndDo
*/
AADD(aCpos,"E2_NATUREZ")   
AADD(aCpos,"E2_NATDESC") 
//AADD(aCpos,"E2_MULTNAT") 
AADD(aCpos,"E2_MULNATU") 
AADD(aCpos,"E2_LD") 
AADD(aCpos,"E2_BANCO") 
AADD(aCpos,"E2_AGEFOR") 
AADD(aCpos,"E2_DVFOR") 
AADD(aCpos,"E2_CTAFORLD")

//AADD(aCpos,"E2_FLUXO")   

dbSelectArea("SE2")
dbSetOrder(1)

cCadastro := "Natureza de Contas a Pagar"
aCores    := {}
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar" ,"U_NatVis"  , 0 , 2},;
{"Natureza"   ,"U_Nature"   , 0 , 4},;
{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Natureza a Reclassificar"},{"BR_VERMELHO","Natureza Reclassificada"}})',0 , 4 }}


Aadd( aCores, { "ALLTRIM(E2_NATUREZ) == '9.99.99' "  	, "BR_VERDE" 	 	} )
Aadd( aCores, { "!Empty(E2_NATUREZ) " 	, "BR_VERMELHO"		} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE2",,,,,2, aCores)

Return               

User Function NatVis()                                              
 AxVisual('SE2',Recno(),2,aAcho,aCpos)
Return
                                                               	
User Function Nature()                                              
 AxAltera("SE2",Recno(),4,aAcho,aCpos,,,'ExecBlock("SE2SE5",.F.,.F.)')
Return

User Function SE2SE5()                             
_aArea:= GetArea()
dbSelectArea("SE5")
dbSetOrder(7)
If dbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA, .F.)
  While !EOF() .And. SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	RecLock("SE5", .F.)
	  SE5->E5_NATUREZ := M->E2_NATUREZ
	msUnLock()
    dbSkip()
  EndDo                                                
EndIf              
RestArea(_aArea)
Return(.T.)                                                                  
		