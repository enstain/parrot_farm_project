angular.module('parrotApp.services', []).factory('Parrot', function($resource) {
  return $resource('http://localhost:8080/parrots/:id.json', { id: '@id' }, {
    update: {
      method: 'PUT'
    },
    values: {
    	method: 'GET',
    	params: {field: '@field'},
    	url: 'http://localhost:8080/parrots/values/:field.json', 
    	isArray: true
    },
    parents: {
    	method: 'GET',
    	params: {sex: '@sex'},
    	url: 'http://localhost:8080/parrots/may_be_parents/:sex.json', 
    	isArray: true
    },
    ancestry: {
    	method: 'GET',
    	url: 'http://localhost:8080/parrots/:id/show_ancestry.json',
    	isArray: true
    },
    descendants: {
    	method: 'GET',
    	url: 'http://localhost:8080/parrots/:id/show_descendants.json',
    	isArray: true
    }
  });
});