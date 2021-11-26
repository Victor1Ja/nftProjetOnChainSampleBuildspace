// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{
    struct NFT{
        address sender;
        uint tokenId;
        string image;
    }
    NFT [] nfts;
    address public owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    string[] firstWords = ["Beloved", "Amazing", "Sad", "Gorgeous", "Spicy", "Hot","Small", "Tall", "Huge", "Pretty", "Beutiful", "Ugly", "Happy", "Weird"];

    string[] secondWords = ["Butt", "Mouth", "Ankle", "Boobs", "Eyes", "Knees", "Elbow", "Nose", "Legs", "Feet", "Neck", "Tail", "Wings", "Ear", "Teeth","Nipple"];

    string[] thirdWords = ["Kitten", "Puppy", "Sqirrel", "Otter", "Bear", "Fox", "Girl", "Boy", "Bird", "Whale", "Penguin"];
    event NewEpicNFTMinted(address sender, uint256 tokenId, string image);

    modifier onlyOwner () {
       require(msg.sender == owner, "This can only be called by the contract owner!");
       _;
     }

    constructor() ERC721 ("CoolWordsNft", "CWN") {
        console.log("This is my NFT contract. Whoa!");
        owner = msg.sender;
    }
    /*function pickRandomFistWord(uint ) private{
        random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    }*/
    function getTotalNFTsMintedSoFar () public view returns (uint ){
        return _tokenIds.current();
    }

    function withdrawEth(uint amount ) onlyOwner public{
        require(amount <= address(this).balance, "This amount can't be withdraw");
        (bool succes, ) = (msg.sender).call{value: amount}("");
        require (succes, "Withdraw failed");
    }

    function makeAnEpicNFT() public payable{
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();
        require(newItemId < 111, "Exceeds token supply");
        console.log(msg.value);
        require( msg.value >= 0.01 ether, "Not enough ETH sent : check price");
        //get the ramdom
        uint seed = uint256(keccak256(abi.encodePacked(newItemId*(uint)(block.timestamp * block.difficulty)))) % 1000000;
        console.log(seed);
        string memory Nft = string(abi.encodePacked(firstWords[ seed%100%firstWords.length], secondWords[ seed/100%100%secondWords.length ],thirdWords[ seed/10000%100%thirdWords.length] ));
        string memory color = colors[seed%colors.length];
        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, Nft, "</text></svg>"));
        //log the Svg.
        console.log(finalSvg);
        console.log(color);

        // Get all the JSON metadata in place and base64 encode it.
        string memory sJson = string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        Nft,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                );
        string memory json = Base64.encode(bytes( sJson));

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
        nfts.push(NFT(msg.sender,newItemId,finalSvg ));
        _tokenIds.increment();

        //emit event nft minted
        emit NewEpicNFTMinted(msg.sender, newItemId, finalSvg);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
    function getAllNfts( ) public view returns (NFT [] memory){
        return nfts;
    }
    function getNft(uint id ) public view returns (NFT memory){
        return nfts [id];
    }
}
