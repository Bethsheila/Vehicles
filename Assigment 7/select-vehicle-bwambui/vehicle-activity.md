---
title: Vehicle Registrations Activity
...


# WA State Vehicle Registrations

Goal: to practice SELECTs on a single table, using:

- naming columns to SELECT
- WHERE clause filtering
- ORDER BY
- DISTINCT
- summary functions (count, min, max)
- GROUP BY groupings
- LIMIT

on a larger, real-world dataset from the WA State DMV.



## Activity

<!-- As a group activity:

Most importantly: play!

- each team member should submit (at least) 2 queries/SELECTs
- answer (at least) 3 of the below questions
- ask one question for yourself (you can answer this or not)

Submit as multiple .SQL files with comments (leading \-\- (double hyphens)) to document the question.
List/call each of the query SQL files in "query.bat". Since this is a group exercise but
team members can work independently, I suggest making one query SQL file per team member
to minimize merge conflicts. But you are free to agree on whatever file organization you
want. Just remember I will be running the query.bat to see what you've done.

![](documenting-query.png){width=60%}
-->

### Requirements

- work and submit in the GitHub repository you are invited to collaborate on
- work with VSCode and the SQLTools plugin
- submit three new queries (see sample questions for ideas)
  - at least one should use GROUP BY and a summary function
  - at least one should use DISTINCT, or the DISTINCT can be replaced with a second GROUP BY query
  - results should not be more than 10-20 lines, unless you have a good reason (I will be looking at the results, and possibly running them on the full 25 million record dataset). If there are more than 20 results, you must use ORDER BY to show the most-important rows first (and consider using LIMIT).
  - be thoughtful about the columns you select
- add one .sql file with an idea for a new query (in comments)
  - you do not have to implement this query
  - it should depend on the data in the database (for example: "most expensive car" can not be answered because the registration does not include price)

### What to do

- start a Codespace with the select-vehicle-USER you were invited to
- in Terminal, run "bash setup.sh" to create and populate the database tables
- write queries
- commit and sync
- note in Canvas



## The Database

The 50,000 records is big enough to exercise most queries you might write. There are supercars,
alternative fuel vehicles, vehicles registered out of state, etc. If you write a query and it
does not return results, do a little investigation. For fields like fuel type and electrification,
have you matched the values correctly (make a query using DISTINCT on these columns to see what
is in the database). If you don't get anything do a little work to prove that's correct. (Like:
there are very few registrations of older vehicles--this is described below.)

## Setup

The sample repository comes with two shell scripts:

- setup.sh (drops and recreates the database from the supplied .csv)
- query.sh (to automate running the queries you write)

Run "bash ./setup.sh"
It should finish with "COPY 50000" indicating it brought in 50,000 rows.


## Sample Questions

- what is the make/model of the oldest year represented in the database?
- what makes are represented in the database?
- how many vehicles per make? what is the interesting order?
- number of Tesla vehicles by model?
- are all Ferraris red?
- are most Ferraris red?
- what proportion of registered vehicles are BEVs? (Get numbers to do the division; do not give final percentage.)
- how are BEVs distributed by county?
 

## Workflow

<!--
I suggest writing most queries using the VSCode editor window.

You can work interactively in a Terminal pane by running "psql -d vehicle50k" and entering
SQL there directly. I prefer to copy/paste from the editor window because the editor provides
a lot more support, and as you work there you can commit changes and track the queries
you've written. Everything you type in the lower psql prompt disappears quickly.
-->

Use VSCode in a GitHub Codespace.

Use the SQLTools to send your SQL to the database.

Use queries to see what the dataset looks like.

Before your final submit, test your queries in the Terminal by running "bash query.sh"

Commit regularly: when you have a working query (even if you want to
clean it up), or before you start over on something.



## Introductory notes

- this is a single table; it is not normalized

- **Check your capitalization of values!** Use a SELECT DISTINCT to take samples from the database. PostgreSQL downcases unquoted column and table names, but it does not alter value data. Values must match case.

