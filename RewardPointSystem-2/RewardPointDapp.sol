pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

import './Table.sol';
import './Casting.sol';

contract RewardPointDapp {
    using Casting for *;
    
    mapping(string => address) private tables;
    
    function register(string memory key, address table) public {
        require(address(0x0) == tables[key]);
        tables[key] = table;
    }
    
    function getTable(string memory key) private view returns (Table) {
        return Table(tables[key]);
    }
    
    function getCustomer(string memory name) public view returns (Table.Row memory) {
        return getTable("Customer").getRow(name);
    }
    
    function getCustomer(string memory name, string memory column) private view returns (string memory) {
        string[] memory tmp = getTable("Customer").getRow(name).names;
        
        for(uint i=0; i<tmp.length; i++) {
            if(keccak256(abi.encodePacked(tmp[i])) == keccak256(abi.encodePacked(column))) {
                return getTable("Customer").getRow(name).values[i];
            }
        }
        
        return "";
    }
    
    function getProductUsingPID(string memory pid) public view returns (Table.Row memory) {
        return getTable("Product").getRow(pid);
    }
    
    function getProductUsingPID(string memory pid, string memory column) private view returns (string memory) {
        string[] memory tmp = getTable("Product").getRow(pid).names;
        
        for(uint i=0; i<tmp.length; i++) {
            if(keccak256(abi.encodePacked(tmp[i])) == keccak256(abi.encodePacked(column))) {
                return getTable("Product").getRow(pid).values[i];
            }
        }
        
        return "";
    }
    
    function buyProductUsingMoney(string memory customerName, string memory productID, string memory newID, uint amount) public {
        uint productPerPrice = Casting.string2uint(getProductUsingPID(productID, 'perPrice'));
        uint productAmount = Casting.string2uint(getProductUsingPID(productID, "amount"));
        uint customerMoney = Casting.string2uint(getCustomer(customerName, "money"));
        uint total = productPerPrice * amount;
        
        require(customerMoney >= total);
        require(productAmount >= amount);
        
        Table.Row memory tmpProduct = getProductUsingPID(productID);
        tmpProduct.values[3] = Casting.uint2string(productAmount - amount);
        getTable("Product").update(tmpProduct);
        
        uint customerPoint = Casting.string2uint(getCustomer(customerName, "point"));
        uint productPointRate = Casting.string2uint(getProductUsingPID(productID, "pointRate"));
        
        Table.Row memory tmpCustomer = getCustomer(customerName);
        tmpCustomer.values[1] = Casting.uint2string(customerMoney - total);
        tmpCustomer.values[2] = Casting.uint2string(customerPoint + (total * productPointRate) / 100);
        getTable("Customer").update(tmpCustomer);
        
        Table.Row memory newProduct = getProductUsingPID(productID);
        newProduct.values[0] = newID;
        newProduct.values[3] = Casting.uint2string(amount);
        newProduct.values[5] = customerName;
        getTable("Product").add(newProduct);
    }
    
    function buyProductUsingPoint(string memory customerName, string memory productID, string memory newID, uint amount) public {
        uint productPerPrice = Casting.string2uint(getProductUsingPID(productID, 'perPrice'));
        uint productAmount = Casting.string2uint(getProductUsingPID(productID, "amount"));
        uint customerPoint = Casting.string2uint(getCustomer(customerName, "point"));
        uint total = productPerPrice * amount;
        
        require(customerPoint >= total);
        require(productAmount >= amount);
        
        Table.Row memory tmpProduct = getProductUsingPID(productID);
        tmpProduct.values[3] = Casting.uint2string(productAmount - amount);
        getTable("Product").update(tmpProduct);
        
        Table.Row memory tmpCustomer = getCustomer(customerName);
        tmpCustomer.values[2] = Casting.uint2string(customerPoint - total);
        getTable("Customer").update(tmpCustomer);
        
        Table.Row memory newProduct = getProductUsingPID(productID);
        newProduct.values[0] = newID;
        newProduct.values[3] = Casting.uint2string(amount);
        newProduct.values[5] = customerName;
        getTable("Product").add(newProduct);
    }
}
