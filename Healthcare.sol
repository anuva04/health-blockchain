pragma solidity >=0.4.22 <0.6.0;

contract Healthcare {
    address private hospitalAdmin;

    struct Records {
        uint256 doc_ID;
        uint256 signatureCnt;
        string date;
        string hospitalName;
        string patientName;
        bool isvalue;
        address pAddress;
        mapping (address => uint256) signatures;
    }

    modifier signAuth {
        require(msg.sender == hospitalAdmin);
        _;
    }

    constructor() public {
        hospitalAdmin = 0x194A6c4eA6eA9B5e8FE82F27fE53105f9F7268A9;
    }

    mapping (uint256=> Records) public _records;
    uint256[] public recordsArr;

    event recordCreated(uint256 doc_ID, string patientName, string date, string hospitalName);
    event recordSigned(uint256 doc_ID, string patientName, string date, string hospitalName);

    function newRecord(uint256 _ID, string memory _pName, string memory _date, string hName) {
        Records storage _newRecord = _records[_ID];

        require(!_records[_ID].isValue);
            _newRecord.pAddress = msg.sender;
            _newRecord.doc_ID = _ID;
            _newRecord.patientName = _pName;
            _newRecord.date = _date;
            _newRecord.hospitalName = hName;
            _newRecord.signatureCnt = 0;
        
        recordsArr.push(_ID);
        emit recordCreated(newRecord.doc_ID, _pName, _date, hName);
    }

    function signRecord(uint256 _ID) signAuth public {
        Records storage record = _records[_ID];

        require(address(0) != records.pAddress);
        require(msg.sender != records.pAddress);

        require(record.signatures[msg.sender] != 1);
        record.signatureCnt += 1;

        if(record.signatureCnt == 1){
            emit recordSigned(record.doc_ID, record.patientName, record.date, record.hospitalName);
        }
    }
}