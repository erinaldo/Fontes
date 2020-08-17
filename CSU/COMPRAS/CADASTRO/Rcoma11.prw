#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rcoma11  บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro das opcoes de entregas para Pedidos de Compras.   บฑฑ
ฑฑบ          ณ O escopo esta relacionado a OS 0248/10.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcoma11()

Local cFunc       := "U_Rcoma11a"
Private cCadastro := "Op็๕es de Entrega"
PRIVATE aRotina   := { { 'Pesquisar'   ,'AxPesqui' , 0 , 2},;
{"Visualizar"      ,'AxVisual',0,2, 0, Nil},;
{"Incluir"         ,'AxInclui("ZA9",,,,,, "U_Rcoma11a()")',0,3},;
{"Alterar"         ,'AxAltera("ZA9",ZA9->(Recno()),4,,,,,"U_Rcoma11a()")',0,4},;
{"Excluir"         ,'U_Rcoma11b()',0,5} }

mBrowse( 6, 1,22,75,"ZA9")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcoma11a บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida se ja existe a opcao default no momento da confir-  บฑฑ
ฑฑบ          ณ macao.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcoma11a()

Local cVerifik, cTxtBlq, cExec
Local aAreaAnt  := GetArea()
Local cNxtAlias := GetNextAlias()
Local cEol      := Chr(13)+Chr(10)
Local lTrok     := .t.

cVerifik := " SELECT R_E_C_N_O_ AS RECN_O "+cEol
cVerifik += " FROM "+RetSqlName("ZA9")+cEol
cVerifik += " WHERE ZA9_FILIAL = '"+xFilial('ZA9')+"' "+cEol
cVerifik += " AND   ZA9_DEFAUL = 'S' "+cEol
If !Inclui
	cVerifik += " AND   R_E_C_N_O_ <> "+Str( ZA9->( Recno() ) )+cEol
EndIf
cVerifik += " AND   D_E_L_E_T_ = ' ' "+cEol

U_MontaView( cVerifik, cNxtAlias )

(cNxtAlias)->( DbGoTop() )

If (cNxtAlias)->RECN_O > 0 .And. M->ZA9_DEFAUL == 'S'
	
	ZA9->( DbGoTo( (cNxtAlias)->RECN_O ) )
	
	cTxtBlq := "Jแ existe uma op็ใo Default. A op็ใo atualmente Default ้ "+Trim(ZA9->ZA9_DESCRI)+". "
	cTxtBlq += "Deseja trocar a op็ใo Default para "+Trim(M->ZA9_DESCRI)+" ?"+cEol+cEol
	cTxtBlq += "Se voce confirmar a troca, a op็ใo "+Trim(ZA9->ZA9_DESCRI)+" deixara de ser Default! "
	
	If Aviso("OPวรO Jม EXISTENTE Recno("+AllTrim(Str((cNxtAlias)->RECN_O))+")",cTxtBlq,	{"&TROCAR","Desistir"},3,"op็ใo Default",,"PCOLOCK") == 1
		
		cExec := " UPDATE "+RetSqlName('ZA9')+" SET ZA9_DEFAUL = ' ' "
		cExec += " WHERE R_E_C_N_O_ = "+Str( (cNxtAlias)->RECN_O )
		
		If TcSqlExec( cExec ) # 0
			cTxtBlq := "Ocorreu um problema no momento da gravacao do valor default. "
			cTxtBlq += "Entre em contato com a area de Sistemas ERP informando a mensagem "
			cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
			Aviso("Gravacao do Default Recno("+AllTrim(Str((cNxtAlias)->RECN_O))+")",cTxtBlq,;
			{"&Fechar"},3,"Opcao Default",,;
			"PCOLOCK")
		EndIf
		
	Else
		
		lTrok := .f.
		
	EndIf
	
EndIf

(cNxtAlias)->( DbCloseArea() )
RestArea( aAreaAnt )

Return( lTrok )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcoma11b บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida se a opcao de entrega a ser excluida ja foi utiliza บฑฑ
ฑฑบ          ณ da em algum pedido de compra.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcoma11b()

Local cVerifik

cVerifik := " SELECT COUNT(*) AS OCORREN FROM "+RetSqlName('SC7')
cVerifiK += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cVerifik += " AND   C7_X_TENT  = '"+ZA9->ZA9_CODIGO+"' "
cVerifik += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cVerifik, "cPodeDel" )

cPodeDel->( DbGoTop() )

If cPodeDel->OCORREN > 0
    cTxtBlq := "Esta opcao ja foi utilizada. A operacao nao sera concluida. "
	Aviso("Opcao ja Utilizada em PC",cTxtBlq,;
	{"&Fechar"},3,"Exclusao nao Permitida",,;
	"PCOLOCK")
	Return(.f.)
EndIf

AxDeleta("ZA9",ZA9->(Recno()),5)

Return(.t.)