# Book Sales Program Effectiveness Analysis (2019)

## Project Overview

This project analyzes a 2019 book sales dataset to evaluate whether a new book promotion program successfully increased sales. The dataset (`sales2019.csv`) contains customer purchase records including book titles, order quantities, customer types, review text, and sale dates.

The analysis covers the full data workflow: cleaning and imputing missing values, classifying customer reviews as positive or negative, formatting date columns, and comparing pre- and post-program sales figures. The key cutoff date is **July 1, 2019**, which marks the start of the new book program.

---

## Research Questions

1. Did the new book program lead to an overall increase in books sold after July 1, 2019?
2. Did the program's effect differ between individual customers and business customers?
3. Did customer review sentiment improve after the program launched?

---

## Methodology and Technical Workflow

**Step 1 — Load and Explore the Data**

The dataset is loaded using `read.csv()` and inspected with `head()`, `view()`, `colnames()`, `nrow()`, and `ncol()` to understand its structure and identify potential data quality issues.

**Step 2 — Clean the Data**

Two data quality issues are addressed:
- Rows with blank or whitespace-only entries in the `user_submitted_review` column are removed using `filter()` with `trimws()`.
- Missing values in `total_purchased` are imputed with the column mean using `mutate()` and `ifelse()`.

**Step 3 — Classify Reviews**

A custom function `is_positive_review()` is created using `str_detect()` and `case_when()` to flag reviews containing positive phrases such as `"Awesome!"`, `"learned"`, or `"Never read a better book"` as `TRUE`. A new column `Positive_review` is added to the dataset using `mutate()`.

**Step 4 — Format Dates and Create Grouping Variable**

The `date` column is converted from string to date format using `mdy()` from the `lubridate` package. A new boolean column `pre_july` is created with `if_else()` to indicate whether each sale occurred before or after July 1, 2019.

**Step 5 — Summarize and Compare**

Three summary tables are generated using `group_by()` and `summarize()`:
- Total books sold before vs. after July 1
- Total books sold by date group and customer type
- Total positive reviews before vs. after July 1

---

## Key Findings

### Overall Sales
| Period | Total Books Sold |
|---|---|
| Before July 1, 2019 | 8,525 |
| After July 1, 2019 | 8,642 |

The program resulted in a **net increase of 117 books sold**, suggesting a modest but positive overall effect.

### Sales by Customer Type
| Period | Business | Individual |
|---|---|---|
| Before July 1, 2019 | 5,897 | 2,628 |
| After July 1, 2019 | 5,872 | 2,770 |

Business sales **declined by 25 units** after the program launched, while individual sales **increased by 142 units**. The program appears to have driven growth exclusively among individual customers, with no benefit — and a slight negative effect — for business customers.

### Review Sentiment
| Period | Positive Reviews |
|---|---|
| Before July 1, 2019 | 684 |
| After July 1, 2019 | 658 |

The number of positive reviews **decreased by 26** after the program launched, suggesting that customer sentiment did not improve alongside sales.

### Summary

The new book program had a mixed outcome. While it succeeded in growing individual customer sales, it did not improve business sales or review sentiment. Further investigation into why business purchases declined and what drove the drop in positive reviews would be valuable next steps.

---

## Requirements and Setup

**Language:** R (version 4.0 or higher recommended)  
**IDE:** RStudio

**Required packages:**

```r
install.packages("tidyverse")
install.packages("lubridate")
```

| Package | Use |
|---|---|
| `tidyverse` | Data cleaning, filtering, transformation, and summarization |
| `lubridate` | Parsing and converting date strings |
| `purrr` | Functional programming utilities |
| `stringr` | String detection for review classification |

**To run the analysis:**

1. Download `sales2019.csv` and note its file path
2. Open the project script in RStudio
3. Update the file path in `read.csv()` to match your local machine
4. Run `install.packages("tidyverse")` and `install.packages("lubridate")` if not already installed
5. Run the script from top to bottom to reproduce all results
