pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct Order {
        uint32 id;
        string text;
        uint32 number;
        uint64 createdAt;
        bool isPaid;
        uint64 cost;
    }

struct Stat {
        uint32 paidCount;
        uint32 unpaidCount;
        uint64 paidSum;
    }