# Amazon Bluetooth Speaker Comparison Analysis:

## Relevant Links:
- Colab Notebook: https://colab.research.google.com/drive/1TSaVx5vnQtEjOWuK7mcOADBBtNFkY9uE?usp=sharing
- Tableau Dashboard: https://public.tableau.com/views/Amz-revs-analysis_2/ExecutiveSummary?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
## Project Overview:
Analyzed Amazon customer reviews for five premium wireless speakers:

- Beats Pill
- JBL Charge 5
- Bose Soundlink Flex
- Marshall Emberton II
- Sony ULT Field

This project combines the following:

- PostgreSQL
- NLP Sentiment Analysis (TextBlob, Python)
- Tableau (Visualisations)
- Product Analytics (EDA, data preprocessing, Gemini API integration)

The overall goal was to determine general customer satisfaction and compare how the Beats Pill stacks up against these similar competitor products and what brand positioning they should take if they were to reenter the market with a premium wireless speaker product.

## Business Question:

How does the Beats Pill compare against Bluetooth speakers in terms of:
- Customer ratings
- Review engagements
- Sentiment
- Review Volume
- Customer feedback quality

## Data Pipeline:

Raw Amazon Reviews
        ↓
PostgreSQL Cleaning
        ↓
Product Selection
        ↓
Sentiment and Exploratory Data Analysis (Python)
        ↓
Product Summary Tables
        ↓
Tableau Dashboards

### SQL Processing:

- Removed Duplicates
- Standardised dates
- Created product lookup table (for relevant products)
- Generated KPI summary table and a monthly trend table  for relevant products
- Calculated sentiment distributions

### NLP Analysis

TextBlob was used to generate:

- Polarity scores
- Subjectivity scores

Sentiment categories:

- Positive (> 0.1)
- Neutral (-0.1 to 0.1)
- Negative (< -0.1)

## Dashboard Snapshots
- Screenshots of the Executive Summary and the Sentiment Analysis
<img width="1201" height="700" alt="Screenshot 2026-06-16 144839" src="https://github.com/user-attachments/assets/76a13397-0963-4e6e-98c0-1daea27c565f" />
<img width="1197" height="696" alt="Screenshot 2026-06-16 145316" src="https://github.com/user-attachments/assets/422d1456-5a23-44f8-abb8-091989e73d97" />

## Key Findings:
- All of the selected products scored a very high average rating between 4-5 stars
- The Beats Pill scored the lowest however it has the fewest reviews total (55) with all the others ranging 100-115, this is likely due to the fact that it was released later.
- The speakers with the highest scores in polarity tended to have the higher average ratings which is clear with the JBL Charge 5 however the differences are marginal, we can likely assume that more negative reviews offer more specificity and more positive reviews are more general in nature.
- According to our polarity classifications the JBL Charge 5 and Marshall Emberton II had only positive and neutral reviews (no negative reviews).
- The Beats Pill scored the highest overall in subjectivity despite the smaller review pool this likely means that Beats operates in a more specific niche than other speakers.

## Processes Used:
- SQL (PostgreSQL)
- Data Cleaning
- Data Modeling
- Window Functions
- Joins
- Aggregations
- NLP Sentiment Analysis
- Tableau Dashboard Design
- Product Analytics
