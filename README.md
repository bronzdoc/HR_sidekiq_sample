# Sales Management System API (Ruby on Rails + Sidekiq)

## Project Specifications

**Read-Only Files**
- spec/*

**Environment**  

- Ruby version: 3.2.2
- Rails version: 7.0.0
- Sidekiq + Redis
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
bin/bundle exec sidekiq
```
- install: 
```bash
bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

In this challenge, you are part of a team that is building a Sales Management System. One requirement is for a REST API service to import sales records using the Rails framework and the background processing engine Sidekiq. You will need to add functionality to import sales records to the system from a CSV file in a background process as well as fetch sales records via API. The team has come up with a set of requirements including API format, response codes, and data validations.

The definitions and detailed requirements list follow. You will be graded on whether your application performs data processing and runs background jobs based on given use cases exactly as described in the requirements.

Each sale has the following structure:

- id: The unique ID of the sale.
- region: The name of the region where sale has been made.
- country: The name of the country where sale has been made.
- channel: The sales channel.
- item_type: The name of the item sold.
- order_date: The date when the order has been placed.
- order_id: The ID of the order.
- units: The number of units sold.
- unit_price_in_cents: The price in cents of a single unit that has been sold.
- total_revenue_in_cents: The total revenue in cents made by selling units.

### Sample sale JSON:

```
{
  id: 1,
  channel: "Offline",
  country: "Tuvalu",
  item_type: "Baby Food",
  order_date: "2014-05-01",
  order_id: "669165933",
  region: "Australia and Oceania",
  total_revenue_in_cents: 255280,
  unit_price_in_cents: 25528,
  units: 10
}
```

An incoming CSV file has following structure:

| Region                | Country | Item Type | Sales Channel | Order Date | Order ID  | Units Sold | Unit Price | Total Revenue |
|-----------------------|---------|-----------|---------------|------------|-----------|------------|------------|---------------|      
| Australia and Oceania | Tuvalu  | Baby Food | Offline       | 2014-05-01 | 669165933 | 100        | 255.28     | 25528         |
| Central America       | Grenada | Cereal    | Offline       | 2014-05-03 | 899001122 | 100        | 21.35      | 2135          |

**Note that the CSV file specifies money in full units, not in cents.**

## Requirements:

`POST /sales/import`:

* The endpoint receives a payload in the following format:
  ```
  {
    file: <UploadedFile>
  }
  ```
* The endpoint should validate the following conditions:
  * The file should be present
  * The file should be a CSV file
* If any of the above requirements fail, the server should return response code 422.
* If an incoming file is correct, the server should return 200 and the following JSON response, where `job_id` is the id of a Sidekiq background job that processes the file.:
  ```
  {
    job_id: "JOB_ID"
  }
  ```
* Sales should be imported in a background job. The following conditions for every sale record must be satisfied:
  * All fields are required
  * _units_ can't be a negative number
  * _unit_price_in_cents_ can't be a negative number
  * _total_revenue_in_cents_ can't be a negative number
* If any sales record does not satisfy the conditions above, then the background job should fail and nothing from the file should be persisted to the database.     

The application already implements the `GET /sales` endpoint, which returns all sales existing in the system.

**In this project, you should use Sidekiq for implementing background jobs.**


## Sample requests and responses

`POST /sales/import`

Example request:
```
{
  "file": <UploadedFile filename="sales.csv">
}
```

Response:
```
{
  "job_id": "3abcc0f973de689d6eba4f28"
}
```

`GET /sales`

Response:

```
[
 {
   id: 1,
   channel: "Offline",
   country: "Tuvalu",
   item_type: "Baby Food",
   order_date: "2014-05-01",
   order_id: "669165933",
   region: "Australia and Oceania",
   total_revenue_in_cents: 2552800,
   unit_price_in_cents: 25528,
   units: 100
 },
 {
   id: 2,
   channel: "Offline",
   country: "Grenada",
   item_type: "Cereal",
   order_date: "2014-05-03",
   order_id: "899001122",
   region: "Central America and the Caribbean",
   total_revenue_in_cents: 213500,
   unit_price_in_cents: 2135,
   units: 100
 }
]
```
