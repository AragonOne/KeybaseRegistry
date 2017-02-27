pragma solidity ^0.4.8;

import "./KeybaseRegistry.sol";

contract KeybaseResolver is KeybaseRegistry {
  function KeybaseResolver(bytes32 _namehash, string _suffix, bool _isLegacySignature)
           KeybaseRegistry(_suffix, _isLegacySignature) {
    namehash = _namehash;
  }

  function supportsInterface(bytes4 interfaceID) constant returns (bool) {
    return interfaceID == 0x3b3b57de || interfaceID == 0x691f3431;
  }

  function addr(bytes32 node) constant returns (address) {
    return resolverAddresses[node];
  }

  function name(bytes32 node) constant returns (string) {
    return resolverNames[node];
  }

  function processSuccessfulRequest(KeybaseRegistry.RegisterRequest request) internal {
    super.processSuccessfulRequest(request);
    bytes32 addressNode = sha3(namehash, request.username);
    bytes32 nodeName = sha3(namehash, request.requester);

    resolverAddresses[addressNode] = request.requester;
    resolverNames[nodeName] = request.username;

    AddrChanged(addressNode, request.requester);
    NameChanged(nodeName, request.username);
  }

  bytes32 namehash;
  mapping (bytes32 => address) resolverAddresses;
  mapping (bytes32 => string) resolverNames;

  event AddrChanged(bytes32 indexed node, address a);
  event NameChanged(bytes32 indexed node, string n);
}
