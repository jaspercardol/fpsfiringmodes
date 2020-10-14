#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; Global settings
mode = 1 ; 1 = off, 2 = burst, 3 = automatic
button_hold_delay = 10
delay_between_shots = 50

; Notification settings
notify = true
notify_traytip = true
notify_splashtext = true
notify_sound = true

; Burst Fire settings
burst_size = 3 ; Number of bullets you want to fire when clicking once.



*XButton2:: ; Switch modes.
traytip_desc = false
Switch mode
{
	case 1:
		mode = 2
	case 2:
		mode = 3
	case 3:
		mode = 4
	case 4:
		mode = 1
}
if(notify = "true") {
	NotifyOnModeSwitch(mode)
}
return

~LButton::
Switch mode
{
	case 1:
		return
	case 2:
		Loop, % burst_size {
			Send {LButton down}
			Sleep button_hold_delay
			Send {LButton up}
			Sleep (delay_between_shots - button_hold_delay)
		}
		return
	case 3:
		while(getKeyState("LButton","P")) {
			Send {LButton down}
			Sleep button_hold_delay
			Send {LButton up}
			if(delay_between_shots != "false") {
			Sleep (delay_between_shots - button_hold_delay)
			} else {
			Sleep button_hold_delay
			}
		}
		return
	case 4:
		Send {LButton down}
		Sleep button_hold_delay
		Send {LButton up}
		return
}

; Copy this function into your script to use it.
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

; Notify User
NotifyOnModeSwitch(newmode) {
	title = Weapon Control
	text = false
	Switch newmode {
		case 1:
			text = Off
		case 2:
			text = Burst Fire
		case 3:
			text = Rapid Fire
		case 4:
			text = Single Shot
	}
	if(notify_splashtext) {
		SoundBeep, 524, 200
		SplashTextOn, 50,25, %title%, %text%
		SetTimer % SplashTextOff, 200
	}
	if(notify_traytip = "true") {
		TrayTip, %title%, %text%, 5, 16
		SetTimer % HideTrayTip, 200
	}
	if("true" = "true") {
		Switch newmode {
			case 1:
				SoundBeep, 262, 300
				
			case 2:
				SoundBeep, 524, 200
			case 3:
				SoundBeep, 524, 100
				Sleep 25
				SoundBeep, 524, 100
			case 4:
				SoundBeep, 524, 100
				Sleep 25
				SoundBeep, 524, 100
				Sleep 25
				SoundBeep, 524, 100
		}
	}


}


