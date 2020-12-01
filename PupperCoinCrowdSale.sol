pragma solidity ^0.5.0;
// Import the necessary contracts and additions.
import "./Puppercoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Here I  Inherit the crowdsale contracts.
contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale, CappedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint256 rate, 
        address payable wallet, 
        uint goal, 
        uint openingTime, 
        uint closingTime, 
        PupperCoin token
    )
        
    Crowdsale(rate, wallet, token)
    CappedCrowdsale(goal)
    RefundableCrowdsale(goal)
    TimedCrowdsale(openingTime,closingTime)
    public 
    {

    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint openingTime = now;
    uint closingTime = now + 24 weeks;

    constructor(
        uint goal,
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, goal, openingTime, closingTime, token);
        token_sale_address = address(pupper_sale);

        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}