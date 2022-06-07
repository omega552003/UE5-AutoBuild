@ECHO OFF
REM This is supposed to only download updates/missing files, but it just re-initializes the project
git clone -b release https://github.com/EpicGames/UnrealEngine.git

REM Run UE5's build scripts
cd UnrealEngine
call Setup.bat
call GenerateProjectFiles.bat

REM Build project in VS commandline
"C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\MSbuild.exe" -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln
