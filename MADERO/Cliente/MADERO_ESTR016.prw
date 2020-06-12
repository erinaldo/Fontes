#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA    Chr(13)+Chr(10)

User Function ESTR016() 

Local oReport := nil
Private cPerg := PadR("ESTR016",10)

CriaSX1(cPerg)
Pergunte(cPerg,.F.)  


oReport := RptDef(cPerg)
oReport:PrintDialog()
Return

Static Function RptDef(cNome)
Local oReport := Nil
Local oSection1:= Nil
Local oSection2:= Nil
Local oSection3:= Nil
Local oBreak
Local oFunction

/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
oReport := TReport():New(cNome,"Relatório de Movimentação de Estoque",cNome,{|oReport| ReportPrint(oReport)},"Movimentação de Estoque")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

//Monstando a primeira seção
oSection1:= TRSection():New(oReport, "Movimentação de Estoque",{"TRBNCM"})
TRCell():New(oSection1,"FILIAL"		,"TRBNCM","FILIAL" 		,"@!",10)
TRCell():New(oSection1,"DESCFIL"  ,"TRBNCM","DESCRICAO"	,"@!",40)

//Segunda seção, será apresentado os produtos
oSection2:= TRSection():New(oReport, "Produtos", "TRBNCM")
TRCell():New(oSection2,"PRODUTO"   	,"TRBNCM","Produto"		,"@!",30)
TRCell():New(oSection2,"DESCRICAO" 	,"TRBNCM","Descrição"	,"@!",50)
  
//Terceira Secao - Detalhes
oSection3:= TRSection():New(oReport, "Detalhes", "TRBNCM")
TRCell():New(oSection3,"EMISSAO"	,"TRBNCM","Emissão"		,PesqPict("SB1","B1_DATREF"), 12)
TRCell():New(oSection3,"GRUPO" 		,"TRBNCM","Tp. Movimentação"		,"@!",16)
TRCell():New(oSection3,"DESCGRP"	,"TRBNCM","Descrição"	,"@!",40)
TRCell():New(oSection3,"POSINI"		,"TRBNCM","Qtde Movim.(UN)"	,"@E 9999999.9999",12)
TRCell():New(oSection3,"PRMEDINI"	,"TRBNCM","Custo Unit.(R$)"	,"@E 9,999,999,999.9999",12)
TRCell():New(oSection3,"POSINIVL"	,"TRBNCM","Sld.Estoque(UN)","@E 9999999.9999",12)
TRCell():New(oSection3,"DIFERENCA"	,"TRBNCM","Custo Total(R$)","@E 9,999,999,999.9999",12)
TRCell():New(oSection3,"ESTOQUE"	,"TRBNCM","Sld.Estoque(R$)","@E 9,999,999,999.9999",12)
TRCell():New(oSection3,"CMEDIO"		,"TRBNCM","Custo.Medio(R$)","@E 9,999,999,999.9999",12)

oBreak1 := TRBreak():New(oSection2,oSection2:Cell("PRODUTO"),"Subtotal por Produto")
TRFunction():New(oSection3:Cell("POSINI"),NIL,"ONPRINT",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection3:Cell("POSINIVL"),,"ONPRINT",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection3:Cell("PRMEDINI"),,"ONPRINT",oBreak1,,,,.F.,.F.)
TRFunction():New(oSection3:Cell("ESTOQUE"),,"ONPRINT",oBreak1,,,,.F.,.F.)

