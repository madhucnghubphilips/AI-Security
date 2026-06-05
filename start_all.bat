@echo off
setlocal EnableExtensions

cd /d "%~dp0"

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker was not found. Install Docker Desktop first.
  exit /b 1
)

docker compose version >nul 2>nul
if errorlevel 1 (
  docker-compose version >nul 2>nul
  if errorlevel 1 (
    echo Docker Compose was not found. Install Docker Desktop with Compose support.
    exit /b 1
  )
  set "COMPOSE=docker-compose"
) else (
  set "COMPOSE=docker compose"
)

set "ACTION=%~1"
if "%ACTION%"=="" set "ACTION=up"

if /I "%ACTION%"=="up" goto UP
if /I "%ACTION%"=="start" goto UP
if /I "%ACTION%"=="build" goto BUILD
if /I "%ACTION%"=="down" goto DOWN
if /I "%ACTION%"=="stop" goto DOWN
if /I "%ACTION%"=="logs" goto LOGS
if /I "%ACTION%"=="status" goto STATUS
if /I "%ACTION%"=="ps" goto STATUS
if /I "%ACTION%"=="help" goto HELP
if /I "%ACTION%"=="-h" goto HELP
if /I "%ACTION%"=="--help" goto HELP
goto HELP_ERROR

:UP
%COMPOSE% config --quiet
if errorlevel 1 exit /b 1
call :PRINT_URLS
%COMPOSE% up --build
exit /b %ERRORLEVEL%

:BUILD
%COMPOSE% config --quiet
if errorlevel 1 exit /b 1
%COMPOSE% build
exit /b %ERRORLEVEL%

:DOWN
%COMPOSE% down
exit /b %ERRORLEVEL%

:LOGS
%COMPOSE% logs
exit /b %ERRORLEVEL%

:STATUS
%COMPOSE% ps
exit /b %ERRORLEVEL%

:HELP_ERROR
call :HELP
exit /b 1

:HELP
echo Usage:
echo   start_all.bat          Build and start everything
echo   start_all.bat up       Build and start everything
echo   start_all.bat build    Build Docker images only
echo   start_all.bat down     Stop containers
echo   start_all.bat logs     Show container logs
echo   start_all.bat status   Show container status
exit /b 0

:PRINT_URLS
echo.
echo Apps:
echo   LLM01 Prompt Injection                  http://localhost:8501
echo   LLM02 Sensitive Information Disclosure  http://localhost:8502
echo   LLM03 Supply Chain Kontra Style         http://localhost:8503
echo   LLM04 Data and Model Poisoning          http://localhost:8504
echo   LLM05 Improper Output Handling          http://localhost:8505
echo   LLM06 Excessive Agency                  http://localhost:8506
echo   LLM07 System Prompt Leakage             http://localhost:8507
echo   LLM08 Vector and Embedding Weaknesses   http://localhost:8508
echo   LLM09 Misinformation                    http://localhost:8509
echo   LLM10 Unbounded Consumption             http://localhost:8510
echo   RAG Chatbot                             http://localhost:8000
echo   Ollama API                              http://localhost:11434
echo.
echo First run note:
echo   Ollama model downloads can take several minutes.
echo   Keep this terminal open while the apps are running.
echo.
exit /b 0
