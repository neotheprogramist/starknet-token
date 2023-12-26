use starknet::ClassHash;
use starknet::ContractAddress;
use starknet::class_hash_const;
use starknet::contract_address_const;

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 18_u8;
const SUPPLY: u256 = 2000;
const VALUE: u256 = 300;
const ROLE: felt252 = 'ROLE';
const OTHER_ROLE: felt252 = 'OTHER_ROLE';
const URI: felt252 = 'URI';
const TOKEN_ID: u256 = 21;
const PUBKEY: felt252 = 'PUBKEY';
const NEW_PUBKEY: felt252 = 'NEW_PUBKEY';
const SALT: felt252 = 'SALT';
const SUCCESS: felt252 = 123123;
const FAILURE: felt252 = 456456;

fn JEDISWAP_MAINNET() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}

fn JEDISWAP_TESTNET() -> ContractAddress {
    contract_address_const::<0x02bcc885342ebbcbcd170ae6cafa8a4bed22bb993479f49806e72d96af94c965>()
}

fn ADMIN() -> ContractAddress {
    contract_address_const::<'ADMIN'>()
}

fn AUTHORIZED() -> ContractAddress {
    contract_address_const::<'AUTHORIZED'>()
}

fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

fn CLASS_HASH_ZERO() -> ClassHash {
    class_hash_const::<0>()
}

fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn NEW_OWNER() -> ContractAddress {
    contract_address_const::<'NEW_OWNER'>()
}

fn OTHER() -> ContractAddress {
    contract_address_const::<'OTHER'>()
}

fn OTHER_ADMIN() -> ContractAddress {
    contract_address_const::<'OTHER_ADMIN'>()
}

fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'RECIPIENT'>()
}

fn OPERATOR() -> ContractAddress {
    contract_address_const::<'OPERATOR'>()
}

fn DATA(success: bool) -> Span<felt252> {
    let mut data = array![];
    if success {
        data.append(SUCCESS);
    } else {
        data.append(FAILURE);
    }
    data.span()
}
