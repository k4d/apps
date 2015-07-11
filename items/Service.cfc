component
	rest="true"
	restPath="/"
	produces="application/json"
	output="false"
{
	pageencoding "utf-8";

	url.returnFormat = "JSON";

	/*	Initialize					------------------------------ */

	public any function init ()
	{
		createData();

		return this;
	}

	/*	CREATE SQL					------------------------------ */

	public void function createSQLScript ()
	{
		local.jsonFile = fileRead( expandPath( "data/items.json" ) );
		local.jsonData = deserializeJSON( local.jsonFile );
		local.sqlCode = "INSERT INTO Items VALUES";
		local.recordSQL = "";

		arrayEach( local.jsonData, function ( value, index )
		{
			recordSQL = "(";
			recordSQL &= index & ",";
			recordSQL &= value.parentId & ",";
			recordSQL &= "'" & value.keyId & "'" & ",";
			recordSQL &= "'" & value.title & "'" & ",";
			recordSQL &= "'" & value.description & "'" & ",";
			recordSQL &= "'" & value.dateCreated & "'" & ",";
			recordSQL &= "'" & value.dateUpdated & "'" & ",";
			recordSQL &= value.price & ",";
			recordSQL &= value.amount & ",";
			recordSQL &= ( value.isActive is "YES" ) ? true : false;
			recordSQL &= ",";
			recordSQL &= ( value.isDeleted is "YES" ) ? true : false;
			recordSQL &= ")";
			recordSQL &= ( arrayLen( jsonData ) ) ? ";" : ",";
			sqlCode &= "#Chr(10)##Chr(13)#" & recordSQL;
		});

		fileWrite( expandPath("data/data.sql"), local.sqlCode );
	}

	/*	CREATE DATA					------------------------------ */

	public void function createData ()
	{
		local.jsonFile = fileRead( expandPath( "data/items.json" ) );
		local.jsonData = deserializeJSON( local.jsonFile );

		arrayEach( local.jsonData, function ( index )
		{
			local.item = entityNew( "Items", index );
			entitySave( local.item );
		});
		ormFlush();
	}

	/*	HELPERS 					------------------------------ */

	private numeric function getItemsCount ()
	{
		return ormExecuteQuery( "select count(*) from Items", true );
	}

	private string function wrapJSON ( required string data, string callback )
	{
		local.callback = ( arguments.callback neq "" && arguments.callback neq "?" ) ? arguments.callback : "jsonData";

		return local.callback & "(" & arguments.data & ");";
	}

	/*	CREATE 						------------------------------ */

	remote void function insertItem ( required string args )
		httpMethod="POST"
		restPath="records"
	{
		local.args = deserializeJSON( arguments.args );

		transaction
		{
			local.entity = entityNew( "Items", local.args );
			entitySave( local.entity );
		}
	}

	/*	READ 						------------------------------ */

	/*	Get All						-------------------- */

	remote struct function getItems () // numeric startrow, numeric maxrows, string callback 
		httpMethod="GET"
		restPath="records"
	{
		local.response = {};
		local.response["data"] = [];
		local.response["recordcount"] = getItemsCount();

		local.paging = {};
		local.paging.offset = ( structKeyExists( arguments, "startrow" ) ) ? arguments.startrow : 0;
		local.paging.maxResults = ( structKeyExists( arguments, "maxrows" ) ) ? arguments.maxrows : 0;

		local.response["data"] = entityLoad( "Items", {}, local.paging );
		local.response["recordreturn"] = arrayLen( local.response["data"] );

		if ( structKeyExists( arguments, "callback" ) )
		{
			url.returnFormat = "plain";

			return wrapJSON ( serializeJSON( local.response ), arguments.callback );
		} else {
			return local.response;
		}
	}

	/*	Get One						-------------------- */

	remote struct function getItem ( required numeric id restArgSource="Path" ) //, string callback 
		httpMethod="GET"
		restPath="records/{id}"
	{
		local.response = {};
		local.data = entityLoadByPK( "Items", arguments.id );

		if ( !isNull( local.data ) )
		{
			local.response["recordreturn"] = 1;
			/*
				Fix CF REST ORM component bug
				response data component => serializeJSON => deserializeJSON
				Error: "Message":"Could not find the ColdFusion component or interface double."
			*/
			local.response["data"] = deserializeJSON( serializeJSON( local.data ) );
		} else {
			local.response["recordreturn"] = 0;
			local.response["data"] = {};
		}

		if ( structKeyExists( arguments, "callback" ) )
		{
			url.returnFormat = "plain";

			return wrapJSON ( serializeJSON( local.response ), arguments.callback );
		} else {
			return local.response;
		}
	}

	/*	UPDATE 						------------------------------ */

	remote void function updateItem ( required numeric id, required string args )
		httpMethod="PUT"
		restPath="records/{id}"
	{
		local.args = deserializeJSON( arguments.args );

		transaction
		{
			local.entity = entityLoadByPK( "Items", arguments.id );

			if ( !isNull( local.entity ) )
			{
				structEach( local.args, function ( key, value )
				{
					entity[key] = value;
				});
			}
		}
	}

	/*	DELETE 						------------------------------ */

	remote void function deleteItem ( required numeric id )
		httpMethod="DELETE"
		restPath="records/{id}"
	{
		if ( getItemsCount() )
		{
			transaction
			{
				local.entity = entityLoadByPK( "Items", arguments.id );
				if ( !isNull( local.entity ) )
				{
					entityDelete( local.entity );
				}
			}
		}
	}
}