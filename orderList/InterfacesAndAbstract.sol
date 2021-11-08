pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "ShopStructures.sol";

interface Transactable {
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}


abstract contract HasConstructorWithPubKey {
   constructor(uint256 pubkey) public {}
}

interface IOrderList {
   function createOrder(string text, uint32 number) external;
   function updateOrder(uint32 id, uint64 cost, bool done) external;
   function deleteOrder(uint32 id) external;
   function getOrderList() external returns (Order[] orderList);
   function getStat() external returns (Stat);
}