// SPDX-License-Identifier: MIT
use starknet::ContractAddress;

#[starknet::interface]
trait IRouter<TContractState> {
    fn factory(self: @TContractState) -> felt252;
}
