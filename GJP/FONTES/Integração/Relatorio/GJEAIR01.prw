#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "fileio.ch"
 
User Function GJEAIR01()

//SELECT XX3_UUID, R_E_C_N_O_, ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024), XX3_TRANS)),'')  
//FROM XX3040 AS XX3
//WHERE ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024), XX3_TRANS)),'') LIKE '%VENDA|25|61|61|1452342%'

Local oProcess//incluํdo o parโmetro lEnd para controlar o cancelamento da janelao
LOCAL cPerg	:= "GJEAIR01  "

Default lEnd := .F.

P12M01SX1(cPerg)
If !Pergunte(cPerg,.T.)
	msginfo("Rotina Cancelada")
	Return()
EndIf

oProcess := MsNewProcess():New({|lEnd| GEAI01Exec(@oProcess, @lEnd) },"Analise EAI - Falhas","Lendo Registros do EAI - XX3",.T.) 

oProcess:Activate()

Return                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJEAIR01  บAutor  ณMicrosiga           บ Data ณ  12/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GEAI01Exec(oProcess, lEnd)

Local cObserv     := ""
Local cObserv2    := ""
Local aObserv     := {} 
Local cAliasTrb   := GetNextAlias()
Local cFile
Local _nI
Local cMask
Local cTexto := ""
  
cQ:= "SELECT XX3_CODIGO, XX3_UUID, XX3_TRDATA, XX3_TRHORA, XX3_FUNCOD "
cQ+= "FROM " +RetSqlName("XX3") + " XX3 "
cQ+= "WHERE D_E_L_E_T_ = '' AND XX3_TPTRAN = '0' AND XX3_STATUS = '3' "
If alltrim(mv_par01) <> "TODAS"
	cQ+= "AND XX3_FUNCOD = '"+alltrim(mv_par01)+"' "
EndIf
cQ+= "ORDER BY XX3_CODIGO "
cQ := ChangeQuery(cQ)		
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

//TcSetField(cAliasTrb,"XX3_TRDATA","D",8, 0 )

nCount := (cAliasTrb)->(RecCount())
oProcess:SetRegua1(nCount)

Do While (cAliasTrb)->(!EOF())

	If lEnd	//houve cancelamento do processo		
		Exit	
	EndIf	       	

	oProcess:IncRegua1("XX3 " )
	
	DbSelectArea("SXH")
	DbSetOrder(2)//EMPRESA+FILIAL+CANAL+CARGO

	If DbSeek(cEmpAnt+cFilAnt+"    002"+(cAliasTrb)->(XX3_UUID))
		_cUUID := (cAliasTrb)->(XX3_UUID)

		nCountSXH := SXH->(RecCount()) 
		oProcess:SetRegua2(nCountSXH)	

		Do While _cUUID == alltrim(SXH->XH_CARGO)
			
			oProcess:IncRegua2("SXH ")
			
			If alltrim(SXH->XH_TITLE) == "Falhou"
				cObserv  := substr(SXH->XH_MESSAGE,1,250)
			Endif
				
			SXH->(DbSkip())
		EndDo
		cObserv2 := ""
		For i := 1 to Len(cObserv)
			if substr(cObserv,i,2)  == chr(13)+chr(10)
				LOOP
			Elseif substr(cObserv,i,1)  == chr(13) .or. substr(cObserv,i,1)  == chr(10)
				LOOP
			EndIf
			cObserv2+= substr(cObserv,i,1)
		Next
		aadd(aObserv,{alltrim((cAliasTrb)->XX3_CODIGO),alltrim((cAliasTrb)->XX3_TRDATA),alltrim((cAliasTrb)->XX3_TRHORA),alltrim((cAliasTrb)->XX3_UUID), alltrim((cAliasTrb)->XX3_FUNCOD),alltrim(substr(cObserv2,1,250))})
	EndIf
	(cAliasTrb)->(DbSkip())
EndDo

/*
If !Empty(aObserv)
  // Abre o arquivo
  nHandle := fopen('c:\temp\XX3040.txt' , FO_READWRITE + FO_SHARED )
  If nHandle == -1
    MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
  Else
    FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
    FWrite(nHandle, "CODIGO;DATA;HORA;UUDI;MENSAGEM;ERRO;"+chr(13)+chr(10)) // Insere texto no arquivo
	For _nI := 1 to len(aObserv)
	    FWrite(nHandle, aObserv[_nI,1]+";"+aObserv[_nI,2]+";"+aObserv[_nI,3]+";"+aObserv[_nI,4]+";"+aObserv[_nI,5]+";"+aObserv[_nI,6]+";"+chr(13)+chr(10)) // Insere texto no arquivo
	Next _nI
    fclose(nHandle)                   // Fecha arquivo
    MsgAlert('Processo concluํdo')
  Endif

Else
	Msginfo("Nใo houve registros para processamento!")
EndIf
*/

cObserv:= "CODIGO;DATA;HORA;UUDI;MENSAGEM;ERRO;"+chr(13)+chr(10) // Insere texto no arquivo

For _nI := 1 to len(aObserv)
    cObserv+= aObserv[_nI,1]+";"+aObserv[_nI,2]+";"+aObserv[_nI,3]+";"+aObserv[_nI,4]+";"+aObserv[_nI,5]+";"+aObserv[_nI,6]+";"+chr(13)+chr(10) // Insere texto no arquivo
Next _nI

If msgyesno("Confirma a exporta็ใo do arquivo para .csv?")
	cTexto += cObserv
	//cFileLog := MemoWrite( CriaTrab( , .F. ) + ".csv", cTexto )
//	cFile := cGetFile( cMask, "O arquivo serแ salvo como '.csv'",0,"SERVIDOR\",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	cFile := cGetFile( cMask, "O arquivo serแ salvo como '.csv'",0,"C:\",.F.,GETF_LOCALHARD)
	If !empty(cFile)
		MemoWrite( cFile+".csv", cTexto )
		msginfo("Arquivo salvo com sucesso no caminho "+alltrim(cFile)+".csv")
	EndIf
EndIf
	
(cAliasTrb)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJEAIR01  บAutor  ณMicrosiga           บ Data ณ  12/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION P12M01SX1(cPerg)
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , ;
             'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , ;
             'X1_VAR01'  , 'X1_DEF01'  , 'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , ;
             'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', 'X1_CNT02'  , ;
             'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , ;
             'X1_VAR04'  , 'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , ;
             'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', 'X1_DEFENG5', 'X1_CNT05'  , ;
             'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

//Consulta Padrใo SX5EAI na tabela SX5 - ZZ
AADD(aDados,{cPerg,'01','Mensagem EAI?','Mensagem EAI?','Mensagem EAI?','MV_CH1','C',50,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','SX5EAI','','','','',''} )

// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Rotina de Consulta Mensagens com FALHA (Status = 3 ) no EAI. Selecione o tipo de Mensagem ou deixe como TODOS para pegar todas as mensagens com Falha.'},{''},{''}})

	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	
EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN