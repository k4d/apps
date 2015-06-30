component
	rest="true"
	restPath="/"
	produces="application/json"
	output="false"
{
	pageencoding "utf-8";

	url.returnFormat="JSON";

	/*	Initialize function			------------------------------ */

	public any function initialize ()
	{
		application.data = createData();

		return this;
	}

	/*	Private functions			------------------------------ */

	private query function createData ()
	{
		local.jsonFile = fileRead( expandPath( "json/data.json" ) );
		local.jsonData = deserializeJSON( local.jsonFile );

		arrayInsertAt( local.jsonData.fields, 1, "id" );
		arrayInsertAt( local.jsonData.type, 1, "Integer" );

		arrayEach( local.jsonData.data, function ( value, index ){
			arrayInsertAt( value, 1, index );
			arraySet( jsonData.data, index, index, value );
		});

		local.fields = arrayToList( local.jsonData.fields, "," );
		local.type = arrayToList( local.jsonData.type, "," );
		local.data = local.jsonData.data;

		local.response = queryNew(
			local.fields,
			local.type,
			local.data
		);

		return local.response;
	}

	/*	Remote functions			------------------------------ */

	remote any function getItems ()
		httpMethod="GET"
		restPath="items"
	{
		local.response = {};
		local.response["data"] = [];
		local.query = queryExecute("
			select *
			from application.data
			",
			[],
			{
				dbtype="query"
			}
		);
		local.response["recordcount"] = application.data.recordcount;
		local.response["recordreturn"] = local.query.recordcount;

		for ( row in local.query )
		{
			arrayAppend( local.response.data, row );
		}
		return local.response;
	}

	remote any function getItem ( required numeric id restArgSource="Path" )
		httpMethod="GET"
		restPath="/items/{id}"
	{
		local.response = {};
		local.response["data"] = {};
		local.query = queryExecute("
			select *
			from application.data
			where id=:id
			",
			{
				id={
					value=arguments.id,
					CFSQLType='cf_sql_integer'
				}
			},
			{
				dbtype="query"
			}
		);
		local.response["recordreturn"] = local.query.recordcount;

		for ( row in local.query )
		{
			local.response["data"] = row;
		}
		return local.response;
	}

	remote void function createItem ( required string args restArgSource="Form" )
		httpMethod="POST"
		restPath="items"
	{
		queryAddRow( application.data, deserializeJSON( arguments.args ) );
	}

	remote void function updateItem ( required numeric id restArgSource="Path", required string args restArgSource="Header" )
		httpMethod="PUT"
		restPath="/items/{id}"
	{
		//	Code here
	}

	remote void function deleteItem ( required numeric id restArgSource="Path" )
		httpMethod="DELETE"
		restPath="/items/{id}"
	{
		//	Code here
	}
}