angular.module('parrotApp.controllers', [])

.controller('ParrotListController', function($scope, $stateParams, $state, $window, Parrot) {
  //$scope.parrots = Parrot.query(); //fetch all parrots. Issues a GET to /api/parrots
  $scope.search_keys = {
    "search_name": {
      "type": "text",
      "label": "Name equal to"
    },
    "age_equal": {
      "type": "number",
      "label": "Age equal to"
    },
    "age_gt": {
      "type": "number",
      "label": "Age greater than"
    },
    "age_lt": {
      "type": "number",
      "label": "Age less than"
    },
    "brood": {
      "type": "select",
      "label": "Brood?",
      "source": [{"value": "true"}, {"value": "false"}]
    },
    "sex_is": {
      "type": "select",
      "label": "Sex is",
      "source": Parrot.values({field: "sex"})
    },
    "color_is": {
      "type": "select",
      "label": "Color is",
      "source": Parrot.values({field: "color"})
    }
  }

  $scope.search = {};
  $scope.newFilter = "";
  $scope.parrots = Parrot.query($scope.search);

  $scope.addFilter = function() {
    var filterName = $scope.newFilter;
    if (filterName != "") {
      $scope.search[filterName] = "";
      $scope.newFilter = "";
    }
  }

  $scope.removeFilter = function(keyName) {
    delete $scope.search[keyName];
  }

  $scope.applyFilters = function() {
    $scope.parrots = Parrot.query($scope.search);
  }

  $scope.deleteParrot = function(parrot) { // Delete a parrot. Issues a DELETE to /api/parrots/:id
    if (confirm('Are you sure?')) {
      parrot.$delete(function(response) {
        $window.location.href = ''; //redirect to home
      },function(response) {
        alert(response.data.base);
      });
    }
  };
})

.controller('ParrotViewController', function($scope, $stateParams, Parrot) {
  $scope.mother = null;
  $scope.father = null;
  $scope.parrot = Parrot.get({ id: $stateParams.id }, function() {
    var mother_id = $scope.parrot.mother_id,
      father_id = $scope.parrot.father_id;

    $scope.descendants = Parrot.descendants({id: $scope.parrot.id});
    $scope.ancestry = Parrot.ancestry({id: $scope.parrot.id});

    if (mother_id && mother_id != "nil") {
      $scope.mother = Parrot.get({ id: $scope.parrot.mother_id });
    }

    if (father_id && mother_id != "nil") {
      $scope.father = Parrot.get({ id: $scope.parrot.father_id });
    }
  });
  
})

.controller('ParrotCreateController', function($scope, $state, $stateParams, Parrot) {
  $scope.colors = Parrot.values({field: "color"});
  $scope.sex_values = Parrot.values({field: "sex"});

  $scope.fathers = Parrot.parents({sex: "male"});
  $scope.mothers = Parrot.parents({sex: "female"});

  $scope.parrot = new Parrot({age: 0, sex: "male", color: "green", mother_id: "nil", father_id: "nil"});  //create new parrot instance. Properties will be set via ng-model on UI

  $scope.addParrot = function() { //create a new parrot. Issues a POST to /api/parrots
    $scope.parrot.$save(function() {
      $state.go('parrots'); // on success go back to home i.e. parrots state.
    });
  };
})

.controller('ParrotEditController', function($scope, $state, $stateParams, Parrot) {
  $scope.colors = Parrot.values({field: "color"});
  $scope.sex_values = Parrot.values({field: "sex"});

  $scope.fathers = Parrot.parents({sex: "male"});
  $scope.mothers = Parrot.parents({sex: "female"});

  $scope.updateParrot = function() { //Update the edited parrot. Issues a PUT to /api/parrots/:id
    $scope.parrot.$update(
      function(response) {
        console.log(response);
        $state.go('parrots'); // on success go back to home i.e. parrots state.
      },
      function(response) {
        $scope.errors = response.data.base;
        $scope.$apply;
      }
    );
  };

  $scope.loadParrot = function() { //Issues a GET request to /api/parrots/:id to get a parrot to update
    $scope.parrot = Parrot.get({ id: $stateParams.id });
    console.log($scope.parrot);
  };

  $scope.loadParrot(); // Load a parrot which can be edited on UI
});