@echo off
cd /d %~dp0
set /P yn="�����[�X�p�̊��Ƀv���[���y�[�W��z�u���܂��B��낵���ł����H[y/n] : %yn%"

if %yn%==y (
java -jar presenmaker.jar .\ release > release.log 2>&1
) else (
echo ���������ɏI�����܂��B
)
pause