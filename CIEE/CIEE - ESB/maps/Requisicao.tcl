<MAP separator="|">
	<LINE identifier="C" name="CABECALHO">
		<FIELD name="DocCompany"/>
		<FIELD name="DocBranch"/>	
		<FIELD name="FunctionCode"/>		
		<FIELD name="Operation"/>		
		<FIELD name="ZN_NUMSOC" />
		<FIELD name="ZN_USEREQ" />
		<FIELD name="ZN_EMAIL" />
		<FIELD name="ZN_CR" />	
		<FIELD name="ZN_DESCCR" />
		<FIELD name="ZN_RAMAL" />
		<FIELD name="ZN_DATA" />		
		<FIELD name="ZN_EMAIL2" />
		<CHILD>ITEM</CHILD>	
	</LINE>
	<LINE identifier="I" name="ITEM">
		<FIELD name="ZN_COD" />	
		<FIELD name="ZN_DESCR" />
		<FIELD name="ZN_UM" />
		<FIELD name="ZN_QUANT" />
		<FIELD name="ZN_SALDO" />
	</LINE>	
</MAP>