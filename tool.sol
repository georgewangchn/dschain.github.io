pragma solidity ^0.4.24;
contract tool {
    
    function string2bytes32(string  source) view returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    function bytes322string(bytes32  b) view returns (string) {
       
       bytes memory names = new bytes(b.length);
       
       for(uint i = 0; i < b.length; i++) {
           
           names[i] = b[i];
       }
       return string(names);
   }
}





