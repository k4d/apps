component
	output="false"
{
	pageencoding "utf-8";

	/*	Imports						------------------------------ */

	import Service;

	/*	Component variables			------------------------------ */

	/*	Application settings		-------------------- */

	this.name						= "cars";
	this.applicationTimeout			= createTimeSpan( 0, 1, 0, 0 );
	this.invokeImplicitAccessor		= true;

	/*	REST settings				-------------------- */

	this.restSettings.cfcLocation		= "./";
	this.restSettings.skipCFCWithError	= true;

	/*	Application functions		------------------------------ */

	public boolean function onApplicationStart ()
	{
		initApp();

		return true;
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

	/*	Other functions				------------------------------ */

	private void function initApp () {

		application.APP = {};
		application.APP.start = now();

		application.Service = new Service();
		application.Service.init();

		restInitApplication( getDirectoryFromPath( getCurrentTemplatePath() ), this.name, {host="apps"} );
	}

	private void function reInitApp () {

		applicationStop();

		initApp();

		location( url="./main.cfml" );
	}
}