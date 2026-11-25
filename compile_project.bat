@echo off
echo ===================================================
echo CRUISEBUS - Compiling Java MVC Codebase
echo ===================================================

set "JAVA_HOME=C:\Program Files\Java\jdk-26.0.1"
set "TOMCAT_LIB=C:\xampp\tomcat\lib"
set "WEBAPP_LIB=src\main\webapp\WEB-INF\lib"
set "OUT_DIR=src\main\webapp\WEB-INF\classes"

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

set "CP=%TOMCAT_LIB%\servlet-api.jar;%TOMCAT_LIB%\jsp-api.jar;%WEBAPP_LIB%\mysql-connector-j-8.3.0.jar;%WEBAPP_LIB%\gson-2.10.1.jar;%WEBAPP_LIB%\jstl-1.2.jar"

echo [1/3] Compiling Java classes with javac...
"%JAVA_HOME%\bin\javac.exe" -cp "%CP%" -d "%OUT_DIR%" src\main\java\com\cruisebus\model\*.java src\main\java\com\cruisebus\util\*.java src\main\java\com\cruisebus\dao\*.java src\main\java\com\cruisebus\controller\*.java src\main\java\com\cruisebus\filter\*.java

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Compilation successful!
echo [3/3] Deploying to Tomcat C:\xampp\tomcat\webapps\cruisebus ...
if not exist "C:\xampp\tomcat\webapps\cruisebus" mkdir "C:\xampp\tomcat\webapps\cruisebus"
xcopy /E /I /Y "src\main\webapp\*" "C:\xampp\tomcat\webapps\cruisebus\" > nul

echo ===================================================
echo CruiseBus deployed successfully to Tomcat!
echo Access the site at: http://localhost:8080/cruisebus/home
echo ===================================================
pause
