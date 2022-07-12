// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract supplyChain{
    uint32 public product_id = 0;   // Product ID
    uint32 public participant_id = 0;   // Participant ID
    uint32 public owner_id = 0;   // Ownership ID    

    struct participant{
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }
    
    struct product{
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    struct ownership{
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }

    mapping(uint32 => participant) public participants;
    mapping(uint32 => product) public products;

    event TransferOwnership(uint32 prdouctId);

    modifier onlyOwner(uint32 _productId) {
        if(products[_productId].productOwner != msg.sender) {
            throw;
        }
        _;
    }

    modifier onlyManufacturer{
        if(!participants[msg.sender].participantType == "Manufacturer"){
            throw;
        }
    }

    function addParticipant(string memory _username, 
                            string memory _password, 
                            string memory _participantType, 
                            address _participantAddress) public returns (uint32){
                                uint32 tempID = participant_id++;
                                participants[tempID].userName = _username;
                                participants[tempID].password = _password;
                                participants[tempID].participantType = _participantType;
                                participants[tempID].participantAddress = _participantAddress;

                                return tempID;
                            }

    function getParticipant(uint32 _participant_id) public view returns (string memory,address,string memory) {
        return (participants[_participant_id].userName,
                participants[_participant_id].participantAddress,
                participants[_participant_id].participantType);

    
}