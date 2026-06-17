# Amazon Bluetooth Speaker Comparison Analysis:

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
- 

