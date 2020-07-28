pragma solidity ^0.4.24;
contract chain {
    /**链管理员**/
    address public admin;
    
    /**声明一个数据服务商类型
     * uscc:            数据服务公司营业执照编号
     * name:            数据服务公司名
     * is_source:      是否数据源头
     * is_service：      是否在提供服务
    **/
    struct  DataService {
        string  uscc; 
        string  name; 
        bool    is_source;
        bool    is_service;
    }
    
    /**数据服务商地址数组**/
    address[] public ds_addresses;
    /**数据服务商信息列表**/
    mapping(address => DataService) public dataservices;
    
    /**声明商户信息数据结构
     * name:        商户公司名
     * home:        商户门户网站 https://www.****.com/
     * ca:          商户在第三方申请的公钥证书
     * counting：   自增计数器默认0，每修改一次ca，则counting+1
    **/
    struct  Merchant{
        string uscc;
        string name;     
        string home;     
        string ca;       
        uint   counting; 
    }
    
    /**商户统一社会信用代码
     * m_usccs 数组存放商户公司的统一社会信用代码
    **/
    bytes32[] public m_usccs;
    mapping(bytes32 => Merchant) public merchants;
    
    /**脱敏密钥信息encryptedkeys
     * dataservice address => (merchant uscc => ekeys)
    **/
    mapping(address => mapping(bytes32 => string)) public ekeys;
    
    
    /**定义事件**/
    event SET_DS(address indexed user_address_, address indexed ds_address_,string uscc_,string name_,bool is_source_,bool is_service);
    event SET_M(address indexed user_address_, string indexed uscc_,string name_,string home_,string ca_,uint counting_);
    event SET_EKEY(address indexed user_address_,string indexed m_uscc_,string ekey_);
    /*定义接口*/
    function setDS(address ds_address_,string uscc_,string name_,bool is_source_,bool is_service_) public;
    function getDS(address ds_address_) public view returns(string uscc_,string name_,bool is_source_,bool is_service_);
    function setDSAddress(address ds_address_) public;
    function getDSAddress(uint ds_id_) public view returns (address ds_address_);
    function getDSAddressCount() public view returns (uint count_);
    function deleteDSAddress(address ds_address_) public;
    
    
    function setM(string uscc_,string name_,string home_,string ca_) public;
    function getM(string m_uscc_) public view returns(string uscc_,string name_,string home_,string ca_,uint counting_);
    function setMUscc(string m_uscc_) public;
    function getMUscc(uint id_) public view returns (string m_uscc_);
    function getMUsccCount() public view returns (uint count_);
    
    function setEKey(address ds_address_,string m_uscc_,string ekey_) public;
    function getEKey(address ds_address_,string m_uscc_) public view returns(string ekey_);
}





