import { expect } from "chai";
import { ethers } from "hardhat";
import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";

describe("CanarinhoNFT", function () {
  const baseURI = "ipfs://baseURI/";
  const MAX_TOKENS_PER_ADDRESS = 2;
  const MAX_TOKENS = 10;
  const price = ethers.parseEther("0.1");

  async function deployContractFixture() {
    const [owner, addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();

    const CanarinhoNFT = await ethers.getContractFactory("Canarinho");
    const canarinho = await CanarinhoNFT.deploy(baseURI, MAX_TOKENS_PER_ADDRESS, MAX_TOKENS, price);
    await canarinho.waitForDeployment();
    return { canarinho, owner, addr1, addr2, addr3, addr4, addr5 };
  }

  describe("deployment check", function () {
    it("should ensure that values are ok", async function () {
      const { canarinho, owner } = await loadFixture(deployContractFixture);

      expect(await canarinho.price()).to.equal(price);
      expect(await canarinho.owner()).to.equal(owner);
      expect(await canarinho.baseURI()).to.equal(baseURI);
      expect(await canarinho.MAX_TOKENS_PER_ADDRESS()).to.equal(MAX_TOKENS_PER_ADDRESS);
      expect(await canarinho.MAX_TOKENS()).to.equal(MAX_TOKENS);
      expect(await canarinho.isSaleOn()).to.be.false;
    });
  });

  describe("only owner can set sale state", async () => {
    it('should ensure allow onwer to change sale status', async () => {
      const { canarinho, owner } = await loadFixture(deployContractFixture);

      await canarinho.connect(owner).setSaleState(true);
      expect(await canarinho.isSaleOn()).to.be.true;
    });

    it('should error if someone other than owner sets the sale status', async () => {
      const { canarinho, addr1: notOwnerAddr } = await loadFixture(deployContractFixture);

      const innitialContractState = await canarinho.isSaleOn();

      await expect(canarinho.connect(notOwnerAddr).setSaleState(false))
        .to.be.revertedWithCustomError(canarinho, "OwnableUnauthorizedAccount")
        .withArgs(notOwnerAddr.address);

      expect(await canarinho.isSaleOn()).equals(innitialContractState);
    });
  });

  describe("minting", () => {
    describe("when sale is off", () => {
      it("should not allow one to mint", async () => {
        const { canarinho, owner, addr1: anotherUser } = await loadFixture(deployContractFixture);

        await canarinho.connect(owner).setSaleState(false);

        await expect(canarinho.connect(anotherUser).mint()).to.be.revertedWith("sale is off");
      });
    });

    describe("when sale is on", () => {
      it("should allow one to mint the allowed limit per wallet", async () => {
        const { canarinho, owner, addr1: anotherUser } = await loadFixture(deployContractFixture);
        const maxTokens = Number(await canarinho.MAX_TOKENS_PER_ADDRESS());

        await canarinho.connect(owner).setSaleState(true);

        for (let i = 0; i < maxTokens; i++) {
          await canarinho.connect(anotherUser).mint({ value: price });
        }

        await (expect(canarinho.connect(anotherUser).mint({ value: price }))).to.be.revertedWith("max tokens per address reached");
      });

      it("should prevent more tokens to be min than allowed value", async () => {
        const [owner, addr1, addr2, addr3] = await ethers.getSigners();
        const maxTokensPerAddress = 1;
        const maxAllowedTokens = 2;

        const LocalCanarinhoNFT = await ethers.getContractFactory("Canarinho");
        const canarinho = await LocalCanarinhoNFT.deploy(baseURI, maxTokensPerAddress, maxAllowedTokens, price);
        await canarinho.waitForDeployment();

        await canarinho.connect(owner).setSaleState(true);
        await canarinho.connect(addr1).mint({ value: price });
        await canarinho.connect(addr2).mint({ value: price });

        await expect(canarinho.connect(addr3).mint({ value: price })).to.be.revertedWith("no more tokens can be minted");
      });

      it("should revert if no sufficient ether is sent", async () => {
        const { canarinho, owner, addr1: anotherUser } = await loadFixture(deployContractFixture);
        const notSufficientPrice = ethers.parseEther("0.01");

        await canarinho.connect(owner).setSaleState(true);

        await expect(canarinho.connect(anotherUser).mint({ value: notSufficientPrice })).to.be.revertedWith("insufficient ETH");
      });

      it("should allow one to mint, update total supply and number of NFTs per wallet", async () => {
        const { canarinho, owner, addr1: anotherUser } = await loadFixture(deployContractFixture);
        const expectedNumberOfNFTs = 1;

        await canarinho.connect(owner).setSaleState(true);

        await canarinho.connect(anotherUser).mint({ value: price });

        expect(await canarinho.totalSupply()).equal(expectedNumberOfNFTs);
        expect(await canarinho.tokens(anotherUser)).equal(expectedNumberOfNFTs);
      });
    });
  });

  describe("checking token URI", () => {
    it("should return correct token URI", async function () {
      const { canarinho, addr1 } = await deployContractFixture();
      await canarinho.setSaleState(true);

      await canarinho.connect(addr1).mint({ value: ethers.parseEther("0.1") });

      expect(await canarinho.getTokenURI(0)).to.equal("ipfs://baseURI/0");
    });
  
    it("should not return URI for non-existent token", async function () {
      const { canarinho } = await deployContractFixture();

      await expect(canarinho.getTokenURI(0)).to.be.revertedWith("token must exist");
    });
  });
});
