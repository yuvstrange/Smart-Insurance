pragma solidity >=0.4.22 <0.6.0;

contract HealthCare {

    address private hospitalAdmin;
    address private labAdmin;

    struct Record {
        uint256 ID;
        uint256 price;
        uint256 signatureCount;
        string testName;
        string date;
        string hospitalName;
        bool isValue;
        address pAddr;
        mapping (address => uint256) signatures;
    }

    modifier signOnly {
        require (msg.sender == hospitalAdmin || msg.sender == labAdmin );
        _;
    }

    constructor() public {
        hospitalAdmin = msg.sender;
        labAdmin = 0x2DbA8D6213cd06a57588DFA525aB091469829a2f ;               
    }
    
    
    
    mapping (uint256=> Record) public _records;
    uint256[] public recordsArr;

    event recordCreated(uint256 ID, string testName, string date, string hospitalName, uint256 price);
    event recordSigned(uint256 ID, string testName, string date, string hospitalName, uint256 price);
    
   
    function newRecord (uint256 _ID, string memory _tName, string memory _date, string memory hName, uint256 price) public{
        Record storage _newrecord = _records[_ID];

        
        require(!_records[_ID].isValue);
            _newrecord.pAddr = msg.sender;
            _newrecord.ID = _ID;
            _newrecord.testName = _tName;
            _newrecord.date = _date;
            _newrecord.hospitalName = hName;
            _newrecord.price = price;
            _newrecord.isValue = true;
            _newrecord.signatureCount = 0;

        recordsArr.push(_ID);
        emit  recordCreated(_newrecord.ID, _tName, _date, hName, price);
    }

    
    function signRecord(uint256 _ID) signOnly public {
        Record storage records = _records[_ID];
        
        
        require(address(0) != records.pAddr);
        require(msg.sender != records.pAddr);
        
        
        require(records.signatures[msg.sender] != 1);

        records.signatures[msg.sender] = 1;
        records.signatureCount++;

        
        if(records.signatureCount == 2)
            emit  recordSigned(records.ID, records.testName, records.date, records.hospitalName, records.price);

    }
}