component
	output = false
	hint = "I define the application settings and event handlers."
	{

	// Define application settings.
	this.name = "SecureScheduledTaskDemo";
	this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;

	// ---
	// LIFE-CYCLE METHODS.
	// ---

	/**
	* I get called once when the application is being started. This method call is
	* single-threaded across all requests while the application is being bootstrapped.
	*/
	public void function onApplicationStart() {

		application.scheduledTaskPassword = env( "TASK_PASSWORD" );

		// NOTE: We are configuring the "task.cfm" script to be requested using the
		// localhost domain, "127.0.0.1", and an internal port, "8888". Since port 8888
		// is NOT EXPOSED by the container, we know that a PUBLIC request will never use
		// this port.
		// --
		// NOTE: There is a bug in recent version of Lucee CFML where the "Authorization"
		// header is not being sent-through, even if the username/password attributes are
		// defined. See: https://luceeserver.atlassian.net/browse/LDEV-2925 . As such,
		// I'm using the URL to provide the password.
		schedule
			action = "update"
			task = "RunTask"
			operation = "HTTPRequest"
			url = "http://127.0.0.1:8888/task.cfm?password=#encodeForUrl( application.scheduledTaskPassword )#"
			startDate = "2021-01-01"
			startTime = "00:00 AM"
			interval = 30 // Every 30-seconds.
		;

	}


	/**
	* I get called once at the start of every request into the ColdFusion application.
	*/
	public void function onRequestStart() {

		if ( url.keyExists( "init" ) ) {

			applicationStop();
			location( url = "/index.cfm", addToken = false );

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I return the given environment variable value; or, the fallback if the variable is
	* either UNDEFINED or EMPTY.
	*/
	private string function env(
		required string name,
		string fallbackValue = ""
		) {

		// In Lucee CFML, we can access the environment variables directly from the
		// SERVER SCOPE.
		var value = ( server.system.environment[ name ] ?: "" );

		// For the sake of the demo, we're treating an EMPTY value and a NON-EXISTENT
		// value as the same thing, using the given value only if it is populated.
		return( value.len() ? value : fallbackValue );

	}

}
