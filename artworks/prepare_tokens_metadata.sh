#!/bin/sh

cid=$1
players_dir=$2
prepared_dir=$3

if [ -z "$cid" ] || [ -z "$prepared_dir" ] || [ -z "$players_dir" ]; then
  echo "[ERROR]: Usage: $0 <cid> <players_directory_path> <prepared_directory_path>"
  exit 1
fi

rm -rf "$prepared_dir"
mkdir -p "$prepared_dir"

for player_dir in "$players_dir"/*; do
  if [ -d "$player_dir" ]; then
    nft_token_id=$(basename "$player_dir") 
    metadata_file="$player_dir/metadata.json"

    if [ -f "$metadata_file" ]; then
      # replace <CID_HERE> with the given cid, and save it with the player's folder name
      sed "s|<CID_HERE>|$cid|" "$metadata_file" > "$prepared_dir/$nft_token_id"
    else
      echo "[ERROR]: metadata.json not found in $player_dir"
      exit 1
    fi
  fi
done

echo "[SUCCESS]: all metadata files placed at $prepared_dir"
