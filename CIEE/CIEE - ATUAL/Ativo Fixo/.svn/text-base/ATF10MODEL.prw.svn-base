User Function ATF10MODEL
Local aParam:=Paramixb
Local oModel:=aParam[1]
Local oModelCab:=oModel:GetModel("ATF10PAG_CAB")

If aParam[2]=='MODELVLDACTIVE' .And. IsInCallStack('ATFA010') 
	oModelCab:SetValue("PAG_CBASE",SN1->N1_CBASE)
	oModelCab:SetValue("PAG_ITEM",SN1->N1_ITEM)
EndIf
Return(.T.)