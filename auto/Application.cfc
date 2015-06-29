component
	output="true"
{
	pageencoding "utf-8";

	/*	Imports						------------------------------ */

	import Service;

	/*	Application variables		------------------------------ */

	this.name = "auto";
	this.applicationTimeout = createTimeSpan(0,1,0,0);

	this.restsettings.cfclocation = "./";
	this.restsettings.skipcfcwitherror = true;

	/*	Application functions		------------------------------ */

	public boolean function onApplicationStart ()
	{
		initApp();

		return true;
	}

	public void function onSessionStart ()
	{
		// code here
	}

	public boolean function onRequestStart ( required string targetPage )
	{
		( structKeyExists( url, "reinit" ) ) ? reInitApp() : false;

		return true;
	}

	public void function onRequest ( required string targetPage )
	{
		include arguments.targetPage;
	}

	public void function onRequestEnd ()
	{
		// code here
	}

	public void function onApplicationEnd ( struct appScope=structNew() )
	{
		// code here
	}

	/*	Other functions				------------------------------ */

	private void function initApp () {

		application.start = now();

		application.Service = new Service();
		application.Service.initialize();

		restInitApplication( getDirectoryFromPath(getCurrentTemplatePath()), this.name, {host="apps"} );
	}

	private void function reInitApp () {

		applicationStop();

		initApp();
	}
}