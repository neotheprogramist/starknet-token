use core::array::ArrayTrait;
use core::traits::TryInto;
use core::option::OptionTrait;
use starknet::{contract_address_const, ContractAddress, testing};
use snforge_std::{declare, start_prank, stop_prank, ContractClassTrait, CheatTarget};
use starknet_token::{
    IStarkNetErc20TokenSafeDispatcher, IStarkNetErc20TokenSafeDispatcherTrait,
    erc20::{IErc20TokenSafeDispatcher, IErc20TokenSafeDispatcherTrait},
    jediswap::{
        IRouterSafeDispatcher, IRouterSafeDispatcherTrait, IFactorySafeDispatcher,
        IFactorySafeDispatcherTrait, IPairSafeDispatcher, IPairSafeDispatcherTrait
    },
};
use tests::utils::{
    constants::{OTHER, VALUE, SUPPLY, UNIT, OWNER, ZERO},
    mainnet::{
        ETH_TOKEN_CONTRACT, ETH_TOKEN_PERMISSIONED_MINT, USDC_TOKEN_CONTRACT,
        USDC_TOKEN_PERMISSIONED_MINT, JEDISWAP_CONTRACT, JEDISWAP_FACTORY_CONTRACT,
        JEDISWAP_ETH_USDC_PAIR_CONTRACT
    },
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

#[test]
#[fork("SN_MAINNET")]
fn test_mint_usdc() {
    let eth_token_address = USDC_TOKEN_CONTRACT();
    let eth_token_minter_address = USDC_TOKEN_PERMISSIONED_MINT();

    let safe_dispatcher = IStarkNetErc20TokenSafeDispatcher { contract_address: eth_token_address };

    let balance_before = safe_dispatcher.balanceOf(OTHER()).unwrap();
    assert(balance_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(eth_token_address), eth_token_minter_address);
    safe_dispatcher.permissionedMint(OTHER(), VALUE).unwrap();
    stop_prank(CheatTarget::One(eth_token_address));

    let balance_after = safe_dispatcher.balanceOf(OTHER()).unwrap();
    assert(balance_after == VALUE, 'Invalid balance');
}

#[test]
#[fork("SN_MAINNET")]
fn test_swap_usdc_to_eth() {
    let safe_dispatcher = IRouterSafeDispatcher { contract_address: JEDISWAP_CONTRACT() };

    let eth_token_address = ETH_TOKEN_CONTRACT();
    let usdc_token_address = USDC_TOKEN_CONTRACT();

    let eth_token_minter_address = ETH_TOKEN_PERMISSIONED_MINT();
    let usdc_token_minter_address = USDC_TOKEN_PERMISSIONED_MINT();

    let safe_dispatcher_eth = IStarkNetErc20TokenSafeDispatcher {
        contract_address: eth_token_address
    };
    let safe_dispatcher_usdc = IStarkNetErc20TokenSafeDispatcher {
        contract_address: usdc_token_address
    };

    let balance_eth_before = safe_dispatcher_eth.balanceOf(OTHER()).unwrap();
    let balance_usdc_before = safe_dispatcher_usdc.balanceOf(OTHER()).unwrap();

    assert(balance_eth_before == 0, 'Invalid balance');
    assert(balance_usdc_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(eth_token_address), eth_token_minter_address);
    safe_dispatcher_eth.permissionedMint(OTHER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(eth_token_address));

    start_prank(CheatTarget::One(usdc_token_address), usdc_token_minter_address);
    safe_dispatcher_usdc.permissionedMint(OTHER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(usdc_token_address));

    let balance_eth_after = safe_dispatcher_eth.balanceOf(OTHER()).unwrap();
    let balance_usdc_after = safe_dispatcher_usdc.balanceOf(OTHER()).unwrap();

    assert(balance_eth_after == SUPPLY, 'Invalid balance');
    assert(balance_usdc_after == SUPPLY, 'Invalid balance');

    let safe_dispatcher = IPairSafeDispatcher {
        contract_address: JEDISWAP_ETH_USDC_PAIR_CONTRACT()
    };

    let (usdc_reserves, eth_reserves, time) = safe_dispatcher.get_reserves().unwrap();

    let safe_dispatcher = IRouterSafeDispatcher { contract_address: JEDISWAP_CONTRACT() };

    let quote_b = safe_dispatcher.quote(UNIT, usdc_reserves, eth_reserves).unwrap();

    assert(quote_b == 2246018606, 'Invalid quote');
}

#[test]
#[fork("SN_MAINNET")]
fn test_create_new_pair() {
    let contract = declare('Erc20Token');
    let custom_token_address = contract.deploy(@array![OWNER().into(), ZERO().into(), 0, 0, 1, 0, 0, 0, 1, 0]).unwrap();

    let eth_token_address = ETH_TOKEN_CONTRACT();
    let eth_token_minter_address = ETH_TOKEN_PERMISSIONED_MINT();

    let safe_dispatcher_custom = IErc20TokenSafeDispatcher {
        contract_address: custom_token_address
    };

    let safe_dispatcher_eth = IStarkNetErc20TokenSafeDispatcher {
        contract_address: eth_token_address
    };

    let balance_custom_before = safe_dispatcher_custom.balance_of(OTHER()).unwrap();
    let balance_eth_before = safe_dispatcher_eth.balanceOf(OTHER()).unwrap();

    assert(balance_custom_before == 0, 'Invalid balance');
    assert(balance_eth_before == 0, 'Invalid balance');

    start_prank(CheatTarget::One(custom_token_address), OWNER().into());
    safe_dispatcher_custom.mint(OTHER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(custom_token_address));

    start_prank(CheatTarget::One(eth_token_address), eth_token_minter_address);
    safe_dispatcher_eth.permissionedMint(OTHER(), SUPPLY).unwrap();
    stop_prank(CheatTarget::One(eth_token_address));

    let balance_custom_after = safe_dispatcher_custom.balance_of(OTHER()).unwrap();
    let balance_eth_after = safe_dispatcher_eth.balanceOf(OTHER()).unwrap();

    assert(balance_custom_after == SUPPLY, 'Invalid balance');
    assert(balance_eth_after == SUPPLY, 'Invalid balance');

    let safe_dispatcher = IFactorySafeDispatcher { contract_address: JEDISWAP_FACTORY_CONTRACT() };

    let pair_address = safe_dispatcher
        .create_pair(custom_token_address.into(), eth_token_address.into())
        .unwrap();

    let safe_dispatcher = IPairSafeDispatcher {
        contract_address: pair_address.try_into().unwrap()
    };

    let (usdc_reserves, eth_reserves, time) = safe_dispatcher.get_reserves().unwrap();

    assert(usdc_reserves == 0, 'Invalid usdc reserves');
    assert(eth_reserves == 0, 'Invalid eth reserves');
}
