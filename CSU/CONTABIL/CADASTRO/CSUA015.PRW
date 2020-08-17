User function CSUA015()


private CCADASTRO := "Cadastro de Usuarios Lib. Rateio Off-Line"





private AROTINA := {{"Pesquisar","AxPesqui",0,1},{"Visualizar","AxVisual",0,2},{"Incluir","AxInclui",0,3},{"Alterar","AxAltera",0,4},{"Excluir","AxDeleta",0,5}}

private CDELFUNC := ".T."

private CSTRING := "SZG"

dbselectarea("SZG")
dbsetorder(1)
dbselectarea(CSTRING)
MBROWSE(6,1,22,75,CSTRING)

return NIL