Return(oReport)

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local cQuery        := ""
Local cQuer2        := ""
Local cFilialE  := ""
Local cProd 	:= ""
Local lPrim 	:= .T.
Local cLocal := ""
Local nQtdMov := 0 
Local nEsti_un := 0
Local nVi_cm1  := 0
Local nEstf_un := 0
Local nVf_cm1  := 0  
Local nVifim := 0 
Local nSldEst := 0 
Local aRetorno := {}
Local sDateFim 
Local cAnob 
Local nAnoI
Local nCont := 0 
Local cData :=""
Local cGrupo :=""
Private oSection3 := oReport:Section(3)
//Monto minha consulta conforme parametros passado
//Pegando os dados
cQuery := " SELECT "                       + STR_PULA
cQuery += "     filial,                   "+ STR_PULA
cQuery += "     emissao,                  "+ STR_PULA
cQuery += "     produto,                  "+ STR_PULA
cQuery += "     descricao,                "+ STR_PULA
cQuery += "     grupo,                    "+ STR_PULA
cQuery += "     estoque,                  "+ STR_PULA
cQuery += "     SUM(quant_compras) qt_comp,            "+ STR_PULA
cQuery += "     SUM(total_compras) tl_comp,            "+ STR_PULA
cQuery += "     SUM(bonif_compras) bf_comp,            "+ STR_PULA
cQuery += "     SUM(bonif_total) bf_total,              "+ STR_PULA
cQuery += "     SUM(transf_compras) tf_comp,           "+ STR_PULA
cQuery += "     SUM(transf_total) tf_total,             "+ STR_PULA
cQuery += "     SUM(total_entradas_un) t_ent_un,        "+ STR_PULA
cQuery += "     SUM(total_entradas_r) t_ent_r,         "+ STR_PULA
cQuery += "     SUM(cons_vendas_un) c_vd_un,           "+ STR_PULA
cQuery += "     SUM(cons_vendas_r) c_vd_r,            "+ STR_PULA
cQuery += "     SUM(evento_prime_durski_un) ep_dk_un,   "+ STR_PULA
cQuery += "     SUM(evento_prime_durski_r) ep_dk_r,    "+ STR_PULA
cQuery += "     SUM(total_conso_vendas_un) tcsv_un,    "+ STR_PULA
cQuery += "     SUM(total_conso_vendas_r) tcsv_r,     "+ STR_PULA
cQuery += "     SUM(ret_marqueting_ind_un) Rm_ind_un,    "+ STR_PULA
cQuery += "     SUM(ret_marqueting_ind_r) Rm_ind_r,     "+ STR_PULA
cQuery += "     SUM(perda_qual_ind_un) pq_ind_un,        "+ STR_PULA
cQuery += "     SUM(perda_qual_ind_r) pq_ind_r,         "+ STR_PULA
cQuery += "     SUM(ret_troca_desist_un) tc_des_un,      "+ STR_PULA
cQuery += "     SUM(ret_troca_desist_r) tc_des_r,       "+ STR_PULA
cQuery += "     SUM(ret_merc_danif_un) me_danif_un,        "+ STR_PULA
cQuery += "     SUM(ret_merc_danif_r) me_danif_r,         "+ STR_PULA
cQuery += "     SUM(ret_sob_pre_prep_un) s_pprep_un,      "+ STR_PULA
cQuery += "     SUM(ret_sob_pre_prep_r) s_pprep_r,       "+ STR_PULA
cQuery += "     SUM(ret_falha_salao_un) fa_salao_un,       "+ STR_PULA
cQuery += "     SUM(ret_falha_salao_r) fa_salao_r,        "+ STR_PULA
cQuery += "     SUM(falha_cozinha_bar_un) fa_c_bar_un,     "+ STR_PULA
cQuery += "     SUM(ret_desp_validade_un) dp_val_un,     "+ STR_PULA
cQuery += "     SUM(falha_cozinha_bar_r) fa_c_bar_r,      "+ STR_PULA
cQuery += "     SUM(ret_desp_validade_r) dp_val_r,      "+ STR_PULA
cQuery += "     SUM(ret_desp_descong_un) ddesc_un,      "+ STR_PULA
cQuery += "     SUM(ret_desp_descong_r) ddesc_r,       "+ STR_PULA
cQuery += "     SUM(total_desp_un) t_desp_un,            "+ STR_PULA
cQuery += "     SUM(total_desp_r) t_desp_r,             "+ STR_PULA
cQuery += "     SUM(aj_conso_vendas_un) aj_c_v_un,       "+ STR_PULA
cQuery += "     SUM(aj_conso_vendas_r) aj_c_v_r,        "+ STR_PULA
cQuery += "     SUM(AJ_INVENTARIO_UN) AJ_INV_UN,         "+ STR_PULA
cQuery += "     SUM(AJ_INVENTARIO_R) AJ_INV_R,          "+ STR_PULA
cQuery += "     SUM(tot_desp_ajustes_un) t_dp_aj_un,      "+ STR_PULA
cQuery += "     SUM(tot_desp_ajustes_r) t_dp_aj_r,       "+ STR_PULA
cQuery += "     SUM(ret_testes_un) r_test_un,            "+ STR_PULA
cQuery += "     SUM(ret_testes_r) r_test_r,             "+ STR_PULA
cQuery += "     SUM(ret_prime_durski_un) r_pd_un,      "+ STR_PULA
cQuery += "     SUM(ret_prime_durski_r) r_pd_r,       "+ STR_PULA
cQuery += "     SUM(retirada_secos_un) r_secos_un,        "+ STR_PULA
cQuery += "     SUM(retirada_secos_r) r_secos_r,         "+ STR_PULA
cQuery += "     SUM(tot_cons_aj_secos_un) tcaj_sec_un,     "+ STR_PULA
cQuery += "     SUM(tot_cons_aj_secos_r) tcaj_sec_r,      "+ STR_PULA
cQuery += "     SUM(ret_limpeza_un) r_limp_un,           "+ STR_PULA
cQuery += "     SUM(ret_limpeza_r) r_limp_r,            "+ STR_PULA
cQuery += "     SUM(desp_limpeza_un) d_limp_un,          "+ STR_PULA
cQuery += "     SUM(desp_limpeza_r) d_limp_r,           "+ STR_PULA
cQuery += "     SUM(tot_cons_desp_limpeza_un) tcdl_un, "+ STR_PULA
cQuery += "     SUM(tot_cons_desp_limpeza_r) tcdl_r,  "+ STR_PULA
cQuery += "     SUM(ret_enxoval_un) r_enxo_un,           "+ STR_PULA
cQuery += "     SUM(ret_enxoval_r) r_enxo_r,            "+ STR_PULA
cQuery += "     SUM(tot_ret_aj_enxoval_un) traje_un,    "+ STR_PULA
cQuery += "     SUM(tot_ret_aj_enxoval_r) traje_r,     "+ STR_PULA
cQuery += "     SUM(ret_uso_consumo_un) r_uso_c_un,       "+ STR_PULA
cQuery += "     SUM(ret_uso_consumo_r) r_uso_c_r,        "+ STR_PULA
cQuery += "     SUM(desp_uso_consumo_un) ds_cons_un,      "+ STR_PULA
cQuery += "     SUM(desp_uso_consumo_r) ds_cons_r,       "+ STR_PULA
cQuery += "     SUM(tot_cons_desp_uso_cons_un) tcds_c_un,"+ STR_PULA
cQuery += "     SUM(tot_cons_desp_uso_cons_r) tcds_c_u_r, "+ STR_PULA
cQuery += "     SUM(cons_al_func_un) c_al_fc_un,          "+ STR_PULA
cQuery += "     SUM(cons_al_func_r) c_al_fc_r,           "+ STR_PULA
cQuery += "     SUM(sobra_al_func_un) sal_fc_un,         "+ STR_PULA
cQuery += "     SUM(sobra_al_func_r) sal_fc_r,          "+ STR_PULA
cQuery += "     SUM(desperdicio_al_func_un) dal_fc_un,   "+ STR_PULA
cQuery += "     SUM(desperdicio_al_func_r) dal_fc_r,    "+ STR_PULA
cQuery += "     SUM(total_consumo_func_un) tc_fc_un,    "+ STR_PULA
cQuery += "     SUM(total_consumo_func_r) tc_fc_r,     "+ STR_PULA
cQuery += "     SUM(retirada_uniformes_un) r_unif_un,    "+ STR_PULA
cQuery += "     SUM(retirada_uniformes_r) r_unif_r,     "+ STR_PULA
cQuery += "     SUM(total_ajustes_unif_un) taj_unif_un,    "+ STR_PULA
cQuery += "     SUM(total_ajustes_unif_r) taj_unif_r,     "+ STR_PULA
cQuery += "     SUM(saida_venda_un) s_venda_un,           "+ STR_PULA
cQuery += "     SUM(saida_venda_r) s_venda_r,            "+ STR_PULA
cQuery += "     SUM(saida_transf_un) s_tf_un,          "+ STR_PULA
cQuery += "     nome_filial,               "+ STR_PULA
cQuery += "     SUM(SAIDA_DEVOLUCAO_UN) S_DEV_UN,     "+ STR_PULA
cQuery += "     SUM(SAIDA_DEVOLUCAO_R) S_DEV_R,      "+ STR_PULA
cQuery += "     SUM(total_saidas_un) t_sai_un,          "+ STR_PULA
cQuery += "     SUM(total_saidas_r) t_sai_r           "+ STR_PULA
cQuery += " FROM                          "+ STR_PULA
cQuery += "     vw_movestoque             "+ STR_PULA
cQuery += "     where filial between '"+MV_PAR01+"' AND '"+MV_PAR02+"' and emissao  between '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "+ STR_PULA
if !empty(MV_PAR05)
	cQuery += " AND Grupo between  '"+MV_PAR05+"' AND  '"+MV_PAR06+"' "+ STR_PULA
