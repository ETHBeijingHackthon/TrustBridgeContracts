// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TrustBridge is ERC721URIStorage {
    struct NFT {
        uint id;
        uint fid;
        address owner;
        string coverURI;
        string multimedia;
        string title;
        string description;
        uint reviewCount;
        uint score;
        uint collectCount;
        // mapping(uint => Review) reviews;
    }

    struct Review {
        uint nftId;
        uint reviewId;
        address reviewer;
        uint score;
        string description;
        string multimedia;
    }

    mapping(uint => NFT) public nfts;
    mapping(uint256 => Review[]) public reviews;

    event NFTCreated(
        uint id,
        uint fid,
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

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("TrustBridge", "TSB") {
        _tokenIds.increment();
    }

    function createNFT(
        string memory _coverURI,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) public {
        _mintNFT(0, _coverURI, _multimedia, _title, _description);
    }

    function _mintNFT(
        uint fid,
        string memory _coverURI,
        string memory _multimedia,
        string memory _title,
        string memory _description
    ) private {
        uint256 nftCount = _tokenIds.current();
        nfts[nftCount] = NFT(
            nftCount,
            fid,
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
        uint256 nftCount = _tokenIds.current();
        require(_nftId > 0 && _nftId < nftCount, "Invalid NFT id");
        require(_score > 0 && _score <= 10, "Invalid score");
        nfts[_nftId].reviewCount++;
        nfts[_nftId].score =
            (nfts[_nftId].score + _score) /
            nfts[_nftId].reviewCount;

        _mintNFT(_nftId, "", _multimedia, "", _description);

        reviews[_nftId].push(
            Review({
                nftId: _nftId,
                reviewId: _tokenIds.current(),
                reviewer: msg.sender,
                score: _score,
                description: _description,
                multimedia: _multimedia
            })
        );

        emit NFTReviewed(
            _nftId,
            nfts[_nftId].reviewCount,
            msg.sender,
            _score,
            _description,
            _multimedia
        );
    }
}
