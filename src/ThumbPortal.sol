// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract ThumbPortal {
    uint256 totalUp;
    uint256 totalDown;

        uint256 private seed;
    
    event NewThumb(address indexed from, uint256 timestamp, uint256 orientation, string message);

    struct Thumb {
        address sender; // The address of the user who sent the thumb
        uint256 timestamp; // The timestamp when the user sent the thumb
        uint256 orientation; // The orientation of the thumb (up (1) or down (0))
        string message; // The message the user sent
    }

    Thumb[] thumbs;

    mapping(address => uint256) public lastThumbUp;

    constructor() payable {
        console.log("This is your smart contract speaking...");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function up(string memory _message) public {
        require(
            lastThumbUp[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 seconds!"
        );

        lastThumbUp[msg.sender] = block.timestamp;

        totalUp += 1;
        console.log("%s has put a thumb up with message: %s", msg.sender, _message);

        thumbs.push(Thumb(msg.sender, block.timestamp, 1, _message));

        emit NewThumb(msg.sender, block.timestamp, 1, _message);
        
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed <= 25) {
            console.log("%s won!", msg.sender);
        
            uint256 giftAmount = 0.001 ether;
            require(
                giftAmount <= address(this).balance,
                "There is not enough ether in the contract!"
            );
            (bool success, ) = (msg.sender).call{value: giftAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function down(string memory _message) public {
        totalDown += 1;
        console.log("%s has put a thumb down with message: %s", msg.sender, _message);

        thumbs.push(Thumb(msg.sender, block.timestamp, 0, _message));

        emit NewThumb(msg.sender, block.timestamp, 0, _message);
    }

    function getAllThumbs() public view returns (Thumb[] memory) {
        return thumbs;
    }

    function getTotalUp() public view returns (uint256) {
        console.log("There have been %d thumbs up.", totalUp);
        return totalUp;
    }

    function getTotalDown() public view returns (uint256) {
        console.log("There have been %d thumbs down.", totalDown);
        return totalDown;
    }
}

contract ContractInput is Test {
    ThumbPortal thumbPortal;
    uint256 totalUp;
    uint256 totalDown;
    string message;


    function setUp() public {
        totalUp = 0;
        totalDown = 0;
        message = "hello world";

        thumbPortal = new ThumbPortal();
    }

    // function testUp() public {
    //     assertEq(thumbPortal.getTotalUp(), totalUp);
    //     thumbPortal.up(message);
    //     totalUp++;
    //     assertEq(thumbPortal.getTotalUp(), totalUp);
    // }

    function testDown() public {
        assertEq(thumbPortal.getTotalDown(), totalDown);
        thumbPortal.down(message);
        totalDown++;
        assertEq(thumbPortal.getTotalDown(), totalDown);
    }

    // function testGetAllThumbs() public {
    //     assertEq(thumbPortal.getAllThumbs().length, 2);
    //     assertEq(thumbPortal.getAllThumbs()[0].sender, address(this));
    //     assertEq(thumbPortal.getAllThumbs()[0].orientation, 0);
    //     assertEq(thumbPortal.getAllThumbs()[0].message, message);
    // }
}

// contract ContractOutput is Test {
//     ThumbPortal thumbPortal;
//     string message;

//     event NewThumb(address indexed from, uint256 timestamp, uint256 orientation, string message);

//     function setUp() public {
//         message = "hello world";
//         thumbPortal = new ThumbPortal();
//     }

//     function testFailTime() public {
//         thumbPortal.up(message);
//     }

//     function testEmitNewThumb() public {
//         // ThumbPortal testEmit = new ThumbPortal();
//         skip(45);
//         vm.expectEmit(true, false, true, true);
//         emit NewThumb(address(this), block.timestamp, 1, message); 
//         thumbPortal.up(message);
//     }
// }