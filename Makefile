ARTWORK_PLAYERS="./artworks/players"
CONTRACT_IMAGES="./artworks/contract_images"
ARTWORK_PREPARED_IMAGES="./artworks/prepared_images"
ARTWORK_PREPARED_METADATA="./artworks/prepared_metadata"

prep_tokens_imgs:
	./artworks/prepare_tokens_images.sh $(ARTWORK_PLAYERS) $(ARTWORK_PREPARED_IMAGES) $(CONTRACT_IMAGES)

prep_tokens_metadata:
ifeq ($(strip $(cid)),)
	$(error "[ERROR]: 'cid' parameter is required. Pass it this way: cid=VALUE")
endif
	./artworks/prepare_tokens_metadata.sh $(cid) $(ARTWORK_PLAYERS) $(ARTWORK_PREPARED_METADATA)

prep_contract_metadata:
ifeq ($(strip $(image_uri)),)
	$(error "[ERROR]: 'image_uri' parameter is required. Pass it this way: image_uri=VALUE")
endif
ifeq ($(strip $(banner_image)),)
	$(error "[ERROR]: 'banner_image' parameter is required. Pass it this way: banner_image=VALUE")
endif
ifeq ($(strip $(featured_image)),)
	$(error "[ERROR]: 'featured_image' parameter is required. Pass it this way: featured_image=VALUE")
endif
ifeq ($(strip $(prepared_dir)),)
	$(error "[ERROR]: 'prepared_dir' parameter is required. Pass it this way: prepared_dir=VALUE")
endif
ifeq ($(strip $(owner_address)),)
	$(error "[ERROR]: 'owner_address' parameter is required. Pass it this way: owner_address=VALUE")
endif
	./artworks/prepare_contract_metadata.sh $(image_uri) $(banner_image) $(featured_image) $(prepared_dir) $(owner_address)

contract_test:
	cd nft && REPORT_GAS=true npx hardhat test || cd ..

contract_compile: contract_test
	cd nft && npx hardhat compile || cd ..

contract_deploy_local:
ifeq ($(strip $(contract_version)),)
	$(error "[ERROR]: 'contract_version' must be passed. Pass it this way: contract_version=VALUE")
endif
	cd nft && npx hardhat ignition deploy ./ignition/modules/Canarinho.ts --network localhost --deployment-id $(contract_version) || cd ..

contract_deploy_sepolia:
ifeq ($(strip $(contract_version)),)
	$(error "[ERROR]: 'contract_version' must be passed. Pass it this way: contract_version=VALUE")
endif
	cd nft && npx hardhat ignition deploy ./ignition/modules/Canarinho.ts --network sepolia --deployment-id $(contract_version) || cd ..
