Function GetComponentArch
	Call GetArch
	Pop $0
	${If} $0 == "x64"
		StrCpy $0 "amd64"
	${EndIf}
	Push $0
FunctionEnd

!macro SPHandler kbid title os sp
	!insertmacro NeedsSPHandler "${kbid}" "${os}" "${sp}"

	Function Download${kbid}
		Call Needs${kbid}
		Pop $0
		${If} $0 == 1
			Call GetArch
			Pop $0
			ReadINIStr $0 $PLUGINSDIR\Patches.ini "${kbid}" $0
			ReadINIStr $1 $PLUGINSDIR\Patches.ini "${kbid}" Prefix
			!insertmacro Download "${title}" "$1$0" "${kbid}.exe" 1
		${EndIf}
	FunctionEnd

	Function Install${kbid}
		Call Needs${kbid}
		Pop $0
		${If} $0 == 1
			Call Download${kbid}
			!insertmacro InstallSP "${title}" "${kbid}.exe"
		${EndIf}
	FunctionEnd
!macroend

!macro MSUHandler kbid title
	Function Needs${kbid}
		Call GetComponentArch
		Pop $0
		ClearErrors
		EnumRegKey $1 HKLM "${REGPATH_CBS_PACKAGEINDEX}\Package_for_${kbid}~31bf3856ad364e35~$0~~0.0.0.0" 0
		${If} ${Errors}
			Push 1
		${Else}
			Push 0
		${EndIf}
	FunctionEnd

	Function Download${kbid}
		Call Needs${kbid}
		Pop $0
		${If} $0 == 1
			Call GetArch
			Pop $0
			ReadINIStr $1 $PLUGINSDIR\Patches.ini "${kbid}" $0
			ReadINIStr $2 $PLUGINSDIR\Patches.ini "${kbid}" Prefix
			!insertmacro DownloadMSU "${kbid}" "${title}" "$2$1"
		${EndIf}
	FunctionEnd

	Function Install${kbid}
		Call Needs${kbid}
		Pop $0
		${If} $0 == 1
			Call Download${kbid}
			!insertmacro InstallMSU "${kbid}" "${title}"
		${EndIf}
	FunctionEnd
!macroend

; Service Packs
!insertmacro SPHandler  "VistaSP1"  "Windows Vista $(SP) 1" "WinVista" 0
!insertmacro SPHandler  "VistaSP2"  "Windows Vista $(SP) 2" "WinVista" 1
!insertmacro SPHandler  "Win7SP1"   "Windows 7 $(SP) 1"     "Win7"     0

; Windows Vista post-SP2 update combination that fixes WU indefinitely checking for updates
!insertmacro MSUHandler "KB3205638" "$(SecUpd) for Windows Vista"
!insertmacro MSUHandler "KB4012583" "$(SecUpd) for Windows Vista"
!insertmacro MSUHandler "KB4015195" "$(SecUpd) for Windows Vista"
!insertmacro MSUHandler "KB4015380" "$(SecUpd) for Windows Vista"

; Internet Explorer 9 for Windows Vista
!insertmacro MSUHandler "KB971512"  "$(Update) for Windows Vista"
!insertmacro MSUHandler "KB2117917" "$(PUS) for Windows Vista"

!insertmacro NeedsFileVersionHandler "IE9" "mshtml.dll" "9.0.8112.16421"
!insertmacro PatchHandler "IE9" "$(IE) 9 for Windows Vista" "/passive /norestart /update-no /closeprograms"

; Windows Vista Servicing Stack Update
!insertmacro MSUHandler "KB4493730" "2019-04 $(SSU) for Windows $(SRV) 2008"

; Windows 7 Servicing Stack Update
!insertmacro MSUHandler "KB3138612" "2016-03 $(SSU) for Windows 7"
!insertmacro MSUHandler "KB4474419" "$(SHA2) for Windows 7"
!insertmacro MSUHandler "KB4490628" "2019-03 $(SSU) for Windows 7"

; Windows Home Server 2011 Update Rollup 4
!insertmacro MSUHandler "KB2757011" "$(SectionWHS2011U4)"

; Windows 8 Servicing Stack
!insertmacro MSUHandler "KB4598297" "2021-01 $(SSU) for Windows $(SRV) 2012"

; Windows 8.1 Servicing Stack
!insertmacro MSUHandler "KB3021910" "2015-04 $(SSU) for Windows 8.1"

; Windows 8.1 Update 1
!insertmacro MSUHandler "KB2919355" "Windows 8.1 $(Update) 1"
!insertmacro MSUHandler "KB2932046" "Windows 8.1 $(Update) 1"
!insertmacro MSUHandler "KB2959977" "Windows 8.1 $(Update) 1"
!insertmacro MSUHandler "KB2937592" "Windows 8.1 $(Update) 1"
!insertmacro MSUHandler "KB2934018" "Windows 8.1 $(Update) 1"

; Windows 8.1 Update 3
; TODO
; !insertmacro MSUHandler "KB2934018" "Windows 8.1 $(Update) 3"

Function NeedsVistaPostSP2
	Call NeedsKB3205638
	Call NeedsKB4012583
	Call NeedsKB4015195
	Call NeedsKB4015380
	Call NeedsKB4493730
	Pop $0
	Pop $1
	Pop $2
	Pop $3
	Pop $4
	${If} $0 == 1
	${OrIf} $1 == 1
	${OrIf} $2 == 1
	${OrIf} $3 == 1
	${OrIf} $4 == 1
		Push 1
	${Else}
		Push 0
	${EndIf}
FunctionEnd

Function NeedsWin7PostSP1
	Call NeedsKB3138612
	Call NeedsKB4474419
	Call NeedsKB4490628
	Pop $0
	Pop $1
	Pop $2
	${If} $0 == 1
	${OrIf} $1 == 1
	${OrIf} $2 == 1
		Push 1
	${Else}
		Push 0
	${EndIf}
FunctionEnd

Function NeedsWin81Update1
	Call NeedsKB2919355
	Call NeedsKB2932046
	Call NeedsKB2937592
	Call NeedsKB2934018
	Pop $0
	Pop $1
	Pop $2
	Pop $3
	Pop $4

	${If} $0 == 1
	${OrIf} $1 == 1
	${OrIf} $2 == 1
	${OrIf} $3 == 1
		Push 1
	${Else}
		Push 0
	${EndIf}
FunctionEnd

; TODO
; Function NeedsWin81Update3
; 	Call GetArch
; 	Call NeedsKB2934018
; 	Pop $0
; 	Pop $1
; 	${If} $0 == 1
; 	${AndIf} $1 == "arm"
; 		Push 1
; 	${Else}
; 		Push 0
; 	${EndIf}
; FunctionEnd

; Weird prerequisite to Update 1 that fixes the main KB2919355 update failing to install
Function DownloadClearCompressionFlag
	Call GetArch
	Pop $0
	ReadINIStr $0 $PLUGINSDIR\Patches.ini ClearCompressionFlag $0
	ReadINIStr $1 $PLUGINSDIR\Patches.ini ClearCompressionFlag Prefix
	!insertmacro Download "Windows 8.1 $(Update) 1 $(PrepTool)" "$1$0" "ClearCompressionFlag.exe" 1
FunctionEnd

Function InstallClearCompressionFlag
	Call DownloadClearCompressionFlag
	!insertmacro Install "Windows 8.1 $(Update) 1 $(PrepTool)" "ClearCompressionFlag.exe" ""
FunctionEnd