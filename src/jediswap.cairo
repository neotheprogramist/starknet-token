// SPDX-License-Identifier: MIT
use starknet::ContractAddress;

#[starknet::interface]
trait IRouter<TContractState> {
    fn factory(self: @TContractState) -> felt252;
    fn quote(self: @TContractState, amount_a: u256, reserve_a: u256, reserve_b: u256) -> u256;

    fn add_liquidity(
        ref self: TContractState,
        token_a: felt252,
        token_b: felt252,
        amount_a_desired: u256,
        amount_b_desired: u256,
        amount_a_min: u256,
        amount_b_min: u256,
        to: felt252,
        deadline: felt252
    ) -> (u256, u256, u256);
    fn swap_exact_tokens_for_tokens(
        ref self: TContractState,
        amount_in: u256,
        amount_out_min: u256,
        path: Array<felt252>,
        to: felt252,
        deadline: felt252,
    ) -> Array<u256>;
}

#[starknet::interface]
trait IFactory<TContractState> {
    fn get_pair(self: @TContractState, token0: felt252, token1: felt252) -> felt252;

    fn create_pair(ref self: TContractState, token_a: felt252, token_b: felt252) -> felt252;
}

#[starknet::interface]
trait IPair<TContractState> {
    fn token0(self: @TContractState) -> felt252;
    fn token1(self: @TContractState) -> felt252;
    fn get_reserves(self: @TContractState) -> (u256, u256, felt252);
}
