#!/bin/sh

# Helper functions 

print_usage() 
{
    # Print script usage

    cat <<EOF
Usage: $0 [-d] SHEET

    -d, --default           use the default terminal bell instead of beep
    SHEET                   path to the sheet file
EOF
}

# Parse args

function='beep_note'

for arg in "$@"; do
    case $arg in
        -d|--default) function='' ;;
        -h|--help) print_usage; exit;;
        *) set -- "$@" "$arg" ;;  # Leave positional arguments
    esac
    shift
done

# Custom single note function
beep_note()
{
    # Play single note using beep command
    # $1    - frequency in Hz
    # $2    - length in ms

    frequency="$1"
    length="$2"

    beep -f "$frequency" -l "$length"
}

# Get script directory, works in most simple cases
scriptdir="$(dirname -- "$0")"

# Import library functions
# shellcheck disable=SC1090
. "$scriptdir/beeplaylib.sh"

# awk is responsible for reading whatever was passed and piping it to beeplay
# if nothing or '-' is passed then awk reads from stdin
# system("") is used to flush output after each line so beeplay can read it immediately
# NF ignores empty lines
awk 'NF { print $0; system("")}' "$@" | beeplay $function