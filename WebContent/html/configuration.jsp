<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ include file="init.jsp" %>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<p>The field should separated by , </p>
<aui:form action="<%= configurationURL %>" method="post" name="fm">
    <aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="preferences--foldersKey--" label="Folder List" type="text" required="true" value="<%= folders_cfg %>" style="width: 100%;"/>
	
	<aui:input name="preferences--vendorKey--" label="Vendor list" type="textarea" value="<%= vendor_cfg %>" style="width: 100%;"/>
	<aui:input name="preferences--technologyKey--" label="Technology list" type="textarea" value="<%= technology_cfg %>" style="width: 100%;"/>
	<aui:input name="preferences--productTypeKey--" label="Product Type list" type="textarea" value="<%= productType_cfg %>" style="width: 100%;"/>
	<aui:input name="preferences--flashTypeKey--" label="Flash Type list" type="textarea" value="<%= flashType_cfg %>" style="width: 100%;"/>

    <aui:button-row>
        <aui:button type="submit" />
    </aui:button-row>
</aui:form>