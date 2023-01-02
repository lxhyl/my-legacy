## My-Legacy

Protect the property of the original address when the private key or mnemonic word is lost.


test contract deploy on https://goerli.etherscan.io/address/0xc615627D0E044E9F8b5eaD860EC9E4a94f7829C1




### Dev

- `mv .env.example .env` and edit it
- `forge install`
- `forge test`

### Deploy

- `source .env`
- `forge script script/deploy.s.sol:MyLegacy --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv`

### Upgrade

- `source .env`
- `forge script script/upgrade.s.sol:MyLegacyUpgrade --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv`


### Verify

- `forge verify-contract --chain-id <ChainId> <Address> <ContractPath>:<ContractName>`