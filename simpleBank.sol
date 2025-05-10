pragma solidity ^0.8.14;

contract SimpleBank {
    uint8 private clientCount;
    mapping (address => uint) private balances;
    address public owner;

    // Log the event about a deposit being made by an address and its amount
    event LogDepositMade(address indexed accountAddress, uint amount);

    // Constructor is "payable" so it can receive the initial funding of 30, 
    // required to reward the first 3 clients
    constructor() payable {
        require(msg.value == 30 ether, "30 ether initial funding required");
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
        clientCount = 0;
    }

    /// @notice Only allow the function to be called by an enrolled customer
    modifier onlyEnrolled() {
        require(balances[msg.sender] > 0, "You must enroll first.");
        _;
    }

    /// @notice Only allow the function to be called by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    /// @notice Enroll a customer with the bank, 
    /// giving the first 3 of them 10 ether as reward
    /// @return The balance of the user after enrolling
    function enroll() public returns (uint) {
        if (clientCount < 3) {
            clientCount++;
            balances[msg.sender] = 10 ether;
        }
        return balances[msg.sender];
    }


    /// @notice Deposit ether into bank, requires method is "payable"
    /// @return The balance of the user after the deposit is made
    function deposit() public payable onlyEnrolled returns (uint) {
        // If we dont use modifier function(onlyEnrolled), we shuould use this way.
        // Check if the user is enrolled
        // require(balances[msg.sender] > 0, "You must enroll first.");

        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @return remainingBal The balance remaining for the user
    function withdraw(uint withdrawAmount) public onlyEnrolled returns (uint remainingBal) {
        // Check enough balance available, otherwise just return balance
        if (withdrawAmount <= balances[msg.sender]) {
            balances[msg.sender] -= withdrawAmount;

            // method1 to transfer ether
            // transfer funct. use fixed gas limit of 2300, so it is not flexible.
            payable(msg.sender).transfer(withdrawAmount);


            // method2 to transfer ether
            // call is a low-level function that can be used to call any function or send ether.
            // it use not fixed gas limit, so it is more flexible than transfer.
            // it returns a boolean(success) and data(bytes memory)

            // (bool success, ) = msg.sender.call{value: withdrawAmount}("");
            // require(success, "Transfer failed.");
        }
        return balances[msg.sender];
    }

    /// @notice Withdraw all ether from the contract, only callable by the owner
    function withdrawAll() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    /// @notice Just reads balance of the account requesting, so "constant"
    /// @return The balance of the user
    function balance() public view onlyEnrolled returns (uint) {
        return balances[msg.sender];
    }

    /// @return The balance of the Simple Bank contract
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }
}