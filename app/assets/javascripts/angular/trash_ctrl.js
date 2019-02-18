var app = angular.module('todo');
app.controller('TrashCtrl', ['$scope', '$state', 'Flash', 'Spin', 'TodoList', '$uibModal', 'TodoItem',
  function($scope, $state, Flash, Spin, TodoList, $uibModal, TodoItem){
    $scope.currentPage = 1;
    $scope.pageSize = 5;
    $scope.todo_lists = [];
    $scope.totalItems = 0;
    getTodoLists();

    function getTodoLists(){
      TodoList.all({ page: $scope.currentPage,
        limit: $scope.pageSize, trash: true }, function(response) {
        $scope.todo_lists = response.todo_lists;
        $scope.totalItems = response.total;
      });
    };

    $scope.pageChangeHandler = function(newPageNumber){
      getTodoLists();
    };

    $scope.restoreTodoList = function(todo_list){
      Spin.startSpin();
      TodoList.restore({id: todo_list.id}, function(resp){
        cleanTodoList(todo_list);
        Spin.stopSpin();
        Flash.create('success', "Todo list restored successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.deleteTodoList = function(todo_list){
      Spin.startSpin();
      TodoList.delete({id: todo_list.id}, function(resp){
        cleanTodoList(todo_list);
        Spin.stopSpin();
        Flash.create('success', "Todo list deleted successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.restoreTodoItem = function(todo_list, todo_item){
      Spin.startSpin();
      TodoItem.restore({id: todo_item.id}, function(resp){
        var index = todo_list.deleted_todo_items.indexOf(todo_item);
        todo_list.deleted_todo_items.splice(index, 1);
        if(todo_list.deleted_todo_items.length == 0){
          cleanTodoList(todo_list);
        }
        Spin.stopSpin();
        Flash.create('success', "Todo item restored successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    $scope.deleteTodoItem = function(todo_list, todo_item){
      Spin.startSpin();
      TodoItem.delete({id: todo_item.id}, function(resp){
        var index = todo_list.deleted_todo_items.indexOf(todo_item);
        todo_list.deleted_todo_items.splice(index, 1);
        if(todo_list.deleted_todo_items.length == 0){
          cleanTodoList(todo_list);
        }
        Spin.stopSpin();
        Flash.create('success', "Todo item deleted successfully", 'custom-class');
      }, function(error){
        console.log(error);
        Spin.stopSpin();
      });
    };

    function cleanTodoList(todo_list){
      var index = $scope.todo_lists.indexOf(todo_list);
      $scope.todo_lists.splice(index, 1);
      $scope.totalItems -= 1;
    }
}]);

