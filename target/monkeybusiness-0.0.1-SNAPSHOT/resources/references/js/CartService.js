var App = angular.module('myApp1',[]);

App.factory('UserService', ['$http', '$q', function($http, $q){
	 
    return {
         
            fetchAllCartItems: function() {
                    return $http.get('http://localhost:9001/furnit/flows/fetchitems/')
                            .then(
                                    function(response){
                                        return response.data;
                                    }, 
                                    function(errResponse){
                                        console.error('Error while fetching items');
                                        return $q.reject(errResponse);
                                    }
                            );
            },
             
            createCartItem: function(item){
                    return $http.post('http://localhost:9001/furnit/flows/createItem/', item)
                            .then(
                                    function(response){
                                        return response.data;
                                    }, 
                                    function(errResponse){
                                        console.error('Error while creating item');
                                        return $q.reject(errResponse);
                                    }
                            );
            },
             
            updateCartItem: function(item, id){
                    return $http.put('http://localhost:9001/furnit/flows/createItem/'+id, item)
                            .then(
                                    function(response){
                                        return response.data;
                                    }, 
                                    function(errResponse){
                                        console.error('Error while updating item');
                                        return $q.reject(errResponse);
                                    }
                            );
            }
         
    };
 
}]);

//////////////////////////////////////////////////

App.controller('ItemController', ['$scope', 'UserService', function($scope, UserService) {
    var self = this;
    self.item={id:null,username:'',address:'',email:''};
    self.items=[];
         
    self.fetchAllUsers = function(){
        UserService.fetchAllUsers()
            .then(
                         function(d) {
                              self.users = d;
                         },
                          function(errResponse){
                              console.error('Error while fetching Currencies');
                          }
                 );
    };
      
    self.createUser = function(user){
        UserService.createUser(user)
                .then(
                self.fetchAllUsers, 
                        function(errResponse){
                             console.error('Error while creating User.');
                        } 
            );
    };

   self.updateUser = function(user, id){
        UserService.updateUser(user, id)
                .then(
                        self.fetchAllUsers, 
                        function(errResponse){
                             console.error('Error while updating User.');
                        } 
            );
    };

   self.deleteUser = function(id){
        UserService.deleteUser(id)
                .then(
                        self.fetchAllUsers, 
                        function(errResponse){
                             console.error('Error while deleting User.');
                        } 
            );
    };

    self.fetchAllUsers();

    self.submit = function() {
        if(self.user.id===null){
            console.log('Saving New User', self.user);    
            self.createUser(self.user);
        }else{
            self.updateUser(self.user, self.user.id);
            console.log('User updated with id ', self.user.id);
        }
        self.reset();
    };
         
    self.edit = function(id){
        console.log('id to be edited', id);
        for(var i = 0; i < self.users.length; i++){
            if(self.users[i].id === id) {
               self.user = angular.copy(self.users[i]);
               break;
            }
        }
    };
         
    self.remove = function(id){
        console.log('id to be deleted', id);
        if(self.user.id === id) {//clean form if the user to be deleted is shown there.
           self.reset();
        }
        self.deleteUser(id);
    };

     
    self.reset = function(){
        self.user={id:null,username:'',address:'',email:''};
        $scope.myForm.$setPristine(); //reset Form
    };

}]);
