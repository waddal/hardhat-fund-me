//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error Unauthorized();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // when using libary, the object invoking a function is passed in as input parameter
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 == 1 * 10^18 == 1000000000000000000;
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withraw() public validateSender {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            // resetting the amount donated to current fund
            addressToAmountFunded[funder] = 0; 
            // reset the array
            funders = new address[](0); 
            // make the widthrawl, there are three ways
            // (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
            (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
            require(callSuccess, "Call failed.");
        }
    }

    modifier validateSender {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) { revert Unauthorized(); }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}