- there is something strange about older cars--write some queries to explore

### Large dataset

Some hints on using <code>psql</code> when working with a large dataset:

- use LIMIT to make results smaller (especially in joins)
- DISTINCT is helpful in getting an idea of what values are used
- summary functions (max, min, count) are also helpful
- in psql: **use 'q' to quit the pager of long results and return to the psql command prompt**

## About the dataset(s)


From [https://data.wa.gov/Transportation](https://data.wa.gov/Transportation/Vehicle-Registration-Transactions-by-Department-of/brw6-jymh)

25M records; 6GB, covering the years are 2020-2025, inclusive.

Each row represents someone registering their vehicle for that
date. Registrations usually last one year, so it may be that a vehicle
is represented three times (or more?)  in the full dataset. For the
smaller datasets, they represent only one week or month, so the vehicles are
probably unique.

### Smaller

There are two smaller datasets. They are faster to experiment with,
and because they do not cover multiple years, the vehicles in the
database are probably unique.

- vrt50k.csv: 11MB; 50,000 records
- vrt_2023-09.csv: 120MB, 550k records

The vrt50k is included in your repository; the larger is available on Canvas.

vrt_2023-09.csv has all/only registrations from September, 2023.

vrt50k.csv has a random 50,000 records from September, 2023.


### Schema

Create the database table:

```sql
CREATE TABLE registration (
    TransactionDate DATE,
    Make VARCHAR,
    Model VARCHAR,
    MYear INTEGER,
    Color VARCHAR,
    Type VARCHAR,
    Use VARCHAR,
    FuelTypePrimary VARCHAR,
    GVWRClass VARCHAR,
    GVWRRange VARCHAR,
    FuelTypeSecondary VARCHAR,
    Electrification VARCHAR,
    PlateBackground VARCHAR,
    PlateConfiguration VARCHAR,
    OwnerType VARCHAR,
    County VARCHAR,
    State VARCHAR,
    PostalCode VARCHAR,
    TransactionType VARCHAR,
    TransactionChannel VARCHAR,
    CensusTract VARCHAR,
    TransactionCount VARCHAR
);
```



or

```
SET datestyle TO 'ISO, MDY';
\COPY registration FROM 'vrt50k.csv' CSV;
```


## Example query

```
SELECT DISTINCT make, model FROM registration ORDER BY model DESC LIMIT 10 ;
```

```
SELECT myear, count(myear) FROM registration WHERE myear < 1990 GROUP BY myear ORDER BY myear ;
```


## Extras

### Importing other datasets

Starting with the table you created from the description above:

- download your desired .csv file from Canvas or WA data.gov
- move the downloaded file into your project directory (it is easier to copy without paths)
- \\COPY the data (use the backslash!) into your table


```
SET datestyle TO 'ISO, MDY';
\COPY registration FROM 'vrt_2023-09.csv' CSV HEADER;
```


The full dataset is big, but the database handles it OK with indexes.
(It takes about 5 minutes to load from a fast SSD; similar time to index.)

For full dataset:

```
SET datestyle TO 'ISO, MDY';
\COPY registration FROM 'Downloads/Vehicle_Registration_Transactions_by_Department_of_Licensing_20231103.csv' CSV HEADER
```

Queries are much faster if you index the interesting columns:

```
CREATE INDEX ON registration(make);
CREATE INDEX ON registration(model);
CREATE INDEX ON registration(transactiondate);
CREATE INDEX ON registration(electrification);
```

(The indexes are only needed if you have the full database.)


### Related Data

Some county-level questions are more interesting if you know the population
of the county, which can vary widely.

I have not found a county-level population on data.wa.gov, but there are some tables here:

https://ofm.wa.gov/washington-data-research/population-demographics/population-estimates/historical-estimates-april-1-population-and-housing-state-counties-and-cities

They are in Excel format on a separate worksheet and have the common
1NF violation of having a different column for each year. But they could
be adapted and loaded into this database if anyone is interested in trying out JOINs.