# Filebase

## Setup an account
- [access here](https://console.filebase.com/);

## Provision a bucket
- [see it](https://docs.filebase.com/archive/content-archive/getting-started-guide#buckets);

### Access keys
- [see how to get key and secret](https://docs.filebase.com/api-documentation/ipfs-pinning-service-api);

- test it
```sh
curl --request GET \
  --url 'https://api.filebase.io/v1/ipfs/pins?=' \
  --header 'Authorization: Bearer $BUCKET_SECRET'
```

