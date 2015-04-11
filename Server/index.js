var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var mongoose = require('mongoose');
// Database connect
mongoose.connect('mongodb://localhost/tasks');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function (callback) {
	console.log("db connnnnnected");
  // yay!
});
app.get('/', function(req, res){
  res.sendFile('/Users/Chris/Documents/Development/FYP-Fitserver/web/index.html');
}); 
var userSchema = mongoose.Schema({
	name: String,
	age: String,
	gender:String,
	calories:String,
	wellBeingScore:Number
});
var User = mongoose.model('User',userSchema)
//console.log ('DEBUGG BEFORE QUERY USER IS :' +User);
function dbQuery(name,socket){
	var queryResult;
    //console.log("DEBUGGG QUERY Name is : " +name );
  User.find({ name: name },{'_id' :0}).exec(function (err, result) {
  	if (err) return handleError(err);
  if (result[0]){
  console.log('Query Result for '+ name +' is: ' + result[0].name) 
  console.log('DEBUGG QUERYRESULT IS :' + result[0].age);
  socket.emit("found",result[0].name,result[0].age,result[0].gender,result[0].calories);
  }
  else 
  {
  console.log("no match");
  io.emit("no match");
  }
});
}
function dbFunction(data){
var user1 = new User (
{ name: data.name,
  age :data.age,
  gender: data.gender,
  calories:data.calories,
  wellBeingScore: data.wellBeingScore	
})
//console.log ('DEBUGG: user name is : '+user1.name)
user1.save(function(err,user1) {
	if(err) 
		{   console.error(err);
			return err;
		}
		console.log("save successful");
		});
		return "success";
	}
//mongoose.model ('Tasks',Tasks);
function socketConn(io,User) {
io.on('connection', function(socket){
  socket.on ('handshake',function() {
	console.log ('a user from iphone connected');
	});
  socket.on ('disconnect',function() {
	console.log ('a user disconnected');
	});
socket.on('query', function(data){
	var name =data.name;
	//console.log("DEBUGGG QUERY Name is : " + name );
   dbQuery(name,socket);
})
  socket.on ('data', function(data,db) {
  console.log("name: "+data.name
  			 +"\nage: "+data.age	
  			 +"\ngender: "+data.gender
  			 +"\ncalories: "+data.calories
  			 +"\nWell-Being: "+data.wellBeingScore);
  var msg = dbFunction(data);
  console.log ('db save is '+msg)
  io.emit ('db status',msg);
});
})
}
socketConn(io);
http.listen(3000, function(){
  console.log('listening on localhost:3000');
});
