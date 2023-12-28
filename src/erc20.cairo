// SPDX-License-Identifier: MIT
use starknet::ContractAddress;

#[starknet::interface]
trait IErc20Token<TContractState> {
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;

    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;

    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn renounce_ownership(ref self: TContractState);

    fn burn(ref self: TContractState, value: u256);
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
}

#[starknet::contract]
mod Erc20Token {
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::token::erc20::erc20::ERC20Component::InternalTrait;
    use openzeppelin::token::erc20::ERC20Component;
    use openzeppelin::access::ownable::OwnableComponent;
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>;

    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableCamelOnlyImpl =
        OwnableComponent::OwnableCamelOnlyImpl<ContractState>;

    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        swap_router: ContractAddress,
        deduction_numer: u256,
        deduction_denom: u256,
        burn_numer: u256,
        burn_denom: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        swap_router: ContractAddress,
        deduction_numer: u256,
        deduction_denom: u256,
        burn_numer: u256,
        burn_denom: u256,
    ) {
        self.erc20.initializer('MyToken', 'MTK');
        self.ownable.initializer(owner);
        self.swap_router.write(swap_router);
        self.deduction_numer.write(deduction_numer);
        self.deduction_denom.write(deduction_denom);
        self.burn_numer.write(burn_numer);
        self.burn_denom.write(burn_denom);
    }

    #[generate_trait]
    #[external(v0)]
    impl ExternalImpl of ExternalTrait {
        fn total_supply(self: @ContractState) -> u256 {
            self.erc20.total_supply()
        }
        fn totalSupply(self: @ContractState) -> u256 {
            self.erc20.total_supply()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self.erc20.balance_of(account)
        }
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            self.erc20.balance_of(account)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self.erc20.allowance(owner, spender)
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            self.erc20.transfer(recipient, amount)
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            // let amount_to_deduct = amount * self.deduction_numer.read() / self.deduction_denom.read();
            // let amount_to_burn = amount_to_deduct * self.burn_numer.read() / self.burn_denom.read();
            // let amount_to_distribute = amount_to_deduct - amount_to_burn;
            // self.erc20._burn(sender, amount_to_burn);
            // self.erc20.transfer_from(sender, self.owner(), amount_to_distribute);
            self.erc20.transfer_from(sender, recipient, amount)
        }
        fn transferFrom(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            // let amount_to_deduct = amount * self.deduction_numer.read() / self.deduction_denom.read();
            // let amount_to_burn = amount_to_deduct * self.burn_numer.read() / self.burn_denom.read();
            // let amount_to_distribute = amount_to_deduct - amount_to_burn;
            // self.erc20._burn(sender, amount_to_burn);
            // self.erc20.transfer_from(sender, self.owner(), amount_to_distribute);
            self.erc20.transfer_from(sender, recipient, amount)
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            self.erc20.approve(spender, amount)
        }

        fn burn(ref self: ContractState, value: u256) {
            let caller = get_caller_address();
            self.erc20._burn(caller, value);
        }

        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            self.ownable.assert_only_owner();
            self.erc20._mint(recipient, amount);
        }
    }
}
