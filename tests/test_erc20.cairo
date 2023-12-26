use core::result::ResultTrait;
use starknet::{contract_address_const, ContractAddress, testing};

use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};

use starknet_token::IErc20TokenSafeDispatcher;
use starknet_token::IErc20TokenSafeDispatcherTrait;

use tests::utils::constants::{
    ZERO, OWNER, SPENDER, RECIPIENT, NAME, SYMBOL, DECIMALS, SUPPLY, VALUE
};

fn get_swap_contract() -> ContractAddress {
    contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
}

fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@array![OWNER().into(), get_swap_contract().into()]).unwrap()
}

#[test]
fn test_mint_balance() {
    let contract_address = deploy_contract('Erc20Token');

    let safe_dispatcher = IErc20TokenSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.balance_of(OWNER()).unwrap();
    assert(balance_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(contract_address), OWNER());
    safe_dispatcher.mint(OWNER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(contract_address));

    let balance_after = safe_dispatcher.balance_of(OWNER()).unwrap();
    assert(balance_after == SUPPLY, 'Invalid balance');
}

#[test]
fn test_transfer() {
    let contract_address = deploy_contract('Erc20Token');

    let safe_dispatcher = IErc20TokenSafeDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), OWNER());
    safe_dispatcher.mint(SPENDER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(contract_address));

    let balance_before = safe_dispatcher.balance_of(SPENDER()).unwrap();
    assert(balance_before == SUPPLY, 'Invalid balance');

    start_prank(CheatTarget::One(contract_address), SPENDER());
    safe_dispatcher.transfer(RECIPIENT(), VALUE).unwrap();
    stop_prank(CheatTarget::One(contract_address));

    let balance_after = safe_dispatcher.balance_of(SPENDER()).unwrap();
    assert(balance_after == SUPPLY - VALUE, 'Invalid balance');

    let balance_after = safe_dispatcher.balance_of(RECIPIENT()).unwrap();
    assert(balance_after == VALUE, 'Invalid balance');
}
