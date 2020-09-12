#!/bin/bash

# Author: Adrien Cotte <adrien@cotte.com>
#
# System:
#       BusyBox v1.25.1 (2019-09-13 12:13:30 CEST) multi-call binary
#       Linux Lakka 4.19.50 #1 SMP Fri Sep 13 12:01:45 CEST 2019 armv7l GNU/Linux
#
# USAGE:
#   1) Copy this script to your roms root dir (ex: /storage/roms/downloads)
#   2) Run it
#   3) Copy generated files (ex: "Nintendo - Nintendo Entertainment System.lpl") to /storage/playlists

# Supported emulators
extensions_list="nes smc z64"

# HEADER
get_header() {
    cat << EOF
{
  "version": "1.2",
  "default_core_path": "",
  "default_core_name": "",
  "label_display_mode": 0,
  "right_thumbnail_mode": 0,
  "left_thumbnail_mode": 0,
  "items": [
EOF
}

#FOOTER
get_footer() {
    cat << EOF
  ]
}
EOF
}

# Processing
for ext in $extensions_list; do
        files_list=.tmp_gen_playlists
        find . -type f -iname *.$ext > $files_list
        sed -i 's/ /@@SPACE@@/g' $files_list # TRICK TO AVOID SPACES
        sed -i 's/(/@@PARENTB@@/g' $files_list # TRICK TO AVOID (
        sed -i 's/)/@@PARENTF@@/g' $files_list # TRICK TO AVOID )
        sed -i "s/'/@@QUOTE@@/g" $files_list # TRICK TO AVOID '
        case $ext in
          nes) db_name="Nintendo - Nintendo Entertainment System.lpl"
               ;;
          smc) db_name="Nintendo - Super Nintendo Entertainment System.lpl"
               ;;
          z64) db_name="Nintendo - Nintendo 64.lpl"
               ;;
        esac
        get_header > $db_name
        for file in $(cat $files_list); do
          echo "    {" >> $db_name
          echo "      \"path\": \"$PWD/$file\"," >> $db_name
          echo "      \"label\": \"$(basename $file)\"," >> $db_name
          echo "      \"core_path\": \"DETECT\"," >> $db_name
          echo "      \"core_name\": \"DETECT\"," >> $db_name
          echo "      \"crc32\": \"DETECT\"," >> $db_name
          echo "      \"db_name\": \"$db_name\"" >> $db_name
          echo "    }", >> $db_name
        done
        get_footer >> $db_name
        sed -i 's/@@SPACE@@/ /g' "$db_name" # TRICK TO AVOID SPACES
        sed -i 's/@@PARENTB@@/(/g' "$db_name" # TRICK TO AVOID (
        sed -i 's/@@PARENTF@@/)/g' "$db_name" # TRICK TO AVOID )
        sed -i "s/@@QUOTE@@/'/g" "$db_name" # TRICK TO AVOID '
done
