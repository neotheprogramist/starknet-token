use starknet::{contract_address_const, ContractAddress, testing};
use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};
use starknet_token::{
    erc20::{
        IErc20TokenSafeDispatcher, IErc20TokenSafeDispatcherTrait,
        IStarkNetErc20TokenSafeDispatcher, IStarkNetErc20TokenSafeDispatcherTrait
    },
    jediswap::{IRouterSafeDispatcher, IRouterSafeDispatcherTrait},
};
use tests::utils::{
    constants::{OTHER, VALUE},
    mainnet::{ETH_TOKEN_CONTRACT, ETH_TOKEN_PERMISSIONED_MINT, JEDISWAP_CONTRACT},
};

#[test]
#[fork("SN_MAINNET")]
fn test_mint_eth() {
    let eth_token_address = ETH_TOKEN_CONTRACT();
    let eth_token_minter_address = ETH_TOKEN_PERMISSIONED_MINT();

    let safe_dispatcher = IStarkNetErc20TokenSafeDispatcher { contract_address: eth_token_address };

    let balance_before = safe_dispatcher.balanceOf(OTHER()).unwrap();
    assert(balance_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(eth_token_address), eth_token_minter_address);
    safe_dispatcher.permissionedMint(OTHER(), VALUE).unwrap();
    stop_prank(CheatTarget::One(eth_token_address));

    let balance_after = safe_dispatcher.balanceOf(OTHER()).unwrap();
    assert(balance_after == VALUE, 'Invalid balance');
}
