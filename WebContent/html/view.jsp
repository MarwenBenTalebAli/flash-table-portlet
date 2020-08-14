<%@page import="com.context.portlet.util.CustomComparatorUtil"%>
<%@page import="com.liferay.portlet.PortletPreferencesFactoryUtil"%>
<%@page import="com.liferay.portlet.PortalPreferences"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="com.liferay.portal.kernel.repository.model.FileEntry"%>
<%@page
	import="com.liferay.portlet.documentlibrary.service.DLAppServiceUtil"%>
<%@page import="com.liferay.portal.kernel.repository.model.FileVersion"%>
<%@page import="com.liferay.portlet.documentlibrary.util.DLUtil"%>
<%@page import="com.liferay.portlet.asset.model.AssetEntry"%>
<%@page
	import="com.liferay.portal.kernel.util.OrderByComparatorFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.util.OrderByComparator"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@ include file="init.jsp"%>
<portlet:renderURL var="renderUrl" />
<portlet:renderURL var="searchFilterURL" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>

<aui:form action="${searchFilterURL}" method="post" name="fm">
	<table class="filters">
		<tr>
			<td class="width-filter-1">&nbsp;</td>
			<td class="width-filter-16">
				<aui:select name="dateFilter" label="" cssClass="filter-text-size">
					<aui:option label="All" value="all"
						selected="${dateFilter =='all'? 'true' : 'false' }"></aui:option>
					<c:forEach items="${listDate}" var="date">
						<aui:option label="${date }" value="${date }"
							selected="${dateFilter == date? 'true' : 'false' }"></aui:option>
					</c:forEach>
				</aui:select></td>
			<td class="width-filter-15"><aui:select name="vendorFilter" label="" cssClass="filter-text-size">
					<aui:option label="All" value="all"
						selected="${vendorFilter =='all'? 'true' : 'false' }"></aui:option>
					<c:forEach items="<%=listVendor%>" var="vendor">
						<aui:option label="${vendor }" value="${vendor }"
							selected="${vendorFilter == vendor? 'true' : 'false' }"></aui:option>
					</c:forEach>
				</aui:select></td>
			<td class="width-filter-16"><aui:select name="technologyFilter" cssClass="filter-text-size"
					label="">
					<aui:option label="All" value="all"
						selected="${technologyFilter =='all'? 'true' : 'false' }"></aui:option>
					<c:forEach items="<%=listTechnology%>" var="technology">
						<aui:option label="${technology }" value="${technology }"
							selected="${technologyFilter == technology? 'true' : 'false' }"></aui:option>
					</c:forEach>
				</aui:select></td>
			<td class="width-filter-16"><aui:select name="productTypeFilter" cssClass="filter-text-size"
					label="">
					<aui:option label="All" value="all"
						selected="${productTypeFilter =='all'? 'true' : 'false' }"></aui:option>
					<c:forEach items="<%=listProductType%>" var="productType">
						<aui:option label="${productType }" value="${productType }"
							selected="${productTypeFilter == productType? 'true' : 'false' }"></aui:option>
					</c:forEach>
				</aui:select></td>
			<td class="width-filter-16"><aui:select name="flashTypeFilter" label="" cssClass="filter-text-size">
					<aui:option label="All" value="all"
						selected="${flashTypeFilter =='all'? 'true' : 'false' }"></aui:option>
					<c:forEach items="<%=listFlashType%>" var="flashType">
						<aui:option label="${flashType }" value="${flashType }"
							selected="${flashTypeFilter == flashType? 'true' : 'false' }"></aui:option>
					</c:forEach>
				</aui:select></td>
			<td colspan="3" class="li-search">
				<aui:input name="searchKey" cssClass="filter-text-size"
					placeholder="search" label="" value="${searchKey}"></aui:input> 
				<aui:input
					name="submit" type="submit" label="" cssClass="search"></aui:input>
			</td>
		</tr>
	</table>
</aui:form>
<br />

