use starknet::{contract_address_const, ContractAddress, testing};
use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};
use starknet_token::jediswap::{IRouterSafeDispatcher, IRouterSafeDispatcherTrait};
use tests::utils::constants::{OWNER, SPENDER, RECIPIENT, SUPPLY, VALUE, JEDISWAP_MAINNET};

fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@array![]).unwrap()
}

#[test]
#[fork("SN_MAINNET")]
fn test_fork_router_interface() {
    let contract_address = JEDISWAP_MAINNET();

    let safe_dispatcher = IRouterSafeDispatcher { contract_address };

    let result = safe_dispatcher.factory().unwrap();

    println!("{:?}", result);
}
