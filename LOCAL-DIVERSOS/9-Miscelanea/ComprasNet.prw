#INCLUDE "TOTVS.CH"
//#INCLUDE "XMLCSVCS.CH"
#Include 'Protheus.ch'

User Function ComprasNet()
Local cUrl := "http://www.google.com"
Local nTimeOut := 120 
Local aHeadOut := {}
Local cHeadRet := ""
Local sPostRet := ""

//"https://api.iugu.com/v1/invoices/06A7F2E235734929B7E80DCC6F64C392?api_token=e3a203c0cfaf1f396fe9d45e22b7bea4" 

	RpcSetType(3)
	RpcSetEnv("99", "01")



aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/x-www-form-urlencoded')

//sPostRet := HttpPost("https://api.iugu.com", "/v1/invoices/06A7F2E235734929B7E80DCC6F64C392?api_token=e3a203c0cfaf1f396fe9d45e22b7bea4", "", nTimeOut,aHeadOut,@cHeadRet)//HttpPost(cUrl,"",cXml,nTimeOut,aHeadOut,@cHeadRet)

sPostRet := HttpPost("https://api.iugu.com/v1/accounts/financial?api_token=e3a203c0cfaf1f396fe9d45e22b7bea4&year=2017&month=04&day=19&limit=100&start", "", "", nTimeOut,aHeadOut,@cHeadRet)//HttpPost(cUrl,"",cXml,nTimeOut,aHeadOut,@cHeadRet)

if !empty(sPostRet) 
  conout("HttpPost Ok") 
  varinfo("WebPage", sPostRet)
else 
  conout("HttpPost Failed.") 
  varinfo("Header", cHeadRet)
Endif

	RpcClearEnv()
	

Return