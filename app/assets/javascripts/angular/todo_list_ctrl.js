var app = angular.module('todo');
app.controller('TodoListCtrl', ['$scope', '$state', 'Flash', 'Spin', 'TodoList', '$uibModal', 'TodoItem',
  function($scope, $state, Flash, Spin, TodoList, $uibModal, TodoItem){
    $scope.currentPage = 1;
    $scope.pageSize = 3;
    $scope.todo_lists = [];
    $scope.totalItems = 0;
    $scope.title = undefined;
    getTodoLists();

    function getTodoLists(){
      TodoList.all({ page: $scope.currentPage,
        limit: $scope.pageSize, title: $scope.title }, function(response) {
        $scope.todo_lists = response.todo_lists;
        $scope.totalItems = response.total;
      });
    };

    $scope.pageChangeHandler = function(newPageNumber){
      getTodoLists();
    };

    $scope.searchTodoList = function(title){
      $scope.title = title;
      getTodoLists();
    };

    $scope.addTodoList = function(){
      $uibModal.open({
        templateUrl: 'todo_list_form.html',
        backdrop: true,
        windowClass: 'modal',
        controller: ['$scope', '$uibModalInstance', 'todo_lists', 'totalItems',
        function ($scope, $uibModalInstance, todo_lists, totalItems) {
          $scope.errors = [];
          $scope.todo_list = { title: null };
          $scope.save = function(){
            Spin.startSpin();
            TodoList.create({todo_list: $scope.todo_list}, function(resp){
              todo_lists.splice(0, 0, resp.todo_list);
              totalItems += 1;
              $scope.todo_list = { title: null };
              $uibModalInstance.dismiss('cancel');
              Spin.stopSpin();
              Flash.create('success', "Todo list created successfully", 'custom-class');
            }, function(resp){
              angular.forEach(resp.data.errors, function(error, field) {
                if($scope.todoListForm[field] != undefined){
                  $scope.todoListForm[field].$setValidity('server', false);
                  $scope.errors[field] = error;
                };
              });
              Spin.stopSpin();
            });
          };
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };
          $scope.errorClass = function(name) {
            return $scope.todoListForm[name].$error.server ? 'has-error' : '';
          };
        }],
        resolve: {
          todo_lists: function () {
            return $scope.todo_lists;
          },
          totalItems: function() {
            return $scope.totalItems;
          }
        }
      });
    };

    $scope.editTodoList = function(todo_list){
      $uibModal.open({
        templateUrl: 'todo_list_form.html',
        backdrop: true,
        windowClass: 'modal',
        controller: ['$scope', '$uibModalInstance', 'todo_list', 'todo_lists',
        function ($scope, $uibModalInstance, todo_list, todo_lists) {
          $scope.errors = [];
          $scope.todo_list = angular.copy(todo_list);
          $scope.save = function(){
            Spin.startSpin();
            TodoList.update({id: todo_list.id, todo_list: $scope.todo_list}, function(resp){
              var index = todo_lists.indexOf(todo_list);
              todo_lists.splice(index, 1);
              todo_lists.splice(0, 0, resp.todo_list)
              $uibModalInstance.dismiss('cancel');
              Spin.stopSpin();
              Flash.create('success', "Todo list updated successfully", 'custom-class');
            }, function(resp){
              angular.forEach(resp.data.errors, function(error, field) {
                if($scope.todoListForm[field] != undefined){
                  $scope.todoListForm[field].$setValidity('server', false);
                  $scope.errors[field] = error;
                };
              });
              Spin.stopSpin();
            });
          };
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };
          $scope.errorClass = function(name) {
            return $scope.todoListForm[name].$error.server ? 'has-error' : '';
          };
        }],
        resolve: {
          todo_list: function () {
            return todo_list;
          },
          todo_lists: function(){
            return $scope.todo_lists;
          }
        }
      });
    };

    $scope.destroyTodoList = function(todo_list){
      Spin.startSpin();
      TodoList.softDelete({id: todo_list.id}, function(resp){
        var index = $scope.todo_lists.indexOf(todo_list);
        $scope.todo_lists.splice(index, 1);
        $scope.totalItems -= 1;
        Spin.stopSpin();
        Flash.create('success', "Todo list destroyed successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.deleteTodoList = function(todo_list){
      Spin.startSpin();
      TodoList.delete({id: todo_list.id}, function(resp){
        var index = $scope.todo_lists.indexOf(todo_list);
        $scope.todo_lists.splice(index, 1);
        $scope.totalItems -= 1;
        Spin.stopSpin();
        Flash.create('success', "Todo list deleted successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.addTodoItem = function(todo_list){
      $uibModal.open({
        templateUrl: 'todo_item_form.html',
        backdrop: true,
        windowClass: 'modal',
        controller: ['$scope', '$uibModalInstance', 'todo_list',
        function ($scope, $uibModalInstance, todo_list) {
          $scope.errors = [];
          $scope.todo_list = todo_list;
          $scope.todo_item = { content: null };
          $scope.save = function(){
            Spin.startSpin();
            TodoItem.create({todo_list_id: todo_list.id,
              todo_item: $scope.todo_item}, function(resp){
              todo_list.todo_items.splice(0, 0, resp.todo_item);
              $scope.todo_item = { content: null };
              $uibModalInstance.dismiss('cancel');
              Spin.stopSpin();
              Flash.create('success', "Todo item created successfully", 'custom-class');
            }, function(resp){
              angular.forEach(resp.data.errors, function(error, field) {
                if($scope.todoItemForm[field] != undefined){
                  $scope.todoItemForm[field].$setValidity('server', false);
                  $scope.errors[field] = error;
                };
              });
              Spin.stopSpin();
            });
          };
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };
          $scope.errorClass = function(name) {
            return $scope.todoItemForm[name].$error.server ? 'has-error' : '';
          };
        }],
        resolve: {
          todo_list: function () {
            return todo_list;
          }
        }
      });
    };

    $scope.editTodoItem = function(todo_list, todo_item){
      $uibModal.open({
        templateUrl: 'todo_item_form.html',
        backdrop: true,
        windowClass: 'modal',
        controller: ['$scope', '$uibModalInstance', 'todo_list', 'todo_item',
        function ($scope, $uibModalInstance, todo_list, todo_item) {
          $scope.errors = [];
          $scope.todo_list = todo_list;
          $scope.todo_item = angular.copy(todo_item);
          $scope.save = function(){
            Spin.startSpin();
            TodoItem.update({id: todo_item.id, todo_item: $scope.todo_item}, function(resp){
              var index = todo_list.todo_items.indexOf(todo_item);
              todo_list.todo_items.splice(index, 1);
              todo_list.todo_items.splice(0, 0, resp.todo_item)
              $uibModalInstance.dismiss('cancel');
              Spin.stopSpin();
              Flash.create('success', "Todo item updated successfully", 'custom-class');
            }, function(resp){
              angular.forEach(resp.data.errors, function(error, field) {
                if($scope.todoItemForm[field] != undefined){
                  $scope.todoItemForm[field].$setValidity('server', false);
                  $scope.errors[field] = error;
                };
              });
              Spin.stopSpin();
            });
          };
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };
          $scope.errorClass = function(name) {
            return $scope.todoItemForm[name].$error.server ? 'has-error' : '';
          };
        }],
        resolve: {
          todo_item: function () {
            return todo_item;
          },
          todo_list: function(){
            return todo_list;
          }
        }
      });
    };

    $scope.deleteTodoItem = function(todo_list, todo_item){
      Spin.startSpin();
      TodoItem.delete({id: todo_item.id}, function(resp){
        var index = todo_list.todo_items.indexOf(todo_item);
        todo_list.todo_items.splice(index, 1);
        Spin.stopSpin();
        Flash.create('success', "Todo item deleted successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.destroyTodoItem = function(todo_list, todo_item){
      Spin.startSpin();
      TodoItem.softDelete({id: todo_item.id}, function(resp){
        var index = todo_list.todo_items.indexOf(todo_item);
        todo_list.todo_items.splice(index, 1);
        Spin.stopSpin();
        Flash.create('success', "Todo item destroyed successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };
}]);

