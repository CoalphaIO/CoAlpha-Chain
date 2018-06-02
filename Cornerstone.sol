pragma solidity 0.4.24;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./CoAlphaToken.sol";


contract CoAlphaTokenConerstone is Ownable {
    using SafeMath for uint256;
    CoAlphaToken private tokenContract;
    mapping(address => uint256) private tokenAccountList;
    mapping(address => uint256) private tokenReleaseList;
    uint256 private releaseTime1 = 1528560000;
    uint256 private releaseTime2 = 1536508800;
    uint256 private releaseTime3 = 1544371200;
    uint256 private releaseTime4 = 1552147200;
    uint256 private releaseTime5 = 1560096000;
    uint256 private step = 5;

    function addConerstone (
        address _conerstone,
        uint256 _tokenNum
    )
        public
        onlyOwner
    {
        require(now < releaseTime1);
        tokenAccountList[_conerstone] = _tokenNum;
    }

    function configTokenContract ( 
        address _tokenContract
    ) 
        public
        onlyOwner
    {
        tokenContract = CoAlphaToken(_tokenContract);
    }

    function conerstoneTokenBalance () 
        public
        view
        returns (uint256)
    {
        return tokenAccountList[msg.sender];
    }

    function conerstoneReleaseBalance ()
        public
        view
        returns (uint256)
    {
        return tokenReleaseList[msg.sender];
    }

    function getReleaseStep ()
        private
        returns (uint256)
    {
        uint256 curStep = 0;
        if (now >= releaseTime5) {
            curStep = 5;
        } else if (now >= releaseTime4) {
            curStep = 4;
        } else if (now >= releaseTime3) {
            curStep = 3;
        } else if (now >= releaseTime2) {
            curStep = 2;
        } else if (now >= releaseTime1) {
            curStep = 1;
        }
        return curStep;
    }

    function releaseToken ()
        public
    {
        require(tokenContract != CoAlphaToken(0));
        uint256 curStep = getReleaseStep();
        require(curStep > 0 && curStep <= 5);
        uint256 needReleaseTokenTotal = tokenAccountList[msg.sender];
        if (curStep < 5) {
            needReleaseTokenTotal = tokenAccountList[msg.sender].mul(curStep).div(5);
        }
        uint256 curReleaseTokenTotal = tokenReleaseList[msg.sender];
        uint256 amount = needReleaseTokenTotal - curReleaseTokenTotal;
        if (amount > 0) {
            tokenReleaseList[msg.sender] = needReleaseTokenTotal;
            tokenContract.transferFrom(owner, msg.sender, amount);
        }
    }
}