#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0

ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1

#SingleInstance Force
#include process.ahk
#include movement.ahk

;Restart if not started as Administrator
full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
global boost1_user := ""
global boost1_password := ""
global boost2_user := ""
global boost2_password := ""
global boost3_user := ""
global boost3_password := ""
global boost4_user := ""
global boost4_password := ""
global boost5_user := ""
global boost5_password := ""
global boost6_user := ""
global boost6_password := ""
global boost7_user := ""
global boost7_password := ""
global boost8_user := ""
global boost8_password := ""
global boost9_user := ""
global boost9_password := ""

global boosted_user := ""
global boosted_password := ""


global boost1 := "Sandbox:" . boost1_user . ":Valve001" ;Always 1
global boost2 := "Sandbox:" . boost2_user . ":Valve001" ;Always 1
global boost3 := "Sandbox:" . boost3_user . ":Valve001" ;Always 1
global boost4 := "Sandbox:" . boost4_user . ":Valve001" ;Always 1
global boost5 := "Sandbox:" . boost5_user . ":Valve001" ;1 OR 2
global boost6 := "Sandbox:" . boost6_user . ":Valve001" ;Always 2
global boost7 := "Sandbox:" . boost7_user . ":Valve001" ;Always 2
global boost8 := "Sandbox:" . boost8_user . ":Valve001" ;Always 2
global boost9 := "Sandbox:" . boost9_user . ":Valve001" ;Always 2

global liveAccount := "Valve001" ;boosted_user

global running = 0
global teamID = 0
global team0lobby := "blank"
global team1lobby := "blank"
global lastMove := "blank"
global roundCount = 0
global posfile := "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\banned_ip.cfg"

global outputFile := "\gamestate\output.txt" ;needed for GameState Integration events. See /gamestate/README.md

global aimbot := "blank"
sleep 1000

sleep 60000

startClients()

;Sleep until all clients are open
Loop {
	if(WTSEnumProcesses("csgo") = 10) ;See below - counts number of processes open with title
		break
	Sleep 5000
}
Sleep 20000
aimbot = 0
teamID = 0
FileDelete, %outputFile% ;Clear our GSI file prior to starting
fullOuterLoop() ;Our core loop

WTSEnumProcesses(proc)
{
    local tPtr := pPtr := nTTL := cnt := 0, PList := ""
    if !(DllCall("wtsapi32.dll\WTSEnumerateProcesses", "Ptr", 0, "Int", 0, "Int", 1, "PtrP", pPtr, "PtrP", nTTL))
        return "", DllCall("kernel32.dll\SetLastError", "UInt", -1)

    tPtr := pPtr
    loop % (nTTL)
    {
        if (InStr(PList := StrGet(NumGet(tPtr + 8)), proc))
            cnt++
        tPtr += (A_PtrSize = 4 ? 16 : 24)
    }

    DllCall("wtsapi32.dll\WTSFreeMemory", "Ptr", pPtr)

    return cnt, DllCall("kernel32.dll\SetLastError", "UInt", nTTL)
}

