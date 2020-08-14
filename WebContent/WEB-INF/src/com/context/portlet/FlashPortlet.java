package com.context.portlet;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.repository.model.Folder;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.model.DLFolderConstants;
import com.liferay.portlet.documentlibrary.service.DLAppServiceUtil;
import com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil;
import com.liferay.portlet.dynamicdatamapping.storage.Fields;
import com.liferay.util.bridges.mvc.MVCPortlet;

public class FlashPortlet extends MVCPortlet {
	private static long ROOT_FOLDER_ID = DLFolderConstants.DEFAULT_PARENT_FOLDER_ID;
	
	DateFormat dateFormat = new SimpleDateFormat("MMM yyyy");
	DateFormat inputFormat = new SimpleDateFormat("yyyy/MM/dd");
	List<String> FOLDERS_NAME = new ArrayList<String>();
	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		PortletPreferences pref = renderRequest.getPreferences();
		String folders_cfg = pref.getValue("foldersKey", "");
		FOLDERS_NAME = Collections.unmodifiableList(Arrays.asList(folders_cfg.split(",")));
		
		String dateFilter = renderRequest.getParameter("dateFilter");
		String vendorFilter = renderRequest.getParameter("vendorFilter");
		String productTypeFilter = renderRequest.getParameter("productTypeFilter");
		String flashTypeFilter = renderRequest.getParameter("flashTypeFilter");
		String technologyFilter = renderRequest.getParameter("technologyFilter");
		String searchKey = renderRequest.getParameter("searchKey");
		renderRequest.setAttribute("dateFilter",dateFilter);
		renderRequest.setAttribute("vendorFilter",vendorFilter);
		renderRequest.setAttribute("productTypeFilter",productTypeFilter);
		renderRequest.setAttribute("flashTypeFilter",flashTypeFilter);
		renderRequest.setAttribute("technologyFilter",technologyFilter);
		renderRequest.setAttribute("searchKey",searchKey);
		
		List<DLFileEntry> listFiles = new ArrayList<DLFileEntry>();
		List<DLFileEntry> listContextFiles = new ArrayList<DLFileEntry>();
		try {
			listFiles = getAllFiles(themeDisplay);
			listContextFiles = getAllFiles(themeDisplay);
		} catch (PortalException e1) {
			e1.printStackTrace();
		} catch (SystemException e1) {
			e1.printStackTrace();
		}

		List<String> listDate = new ArrayList<String>();
		List<Date> listAllDate = new ArrayList<Date>();

		List<String> listVendor =  Collections.unmodifiableList(Arrays.asList(pref.getValue("vendorKey", "").split(",")));
		List<String> listTechnology =  Collections.unmodifiableList(Arrays.asList(pref.getValue("technologyKey", "").split(",")));
		List<String> listProductType = Collections.unmodifiableList(Arrays.asList(pref.getValue("productTypeKey", "").split(",")));
		List<String> listFlashType = Collections.unmodifiableList(Arrays.asList(pref.getValue("flashTypeKey", "").split(",")));
		
