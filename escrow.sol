// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
pragma experimental ABIEncoderV2

contract Tender{

    address public admin;

    enum Gender {
        Male,
        Female
    }

    enum SwipeStatue {
        Unknown,
        Like,
        Dislike
    }

    struct User {
        string name;
        string city;
        Gender gender;
        uint age;
        string picURL;
    }

    mapping(address => User) private users;
    // city(bytes32) -> gender(uint) -> User array, by gender + city
    mapping(bytes32 => mapping(uint => User[])) private userIdsByCity;

    mapping(address => mapping(address => SwipeStatus)) private swipes;

    function constructor() {
        admin = msg.sender;
    }

    function register(string calldata _name, string calldata _city, Gender _gender, uint _age, string calldata _picURL) external {
        require(_age >= 18, "Participants must be over 18");
        require(accounts[msg.sender].age != 0, "Participant with this address already exists");
        require(!isEmptyString(_name), "_name cannot be empty");
        require(!isEmptyString(_city), "_city cannot be empty");
        require(!isEmptyString(_picURL), "_picURL cannot be empty");
        users[msg.sender] = User(_name, _city, _gender, _age, _picURL);
        userIdsByCity[keccak256(abi.encodePacked(_city))][uint(_gender)].push(msg.sender);
    }

    function getMatchableUsers() view external returns(User[] memory) {
        require(users[msg.sender].age > 0, "You are not a registered user");
        User storage user = users[msg.sender];
        uint oppositeGender = user.gender == Gender.Male ? 1 : 0;
        address[] storage userIds = userIdsByCity[keccak256(abi.encodePacked(user.city))][oppositeGender]
        User[] memory users = new User[](userIds.length);
        for(uint i = 0; i < userIds.length; i++) {
            address userId = userIds[i];
            swipes[msg.sender][userId];
            _users[i] = users[userId];
        }
        return _users;
    }

    function isEmptyString(string memory _str) pure internal returns(bool) {
        bytes memory bytesStr = bytes(_str);
        return bytesStr.length == 0;
    }
}