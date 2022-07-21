// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Echo {
    using Counters for Counters.Counter;
    Counters.Counter private _trackIdTracker;

    uint STREAMPRICE = 2;

    mapping(uint256 => uint256) private _fingerprintToInternalID; // maps fingerprint to internalID
    mapping(uint256 => MetadataStruct) private _metadata; // maps InternalId to metadata
    mapping(uint256 => bytes32) private _internalDirectory; // maps internalId to CID
    mapping(bytes32 => bool) private _cidInLibrary;

    struct MetadataStruct {
        bytes32 title;
        bytes32 artist;
        address payable uploader;
    }

    constructor () {
        _trackIdTracker.reset();
        _trackIdTracker.increment(); // start with 1, 0 in mapping means doesn't exist
    }

    // returns 0 for success
    // returns 1 for error - CID in library already
    // returns 2 for error - fingerprint equivalent track in library already
    function uploadTrack (
        bytes32 _hash, bytes32 title, bytes32 artist
    ) public returns (uint8)
    {
        // first check if that CID already exists in our library
        if (_cidInLibrary[_hash]) {
            return 1;
        }

        // make call to fingerprinting to test if that works
        uint256 fingerprint = _callFingerprinting(_hash);

        if (_fingerprintToInternalID[fingerprint] != 0) {
            return 2;
        }

        // we are safe to add this track to our library
        uint256 id = _trackIdTracker.current();
        _trackIdTracker.increment();
        _fingerprintToInternalID[fingerprint] = id;
        _metadata[id] = MetadataStruct(title, artist, payable(msg.sender));
        _internalDirectory[id] = _hash;
        _cidInLibrary[_hash] = true;

        return 0; // success
    }

    function getNumTracks() public view returns (uint256) {
        return _trackIdTracker.current();
    }

    function _callFingerprinting(bytes32 cid) private pure returns (uint256) {
        return uint256(cid); // TODO - implement Fluence call
    }

    function getMetadata(uint256 _internalId) public view returns (bytes32[2] memory retval) {
        require(_metadataExists(_internalId));

        // assume the metadata exists
        retval[0] = _metadata[_internalId].title;
        retval[1] = _metadata[_internalId].artist;
    }

    function payForCID (uint256 _internalId) public payable returns (bytes32) {
        require(msg.value == STREAMPRICE,"Please send precise amount");
        require(_internalDirectory[_internalId]!=0); // make sure internal id is valid
        require(_metadataExists(_internalId)); // make sure we have metadata
        (bool success, ) = _metadata[_internalId].uploader.call{value:getPrice(_internalId)}("");
        require(success, "Transfer failed.");
        return _internalDirectory[_internalId];
    }


    function getPrice(uint256 _internalId) public view returns (uint) {
        require(_internalId!=0); // really only to silence warning, can be changed later
        return STREAMPRICE; //TODO - perhaps make this more sophisticated later
    }


    function _metadataExists(uint256 _internalId) private view returns (bool) {
        return (
            _metadata[_internalId].title  != 0 ||
            _metadata[_internalId].artist != 0 ||
            _metadata[_internalId].uploader != address(0)
        );
    }
}