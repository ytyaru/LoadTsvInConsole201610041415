@echo off
::
:: q�R�}���h�̃e�X�g
::
:: TSV�t�@�C������SQL��select���ɂăf�[�^���擾����B
::

:: q�R�}���h
:: http://harelba.github.io/q/
set q=C:\root\tool\System\q-1.5.0\bin\q.bat

:: �Ώۃt�@�C��
set Tsv_Account=GitHubAccount.tsv
set Tsv_Token=GitHubAccessToken.tsv
set Tsv_OAuth=GitHubOAuthApplication.tsv
set TABLE=%Tsv_Account%

:: �S���[�U���擾����
setlocal enabledelayedexpansion
set USERS=
for /f "usebackq tokens=*" %%i in (`%q% -H -t "select username from %TABLE%"`) do (
  set USERS=!USERS!^

%%i
)
:: �����s�f�[�^
echo ----------q�R�}���h����擾���������s�̃��[�U��----------
echo !USERS!
::echo ---------------------------------------------------------

echo ----------���[�U���ꗗ----------
for %%I in ( %USERS% ) do echo [%%I]
::echo --------------------------------


echo ----------�e���[�U��AccessToken('RepositoryControl')�ꗗ----------
:: http://jisakupc-technical.info/programing/491/
set TABLE=%Tsv_Token%
set AccessToken=
for %%I in ( %USERS% ) do (
	FOR /F "usebackq" %%i in (`%q% -H -t "select AccessToken from %TABLE% where username == '%%I' and TokenDescription == 'RepositoryControl'"`) DO set AccessToken=%%i
	echo [%%I]    !AccessToken!
)
::echo --------------------------------



set max_len_username=
FOR /F "usebackq" %%i in (`%q% -H -t "select MAX(LENGTH(username)) from %Tsv_Account%"`) DO @set max_len_username=%%i
echo ���[�U���̍ő咷�F%max_len_username%

echo ----------�e���[�U��AccessToken('RepositoryControl')�ꗗ----------
:: http://jisakupc-technical.info/programing/491/
:: http://piyopiyocs.blog115.fc2.com/blog-entry-899.html
set pad=%max_len_username%
set Username=
set TABLE=%Tsv_Token%
set AccessToken=
for %%I in ( %USERS% ) do (
	FOR /F "usebackq" %%i in (`%q% -H -t "select AccessToken from %TABLE% where username == '%%I' and TokenDescription == 'RepositoryControl'"`) DO set AccessToken=%%i
	set userspace=                                %%I
	set userspace=!userspace:~-%pad%!
	echo !userspace!    !AccessToken!
)
::echo --------------------------------

endlocal



:: �A�J�E���g�������擾����
set TABLE=%Tsv_Account%
set account_num=
::call %q% -H -t "select COUNT(*) from %TABLE%"
FOR /F "usebackq" %%i in (`%q% -H -t "select COUNT(*) from %TABLE%"`) DO set account_num=%%i
echo �A�J�E���g���� : %account_num%

:: AccessToken�̕��������擾����
set whereUser=user3
set len_AccessToken=
::call %q% -H -t "select LENGTH(AccessToken) from GitHubAccessToken.tsv where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"
FOR /F "usebackq" %%i in (`%q% -H -t "select LENGTH(AccessToken) from GitHubAccessToken.tsv where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"`) DO @set len_AccessToken=%%i
echo AccessToken�̕����񒷁F%len_AccessToken%

:: ���[�U���̕��������擾����
set whereUser=user3
set len_username=
::call %q% -H -t "select LENGTH(username) from %Tsv_Account% where username == '%whereUser%'"
FOR /F "usebackq" %%i in (`%q% -H -t "select LENGTH(username) from %Tsv_Account% where username == '%whereUser%'"`) DO @set len_username=%%i
echo ���[�U���̕�����(%whereUser%)�F%len_username%

:: ���[�U���̍ő咷
::call %q% -H -t "select MAX(LENGTH(username)) from %Tsv_Account%"
set max_len_username=
FOR /F "usebackq" %%i in (`%q% -H -t "select MAX(LENGTH(username)) from %Tsv_Account%"`) DO @set max_len_username=%%i
echo ���[�U���̍ő咷�F%max_len_username%





echo ---------- �\�[�g�B�V�������ɕ��בւ��� ----------
call %q% -H -t "select username, created from %Tsv_Account% order by Created desc"
echo --------------------------------------------------

:: %q% -H -t "select RPAD(username, %max_len_username%, '-') from %Tsv_Account%"
:: query error: near "%": syntax error
:: �G���[�B%%���W�J���ꂸ��q�ɓn����Ă�����ۂ�
:: %q% -H -t "select RPAD(username, 12, '-') from %Tsv_Account%"
:: query error: no such function: RPAD
:: �G���[�BRPAD�֐��͂Ȃ�

:: �T�u�N�G���͎g���Ȃ��H
::call %q% -H -t "select LENGTH(username) from %Tsv_Account% where LENGTH(username) > (select MAX(LENGTH(username)) from %Tsv_Account%)





:: ���[�U�̑��݊m�F
set whereUser=user3
set username=
::call %q% -H -t "select * from %TABLE% where username == '%whereUser%'"
FOR /F "usebackq" %%i in (`%q% -H -t "select * from %TABLE% where username == '%whereUser%'"`) DO set username=%%i
if "%username%" == "%whereUser%" (
	echo ���[�U���݊m�F�F����F%whereUser%
) else (
	echo ���[�U���݊m�F�F�Ȃ��F%whereUser%
)



set whereUser=user3
set password=
FOR /F "usebackq" %%i in (`%q% -H -t "select password from %TABLE% where username == '%whereUser%'"`) DO @set password=%%i
echo %whereUser% �̃p�X���[�h�� %password% �ł��B

set MailAddress=
FOR /F "usebackq" %%i in (`%q% -H -t "select mailaddress from %TABLE% where username == '%whereUser%'"`) DO @set MailAddress=%%i
echo %whereUser% �̃��A�h�� %MailAddress% �ł��B

set TABLE=%Tsv_Token%
set AccessToken=
FOR /F "usebackq" %%i in (`%q% -H -t "select AccessToken from %TABLE% where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"`) DO @set AccessToken=%%i
echo %whereUser% �� repo�p�A�N�Z�X��g�[�N���� %AccessToken% �ł��B

set TABLE=%Tsv_OAuth%
set ClientId=
FOR /F "usebackq" %%i in (`%q% -H -t "select ClientId from %TABLE% where username == '%whereUser%' and ApplicationName == 'test'"`) DO @set ClientId=%%i
echo %whereUser% �� test�pClientId�� %ClientId% �ł��B

set ClientSecret=
FOR /F "usebackq" %%i in (`%q% -H -t "select ClientSecret from %TABLE% where username == '%whereUser%' and ApplicationName == 'test'"`) DO @set ClientSecret=%%i
echo %whereUser% �� test�pClientSecret�� %ClientSecret% �ł��B

pause
@echo on
