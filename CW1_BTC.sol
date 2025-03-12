pragma solidity ^0.5.1;

/**
This contract stores records of tokens with a date/time string and a value (also as a string).
It includes time-based restrictions and an ownership check for record creation.
*/

contract RecordTokenValue {
     
    uint256 public recordCount = 0;
    mapping(uint => Record) public records;
    
    // Timestamp after which records can be added (18th February 2025, at 00:00 GMT)
    uint256 openingTime = 1739836800;
    
    // Restricts function call to after openingTime
    modifier onlyWhileOpen() {
        require(block.timestamp >= openingTime, "Contract not open yet");
        _;
    }

    // Contract owner address
    address owner;
    
    // Restricts function call to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Sets the deployer as the owner
    constructor() public {
        owner = msg.sender;
    }
    
    // Defines a record with ID, date/time, token name, and value
    struct Record {
        uint id;
        string dateTime;
        string tokenName;
        string valueAsString;
    }
        
    // Adds a new record, restricted by opening time and ownership
    function addRecord(
        string memory dateTime,
        string memory tokenName,
        string memory valueAsString
    )
        public
        onlyWhileOpen
        onlyOwner
    {
        incrementCount();
        records[recordCount] = Record(recordCount, dateTime, tokenName, valueAsString);
    }
    
    // Increments the record counter
    function incrementCount() internal {
        recordCount += 1;
    }
}