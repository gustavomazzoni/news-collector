# News Collector
## Goal

Create a software application that aggregates news data and publishes it to Redis.

Access an URL containing a list of zip files. Each zip file contains a bunch of xml files. Each xml file contains 1 news report.

The application needs to download all of the zip files, extract out the xml files, and publish the content of each xml file to a redis list.

The application must be idempotent. Need to be able to run it multiple times but not get duplicate data in the redis list.

## Solution

* Ruby as the programming language.
* Parallelism with Thread Pooling to download files, unzip and save XML content in Redis in parallel. This have reduced the process time by at least 5x.
* Nokogiri Gem to search for zip files links inside the page's document.
* Redis for saving the news with use of SADD method so duplicated member in the list.


Gems:
* rubyzip - for open and unzip zip files
* Nokogiri - for dealing with page DOM
* Redis - client for Redis server


## Running the application
### Download the project
Download or clone the project using following command:
```sh
$ git clone https://github.com/gustavomazzoni/news-collector
```

### Install
Install project dependencies
```sh
$ bundle install
```

### Run
Before running the application, you need to start the Redis server
```sh
$ redis-server
```

Now, just run news_collector app
```sh
$ ruby news_collector.rb
```

You can also specify the URL to extract the zip links and the number of the threads to run in parallel
```sh
$ ruby news_collector.rb <URL> 20
```
