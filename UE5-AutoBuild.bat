@ECHO OFF
SET "UEInstallDir="
SET "UErepo="
SET "UEStat="
SET "VSInstallDir="

:input
CLS
ECHO                               ..°°°********°°°..                               
ECHO                        .°*oO###@@@@@@@@@@@@@@@@###Oo*°.                        
ECHO                    °*O##@@@@@@@###OOOOOOOOOO###@@@@@@@@#Oo°.                   
ECHO                .*O#@@@@@##Oo*°..              ..°*oO##@@@@@#O*.                
ECHO             .*O@@@@@#Oo°.                            .°oO#@@@@@O*.             
ECHO           .o#@@@@#O°.                                    .°o#@@@@#o°           
ECHO         .O@@#@@O*.              .°*o*°                      .*O@@#@@O.         
ECHO        o@@##@O°             °*O##@O°                  .°**.    °O@##@@o        
ECHO      .#@##@#*           .*O#@@@@@*               .°oO#@@o.       *#@##@#.      
ECHO     °#@##@O.         .*O@@@@#####*        .*° .*O#@@@@O.          .O@##@#°     
ECHO    .####@O         .o#@@##########*°       °###@@####o              O@###@°    
ECHO    #@####        .o#@@@@@@@@#####@@@.       °@######@°               O#####    
ECHO   *@###@°       °#@@@@Oo***#########.       .#######@°               .####@o   
ECHO   ####@O       o@@@#*.     *@#######.       °@######@°                O@####   
ECHO  .#@##@o      *@@O°        *@#####@#.       .@######@°                *@###@.  
ECHO  .####@o     .@#°          *@#####@#.       .@######@°                *@###@.  
ECHO   #@##@O     oo            *@#####@#.       °@######@°                o@##@#   
ECHO   o@####.    .             *@#####@#.       .@######@°         ..     ####@O   
ECHO   .####@O                  *@#####@#        *@######@°      .*o*     o@###@.   
ECHO    *@###@o                 *@#######O*°°*oO#@########O*°°*o##o.     *@###@*    
ECHO     *@###@o           ....°O########@@@@@@@#@@#######@@@@@#*       o@###@o     
ECHO      *@@##@O.         .o#@@@@#############@@##@@@@@@@@#O*.       .O@##@@*      
ECHO       .O@@#@#o.          .*O#@@@@@@@@@#@@@O°  .*oO#Oo°.         o#@#@@#°       
ECHO         *#@@#@#o.            .°*oOO#####o.                   .o#@#@@#*         
ECHO           *#@@@@#O*.                 ..                   .*O#@@@@#*.          
ECHO             °O#@@@@#O*°                                °*O#@@@@#O*             
ECHO               .*O#@@@@@#Oo*°.                    .°*oO#@@@@@#O*.               
ECHO                  .°oO#@@@@@@@##Oooo********oooOO#@@@@@@@#Oo°.                  
ECHO                       °*oO##@@@@@@@@@@@@@@@@@@@@@@##Oo*°.                      
ECHO                            ..°°*oooOOOOOOOOooo*°°..                            
ECHO
ECHO                    Unreal Engine 5 Automated Build Script
ECHO.
ECHO This will perform the following:
ECHO - TODO/WIP Check prerequisits
ECHO - TODO/WIP Input user options for project
ECHO - Clone or Update Unreal Engine 5 from Git Hub
ECHO - Download and setup binaries and prerequisits
ECHO - Generate files for the project to build
ECHO - Build the project
ECHO.
SET /P "go=OK to continue with building? (y/n): "
IF /i %go% EQU n ( GOTO:EOF ) ELSE ( IF /i %go% NEQ y ( GOTO input ) )
CLS                                                                                
SET UErepo="https://github.com/EpicGames/UnrealEngine.git"

REM Prereqs https://stackoverflow.com/questions/14691494/check-if-command-was-successful-in-a-batch-file
REM Finding location of MSbuild.exe
FOR /F "delims=" %%i IN ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe') DO (
SET VSInstallDir="%%i"
)

REM This is supposed to identify if its updating or installing the engine.
IF EXIST UnrealEngine\ (
ECHO Unreal Engine found, updating.
SET "UEStat=u"
GOTO UEDir
) ELSE (
ECHO Unreal Engine not found, cloning.
SET "UEStat=c"
GOTO clone
)

:UEDir
REM Setting current working directory to Unreal Engine source root 
CD UnrealEngine
SET UEInstallDir="%cd%"
REM Determine what we're doing next
IF %UEStat% EQU c ( GOTO build )
IF %UEStat% EQU u ( GOTO update )

:clone
GIT clone -b release %UErepo%
GOTO UEDir
)

:update
REM First Git command may not be needed
GIT remote add origin %UErepo%
GIT fetch
GIT reset --hard HEAD
GIT merge origin/release
GIT pull origin release
)

:build
REM Run UE5's build scripts
CALL Setup.bat
CALL GenerateProjectFiles.bat
REM Build project in VS commandline
%VSInstallDir% -m /t:Engine\UE5 /p:Configuration="Development Editor" /p:Platform=Win64 UE5.sln

:end
REM Cleanup
SET "go="
SET "UEInstallDir="
SET "UErepo="
SET "UEStat="
SET "VSInstallDir="
GOTO:eof
