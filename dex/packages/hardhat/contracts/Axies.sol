pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Axies is ERC20 {
    constructor() ERC20("Axies", "AXIE") {
        _mint(msg.sender, 2000 * 10 ** 18); // mints 1000 axies!
    }
}
