// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MiToken is ERC20, Ownable {
    using SafeMath for uint8;

    uint8 private _decimals = 18;

    constructor() ERC20("SANTIAGO", "SBP") {
        _mint(_msgSender(), 10**9 * 10**_decimals);
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}
