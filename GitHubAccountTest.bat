@echo off
::
:: qコマンドのテスト
::
:: TSVファイルからSQLのselect文にてデータを取得する。
::

:: qコマンド
:: http://harelba.github.io/q/
set q=C:\root\tool\System\q-1.5.0\bin\q.bat

:: 対象ファイル
set Tsv_Account=GitHubAccount.tsv
set Tsv_Token=GitHubAccessToken.tsv
set Tsv_OAuth=GitHubOAuthApplication.tsv
set TABLE=%Tsv_Account%

:: 全ユーザを取得する
setlocal enabledelayedexpansion
set USERS=
for /f "usebackq tokens=*" %%i in (`%q% -H -t "select username from %TABLE%"`) do (
  set USERS=!USERS!^

%%i
)
:: 複数行データ
echo ----------qコマンドから取得した複数行のユーザ名----------
echo !USERS!
::echo ---------------------------------------------------------

echo ----------ユーザ名一覧----------
for %%I in ( %USERS% ) do echo [%%I]
::echo --------------------------------


echo ----------各ユーザのAccessToken('RepositoryControl')一覧----------
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
echo ユーザ名の最大長：%max_len_username%

echo ----------各ユーザのAccessToken('RepositoryControl')一覧----------
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



:: アカウント件数を取得する
set TABLE=%Tsv_Account%
set account_num=
::call %q% -H -t "select COUNT(*) from %TABLE%"
FOR /F "usebackq" %%i in (`%q% -H -t "select COUNT(*) from %TABLE%"`) DO set account_num=%%i
echo アカウント件数 : %account_num%

:: AccessTokenの文字数を取得する
set whereUser=user3
set len_AccessToken=
::call %q% -H -t "select LENGTH(AccessToken) from GitHubAccessToken.tsv where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"
FOR /F "usebackq" %%i in (`%q% -H -t "select LENGTH(AccessToken) from GitHubAccessToken.tsv where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"`) DO @set len_AccessToken=%%i
echo AccessTokenの文字列長：%len_AccessToken%

:: ユーザ名の文字数を取得する
set whereUser=user3
set len_username=
::call %q% -H -t "select LENGTH(username) from %Tsv_Account% where username == '%whereUser%'"
FOR /F "usebackq" %%i in (`%q% -H -t "select LENGTH(username) from %Tsv_Account% where username == '%whereUser%'"`) DO @set len_username=%%i
echo ユーザ名の文字数(%whereUser%)：%len_username%

:: ユーザ名の最大長
::call %q% -H -t "select MAX(LENGTH(username)) from %Tsv_Account%"
set max_len_username=
FOR /F "usebackq" %%i in (`%q% -H -t "select MAX(LENGTH(username)) from %Tsv_Account%"`) DO @set max_len_username=%%i
echo ユーザ名の最大長：%max_len_username%





echo ---------- ソート。新しい順に並べ替える ----------
call %q% -H -t "select username, created from %Tsv_Account% order by Created desc"
echo --------------------------------------------------

:: %q% -H -t "select RPAD(username, %max_len_username%, '-') from %Tsv_Account%"
:: query error: near "%": syntax error
:: エラー。%%が展開されずにqに渡されているっぽい
:: %q% -H -t "select RPAD(username, 12, '-') from %Tsv_Account%"
:: query error: no such function: RPAD
:: エラー。RPAD関数はない

:: サブクエリは使えない？
::call %q% -H -t "select LENGTH(username) from %Tsv_Account% where LENGTH(username) > (select MAX(LENGTH(username)) from %Tsv_Account%)





:: ユーザの存在確認
set whereUser=user3
set username=
::call %q% -H -t "select * from %TABLE% where username == '%whereUser%'"
FOR /F "usebackq" %%i in (`%q% -H -t "select * from %TABLE% where username == '%whereUser%'"`) DO set username=%%i
if "%username%" == "%whereUser%" (
	echo ユーザ存在確認：ある：%whereUser%
) else (
	echo ユーザ存在確認：ない：%whereUser%
)



set whereUser=user3
set password=
FOR /F "usebackq" %%i in (`%q% -H -t "select password from %TABLE% where username == '%whereUser%'"`) DO @set password=%%i
echo %whereUser% のパスワードは %password% です。

set MailAddress=
FOR /F "usebackq" %%i in (`%q% -H -t "select mailaddress from %TABLE% where username == '%whereUser%'"`) DO @set MailAddress=%%i
echo %whereUser% のメアドは %MailAddress% です。

set TABLE=%Tsv_Token%
set AccessToken=
FOR /F "usebackq" %%i in (`%q% -H -t "select AccessToken from %TABLE% where username == '%whereUser%' and TokenDescription == 'RepositoryControl'"`) DO @set AccessToken=%%i
echo %whereUser% の repo用アクセス･トークンは %AccessToken% です。

set TABLE=%Tsv_OAuth%
set ClientId=
FOR /F "usebackq" %%i in (`%q% -H -t "select ClientId from %TABLE% where username == '%whereUser%' and ApplicationName == 'test'"`) DO @set ClientId=%%i
echo %whereUser% の test用ClientIdは %ClientId% です。

set ClientSecret=
FOR /F "usebackq" %%i in (`%q% -H -t "select ClientSecret from %TABLE% where username == '%whereUser%' and ApplicationName == 'test'"`) DO @set ClientSecret=%%i
echo %whereUser% の test用ClientSecretは %ClientSecret% です。

pause
@echo on
