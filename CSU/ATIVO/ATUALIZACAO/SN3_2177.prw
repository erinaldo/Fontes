// Programa criado para atender a requisi��o da ordem de servi�o 2177/10 onde o departamento do ativo fixo deseja utilizar a rotina de transferencia para
// as entidades cont�beis - Unidade de neg�cio e Opera��o (classe de valor e item cont�bil) na rotina de transferencia. Contudo, os campos utilizados na
// implanta��o do m�dulo, n�o eram as entidades relacionadas ao bem e sim a despesa. Para isso, precisamos rodar esta rotina para atualizar o caompo 
// correto nas tabelas do Ativo SN3.
// David Gomes Cardoso Junior - 13.10.2010

#Include 'Rwmake.ch'

User Function SN3_2177()
If !MsgBox('Deseja realizar o ajuste do conte�do dos campos de Unidade de Neg�cio e Opera��o?','Ajusta SN3 OS 2177/10','YesNo')
   Return
EndIf

Processa( { || OkProc() }, "Efetuando Update" )

Return

Static Function OkProc()
SN3->( DbSetOrder(1) )
ProcRegua( SN1->( RecCount() ) )

While !SN3->( Eof() )
    IncProc()   
    If SN3->( DbSeek( SN3->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ) ) )
       TcSqlExec(" UPDATE "+RetSqlName("SN3")+" SET N3_SUBCCON = '"+SN3->N3_SUBCTA+"' WHERE R_E_C_N_O_ = "+Str( SN3->( Recno() ) ) )
       TcSqlExec(" UPDATE "+RetSqlName("SN3")+" SET N3_CLVLCON = '"+SN3->N3_CLVL+"' WHERE R_E_C_N_O_ = "+Str( SN3->( Recno() ) ) )
    EndIf
	SN3->( DbSkip() )
EndDo

Alert( "Comando Finalizado" )

Return