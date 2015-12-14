# Cookbook Buckets

This is a Cookbook app demo used to manage cookbook and related materials, the detail requirements can be found [here (need permission)](https://docs.google.com/document/d/1HqX8f2sNsYNC5bJYuQCouFjFU0c4zcYv4QDEQTpslKs). Each cookbook contains:

* Name
* One image
* Description
* Multiple tags
* Multiple materials

And each materials in cookbook contains:

* Name
* Quantity
* Unit

User can search cookbook by its name, description, tag name and material name.

The app is deployed on [heroku](http://cookbook-buckets.herokuapp.com/), and image is currently saving on [Qiniu](http://qiniu.com/).

## Known Issues and not implemented requirements

* Show/Edit/Search is in modal instead of separated page.
* Upload to Google sheet is not implemented.
* The list will be reloaded after every modify request, will change to only update modified records and avoid reloading the whole list.
* Add validator for input fields.
* Promot confirmation for delete operation.



