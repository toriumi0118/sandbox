@echo off
cd /d %~dp0
set /P yn="リリース用の環境にプレゼンページを配置します。よろしいですか？[y/n] : %yn%"

if %yn%==y (
java -jar presenmaker.jar .\ release > release.log 2>&1
) else (
echo 何もせずに終了します。
)
pause