<c:choose>
	<c:when test="${fn:length(listFiles) gt 0}">
		<div class="lfr-search-container " id="flash-table">
			<form action="#" id="download_form">
				<% 
				PortletURL actionURL = renderResponse.createRenderURL();
				DateFormat dateFormat = new SimpleDateFormat("MMM yyyy"); 
				String orderByCol, orderByType;
				PortalPreferences portalPrefs = PortletPreferencesFactoryUtil.getPortalPreferences(request); 
				String sortByCol = ParamUtil.getString(request, "orderByCol"); 
				String sortByType = ParamUtil.getString(request, "orderByType"); 
				   
				if (Validator.isNotNull(sortByCol ) && Validator.isNotNull(sortByType )) { 

				portalPrefs.setValue("NAME_SPACE", "sort-by-col", sortByCol); 
				portalPrefs.setValue("NAME_SPACE", "sort-by-type", sortByCol); 

				} else { 

				orderByCol = portalPrefs.getValue("NAME_SPACE", "sort-by-col", "Date");
				orderByType = portalPrefs.getValue("NAME_SPACE", "sort-by-type ", "asc");   
				}
				%>

				<liferay-ui:search-container orderByCol="<%=sortByCol%>"
					orderByType="<%=sortByType%>" iteratorURL="<%=actionURL%>"
					delta="10" emptyResultsMessage="no-documents">
					<liferay-ui:search-container-results>
						<%
							List<DLFileEntry> fileList = (List<DLFileEntry>) request.getAttribute("listFiles");
							OrderByComparator orderByComparator = OrderByComparatorFactoryUtil.create("DLFileEntry", "modifiedDate", false);
						    
							ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
							OrderByComparator orderByComparatorDate =        
									CustomComparatorUtil.getFileOrderByComparator(sortByCol, sortByType);         
							Collections.sort(fileList, orderByComparatorDate);
							
							results = ListUtil.subList(fileList, searchContainer.getStart(),    
					                     searchContainer.getEnd());
				     
			               if (fileList.size()< total)
			                {
			            	   total = fileList.size();
			                }
			               pageContext.setAttribute("results", results);
			               pageContext.setAttribute("total", total);
						%>
					</liferay-ui:search-container-results>
					<liferay-ui:search-container-row modelVar="file"
						className="DLFileEntry">
						<%
							ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
							String pdfUrl = "", excelUrl = "";
							String logo ="", vendor="", technology="", productType="", flashType="", fileTitle="", fileUrl="", file_name="";
							
							long globalGroupId = GroupLocalServiceUtil.getCompanyGroup(PortalUtil.getDefaultCompanyId()).getGroupId();
							
							if(file.getExtension().equalsIgnoreCase("pdf"))
								pdfUrl = "<a target='_blank' href='"+ themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + globalGroupId + StringPool.SLASH + file.getUuid()+"' ><img src='/flash-table-portlet/images/pdf.png' width='20px'/> </a>";
							else if(file.getExtension().equalsIgnoreCase("xlsx") || file.getExtension().equalsIgnoreCase("xls") || file.getExtension().equalsIgnoreCase("csv") )
								excelUrl = "<a target='_blank' href='"+ themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + globalGroupId + StringPool.SLASH + file.getUuid()+"' ><img src='/flash-table-portlet/images/excel.png' width='20px'/> </a>";
			
							String fileDate = dateFormat.format(file.getModifiedDate());
							String logoUrl = "";
							String maxWidth = "120px";
							String marginLeft = "0px";
							String marginTop = "0px";
							try{
								Map<String, Fields> fieldsMap = file.getFieldsMap(file.getFileVersion().getFileVersionId());
								Collection<Fields> collectionFields = fieldsMap.values();
								for (Fields fields : collectionFields) {
									vendor =  fields.get("vendor").getValue().toString().replace("[\"", "").replace("\"]", "");
									if(vendor.equalsIgnoreCase("other"))
										logo="<strong>Other</strong>";
									else 
									{
										 logoUrl = "/flash-table-portlet/images/vendor/"+vendor.toLowerCase()+".gif";
										 
										 if("brother".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("canon".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("dell".equals(vendor.toLowerCase())){
											 maxWidth = "138px";
											 marginLeft = "-34px";
										 	 marginTop = "0px";
										 }
										 if("epson".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										
										 if("hp".equals(vendor.toLowerCase())){
											 maxWidth = "138px";
											 marginLeft = "-34px";
										 	 marginTop = "0px";
										 }
										 if("kodak".equals(vendor.toLowerCase())){
											 maxWidth = "138px";
											 marginLeft = "-34px";
										 	 marginTop = "0px";
										 }
										 if("konica".equals(vendor.toLowerCase())){
											 maxWidth = "120px";
											 marginLeft = "-10px";
										 	 marginTop = "0px";
										 }
										 if("kyocera".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("lexmark".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("oki".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("ricoh".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("samsung".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 if("xerox".equals(vendor.toLowerCase())){
											 maxWidth = "96px";
											 marginLeft = "0px";
										 	 marginTop = "0px";
										 }
										 
										 logo = "<div class='crop'><img src='"+logoUrl
											+"' style='margin-left: "+marginLeft
											+";margin-top: "+marginTop
											+";max-width: "+maxWidth
											+";' alt='"+vendor.toLowerCase()+"'/></div>";
									}
									technology= fields.get("technology").getValue().toString().replace("[\"", "").replace("\"]", "");
									productType =  fields.get("producttype").getValue().toString().replace("[\"", "").replace("\"]", "");
									flashType =  fields.get("flashtype").getValue().toString().replace("[\"", "").replace("\"]", "");
									
									if(fields.get("optionaldate") != null ) {
										  DateFormat inputFormat = new SimpleDateFormat("yyyy/MM/dd");
										  Date optionalDate = inputFormat.parse((String) fields.get("optionaldate").getValue());
										  fileDate = dateFormat.format(optionalDate);
								      }
								}
							}catch(Exception ex){
								ex.printStackTrace();
							}
							fileUrl = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + globalGroupId + StringPool.SLASH + file.getUuid();
							file_name  = file.getTitle() + "." + file.getExtension();
							fileTitle =  "<div style='display:inline'>"+file.getTitle()+"</div>";
						%>

						<liferay-ui:search-container-column-text cssClass="width-1">
							<input name="<%=file_name%>" type="checkbox" data-url="<%=fileUrl%>"/>
						</liferay-ui:search-container-column-text>

						<liferay-ui:search-container-column-text name="Date"
							cssClass="txt-capitalize width-18" value="<%=fileDate%>" />
							
						<liferay-ui:search-container-column-text name='vendor'
							cssClass="width-20" value="<%=logo%>" />
							
						<liferay-ui:search-container-column-text name='technology'
							cssClass="width-10" value="<%=technology%>" />
						<liferay-ui:search-container-column-text name='product-type'
							cssClass="width-14" value="<%=productType%>" />
						<liferay-ui:search-container-column-text name='flash-type'
							cssClass="width-14" value="<%=flashType%>" />
						<liferay-ui:search-container-column-text name='model'
							cssClass="width-15" value="<%=fileTitle%>" />
						<liferay-ui:search-container-column-text name='executive-summary'
							cssClass="width-4" value="<%=pdfUrl%>" />
						<liferay-ui:search-container-column-text name='excel-file'
							cssClass="width-4" value="<%=excelUrl%>" />
					</liferay-ui:search-container-row>
					
					<liferay-ui:search-iterator
						searchContainer="<%= searchContainer %>"
						paginate="${fn:length(listFiles) ge 10}" />	
					<div style="position: relative;"><aui:button cssClass="download-button" id="download_files" type="submit" value="Download"></aui:button></div>
				</liferay-ui:search-container>
				
			</form>

		</div>
		<br />
		<br />
	</c:when>
	<c:otherwise>
		<div class="alert alert-warning text-center">
			<br />
			<liferay-ui:message key="no-documents" />
			<br /> <br />
		</div>
	</c:otherwise>
</c:choose>
