// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 * @title CustomDataTypes
 * @author Trust Bridge Protocol
 *
 * @notice A standard library of data types used throughout the Trust Bridge Protocol.
 */
library CustomDataTypes {
    struct NFT {
        uint id;
        uint fid;
        string sort;
        address owner;
        string coverURI;
        string mediaType;
        string multimedia;
        string title;
        string description;
        uint reviewCount;
        uint score;
        uint collectCount;
    }

    struct Review {
        uint nftId;
        uint reviewId;
        address reviewer;
        uint score;
        string description;
        string multimedia;
    }
}
