
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedExchange {
    address public owner;
    mapping(address => mapping(address => uint256)) public liquidity;

    event TokenSwapped(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, address token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function addLiquidity(address token, uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        liquidity[msg.sender][token] += amount;
        emit LiquidityAdded(msg.sender, token, amount);
    }

    function swap(address tokenIn, address tokenOut, uint256 amountIn) external returns (uint256) {
        require(amountIn > 0, "Amount must be > 0");
        require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn), "Transfer failed");

        // Simplified: 1:1 exchange rate
        require(IERC20(tokenOut).transfer(msg.sender, amountIn), "Token out transfer failed");

        emit TokenSwapped(msg.sender, tokenIn, tokenOut, amountIn, amountIn);
        return amountIn;
    }

    function getLiquidity(address provider, address token) external view returns (uint256) {
        return liquidity[provider][token];
    }
}

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
