@ECHO OFF


REM This is supposed to identify if its updating or installing the engine.
if exist UnrealEngine\ (
  ECHO "Unreal Engine found, updating."
  cd UnrealEngine
  REM Setting current location to var
  set "ueinstallloc=%cd%"
  echo %ueinstallloc%
  git remote add origin https://github.com/EpicGames/UnrealEngine.git
  git fetch
  git reset --hard HEAD
  git merge origin/release
  git pull origin release
) else (
  ECHO "Unreal Engine not found, cloning."
  git clone -b release https://github.com/EpicGames/UnrealEngine.git
  cd UnrealEngine
  REM Setting current location to var
  set "ueinstallloc=%cd%"
  echo %ueinstallloc%
)

REM Run UE5's build scripts
call Setup.bat
call GenerateProjectFiles.bat

REM Finding location of MSbuild.exe
FOR /F "delims=" %i IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe') DO set vsinstallloc=%i
echo %vsinstallloc%


REM Build project in VS commandline
"%vsinstallloc%" -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln
