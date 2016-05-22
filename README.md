# fluxday
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

fluxday is a task & productivity management application ideal for fast growing startups and small companies. fluxday was developed by Foradian starting in 2014 and was a critical part of the company’s [hyper growth and success](http://www.fedena.com/history). fluxday was opensourced by [Foradian](http://foradian.com) in May 2016 to help more startups use the power of a no-nonsense productivity tracking tool.

fluxday is engineered based on the concepts of [OKR](https://en.wikipedia.org/wiki/OKR) - Objectives and Key Results, invented and made popular by  John Doerr. OKRs and OKR tools are used today by many companies, including Google, LinkedIn and Twitter

## You can use fluxday for
- Managing and Tracking OKRs
- Creating, assigning and tracking tasks
- Maintaining log of time spent by employees
- Generating different types of reports, and in different formats
- Analyzing progress and productivity of your company, its departments, teams and employees
- OAuth server with filtered access to users

> “through discipline comes freedom” - aristotle

## License
Fluxday is released under [Apache License 2.0](https://github.com/foradian/fluxday/blob/master/LICENSE)

## Installation
### Dependencies
- Ruby 2.1.0
- MySQL or MariaDB server
- Imagemagick
- wkhtmltopdf (To be downloaded from [this website](http://wkhtmltopdf.org/) and placed in lib folder)

### Clone Fluxday
```sh
git clone https://github.com/foradian/fluxday.git  
```
### Install bundler and required gems
Once the specified version of Ruby is installed with all its dependencies satisfied, run the following command from the root directory of the application.
```sh
gem install bundler
bundle install
```
### Configure application

For google authentication, you need to set up the corresponding key, secret, callback url etc. The application loads these informations from the file config/app_config.yml
The sample configuration is available at [config/app_config.yml.example](https://github.com/foradian/fluxday/blob/master/config/app_config.yml.example) (You can simply copy this file to app_config.yml to run Fluxday without google authentication).
```sh
cp config/app_config.yml.example config/app_config.yml
```
### Create and configure database
Modify the database credentials in [config/database.yml](https://github.com/foradian/fluxday/blob/master/config/database.yml) . Now you can create the database and perform migrations
```sh
rake db:create
rake db:migrate
```
Fluxday will populate the database with an admin user entry when we run the seed.
```sh
rake db:seed
```
### Start the application
You can start the Rails server using
```sh
rails server
```
Fluxday can be accessed from the browser by navigating to [http://localhost:3000]().
#### Initial login credentials:
Email: admin@fluxday.io

Password: password
