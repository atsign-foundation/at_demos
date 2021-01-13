<img src="https://atsign.dev/assets/img/@developersmall.png?sanitize=true">

### Now for a little internet optimism

# @Protocol Hello World Demo (Incomplete Version)

This directory contains the incomplete code for the Hello World application. Complete the 
TODOs to get it working!

## Getting Started

Clone this project from the @ Company repository. Follow these steps to fill in the TODOs!

### Login screen:
1. Declare and initialize variables at the top of login_screen.dart. You will need one bool
for the async call logic, an instance of a `TextEditingController`, and an instance of 
`ServerDemoService`.
2. Set `inAsyncCall` to your boolean variable.
3. Assign `controller` and `onPressed` parameters.
4. Fill in the async _ _login_ method. Sets your boolean variable to true using setState(() {}).
If atSign != null, try the onboard() method (which is called using the `ServerDemoService` object) 
then push the Navigator to the home screen. If an error is caught, use the authenticate() method 
(passing in values to its atSign, jsonData, and decryptKey parameters) then push the Navigator to the home screen.

### Home screen:
1. Declare and initialize variables at the top of home_screen.dart You will need two Strings to
capture the key/value pair, an instance of a `TextEditingController` as well as two Strings to save
the lookup key/value pair, a `List<String>` to capture the keys that are scanned from an @server, and
an instance of `ServerDemoService`.
2. Fill in the `onChanged` functions to save the key/value pair.
3. For the `items` parameter, map each key in your `List<String>` variable to an instance of `DropDownMenuItem`
with its `value` and `child` parameters set to the key. Remember to convert this dynamic to a `List<String>` object!
4. With the following `onChanged` function, set the lookup key variable as well as the text field of your `TextEditinController`
variable to the value. 
5. Set the `value` parameter to an empty string if the `List<String>` variable is empty or the first item in the list.
6. In the `TextField` of the lookup widget, assign the `controller` parameter to the `TextEditingController` variable.
Assign the string in the `Text` widget to the lookup value variable.
7. Create the async _ _update_ method. Make an instance of `AtKey` and pass in the key variable to its `key` parameter. Assign 
the atSign to the `sharedWith` parameter. Pass this `AtKey` object into the put verb.
8. Create the async _ _scan_ method. Call the getKeys method (with its `sharedBy` parameter set to atSign) and assign the returned
list to a variable. Remove the namespace, atSign, and any other unnecessary information from the retrieved keys using the replaceAll
method (once again, use the map method to perform replaceAll on each key. Don't forget to convert the dynamic back to a list!). Set
the `List<String>` variable to the result using setState(() {}).
9. Create the async _ _lookup_ method. Make an instance of `AtKey` and populate `key` and `sharedWith` parameters with the lookup key variable
and atSign. Call get with the `AtKey` object passed in, set the return value of the get method to the lookup value variable.
10. Fill in all `onPressed` parameters with the appropriate methods.

If you finish all these steps, you are done! If any of them are confusing, feel free to reach out to us or reference the complete version
of this demo application.
