pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "AClerkDebot.sol";


contract PerformerDebot is AClerkDebot {
   
    uint32 m_oderId;    // Order id for update. I didn't find a way to make this var local

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (unpaid/paid/total) orders. Costs = /{}",
                    m_stat.unpaidCount,
                    m_stat.paidCount,
                    m_stat.paidCount + m_stat.unpaidCount,
                    m_stat.paidSum
            ),
            sep,
            [
                MenuItem("Show order list","",tvm.functionId(showOrderList)),
                MenuItem("Update order status","",tvm.functionId(updateOrder)),
                MenuItem("Delete order","",tvm.functionId(deleteOrder))
            ]
        );
    }

    function updateOrder(uint32 index) public {
        index = index;
        if (m_stat.paidCount + m_stat.unpaidCount > 0) {
            Terminal.input(tvm.functionId(updateOrder_), "Enter order number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no order to update");
            _menu();
        }
    }

    function updateOrder_(string value) public {
        (uint256 num,) = stoi(value);
        m_oderId = uint32(num);
        Terminal.input(tvm.functionId(updateOrder__), "Enter a cost:", false);
        // ConfirmInput.get(tvm.functionId(updateOrder__),"Enter cost:");
    }

    function updateOrder__(string value) public view {
        (uint256 cost,) = stoi(value);
        optional(uint256) pubkey = 0;
        IOrderList(m_address).updateOrder{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_oderId, uint64(cost), true);
    }

    
}
