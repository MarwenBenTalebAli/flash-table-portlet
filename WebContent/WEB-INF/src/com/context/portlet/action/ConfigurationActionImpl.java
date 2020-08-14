package com.context.portlet.action;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;

import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import javax.portlet.PortletPreferences;

public class ConfigurationActionImpl extends DefaultConfigurationAction{
	@Override
	public void processAction( PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {  
	    super.processAction(portletConfig, actionRequest, actionResponse);

	    PortletPreferences prefs = actionRequest.getPreferences();

	    //String somePreferenceKey = prefs.getValue("somePreferenceKey", "true");

	    // Add any preference processing here.
	}
}
