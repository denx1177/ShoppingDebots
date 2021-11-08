pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "ShopStructures.sol";

contract orderList {
    /*
     * ERROR CODES
     * 100 - Unauthorized
     * 102 - task not found
     */

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    uint32 m_count;

    

    mapping(uint32 => Order) m_orderList;

    uint256 m_ownerPubkey;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    function createOrder(string text, uint32 number) public onlyOwner {
        tvm.accept();
        m_count++;
        m_orderList[m_count] = Order(m_count, text, number, now, false, 0);
    }

    function updateOrder(uint32 id, uint64 cost, bool done) public onlyOwner {
        optional(Order) order = m_orderList.fetch(id);
        require(order.hasValue(), 102);
        tvm.accept();
        Order thisOrder = order.get();
        thisOrder.isPaid = done;
        thisOrder.cost = cost;
        m_orderList[id] = thisOrder;
    }

    function deleteOrder(uint32 id) public onlyOwner {
        require(m_orderList.exists(id), 102);
        tvm.accept();
        delete m_orderList[id];
    }

    // Get methods

    function getOrderList() public view returns (Order[] orderList) {
        string text;
        uint32 number;
        uint64 createdAt;
        bool isPaid;
        uint64 cost;

        for((uint32 id, Order order) : m_orderList) {
            text = order.text;
            number = order.number;
            isPaid = order.isPaid;
            createdAt = order.createdAt;
            cost = order.cost;
            orderList.push(Order(id, text, number, createdAt, isPaid, cost));
       }
    }

    function getStat() public view returns (Stat stat) {
        uint32 paidCount;
        uint32 unpaidCount;
        uint64 paidSum;

        for((, Order order) : m_orderList) {
            if  (order.isPaid) {
                paidCount += order.number;
                paidSum += order.cost;
            } else {
                unpaidCount += order.number;
            }
        }
        stat = Stat( paidCount, unpaidCount, paidSum );
    }
}
