#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p cache
cd cache

# Bundled themes are a reviewed, kid-friendly list kept in this repo
# (.github/themes.txt) instead of OnionUI's live "featured" list, and the
# theme zips are pinned to the OnionUI/Themes commit they were reviewed at.
# To add a theme: check its art, add its name to themes.txt, and bump
# THEMES_REF if it only exists in a newer commit.
THEMES_REF=b01198352e8927c3c5b9a828f73177bc81745954
featured=$(grep -v '^[[:space:]]*$' "$SCRIPT_DIR/themes.txt")

readarray -t themes <<< "$featured"

f() { themes=("${BASH_ARGV[@]}"); }

shopt -s extdebug
f "${themes[@]}"
shopt -u extdebug

mkdir -p ../dist/Themes

for element in "${themes[@]}"
do
    zipfile="$element.zip"

    if [[ ! -f "$zipfile" ]]
    then
        echo "-- downloading theme: $element"
        wget -O "$zipfile" "https://github.com/OnionUI/Themes/raw/$THEMES_REF/release/$element.zip" -q --show-progress
    fi

    if [ "$element" == "Silky by DiMo" ]; then
        echo "-- extracting theme: $element"
        unzip -oq "$zipfile" -d ../dist/Themes
    else
        echo "-- copying theme: $element"
        cp "$zipfile" ../dist/Themes
    fi
done
