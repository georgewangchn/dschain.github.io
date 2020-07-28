pragma solidity ^0.4.24;
import "./chain.sol";
import "./tool.sol";
contract dschain is chain,tool{
    constructor() public {
        admin = msg.sender;
    }

    function setDSAddress(address ds_address_) public{
        require(admin==msg.sender,"You are not admin,have no privilege");
        require(!isDSAddress(ds_address_),"The dataservice  address is existed");
        ds_addresses.push(ds_address_);
    }
    function getDSAddress(uint ds_id_) public view returns (address ds_address_){
        require(ds_id_ < ds_addresses.length,"outside the length");
        ds_address_ = ds_addresses[ds_id_];
    }
    function isDSAddress(address ds_address_) public view returns(bool is_set_){
        for(uint i=0;i<ds_addresses.length;i++){
            if(ds_addresses[i]==ds_address_)
                return true;
        }
        return false;
    }
    function findDSAddressIndex(address ds_address_) public view returns(uint index_){
        for(uint i=0;i<ds_addresses.length;i++){
            if(ds_addresses[i]==ds_address_)
                return i;
        }
        return ds_addresses.length;
    }
    function getDSAddressCount() public view returns (uint count_){
        count_=ds_addresses.length;
    }
    function deleteDSAddress(address ds_address_) public {
        require(admin==msg.sender,"You are not admin,have no privilege");
        uint index_=findDSAddressIndex(ds_address_);
        require(index_<ds_addresses.length,"The dataservice  address is not existed");
        delete ds_addresses[index_];
    }
    
    //--------------------管理服务商ds-------------------------------
    function setDS(address ds_address_,string uscc_,string name_,bool is_source_,bool is_service_) public{
        require(ds_address_==msg.sender || admin==msg.sender ,"You have no privilege");
        require(isDSAddress(ds_address_),"Please set dataservice address first");
        dataservices[ds_address_]=DataService({uscc:uscc_,name:name_,is_source:is_source_,is_service:is_service_});
        emit SET_DS(msg.sender, ds_address_,uscc_,name_,is_source_,is_service_);
    }
    function getDS(address ds_address_) public view 
        returns(string uscc_,string name_,bool is_source_,bool is_service_){
      DataService memory ds_ = dataservices[ds_address_];
      uscc_=ds_.uscc;
      name_=ds_.name;
      is_source_=ds_.is_source;
      is_service_=ds_.is_service;
    }
    
    
     function setMUscc(string m_uscc_) public{
        require(admin==msg.sender || isDS() ,"You are not admin || DS,have no privilege to set merchant uscc");
        bytes32  temp_m_uscc_ = tool.string2bytes32(m_uscc_);
        require(!isMUscc(temp_m_uscc_),"the merchant uscc is already seted");
        
        m_usccs.push(temp_m_uscc_);
    }
    function getMUscc(uint id_) public view returns (string m_uscc_){
        require(id_ < m_usccs.length,"outside the length");
        m_uscc_ = tool.bytes322string(m_usccs[id_]);
    }
    function getMUsccCount() public view returns (uint count_){
        count_=m_usccs.length;
    }
    function isMUscc(bytes32 m_uscc_)public view returns(bool is_set_){
        for(uint i=0;i<m_usccs.length;i++){
            if(m_usccs[i]==m_uscc_)
                return true;
        }
        return false;
    }
    function isDS() public view returns(bool is_ds_){
        for(uint i=0;i<ds_addresses.length;i++){
            if (msg.sender==ds_addresses[i]){
                return true;
            }
        }
        return false;
    }
//--------------------管理商户m-------------------------------
    function setM(string uscc_,string name_,string home_,string ca_) public{
        require(admin==msg.sender || isDS(),"You are not admin or DS,have no privilege");
        bytes32 temp_m_uscc_ = tool.string2bytes32(uscc_);
        require(isMUscc(temp_m_uscc_),"The merchant uscc is not existed");
        uint  counting_ = merchants[temp_m_uscc_].counting+1;
        
        merchants[temp_m_uscc_]=Merchant({uscc:uscc_,name:name_,home:home_,ca:ca_,counting:counting_});
        emit SET_M(msg.sender,uscc_, name_, home_, ca_,counting_);
    }

    function getM(string m_uscc_) public view returns(string uscc_,string name_,string home_,string ca_,uint counting_){
      bytes32 temp_m_uscc_ = tool.string2bytes32(m_uscc_);
      Merchant memory m_ = merchants[temp_m_uscc_];
      uscc_=m_.uscc;
      name_=m_.name;
      home_=m_.home;
      ca_=m_.ca;
      counting_=m_.counting;
    }
    
    function setEKey(address ds_address_,string m_uscc_,string ekey_) public {
        require(ds_address_==msg.sender,"DS can only set encryptedkeys for itself");
        require(isDSAddress(ds_address_),"The dataservice  address is not existed");
        bytes32 temp_m_uscc_ = tool.string2bytes32(m_uscc_);
        require(isMUscc(temp_m_uscc_),"The merchant  uscc is not existed");
        
        ekeys[ds_address_][temp_m_uscc_]=ekey_;
        emit SET_EKEY(msg.sender,m_uscc_,ekey_);
    }
    function getEKey(address ds_address_,string m_uscc_) public view returns(string ekey_) {
        bytes32 temp_m_uscc_ = tool.string2bytes32(m_uscc_);
        ekey_=ekeys[ds_address_][temp_m_uscc_];
    }
}
