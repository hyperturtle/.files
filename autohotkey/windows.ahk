;STARTOFSCRIPT 
SetTimer,UPDATEDSCRIPT,1000 

UPDATEDSCRIPT: 
FileGetAttrib,attribs,%A_ScriptFullPath% 
IfInString,attribs,A 
{ 
FileSetAttrib,-A,%A_ScriptFullPath% 
SplashTextOn,,,Updated script, 
Sleep,500 
Reload 
} 
Return 
;ENDOFSCRIPT


; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;       MS Outlook might have multiple windows open (main window and email
;       windows).  This parm allows activating a specific window.
; ===========================================================================
RunOrActivate(Target, WinTitle = "")
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target%, , , PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <> 
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      TrayTip, , Activating PID %PID% (%TargetNameOnly%)
      WinActivate, ahk_pid %PID%
   }


   SetTimer, RunOrActivateTrayTipOff, 1500
}

; Turn off the tray tip
RunOrActivateTrayTipOff:
   SetTimer, RunOrActivateTrayTipOff, off
   TrayTip
Return


; Remap Capslock Key
Capslock::
;suspend to prevent calling esc
Suspend on
Send, {ESC}
Suspend off
return

; Open VIM
#v::RunOrActivate("gvim.bat")
#c::RunOrActivate("chrome.exe")
#f::RunOrActivate("firefox.exe")
#o::RunOrActivate("outlook.exe")
#p::RunOrActivate("p4v.exe")
#i::RunOrActivate("mlpod.exe")
