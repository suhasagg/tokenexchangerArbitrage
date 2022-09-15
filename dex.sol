// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title DEX
 * @author Suhas 
 * 
 */
contract DEX {
    /* ========== GLOBAL VARIABLES ========== */

    using SafeMath for uint256; //outlines use of SafeMath for uint256 variables
    IERC20 token; //instantiates the imported contract
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    /* ========== EVENTS ========== */

    /**
     *  Emitted when ethToToken() swap transacted
     */
    event EthToTokenSwap(
        address addrr,
        string tokenMinted,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /**
     *  Emitted when tokenToEth() swap transacted
     */
    event TokenToEthSwap(
        address addrr,
        string tokenMinted,
        uint256 tokenAmount,
        uint256 ethAmount
    );

    /**
     *  Emitted when liquidity provided to DEX and mints LPTs.
     */
    event LiquidityProvided(
        address adrr,
        uint256 liquidityMinted,
        uint256 ethDeposit,
        uint256 tokenDeposit
    );

    /**
     *  Emitted when liquidity removed from DEX and decreases LPT count within DEX.
     */
    event LiquidityRemoved(
        address addrr,
        uint256 amount,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /* ========== CONSTRUCTOR ========== */

    constructor(address token_addr) public {
        token = IERC20(token_addr); //specifies the token address that will hook into the interface and be used through the variable 'token'
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * initializes amount of tokens that will be transferred to the DEX itself from the erc20 contract mintee (and only them based on how ERC20.sol is written). Loads contract up with both ETH and ERC20.
     * tokens amount to be transferred to DEX
     * totalLiquidity is the number of LPTs minting as a result of deposits made to DEX contract
     * since ratio is 1:1, this is fine to initialize the totalLiquidity (wrt to ERC20) as equal to eth balance of contract.
     */
    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0);
        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;
        require(
            token.transferFrom(msg.sender, address(this), tokens),
            "DEX: init - transfer did not transact"
        );
        return totalLiquidity;
    }

    /**
     *  returns yOutput, or yDelta for xInput (or xDelta)
     *  Price section for an understanding of the DEX's pricing model and for a price function to add to your contract.
     *  we’re paying a 0.3% fee for additional deduction to DEX
     *  let’s move on to the interesting part of the AMM: exchanging tokens. Say that a user wants to get token_b in exchange for token_a of some specified amount (token_a_amount). Let’s denote the amount of tokens they will get by token_b_amount. In the equations below we let:
     *  a and b denote the amounts of token_a and token_b the user swaps,
     *  x and y denote the current balances of token_a and token_b in the AMM (that is, AmmState.token_a_balance and AmmState.token_b_balance).
     *  The AMM formula states that the value of token_a_balance * token_b_balance (that is, x * y) should be preserved. So we have:
     *  (x+a).(y-b) = x.y
     *  Let’s isolate b (as the rest of the values are known):
     *  b = y.a/(x+a)
     *  Output token price is determined using above.
     */
    function price(
        uint256 xInput,
        uint256 xReserves,
        uint256 yReserves
    ) public view returns (uint256 yOutput) {
        yOutput = (997 * xInput * (yReserves)) / (xReserves + xInput) / 1000;
    }

    /**
     * returns liquidity for a user. Note this is not needed typically due to the `liquidity()` mapping variable being public and having a getter as a result. 
     */
    function getLiquidity(address lp) public view returns (uint256) {
        return liquidity[lp];
    }

    /**
     * sends Ether to DEX in exchange for $Token
     */
    function ethToToken() public payable returns (uint256 tokenOutput) {
        require(msg.value > 0, "cannot swap 0 ETH");
        tokenOutput = price(
            msg.value,
            (address(this).balance.sub(msg.value)),
            token.balanceOf(address(this))
        );
        token.transfer(msg.sender, tokenOutput);
        emit EthToTokenSwap(
            msg.sender,
            "Eth to ERC20",
            msg.value,
            tokenOutput
        );
        return tokenOutput;
    }

    /**
     * sends $Token tokens to DEX in exchange for Ether
     */
    function tokenToEth(uint256 tokenInput) public returns (uint256 ethOutput) {
        require(token.transferFrom(msg.sender, address(this), tokenInput));
        ethOutput = price(
            tokenInput,
            token.balanceOf(address(this)),
            address(this).balance
        );
        payable(msg.sender).transfer(ethOutput);
        emit TokenToEthSwap(
            msg.sender,
            "ERC20 to Eth",
            tokenInput,
            ethOutput
        );
    }

    /**
     * allows deposits of $Token and $ETH to liquidity pool
     * parameter is the msg.value sent with this function call. That amount is used to determine the amount of $Token needed as well and taken from the depositor.
     * user has to make sure to give DEX approval to spend their tokens on their behalf by calling approve function prior to this function call.
     * Equal parts of both assets will be removed from the user's wallet with respect to the price outlined by the AMM.
     */
    function deposit() public payable returns (uint256 tokensDeposited) {
        uint256 ethBalance = (address(this).balance).sub(msg.value);
        tokensDeposited =
            (msg.value * token.balanceOf(address(this))) /
            ethBalance.add(1);
        require(token.transferFrom(msg.sender, address(this), tokensDeposited));
        uint256 liquidityMinted = (msg.value * totalLiquidity) / ethBalance;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += msg.value;
        emit LiquidityProvided(
            msg.sender,
            liquidityMinted,
            msg.value,
            tokensDeposited
        );
    }

    /**
     * allows withdrawal of $Token and $ETH from liquidity pool
     */
    function withdraw(uint256 amount)
        public
        returns (uint256 eth_amount, uint256 token_amount)
    {
        require(
            amount <= liquidity[msg.sender],
            "you don't have enough lpTokens"
        );
        liquidity[msg.sender] = liquidity[msg.sender].sub(amount);
        uint256 ethBalance = address(this).balance;
        uint256 tokenBalance = token.balanceOf(address(this));

        eth_amount = ethBalance.mul(amount) / totalLiquidity;
        token_amount = amount.mul(tokenBalance) / totalLiquidity;
        totalLiquidity = totalLiquidity.sub(amount);
        (bool sent, ) = payable(msg.sender).call{value: eth_amount}("");
        require(sent, "withdraw(): revert in transferring eth to you!");
        require(
            token.transfer(msg.sender, token_amount),
            "error in transferring ERC20"
        );
        emit LiquidityRemoved(msg.sender, amount, eth_amount, token_amount);
    }
}
