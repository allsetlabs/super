# McDVoice Survey Skill

Fill out the McDonald's Customer Satisfaction Survey at mcdvoice.com from a receipt photo and return the validation code.

## Trigger

Use when the user shares a McDonald's receipt photo and asks to fill out the survey or get a validation code.

## Process

### Step 1: Extract Receipt Data

Use the Read tool to view the receipt image. The receipt is often photographed at an angle — use `sips` + `tesseract` to rotate and OCR it:

```bash
# Try rotating 90 degrees clockwise to orient the receipt upright
sips -r 90 /path/to/receipt.jpg --out ~/Desktop/receipt_90.jpg
tesseract ~/Desktop/receipt_90.jpg ~/Desktop/receipt_ocr --psm 6
cat ~/Desktop/receipt_ocr.txt
```

Key fields to extract from OCR output:

- **Store #** — labeled "Restaurant #XXXXX" near the top
- **KS #** — labeled "KS# XX"
- **Date** — format MM/DD/YYYY
- **Time** — format HH:MM AM/PM (convert to 24h for the hour dropdown)
- **Order #** — labeled "Order XX"
- **Amount Spent** — "Take-Out Total" or "Eat-In Total" (split into dollars and cents)

### Step 2: Navigate to Survey (Alternative Entry)

Navigate to `https://www.mcdvoice.com/Index.aspx?POSType=PieceMeal`

This skips the 26-digit code requirement and uses individual receipt fields instead.

### Step 3: Fill Entry Form

| Field                         | Source                                       |
| ----------------------------- | -------------------------------------------- |
| Store #                       | Restaurant number from OCR                   |
| KS #                          | KS# value from OCR                           |
| Date month/day/year dropdowns | Visit date                                   |
| Time hour/minute dropdowns    | Visit time in 24h format                     |
| Order                         | Order number                                 |
| Amount dollars . cents        | Total spent (use 0 . 00 if free via Rewards) |

Click **Start**.

### Step 4: Answer All Survey Questions Positively

Work through each page, selecting the most positive option unless context from the receipt suggests otherwise:

| Question                                        | Answer                                                                                        |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Did you visit [location]?                       | **Yes**                                                                                       |
| How did you place your order?                   | **McDonald's Mobile app** if $0.00 (Rewards), else **With an employee**                       |
| Visit type                                      | "Take-Out Total" → **Carry out** · "Eat-In Total" → **Dine-in** · drive-thru → **Drive-thru** |
| Overall satisfaction                            | **Highly Satisfied**                                                                          |
| All satisfaction rating rows                    | **Highly Satisfied** (first radio in each row)                                                |
| Was your order accurate?                        | **Yes**                                                                                       |
| Did employee greet you / thank you for Rewards? | **Yes**                                                                                       |
| Items ordered (checkboxes)                      | Match receipt: coffee → **Beverages & Coffee**                                                |
| Beverage type                                   | "Premium Roast" → **Brewed Coffee**                                                           |
| Quality of beverage                             | **Highly Satisfied**                                                                          |
| Did you experience a problem?                   | **No**                                                                                        |
| Likelihood to return/recommend                  | **Highly Likely** (both rows)                                                                 |
| Comment box                                     | Brief positive comment, e.g. "The coffee was great and service was fast and friendly."        |
| Visits in past 30 days                          | **Four or more**                                                                              |
| Favorite fast food                              | **McDonald's**                                                                                |
| Brand trust                                     | **Strongly Agree**                                                                            |
| Demographics                                    | Skip (all optional)                                                                           |

Click **Next** after each page.

### Step 5: Return Validation Code

The final "Thank You" page shows:

> **Validation Code: XXXXXXX**

Report this 7-digit code to the user. Write it on the receipt to redeem.

**Terms:** Valid 30 days · equal or lesser value item · participating U.S. McDonald's only · one per person per visit · not valid with other offers or McDelivery.

## Tips

- If the receipt image is sideways/rotated, try `sips -r 90`, `-r 180`, or `-r 270` until tesseract produces readable text
- The survey URL `POSType=PieceMeal` works even when the receipt has a 26-digit code — faster than entering the code
- Total Savings on the receipt is NOT the amount spent — use Take-Out/Eat-In Total instead
- If store lookup fails, double-check the store number from the OCR (5 digits, e.g. "Restaurant #25208")
