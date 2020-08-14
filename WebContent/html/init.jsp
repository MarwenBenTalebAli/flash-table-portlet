
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Collections"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<%@page import="org.json.JSONObject"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntryMetadata"%>
<%@page import="com.liferay.portlet.dynamicdatamapping.model.DDMStructure"%>
<%@page import="com.liferay.portlet.dynamicdatamapping.storage.Fields"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portlet.documentlibrary.model.DLFileEntry"%>
<%@page import="java.util.List"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.dao.search.SearchContainer"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil" %>
<portlet:defineObjects />
<liferay-theme:defineObjects />

<%  
	String vendor_cfg = GetterUtil.getString(portletPreferences.getValue("vendorKey", "Brother,Canon,Dell,Epson,HP,Kodak,Konica,Kyocera,Lexmark,Oki,Other,Ricoh,Samsung,Xerox"));
	String technology_cfg = GetterUtil.getString(portletPreferences.getValue("technologyKey", "Inkjet,Laser"));
	String productType_cfg = GetterUtil.getString(portletPreferences.getValue("productTypeKey", "Consumables,MFP,SFP"));
	String flashType_cfg = GetterUtil.getString(portletPreferences.getValue("flashTypeKey", "Erratum,New Product,Other,Price Change"));
	String folders_cfg = GetterUtil.getString(portletPreferences.getValue("foldersKey", "CONTEXT Flash"));
			
	List<String> listVendor =  Collections.unmodifiableList(Arrays.asList(portletPreferences.getValue("vendorKey", "").split(",")));
	List<String> listTechnology =  Collections.unmodifiableList(Arrays.asList(portletPreferences.getValue("technologyKey", "").split(",")));
	List<String> listProductType = Collections.unmodifiableList(Arrays.asList(portletPreferences.getValue("productTypeKey", "").split(",")));
	List<String> listFlashType = Collections.unmodifiableList(Arrays.asList(portletPreferences.getValue("flashTypeKey", "").split(",")));
	
%>