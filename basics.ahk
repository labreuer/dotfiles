#InstallKeybdHook
#SingleInstance force

GroupAdd, TextEditors, ahk_exe sublime_text.exe

GroupAdd, NoMdash, ahk_exe devenv.exe
GroupAdd, NoMdash, ahk_exe PaintDotNet.exe
GroupAdd, NoMdash, ahk_exe LINQPad.exe

GroupAdd, CloseWindowF4, ahk_exe devenv.exe
GroupAdd, CloseWindowF4, ahk_exe Ssms.exe
GroupAdd, CloseWindowF4, ahk_exe powershell_ise.exe

#IfWinNotActive ahk_group NoMdash
^-::send, {Asc 0151}
^!-::send, {Asc 0150}
#IfWinNotActive

; need UTF8+BOM encoding to Send unicode
^!a::  Send {Asc 160}  ; á
^!+a:: Send {Asc 0193} ; Á
^!e::  Send {Asc 130}  ; é
^!+e:: Send {Asc 144}  ; É
^!i::  Send {Asc 161}  ; í
^!+i:: Send {Asc 0205} ; Í
#IfWinNotActive ahk_exe devenv.exe
^!o::  Send {Asc 162}  ; ó
#IfWinNotActive
^!+o:: Send {Asc 0211} ; Ó
^!u::  Send {Asc 163}  ; ú
^!+u:: Send {Asc 0218} ; Ú
^!c::  Send ç
^!+c:: Send Ç
#n::  Send {Asc 164}  ; ñ
#+n:: Send {Asc 165}  ; Ñ
^!+s:: Send {Asc 0167} ; §
^!t::  Send {Asc 0134} ; †
^!+t:: Send {Asc 0135} ; ‡
^!8::  Send {Asc 0149} ; •
^!1::  Send {Asc 0172} ; ¬
^!=::  Send ≠ ; ≠
^!/::  SendInput, {raw}&#8203;
#f7:: Run %A_WinDir%\system32\SnippingTool.exe
#PrintScreen:: Run %A_WinDir%\system32\SnippingTool.exe

^!,::  SendInput, {raw}<blockquote>
; ^!+,:: SendInput, {raw}<blockquote class="gmail_quote" style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
^!+,:: SendInput, {raw}<blockquote style="margin: 0px 0px 0px 0.8ex; border-left: 1px solid blue; padding-left: 1ex;">
#IfWinNotActive ahk_exe sublime_text.exe
^!.::  SendInput, {raw}</blockquote>
#IfWinActive ahk_exe sublime_text.exe
#IfWinActive
^!.::  SendInput, {raw}</

;#`::   ProcessAccent({"a":"à", "e":"è", "i":"ì", "o":"ò", "u":"ù"})
#'::   ProcessAccent({"a":"á", "e":"é", "i":"í", "o":"ó", "u":"ú"})
#+`;:: ProcessAccent({"a":"ä", "e":"ë", "i":"ï", "o":"ö", "u":"ü"})
; couldn't get ^ or > to work
#.::   ProcessAccent({"a":"â", "e":"ê", "i":"î", "o":"ô", "u":"û"})
#-::   ProcessAccent({"a":"ā", "e":"ē", "i":"ī", "o":"ō", "u":"ū"}) 
#~::   ProcessAccent({"c":"ç"})
#/::   ProcessAccent({"o":"ø"})

;+space:: SendInput, {raw}&nbsp;

#IfWinActive Copy Bible Verses
Escape::!F4
#IfWinActive

; Trying to use IfWinActive and typing ^!n in EverNote
; caused the lock screen to show up... for some reason
#IfWinNotActive ahk_exe Evernote.exe
;^!n:: SendInput, {raw}&nbsp;&nbsp;&nbsp;&nbsp;
^!n:: SendInput, {raw}    
#IfWinActive ahk_class ENSingleNoteView
^!n::
    SendInput, ^q
    ; at one point I thought this made WinWaitActive return more quickly
    ;Sleep, 40 
    WinWaitActive, ahk_class ENQuickSearchPopup, , 2
    if ErrorLevel
        Return
    else
        SendInput, intitle:""{left}
    Return
#IfWinActive ahk_exe Evernote.exe
^!n::   SendInput, intitle:""{left}
    ;releaseAllModifiers()
#IfWinActive

#IfWinActive ahk_exe UpNote.exe
^+h::	SendInput, ^!+3
#IfWinActive

^+!n:: SendInput, {raw}(<p>(</p>)?|</?p>)|<br/?>

ProcessAccent(dict)
{
	Input, c, L1
	ac := % dict[c]

	If !ac
		oc := c
	Else If c is lower
		oc := ac
	Else
		StringUpper oc, ac
	 
	Send % oc
}

#SPACE::
	;WinGet, ExStyle, ExStyle, A
	;if (ExStyle & 0x8)
	;{
	;	OutputDebug, AHK TOP
	;}
	;else
	;{
	;	OutputDebug, AHK nope
	;}
	;WinSet, AlwaysOnTop, Off, A

	WinGet windows, List
	loop %windows%
	{
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		WinGetClass, wc, ahk_id %id%
		if (wt)
			s := wt
		else
			s = {%wc%}
		WinGet, wg, ExStyle, ahk_id %id%
		aot := wg & 0x8
		if (aot)
		{
			OutputDebug, AHK %aot% %s%
			WinSet, AlwaysOnTop, Off, ahk_id %id%
		}
	}
	
	return

