# Artwork operations

## Prepare images

```sh
make prep_tokens_imgs
```

It will copy the image of each player at /players/*/*.(png|jpg|webp) and also some contract needed images into a single directory to be uploaded to IPFS.

## Setup IPFS
- [setup a filebase account](../docs/filebase.md#setup-an-account);
- [provison a bucket](../docs/filebase.md#provision-a-bucket);

## Upload images to Filebase (IPFS) via API 
- *NOTE*: it requires paid account.
- [generage upload token](../docs/filebase.md#access-keys);
- upload the prepared images folder to Filebase;

## Upload images to Filebase (IPFS) manually
- Upload the *full folder* to the bucket;
- Copy the generated CID;

## Set the new CID into the metadata files

```sh
make prep_tokens_metadata cid=$CID_HERE
```

## Prepare contract metadata

You should collect the images uploaded and inject them here. E.g:

```sh
make prep_contract_metadata image_uri=ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/main_image.jpg banner_image=ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/banner_image.avif featured_image=ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/featured_image.webp prepared_dir=./artworks/prepared_metadata owner_address=0x93939nj3845082ea4C449D6Eb84789eD34988936b
```

