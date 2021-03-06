#INCLUDE "rwmake.ch"


/*/
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  � MSD2460  � Autor � EDNEI C. MAURIZ  � Data �  08/01/07 1   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Descricao � P.E. para gravacao dos campos CC/ITEMD/CLVL no SD2(ITEM DA 艮�
臼�          � Nota Fiscal                                                艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � Espec�fico Projeto Contabiliza艫o do Faturamento           艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼臼�
烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝烝�
/*/

User Function MSD2460()


//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� Declaracao de Variaveis                                             �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�


SetPrvt("_AAMBIENTE,_CALIASATU,_NI,")

//+--------------------------------------------------------------+
//� Salva ambiente                                               �
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
//� Restaura o ambiente                                 �
//+--------------------------------------------------------------+
RestAmbiente()

Return()

/*/
_____________________________________________________________________________
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
Ζ+-----------------------------------------------------------------------+Ζ
Ζ�Fun艢o    � SalvaAmb � Autor �                                                    � Data �                           Ζ�
Ζ+----------+------------------------------------------------------------Ζ�
Ζ�Descri艢o � Salva o ambiente atual                                     Ζ�
Ζ+----------+------------------------------------------------------------Ζ�
Ζ�Uso       � Generico                                                   Ζ�
Ζ+-----------------------------------------------------------------------+Ζ
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
�����������������������������������������������������������������������������
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
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
Ζ+-----------------------------------------------------------------------+Ζ
Ζ�Fun艢o    � RestAmb  � Autor �                                                              . � Data �              Ζ�
Ζ+----------+------------------------------------------------------------Ζ�
Ζ�Descri艢o � Restaura o ambiente salvo                                  Ζ�
Ζ+----------+------------------------------------------------------------Ζ�
Ζ�Uso       � Generico                                                   Ζ�
Ζ+-----------------------------------------------------------------------+Ζ
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
�����������������������������������������������������������������������������
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