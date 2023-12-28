use starknet::ContractAddress;

mod erc20;
mod jediswap;

#[starknet::interface]
trait IStarkNetErc20Token<TContractState> {
    fn totalSupply(self: @TContractState) -> u256;
    fn balanceOf(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transferFrom(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;

    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;

    fn increaseAllowance(
        ref self: TContractState, spender: ContractAddress, added_value: u256
    ) -> bool;
    fn decreaseAllowance(
        ref self: TContractState, spender: ContractAddress, subtracted_value: u256
    ) -> bool;

    fn permissionedMint(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn permissionedBurn(ref self: TContractState, account: ContractAddress, amount: u256);
}
