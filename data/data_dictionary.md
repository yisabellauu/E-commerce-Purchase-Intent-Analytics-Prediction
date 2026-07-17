# Data Dictionary

This project uses the Online Shoppers Purchasing Intention Dataset. Each
row represents one website browsing session.

| Variable | Description |
|---|---|
| `session_id` | Unique identifier created for each browsing session |
| `administrative_pages` | Number of administrative pages visited during the session |
| `administrative_duration_seconds` | Time spent on administrative pages, measured in seconds |
| `informational_pages` | Number of informational pages visited during the session |
| `informational_duration_seconds` | Time spent on informational pages, measured in seconds |
| `product_related_pages` | Number of product-related pages visited during the session |
| `product_related_duration_seconds` | Time spent on product-related pages, measured in seconds |
| `bounce_rate` | Estimated percentage of visitors who entered and left from the page without further interaction |
| `exit_rate` | Estimated percentage of pageviews that ended the browsing session |
| `page_value` | Average value of a page visited before completing a transaction |
| `special_day` | Closeness of the session date to a special shopping day |
| `month_name` | Month in which the browsing session occurred |
| `month_order` | Numeric value used to sort months chronologically |
| `operating_system_id` | Anonymized code representing the visitor’s operating system |
| `browser_id` | Anonymized code representing the visitor’s browser |
| `region_id` | Anonymized code representing the visitor’s geographic region |
| `traffic_source_id` | Anonymized code representing the source through which the visitor arrived |
| `visitor_type` | Visitor category, such as returning, new, or other |
| `is_weekend` | Binary indicator: `1` for weekend sessions and `0` otherwise |
| `converted` | Target variable: `1` if the session resulted in a purchase and `0` otherwise |
| `engagement` | Product-page engagement category based on session duration |
| `engagement_order` | Numeric value used to sort engagement categories |

## Important Notes

- `converted` is derived from the original `Revenue` variable.
- The operating system, browser, region, and traffic-source variables are
  anonymized categorical IDs.
- The dataset does not provide a public mapping from traffic-source IDs to
  named marketing channels.
- `engagement` is a project-derived variable based on time spent on
  product-related pages.
