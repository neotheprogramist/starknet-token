use starknet::{contract_address_const, ContractAddress};

fn JEDISWAP_CONTRACT() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}
fn JEDISWAP_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}

fn ETH_TOKEN_CONTRACT() -> ContractAddress {
    contract_address_const::<0x033478650b3b71be225cbad55fda8a590022eea17be3212d0ccbf3d364b1e448>()
}
fn ETH_TOKEN_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x008718bf271493c557974f8aab1179f431a0ca956c74e83f8ec4c37834f0f9ce>()
}

fn USDC_TOKEN_CONTRACT() -> ContractAddress {
    contract_address_const::<0x06eda767a143da12f70947192cd13ee0ccc077829002412570a88cd6539c1d85>()
}
fn USDC_TOKEN_DEPLOYER_CONTRACT() -> ContractAddress {
    contract_address_const::<0x008718bf271493c557974f8aab1179f431a0ca956c74e83f8ec4c37834f0f9ce>()
}
