pragma solidity 0.4.24;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./CoAlphaToken.sol";


contract CoAlphaTokenCornerStone is Ownable {
    using SafeMath for uint256;
    CoAlphaToken public tokenContract;
    address public fundAccount;
    uint256 public tokenPrice;
    mapping(address => uint256) public tokenAccountList;
    uint256 public tokenTotal;
    uint256 public releaseTime;

    function () public payable {
        require(tokenContract != CoAlphaToken(0));
        if (msg.sender != fundAccount) {
            require(msg.value >= minDonation);
            uint256 amount = calculateTokensPerWeiFromBuyPrice(msg.value);
            tokenAccountList[msg.sender] = tokenAccountList[msg.sender].add(amount);
            tokenTotal = tokenTotal.add(amount);
            fundAccount.transfer(msg.value);
        }
    }

    function configCornerStone(
        address _tokenContract, 
        address _fundAccount, 
        uint256 _minDonation,
        uint256 _tokenPrice, 
        uint256 _releaseTime
    ) 
        public
        onlyOwner
    {
        require(_releaseTime > now);
        tokenContract = CoAlphaToken(_tokenContract);
        fundAccount = _fundAccount;
        minDonation = _minDonation;
        tokenPrice = _tokenPrice;
        releaseTime = _releaseTime;
    }

    function releaseToken ()
        public
    {
        require(tokenContract != CoAlphaToken(0));
        require(releaseTime > 0 && releaseTime < now);
        uint256 amount = tokenAccountList[msg.sender];
        if (amount > 0) {
            tokenAccountList[msg.sender] = 0;
            tokenContract.transferFrom(owner, msg.sender, amount);
        }
    }

    uint256 private weiPerEth = 10**18;
    uint256 private minDonation;

    function getEthersFromWei(
        uint256 _weiAmount
    )
        private
        view
        returns (uint256)
    {
        return _weiAmount.div(weiPerEth);
    }

    function getRemainingFractionalEthersFromWei(
        uint256 _weiAmount
    )
        private
        view
        returns (uint256)
    {
        return _weiAmount % weiPerEth;
    }

    function calculateTokensPerWeiFromBuyPrice(
        uint256 _weiAmount
    )
        private
        view
        returns (uint256)
    {
        uint256 ethers = getEthersFromWei(_weiAmount);
        uint256 remainingWeis = getRemainingFractionalEthersFromWei(_weiAmount);
        uint256 etherFraction = remainingWeis.div(weiPerEth);
        uint256 tokenAmount = (ethers.mul(tokenPrice)).add(etherFraction.mul(tokenPrice));
        return tokenAmount;
    }
}