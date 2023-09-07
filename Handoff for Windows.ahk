#Persistent
FileRead,BarkPushURL,url.txt 

+^c::        ; Ctrl+Shift+C直接推送当前剪贴板中的内容，若与其它软件热键冲突可自行更换
    RegExMatch(Clipboard, "(http(s)?:\/\/)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:[0-9]{1,5})?[-a-zA-Z0-9()@:%_\\\+\.~#?&//=]*", url)
    If (url != "") {
		Clipboard := StrReplace(Clipboard, url, UrlEncode(url))             
    }
	Clipboard := StrReplace(Clipboard, "/", "%2F")  
    Clipboard := StrReplace(Clipboard, "?", "%3F")  
	bark := BarkPushURL . Clipboard . "?automaticallyCopy=1"
    ; 打印结果到日志
	FileAppend, %bark% `n, log.txt
    HTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HTTP.open("GET", bark)
    HTTP.send()

UrlEncode(String) 
{ 
   OldFormat := A_FormatInteger 
   SetFormat, Integer, H 

   Loop, Parse, String 
   { 
      if A_LoopField is alnum 
      { 
         Out .= A_LoopField 
         continue 
      } 
      Hex := SubStr( Asc( A_LoopField ), 3 ) 
      Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex ) 
   } 
   SetFormat, Integer, %OldFormat% 
   return Out 
} 