# SQL Data Preparation and Analysis

This folder contains the MySQL scripts used to transform the Online
Shoppers Purchasing Intention Dataset into an analysis-ready session
table and calculate conversion metrics for reporting and visualization.

## Files

| File | Description |
|---|---|
| `01_create_cleaned_table.sql` | Renames variables, converts binary fields, creates derived variables, and validates the cleaned table |
| `02_create_summary_views.sql` | Creates reusable views for conversion analysis by visitor type, traffic source, month, and engagement level |

## Requirements

- MySQL Server
- MySQL Workbench
- Online Shoppers Purchasing Intention Dataset

## Data Source

The original dataset can be downloaded from the UCI Machine Learning
Repository:

[Online Shoppers Purchasing Intention Dataset](https://archive.ics.uci.edu/dataset/468/online+shoppers+purchasing+intention+dataset)

The original data is not stored in this repository.


## Notes

- Each row represents one website browsing session.
- `converted` indicates whether the session resulted in a purchase.
- Engagement groups are derived from time spent on product-related pages.
- Operating system, browser, region, and traffic-source values are
  anonymized categorical IDs.
- The dataset does not provide a public mapping from traffic-source IDs
  to named marketing channels.
