# README

This is a repo to reproduce an issue on Rails 6 where you are not able to run System tests driven by Poltergeist
using `ActionDispatch::SystemTestCase` without chrome installed on the system.

To reproduce in your machine, you should make sure that chrome is not present on the expected paths.

On Mac, you can rename your Google Chrome or Chromium application to another name.
E.g.: `mv /Applications/Google\ Chrome.app /Applications/Google\ Chrome-moved.app`

If you are on linux, do a `which chrome` and rename the binary to something else.

The exception that happens when you don't have chrome in your system is:

```sh
rails aborted!
Webdrivers::BrowserNotFound: Failed to find Chrome binary.
/Users/jcoel001/src/test/issue-poltergeist/test/application_system_test_case.rb:4:in <main>'
/Users/jcoel001/src/test/issue-poltergeist/test/system/home_test.rb:1:in `<main>'
/Users/jcoel001/src/test/issue-poltergeist/bin/rails:9:in `<top (required)>'
/Users/jcoel001/src/test/issue-poltergeist/bin/spring:15:in `<top (required)>'
bin/rails:3:in `load'
bin/rails:3:in `<main>'
Tasks: TOP => test:system
```