Endif 
if !empty(MV_PAR07)
	cQuery += " AND produto between  '"+MV_PAR07+"' AND  '"+MV_PAR08+"' "+ STR_PULA
Endif
cQuery += " GROUP BY     filial,emissao, produto, descricao, grupo, estoque,  nome_filial             "+ STR_PULA
cQuery += " ORDER BY    filial  ,produto, emissao  "
//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TRBNCM") <> 0
	DbSelectArea("TRBNCM")
	DbCloseArea()
ENDIF

//crio o novo alias
TCQUERY cQuery NEW ALIAS "TRBNCM"
//Memowrite("c:\temp\ESTR016.txt",CQuery)
dbSelectArea("TRBNCM")
TRBNCM->(dbGoTop())

oReport:SetMeter(TRBNCM->(LastRec()))

//Irei percorrer todos os meus registros
While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection1:Init()
	
	oReport:IncMeter()
	
	IncProc("Imprimindo "+alltrim(TRBNCM->FILIAL))
	
	If cFilialE != TRBNCM->FILIAL
		cFilialE 	:= TRBNCM->FILIAL
		//imprimo a primeira seção
		oSection1:Cell("FILIAL"):SetValue(TRBNCM->FILIAL)
		oSection1:Cell("DESCFIL"):SetValue(TRBNCM->nome_filial)
		oSection1:Printline()
	EndIf
	
	//inicializo a segunda seção
	oSection2:init()
	
	If cProd != TRBNCM->PRODUTO
		//imprimo a segunda seção
		cProd 	:= TRBNCM->PRODUTO
		oSection2:Cell("PRODUTO"):SetValue(TRBNCM->PRODUTO)
		oSection2:Cell("DESCRICAO"):SetValue(TRBNCM->DESCRICAO)
		oSection2:Printline()
	EndIf
	
	//inicializo a terceira seção
	oSection3:init()
	
	//verifico se o codigo d é mesmo, se sim, imprimo o produto
	While TRBNCM->FILIAL == cFilialE .and. TRBNCM->PRODUTO == cProd
		oReport:IncMeter()
		//   inicio
		nCont++
		nEsti_un := 0
		nVi_cm1  := 0
		nEstf_un := 0
		nVf_cm1  := 0    
		cLocal := GetAdvFVal("SB2","B2_LOCAL",TRBNCM->FILIAL+TRBNCM->PRODUTO,1,"Erro")
	   	aRetorno := CalcEst(TRBNCM->PRODUTO,cLocal,STOD(TRBNCM->EMISSAO))
		nEsti_un := aRetorno[1]//Quantidade inicial em estoque na data
		nVi_cm1  := aRetorno[2]/aRetorno[1] //preco medio    
		nVifim := aRetorno[2]
		sDateFim := DTOS(MV_PAR04)
		
		cAnob := val(substr(sDateFim, 1, 4))/4
		nAnoI := INT(cAnob)
		if cAnob == nAnoI                                                                                     
			if substr(sDateFim,7,2) == "29"
				sDateFim := StoD(substr(sDateFim, 1, 4)+StrZero(val(substr(sDateFim, 5, 2))+1,2)+"01")
			Else
				sDateFim := StoD(substr(sDateFim, 1, 6)+StrZero(val(substr(sDateFim, 7, 2))+1,2))
			EndIf
		Else
			if substr(sDateFim,7,2) == "31" .and. substr(sDateFim,5,2) $ ("01|03|05|07|08|10|12")
				sDateFim := StoD(substr(sDateFim, 1, 4)+StrZero(val(substr(sDateFim, 5, 2))+1,2)+"01")
			Else
				sDateFim := StoD(substr(sDateFim, 1, 6)+StrZero(val(substr(sDateFim, 7, 2))+1,2))
			EndIf
		Endif
		
	   	aRetorno := CalcEst(TRBNCM->PRODUTO,cLocal,sDateFim)
		nEstf_un := aRetorno[1]//Quantidade inicial em estoque na data
		nVf_cm1  := aRetorno[2]/aRetorno[1]//preco medio
			
		//fim
		//VAlidações de campos a serem incluidos nos detalhes do relatorio. Só irão aparecer caso sejam > 0.
		  
		If nCont ==1  //imprime estoque inicial somente 01 vez independente de data. 
			//Estoque Inicial(UN)  - obrigatorio mesmo que seja valores = 0(zer0)
			ImpSect3(STOD(TRBNCM->EMISSAO),"Estoque Inicial","",nQtdMov,nEsti_un,nVi_cm1,nVifim)//data inicial/grupo/descri/qtd mov/qdt ini / vlr medio 
			nSldEst := nEsti_un
		EndIf
		If TRBNCM->r_secos_un <> 0 // retirada secos
			nSldEst -= r_secos_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Secos",r_secos_un,nSldEst,nVi_cm1,nVifim) 
		EndIf   
		If TRBNCM->qt_comp <> 0 // quantidade Entrada Compra 
			nSldEst += qt_comp// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Entrada","Entrada Compra",qt_comp,nSldEst,nVi_cm1,nVifim) 
		EndIf 
		If TRBNCM->bf_comp <> 0 // quantidade Entrada Bonificacao   
		nSldEst += bf_comp// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Entrada","Entrada Bonificação",bf_comp,nSldEst,nVi_cm1,nVifim) 
		EndIf    
		If TRBNCM->tf_comp <> 0 // quantidade Entrada transferencia 
		nSldEst += tf_comp// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Entrada","Entrada Transferência",tf_comp,nSldEst,nVi_cm1,nVifim) 
		EndIf 
	   /*	If TRBNCM->t_ent_un <> 0 // quantidade Total Entradas   
		nSldEst += t_ent_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Entradas",t_ent_un,nEsti_un,nSldEst) 
		EndIf */
		If TRBNCM->c_vd_un <> 0 // quantidade Consolidação Vendas  
			nSldEst -= c_vd_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Consolidação Vendas",c_vd_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->ep_dk_un <> 0 // quantidade Evento Prime/Durski 
			nSldEst -= ep_dk_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Evento Prime/Durski",ep_dk_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		/*If TRBNCM->tcsv_un <> 0 // quantidade Total Consolidação de Vendas    
		nSldEst += tcsv_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Consolidação de Vendas",tcsv_un,nEsti_un,nSldEst) 
		EndIf*/
		If TRBNCM->Rm_ind_un <> 0 // quantidade Retirada Marketing (Indústria)   
		nSldEst -= Rm_ind_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Marketing (Indústria)",Rm_ind_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->pq_ind_un <> 0 // quantidade Retirada Qualidade (Indústria)  
			nSldEst -= pq_ind_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Qualidade (Indústria)",pq_ind_un,nSldEst,nVi_cm1,nVifim) 
		EndIf	
		If TRBNCM->tc_des_un <> 0 // quantidade Retirada troca/desist    
		nSldEst -= tc_des_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada troca/desist",tc_des_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->me_danif_un <> 0 // quantidade Retirada Mercadoria Danificada   
		nSldEst -= me_danif_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Mercadoria Danificada",me_danif_un,nSldEst,nVi_cm1,nVifim) 
		EndIf	
		If TRBNCM->s_pprep_un <> 0 // quantidade Retirada Sobra pre-preparo 
		nSldEst -= s_pprep_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Sobra pre-preparo",s_pprep_un,nSldEst,nVi_cm1,nVifim) 
		EndIf	
		If TRBNCM->fa_salao_un <> 0 // quantidade Retirada Falha Salão 
			nSldEst -= fa_salao_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Falha Salão",fa_salao_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->fa_c_bar_un <> 0 // quantidade Falha Cozinha/Bar 
			nSldEst -= fa_c_bar_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Falha Cozinha/Bar",fa_c_bar_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->dp_val_un <> 0 // Retirada Desperdicio por Validade 
		nSldEst -= dp_val_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Desperdicio por Validade",dp_val_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->ddesc_un <> 0 // Retirada Desperdicio por Descongelamento
		nSldEst -= ddesc_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Desperdicio por Descongelamento",ddesc_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->t_desp_un <> 0 // Total Desperdícios    
				nSldEst += t_desp_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Desperdícios",t_desp_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->aj_c_v_un <> 0 // Ajuste p/ Consolidação Venda 
		nSldEst += aj_c_v_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Entrada","Ajuste p/ Consolidação Venda",aj_c_v_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->AJ_INV_UN <> 0 // Ajustes de Inventário  
			 If TRBNCM->AJ_INV_UN  < 0 
			 	nSldEst -= NumNeg(AJ_INV_UN)// se for saida subtrai , se for entrada soma
				ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Ajustes de Inventário",NumNeg(AJ_INV_UN),nSldEst,nVi_cm1,nVifim) 
			 Else
				nSldEst += AJ_INV_UN// se for saida subtrai , se for entrada soma
				ImpSect3(STOD(TRBNCM->EMISSAO),"Entrada","Ajustes de Inventário",AJ_INV_UN,nSldEst,nVi_cm1,nVifim) 
			EndIf
		EndIf
		/*If TRBNCM->t_dp_aj_un <> 0 // Total Desperdícios+Ajustes 
			nSldEst += t_dp_aj_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Desperdícios+Ajustes",t_dp_aj_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->r_test_un <> 0 // Retirada Testes    
			nSldEst -= r_test_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Testes",r_test_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->r_pd_un <> 0 // Retirada Prime/Durski 
			nSldEst -= r_pd_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Prime/Durski",r_pd_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->r_secos_un <> 0 // Retirada Secos     
			nSldEst -= r_secos_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Secos",r_secos_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->tcaj_sec_un <> 0 // Total Consumo+Ajustes Secos   
		nSldEst += tcaj_sec_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Consumo+Ajustes Secos",tcaj_sec_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->d_limp_un <> 0 // Desperdicio Limpeza    
		nSldEst -= d_limp_un
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Desperdicio Limpeza",d_limp_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->tcdl_un <> 0 // Total Consumo+Desperdícios+Ajustes Limpeza  
			nSldEst += tcdl_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Tot.Consumo+Desperdícios+Ajustes Limpeza",tcdl_un,nEsti_un,nSldEst) 
		EndIf*/
		If TRBNCM->r_enxo_un <> 0 // Retirada Enxoval   
			nSldEst -= r_enxo_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Enxoval",r_enxo_un,nSldEst,nVi_cm1,nVifim) 
		EndIf			
		/*If TRBNCM->traje_un <> 0 // Total Retirada+Ajustes Enxoval  
			nSldEst += traje_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Retirada+Ajustes Enxoval",traje_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->r_uso_c_un <> 0 // Retirada Uso e Consumo 
		nSldEst -= r_uso_c_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Uso e Consumo",r_uso_c_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->ds_cons_un <> 0 // Desperdício Uso e Consumo   
			nSldEst -= ds_cons_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Desperdício Uso e Consumo",ds_cons_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		/*If TRBNCM->tcds_c_un <> 0 // Total Consumo+Desperdícios+Ajustes Uso e Consumo 
		nSldEst += tcds_c_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Tot.Cons.+Desperdício+Ajuste Uso/Consumo",tcds_c_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->c_al_fc_un <> 0 // Consumo Alimentação Funcionários
			nSldEst -= c_al_fc_un // se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Consumo Alimentação Funcionários",c_al_fc_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->sal_fc_un <> 0 // Sobra Alimentação Funcionários   
		nSldEst -= sal_fc_un // se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Sobra Alimentação Funcionários",sal_fc_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->dal_fc_un <> 0 //Desperdício Alimentação Funcionarios  
			nSldEst -= dal_fc_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Desperdício Alimentação Funcionarios",dal_fc_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->tc_fc_un <> 0 //Total Consumo+Sobras+Desperdícios+Ajustes Alimentação Funcionários    
		nSldEst += tc_fc_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Tot.Cons+Sobra+Desperdício+Ajuste Func.",tc_fc_un,nEsti_un,nSldEst) 
		EndIf*/
		If TRBNCM->r_unif_un <> 0 //Retirada Uniformes  
			nSldEst -= r_unif_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Retirada Uniformes",r_unif_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->taj_unif_un <> 0 //Total Retirada+Ajustes Uniformes    
			nSldEst += taj_unif_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Retirada+Ajustes Uniformes",taj_unif_un,nEsti_un,nSldEst) 
		EndIf*/		
		If TRBNCM->s_venda_un <> 0 //Saída - Venda   
		nSldEst -= s_venda_un// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Saída - Venda",s_venda_un,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		If TRBNCM->s_tf_un <> 0 //Saída - Transferência 
		nSldEst -= s_tf_un // se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Saída - Transferência",s_tf_un,nSldEst,nVi_cm1,nVifim) 
		EndIf
		If TRBNCM->S_DEV_UN <> 0 //Saída - Devolução   
			nSldEst -= S_DEV_UN// se for saida subtrai , se for entrada soma
			ImpSect3(STOD(TRBNCM->EMISSAO),"Saída","Saída - Devolução",S_DEV_UN,nSldEst,nVi_cm1,nVifim) 
		EndIf		
		/*If TRBNCM->t_sai_un <> 0 //Total Saidas  
				nSldEst += t_sai_un
			ImpSect3(STOD(TRBNCM->EMISSAO),TRBNCM->GRUPO,"Total Saidas",t_sai_un,nEsti_un,nSldEst) 
		EndIf*/	
		cData  := TRBNCM->EMISSAO	
		cGrupo := TRBNCM->GRUPO				
		TRBNCM->(dbSkip())//loop secao 3
	EndDo  
		
		//Estoque Final  Repete o valor do ultimo lancamento
		//nSldEst += nEstf_un
		ImpSect3(STOD(cData),"Estoque Final","",0,nSldEst,nVi_cm1,0) 	
		nCont := 0 
		nSldEst := 0
	//finalizo a terceira seção para que seja reiniciada para o proximo produto
	oSection3:Finish()
	//imprimo uma linha para separar um PRODUTO de outro
	oReport:ThinLine()
	
	//finalizo a segunda seção para que seja reiniciada para o proximo registro
	oSection2:Finish()
	//imprimo uma linha para separar uma NCM de outra
	//	oReport:ThinLine()
	//finalizo a primeira seção
	oSection1:Finish()
