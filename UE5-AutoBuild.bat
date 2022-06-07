@ECHO OFF

REM This is supposed to identify if its updating or installing the engine.
if exist UnrealEngine\ (
  ECHO "Unreal Engine found, updating."
  cd UnrealEngine
  git remote add origin https://github.com/EpicGames/UnrealEngine.git
  git fetch
  git reset --hard HEAD
  git merge origin/release
  git pull origin release
) else (
  ECHO "Unreal Engine not found, cloning."
  git clone -b release https://github.com/EpicGames/UnrealEngine.git
  cd UnrealEngine
)

REM Run UE5's build scripts
call Setup.bat
call GenerateProjectFiles.bat

REM Build project in VS commandline
"C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\MSbuild.exe" -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln
