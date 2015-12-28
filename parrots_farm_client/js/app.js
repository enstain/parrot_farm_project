angular.module('parrotApp', ['ui.router', 'ngResource', 'parrotApp.controllers', 'parrotApp.services']);

angular.module('parrotApp').config(function($stateProvider) {
  $stateProvider.state('parrots', { // state for showing all parrots
    url: '/parrots',
    templateUrl: 'partials/parrots.html',
    controller: 'ParrotListController'
  }).state('viewParrot', { //state for showing single parrot
    url: '/parrots/:id/view',
    templateUrl: 'partials/parrot-view.html',
    controller: 'ParrotViewController'
  }).state('newParrot', { //state for adding a new parrot
    url: '/parrots/new',
    templateUrl: 'partials/parrot-add.html',
    controller: 'ParrotCreateController'
  }).state('editParrot', { //state for updating a parrot
    url: '/parrots/:id/edit',
    templateUrl: 'partials/parrot-edit.html',
    controller: 'ParrotEditController'
  });
}).run(function($state) {
  $state.go('parrots'); //make a transition to movies state when app starts
});