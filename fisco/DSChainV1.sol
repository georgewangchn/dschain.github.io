pragma solidity ^0.4.25;

contract DSChainV1 {
    //链管理员
    address public admin;
    
    //声明一个数据服务商类型
    struct  DataService {
        string uscc; //数据服务公司营业执照编号
        string name; //数据服务公司名
        bool    is_datasource;//是否数据源
        bool    is_normal;//是否正常服务
    }
    
    //声明数据使用商户类型
    struct  Merchant{
        string uscc; //商户公司营业执照编号
        string name; //商户公司名
        string ca;
    }
    
    //数据服务商信息
    address[] public ds_addresses;
    mapping(address => DataService) public dataservices;
    
    //商户信息
    address[] public m_addresses;
    mapping(address => Merchant) public merchants;
    
    //密钥信息 数据服务商-商户-encryptedkey
    mapping(address => mapping(address => string)) public encryptedkeys;

    constructor() public {
        admin = msg.sender;
    }
    //--------------------管理服务商address-------------------------------
    function setDSAddress(address ds_address_) public{
        require(admin==msg.sender,"You are not admin,have no privilege");
        require(!isDSAddress(ds_address_),"The dataservice  address is existed");
        ds_addresses.push(ds_address_);
    }
    function getDSAddress(uint ds_id_) public view returns (address ds_address_){
        require(ds_id_ < ds_addresses.length,"outside the length");
        ds_address_ = ds_addresses[ds_id_];
    }
    function isDSAddress(address ds_address_)private view returns(bool is_set_){
        for(uint i=0;i<ds_addresses.length;i++){
            if(ds_addresses[i]==ds_address_)
                return true;
        }
        return false;
    }
    function getDSAddressCount() public view returns (uint count_){
        count_=ds_addresses.length;
    }
    
    //--------------------管理商户m_address-------------------------------
    function isDS() private view returns(bool is_ds_){
        for(uint i=0;i<ds_addresses.length;i++){
            if (msg.sender==ds_addresses[i]){
                return true;
            }
        }
        return false;
    }
    function setMAddress(address m_address_) public{
        require(admin==msg.sender || isDS() ,"You are not admin || DS,have no privilege to set merchant address。");
        require(!isMAddress(m_address_),"the merchant address is already seted");
        m_addresses.push(m_address_);
    }
    function getMAddress(uint m_id_) public view returns (address m_address_){
        require(m_id_ < m_addresses.length,"outside the length");
        m_address_ = m_addresses[m_id_];
    }
    function getMAddressCount() public view returns (uint count_){
        count_=m_addresses.length;
    }
    function isMAddress(address m_address_)private view returns(bool is_set_){
        for(uint i=0;i<m_addresses.length;i++){
            if(m_addresses[i]==m_address_)
                return true;
        }
        return false;
    }
    //--------------------管理服务商ds-------------------------------
    function setDS(address ds_address_,string uscc_,string name_,bool is_datasource_,bool is_normal_) public{
        require(admin==msg.sender,"You are not admin,have no privilege");
        require(isDSAddress(ds_address_),"Please set dataservice address first");
        dataservices[ds_address_]=DataService({uscc:uscc_,name:name_,is_datasource:is_datasource_,is_normal:is_normal_});
    }
    //管理员删除数据源
    function deleteDS(address ds_address_) public{
        require(admin==msg.sender || ds_address_ == msg.sender,"You are not admin or DS,have no privilege");
        delete dataservices[ds_address_];
    }
    function getDS(address ds_address_) public view 
        returns(string uscc_,string name_,bool is_datasource_,bool is_normal_){
      DataService memory ds_ = dataservices[ds_address_];
      uscc_=ds_.uscc;
      name_=ds_.name;
      is_datasource_=ds_.is_datasource;
      is_normal_=ds_.is_normal;
    }
//--------------------管理商户m-------------------------------
    function setM(address m_address_,string uscc_,string name_,string ca_) public{
        require(admin==msg.sender || isDS(),"You are not admin or DS,have no privilege");
        require(isMAddress(m_address_),"The merchant  address is not existed");
        merchants[m_address_]=Merchant({uscc:uscc_,name:name_,ca:ca_});
    }

    function deleteM(address m_address_) public{
        require(admin==msg.sender ||isDS(),"You are not admin or DS,have no privilege");
        delete merchants[m_address_];
    }
    function getM(address m_address_) public view 
        returns(string uscc_,string name_,string ca_){
      Merchant memory m_ = merchants[m_address_];
      uscc_=m_.uscc;
      name_=m_.name;
      ca_=m_.ca;
    }
     //--------------------管理密钥-------------------------------
    function setEKey(address ds_address_,address m_address_,string ekey_) public {
        require(ds_address_==msg.sender,"DS can only set encryptedkeys for itself");
        require(isDSAddress(ds_address_),"The dataservice  address is not existed");
        require(isMAddress(m_address_),"The merchant  address is not existed");
        encryptedkeys[ds_address_][m_address_]=ekey_;
    }
    function getEKey(address ds_address_,address m_address_) public returns(string ekey_) {
        ekey_=encryptedkeys[ds_address_][m_address_];
    }
}