#Escape::SendMessage 0x112, 0xF170, 2, , Program 

;#F2::
;	WinActivate ahk_class Notepad++
;	WinActivate ahk_class ApplicationFrameWindow
;Return

;#v::
;RunWait, "C:\Users\labreuer\Documents\Visual Studio 2013\Projects\KindleNote\bin\Debug\KindleNote.exe"
;Send ^v
;Return

#g:: WinActivate ahk_exe mintty.exe

#o::
; might need to sleep, here
; https://gist.github.com/davejamesmiller/1965854
SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off
; https://autohotkey.com/board/topic/25339-how-to-turn-off-monitor/
;SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, (LPARAM) 2);

Sleep, 300

SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off

; Sleep, 50
; Run, "C:\Users\labreuer\Documents\Visual Studio 2017\Projects\MonitorOff\bin\Debug\MonitorOff.exe"
; Sleep, 300
; Run, "C:\Users\labreuer\Documents\Visual Studio 2017\Projects\MonitorOff\bin\Debug\MonitorOff.exe"
Return

#w:: WinActivate ahk_exe pwsh.exe

#,:: WinActivate ahk_exe chrome.exe

; emulate OSX command-backtick functionality
!`::
!+`::
; OutputDebug, AHK backtick_initialized = %backtick_initialized%
if (!backtick_initialized)
{
	backtick_initialized := 1
	SetTimer, CheckDisable, 10

	WinGet, pn, ID, A
	WinGetClass, pn_class, ahk_id %pn%
	WinGet, pns, List, ahk_class %pn_class%
	; Visual Studio 2017 has custom classes for each top-level window, so revert
	; to matching on the process name
	; Chrome_WidgetWin_1 is the class for Electron apps as well as Chrome
	if (pns == 1 or pn_class == "Chrome_WidgetWin_1")
	{
		WinGet, pn, ProcessPath, A
		WinGet, pns, List, ahk_exe %pn%
	}
	pn_cur := 0
	backtick_windows := []

	Loop, %pns%
	{
		this_id := pns%A_Index%
		WinGetTitle, this_title, ahk_id %this_id%
		; WinGetClass, this_class, ahk_id %this_id%
		; OutputDebug, AHK %A_Index% %this_title% / %this_class%
		; tried to do this with regex in WinGet, pns, List -- but it wasn't working
		if (this_title)
			backtick_windows.Push(this_id)
	}
}

if (GetKeyState("Shift"))
	add_value := backtick_windows.Length() - 1
else
	add_value := 1

pn_cur := Mod(pn_cur + add_value, backtick_windows.Length())
idx := pn_cur + 1
; OutputDebug, AHK: +%add_value% -> %idx%
this_id := backtick_windows[idx]
WinActivate, ahk_id %this_id%
return

; I found no better way to detect the alt-keyup
CheckDisable:
KeyWait, LAlt, T0.001
if (!ErrorLevel)
{
	backtick_initialized := 0
	SetTimer, CheckDisable, off
}
return

; emulate OSX command-backtick functionality except the active window is sent
; to the bottom of the Z-index
#`::
WinGetClass, ActiveClass, A
WinGet, WinClassCount, Count, ahk_class %ActiveClass%
if WinClassCount = 1
    return
WinSet, Bottom,, A
WinActivate, ahk_class %ActiveClass%
return

; I didn't feel like making the hide-last-window functionality from #`:: work,
; so this progressively pulls more windows to the top; in a sense that's
; actually the exact inverse of #`::
#+`::
WinGet, pn, ProcessPath, A
WinGet, pns, List, ahk_exe %pn%
OutputDebug, AHK pns%pns%, %pns5%
if pns = 1
	return
;WinSet, Bottom,, A
this_id := pns%pns%
WinActivate, ahk_id %this_id%
return



; https://autohotkey.com/board/topic/43779-reload-this-script-shortcut-solved/
#+r:: Reload

#v::
Send ^c
RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" u
Send ^v
Return

^#v::
Send ^c
RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" u 2
Send ^v
Return

^!#v::
Send ^c
RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" b 2
Send ^v
Return

#IfWinActive ahk_group TextEditors
#z::
RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" vc
Send ^v
Return

#IfWinActive
#z::
RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" a
Send ^v
Return


#c::
;Send ^c
RunWait, "C:\Users\labreuer\git\PdfCopy\bin\Debug\PdfCopy.exe"
releaseAllModifiers()
Send ^v
Return

;#w::
;	x := "a#tb"
;	SendInput, {raw}"<%x%>"
;Return

;#w::
;    Loop 2 {
;        Send ^a^c
;        Send !{down}
;        RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" rtf C:\Users\labreuer\Downloads\FttG\rtf\p%A_Index%.rtf
;        Sleep, 1000 
;        
;    }
;Return

