/*	Application					------------------------------ */

var app = angular.module( 'Cars', [ 'ngRoute' ] );

/*	Application config			-------------------- */

app.config([ '$routeProvider', function( $routeProvider ) {

	/*	Route settings				-------------------- */

	$routeProvider
		.when('/',{
			templateUrl: '/cars/app/templates/list.html',
			controller: 'LayoutHome'
		})
		.when('/list',{
			templateUrl: '/cars/app/templates/list.html',
			controller: 'LayoutHome'
		})
		.when('/list/:id',{
			templateUrl: '/cars/app/templates/details.html',
			controller: 'LayoutCarsDetails'
		})
		.otherwise({
			retirectTo: '/'
		});

}]);

/*	Controllers					------------------------------ */

app.controller( 'LayoutHome', [ '$scope', '$http', '$location', function( $scope, $http, $location ) {

	$http.get( 'http://apps/rest/cars/records' )
		.success(function ( data, status, record, config ) {
			$scope.records = data;
			$scope.data = $scope.records.data;
		});

	$scope.orderByField = 'id';
	$scope.reverse = false;
	$scope.sort = function ( field ) {
		if ( $scope.orderByField === field )
		{
			$scope.reverse = !$scope.reverse;
		} else {
			$scope.orderByField = field;
			$scope.reverse = false;
		}
	};

}]);

app.controller( 'LayoutCarsDetails', [ '$scope', '$http', '$location', '$routeParams', function( $scope, $http, $location, $routeParams ) {

	$scope.id = $routeParams.id;

	var url = 'http://apps/rest/cars/records/' + $scope.id;

	$http.get( url )
		.success(function ( data, status, record, config ) {
			$scope.records = data;
			$scope.data = $scope.records.data;
		});

}]);