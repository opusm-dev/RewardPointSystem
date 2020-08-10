pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

contract SimplePoint {
    
    struct Customer {
		string name;
        uint money;
        uint point;
    }
    
    struct Product {
    	string pid;
	    string name;
        uint perPrice;
        uint amount;
        uint pointRate;
        string owner;
    }
    
    mapping(string=>Customer) private customers;
    mapping(string=>Product) private products;
    
    constructor() public {
        customers['LEE'] = Customer('LEE', 100000, 0);
	    customers['KIM'] = Customer('KIM', 50000, 0);
	    customers['PARK'] = Customer('PARK', 80000, 0);
        
        products['48374'] = Product('48374', '컵라면', 1200, 10, 50, 'GS25');
        products['15432'] = Product('15432','삼각김밥', 800, 20, 35, 'GS25');
        
        products['53346'] = Product('53346', '화장지', 8000, 5, 38, 'Home Plus');
        products['98341'] = Product('98341', '샴푸', 6200, 15, 27, 'Home Plus');
        
        products['25364'] = Product('25364', '영화관람표', 8000, 45, 70, 'CGV');
        products['38346'] = Product('38346', '팝콘', 4000, 50, 55, 'CGV');
    }
    
    function buyProductUsingMoney(string memory customerName, string memory productID, string memory newID, uint amount) public {
        uint total = products[productID].perPrice * amount;
        require(customers[customerName].money >= total);
        require(products[productID].amount >= amount);
        
        products[productID].amount -= amount;
        customers[customerName].money -= total;
        
        customers[customerName].point += (total * products[productID].pointRate) / 100;
        
        string memory productName = products[productID].name;
        uint productPerPrice = products[productID].perPrice;
        uint productPointRate = products[productID].pointRate;
        
        products[newID] = Product(newID, productName, productPerPrice, amount, productPointRate, customerName);
    }
    
    function buyProductUsingPoint(string memory customerName, string memory productID, string memory newID, uint amount) public {
        uint total = products[productID].perPrice * amount;
        require(customers[customerName].point >= total);
        require(products[productID].amount >= amount);
        
        products[productID].amount -= amount;
        customers[customerName].point -= total;
        
        string memory productName = products[productID].name;
        uint productPerPrice = products[productID].perPrice;
        uint productPointRate = products[productID].pointRate;
        
        products[newID] = Product(newID, productName, productPerPrice, amount, productPointRate, customerName);
    }
    
    function getProducts(string memory pid) public view returns (Product memory) {
        return products[pid];
    }
    
    function getCustomerInfo(string memory customerName) public view returns (Customer memory) {
        return customers[customerName];
    }
}
