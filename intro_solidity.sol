pragma solidity ^0.8.14;


//DATA LOCATIONS IN VARIABLE TYPES
// memory: temporary storage, can read and write, only used in the current function call
// calldata: read-only temporary storage, used for function arguments
// storage: permanent storage, can read and write, used for state variables

contract Test {
    // STORAGE VARIABLES: these varables are stored on the blockchain
    string data;
    uint number;    //uint: unsigned integer, 0 or positive number
    address owner;  //address: 20 byte address, used for accounts and contracts
    mapping(address => uint) deposit; //mapping: key-value pair, like a dictionary
    uint num1 = 2;
    uint num2 = 4;

    // for logging
    event DataChanged(string message, uint newData); // event: used to notify clients when a state variable changes



    //CONSTRUCTOR
    constructor() {
        owner = msg.sender;

        // msg.sender: address of the account that deployed the contract (address of the user of this contract)
        // msg.value; // amount of ether sent with the transaction
        // address(this); // address of the contract
        // address(0); // address of the zero address, used for checking if an address is valid
        // msg.sender.transfer(1 ether); // transfer ether to the sender
        // block.timestamp; // current block timestamp
        // block.number; // current block number
        // block.difficulty; // current block difficulty
        // block.gaslimit; // current block gas limit
        // block.chainid; // current chain id
        // block.coinbase; // address of the miner of the current block
    }


    function set(string memory _data) public {
        data = _data;
    }

    // function get() public view returns (string memory) {
    //     return data;
    // }



    // MULTİPLE RETURN VALUES
    // method1
    // function get() public view returns (string memory, uint) {
    //     return (data, number);
    // }

    // method2
    function get() public pure returns (string memory _data, uint _number) {
        _data = "Hello World!";
        _number = 42;
    }


    function useGet() public pure returns (string memory, uint) {

        string memory _data;
        uint _number;
        (_data, _number) = get();

        // can also use this to call the function
        // (string memory _data, uint _number) = get();
    
        return (_data, _number);
    }



    //FUNCTİON TYPES

    //PURE: does not read or write to the blockchain, only uses the input parameters
    function getResult() public pure returns (uint product, uint sum) {
        uint a = 2;
        uint b = 3;
        product = a * b;
        sum = a + b;
    }

    //VIEW: reads the blockchain, but does not write to it
    function getResult2() public view returns (uint product, uint sum) {
        product = num1 * num2;
        sum = num1 + num2;
    }

    //STATE CHANGES: write to the blockchain
    function getResult3() public returns (uint product, uint sum) {
        num1 = 10;
        product = num1 * num2;
        sum = num1 + num2;

        emit DataChanged("Data changed!", num1); // emit: used to notify clients when a state variable changes
    }




    // This function is called when the contract receives ether
    // when sended transaction that does not contain any data
    receive() external payable {
        deposit[msg.sender] += msg.value; // deposit ether to the contract
    }


    // When a call is made that does not match the name of a function defined in the contract,
    // For transactions that contain data and do not match the receive(),
    // if the receive() function is not defined and only ether has been sent.
    fallback() external payable {
        deposit[msg.sender] += msg.value;
    }


    // This is a specialized function that is called when the contract receives ether
    function depositEther() public payable {
        deposit[msg.sender] += msg.value;
    }


    function sendEther(address payable recipient, uint amount) public {
        require(deposit[msg.sender] >= amount, "Unsufficient balance"); // require: used to check if a condition is true, if not, revert the transaction
        deposit[msg.sender] -= amount;
        recipient.transfer(amount);
    }
}