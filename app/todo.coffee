Tasks = new (Mongo.Collection)('tasks')

# This code only runs on the client
if Meteor.isClient

  Template.body.helpers

    tasks: ->
      if Session.get('hideCompleted')
        Tasks.find { checked: $ne: true }, sort: createdAt: -1
      else
        Tasks.find {}, sort: createdAt: -1

    hideCompleted: ->
      Session.get 'hideCompleted'

  Template.body.events

    'submit .new-task': (event) ->
      event.preventDefault()
      text = event.target.text.value

      Meteor.call("addTask", text)

      event.target.text.value = ''

    'click .toggle-checked': ->
      # Set the checked property to the opposite of its current value
      return Meteor.call("setChecked", @_id, !@checked)

    'click .delete': ->
      return Meteor.call("deleteTask", @_id)

    'change .hide-completed input': (event) ->
      return Session.set 'hideCompleted', event.target.checked

  Accounts.ui.config passwordSignupFields: 'USERNAME_ONLY'

Meteor.methods
  addTask: (text) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-authorized")

    Tasks.insert
      text: text
      owner: Meteor.userId()
      username: Meteor.user().username
      createdAt: new Date

  deleteTask: (taskId) ->
    Tasks.remove(taskId)

  setChecked: (taskId, setChecked) ->
    Tasks.update(taskId, { $set: {checked: setChecked } })



