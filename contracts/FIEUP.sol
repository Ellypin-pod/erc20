pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title KauriBadges
 * KauriBadges - non-fungible badges
 */
contract FIEUIZ is ERC20, Ownable {
    string public constant name = "FIEUPZTest";
    string public constant symbol = "FIEUIZ";
    uint8 public constant decimals = 0;

    address constant _feeWallet = 0xDBb349BA3140256638096E98fe4A1DA0943D09c9;
    address constant _redeemWallet = 0xbd49F20F816C8ff831832F20fF0509A6176F9902;

    mapping(address => uint256) redeemBalances;
    uint256 _fee = 1;

  /**
   * @dev Function to mint tokens
   * @param to The address that will receive the minted tokens.
   * @param value The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address to,
    uint256 value
  )
    public
    onlyOwner
    returns (bool)
  {
    _mint(to, value);
    return true;
  }
    
    /**
    * @dev Redeem tokens.
    * @param _tokens number of tokens
    */
    function redeem(uint256 _tokens) public {
        require(_tokens > 0);
        uint256 feeToken = _fee (10 * uint256(decimals));
        require(_tokens <= balanceOf(msg.sender) + feeToken ,"Insufficient balance");
        redeemBalances[msg.sender] = redeemBalances[msg.sender].add(_tokens);
        transfer(_redeemWallet, _tokens);
        transfer(_feeWallet, feeToken);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param _from The address of redeemed user to be burned from.
     * @param _value The amount of token to be burned.
     */
    function burnFrom(address _from, uint256 _value) public onlyOwner {
        require(_value > 0);
        redeemBalances[_from] = redeemBalances[_from].sub(_value);
        _burn(_redeemWallet, _value);
    }

    /**
     * @dev Set fee of redeem token.
     * @param _value The fee of token.
     */
    function setFee(uint256 _value) public onlyOwner returns (bool){
        require(_value > 0);
        _fee = _value;
        return true;
    }

    /**
     * @dev Get fee of redeem token.
     */
    function getFee() public view returns (uint256){
        return _fee;
    }
}