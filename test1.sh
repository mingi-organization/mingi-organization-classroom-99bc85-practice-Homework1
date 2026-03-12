#!/bin/bash
cd "$(dirname "$0")"

path_code="code"
path_test="Test"
CC="gcc"

run_test() {
    local name=$1
    local suffix=$2
    $CC "$path_code/$name.c" -o "$path_code/$name" 2>/dev/null
    if [ ! -f "$path_code/$name" ]; then
        echo "$name: COMPILE FAIL"
        return
    fi
    local infile="$path_test/${name}-in${suffix}.txt"
    local outfile="$path_test/${name}-out${suffix}.txt"
    local actual="$path_test/actual${name}${suffix}.txt"
    if [ -f "$infile" ]; then
        "./$path_code/$name" < "$infile" > "$actual"
    else
        "./$path_code/$name" > "$actual"
    fi
    if diff -q "$actual" "$outfile" > /dev/null 2>&1; then
        echo "${name}-out${suffix}.txt: PASS"
    else
        echo "${name}-out${suffix}.txt: FAIL"
    fi
    rm -f "$actual"
}

for f in 1-1 1-2 1-3 2-1 2-2 2-3 2-4 3-1 3-2 3-3 3-4 4-2; do
    run_test "$f" ""
done

for f in 4-1 4-3; do
    for n in 0 1 2 3; do
        run_test "$f" "$n"
    done
done
