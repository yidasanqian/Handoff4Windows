;Made by Tp
;使用前请务必在同一个目录下建立「url.txt」文档，并以「https://api.day.app/xxxxxxxxx/」的格式将推送链接粘贴进去。
^!c::
{
	FileRead, url, url.txt
	cb = %clipboard%
	If (InStr(cb,"http://") or InStr(cb,"HTTP://") or InStr(cb,"https://") or InStr(cb,"HTTPS://"))
	{
	    copy := "?url=" . cb
	    cb := "Incoming URL Link"
	} else {
		copy := "?automaticallyCopy=1&copy=" . cb
	}
	finalURL = %url%%cb%%copy%
	
	dhw := A_DetectHiddenWindows
	DetectHiddenWindows On
	Run "%ComSpec%" /k,, Hide, pid
	while !(hConsole := WinExist("ahk_pid" pid))
		Sleep 10
	DllCall("AttachConsole", "UInt", pid)
	DetectHiddenWindows %dhw%

	req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.Open("GET", finalURL)
	req.Send()
	

	DllCall("FreeConsole")
	Process Exist, %pid%
	if (ErrorLevel == pid)
		Process Close, %pid%
	return
}
