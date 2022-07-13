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
    mapping(uint32 => ownership) public ownerships; // ownerships by ownership ID (owner_id)
    mapping(uint32 => uint32[]) public productTrack;  // ownerships by Product ID (product_id) / Movement track for a product

    event TransferOwnership(uint32 prdouctId);

    modifier onlyOwner(uint32 _productId) {
        require(products[_productId].productOwner != msg.sender);
        _;
    }

    modifier onlyManufacturer(uint32 _ownerId) {
        require(keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer"), "Only Manufacturer can add a product");
        _;
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

    function addProduct(uint32 _ownerId,
                        string memory _modelNumber,
                        string memory _partNumber,
                        string memory _serialNumber,
                        uint32 _productCost) onlyManufacturer(_ownerId) public returns (uint32) {
        uint32 productId = product_id++;
        products[productId].modelNumber = _modelNumber;
        products[productId].partNumber = _partNumber;
        products[productId].serialNumber = _serialNumber;
        products[productId].productOwner = participants[_ownerId].participantAddress;
        products[productId].cost = _productCost;
        products[productId].mfgTimeStamp = uint32(block.timestamp);
        return productId;
    }
}