# fluxday

fluxday is a task & productivity management application ideal for fast growing startups and small companies. fluxday was developed by Foradian starting in 2014 and was a critical part of the company’s [hyper growth and success](http://www.fedena.com/history). fluxday was opensourced by [Foradian](http://foradian.com) in May 2016 to help more startups use the power of a no-nonsense productivity tracking tool.

fluxday is engineered based on the concepts of [OKR](https://en.wikipedia.org/wiki/OKR) - Objectives and Key Results, invented and made popular by  John Doerr. OKRs and OKR tools are used today by many companies, including Google, LinkedIn and Twitter

## You can use fluxday for
- Managing and Tracking OKRs
- Creating, assigning and tracking tasks
- Maintaining log of time spent by employees
- Generating different types of reports, and in different formats
- Analyzing progress and productivity of your company, its departments, teams and employees
- OAuth server with filtered access to users

Visit the [official website](http://fluxday.io) for more info		

> “through discipline comes freedom” - aristotle

## License
Fluxday is released under [Apache License 2.0](https://github.com/foradian/fluxday/blob/master/LICENSE)

## Live demo
Try Fluxday before downloading. Use the email-id and password given below to login as different types of users like Administrator, Team Lead and Employee.

Please note that the demo will automatically reset every 2 hours.

| User role  | Email | Password |
| ------------- | ------------- |------------- |
| Admin user  | admin@fluxday.io  | password |
| Team lead  | lead@fluxday.io  | password |
| Employee 1  | emp1@fluxday.io  | password |
| Employee 2  | emp2@fluxday.io  | password |

### [Live demo](https://app.fluxday.io)

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
Once the specified version of Ruby is installed with all its dependencies satisfied, run the following command from the root directory of the application. (You can skip this section if you are using docker)
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

#### 1. With docker
```sh
cp config/database.yml.example config/database.yml
cp app.env.example app.env
```
Database configurations relies on the file app.env . After above steps update this file with actual credentials.

#### 2. Without docker
```sh
cp config/database.yml.example config/database.yml
```
Update the credentials in database.yml with actual values.

Now you can create the database and perform migrations
```sh
rake db:create
rake db:migrate
```
Fluxday will populate the database with an admin user entry when we run the seed.
```sh
rake db:seed
```
### Start the application

#### 1. With docker
Start container with:
```sh
docker-compose up -d --build --remove-orphans
```

And to access the container:

```sh
docker exec -it fluxday /bin/bash
```

#### 2. Without docker
You can start the Rails server using
```sh
rails server
```


Fluxday can be accessed from the browser by navigating to [http://localhost:3000]().
#### Initial login credentials:
Email: admin@fluxday.io

Password: password

## Screenshots
###### Dashboard - View tasks and work logs for a selected day. You can switch between month and week views.

![Dashboard](http://fluxday.io/img/screenshots/dashboard_day.jpg "Dashboard")


###### Departments and Teams - Create and manage departments. Create teams within departments and add members and leads to the teams.

![Departments and Teams](http://fluxday.io/img/screenshots/department.jpg "Departments and Teams")


###### OKR - Create and manage OKRs for a user. Set custom duration for each OKR that align to your team requirements.

![OKR](http://fluxday.io/img/screenshots/okr_view.jpg "OKR")


###### Add tasks - Create tasks for users. Enter duration, map to key result and set priority for the task.

![Add tasks](http://fluxday.io/img/screenshots/add_task.jpg "Add tasks")


###### Task view - View details of tasks like assigned users, duration and priority. You can also add subtasks from here.

![Task view](http://fluxday.io/img/screenshots/task_view.jpg "Task view")


###### Reports - Generate visual and textual reports to view performance of users. Chose between OKR, Worklogs, Tasks and Assignment based reports for an employee or employee groups.

![Reports](http://fluxday.io/img/screenshots/okr_report_hi_res.jpg "Reports")
