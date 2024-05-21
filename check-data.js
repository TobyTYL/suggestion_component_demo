db = connect("mongodb://localhost:27017/state_suggestion");

print("Listing all states:");
db.states.find().forEach(printjson);
