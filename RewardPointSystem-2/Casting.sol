pragma solidity ^0.6.4;

library Casting {
    function uint2string(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
          return '0';
        }
        uint j = _i;
        uint len = 0;
        while (j != 0) {
            ++len;
            j /= 10;
        }
        bytes memory byteValues = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            byteValues[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(byteValues);
    }
    
    function string2uint(string memory s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }
}
