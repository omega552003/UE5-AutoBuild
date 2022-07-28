@ECHO OFF
SET "UEInstallDir="
SET "UErepo="
SET "UEStat="
SET "VSInstallDir="

SET UErepo="https://github.com/EpicGames/UnrealEngine.git"

REM Prereqs
REM Finding location of MSbuild.exe
FOR /F "delims=" %%i IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe') DO (
SET VSInstallDir="%%i"
ECHO MSBUILD found at: 
ECHO %VSInstallDir%
)

REM This is supposed to identify if its updating or installing the engine.
IF EXIST UnrealEngine\ (
ECHO Unreal Engine found, updating.
SET UEStat=u
ECHO %UEStat%
GOTO update
) ELSE (
ECHO Unreal Engine not found, cloning.
SET UEStat=c
ECHO %UEStat%
GOTO clone
)

:UEDir
REM Setting current working directory to Unreal Engine source root 
CD UnrealEngine
SET UEInstallDir="%cd%"
ECHO %UEInstallDir%
IF %UEStat%==c (
SET "UEStat="
GOTO build
)
IF %UEStat%==u (
SET "UEStat="
GOTO update
)

:clone
IF %UEStat%==c (
GIT clone -b release %UErepo%
GOTO UEDir
)

:update
IF %UEStat%==u (
GOTO UEDir
) ELSE (
GIT remote add origin %UErepo%
GIT fetch
GIT reset --hard HEAD
GIT merge origin/release
GIT pull origin release
)
pause

:build
REM Run UE5's build scripts
CALL Setup.bat
CALL GenerateProjectFiles.bat
REM Build project in VS commandline
%VSInstallDir% -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln

:end
SET "UEInstallDir="
SET "UErepo="
SET "UEStat="
SET "VSInstallDir="
pause
GOTO:eof
