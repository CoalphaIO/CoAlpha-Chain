pragma solidity 0.4.24;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./CoAlphaToken.sol";


contract CoAlphaTokenPrivateSell is Ownable {
    using SafeMath for uint256;
    uint256 private weiPerEth = 10**18;
    uint256 private minDonation;
    address private fundAccount;
    CoAlphaToken private tokenContract;
    uint256 private tokenPrice;
    mapping(address => uint256) private tokenAccountList;
    uint256 private releaseTime;

    function () public payable {
        require(tokenContract != CoAlphaToken(0));
        if (msg.sender != fundAccount) {
            require(msg.value >= minDonation);
            uint256 amount = calculateTokensPerWeiFromBuyPrice(msg.value);
            tokenAccountList[msg.sender] = tokenAccountList[msg.sender].add(amount);
            fundAccount.transfer(msg.value);
        }
    }

    function configFundAccount( 
        address _fundAccount
    ) 
        public
        onlyOwner
    {
        fundAccount = _fundAccount;
    }

    function configTokenContract( 
        address _tokenContract
    ) 
        public
        onlyOwner
    {
        tokenContract = CoAlphaToken(_tokenContract);
    }

    function configPrivateSell(
        uint256 _minDonation,
        uint256 _tokenPrice, 
        uint256 _releaseTime
    ) 
        public
        onlyOwner
    {
        minDonation = _minDonation;
        tokenPrice = _tokenPrice;
        releaseTime = _releaseTime;
    }

    function privateTokenBalance() 
        public
        view
        returns (uint256)
    {
        return tokenAccountList[msg.sender];
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

    function calculateTokensPerWeiFromBuyPrice(
        uint256 _weiAmount
    )
        private
        view
        returns (uint256)
    {
        uint256 ethers = _weiAmount.div(weiPerEth);
        uint256 remainingWeis = _weiAmount.sub(ethers.mul(weiPerEth));
        uint256 etherFraction = remainingWeis.div(weiPerEth);
        uint256 tokenAmount = (ethers.mul(tokenPrice)).add(etherFraction.mul(tokenPrice));
        return tokenAmount;
    }
}