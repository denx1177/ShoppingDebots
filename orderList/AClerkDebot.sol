pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "AInitDebot.sol";


abstract contract AClerkDebot is AInitDebot {

    function _menu() internal virtual override;
    
    function showOrderList(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IOrderList(m_address).getOrderList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showOrderList_),
            onErrorId: 0
        }();
    }

    function showOrderList_( Order[] orderList ) public {
        uint32 i;
        if (orderList.length > 0 ) {
            Terminal.print(0, "Your order list:");
            for (i = 0; i < orderList.length; i++) {
                Order order = orderList[i];
                string completed;
                if (order.isPaid) {
                    completed = '✓';
                } else {
                    completed = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" {}   {}  at {}", order.id, completed, order.text, order.number, order.cost, order.createdAt));
            }
        } else {
            Terminal.print(0, "Your order list is empty");
        }
        _menu();
    }

    function deleteOrder(uint32 index) public {
        index = index;
        if (m_stat.paidCount + m_stat.unpaidCount > 0) {
            Terminal.input(tvm.functionId(deleteOrder_), "Enter order number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no order to delete");
            _menu();
        }
    }

    function deleteOrder_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IOrderList(m_address).deleteOrder{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }
}
