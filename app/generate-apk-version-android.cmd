@echo off

:: Variables
set "appPath=%cd%\build\app\outputs\flutter-apk"
set "appName=app-release"
set "finalName=SupplySync"
set "outputPath=%cd%\apk"
set "pubspecPath=pubspec.yaml"

:: Obtenha a versão do pubspec.yaml
for /f "tokens=2 delims= " %%a in ('findstr /r "^version: " "%pubspecPath%"') do set version=%%a
set version=%version:+=_%
echo Version: %version%

:: Compile
echo Compiling build with Flutter
call flutter build apk --target-platform android-arm,android-arm64,android-x64

:: Create dirs
if not exist %outputPath% mkdir %outputPath%

:: Copy .apk to output path
copy /b /y /v %appPath%\%appName%.apk %outputPath%\
:: Delete older file if exists
if exist %outputPath%\%finalName%_%version%.apk del %outputPath%\%finalName%_%version%.apk

:: Rename the file
rename %outputPath%\%appName%.apk %finalName%_%version%.apk

echo Done: %outputPath%\%finalName%_%version%.apk
pause