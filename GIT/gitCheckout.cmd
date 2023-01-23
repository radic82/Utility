@echo off
SETLOCAL ENABLEEXTENSIONS
SET PROJECT_BASE_PATH=C:\myExampe
rem in project_list variable put all projects that you have to checkout separated by space
SET PROJECT_LIST=prj1 prj2 project3

echo *** SELECT Version ***
echo [1] - v23.1
echo [2] - v23.2

set VER=
set /P VER=put your choice:

if "%VER%" == "1" (
	SET VERSION=v23.1.0
)
if "%VER%" == "2" (
	SET VERSION=v23.2.0
)

for %%b in (%PROJECT_LIST%) do ( 
    echo cd %PROJECT_BASE_PATH%\%%b
    git checkout %VERSION%  
)
