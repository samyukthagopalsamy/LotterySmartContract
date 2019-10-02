pragma solidity ^0.5.6;

contract Lottery {
    address public manager;
    address payable[] public players;
    event winnerEvent (address winner, uint amount);
    constructor() public {
        manager = msg.sender;
    }
    modifier onlyManager() {
        require(manager == msg.sender,"Only the manager can call this fn");
        _;
    }
    function () payable external {
        require(msg.value >= 0.01 ether);
        require(manager != msg.sender);
        players.push(msg.sender);
    }
    function balance() public view onlyManager returns (uint) {
        //require(manager == msg.sender,"Only the manager can call balance");
        return address(this).balance;
    }
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp,players.length)));
    }
    function selectWinner() public onlyManager {
        //require(manager == msg.sender,"Only the manager can call winner");
        uint r = random();
        address payable winner;
        uint index = r % players.length;
        winner = players[index];
        require(manager != winner);
        emit winnerEvent(winner,address(this).balance);
        winner.transfer(address(this).balance);
        players = new address payable[](0);
        //emit winnerEvent(winner,address(this).balance);
    }
}