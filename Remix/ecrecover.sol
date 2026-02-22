// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureVerifier {
    // 验证签名
    function verify(
        address _signer,
        string memory _message,
        bytes memory _signature
    ) public pure returns (bool) {
        // 1. 对消息进行哈希
        bytes32 messageHash = keccak256(abi.encodePacked(_message));

        // 2. 添加以太坊签名前缀
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // 3. 从签名中恢复地址
        address recoveredSigner = recoverSigner(ethSignedMessageHash, _signature);

        // 4. 比较地址
        return recoveredSigner == _signer;
    }

    // 添加以太坊签名前缀
    function getEthSignedMessageHash(bytes32 _messageHash)
        public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
        ));
    }

    // 从签名中恢复签名者地址
    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    // 将签名拆分为 r, s, v
    function splitSignature(bytes memory sig)
        public pure returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "Invalid signature length");

        assembly {
            // 前 32 字节是长度，跳过
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
