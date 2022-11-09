/**
 * GrpInfoSoapStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

@SuppressWarnings("rawtypes")
public class GrpInfoSoapStub extends org.apache.axis.client.Stub implements org.tempuri.GrpInfoSoap {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
	private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[11];
        _initOperationDesc1();
        _initOperationDesc2();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GrpLogon");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpCD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpPW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sUserCD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sUserPW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sIP"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sMachineName"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sOSVersion"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "bSetupVerDownloaderCheck"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sSetupVerDownloader"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>GrpLogonResponse>GrpLogonResult"));
        oper.setReturnClass(org.tempuri.GrpLogonResponseGrpLogonResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "GrpLogonResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GrpInfo_S");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpCD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpPW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpDatePW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>GrpInfo_SResponse>GrpInfo_SResult"));
        oper.setReturnClass(org.tempuri.GrpInfo_SResponseGrpInfo_SResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "GrpInfo_SResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetMsgVideoConferenceUserInfo");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>GetMsgVideoConferenceUserInfoResponse>GetMsgVideoConferenceUserInfoResult"));
        oper.setReturnClass(org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "GetMsgVideoConferenceUserInfoResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GRP_CDB");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpCD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpPW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGrpDatePW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sDBIP"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sDBNM"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sDBManUserID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sDBManUserPW"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sWWWRoot"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sUploadPathAbsolute"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "GRP_CDBResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("Grp_USetup");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sVerupVer"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_USetupResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("Grp_MGWSetup");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sVerupVer"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        oper.setReturnClass(int.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_MGWSetupResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("WS_GRP_RealUserUpdate");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateResponse>WS_GRP_RealUserUpdateResult"));
        oper.setReturnClass(org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdateResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[6] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("WS_GRP_RealUserUpdate2");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealMailUserCnt"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdate2Response>WS_GRP_RealUserUpdate2Result"));
        oper.setReturnClass(org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdate2Result"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[7] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("WS_GRP_RealUserUpdateAlpha");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGRP_CD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nRealMailUserCnt"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateAlphaResponse>WS_GRP_RealUserUpdateAlphaResult"));
        oper.setReturnClass(org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdateAlphaResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[8] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("WS_HELPDESK_USER_INSERT");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGRP_ID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sGRP_CD"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sLOGIN_ID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "sUSER_NM"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(org.apache.axis.encoding.XMLType.AXIS_VOID);
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[9] = oper;

    }

    private static void _initOperationDesc2(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("WS_GRP_GetTagFreeLicenseKey");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_GetTagFreeLicenseKeyResponse>WS_GRP_GetTagFreeLicenseKeyResult"));
        oper.setReturnClass(org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_GetTagFreeLicenseKeyResult"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[10] = oper;

    }

    public GrpInfoSoapStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public GrpInfoSoapStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    @SuppressWarnings({ "unchecked" })
	public GrpInfoSoapStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            //javax.xml.namespace.QName qName2;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            
            /*
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            */
            
            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>GetMsgVideoConferenceUserInfoResponse>GetMsgVideoConferenceUserInfoResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>GrpInfo_SResponse>GrpInfo_SResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GrpInfo_SResponseGrpInfo_SResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>GrpLogonResponse>GrpLogonResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GrpLogonResponseGrpLogonResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_GetTagFreeLicenseKeyResponse>WS_GRP_GetTagFreeLicenseKeyResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdate2Response>WS_GRP_RealUserUpdate2Result");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateAlphaResponse>WS_GRP_RealUserUpdateAlphaResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateResponse>WS_GRP_RealUserUpdateResult");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GetMsgVideoConferenceUserInfo");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GetMsgVideoConferenceUserInfo.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GetMsgVideoConferenceUserInfoResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GetMsgVideoConferenceUserInfoResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GRP_CDB");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GRP_CDB.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GRP_CDBResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GRP_CDBResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_MGWSetup");
            cachedSerQNames.add(qName);
            cls = org.tempuri.Grp_MGWSetup.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_MGWSetupResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.Grp_MGWSetupResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_USetup");
            cachedSerQNames.add(qName);
            cls = org.tempuri.Grp_USetup.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_USetupResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.Grp_USetupResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GrpInfo_S");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GrpInfo_S.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">GrpInfo_SResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.GrpInfo_SResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_GetTagFreeLicenseKey");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_GetTagFreeLicenseKey.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_GetTagFreeLicenseKeyResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdate");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdate.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdate2");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdate2.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdate2Response");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdate2Response.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateAlpha");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdateAlpha.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateAlphaResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdateAlphaResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_GRP_RealUserUpdateResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_HELPDESK_USER_INSERT");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_HELPDESK_USER_INSERT.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", ">WS_HELPDESK_USER_INSERTResponse");
            cachedSerQNames.add(qName);
            cls = org.tempuri.WS_HELPDESK_USER_INSERTResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    protected org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call call = super._createCall();
            if (super.maintainSessionSet) {
            	call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
            	call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
            	call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
            	call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
            	call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
            	call.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                call.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                	call.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Object x = cachedSerFactories.get(i);
                        if (x instanceof Class) {
                            java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                            java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                            call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                        else if (x instanceof javax.xml.rpc.encoding.SerializerFactory) {
                            org.apache.axis.encoding.SerializerFactory sf = (org.apache.axis.encoding.SerializerFactory)
                                 cachedSerFactories.get(i);
                            org.apache.axis.encoding.DeserializerFactory df = (org.apache.axis.encoding.DeserializerFactory)
                                 cachedDeserFactories.get(i);
                            call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                    }
                }
            }
            return call;
        }
        catch (java.lang.Throwable t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", t);
        }
    }

    public org.tempuri.GrpLogonResponseGrpLogonResult grpLogon(java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sUserCD, java.lang.String sUserPW, java.lang.String sIP, java.lang.String sMachineName, java.lang.String sOSVersion, boolean bSetupVerDownloaderCheck, java.lang.String sSetupVerDownloader) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[0]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/GrpLogon");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "GrpLogon"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {sGrpCD, sGrpPW, sUserCD, sUserPW, sIP, sMachineName, sOSVersion, new java.lang.Boolean(bSetupVerDownloaderCheck), sSetupVerDownloader});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.GrpLogonResponseGrpLogonResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.GrpLogonResponseGrpLogonResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.GrpLogonResponseGrpLogonResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfo_S(int nGrpID, java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sGrpDatePW) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[1]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/GrpInfo_S");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "GrpInfo_S"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), sGrpCD, sGrpPW, sGrpDatePW});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.GrpInfo_SResponseGrpInfo_SResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.GrpInfo_SResponseGrpInfo_SResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.GrpInfo_SResponseGrpInfo_SResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfo(int nGrpID) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[2]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/GetMsgVideoConferenceUserInfo");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "GetMsgVideoConferenceUserInfo"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public int GRP_CDB(int nGrpID, java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sGrpDatePW, java.lang.String sDBIP, java.lang.String sDBNM, java.lang.String sDBManUserID, java.lang.String sDBManUserPW, java.lang.String sWWWRoot, java.lang.String sUploadPathAbsolute) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[3]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/GRP_CDB");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "GRP_CDB"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), sGrpCD, sGrpPW, sGrpDatePW, sDBIP, sDBNM, sDBManUserID, sDBManUserPW, sWWWRoot, sUploadPathAbsolute});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return ((java.lang.Integer) resp).intValue();
            } catch (java.lang.Exception exception) {
                return ((java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(resp, int.class)).intValue();
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public int grp_USetup(int nGrpID, java.lang.String sVerupVer, int nRealUserCNT) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[4]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/Grp_USetup");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_USetup"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), sVerupVer, new java.lang.Integer(nRealUserCNT)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return ((java.lang.Integer) resp).intValue();
            } catch (java.lang.Exception exception) {
                return ((java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(resp, int.class)).intValue();
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public int grp_MGWSetup(int nGrpID, java.lang.String sVerupVer, int nRealUserCNT) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[5]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/Grp_MGWSetup");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_MGWSetup"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), sVerupVer, new java.lang.Integer(nRealUserCNT)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return ((java.lang.Integer) resp).intValue();
            } catch (java.lang.Exception exception) {
                return ((java.lang.Integer) org.apache.axis.utils.JavaUtils.convert(resp, int.class)).intValue();
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult WS_GRP_RealUserUpdate(int nGrpID, int nRealUserCNT) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[6]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/WS_GRP_RealUserUpdate");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdate"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), new java.lang.Integer(nRealUserCNT)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result WS_GRP_RealUserUpdate2(int nGrpID, int nRealUserCNT, int nRealMailUserCnt) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[7]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/WS_GRP_RealUserUpdate2");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdate2"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID), new java.lang.Integer(nRealUserCNT), new java.lang.Integer(nRealMailUserCnt)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult WS_GRP_RealUserUpdateAlpha(java.lang.String sGRPCD, int nRealUserCNT, int nRealMailUserCnt) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[8]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/WS_GRP_RealUserUpdateAlpha");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdateAlpha"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {sGRPCD, new java.lang.Integer(nRealUserCNT), new java.lang.Integer(nRealMailUserCnt)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public void WS_HELPDESK_USER_INSERT(int nGRPID, java.lang.String sGRPCD, java.lang.String sLOGINID, java.lang.String sUSERNM) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[9]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/WS_HELPDESK_USER_INSERT");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_HELPDESK_USER_INSERT"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGRPID), sGRPCD, sLOGINID, sUSERNM});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        extractAttachments(call);
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult WS_GRP_GetTagFreeLicenseKey(int nGrpID) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call call = createCall();
        call.setOperation(_operations[10]);
        call.setUseSOAPAction(true);
        call.setSOAPActionURI("http://tempuri.org/WS_GRP_GetTagFreeLicenseKey");
        call.setEncodingStyle(null);
        call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        call.setOperationName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_GetTagFreeLicenseKey"));

        setRequestHeaders(call);
        setAttachments(call);
 try {        java.lang.Object resp = call.invoke(new java.lang.Object[] {new java.lang.Integer(nGrpID)});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(call);
            try {
                return (org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult) resp;
            } catch (java.lang.Exception exception) {
                return (org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult) org.apache.axis.utils.JavaUtils.convert(resp, org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

}
