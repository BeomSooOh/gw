/*
 * Copyright 김성중 by Duzon Newturns.,
 * All rights reserved.
 */
package neos.cmm.exp;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.exp
 * 2. Class Name	: CustException.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 1. 5.     김성중       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@SuppressWarnings("serial")
public class CustException extends Exception
{
    private String status   = null;
    private String message  = null;
    private Object obj      = null;

    public CustException()
    {
        super();
    }

    public CustException(String errorCode) 
    {
        super(errorCode);
    }

    public CustException(String errorCode, Object obj) 
    {
        super(errorCode);
        setObj(obj);
    }

    public CustException(String errorCode, Object obj, String message) 
    {
        super(errorCode);
        setObj(obj);
        setMessage(message);
    }

    public CustException(String errorCode, Object obj, String message, String status) 
    {
        super(errorCode);
        setObj(obj);
        setMessage(message);
        setStatus(status);
    }

    public Object getObj()
    {
        return obj;
    }

    public void setObj(Object obj)
    {
        this.obj = obj;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getMessage()
    {
        return message;
    }

    public void setMessage(String message)
    {
        this.message = message;
    }
}


