pragma solidity >=0.4.22 <0.6.0;

contract Healthcare {
    address private hospitalAdmin;

    struct Records {
        uint256 doc_ID;
        uint256 signatureCnt;
        string date;
        string hospitalName;
        string patientName;
        bool isValue;
        address pAddress;
        mapping (address => uint256) signatures;
    }

    modifier signAuth {
        require(msg.sender == hospitalAdmin);
        _;
    }

    constructor() public {
        hospitalAdmin = 0x625C0F8A9679585c38F4d52C7870d78Ea6B1Fc6b;
    }

    mapping (uint256=> Records) public _records;
    uint256[] public recordsArr;

    event recordCreated(uint256 doc_ID, string patientName, string date, string hospitalName);
    event recordSigned(uint256 doc_ID, string patientName, string date, string hospitalName);

    function newRecord(uint256 _ID, string memory _pName, string memory _date, string memory hName) public{
        Records storage _newRecord = _records[_ID];

        require(!_records[_ID].isValue);
            _newRecord.pAddress = msg.sender;
            _newRecord.doc_ID = _ID;
            _newRecord.patientName = _pName;
            _newRecord.date = _date;
            _newRecord.hospitalName = hName;
            _newRecord.signatureCnt = 0;
        
        recordsArr.push(_ID);
        emit recordCreated(_newRecord.doc_ID, _pName, _date, hName);
    }

    function signRecord(uint256 _ID) signAuth public {
        Records storage record = _records[_ID];

        require(address(0) != record.pAddress);
        require(msg.sender != record.pAddress);

        require(record.signatures[msg.sender] != 1);
        record.signatureCnt += 1;

        if(record.signatureCnt == 1){
            emit recordSigned(record.doc_ID, record.patientName, record.date, record.hospitalName);
        }
    }
}
