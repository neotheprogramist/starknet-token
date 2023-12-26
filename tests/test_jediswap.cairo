use starknet::{contract_address_const, ContractAddress, testing};
use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};
use starknet_token::{
    erc20::{IErc20TokenSafeDispatcher, IErc20TokenSafeDispatcherTrait},
    jediswap::{IRouterSafeDispatcher, IRouterSafeDispatcherTrait},
};
use tests::utils::{
    constants::{OTHER, VALUE},
    mainnet::{ETH_TOKEN_CONTRACT, ETH_TOKEN_DEPLOYER_CONTRACT, JEDISWAP_CONTRACT},
};

#[test]
#[fork("SN_MAINNET")]
fn test_mint_eth() {
    let contract_address = ETH_TOKEN_CONTRACT();
    let contract_deployer_address = ETH_TOKEN_DEPLOYER_CONTRACT();

    let safe_dispatcher = IErc20TokenSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.balanceOf(OTHER()).unwrap();
    assert(balance_before == 0, 'Invalid balance');
}
