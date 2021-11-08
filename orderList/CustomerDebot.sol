pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "AClerkDebot.sol";


contract CustomerDebot is AClerkDebot {
   
    string m_orderName; // Order name for create

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
                MenuItem("Create new order","",tvm.functionId(createOrder)),
                MenuItem("Show order list","",tvm.functionId(showOrderList)),
                MenuItem("Delete order","",tvm.functionId(deleteOrder))
            ]
        );
    }

    function createOrder(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(createOrder_), "Enter order name:", false);
    }
    function createOrder_(string value) public {
        m_orderName = value;
        Terminal.input(tvm.functionId(createOrder__), "Enter number:", false);
    }

    function createOrder__(string value) public view {
        (uint256 number,) = stoi(value);
        optional(uint256) pubkey = 0;
        IOrderList(m_address).createOrder{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_orderName,uint32(number));
    }
}