;One client is launched using Steam. This is the master-client, or who we are boosting.
;The other nine clients are launched from individual sandbox clients. These are usually fixed accounts that are the boosting pool, although a couple could be to-be-boosted accounts as well.
;In my case, this was setup using nine different alternative accounts that were each already high elo.
;Naming each Sandboxie box as the users name will make this seperation clean and easy to follow.
;All steam clients are set to launch CSGO, some are also set to use the least resources possible and to auto login.
startClients()
{
	Run *RunAs "C:\Program Files (x86)\Steam\Steam.exe" -applaunch 730 -high
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost1_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost1_user% %boost1_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost2_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost2_user% %boost2_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost3_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost3_user% %boost3_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost4_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost4_user% %boost4_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost5_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost5_user% %boost5_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost6_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost6_user% %boost6_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost7_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost7_user% %boost7_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost8_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost8_user% %boost8_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
	Sleep 15000
	Run *RunAs "C:\Program Files\Sandboxie\Start.exe`" /box:%boost9_user% /elevate `"C:\Program Files (x86)\Steam\Steam.exe`" -single_core -applaunch 730 -login %boost9_user% %boost9_password% -nosound -novid -nojoy -noshader -nofbo -nodcaudio -nomsaa -16bpp -low
}
; To handle killing users. We can choose to do this either with 1) a custom vac-safe cheat or 2) making our own using the resources we have as we own all of the users.
; This is the method to do the later.
; fromClass denotes the window that is playing and killing
; targetClass denotes the window that is being locked on.
aimbot(fromClass, targetClass)
{
	
	WinActivate, ahk_class %fromClass%
	sleep 100
	; See game config. { is our bind to print out our current position to file. We will record this and use it as a variable.
	Send, {. Down}
	Sleep, 20
	Send, {. Up}
	sleep 100
	Send, {. Down}
	Sleep, 20
	Send, {. Up}
	sleep 500
	; Read fromClass current position, store coordinates.
	FileReadLine, exactPos, %posFile%, 1
	FileReadLine, anglePos, %posFile%, 2
	StringSplit, exactArr, exactPos, %A_SPACE%
	StringSplit, angleArr, anglePos, %A_SPACE%
	clientX := Round(exactArr2, 2)
	clientY := Round(exactArr3, 2)
	clientZ := Round(exactArr4, 2)
	clientYa := Round(angleArr6, 2)
	clientP := Round(angleArr5, 2)
	sleep 200
	; Repeat for target class -- yes this should use a common method, I apologize.
	WinActivate, ahk_class %targetClass%
	sleep 100
	Send, {, Down}
	Sleep, 20
	Send, {, Up}
	sleep 100
	Send, {, Down}
	Sleep, 20
	Send, {, Up}
	sleep 500
	FileReadLine, exactPos, %posFile%, 1
	StringSplit, exactArr, exactPos, %A_SPACE%
	;We do not need the angle for the target user. Arguably we could if we wanted to be really accurate about head position but I worried more about body shots since they were more consistent anyway.
	;Additionally, the AFK users are always spinning so their head position couldnt be acquired fast enough for usage.
	targetX := Round(exactArr2, 2)
	targetY := Round(exactArr3, 2)
	targetZ := Round(exactArr4, 2) - 10 ; Aim down in 3D space to aim closer to chest.
	
	;Calculate positional difference
	dX := targetX - clientX
	dY := targetY - clientY
	dZ := targetZ - clientZ
	; delta: %dX%, %dY%, %dZ%
	
	;Here follows the heart of the aim sequence:
	yaw := dllcall("msvcrt\atan2","Double",dY, "Double",dX, "CDECL Double") ;atan2
	
	multiplied := dY * dY + dX * dX
	rooted := sqrt(multiplied)
	pitch := dllcall("msvcrt\atan2","Double",rooted, "Double",dZ, "CDECL Double") ; + 3.14159
	
	;Radian to degree conversions.
	yaw := yaw * 57.2957795131
	pitch := pitch * 57.2957795131 - 90
	sleep 200
	
	;Once the target angle has been calculated, go back to our main player.
	WinActivate, ahk_class %fromClass%
	;%clientX%, %clientY%, %clientZ% %clientA%) > (%targetX%, %targetY%, %targetZ%)
	;yaw: %yaw%, pitch: %pitch%
	sleep 1000
	
	;Let it be known: 19.7628 was my calculated constant for how many pixels corresponded to a degree of motion in 3D space. Found by experiment. YMMV
	;Move the mouse horizontally and vertically, using center offset, depending on the number of angles or target direction
	if(clientYa > 0)
		DllCall("mouse_event", "UInt", 0x01, "UInt", clientYa * 19.7628458 , "UInt", 0)
	else
		DllCall("mouse_event", "UInt", 0x01, "UInt", Abs(clientYa) * 19.7628458 * -1, "UInt", 0)
	if(clientP > 0)
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0 , "UInt", clientP * 19.7628458 * -1)
	else
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Abs(clientP) * 19.7628458)
	DllCall("mouse_event", "UInt", 0x01, "UInt", yaw * 19.7628458 * -1, "UInt", pitch * 19.7628458)
	;We are now locked onto the un-moving users chest.
	
	;This aimbot code is applicable (afaik) for really any aimbot. However, since we know all needed position variables here, we are able to do this in a VAC safe fashion.
 }
