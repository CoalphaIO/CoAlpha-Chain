pragma solidity 0.4.24;


library SafeMath {
    function mul(
        uint256 a, 
        uint256 b
    )
        internal
        pure
        returns (uint256 c)
    {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b);
        return c;
    }

    function div(
        uint256 a, 
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        return a / b;
    }

    function sub(
        uint256 a, 
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        require(b <= a);
        return a - b;
    }

    function add(
        uint256 a,
        uint256 b
    )
        internal
        pure
        returns (uint256 c)
    {
        c = a + b;
        require(c >= a);
        return c;
    }
}