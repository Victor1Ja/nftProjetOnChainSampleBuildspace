// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string baseSvg = "<svg xmlns=\"http://www.w3.org/2000/svg\" preserveAspectRatio=\"xMinYMin meet\" viewBox=\"0 0 350 350\"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width=\"100%\" height=\"100%\" fill=\"black\" /><text x=\"50%\" y=\"50%\" class=\"base\" dominant-baseline=\"middle\" text-anchor=\"middle\">";


    string[] firstWords = ["Beloved", "Amazing", "Sad", "Gorgeous", "Spicy", "Hot","Small", "Tall", "Huge", "Pretty", "Beutiful", "Ugly", "Happy", "Weird"];

    string[] secondWords = ["Butt", "Mouth", "Ankle", "Boobs", "Eyes", "Knees", "Elbow", "Nose", "Legs", "Feet", "Neck", "Tail", "Wings", "Ear", "Teeth","Nipple"];

    string[] thirdWords = ["Kitten", "Puppy", "Sqirrel", "Otter", "Bear", "Fox", "Girl", "Boy", "Bird", "Whale", "Penguin"];

    constructor() ERC721 ("CoolWordsNft", "CWN") {
        console.log("This is my NFT contract. Whoa!");
    }
    /*function pickRandomFistWord(uint ) private{
        random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    }*/
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();
        require(newItemId < firstWords.length * secondWords.length * thirdWords.length/5);
        
        //get the ramdom
        uint seed =uint256(keccak256(abi.encodePacked(newItemId*(uint)(block.timestamp * block.difficulty)))) % 1000000;
        string memory Nft = string(abi.encodePacked(firstWords[ seed%100%firstWords.length], secondWords[ seed/100%100%secondWords.length ],thirdWords[ seed/10000%thirdWords.length] ));

        string memory finalSvg = string(abi.encodePacked(baseSvg, Nft, "</text></svg>"));
        //log the Svg.
        console.log(finalSvg);

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        Nft,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

         // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data.
        _setTokenURI(newItemId, finalTokenUri);

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        console.log(firstWords.length * secondWords.length * thirdWords.length/5);
        console.log("--------------------\n");

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}
