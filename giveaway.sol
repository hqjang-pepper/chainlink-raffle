// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Giveaway is VRFConsumerBaseV2 {
    address [] public addresses;
    mapping (address => bool) public rafflemap;
    address [] private _winners;
    event Winner(
        address [] indexed _winners,
        uint256 gameId
    );
    event Registered(
        address indexed user
    );

    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;


    address vrfCoordinator = 0x271682DEB8C4E0901D1a1550aD2e64D568E69909;

    bytes32 keyHash = 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;

    uint32 callbackGasLimit = 500000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;


    uint32 numRandoms =  5;

    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }


    function insertAddress() public {
      address who = msg.sender;
      require(!rafflemap[who]);
      addresses.push(who);
      rafflemap[who] = true;
      emit Registered(who);
    }

    // Assumes the subscription is funded sufficiently.
    function giveaway() external onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numRandoms
        );
    }
    
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;
    }

    function pusharray() public onlyOwner {
      //case which we have to raffle again
      if(_winners.length > 0){
        delete _winners;
      }
      for(uint i=0; i<numRandoms; i++){
        uint256 randomNumber = (s_randomWords[i] % addresses.length);
        _winners.push(addresses[randomNumber]);
      }
      emit Winner(_winners, s_requestId);
    }

    function getwinners() public view returns (address[] memory){
      return _winners;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }
}
