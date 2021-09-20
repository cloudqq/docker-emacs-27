REM #!/usr/bin/env bash

SET USER=cloudqq
SET WORKDIR=/mnt/workspace
SET VOL_HOME=home20210920
SET DISPLAY=192.168.2.6:0.0

SET EMACS_DIR=C:\\Users\\cloudqq\\Dropbox\\workdir\\mydoc\\2021\\emacs

REM docker volume create %VOL_HOME%

echo %CD%
docker run -ti --rm  ^
 -e HTTP_PROXY=http://192.168.2.100:1088 ^
 -e HTTP_PROXY=http://1921.68.2.100:1088 ^
 -v %VOL_HOME%:/home/%USER% ^
 -v %CD%:%WORKDIR% ^
 -v %EMACS_DIR%:/home/%USER%/.emacs.d ^
 -e DISPLAY=%DISPLAY% ^
 -v /etc/localtime:/etc/localtime:ro ^
 -e UNAME="%USER%" ^
 -e GNAME="%USER%" ^
 -e UID="1000" ^
 -e GID="1000" ^
 -e UHOME="/home/%USER%" ^
 -e WORKSPACE="%WORKDIR%" ^
 -w "%WORKDIR%" ^
testemacs:latest
