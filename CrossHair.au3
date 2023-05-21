#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WinAPI.au3>

;HotKeySet("{F5}", "_clickthrough")
$sections = IniReadSectionNames('settings.ini')
If @error Then
MsgBox(4096, "", "Error occurred, probably no INI file, Creating now")
IniWrite("settings.ini", "CrossHair", "size", 6)
IniWrite("settings.ini", "CrossHair", "gap", 3)
IniWrite("settings.ini", "CrossHair", "width", 2)
IniWrite("settings.ini", "CrossHair", "color", "0xFF0000")
EndIf

Local $iSize = IniRead("settings.ini", "CrossHair", "size", 6);
Local $Gap = IniRead("settings.ini", "CrossHair", "gap", 3)
Local $width = IniRead("settings.ini", "CrossHair", "width", 2)
Local $setColour = IniRead("settings.ini", "CrossHair", "color", $COLOR_RED)

#region GUI
$hGUIMain = GUICreate("")

$hGUIChild = GUICreate("", $iSize*2+$Gap, $iSize*2+$Gap, @DesktopWidth/2-($iSize)-($Gap/2), @DesktopHeight/2-($iSize)-($Gap/2), $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_LAYERED, $WS_EX_TRANSPARENT), $hGUIMain)
GUISetBkColor($COLOR_BLACK)

;left
GUICtrlCreateLabel("", 0, $iSize, $iSize, $gap)
GUICtrlSetBkColor(-1, $setColour)

;right
GUICtrlCreateLabel("", $iSize + $gap, $iSize, $iSize, $gap)
GUICtrlSetBkColor(-1, $setColour)

;TOP
GUICtrlCreateLabel("", $iSize, 0, $gap, $iSize)
GUICtrlSetBkColor(-1, $setColour)

;BOTTOM
GUICtrlCreateLabel("", $iSize, $iSize+$gap, $gap, $iSize)
GUICtrlSetBkColor(-1, $setColour)

_WinAPI_SetLayeredWindowAttributes($hGUIChild, $COLOR_BLACK)

GUISetState(@SW_SHOWNOACTIVATE, $hGUIChild)
#endregion
Global $winHand = ""
While 1
    Sleep(10)
	_WinAPI_SetWindowPos($hGUIChild, $HWND_TOPMOST, 0, 0, 0, 0, BitOR($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOSENDCHANGING))
WEnd




Func _clickthrough()
	if $winHand = "" then
		$winHand = WinGetHandle("", "")
		_WinAPI_SetWindowLong($winHand, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($winHand, $GWL_EXSTYLE), $WS_EX_TRANSPARENT))
	else
		$NoTrans = BitNOT($WS_EX_TRANSPARENT)
		_WinAPI_SetWindowLong($winHand, $GWL_EXSTYLE, BitAND(_WinAPI_GetWindowLong($winHand, $GWL_EXSTYLE), $NoTrans))
		$winHand = ""
	EndIf
EndFunc

