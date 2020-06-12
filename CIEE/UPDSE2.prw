#Include 'Protheus.ch'

User Function UPDSE2()
Local oProcess
Private nHandle := FCREATE("C:\temp\CIEE\LOG_SE2.txt")
Private cTexto := "SE2_17;SE2_PRODUCAO;SE2_17_NATUREZA;SE2_PRD_NATUREZA"

if nHandle = -1
    alert("Erro ao criar arquivo - ferror " + Str(Ferror()))
else
    FWrite(nHandle, cTexto + Chr(13)+Chr(10))
endif
    
dbUseArea(.T., 'DBFCDXADS', '\1-TOTVS\EMERSON\SE2_17.DBF', 'SE217', .T., .F.)
cIndex1 := CriaTrab(Nil, .F.)
IndRegua("SE217", cIndex1, "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA", , , "Selecionando Registros...")
dbSelectArea('SE217')
SE217->(DbGotop())

/*
dbUseArea(.T., 'DBFCDXADS', '\1-TOTVS\EMERSON\SE2_21.DBF', 'SE221', .T., .F.)
cIndex2 := CriaTrab(Nil, .F.)
IndRegua("SE221", cIndex2, "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA", , , "Selecionando Registros...")
dbSelectArea('SE221')
SE221->(DbGotop())
*/

oProcess := MsNewProcess():New({|lEnd| xPROCAJ(@oProcess, @lEnd) },"Aguarde...SE2 dia 21","Processando registros SE2 dia 21...",.T.) 

oProcess:Activate()

FClose(nHandle)

Return
//
//
Static Function xPROCAJ(oProcess, lEnd)

Default lEnd := .F.

DbSelectArea('SE2')
DbSetOrder(1)
DbGotop()
nCountE2 := SE2->(RecCount())
oProcess:SetRegua1(nCountE2)

nCont := 1
Do While SE2->(!EOF())
    IF lEnd 
        MsgStop("Cancelado pelo usuário", "Atenção")
        Exit 
    ENDIF

	oProcess:IncRegua1("Tit-"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+"..reg-"+strzero(nCont,6))
	
	DbSelectArea('SE217')
	If DbSeek(xFilial('SE2')+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
		If SE217->(E2_NATUREZ) <> SE2->(E2_NATUREZ)
			cTexto := SE217->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+";"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+";"+SE217->(E2_NATUREZ)+";"+SE2->(E2_NATUREZ)
			FWrite(nHandle, cTexto + Chr(13)+Chr(10))
			RecLock("SE2",.F.)			
/*			SE2->E2_NATUREZ 	:= SE217->E2_NATUREZ
			SE2->E2_XREDUZ 		:= SE217->E2_XREDUZ
			SE2->E2_ITEMD 		:= SE217->E2_ITEMD
			SE2->E2_CCD 		:= SE217->E2_CCD
			SE2->E2_CLVLDB 		:= SE217->E2_CLVLDB
			SE2->E2_EC05DB 		:= SE217->E2_EC05DB
			SE2->E2_XCONTAB 	:= SE217->E2_XCONTAB
			SE2->E2_XCCUSTO 	:= SE217->E2_XCCUSTO
*/			MsUnLock()
		EndIf
	EndIf
	
	DbSelectArea('SE2')
	SE2->(DbSkip())
	nCont++
EndDo

cTexto:= strzero(nCont)
FWrite(nHandle, cTexto + Chr(13)+Chr(10))

alert('fim')

Return