		for(DLFileEntry file : listFiles){
			try {
				Map<String, Fields> fieldsMap = file.getFieldsMap(file.getFileVersion().getFileVersionId());
				
				if(fieldsMap.values().size() <= 0)
					listContextFiles.remove(file);
				
				for (Fields fields : fieldsMap.values()) {
					if (fields.get("vendor") != null && fields.get("technology")!= null && fields.get("flashtype")!= null && fields.get("producttype")!= null) {
						if(!listVendor.contains(fields.get("vendor").getValue().toString().replace("[\"", "").replace("\"]", "")) ||
							!listTechnology.contains(fields.get("technology").getValue().toString().replace("[\"", "").replace("\"]", "")) ||
							!listFlashType.contains(fields.get("flashtype").getValue().toString().replace("[\"", "").replace("\"]", "")) ||
							!listProductType.contains(fields.get("producttype").getValue().toString().replace("[\"", "").replace("\"]", ""))){
								listContextFiles.remove(file);
						}else{
							if(fields.get("optionaldate") != null ) {
								  String inputOptionalDate = (String) fields.get("optionaldate").getValue();
								  try{
									  Date optionalDate = inputFormat.parse(inputOptionalDate);
									  String formatedDate = dateFormat.format(optionalDate);
									  
									  listAllDate.add(optionalDate);
									  
									  if(!listDate.contains(formatedDate)) listDate.add(formatedDate);
									  
								  }catch(Exception e){
									  e.printStackTrace();
								  }
						      }
							  else{
								  listAllDate.add(file.getModifiedDate());
								  if(!listDate.contains(dateFormat.format(file.getModifiedDate())))
										listDate.add(dateFormat.format(file.getModifiedDate()));
							  }
							
							if(dateFilter != null && !dateFilter.equals("") && !dateFilter.equalsIgnoreCase("all")){
								if(fields.get("optionaldate") != null ) {
									String inputOptionalDate = (String) fields.get("optionaldate").getValue();
									try{
										  Date optionalDate = inputFormat.parse(inputOptionalDate);
										  
										  if(!dateFilter.equalsIgnoreCase(dateFormat.format(optionalDate)))
											  listContextFiles.remove(file);
									  }catch(Exception e){
										  e.printStackTrace();
									  }
							      }
								  else{
									  if(!dateFilter.equalsIgnoreCase(dateFormat.format(file.getModifiedDate())))
										  listContextFiles.remove(file);
								  }
							}

							if(vendorFilter != null && !vendorFilter.equals("") && !vendorFilter.equalsIgnoreCase("all") && !vendorFilter.equalsIgnoreCase(fields.get("vendor").getValue().toString().replace("[\"", "").replace("\"]", "")))
								{
									listContextFiles.remove(file);
								}

							if(technologyFilter != null && !technologyFilter.equals("") && !technologyFilter.equalsIgnoreCase("all") && !technologyFilter.equalsIgnoreCase(fields.get("technology").getValue().toString().replace("[\"", "").replace("\"]", "")))
								{
									listContextFiles.remove(file);
								}
							
							if(productTypeFilter != null && !productTypeFilter.equals("") && !productTypeFilter.equalsIgnoreCase("all") && !productTypeFilter.equalsIgnoreCase(fields.get("producttype").getValue().toString().replace("[\"", "").replace("\"]", "")))
								{
									listContextFiles.remove(file);
								}
							
							if(flashTypeFilter != null && !flashTypeFilter.equals("")&& !flashTypeFilter.equalsIgnoreCase("all") && !flashTypeFilter.equalsIgnoreCase(fields.get("flashtype").getValue().toString().replace("[\"", "").replace("\"]", "")))
								{
									listContextFiles.remove(file);
								}
							
							if(searchKey != null && !searchKey.equals("") && !file.getTitle().toLowerCase().contains(searchKey.toLowerCase()) && !fields.get("vendor").getValue().toString().toLowerCase().contains(searchKey.toLowerCase()))
								{
									listContextFiles.remove(file);
								}
						}
					}else{
						listContextFiles.remove(file);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        
		listDate = sortListDate(listDate, "DESC");
		List<DLFileEntry> list = getListFiles(listContextFiles, listAllDate);
		
		renderRequest.setAttribute("listFiles", list);
		renderRequest.setAttribute("listDate", listDate);
		
		super.doView(renderRequest, renderResponse);
	}
	
	private List<DLFileEntry> getListFiles(List<DLFileEntry> listContextFiles,
			List<Date> listAllDate) {
		List<DLFileEntry> list = new ArrayList<DLFileEntry>();
		for (int i = 0; i <listContextFiles.size(); i++) {
			listContextFiles.get(i).setModifiedDate(listAllDate.get(i));
			list.add(listContextFiles.get(i));
		}
		return list;
	}

	private List<Date> stringListToDateList(List<String> dateStringList, String format) {
	    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
	    List<Date> dateList = new ArrayList<Date>();
	    
	    for (String dateString : dateStringList) {
	        try {
	            dateList.add(simpleDateFormat.parse(dateString));
	        } catch (ParseException e) {
	            e.printStackTrace();
	        }
	    }

		return dateList;
	}
	
	private List<String> sortListDate(List<String> dateStringList, String ordre) {
		List<Date> listDate = stringListToDateList(dateStringList, "MMM yyyy");
		List<String> formatedDateList = new ArrayList<String>();

		Collections.sort(listDate, new Comparator<Date> () {
		    @Override
		    public int compare(Date date1, Date date2) {
		        return date1.compareTo(date2);
		    }
		});
		if("DESC".equals(ordre))
		Collections.reverse(listDate);
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MMM yyyy");
		for (Iterator<Date> i = listDate.iterator(); i.hasNext();) {
			Date date = i.next();
		    if(date != null)
		    formatedDateList.add(simpleDateFormat.format(date));
		}
		
		return formatedDateList;
	}
	
	public List<DLFileEntry> getAllFiles(ThemeDisplay themeDisplay) throws PortalException, SystemException{
		List<DLFileEntry> fileEntries = new ArrayList<DLFileEntry>();
		long globalGroupId = GroupLocalServiceUtil.getCompanyGroup(PortalUtil.getDefaultCompanyId()).getGroupId();
		
		for(String folderName : FOLDERS_NAME){
			try {
				Folder folder = DLAppServiceUtil.getFolder(globalGroupId, ROOT_FOLDER_ID, folderName);
				fileEntries.addAll(DLFileEntryLocalServiceUtil.getFileEntries(globalGroupId,folder.getFolderId(),-1, -1, null));
				
				for(Long subFolder : DLAppServiceUtil.getSubfolderIds(globalGroupId, folder.getFolderId())){
					fileEntries.addAll(DLFileEntryLocalServiceUtil.getFileEntries(globalGroupId, subFolder,-1, -1, null));
				}
			} catch (Exception e) {	
				e.printStackTrace();
			}
		}
		return fileEntries;
	}

}