endRoundWithAim()
{
	;Depending on our current team, select the right target players, aim at them (aimbot), then shoot them (shootShots).
	if(teamID == 1)
	{
		client1 = %boost1%
		client2 = %boost2%
		client3 = %boost3%
		client4 = %boost4%
		client5 = %boost5%
	}
	else
	{
		client1 = %boost5%
		client2 = %boost6%
		client3 = %boost7%
		client4 = %boost8%
		client5 = %boost9%
	}

	aimbot(liveAccount, client1)
	sleep 500
	shootShots()
	Sleep 1000
	aimbot(liveAccount, client2)
	sleep 500
	shootShots()
	Sleep 1000
	aimbot(liveAccount, client3)
	sleep 500
	shootShots()
	Sleep 1000
	aimbot(liveAccount, client4)
	sleep 500
	shootShots()
	Sleep 10`00
	aimbot(liveAccount, client5)
	sleep 500
	shootShots()
}
shootShots()
{
	;left click a few times. This is overkill in most circumstances which does waste time, but not enough for me to care very much.
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	MouseClick, Left
	Sleep 400
	;Reload after killing to keep our bullet count and timing consistent.
	Send, {r Down}
	Sleep, 20
	Send, {r Up}
	Sleep 700
}
;Checks our GSI for current team score, and checks the score of our active team.
readRoundCount()
{
	FileReadLine, ctscore, %outputFile%, 1
	FileReadLine, tscore, %outputFile%, 2
	FileReadLine, team, %outputFile%, 3
	if(team = "CT")
		return %tscore%
	else
		return %ctscore%

}
;Checks GSI to see our game phase.
readStartRound()
{
	FileReadLine, freezetime, %outputFile%, 4
	
	return %freezetime%
}
;Checks game state (warmup, freezetime .. etc)
readMapPhase()
{
	FileReadLine, stat, %outputFile%, 5
	
	return %stat%
}
;The outer loop that resets our teams etc.
fullOuterLoop()
{
	Loop
	{
		FileDelete, %outputFile% ;Every game, clear our files, switch our team files and put us back into lobbies.

		readyForGame()
		
		;swap teams
		sleep 50000
		if(teamID = 0)
			teamID = 1
		else
			teamID = 0
	}
}
readyForGame() ;This is the key game loop. It creates the lobby, gets the url, has the clients join, starts the queue, and awaits for auto-accepting, then waits for rounds.
{
	
	Sleep 1000
	
	createLobby() ; Get one user to make a new lobby. Specifically, these are the team leaders titled in the steamfetch code
	sleep 5000
	getLobbyURL() ; Ask steamfetch
	Sleep 3000
	joinLobby() ;Connect to our lobbies provided by steamfetch
	; lobbies at %team0lobby% and %team1lobby%

	;Ready to queue! We're going to hope that we get the same lobby, and if we don't we're just gonna crash.
	
	;1373, 1003 - GO
	;Tell our team leaders to start searching for games
	WinActivate, ahk_class %boost1%
	Sleep 500
	MouseClick, left, 1373, 1003
	Sleep 100
	MouseClick, left, 1373, 1003
	Sleep 100
	MouseClick, left, 1373, 1003
	Sleep 100
	
	WinActivate, ahk_class %boost6%
	Sleep 500
	MouseClick, left, 1373, 1003
	Sleep 100
	MouseClick, left, 1373, 1003
	Sleep 100
	MouseClick, left, 1373, 1003

	;Wait for green color (Accept Button)
	infinitegg = 0
	Loop
	{
		;Waiting for match found ...
		PixelSearch, outX, outY, 321, 222, 376, 278, 0x3D5318, 15
		if ErrorLevel
		{
			sleep 100
			infinitegg++
			;;If we end up waiting too long, just stop.
			if(infinitegg >= 2400) { ; 4 minutes
				Shutdown, 6 ;Our emergency abort. See notes.
				Sleep 10000
				return
			}
			continue
		}
		else
			break ;Detected good color
		sleep 100
	}
	;ACCEPT BUTTON FOUND
	Sleep 1000
	;ACCEPT GAME
	WinActivate, ahk_class %boost1%
	PixelSearch, outX, outY, 321, 222, 376, 278, 0x3D5318, 15
	if ErrorLevel
	{
		;UNMATCHING GAME ... EXITING
		return
	}
	; accepting... match game found (likely)
	;accept all
	acceptMatch()
	Sleep 80000 ;Wait a long time.
	WinActivate, ahk_class %liveAccount%
	;Open our console
	Send, {`` Down}
	Sleep, 20
	Send, {`` Up}
	;Configuration presets
	Sleep 200
	Send, -left
	Send, {Enter}
	Sleep 200
	;Close console
	Send, {`` Down}
	Sleep, 20
	Send, {`` Up}
	Sleep 100
	;By pressing escape twice, we reset all potential UI flaws that have a tendency of happening in CS.
	Send, {esc Down}
	Sleep, 20
	Send, {esc Up}
	Sleep 800
	Send, {esc Down}
	Sleep, 20
	Send, {esc Up}
	;Wait form warmup to end
	Sleep 3000l
	;This will repeat for our 16 rounds, and end the loop at the end of the game.
	roundCount = 0
	Loop
	{
		awaitRound()
		roundCount++
		if(roundCount = 16)
			return
	}
}
joinLobby() ;With getLobbyUrl, this goes through and joins the lobby on all clients.
{
	;1-4 join team0lobby
	;6-9 join team1lobby
	;5 joins whichever liveAccount doesn't.
	
	;replace w non fixed acc ids
	;Just pass the launch parameter to all of our copies.
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost1_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team0lobby% ;2
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost2_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team0lobby% ;3
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost3_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team0lobby% ;4
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost6_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team1lobby% ;7
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost7_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team1lobby% ;8
	Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost8_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team1lobby% ;9
	
	;Switch off for removable-user. See notes.
	if(teamID == 0)
	{
		Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost4_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team1lobby% ;5
		Run, `"C:\Program Files (x86)\Steam\Steam.exe`" %team0lobby% ;userclient
	}
	else
	{
		Run, `"C:\Program Files\Sandboxie\Start.exe`" /box:%boost4_user% `"C:\Program Files (x86)\Steam\Steam.exe`" %team0lobby% ;5
		Run, `"C:\Program Files (x86)\Steam\Steam.exe`" %team1lobby% ;userclient
	}
	Sleep 3000
	;Pressing enter will skip the screen that asks if you want to leave the current lobby. yes, this should be in a loop.
	WinActivate, ahk_class %boost1%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	;Exec boost config
	openConsoleRunCmd()

	WinActivate, ahk_class %boost2%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost3%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost4%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost5%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost6%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost7%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost8%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %boost9%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()

	WinActivate, ahk_class %liveAccount%
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	openConsoleRunCmd()


	Sleep 500

}
acceptMatch() ;Goes through all clients, clicking the accept button
{
	WinActivate, ahk_class %boost1%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100

	WinActivate, ahk_class %boost2%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100


	WinActivate, ahk_class %boost3%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100


	WinActivate, ahk_class %boost4%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100

	WinActivate, ahk_class %boost5%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100


	WinActivate, ahk_class %boost6%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100


	WinActivate, ahk_class %boost7%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100


	WinActivate, ahk_class %boost8%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100

	WinActivate, ahk_class %boost9%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100

	WinActivate, ahk_class %liveAccount%
	Sleep 500
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100
	MouseClick, left, 483, 246
	Sleep 100

}
createLobby() ;does createGame on both clients
{
	;Create the lobbies on the main accounts.
	WinActivate, ahk_class %boost1%
	createGame()
	Sleep 1000
	WinActivate, ahk_class %boost6%
	createGame()

}
getLobbyURL() ;connects to web to fetch a lobby URL (see steamfetch)
{
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://localhost/steam_getServer.php?id=1", true)
	whr.Send()
	whr.WaitForResponse()
	team0lobby := whr.ResponseText
	
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://localhost/steam_getServer.php?id=2", true)
	whr.Send()
	whr.WaitForResponse()
	team1lobby := whr.ResponseText

}
openConsoleRunCmd() ;runs exec boost
{
	sleep 100
	Send, {`` Down}
	Sleep, 20
	Send, {`` Up}
	
	Sleep 300
	Send, exec boost
	Send, {Enter}
	Sleep 300
	
	Send, {`` Down}
	Sleep, 20
	Send, {`` Up}
	sleep 100

	
}
createGame() ;Clicks buttons to create a new lobby
{
	;Engage in the new compet lobby menu
	Sleep 1000
	openConsoleRunCmd()
	sleep 1000
	MouseClick, left, 483, 29
	Sleep 500
	MouseClick, left, 483, 29
	Sleep 500
	MouseClick, left, 483, 29
	Sleep 500
	MouseClick, left, 483, 29
	Sleep 1500
	MouseClick, left, 464, 132
	Sleep 500
	MouseClick, left, 464, 132
	Sleep 500
	MouseClick, left, 464, 132
	Sleep 500
	MouseClick, left, 464, 132
	Sleep 100
	;Are you sure you would like to leave your current lobby?
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 500
	Send, {Enter Down}
	Sleep, 20
	Send, {Enter Up}
	Sleep 2000
}	
awaitRound() ;Waits for white text indicating the start of a round
{
	;Waiting for round START
	if(readRoundCount() >= 1) ;We missed the first round.
	{
		Shutdown, 6 ;See notes.
		Sleep 5000
		return
	}
	WinActivate, ahk_class %liveAccount%
	; Waiting for Round to Begin
	infinitegg = 0
	;Very similar to waiting for the accept match button. This could have been broken in to its own function
	Loop
	{
		;This is a terrible way of doing it but is a legacy code from before GSI was implemented.
		PixelGetColor, color, 954, 12
		;This is literally just waiting for the round time countdown at the top to switch from red to white (its red for the last 10 seconds of the freezetime countdown prior to the round beginning)
		if color = 0xFFFFFF ;Color is now white. It wasn't before, so this is a new round.
		{
			break
		}
		infinitegg++
		if(infinitegg >= 600) {
			Shutdown, 6 ;See notes
			Sleep 10000
			return
		}
		sleep 100
	}
	; ROUND ENDED
	Sleep 2000
	dcAndRejoin() ;See notes - we are having the accounts were not playing with and not killing disconnect to make sure they dont get in our way when moving out of spawn.
	
	WinActivate, ahk_class %liveAccount%
	sleep 1000
	readyForGameTime()
}
;we bind k to disconnect in our settings.
sendDisconnect() ;Disconnects
{
	Send, {k Down}
	Sleep, 20
	Send, {k Up}
}
;Click the competitive Reconnect button at the top.
sendReconnect() ;Reconnects
{
	MouseClick, left, 985, 120
}
;After we disconnect we can immediately reconnect since the round has already started and we wont be playing in it.
dcAndRejoin() ; Disconnects alternative clients and rejoins them
{
	; Round Began! Disconnecting alternates
	if(teamID == 0)
	{
		client2 = %boost1%
		client3 = %boost2%
		client4 = %boost3%
		client5 = %boost4%
	}
	else
	{
		client2 = %boost6%
		client3 = %boost7%
		client4 = %boost8%
		client5 = %boost9%
	}
	WinActivate, ahk_class %client2%
	sendDisconnect()
	sleep 500
	WinActivate, ahk_class %client3%
	sendDisconnect()
	sleep 500
	WinActivate, ahk_class %client4%
	sendDisconnect()
	sleep 500
	WinActivate, ahk_class %client5%
	sendDisconnect()
	Sleep 6000
	; Reconnecting ;reconnect button is 985, 120
	WinActivate, ahk_class %client2%
	sendReconnect()
	sleep 500
	WinActivate, ahk_class %client3%
	sendReconnect()
	sleep 500
	WinActivate, ahk_class %client4%
	sendReconnect()
	sleep 500
	WinActivate, ahk_class %client5%
	sendReconnect()
	sleep 500

}
;Detects the start of game, fetches our current position, and moves accordingly.
readyForGameTime() ;Gets current position, and does movement.
{
	; First, determine where our client is using color data.
	; Second, trigger the corresponding move action.
	
	; Load in position from file
	Send, {, Down}
	Sleep, 20
	Send, {, Up}
	sleep 200
	
	FileReadLine, currentPosition, %posFile%, 1
	StringSplit, textArray, currentPosition, %A_SPACE%
	roundedInt := Round(textArray2, 2)
	;fetch current position
	;based on a single coord value, run our predetermined movement scripts.
	If(roundedInt = -144.17)
		vertct1()
	else if(roundedInt = -157.56)
		vertct2()
	else if(roundedInt = -184.77)
		vertct3() 
	else if(roundedInt = -197.83)
		vertct4()
	else if(roundedInt = -239.13)
		vertct5()
	else if(roundedInt = -260.77)
		vertct6()
	else if(roundedInt = -273.83)
		vertct7()
	else if(roundedInt = -315.14)
		vertct8()
	else if(roundedInt = -32.71)
		vertct9()
	else if(roundedInt = -324.89)
		vertct10()
	else if(roundedInt = -370.39)
		vertct11()
	else if(roundedInt = -67.04)
		vertct12()
	else if(roundedInt = -400.89)
		vertct13()
	else if(roundedInt = -446.39)
		vertct14()
	else if(roundedInt = -85.62)
		vertct15()
	else if(roundedInt = -1243.86)
		vertt1()
	else if(roundedInt = -1244.12)
		vertt2()
	else if(roundedInt = -1272.23)
		vertt3()
	else if(roundedInt = -1303.98)
		vertt4()
	else if(roundedInt = -1356.22)
		vertt5()
	else if(roundedInt = -1368.14)
		vertt6()
	else if(roundedInt = -1379.24)
		vertt7()
	else if(roundedInt = -1431.62)
		vertt8()
	else if(roundedInt = -1441.29)
		vertt9()
	else if(roundedInt = -1500.05)
		vertt10()
	else if(roundedInt = -1502.21)
		vertt11()
	else if(roundedInt = -1548.95)
		vertt12()
	else if(roundedInt = -1576.03)
		vertt13()
	else if(roundedInt = -1612.94)
		vertt14()
	else if(roundedInt = -1617.93)
		vertt15()
	;after we have done the initial move, then do the long run. The previous movements will put the user in a designated spot, be it T or CT side, and this will then move them from that spot always across the map. We put them into a fixed position above that is always constant to simplify the long run.
	if(lastMove = "ct")
		longrun()
	else
		tlongrun()
	
	;fire them guns
	Send, {2 Down}
	Sleep, 20
	Send, {2 Up}
	Sleep 500
	
	;If using a VACable aimbot, this method will press the lock key (l) and then kill the target. This code has been defunct for a long time.
	if(aimbot == 1)
	{
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 500
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 1000

		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 500
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 1000

		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 500
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 1000

		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 500
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 1000

		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 500
		Send, {l Down}
		Sleep, 20
		Send, {l Up}
		Sleep 250
		MouseClick, Left
		Sleep 1000
	}
	else
	{
		;uses scripted aimbot to kill remaining users
		endRoundWithAim()
	}
	;Last round, dont repeat
	if(roundCount = 15)
		return
	;If somehow we lost count and our GSI is now saying the game is over, just end it
	if(readMapPhase() = "gameover")
	{
		roundCount = 15
		return
	}
	;Wait for next freezetime to begin.
	infinitegg = 0
	Loop
	{
		result := readStartRound()
		if(result = "freezetime")
		{
			; Round ENDED
			Sleep 12000
			break
		}
		infinitegg++
		if(infinitegg >= 120) {
			Shutdown, 6
			Sleep 10000
			return
		}

		sleep 300
	}
	;We're done with this round. Let's wait for another one.
	
	return
}
;debug tool
^r:: ; press control+r to reload
    Reload
  return
