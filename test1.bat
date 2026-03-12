@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "path_code=code"
set "path_test=Test"
set "CC=gcc"

for %%f in (1-1 1-2 1-3 2-1 2-2 2-3 2-4 3-1 3-2 3-3 3-4 4-2) do (
    set "name=%%f"
    %CC% "%path_code%\%%f.c" -o "%path_code%\%%f.exe" 2>nul
    if exist "%path_code%\%%f.exe" (
        set "infile=%path_test%\%%f-in.txt"
        if exist "!infile!" (
            "%path_code%\%%f.exe" < "!infile!" > "%path_test%\actual%%f.txt"
        ) else (
            "%path_code%\%%f.exe" > "%path_test%\actual%%f.txt"
        )
        fc /b "%path_test%\actual%%f.txt" "%path_test%\%%f-out.txt" > nul
        if errorlevel 1 (
            echo %%f-out.txt: FAIL
        ) else (
            echo %%f-out.txt: PASS
        )
        del "%path_test%\actual%%f.txt" 2>nul
    ) else (
        echo %%f: COMPILE FAIL
    )
)

for %%f in (4-1 4-3) do (
    %CC% "%path_code%\%%f.c" -o "%path_code%\%%f.exe" 2>nul
    if exist "%path_code%\%%f.exe" (
        for %%n in (0 1 2 3) do (
            set "infile=%path_test%\%%f-in%%n.txt"
            set "outfile=%path_test%\%%f-out%%n.txt"
            if exist "!infile!" (
                "%path_code%\%%f.exe" < "!infile!" > "%path_test%\actual%%f%%n.txt"
            ) else (
                "%path_code%\%%f.exe" > "%path_test%\actual%%f%%n.txt"
            )
            fc /b "%path_test%\actual%%f%%n.txt" "!outfile!" > nul
            if errorlevel 1 (
                echo %%f-out%%n.txt: FAIL
            ) else (
                echo %%f-out%%n.txt: PASS
            )
            del "%path_test%\actual%%f%%n.txt" 2>nul
        )
    ) else (
        echo %%f: COMPILE FAIL
    )
)

endlocal
