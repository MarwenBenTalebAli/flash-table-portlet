package com.context.portlet.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;

public class ModifiedDateComparator extends OrderByComparator {

	/**
	 * 
	 */
	private static final long serialVersionUID = -564048765335632254L;

	public static String ORDER_BY_ASC = "status ASC";
	public static String ORDER_BY_DESC = "status DESC";

	DateFormat dateFormat = new SimpleDateFormat("MMM yyyy");

	public ThemeDisplay themeDisplay;

	public ModifiedDateComparator() {
		this(false);
	}

	public ModifiedDateComparator(boolean desc) {
		_asc = desc;
	}

	@Override
	public int compare(Object obj1, Object obj2) {

		DLFileEntry instance1 = (DLFileEntry) obj1;
		DLFileEntry instance2 = (DLFileEntry) obj2;

		if (instance1 == null || instance2 == null) {
			return 0;
		}
		
		int value = instance1.getModifiedDate().compareTo(instance2.getModifiedDate());;

		if (_asc) {
			return value;
		} else {
			return -value;
		}

	}

	public String getOrderBy() {
		if (_asc) {
			return ORDER_BY_ASC;
		} else {
			return ORDER_BY_DESC;
		}
	}

	private boolean _asc;

}
