#INCLUDE "rwmake.ch"


/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2460  º Autor ³ EDNEI C. MAURIZ  º Data ³  08/01/07 1   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. para gravacao dos campos CC/ITEMD/CLVL no SD2(ITEM DA º±±
±±º          ³ Nota Fiscal                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico Projeto Contabilização do Faturamento           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MSD2460()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


SetPrvt("_AAMBIENTE,_CALIASATU,_NI,")

//+--------------------------------------------------------------+
//¦ Salva ambiente                                               ¦
//+--------------------------------------------------------------+
_aAmbiente:={}
SalvaAmbiente()

dbSelectArea("SC6")
dbsetorder(1)

If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
	
	dbSelectArea("SD2")
	RecLock("SD2",.F.)
	
	SD2->D2_CCUSTO  := SC6->C6_CCUSTO    //(cento de custo)
	SD2->D2_ITEMD   := SC6->C6_ITEMD        //(undidade de negocio/item)
	SD2->D2_CLVLDB  := SC6->C6_CLVLDB     //(operacao/classe de valor)
	
	MsUnlock()
	
Endif

//+--------------------------------------------------------------+
//¦ Restaura o ambiente                                 ¦
//+--------------------------------------------------------------+
RestAmbiente()

Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ SalvaAmb ¦ Autor ¦                                                    ¦ Data ¦                           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Salva o ambiente atual                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function SalvaAmbiente()
_cAliasAtu:=Alias()
for _ni := 1 to Len(_aAmbiente)
	dbSelectArea(_aAmbiente[_ni,1])
	AADD(_aAmbiente[_ni],indexord())
	AADD(_aAmbiente[_ni],recno())
next
Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ RestAmb  ¦ Autor ¦                                                              . ¦ Data ¦              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Restaura o ambiente salvo                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 20/06/01 ==> Function RestAmbiente
Static Function RestAmbiente()
for _ni:=1 to Len(_aAmbiente)
	dbSelectArea(_aAmbiente[_ni,1])
	dbSetOrder(_aAmbiente[_ni,2])
	dbGoto(_aAmbiente[_ni,3])
next
dbSelectArea(_cAliasAtu)
Return

/*FIM======================================================================== */

User Function AtuSD2()
                             
If Aviso("ENTIDADES NA NF",'Deseja executar o acerto das entidades?',;
	{"&Fechar","Processar"},3,"Itens de NF",,;
	"PCOLOCK") == 1
	Return  
EndIf

Processa( { || AtuSD2a() }, 'Atualizando...' )

Return

Static Function AtuSD2a()

Local nProcs     := 0
Local nAcertados := 0

SC6->( DbSetOrder(1) )
	
DbSelectArea('SD2')
DbSetOrder(5)
Set Filter To &("DTOS(D2_EMISSAO) >= '20071108'")
DbGoTop()	
//SD2->( DbSeek( '0120071108',.t. ) )

ProcRegua( 200 )

While !SD2->( Eof() ) //.And. SD2->( D2_FILIAL+DTOS(D2_EMISSAO) ) >= '0120071108'

    If nProcs == 200
       ProcRegua(200)
       nProcs := 0
    EndIf
    
    IncProc( SD2->D2_FILIAL+' - '+Dtoc(SD2->D2_EMISSAO) )
    
    If Dtos(SD2->D2_EMISSAO) < '20071108'
       SD2->( DbSkip() )
       Loop
    EndIf
    
    nProcs ++
	
	If SC6->( DbSeek( SD2->(D2_FILIAL+D2_PEDIDO+D2_ITEMPV) ) )
	
	    nAcertados ++
		
		DbSelectArea("SD2")
		RecLock("SD2",.F.)		
		SD2->D2_CCUSTO  := SC6->C6_CCUSTO    //(cento de custo)
		SD2->D2_ITEMD   := SC6->C6_ITEMD        //(undidade de negocio/item)
		SD2->D2_CLVLDB  := SC6->C6_CLVLDB     //(operacao/classe de valor)		
		MsUnlock()
		
	Endif
	
	SD2->( DbSkip() )
	
EndDo

Aviso("NOTAS FISCAIS",'Termino de execucao. Itens alteradas: '+Str( nAcertados ),;
	{"&Fechar"},3,"Acerto dos Itens",,;
"PMSAPONT")

Return