Enddo
Return

//---------------------------------------------------------------------
/*/{Protheus.doc} CriaSX1
Função para criação das perguntas na SX1

@author Jair  Matos
@since 16/10/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
Static Function CriaSX1(cPerg)
cValid   := ""
cF3      := ""
cPicture := ""
cDef01   := ""
cDef02   := ""
cDef03   := ""
cDef04   := ""
cDef05   := ""
U_XPutSX1(cPerg, "01", "Filial De?"			,"MV_PAR01", "MV_CH1", "C", 10,	0, "G", cValid,     "SM0",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Filial inicial")
U_XPutSX1(cPerg, "02", "Filial Até?"		,"MV_PAR02", "MV_CH2", "C", 10, 0, "G", cValid,     "SM0",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Filial final")
U_XPutSX1(cPerg, "03", "Emissao De?"		,"MV_PAR03", "MV_CH3", "D", 08,	0, "G", cValid,     cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Data inicial")
U_XPutSX1(cPerg, "04", "Emissao Até?"  		,"MV_PAR04", "MV_CH4", "D", 08, 0, "G", cValid,     cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a Data final")
U_XPutSX1(cPerg, "05", "Grupo De?"	   		,"MV_PAR05", "MV_CH5", "C", 04,	0, "G", cValid,     "SBM",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o Grupo inicial")
U_XPutSX1(cPerg, "06", "Grupo Até?"	   		,"MV_PAR06", "MV_CH6", "C", 04, 0, "G", cValid,     "SBM",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o Grupo final")
U_XPutSX1(cPerg, "07", "Produto De?"		,"MV_PAR07", "MV_CH7", "C", 15,	0, "G", cValid,     "SB1",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o Produto inicial")
U_XPutSX1(cPerg, "08", "Produto Até?"		,"MV_PAR08", "MV_CH8", "C", 15, 0, "G", cValid,     "SB1",   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o Produto final")

Return
//---------------------------------------------------------------------
/*/{Protheus.doc} ImpSect3(emissao,grupo,cDesc,nQtdMov,nQtdInic,nVlrMedi)
Função que imprime a section 3

