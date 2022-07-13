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

    modifier onlyForward(uint32 _oldOwner, uint32 _newOwner){
        participant memory tempOldOwner = participants[_oldOwner];
        participant memory tempNewOwner = participants[_newOwner];
        bool boolManufacturer = keccak256(abi.encodePacked(tempOldOwner.participantType)) == keccak256("Manufacturer")
            && keccak256(abi.encodePacked(tempNewOwner.participantType))==keccak256("Supplier");
        bool boolSupplyer = keccak256(abi.encodePacked(tempOldOwner.participantType)) == keccak256("Supplier") 
            && keccak256(abi.encodePacked(tempNewOwner.participantType))==keccak256("Supplier");
        bool boolConsumer = keccak256(abi.encodePacked(tempOldOwner.participantType)) == keccak256("Supplier") 
            && keccak256(abi.encodePacked(tempNewOwner.participantType))==keccak256("Consumer");
        require(boolManufacturer || boolSupplyer || boolConsumer, "The product can only be transferred from Manufacturer to Supplier or Supplier to Consumer or Supplier to Supplier.");
        _;
    }

    function addParticipant(string memory _username, 
                            string memory _password, 
                            string memory _participantType, 
                            address _participantAddress) public returns (uint32){
                                uint32 participantId = participant_id++;
                                participants[participantId].userName = _username;
                                participants[participantId].password = _password;
                                participants[participantId].participantType = _participantType;
                                participants[participantId].participantAddress = _participantAddress;

                                return participantId;
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

    function newOwner(uint32 _oldOwner, uint32 _newOwner, uint32 _productId) onlyOwner(_productId) onlyForward(_oldOwner, _newOwner) public returns (bool) {
        uint32 ownerId = owner_id++;
        address p2Address = participants[_newOwner].participantAddress;

        ownerships[ownerId].productId = _productId;
        ownerships[ownerId].productOwner = p2Address;
        ownerships[ownerId].ownerId = _newOwner;
        ownerships[ownerId].trxTimeStamp = uint32(block.timestamp);
        products[_productId].productOwner = p2Address;
        productTrack[_productId].push(ownerId);
        emit TransferOwnership(_productId);

        return (true);
    }

    function getProvenance(uint32 _productId) external view returns (uint32[] memory) {
        return productTrack[_productId];
    }

    function getOwnership(uint32 _tempId)  public view returns (uint32, uint32, address, uint32) {

        ownership memory tempOwner = ownerships[_tempId];

         return (tempOwner.productId, tempOwner.ownerId, tempOwner.productOwner, tempOwner.trxTimeStamp);
    }

    function authenticateParticipant(string memory _username, string memory _password) public view returns (bool) {
        for(uint32 i = 0; i < participant_id; i++) {
            bool usernameMatch = keccak256(abi.encodePacked(participants[i].userName)) == keccak256(abi.encodePacked(_username));
            bool passwordMatch = keccak256(abi.encodePacked(participants[i].password)) == keccak256(abi.encodePacked(_password));
            if(usernameMatch && passwordMatch) {
                return (true);
            }
        }
        return (false);
    }

}