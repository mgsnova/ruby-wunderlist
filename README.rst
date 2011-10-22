ruby-wunderlist
===============

ruby-wunderlist is an inofficial Ruby binding for the undocumented Wunderlist
API. It supports at the moment read-only access, but it works. :)

Example
-------

::
  require "wunderlist"
  api = Wunderlist::API.new
  
  # Login to Wunderlist
  api.login "johndoe@example.org", "mypassword"
  
  # Get all lists of John Doe
  lists = api.lists
  
  # Get all tasks in the first list
  # (It's a little bit complicated because lists is a Hash)
  tasks = lists.to_ary.first[1].to_ary.first
