#!/bin/sh

image_uri=$1
banner_image=$2
featured_image=$3
prepared_dir=$4
owner_address=$5

if [ -z "$image_uri" ] || [ -z "$banner_image" ] || [ -z "$featured_image" ] || [ -z "$prepared_dir" ] || [ -z "$owner_address" ]; then
  echo "[ERROR]: Usage: $0 <image_uri> <banner_image_uri> <featured_image_uri> <prepared_dir_uri> <owner_address_uri>"
  exit 1
fi

cat <<EOF > "$prepared_dir/metadata"
{
  "name": "Canarinho NFT Collection",
  "description": "A collection of Canarinho NFTs celebrating Brazilian football culture. These rare digital collectibles honor the Brazilian spirit of football with unique and vibrant art.",
  "image": "$image_uri", 
  "banner_image": "$banner_image",
  "featured_image": "$featured_image",
  "external_link": "https://github.com/buarki/canarinhoNFT",
  "seller_fee_basis_points": 500,
  "fee_recipient": "$owner_address",
  "collaborators": ["$owner_address"]
}
EOF

echo "[SUCCESS]: contract metadata saved to $prepared_dir"
