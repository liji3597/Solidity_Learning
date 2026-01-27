// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

// --- 1. 定义接口 (相当于 .h 文件) ---
interface ILogistics {
    // 状态定义
    enum State { Pending, Shipped, Delivered }
    
    // 核心功能声明
    function createOrder(uint256 orderId, string memory item) external;
    function shipOrder(uint256 orderId, string memory location) external;
    function confirmReceipt(uint256 orderId) external;
    
    // 事件声明 (中断信号)
    event OrderCreated(uint256 indexed orderId, string item);
    event StatusUpdated(uint256 indexed orderId, State status, string location);
}

// --- 2. 实现合约 (相当于 .c 文件) ---
contract LogisticsSystem is AccessControl, ILogistics {
    
    // 定义角色哈希 (32位 UUID)
    bytes32 public constant SUPPLIER_ROLE = keccak256("SUPPLIER");
    bytes32 public constant COURIER_ROLE = keccak256("COURIER");

    // 数据结构
    struct Order {
        uint256 id;
        string item;
        address customer; // 谁买的
        State state;      // 当前状态
        string location;  // GPS坐标或地名
        uint256 timestamp;// 最后更新时间
    }

    // 数据库: OrderID -> Order详情
    mapping(uint256 => Order) public orders;

    // 构造函数
    constructor() {
        // TODO 1: 把部署者 (msg.sender) 设置为默认管理员 (DEFAULT_ADMIN_ROLE)
        // 提示: 使用 _grantRole
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // --- 功能实现 ---

    // 1. 创建订单 (仅 Supplier 可调用)
    function createOrder(uint256 _id, string memory _item) public override onlyRole(SUPPLIER_ROLE) {
        // 检查订单是否已存在 (防止覆盖)
        require(orders[_id].id == 0, "Order already exists");

        // TODO 2: 写入数据到 mapping
        // 初始状态为 Pending，位置为 "Factory"，客户暂定为 msg.sender (或者您可以加个参数指定客户)
        orders[_id] = Order({
            id: _id,
            item: _item,
            customer: address(0), // 暂时留空，或者您可以在参数里加上 customer
            state: State.Pending,
            location: "Factory",
            timestamp: block.timestamp
        });

        emit OrderCreated(_id, _item);
    }

    // 为了简化，我们增加一个 helper 函数来设置客户 (仅 Admin 或 Supplier 可操作)
    function setCustomer(uint256 _id, address _customer) public onlyRole(SUPPLIER_ROLE) {
         orders[_id].customer = _customer;
    }

    // 2. 发货 (仅 Courier 可调用)
    function shipOrder(uint256 _id, string memory _location) public override onlyRole(COURIER_ROLE) {
        // TODO 3: 状态机检查
        // 只有当前状态是 Pending 才能发货
        require(orders[_id].state == State.Pending, "Invalid state transition");

        // 更新状态和位置
        orders[_id].state = State.Shipped;
        orders[_id].location = _location;
        orders[_id].timestamp = block.timestamp;

        // 发射事件
        emit StatusUpdated(_id, State.Shipped, _location);
    }

    // 3. 确认收货 (仅 订单对应的 Customer 可调用!)
    // 注意: 这里不用 Role，因为每个订单的客户都不一样，要根据 mapping 里的数据动态判断
    function confirmReceipt(uint256 _id) public override {
        // TODO 4: 权限检查
        // 必须是 orders[_id].customer 才能调用，或者是 Admin
        require(msg.sender == orders[_id].customer, "Not your order");
        
        // TODO 5: 状态机检查
        // 只有 Shipped 状态才能签收
        require( orders[_id].state == State.Shipped, "Not shipped yet");

        // 更新状态
        orders[_id].state = State.Delivered;
        orders[_id].location = "CustomerHand";
        orders[_id].timestamp = block.timestamp;

        emit StatusUpdated(_id, State.Delivered, "CustomerHand");
    }
}