@author Jair  Matos
@since 22/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
Static Function ImpSect3(emissao,grupo,cDesc,nQtdMov,nQtdInic,nVlrMedi,nVFim)//data inicial/grupo/descri/qtd mov/qdt ini / vlr medio

oSection3:Cell("EMISSAO"):SetValue(emissao)
oSection3:Cell("GRUPO"):SetValue(grupo)
oSection3:Cell("DESCGRP"):SetValue(cDesc)
oSection3:Cell("POSINI"):SetValue(nQtdMov)
oSection3:Cell("PRMEDINI"):SetValue(nVlrMedi)
oSection3:Cell("POSINIVL"):SetValue(nQtdInic) 
oSection3:Cell("DIFERENCA"):SetValue(nQtdMov*nVlrMedi)
oSection3:Cell("ESTOQUE"):SetValue(nQtdInic*nVlrMedi) 
oSection3:Cell("CMEDIO"):SetValue(nVFim/nQtdInic) 
oSection3:Printline()
Return 
//---------------------------------------------------------------------
/*/{Protheus.doc} NumNeg(nValor)
Função que modifica o valor

@author Jair  Matos
@since 30/11/2018
@version P12
@return Nil
/*/
//---------------------------------------------------------------------
STATIC Function NumNeg(nValor)
Local nValNeg := nValor*-1

Return(nValNeg)

