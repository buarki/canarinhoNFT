ARTWORK_PLAYERS="./artworks/players"
ARTWORK_PREPARED_IMAGES="./artworks/prepared_images"
ARTWORK_PREPARED_METADATA="./artworks/prepared_metadata"

artworks_prep_imgs:
	./artworks/prepare_images.sh $(ARTWORK_PLAYERS) $(ARTWORK_PREPARED_IMAGES)

artworks_prep_metadata:
ifeq ($(strip $(cid)),)
	$(error "[ERROR]: 'cid' parameter is required. Usage: make artworks_prep_metadata cid=VALUE")
endif
	./artworks/prepare_metadata.sh $(cid) $(ARTWORK_PLAYERS) $(ARTWORK_PREPARED_METADATA)
