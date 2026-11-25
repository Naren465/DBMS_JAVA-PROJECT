@echo off
echo ===================================================
echo CRUISEBUS - System Launcher (MySQL + Tomcat)
echo ===================================================

echo [1/3] Checking MySQL Service...
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo MySQL is already running.
) else (
    echo Starting MySQL Server...
    start "" /D "C:\xampp" "C:\xampp\mysql\bin\mysqld.exe" --defaults-file=C:\xampp\mysql\bin\my.ini --standalone
    timeout /t 3 /nobreak > nul
)

echo [2/3] Checking Apache Tomcat...
tasklist /FI "IMAGENAME eq tomcat8.exe" 2>NUL | find /I /N "tomcat8.exe">NUL
set TOMCAT_RUNNING=%ERRORLEVEL%
if "%TOMCAT_RUNNING%"=="0" (
    echo Tomcat is already running.
) else (
    echo Starting Apache Tomcat...
    set "JAVA_HOME=C:\Program Files\Java\jdk-26.0.1"
    set "CATALINA_HOME=C:\xampp\tomcat"
    start "CruiseBus Tomcat Server" /D "C:\xampp\tomcat" "C:\xampp\tomcat\bin\catalina.bat" run
    timeout /t 3 /nobreak > nul
)

echo [3/3] Opening CRUISEBUS Web Application...
start http://localhost:8080/cruisebus/home

echo ===================================================
echo CRUISEBUS is now live!
echo Homepage:    http://localhost:8080/cruisebus/home
echo Search/Fleet: http://localhost:8080/cruisebus/search
echo Ticket PNR:  http://localhost:8080/cruisebus/ticket?pnr=LA325478
echo Admin Panel: http://localhost:8080/cruisebus/admin?demo_admin=true
echo ===================================================
pause
