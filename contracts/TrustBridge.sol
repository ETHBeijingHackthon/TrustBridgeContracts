// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import {CustomDataTypes} from "./libraries/CustomDataTypes.sol";

contract TrustBridge is ERC721URIStorageUpgradeable {
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
        string mediaType,
        string multimedia,
        string title,
        string description
    );
    event NFTReviewed(
        uint nftId,
        uint reviewId,
        uint reviewCount,
        uint nftScore,
        address reviewer,
        uint score,
        string description,
        string mediaType,
        string multimedia
    );
    event NFTCollected(uint nftId, address collector, uint NFTCollected);

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    function initialize() public initializer {
        __ERC721_init("TrustBridge", "TSB");
    }

    function createNFT(
        string memory _sort,
        string memory _coverURI,
        string memory _mediaType,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) public {
        _mintNFT(
            0,
            _sort,
            _coverURI,
            _mediaType,
            _multimedia,
            _title,
            _description
        );
    }

    // return the minted NFT ID
    function _mintNFT(
        uint fid,
        string memory _sort,
        string memory _coverURI,
        string memory _mediaType,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) private returns (uint256) {
        uint256 nftCount = _tokenIds.current();
        nfts[nftCount] = CustomDataTypes.NFT(
            nftCount,
            fid,
            _sort,
            msg.sender,
            _coverURI,
            _mediaType,
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
            _mediaType,
            _multimedia,
            _title,
            _description
        );
        return nftCount;
    }

    function reviewNFT(
        uint _nftId,
        uint _score,
        string memory _description,
        string memory _mediaType,
        string memory _multimedia
    ) public {
        require(_exists(_nftId), "Invalid NFT id");
        require(_score >= 0 && _score <= 10, "Invalid score");

        uint256 score = _score;
        if (_hasReviewed[msg.sender][_nftId]) {
            score = 0;
        }

        if (score > 0) {
            // Calculate the avarage score
            nfts[_nftId].score =
                (nfts[_nftId].score * nfts[_nftId].reviewCount + score) /
                (nfts[_nftId].reviewCount + 1);

            nfts[_nftId].reviewCount++;
        }

        uint256 reviewId = _mintNFT(
            _nftId,
            "",
            "",
            _mediaType,
            _multimedia,
            "",
            _description
        );

        _hasReviewed[msg.sender][_nftId] = true;
        reviews[_nftId].push(
            CustomDataTypes.Review({
                nftId: _nftId,
                reviewId: reviewId,
                reviewer: msg.sender,
                score: score,
                description: _description,
                multimedia: _multimedia
            })
        );

        emit NFTReviewed(
            _nftId,
            reviewId,
            nfts[_nftId].reviewCount,
            nfts[_nftId].score,
            msg.sender,
            score,
            _description,
            _mediaType,
            _multimedia
        );
    }

    function collectNFT(uint256 _nftId) public {
        require(_exists(_nftId), "NFT does not exist");
        require(!_hasCollected[msg.sender][_nftId], "NFT already collected");
        require(_ownerOf(_nftId) != msg.sender, "Can't collect self nft");

        nfts[_nftId].collectCount++;
        _hasCollected[msg.sender][_nftId] = true;

        emit NFTCollected(_nftId, msg.sender, nfts[_nftId].collectCount);
    }

    function getCollectionCount(uint256 _nftId) public view returns (uint256) {
        require(_exists(_nftId), "NFT does not exist");
        return nfts[_nftId].reviewCount;
    }
}
