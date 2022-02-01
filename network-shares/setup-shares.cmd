:: (c) Sebastian Resch
:: Setup Network - Shares
:: Share Source:
:: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh750728(v=ws.11)
:: NTFS Source:
:: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc753525(v=ws.10)?redirectedfrom=MSDN
@echo OFF
goto:main

:createFolder
    SETLOCAL ENABLEDELAYEDEXPANSION
        set ntfsPath=%~1
		if exist "%ntfsPath%" (
			echo %ntfsPath% existiert bereits!
		) else (
			mkdir "%ntfsPath%"
			echo %ntfsPath%	wurde erstellt!
		)
		icacls %ntfsPath% /setowner "SYSTEM"
    ENDLOCAL
EXIT /B 0

:createShare
    SETLOCAL ENABLEDELAYEDEXPANSION
        set shareName=%~1
        set ntfsPath=%~2
		net share %shareName% /delete
		net share %shareName%=%ntfsPath% /grant:"Authenticated Users",full
    ENDLOCAL
EXIT /B 0

:ntfsSetFullControl
    SETLOCAL ENABLEDELAYEDEXPANSION
        set ntfsPath=%~1
		set principal=%~2
		icacls %ntfsPath% /grant %principal%:(OI)(CI)F /q
		echo %ntfsPath% += %principal%: Vollzugriff
    ENDLOCAL
EXIT /B 0

:ntfsSetModify
    SETLOCAL ENABLEDELAYEDEXPANSION
        set ntfsPath=%~1
		set principal=%~2
		icacls %ntfsPath% /grant %principal%:(OI)(CI)M /q
		echo %ntfsPath% += %principal%: Andern
    ENDLOCAL
EXIT /B 0

:ntfsSetReadOnly
    SETLOCAL ENABLEDELAYEDEXPANSION
        set ntfsPath=%~1
		set principal=%~2
		icacls %ntfsPath% /grant %principal%:(OI)(CI)R
		echo %ntfsPath% += %principal%: Lesen
    ENDLOCAL
EXIT /B 0

:: Run Main
:main
:: Absolute Path
set basePath=C:\Laufwerke
:: Relative Path
::(starting in execution directory)
::set basePath=%CD%\Laufwerke
:: Create Folders
call:createFolder "%basePath%"
call:createFolder "%basePath%\IT"
call:createFolder "%basePath%\Handel"
call:createFolder "%basePath%\Produktion"
call:createFolder "%basePath%\Verwaltung"
:: Create Shares
:: LWK => Laufwerk
call:createShare "LWK-IT" "%basePath%\IT"
call:createShare "LWK-Handel" "%basePath%\Handel"
call:createShare "LWK-Produktion" "%basePath%\Produktion"
call:createShare "LWK-Verwaltung" "%basePath%\Verwaltung"

:: Basis Konfiguration
:: Set Permission ::
:: Administratoren
::	-> alles	VOLLZUGRIFF
::	-> IT		VOLLZUGRIFF
:: HelpDesk
::	-> andere	LESEN
call:ntfsSetFullControl "%basePath%" "DL_SR_IT-Admins"
call:ntfsSetReadOnly "%basePath%" "DL_SR_HD_Handel"
call:ntfsSetReadOnly "%basePath%" "DL_SR_HD_Produktion"
call:ntfsSetReadOnly "%basePath%" "DL_SR_HD_Verwaltung"
:: Abteilung: IT-Admins
call:ntfsSetFullControl "%basePath%\IT" "DL_SR_IT-Admins"

:: Set Permission ::
:: Mitarbeiter
::	-> eigenes	ÄNDERN
:: HelpDesk
::	-> eigenes	VOLLZUGRIFF

:: Abteilung: Handel
call:ntfsSetModify "%basePath%\Handel" "DL_SR_Handel"
call:ntfsSetFullControl "%basePath%\Handel" "DL_SR_HD_Handel"
:: Abteilung: Produktion
call:ntfsSetModify "%basePath%\Produktion" "DL_SR_Produktion"
call:ntfsSetFullControl "%basePath%\Produktion" "DL_SR_HD_Produktion"
:: Abteilung: Verwaltung
call:ntfsSetModify "%basePath%\Verwaltung" "DL_SR_Verwaltung"
call:ntfsSetFullControl "%basePath%\Verwaltung" "DL_SR_HD_Verwaltung"

:: Read for built-in Administrators
call:ntfsSetReadOnly "%basePath%" "Administrators"
:: Disable Inheritence
icacls %basePath% /inheritancelevel:r