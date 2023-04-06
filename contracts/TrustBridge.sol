// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {CustomDataTypes} from "./libraries/CustomDataTypes.sol";

contract TrustBridge is ERC721URIStorage {
    mapping(uint => CustomDataTypes.NFT) public nfts;
    mapping(uint256 => CustomDataTypes.Review[]) public reviews;
    mapping(address => mapping(uint256 => bool)) private _hasCollected;
    mapping(address => mapping(uint256 => bool)) private _hasReviewed;

    event NFTCreated(
        uint id,
        uint fid,
        string sort,
        address owner,
        string cover,
        string multimedia,
        string title,
        string description
    );
    event NFTReviewed(
        uint nftId,
        uint reviewId,
        address reviewer,
        uint score,
        string description,
        string multimedia
    );
    event NFTCollected(uint nftId, address collector);

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("TrustBridge", "TSB") {
        _tokenIds.increment();
    }

    function createNFT(
        string memory _sort,
        string memory _coverURI,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) public {
        _mintNFT(0, _sort, _coverURI, _multimedia, _title, _description);
    }

    function _mintNFT(
        uint fid,
        string memory _sort,
        string memory _coverURI,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) private {
        uint256 nftCount = _tokenIds.current();
        nfts[nftCount] = CustomDataTypes.NFT(
            nftCount,
            fid,
            _sort,
            msg.sender,
            _coverURI,
            _multimedia,
            _title,
            _description,
            0,
            0,
            0
        );

        _mint(msg.sender, nftCount);
        _setTokenURI(nftCount, _multimedia);
        _tokenIds.increment();
        emit NFTCreated(
            nftCount,
            fid,
            _sort,
            msg.sender,
            _coverURI,
            _multimedia,
            _title,
            _description
        );
    }

    function reviewNFT(
        uint _nftId,
        uint _score,
        string memory _description,
        string memory _multimedia
    ) public {
        require(_exists(_nftId), "Invalid NFT id");
        require(_score >= 0 && _score <= 10, "Invalid score");

        uint256 score = _score;
        if (_hasReviewed[msg.sender][_nftId]) {
            score = 0;
        }

        if (score > 0) {
            nfts[_nftId].reviewCount++;
            nfts[_nftId].score =
                (nfts[_nftId].score + score) /
                nfts[_nftId].reviewCount;
        }

        _mintNFT(_nftId, "", "", _multimedia, "", _description);

        _hasReviewed[msg.sender][_nftId] = true;
        reviews[_nftId].push(
            CustomDataTypes.Review({
                nftId: _nftId,
                reviewId: _tokenIds.current(),
                reviewer: msg.sender,
                score: score,
                description: _description,
                multimedia: _multimedia
            })
        );

        emit NFTReviewed(
            _nftId,
            nfts[_nftId].reviewCount,
            msg.sender,
            score,
            _description,
            _multimedia
        );
    }

    function collectNFT(uint256 _nftId) public {
        require(_exists(_nftId), "NFT does not exist");
        require(!_hasCollected[msg.sender][_nftId], "NFT already collected");
        nfts[_nftId].reviewCount++;
        _hasCollected[msg.sender][_nftId] = true;
    }

    function getCollectionCount(uint256 _nftId) public view returns (uint256) {
        require(_exists(_nftId), "NFT does not exist");
        return nfts[_nftId].reviewCount;
    }
}
