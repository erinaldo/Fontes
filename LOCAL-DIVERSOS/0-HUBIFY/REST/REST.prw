#include 'TOTVS.CH'
#include 'RESTFUL.CH'

//protocolo no AdvPL (POST, PUT, GET e DELETE).

//O nome declarado apó o comando WSRESTFUL será utilizado no endereço (URI) para execução dos métodos (respeitando a configuração de URL do appserver.ini), 
//por exemplo http://localhost:8080/rest/sample
WSRESTFUL emerson DESCRIPTION "Exemplo de serviço REST"

//Declarar com o comando WSDATA as propriedades que serão utilizadas para receber os parâmetros de QueryString (opcional)
WSDATA count AS INTEGER
WSDATA startIndex AS INTEGER 

//Declarar com o comando WSMETHOD <method> DESCRIPTION os métodos HTTP que serão utilizados (POST, PUT, GET e DELETE), não sendo obrigatório declarar todos, somente os que serão utilizados
WSMETHOD GET DESCRIPTION "Exemplo de retorno de entidade(s)" WSSYNTAX "/emerson || /emerson/{id}"
WSMETHOD POST DESCRIPTION "Exemplo de inclusao de entidade" WSSYNTAX "/emerson/{id}"
WSMETHOD PUT DESCRIPTION "Exemplo de alteração de entidade" WSSYNTAX "/emerson/{id}"
WSMETHOD DELETE DESCRIPTION "Exemplo de exclusão de entidade" WSSYNTAX "/emerson/{id}"

//Finalizar a declaração da classe com o comando END WSRESTFUL 
END WSRESTFUL 

WSMETHOD GET WSRECEIVE startIndex, count WSSERVICE emerson
Local i
 
// define o tipo de retorno do método
::SetContentType("application/json")
  
// verifica se recebeu parametro pela URL
// exemplo: http://localhost:8080/sample/1
If Len(::aURLParms) > 0
   // insira aqui o código para pesquisa do parametro recebido
   // exemplo de retorno de um objeto JSON
   ::SetResponse('{"id":' + ::aURLParms[1] + ', "name":"emerson"}')
Else
   // as propriedades da classe receberão os valores enviados por querystring
   // exemplo: http://localhost:8080/sample?startIndex=1&count=10
  
   DEFAULT ::startIndex := 1, ::count := 5
  
   // exemplo de retorno de uma lista de objetos JSON
   ::SetResponse('[')
  
   For i := ::startIndex To ::count + 1
       If i > ::startIndex
          ::SetResponse(',')
       EndIf
       ::SetResponse('{"id":' + Str(i) + ', "name":"emerson"}')
   Next
   ::SetResponse(']')
EndIf
Return .T.
 
 
WSMETHOD POST WSSERVICE emerson
Local lPost := .T.
 
// Exemplo de retorno de erro
If Len(::aURLParms) == 0
   SetRestFault(400, "id parameter is mandatory")
   lPost := .F.
Else
   // insira aqui o código para operação inserção
   // exemplo de retorno de um objeto JSON
   ::SetResponse('{"id":' + ::aURLParms[1] + ', "name":"emerson"}')
EndIf
Return lPost