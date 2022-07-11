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
}