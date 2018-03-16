;--------------------------------------------------------------------------------------------------------------------;
; Fancy Code
full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
NetConnect(bEnable = False) { ; for AHK_L by Sean
	For oConn In ComObjCreate("Shell.Application").Namespace(0x0031).Items
	If  oConn.Name = global Wifi_name
	{
		If InStr(oConn.Verbs.Item(0).Name, bEnable ? "&a" : "&b")
			oConn.Verbs.Item(0).DoIt
		Break
	}
} ; http://www.autohotkey.com/forum/post-391651.html#391651
 ; Examples:
ConnectedToInternet(flag=0x40) { ; by Sean? Gets Internet Connection Status.
	Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}

;--------------------------------------------------------------------------------------------------------------------;
; Main code
global Wifi_name = "Ethernet" ; Go to powerShell and type Get-NetAdapter -Name "*"
F2::  ; Press F2 to toggle wifi
if((ConnectedToInternet())==0){
	NetConnect(1)	; connect
	sleep, 1000
	Reload
}
else{
	NetConnect(0) ; disconnect
MsgBox , , ,Disconnecting..., 1
	Reload
}
return


^Esc::ExitApp ;close app
;--------------------------------------------------------------------------------------------------------------------;