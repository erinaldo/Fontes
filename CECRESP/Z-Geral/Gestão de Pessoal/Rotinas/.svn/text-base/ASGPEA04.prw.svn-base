#include "protheus.ch"

***********
* Debito  *
***********
user function deb_rh_contabil()

	cConta := space(10)

	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
	endif  	

return(cConta)    

***********
* Credito *
***********
user function cre_rh_contabil()

	cConta := space(10)

	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
	endif  	
return(cConta)  

***************************
* Centro de Custo Debito  *
***************************
user function cc_deb_rh_contabil()

cCC := space(10)
crecebCC := space(10)
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO")
    cRecebCC := fdesc("CT1",cConta,"CT1_ACCUST")

 IF cRecebCC = "1"
       cCC:= SRZ->RZ_CC
 endif 

return(cCC)    

*****************************
* * Centro de Custo Credito *
*****************************
user function cc_cre_rh_contabil()

cCC := space(10)
crecebCC := space(10)

	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO")
    cRecebCC := fdesc("CT1",cConta,"CT1_ACCUST")

 IF cRecebCC = "1"
       cCC:= SRZ->RZ_CC
 endif 

return(cCC)

***************************
* Item Contabil  * debito
***************************
user function ic_deb_rh_contabil()

cIC := space(10)
crecebIC := space(10)
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO")
    cRecebIC := fdesc("CT1",cConta,"CT1_ACITEM")

// IF cRecebIC = "1"
//       cIC := Posicione("CT1",1,xFilial("CT1")+SRV->RV_DEBITO,"CT1_FLUXO")
// endif 

return(cIC)    

*****************************
* Item Contabil  * credito
*****************************
user function ic_cre_rh_contabil()

cIC := space(10)
crecebIC := space(10)

	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO")
    cRecebIC := fdesc("CT1",cConta,"CT1_ACITEM")

// IF cRecebIC = "1"
//      cIC := Posicione("CT1",1,xFilial("CT1")+SRV->RV_CREDITO,"CT1_FLUXO")
// endif 

return(cIC)
          
//**************************
//* HISTORICO DO LP 
//*************************

USER FUNCTION xHISTPD

    Local aOld := GETAREA()
    Local nSrvOrd := SRV->(IndexOrd())
    Local nSrvRec := SRV->(Recno())
    Local xHist
    
    dbSelectArea( "SRV" )
    dbSetOrder(1)
    dbSeek( xFilial("SRV")+SRZ->RZ_PD )

        xHIST := "*" + srz->rz_pd +" "+ srv->rv_desc +" REF. " + MESEXTENSO(DDATABASE) + "/" + STRZERO(YEAR(DDATABASE),4)
        xHIST := xHIST + "*"

    SRV->(dbSetOrder( nSrvOrd ))
    SRV->(dbGoTo( nSrvRec ))
    RESTAREA( aOld )    

RETURN(xHIST)

