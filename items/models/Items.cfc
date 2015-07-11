component
	persistent="true"
	entityname="Items"
	table="Items"
	output="false"
{
	pageencoding "utf-8";

	/*	Property					------------------------------ */

	property name="itemId"		column="itemId"			type="numeric"	ormtype="integer"	fieldtype="Id"	generator="increment";
	property name="parentId"	column="parentId"		type="numeric"	ormtype="integer"	default=0;
	property name="keyId"		column="keyId"			type="string"	ormtype="string"	notnull="true";
	property name="title"		column="title"			type="string"	ormtype="string"	notnull="true";
	property name="description"	column="description"	type="string"	ormtype="text";
	property name="dateCreated"	column="dateCreated"	type="date"		ormtype="timestamp"	notnull="true";
	property name="dateUpdated"	column="dateUpdated"	type="date"		ormtype="timestamp";
	property name="price"		column="price"			type="double"	ormtype="double"	notnull="true";
	property name="amount"		column="amount"			type="numeric"	ormtype="integer"	notnull="true";
	property name="isActive"	column="isActive"		type="boolean"	ormtype="boolean"	default=false;
	property name="isDeleted"	column="isDeleted"		type="boolean"	ormtype="boolean"	default=false;
}