; http://www.fileformat.info/info/unicode/category/Sm/list.htm
^!+y::
	repl := {"=>":"⇒", "->":"→", "<-":"←", "!>":"⇏", "!=":"≠", "!!":"¬", "tt":"‡", "~=":"≈", "<<":"«", ">>":"»", ">=":"≥", "<=":"≤", "dg":"°", "tm":"™", "-=":"≡", "in":"∞", "+-":"±", "--":"−", "??":"¿", "!!x":"¡", "ld":"δ", "uD":"Δ", "le":"ε", "lm":"μ", "—2":"⸺", "—3":"⸻", "~~":"∼", "````":"“", "''":"”", "`` ":"‘", " ``":"‘", "' ":"’", " '":"’", "``'":"ʿ", "^2":"²", "_2":"₂", "_0":"₀", "_n":"ₙ", "-?":"­", "el":"∈", "ne":"∉", "xx":"×", "x.":"·", "**":"∗", "vv":"∨", "^^":"∧", "'1":"′", "'2":"″", "'3":"‴", "'4":"⁗", "oe":"œ", "ae":"æ", "<2":"≪", ">2":"≫", "<3":"⋘", ">3":"⋙", "^2":"²", "^3":"³", "^n":"ⁿ", "pr":"∝", ".1":"·", "ff":"ƒ", "=?":"≟", "=d":"≝", "..":"…", "nn":"□", "pp":"◊", "th":"θ", "ph":"ϕ", "ps":"ψ", "ep":"ε", "si":"σ", "fa":"⊥", "tr":"⊤", "pi":"π", "'\u00a0":"’", ":.":"⋮", ".:":"∴", "h-":"ħ" }
	Send, {Shift down}{Left 2}{Shift up}
	
	;OutputDebug, AHK: A 
	save := Clipboard
	clipboard = ; Empty the clipboard
	releaseAllModifiers()
	Send, ^c
	ClipWait, 0.5
	clip := Clipboard
    Clipboard := save
	
    ; Evernote 6.7.5.5825 sometimes appends a newline to copied text
    clip := RegExReplace(clip, "^\s+(?=..)|(?<=..)\s+$")
	oc := repl[clip]
	If oc
		Send {raw}%oc%
    
    releaseAllModifiers()
    ;OutputDebug, AHK: Z
Return


#IfWinActive ahk_exe chrome.exe
^!h::
	RunWait, "C:\Users\labreuer\git\PdfCopy\bin\Debug\PdfCopy.exe"
	s := Clipboard
	s := "<span style='background-color: rgb(255, 250, 165);'>" . s . "</span>"
	Clipboard := s
	RunWait, "C:\Users\labreuer\git\HtmlClipboard\bin\Debug\HtmlClipboard.exe" a
	Send, ^v
	return
#IfWinActive

	
#IfWinNotActive ahk_exe sublime_text.exe
^!+h::
h := RegExMatch(Clipboard, "^https?://")
If (h > 0)
{
	; unreliable with Notepad++, doesn't work with Disqus textbox
	; instead of using the contents, I use this to see if there is selected text, and then use the clipboard to more reliably get it
	; if I just use the clipboard approach, Notepad++ will copy the entire line instead of copying nothing
	; https://autohotkey.com/board/topic/66718-how-to-get-selected-text-without-using-the-clipboard/#entry422204
	WinActive("A")
	ControlGetFocus, ctrl
	ControlGet, text, Selected,, %ctrl%

	href := Clipboard
	If StrLen(text) > 0
	{
		clipboard = ; Empty the clipboard
		Send, ^c
		ClipWait, 0.5
		text := Clipboard
		Clipboard := href
	}

	; this clobbers non-plaintext formatting of clipboard and destination
	; but it has the benefit of manifesting as a single undo action
	SendInput {raw}<a href="%href%">%text%</a>
	
	;SendInput, {raw}<a href="
	;Send ^v
	;SendInput, {raw}">
	;SendInput, %text%
	;SendInput, {raw}</a>
	
	if (StrLen(text) = 0)
	{
		l := StrLen("</a>")
		SendInput {LEFT %l%}
	}
}
Else
{
	SendInput, {raw}<a href="">
	Send ^v
	SendInput, {raw}</a>
	l := StrLen(Clipboard) + StrLen("""></a>")
	SendInput {LEFT %l%}
}
releaseAllModifiers()
Return

^!+j::
	SendInput, {raw}<blockquote><a href="
	Send ^v
	SendInput, {raw}"></a>:
	SendInput {SPACE}
	l := StrLen("</a>: ")
	SendInput {LEFT %l%}
	releaseAllModifiers()
Return
#IfWinActive

; modifiers aren't always released on ctrl-shift-alt-[jh]
releaseAllModifiers() 
{ 
    ;Sleep, 10
    list = LControl|RControl|LShift|RShift|LAlt|RAlt
    Loop Parse, list, | 
    { 
        if (GetKeyState(A_LoopField)) 
            send {Blind}{%A_LoopField% up}       ; {Blind} is added.
    }
}

#IfWinActive ahk_group CloseWindowF4
^w:: SendInput, ^{F4}
#IfWinActive