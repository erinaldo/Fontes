#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FILEIO.CH"
/*---------------------------------------------------------------------------------------
{Protheus.doc} XMLENV01
Ponto de entrada para customizar as informações no XML do RPS unico.
Está sendo utilizado para informar o CPF do tomador de acordo com o campo no pedido de
venda.  

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     Sergio Oliveira
@version    P.12
@since      Jan/2016
@return    	Nenhum
@sample   	Nenhum
@obs      	

==>> - Foi baixado o programa do site de atualizacoes da v12 "15-12-29-fis-rdmake_nfse_p12";
     - O fonte nfseXMLEnv.prw (XML para envio unico) passou a fazer parte dos fontes 
       customizados da SPTURIS;
     - Com a utilizacao deste ponto de entrada, nao houve necessidade de alterar o 
       programa nfseXMLEnv.prw

@project    Nenhum
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User Function XMLENV01()

Local __aParam := aClone( ParamIXB )

//tratamento para preencher automaticamente o CPF/CGC
If __aParam[4][1] == "" 
	__aParam[4][1] := "99999999999" //cgc
EndIf

//tratamento para deixar o complemento com no maximo 30 caracteres
If len(alltrim(__aParam[4][5])) > 30 //comp
	__aParam[4][5] := alltrim(Substr(__aParam[4][5],1,30))
EndIf

//__aParam[4][1] := PegaCPF(__aParam[5][1], __aParam[5][2]) // CPF do Tomador - Informar aqui o CPF da Nota

Return( __aParam )