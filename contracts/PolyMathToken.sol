pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/PausableToken.sol';
import 'zeppelin-solidity/contracts/token/BurnableToken.sol';

contract PolyMathToken is PausableToken, BurnableToken {

  // Token properties.
  string public constant name = 'PolyMathToken';
  string public constant symbol = 'POLY';
  // ERC20 compliant types
  // (see https://blog.zeppelin.solutions/tierion-network-token-audit-163850fd1787)
  uint8 public constant decimals = 18;
  uint256 private constant token_factor = 10**uint256(decimals);
  // 1 billion POLY tokens in units divisible up to 18 decimals.
  uint256 public constant INITIAL_SUPPLY = 1000 * (10**6) * token_factor;

  uint256 public constant PRESALE_SUPPLY = 150000000 * token_factor;
  uint256 public constant PUBLICSALE_SUPPLY = 150000000 * token_factor;
  uint256 public constant FOUNDER_SUPPLY = 150000000 * token_factor;
  uint256 public constant BDMARKET_SUPPLY = 25000000 * token_factor;
  uint256 public constant ADVISOR_SUPPLY = 25000000 * token_factor;
  uint256 public constant RESERVE_SUPPLY = 500000000 * token_factor;

  bool private crowdsaleInitialized = false;

  modifier crowdsaleNotInitialized() {
    require(crowdsaleInitialized == false);
    _;
  }

  function PolyMathToken(address _presale_wallet) {
    require(_presale_wallet != 0x0);
    require(INITIAL_SUPPLY > 0);
    require((PRESALE_SUPPLY + PUBLICSALE_SUPPLY + FOUNDER_SUPPLY + BDMARKET_SUPPLY + ADVISOR_SUPPLY + RESERVE_SUPPLY) == INITIAL_SUPPLY);
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = totalSupply - PRESALE_SUPPLY;
    Transfer(0x0, msg.sender, totalSupply - PRESALE_SUPPLY);
    balances[_presale_wallet] = PRESALE_SUPPLY;
    Transfer(0x0, _presale_wallet, PRESALE_SUPPLY);
  }

  function initializeCrowdsale(address _crowdsale) onlyOwner crowdsaleNotInitialized {
    crowdsaleInitialized = true;
    transfer(_crowdsale, PUBLICSALE_SUPPLY);
    pause();
    transferOwnership(_crowdsale);
  }

  function issueTokens(address _to, uint256 _value) onlyOwner returns (bool) {
    balances[owner] = balances[owner].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(owner, _to, _value);
    return true;
  }

  // Don't accept calls to the contract address; must call a method.
  function () {
    revert();
  }

}
