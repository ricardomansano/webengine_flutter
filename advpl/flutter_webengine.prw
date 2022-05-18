#include "totvs.ch"

function u_flutter
    oDlg := TWindow():New(0, 0, 800, 600, "Flutter via WebEngine")
        oWebChannel := TWebChannel():New()
        oWebChannel:bJsToAdvpl := {|self,key,value| jsToAdvpl(self,key,value) } 
        oWebChannel:connect()
        
        // ------------------------------------------------------------------------
        // [TODO: Atualizar a PORTA de acordo com o servidor que o Flutter iniciar]
        // ------------------------------------------------------------------------
        cUrl := "http://localhost:33251/#/"

        oWebEngine := TWebEngine():New(oDlg,0,0,100,100,cUrl,oWebChannel:nPort)
        oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT
        oWebEngine:bLoadFinished := {|webengine, url| myLoadFinish(webengine, url) }
    oDlg:Activate("MAXIMIZED")
return

// Blocos de codigo recebidos via JavaScript
static function jsToAdvpl(self,key,value)
	conout("",;
		"jsToAdvpl->key: " + key,;
        "jsToAdvpl->value: " + value)

    // ---------------------------------------------------------------
    // Insira aqui o tratamento para as mensagens vindas do JavaScript
    // ---------------------------------------------------------------
    Do Case 
        case key  == "<msg1>"
            // [TODO]
        case key  == "<msg2>"
            // [TODO]
    EndCase
Return

// Bloco de codigo disparado no fim da carga da página HTML
static function myLoadFinish(oWebEngine, url)
    conout("-> myLoadFinish(): Termino da carga da pagina")
    conout("-> Class: " + GetClassName(oWebEngine))
    conout("-> URL: " + url)
    conout("-> Websocket port: " + cValToChar(oWebChannel:nPort))

    // Executa um runJavaScript
    oWebEngine:runJavaScript("alert('RunJavaScript: Termino da carga da pagina');")
return
