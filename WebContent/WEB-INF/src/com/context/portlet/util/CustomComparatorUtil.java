package com.context.portlet.util;

import com.liferay.portal.kernel.util.OrderByComparator;

public class CustomComparatorUtil {
	public static OrderByComparator getFileOrderByComparator(String orderByCol,
			String orderByType) {

		boolean orderByAsc = false;

		if (orderByType.equals("asc")) {
			orderByAsc = true;
		}
		OrderByComparator orderByComparator = new ModifiedDateComparator(orderByAsc);

		if (orderByCol.equalsIgnoreCase("Date")) {
			orderByComparator = new ModifiedDateComparator(orderByAsc);
		}

		return orderByComparator;
	}
}
