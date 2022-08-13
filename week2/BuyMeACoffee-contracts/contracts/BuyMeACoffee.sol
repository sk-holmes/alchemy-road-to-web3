// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract BuyMeACoffee {
    
    // emitted when new memo is created.
    event NewMemo (
        address from,
        uint256 timestamp,
        string name,
        string message
    );

    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received.
    Memo[] memos;

    // deployer addr
    address payable owner;

    // From: https://docs.soliditylang.org/en/v0.8.16/common-patterns.html

    /// Sender not authorized for this
    /// operation.
    error Unauthorized();

    // Modifiers can be used to change
    // the body of a function.
    // If this modifier is used, it will
    // prepend a check that only passes
    // if the function is called from
    // a certain address.
    modifier onlyBy(address account)
    {
        if (msg.sender != account)
            revert Unauthorized();
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev Buy a coffee for the contract owner
     * @param _name Name of the generous coffee buyer
     * @param _message any message sent that are allowed under the laws of physics
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "Send > 0 ETH to buy coffee");

        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        //Emit event
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev Withdraw entire balance to owner.
     */
    function withdrawTips(address payable toAddr) public onlyBy(owner) {
        require(toAddr.send(address(this).balance));
    }

    /**
     * @dev Retrieve all memos stored.
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

}
