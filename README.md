# chainlink-raffle
### Overview
This is a contract that chooses addresses randomly in array, using Chainlink VRF.  
Since Coordinator address and keyHash are different between testnet and mainnet, there are 2 files each for testnet and mainnet.

- giveaway.sol : for mainnet
- giveaway_test.sol : for testnet(rinkedby)

### how to use
- The function to extract random number is giveaway().
- The function to extract and save the address with the extracted random number is pusharray().
- insertAddress() is the function that pushes msg.sender's address into array, which is implemented to revert (fail during the transaction) if there is already an account to apply for in the array.
- You can check the list of winners with getwinners().
