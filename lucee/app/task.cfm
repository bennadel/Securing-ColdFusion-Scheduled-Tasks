<cfscript>

	param name="url.password" type="string" default="";

	// Since the ColdFusion scheduled task is configured as an HTTP request from THIS
	// SERVER to THIS SERVER, we are making the request against the localhost address.
	// As such, we can deny any requests not coming from localhost (ie, any public
	// request to this URL).
	if ( cgi.remote_addr != "127.0.0.1" ) {

		send404( "Incorrect IP address used [#cgi.remote_addr#]." );
		abort; // Not needed, just here for emphasis.

	}

	// In this demo container, we have NGINX (port 80) sitting in front of TOMCAT (port
	// 8888) as a reverse proxy. Furthermore, TOMCAT's ports are NOT EXPOSED PUBLICLY. As
	// such, we can deny any request not coming over port 8888.
	if ( cgi.server_port != "8888" ) {

		send404( "Incorrect server port used [#cgi.server_port#]." );
		abort; // Not needed, just here for emphasis.

	}

	// The ColdFusion scheduled task is configured to include a password in the URL. As
	// such, we can deny any request that doesn't include the expected password.
	if ( compare( url.password, application.scheduledTaskPassword ) ) {

		send404( "Incorrect task password used [#url.password#]." );
		abort; // Not needed, just here for emphasis.

	}

	// There's no actual logic in this scheduled task - we're just exploring security
	// options. Let's just log a message so that we know it executed.
	systemOutput( "Task.cfm executed at #timeFormat( now(), 'HH:mm:ss' )#", true );
	systemOutput( "  - IP: #cgi.remote_addr#", true );
	systemOutput( "  - Port: #cgi.server_port#", true );
	systemOutput( "  - Password: #url.password#", true );
	systemOutput( "", true );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I log the given message and then return a "404 Not Found" in the HTTP response.
	* This call halts all further processing of the request.
	*/
	public void function send404( required string errorMessage ) {

		systemOutput( "Unauthorized Request: #errorMessage#", true, true );
		systemOutput( "", true );

		header
			statusCode = "404"
			statusText = "Not Found"
		;
		// CAUTION: Halts all further processing of the current request.
		content
			type = "text/html"
			variable = charsetDecode( "Not Found", "UTF-8" )
		;

	}

</cfscript>
