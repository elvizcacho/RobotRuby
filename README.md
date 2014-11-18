# Robot developed on Ruby


This project consolidates the social media information of an artist. You add an artist then this application seeks for this one on the Last.fm API, if the artist exists, this one is added to the database and the listeners from Last.m, the popularity of Spootify, the "likes" of Facebook Fan Page and the "likes" only from Chile of this artist are shown in a table which is updated each hour. 

I used the respective APIs to get the information of Last.fm, Spotify and the "likes" from a Facebook Fan Page. However, getting the "Facebook's likes" only from Chile of an artist was not so easy. I had to program a robot to use the Facebook ads console to get this information (_scraping data from Facebook_). I realized which are the requests that Facebook does in order to get this data via Ajax and I programmed a robot which is able to log into facebook, goes to the Facebook Ads console, gets an access token which Facebook uses to send requests. Then, the robot imitates what facebook does to get the information that I needed.

I know, I could have done this easier with the Facebook Ads API, nevertheless, you have to inscribe your app in the Facebook whitelist to be able to use the API and is necessary to fill in a complete form to do this, with information about your company (something that I didn't have when I developed this app) because of this, I solved my problem in this interesting way.


* System dependencies
  - Ruby version: 2.1.2
  - Rails version: 4.1.4
  - Redis: 2.8.9
  - Postgress: 9.3

* Featured gems
  - redis
  - resque
  - resque-scheduler

* Database
  - Developement enviorement: sqlite3
  - Production enviorement: postgres


  Sebastian Vizcaino
  
  elvizcacho@gmail.com