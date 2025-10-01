# Blinkit Sales Analytics

Digging into 8,523 retail transactions to answer one question: Where should Blinkit expand next?

## What This Project Does

Analyzes sales data from 10 Blinkit outlets across India to figure out what's actually driving revenue. Spoiler: It's not what you'd expect.

Used SQL for data work, Python for statistical testing, and Power BI for dashboards (in progress).

## The Big Findings

**Tier 3 cities are outperforming everyone.** They generate 39% of total revenue despite being smaller markets. Lower competition, better penetration. This is where growth should happen.

**Medium-sized outlets are the sweet spot.** They pull in 42% of sales. Small stores are too cramped, large ones waste space. Medium is optimal.

**Visibility beats quality.** High-rated products don't necessarily sell more, but visible products do. Shelf placement matters more than product reviews.

**One format dominates.** Supermarket Type1 drives 65% of revenue. It works everywhere. Replicate this, not the other formats.

**Customer preferences are consistent.** People want the same things whether they're in Tier 1, 2, or 3. Same low-fat to regular ratio works everywhere. Keep it standardized.

## Files in This Repo
blinkit-sales-analytics/
├── data/
│   └── blinkit_data.csv           # Raw data, 8,523 rows
├── sql/
│   ├── analysis.sql               # All queries, 10 KPIs
│   └── key_findings.txt           # What the queries revealed
├── python/
│   ├── statistical_analysis.ipynb # Stats tests
│   ├── requirements.txt           # Dependencies
│   └── results_summary.txt        # Statistical findings
├── powerbi/
│   └── dashboard.pbix             # Coming soon
└── images/
└── project_overview.png       # Project flow diagram


## Quick Stats

Total sales: $1.20 million  
Best outlet: $133K revenue  
Worst outlet: $74K revenue  
Top product category: Fruits & Vegetables ($178K)  
Low-fat products: 64.6% of sales  

## What the Numbers Say

### By Location
Tier 3 cities: $472K (39%)  
Tier 2 cities: $393K (33%)  
Tier 1 cities: $336K (28%)  

Yeah, Tier 1 underperforms. That's the reality.

### By Outlet Size
Medium: $508K (42%)  
Small: $445K (37%)  
Large: $249K (21%)  

Large outlets are inefficient. They cost more but don't generate proportional revenue.

### By Format
Supermarket Type1: $788K (66%)  
Grocery Store: $152K (13%)  
Supermarket Type2: $131K (11%)  
Supermarket Type3: $131K (11%)  

Type1 is the winning formula. Everything else is secondary.

## Statistical Tests Run

Checked correlations between sales and visibility, weight, rating. All came back weak or insignificant. Continuous variables don't drive sales.

Ran chi-square tests on fat content vs location and item type vs outlet type. No significant relationships. Preferences are standardized.

What this means: Sales are driven by outlet characteristics (type, size, location), not individual product features.

## What to Do About It

**Now:**  
Boost visibility for products below 10% shelf space  
Figure out why OUT035 works so well and copy it  
Consider dropping Breakfast and Seafood categories (lowest performers)  

**Next 3-6 months:**  
Open 3 medium Supermarket Type1 outlets in Tier 3 cities  
Standardize operations based on top performers  
Set up monthly tracking dashboard  

**Next 6-12 months:**  
Expand Tier 3 by 40% (adds ~$400K revenue)  
Convert weak formats to Type1  
Exit bottom categories entirely  

Projected impact: +$450K revenue, 37% growth.

## How to Use This

**SQL:**  
Load `data/blinkit_data.csv` into PostgreSQL, run `sql/analysis.sql` line by line.

**Python:**  
```bash
cd python/
pip install -r requirements.txt
jupyter notebook statistical_analysis.ipynb 

```

Power BI: Coming soon.


Technical Stuff I Used
SQL: Window functions (RANK, PARTITION BY), CTEs, running totals
Python: Pandas, SciPy, correlation tests, chi-square tests
Stats: Pearson correlation, chi-square independence tests, descriptive stats
Cleaned 1,463 null values, standardized inconsistent categories, validated data quality.

What This Project Taught Me
Window functions in SQL are incredibly clean for rankings and cumulative calculations. Way better than nested subqueries.
Statistical significance matters. Just because two things look related doesn't mean they are. The chi-square tests proved many assumptions wrong.
Simple analysis often beats complex models. Grouping sales by category answered the key questions. Fancy algorithms aren't always necessary.
Context is everything. The weak visibility correlation seemed wrong until I realized it's probably a threshold effect, not linear.

Honest Limitations
No time-series breakdown (only have yearly data)
No customer demographics (can't segment by age, income, etc)
No profitability analysis (only have revenue, not costs)
Correlation doesn't prove causation
Only looked at linear relationships

What's Next
Add seasonal analysis if monthly data becomes available
Build predictive model for new outlet performance
Test visibility thresholds to find the optimal level
Create A/B test framework for product placement

Dataset Info
8,523 transactions from 2011-2022
10 outlets across 3 location tiers
16 product categories
12 variables including sales, visibility, weight, ratings
Data quality: 17% nulls in item weight (handled), rest complete.

Connect
Have questions? Want to discuss findings? Reach out.
Email: adeyemiboluwatife.olayinka@gmail.com
License
MIT License. Use it, learn from it, just give credit.

If this helped you, drop a star ⭐