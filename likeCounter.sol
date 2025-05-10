// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract likeCounter {
    uint private likeCount;
    address private owner;
    mapping(address => bool) private likedUsers;

    constructor() {
        owner = msg.sender;
        likeCount = 0;
    }

    modifier onlyOneLike() {
        require(!likedUsers[msg.sender], "You have already liked this post.");
        _;
    }

    function like() onlyOneLike public {
        likeCount += 1;
        likedUsers[msg.sender] = true;
    }

    function totalLikeNumbers() public view returns(uint) {
        return likeCount;
    }

    function hasLiked() public view returns(bool) {
        return likedUsers[msg.sender];
    }
}