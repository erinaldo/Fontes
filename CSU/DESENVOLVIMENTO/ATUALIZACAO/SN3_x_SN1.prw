#Include 'Rwmake.ch'

User Function SN3_SN1()

If !MsgBox('Deseja executar o compatibilizador do Código de Grupo de Bens da SN1 para a SN3?','Historico SN1 x SN3','YesNo')
   Return
EndIf

Private cPerg := "SN3SN1"
Private aRegs := {}
//                      123456789.123456789.123456789.
AADD(aRegs,{cPerg,"01","Informe Path para gerar o LOG:","","","mv_ch1","C",70,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DIR","","","","",""})

U_ValidPerg( cPerg, aRegs )

If !Pergunte(cPerg,.t.)
    Return
EndIf

Private cLog     := 'SN3SN1-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
Private nCot     := FCreate( AllTrim(MV_PAR01)+cLog,1 )
Private cEol     := Chr(13)+Chr(10)
Fclose( nCot )
nCot := Fopen( AllTrim(MV_PAR01)+cLog,2 )

If nCot < 0
   MsgBox('O Path especificado nao existe.','Erro no Arquivo','Info')
   Fclose( nCot )
   Return
EndIf

Processa( { || OkProc() }, "Efetuando Update" )

Fclose( nCot )

Return

Static Function OkProc()

SN1->( DbSetOrder(1) )
SN3->( DbSetOrder(1) )

FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Inicio dado ao Log deste Processo..."+cEol+cEol )
FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Indice utilizado no SN1: "+Trim(SN1->(IndexKey()))+cEol )
FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Indice utilizado no SN3: "+Trim(SN3->(IndexKey()))+cEol )

SN1->( DbGoTop() )

ProcRegua( SN1->( RecCount() ) )

While !SN1->( Eof() )

    IncProc()
    
    lSN3 := SN3->( DbSeek( SN1->( N1_FILIAL+N1_CBASE+N1_ITEM ) ) )
    
FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - SN1 (Filial+cBase+Item) => ["+SN1->( N1_FILIAL+N1_CBASE+N1_ITEM )+"]-Encontrado no SN3? "+IIF( lSN3,"Sim","Nao" )+cEol )
    If lSN3
       nExec := TcSqlExec(" UPDATE "+RetSqlName("SN3")+" SET N3_GRUPO = '"+SN1->N1_GRUPO+"' WHERE R_E_C_N_O_ = "+Str( SN3->( Recno() ) ) )
FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+" - Tentativa de Update no SN3. Resultado: "+IIF( nExec==0,"Ok","Deu Erro => "+TcSqlError() )+cEol+cEol )
    EndIf

	SN1->( DbSkip() )

EndDo

Alert( "Processamento Finalizado." )

Return