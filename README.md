# Social Site's page management app
 Primary focus of this app is to be a single platform for multiple social app page/group management(like: [buffer_link](https://www.buffer.com) ). Till now user can manage post of facebook only ,gradually other social app will also integerated.

### Feature Provided by app
1. Facebook
* see page feed data with images
* post in page with multiple image upload support
* set time to post, which will used to post in social app after time delayed
* see total likes and comment

2. Twitter
* see twitter feed data 
* post in twitter with multiple image upload support
* set time to post, which will used to post in social app after time delayed
* see total retweet and like 

3. Instagram
* see instagram feed data with images
* see total likes and comments


### App Requirement
* Ruby 2.4.2 
* Rails 5.2.1
* Postgresql database 
* Redis-server

#### App Installation
* Change .env.sample file to .env and update value insde this file(eg: FACEBOOK_APP_ID, FACEBOOK_APP_SECRETE, DATABASE_USERNAME, DATABASE_PASSWORD etc) 
* Run 'rails db:setup'
* Run 'rails db:migrate'
* Run 'rials server'
