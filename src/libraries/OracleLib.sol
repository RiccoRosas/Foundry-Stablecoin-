// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/*
* @title OracleLib
* @author Rodrigo Martinez
* @notice This libarty us used to check the Chainlink oracle fror stale data,
* if a price is stale, the function will revert, and render the DSCengine unusable. - this is a known issue.
* so if the chainlink network explodes and you have a lot of money in the DSCengine, you will not be able to withdraw and you will get rekt.
*/

library OracleLib {
    error OracleLib__StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function stalePriceCheck(AggregatorV3Interface priceFeed) public view returns (uint80, int256, uint256, uint80) {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) {
            revert OracleLib__StalePrice();
            return (roundId, answer, startedAt, updatedAt, answeredInRound);
        }
    }
}
