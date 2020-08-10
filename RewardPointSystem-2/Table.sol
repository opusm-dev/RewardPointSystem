pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

interface Table {
    struct Row {
        string[] names;
        string[] values;
        bool available;
    }
    
    function add(Row calldata row) external;
    function update(Row calldata newRow) external;
    function getRow(string calldata key) external view returns (Row memory);
}
