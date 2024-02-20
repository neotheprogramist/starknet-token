use core::result::ResultTrait;
use starknet::{contract_address_const, ContractAddress, testing};
use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};
use starknet_token::erc20::{IFungibleTokenDispatcher, IFungibleTokenDispatcherTrait};
use tests::utils::constants::{OWNER, SPENDER, RECIPIENT, SUPPLY, VALUE, ZERO};

fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@array![OWNER().into(), 'TestToken', 'TST']).unwrap()
}

#[test]
fn test_mint_balance() {
    let contract_address = deploy_contract('FungibleToken');

    let safe_dispatcher = IFungibleTokenDispatcher { contract_address };

    let balance_before = safe_dispatcher.balance_of(OWNER());
    assert(balance_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(contract_address), OWNER());
    safe_dispatcher.mint(OWNER(), SUPPLY);
    stop_prank(CheatTarget::One(contract_address));

    let balance_after = safe_dispatcher.balance_of(OWNER());
    assert(balance_after == SUPPLY, 'Invalid balance');
}

#[test]
fn test_transfer() {
    let contract_address = deploy_contract('FungibleToken');

    let safe_dispatcher = IFungibleTokenDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), OWNER());
    safe_dispatcher.mint(SPENDER(), SUPPLY);
    stop_prank(CheatTarget::One(contract_address));

    let balance_before = safe_dispatcher.balance_of(SPENDER());
    assert(balance_before == SUPPLY, 'Invalid balance');

    start_prank(CheatTarget::One(contract_address), SPENDER());
    safe_dispatcher.transfer(RECIPIENT(), VALUE);
    stop_prank(CheatTarget::One(contract_address));

    let balance_after = safe_dispatcher.balance_of(SPENDER());
    assert(balance_after == SUPPLY - VALUE, 'Invalid balance');

    let balance_after = safe_dispatcher.balance_of(RECIPIENT());
    assert(balance_after == VALUE, 'Invalid balance');
}
