use starknet::{contract_address_const, ContractAddress};

fn JEDISWAP_CONTRACT() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}
fn JEDISWAP_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}

fn ETH_TOKEN_CONTRACT() -> ContractAddress {
    contract_address_const::<0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7>()
}
fn ETH_TOKEN_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7>()
}
fn ETH_TOKEN_PERMISSIONED_MINT() -> ContractAddress {
    contract_address_const::<0x73314940630fd6dcda0d772d4c972c4e0a9946bef9dabf4ef84eda8ef542b82>()
}

fn USDC_TOKEN_CONTRACT() -> ContractAddress {
    contract_address_const::<0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8>()
}
fn USDC_TOKEN_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8>()
}
fn USDC_TOKEN_PERMISSIONED_MINT() -> ContractAddress {
    contract_address_const::<0x5cd48fccbfd8aa2773fe22c217e808319ffcc1c5a6a463f7d8fa2da48218196>()
}
