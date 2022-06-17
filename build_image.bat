@echo off
SETLOCAL

:: Set TimeStamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "fullTimeStamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

:: Read .env value to env
for /f "delims== tokens=1,2" %%G in (.env) do set %%G=%%H

set imageName=flask_playground

:: Stop and rm old container
FOR /F %%k in ('%dockerCli% ps -a -q --filter="ancestor=%imageName%:latest" --format="{{.ID}}" -q') DO (
%dockerCli% stop %%k
%dockerCli% rm %%k
)

:: Build the latest image
%dockerCli% build -t %imageName%:%fullTimeStamp% -t %imageName%:latest .

:: Clean history image
FOR /F %%k in ('%dockerCli% images %imageName% -f "before=%imageName%:latest" -q') DO (%dockerCli% rmi %%k)

:: Run New container
%dockerCli% run -d -p 5000:5000 %imageName%:latest



ENDLOCAL