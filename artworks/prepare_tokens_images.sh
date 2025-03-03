#!/bin/sh

players_dir=$1
prepared_dir=$2
contract_images_dir=$3

if [ -z "$players_dir" ] || [ -z "$prepared_dir" ] || [ -z "$contract_images_dir" ]; then
  echo "[ERROR]: Usage: $0 <images_directory_path> <prepared_images_directory_path> <contract_images_directory_path>"
  exit 1
fi

rm -rf "$prepared_dir"
mkdir -p "$prepared_dir"

find "$players_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -exec cp {} "$prepared_dir" \;

find "$contract_images_dir" -type f \( -iname "banner_image*" -o -iname "main_image*" -o -iname "featured_image*" \) -exec cp {} "$prepared_dir" \;

echo "[SUCCESS]: images have been renamed and moved to $prepared_dir"
