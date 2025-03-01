# Artwork operations

## Prepare images

```sh
make artworks_prep_imgs
```

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
make artworks_prep_metadata cid=$CID_HERE
```

