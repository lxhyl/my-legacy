## My-Legacy

Protect the property of the original address when the private key or mnemonic word is lost.


test contract deploy on https://goerli.etherscan.io/address/0x94022093264fad8f5c6134f40ed9674c26b98601




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