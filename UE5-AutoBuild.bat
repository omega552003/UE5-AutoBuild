@ECHO OFF

REM This is supposed to identify if its updating or installing the engine.
IF EXIST UnrealEngine\ (
  ECHO "Unreal Engine found, updating."
  CD UnrealEngine
  REM Setting current location to var
  SET "UEInstallDir=%cd%"
  ECHO %UEInstallDir%
  git remote add origin https://github.com/EpicGames/UnrealEngine.git
  git fetch
  git reset --hard HEAD
  git merge origin/release
  git pull origin release
) ELSE (
  ECHO "Unreal Engine not found, cloning."
  git clone -b release https://github.com/EpicGames/UnrealEngine.git
  CD UnrealEngine
  REM Setting current location to var
  SET "UEInstallDir=%cd%"
  ECHO %UEInstallDir%
)

REM Run UE5's build scripts
CALL Setup.bat
CALL GenerateProjectFiles.bat

REM Finding location of MSbuild.exe
FOR /F "delims=" %i IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe') DO set VSInstallDir=%i
ECHO %VSInstallDir%

REM Build project in VS commandline
"%VSInstallDir%" -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln
