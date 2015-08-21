Tasks = new Mongo.Collection("tasks");

if (Meteor.isClient) {
  // This code only runs on the client
  Template.body.helpers({
    tasks: function() {
      if (Session.get("hideCompleted")) {
          return Tasks.find({checked: {$ne: true}}, { sort: { createdAt: -1 }});
        } else {
          return Tasks.find({}, { sort: { createdAt: -1 }});
      };
    },

    hideCompleted: function() {
      return Session.get("hideCompleted");
    }
  });

 Template.body.events({
   "submit .new-task": function(event) {
     event.preventDefault();

     var text = event.target.text.value;

     Tasks.insert({
       text: text,
       createdAt: new Date()
     });

     event.target.text.value = "";
   },

   "click .toggle-checked": function () {
      // Set the checked property to the opposite of its current value
      Tasks.update(this._id, {
        $set: {checked: ! this.checked}
      });
    },

    "click .delete": function () {
      Tasks.remove(this._id);
    },

    "change .hide-completed input": function(event) {
      Session.set("hideCompleted", event.target.checked);
    }
 });
}
