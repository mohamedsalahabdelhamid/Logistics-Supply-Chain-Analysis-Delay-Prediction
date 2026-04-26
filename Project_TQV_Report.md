# 🚚 Logistics Supply Chain Analysis & Delay Prediction
## Comprehensive Data Mining Project Report (TQV Framework)

**Course:** Data Mining & Logistics Operations  
**Date:** March 2026  
**Framework:** Technical, Quality, Value (TQV) Standard  
**Dataset Period:** March 2019 – December 2020 (21 months)  
**Dataset Size:** 6,880 shipment records × 32 features  

---

## 📑 Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Technical Foundation (T)](#2-technical-foundation-t)
    - 2.1 Database Architecture & Schema Design
    - 2.2 Schema Normalization & Referential Integrity
    - 2.3 Advanced SQL Query Implementation (10 Queries)
    - 2.4 CRUD Operations Demonstration
    - 2.5 Machine Learning: Random Forest Delay Prediction
3. [Data Quality & Preprocessing (Q)](#3-data-quality--preprocessing-q)
    - 3.1 Initial Data State Assessment ("The Before")
    - 3.2 Missing Values Strategy (Column-by-Column Plan)
    - 3.3 Data Cleaning Pipeline (6-Stage Transformation)
    - 3.4 Feature Engineering (6 Engineered Features)
    - 3.5 Duplicate Detection & Key Integrity
    - 3.6 Validity Rules & Impossible Values
    - 3.7 Category Cleanliness Audit
4. [Exploratory Data Analysis Results](#4-exploratory-data-analysis-results)
    - 4.1 Univariate Analysis: Numeric Distributions & Outlier Assessment
    - 4.2 Categorical Analysis: Top Categories & Rare Values
    - 4.3 Temporal Trends: Monthly Volume & Delay Rate
    - 4.4 Bivariate Analysis: Correlation Matrix & Scatter Plots
    - 4.5 Category-vs-Numeric: GPS Provider Impact on Delays

    - 4.6 Category-vs-Category: Vehicle Type × Delivery Status Crosstab

    - 4.7 Multivariate Temporal Heatmap: Monthly Delay Risk

    - 4.8 Customer & Supplier Deep Dive

    - 4.9 Vehicle Type Performance Dashboard

5. [Actionable Business Value (V)](#5-actionable-business-value-v)
    - 5.1 GPS Infrastructure Overhaul
    - 5.2 Account-Level Strategic Intervention (L&T Case Study)
    - 5.3 The August 2020 Breakthrough
    - 5.4 Machine Learning Model Deployment
6. [Final EDA Summary: Top 5 Insights, Problems & Next Steps](#6-final-eda-summary)
7. [Conclusion & 6-Month Strategic Roadmap](#7-conclusion--6-month-strategic-roadmap)

---

## 📄 1. Executive Summary

This report presents a comprehensive technical and operational evaluation of a 21-month logistics dataset spanning March 2019 to December 2020, covering 6,880 shipment records across 32 operational features. The project was conducted through two parallel deliverables:

1. **A relational SQL database** built from 12 interconnected CSV data files, implementing a fully normalized schema with 10 analytical queries.
2. **A full Exploratory Data Analysis (EDA)** on a transportation tracking dataset, covering all 20 required analytical questions (Sections A–E), followed by a predictive machine learning model.

### Key Findings
The analysis reveals a logistics network in **systemic crisis**, with a **68.1% overall delay rate** — meaning more than 2 in 3 shipments arrive late. However, through rigorous data cleaning, architectural normalization, and predictive modeling, we have identified a clear, data-driven path to operational excellence:

| Finding | Impact |
|---|---|
| GPS Provider is the #1 predictor of delays | VAMOSYS achieves ~87.8% on-time vs. 10-15% for manual/CONSENT TRACK |
| Transportation Distance strongly correlates with delay | Trips over 1,000km have significantly higher failure rates |
| L&T accounts for 57%+ of shipment volume | With an ~80% delay rate, this is the key intervention point |
| August 2020 proved the network CAN perform | 34.6% delay rate under peak load (1,626 trips) — a proof of concept |
| Data quality issues affect ~14% of records | Missing GPS telemetry, 1899 epoch dates, and impossible durations |

---

## 🏗 2. Technical Foundation (T)

*The technical core of the project focuses on infrastructure robustness, query sophistication, and predictive capability.*

### 2.1 Database Architecture & Schema Design

The database (`LogisticsDataMiningProjDB`) was designed using a layered architecture that separates reference data, core entities, and transactional data:

**Layer 1 — Reference/Lookup Tables (Created First):**
| Table | Purpose | Rows |
|---|---|---|
| `Countries` | Country reference data | 250 |
| `ShipmentStatusLookup` | Standardized status values (Created, Arrived, Departed, Out for Delivery, Delivered, Failed) | 6 |
| `FailureReasonLookup` | Standardized failure reasons (20 codes: Customer Not Available, Wrong Address, Weather Conditions, etc.) | 20 |
| `MaterialLookup` | Standardized cargo material types (Auto Parts, Steel Coils, Electronics, etc.) | 100 |

**Layer 2 — Core Entity Tables:**
| Table | Purpose | Rows |
|---|---|---|
| `Hubs` | Logistics hub/warehouse locations | ~12 |
| `Customers` | Customer records (Sender/Receiver) | ~50,000 |

**Layer 3 — Staff & Fleet Tables:**
| Table | Purpose | Rows |
|---|---|---|
| `Employees` | Hub employees and staff | ~1,000 |
| `Couriers` | Delivery couriers/drivers | ~5,000 |

**Layer 4 — Transactional Tables:**
| Table | Purpose | Rows |
|---|---|---|
| `Shipments` | Core shipment records with 7 foreign keys | 100,000 |
| `Payments` | Payment transactions linked to shipments | ~100,000 |
| `TrackingEvents` | Real-time GPS tracking events | 601,857 |
| `DeliveryAttempts` | Delivery attempt records with success/failure | 105,824 |
| `ProofOfDelivery` | POD evidence (photo, signature, digital) | 78,829 |

### 2.2 Schema Normalization & Referential Integrity

A critical improvement was the refactoring of free-text strings into normalized foreign key relationships:

**Before Normalization (Problem):**
```
Shipments.CurrentStatus = 'Delivered'  ← Free-text, inconsistent casing
Shipments.CurrentStatus = 'DELIVERED'  ← Duplicate value
Shipments.CurrentStatus = 'delivered'  ← Another duplicate
```

**After Normalization (Solution):**
```sql
Shipments.StatusID = 5  →  ShipmentStatusLookup.StatusID = 5, StatusName = 'Delivered'
```

This normalization was applied to:
- `CurrentStatus` → `StatusID` (FK to `ShipmentStatusLookup`) — eliminated 3 variant spellings
- `MaterialType` → `MaterialID` (FK to `MaterialLookup`) — standardized 100 cargo categories

The `Shipments` table alone now contains **7 foreign key constraints**:
1. `SenderID` → `Customers(CustomerID)`
2. `ReceiverID` → `Customers(CustomerID)`
3. `OriginHubID` → `Hubs(HubID)`
4. `DestinationHubID` → `Hubs(HubID)`
5. `StatusID` → `ShipmentStatusLookup(StatusID)`
6. `MaterialID` → `MaterialLookup(MaterialID)`
7. `FinalFailureReasonID` → `FailureReasonLookup(ReasonID)`

**Benefits**: Reduced storage footprint (INT vs VARCHAR), prevented data entry inconsistencies, and enabled high-speed indexed JOINs for analytical queries.

### 2.3 Advanced SQL Query Implementation (10 Queries)

Ten distinct analytical queries were implemented using advanced T-SQL features:

| # | Query | Technique Used | Business Purpose |
|---|---|---|---|
| Q1 | `vw_ShipmentMaster` | Multi-table JOIN View | Consolidated shipment dashboard with sender/receiver/hub/status names |
| Q2 | Tracking Status Lookup | Subquery + JOIN | Current status of any shipment by tracking number |
| Q3 | `vw_ShipmentTimeline` | VIEW + Chronological JOIN | Full event timeline per shipment for operational audits |
| Q4 | Hub Throughput | `COUNT`, `GROUP BY` | Shipment volume per origin hub for capacity planning |
| Q5 | Courier Success Rate | `SUM(CASE WHEN...)/NULLIF()` | Per-courier delivery success rate (avoids division-by-zero) |
| Q6 | Delivery Failure Analysis | `JOIN FailureReasonLookup` + `COUNT` | Top failure reasons with frequency counts |
| Q7 | Late Deliveries | `DATEDIFF()`, date comparison | Identifies shipments delivered after PromisedDeliveryDate |
| Q8 | Stuck Shipments | `CTE + ROW_NUMBER() OVER(PARTITION BY...)` | Detects shipments with no tracking events in 48+ hours |
| Q9 | `vw_PODValidation` | VIEW + LEFT JOIN | Cross-references Delivered status with POD evidence for compliance |
| Q10 | `vw_HubRevenueMonthly` | `VIEW + YEAR()/MONTH()/SUM()` | Monthly revenue aggregation per hub for financial reporting |

**SQL Execution Proofs:**

![SQL Q1](../Assets/14_SQL_Q1.png)
![SQL Q2](../Assets/15_SQL_Q2.png)
![SQL Q3](../Assets/16_SQL_Q3.png)
![SQL Q4](../Assets/17_SQL_Q4.png)
![SQL Q5](../Assets/18_SQL_Q5.png)
![SQL Q6_1](../Assets/19_SQL_Q6_1.png)
![SQL Q6_2](../Assets/20_SQL_Q6_2.png)
![SQL Q7_1](../Assets/21_SQL_Q7_1.png)
![SQL Q7_2](../Assets/22_SQL_Q7_2.png)
![SQL Q8](../Assets/23_SQL_Q8.png)
![SQL Q9](../Assets/24_SQL_Q9.png)
![SQL Q10](../Assets/25_SQL_Q10.png)

**SQL Views Created:**

![View Q1](../Assets/26_View_Q1.png)
![View Q3](../Assets/27_View_Q3.png)
![View Q9](../Assets/28_View_Q9.png)
![View Q10](../Assets/29_View_Q10.png)

**Technical Highlights:**
- **CTE with Window Functions (Q8):** Uses `ROW_NUMBER() OVER(PARTITION BY ShipmentID ORDER BY EventTime DESC)` to dynamically retrieve the most recent event per shipment, then filters for shipments where the last event was more than 48 hours ago.
- **Safe Division (Q5):** Uses `NULLIF(COUNT(*), 0)` to prevent division-by-zero errors when a courier has no recorded attempts.
- **Status Normalization (Q8):** Uses `JOIN ShipmentStatusLookup` to filter by `StatusName NOT IN ('Delivered', 'Cancelled')` instead of raw status text, ensuring the query works correctly with the normalized schema.

### 2.4 CRUD Operations Demonstration

A complete CRUD (Create, Read, Update, Delete) lifecycle was demonstrated on the `Customers` table:

| Operation | SQL | Purpose |
|---|---|---|
| **CREATE** | `INSERT INTO Customers VALUES (99999, 'Test Customer', ...)` | Insert a new test record |
| **READ** | `SELECT * FROM Customers WHERE CustomerID = 99999` | Verify the inserted record |
| **UPDATE** | `UPDATE Customers SET CustomerName = 'Updated Name' WHERE CustomerID = 99999` | Modify an existing record |
| **DELETE** | `DELETE FROM Customers WHERE CustomerID = 99999` | Clean up the test record |

### 2.5 Machine Learning: Random Forest Delay Prediction

Moving beyond descriptive statistics, a **Random Forest Classifier** was trained to predict whether a shipment would be delayed:

**Model Configuration:**
- Algorithm: Random Forest (100 estimators, max_depth=10)
- Train/Test Split: 80/20 with stratified sampling
- Input Features: GPS Provider, Vehicle Type, Transportation Distance, Market/Regular, Trip Type

**Model Performance:**

| Metric | On-Time | Delayed | Weighted Avg |
|---|---|---|---|
| Precision | ~0.62 | ~0.82 | ~0.76 |
| Recall | ~0.50 | ~0.88 | ~0.76 |
| F1-Score | ~0.56 | ~0.85 | ~0.76 |

**Top Feature Importances (from Random Forest):**

![Random Forest Feature Importance](../Assets/13_Random_Forest_Important_Features.png)

1. `TRANSPORTATION_DISTANCE_IN_KM` — Distance is the strongest predictor of delay
2. `GpsProvider_VAMOSYS` — Using VAMOSYS significantly reduces delay probability
3. `GpsProvider_Unknown` — Missing GPS data correlates with poor outcomes
4. `vehicleType_*` — Heavy commercial vehicles (HCVs) show different delay profiles

**Business Value:** The model can be deployed in the live Tracking Management System (TMS) to flag high-risk shipments *before departure*, enabling proactive resource allocation.

---

## 💎 3. Data Quality & Preprocessing (Q)

*Rigorous cleaning is the foundation of trustworthy analysis. This section documents every decision made during the data quality process.*

### 3.1 Initial Data State Assessment ("The Before")

The raw dataset (6,880 rows × 32 columns) exhibited significant quality issues upon initial inspection:

![Missing Data Assessment](../Assets/01_Missing_Data_Assessment.png)

| Issue Category | Affected Columns | Impact |
|---|---|---|
| **Missing GPS Telemetry** (~14%) | `GpsProvider`, `Data_Ping_time`, `Curr_lat`, `Curr_lon`, `Current_Location` | Cannot track shipment position |
| **Missing Driver Info** (~50-61%) | `Driver_Name` (50%), `Driver_MobileNo` (61%) | Cannot contact driver |
| **Missing Operational Data** (~59%) | `Minimum_kms_to_be_covered_in_a_day` | Cannot benchmark performance |
| **Redundant Status Flags** (~37-63%) | `ontime` (63%), `delay` (37%) | Can be derived from dates |
| **Missing Route Codes** (~0.4%) | `DestinationLocation_Code`, `OriginLocation_Code` | Minor impact |
| **1899 Excel Epoch Dates** | `trip_start_date`, `trip_end_date` | System error, invalid records |
| **Negative Trip Durations** | Records where `trip_end_date` < `trip_start_date` | Clock sync / data entry errors |

**Overall Data Quality:** 86.1% of cells are complete, with 13.9% having at least one missing value. However, the distribution of missing data is non-random — it clusters around GPS-related fields, suggesting a systemic tracking infrastructure gap rather than random data loss.

### 3.2 Missing Values Strategy (Column-by-Column Plan)

Each column with missing values was addressed with a specific, justified strategy:

| Column | Missing % | **Strategy** | **Justification** |
|---|---|---|---|
| `ontime` | 63.0% | **Drop column** | Redundant — on-time status derivable from `actual_eta` vs `Planned_ETA` |
| `Driver_MobileNo` | 60.9% | **Drop column** | Too much missing, not analytically useful |
| `Minimum_kms_to_be_covered_in_a_day` | 59.0% | **Fill with median** | Numeric — median preserves distribution without skew |
| `Driver_Name` | 49.8% | **Fill with "Unknown"** | Categorical — placeholder preserves row, allows grouping |
| `delay` | 36.9% | **Drop column** | Redundant — derived from date comparison |
| `Current_Location` | 14.0% | **Keep NaN** | NaN is meaningful (no GPS ping = untracked segment) |
| `GpsProvider` | 13.9% | **Fill with "Unknown"** | Categorical — enables "Unknown" as its own analysis group |
| `Data_Ping_time` | 13.9% | **Keep NaN** | No ping means untracked — NaN is informative |
| `Curr_lat` / `Curr_lon` | 13.9% | **Keep NaN** | Tied to GPS availability, cannot be meaningfully imputed |
| `vehicleType` | 11.2% | **Fill with "Unknown"** | Categorical — preserves rows for non-vehicle-specific analysis |
| `TRANSPORTATION_DISTANCE_IN_KM` | 10.3% | **Fill with median** | Numeric — median is robust to outliers |
| `trip_end_date` | 2.8% | **Keep NaN** | Trip may not have ended yet (in-transit) |
| `actual_eta` | 0.5% | **Keep NaN** | Minor — insufficient to affect analysis |

### 3.3 Data Cleaning Pipeline (6-Stage Transformation)

A systematic 6-stage cleaning pipeline was applied:

| Stage | Action | Records Affected | Retention |
|---|---|---|---|
| 1. **Date Normalization** | Converted 4 date columns (`trip_start_date`, `trip_end_date`, `actual_eta`, `Planned_ETA`) from strings to datetime objects using `pd.to_datetime(errors='coerce')` | All rows | 100% |
| 2. **GPS Coordinate Parsing** | Parsed `Org_lat_lon` and `Des_lat_lon` bracketed strings (e.g., `"(12.97, 77.59)"`) into 4 separate numeric columns (`org_lat`, `org_lon`, `des_lat`, `des_lon`) | All rows | 100% |
| 3. **Remove 1899 Epoch Records** | Filtered out records where `trip_start_date.year < 2000` (Excel system epoch errors) | ~130 rows removed | ~98% |
| 4. **Remove Impossible Durations** | Filtered out records where `trip_end_date < trip_start_date` (arrival before departure) | ~700 rows removed | ~88% |
| 5. **Missing Values Handling** | Applied the column-by-column strategy from Section 3.2 | Per-column | ~88% |
| 6. **Category Casing Standardization** | Stripped whitespace from all categorical columns (`GpsProvider`, `vehicleType`, `customerNameCode`, `supplierNameCode`) | All rows | ~88% |

**Final Result:** 6,810 cleaned rows retained (88.1% data retention rate). The 11.9% removed consists of genuinely corrupt or logically impossible records.

### 3.4 Feature Engineering

Six engineered features were created to enable deeper analysis:

| Feature | Logic | Purpose |
|---|---|---|
| `TripType` | `"Store Pickup"` if distance = 0, else `"Home Delivery"` | Separate hub-side vs. transit analysis |
| `delivery_status` | `"Delayed"` if `actual_eta > Planned_ETA`, else `"On-Time"` | Binary delay classification |
| `is_delayed` | 1 if Delayed, 0 if On-Time | Numeric target for ML model |
| `month_year` | `trip_start_date` formatted as `YYYY-MM` | Temporal aggregation key |
| `trip_duration_days` | `(trip_end_date - trip_start_date)` in days | Trip length measurement for vehicle/route analysis |
| Parsed GPS coords | `org_lat`, `org_lon`, `des_lat`, `des_lon` | Geographic analysis fields |

**The "Store Pickup" Innovation:**

0km distance records were previously treated as anomalies and dropped entirely. Our analysis correctly identifies these as **"Store Pickups"** — situations where the customer retrieves items from the hub. By creating the `TripType` feature, we can compare:
- Home Delivery delays (transit-related factors)
- Store Pickup delays (warehouse dwell time factors)

**The `trip_duration_days` Feature:**

This feature enables analysis of actual trip length in days, allowing comparison across vehicle types and routes. Negative durations (from clock sync errors) were set to NaN to prevent analysis contamination.

### 3.5 Duplicate Detection & Key Integrity

**Exact Duplicate Rows (Q6):** Checked using `df.duplicated().sum()`. Result: No exact duplicate rows were found in the dataset.

**Key Duplicates (Q7):** `BookingID` was checked as the expected unique key using `df['BookingID'].duplicated().sum()`. Duplicate BookingIDs were found and addressed by keeping the first occurrence, since BookingID should be unique per shipment.

### 3.6 Validity Rules & Impossible Values

A systematic validity audit was performed (Q8):

| Rule | Check | Result |
|---|---|---|
| 1899 Epoch Dates | `trip_start_date.year < 1910` | ~130 records detected and removed |
| Negative Trip Duration | `trip_end_date < trip_start_date` | ~700 records detected and removed |
| Zero-Distance Records | `TRANSPORTATION_DISTANCE_IN_KM == 0` | 18 records → reclassified as "Store Pickup" |
| Negative Distances | `TRANSPORTATION_DISTANCE_IN_KM < 0` | 0 records (none found) |
| Future Dates | `trip_start_date > now()` | 0 records (none found) |
| Indian Lat/Lon Range | Lat: 6-36°, Lon: 68-98° | Minor outliers detected, kept (legitimate locations) |

### 3.7 Category Cleanliness Audit

All categorical columns were audited for inconsistent casing, trailing whitespace, and typos (Q9):

| Column | Unique Values | Issues Found | Action |
|---|---|---|---|
| `GpsProvider` | 5 | None | ✅ Clean |
| `Market/Regular` | 2 | Trailing whitespace in column name | Stripped on load |
| `vehicleType` | 14 | None | ✅ Clean |
| `customerNameCode` | 10 | None | ✅ Clean |
| `supplierNameCode` | Variable | None | ✅ Clean |
| `Material Shipped` | Variable | None | ✅ Clean |

---

## 📊 4. Exploratory Data Analysis Results

*This section summarizes the EDA findings organized by analysis type.*

### 4.1 Univariate Analysis: Numeric Distributions & Outlier Assessment

**Numeric Summary (Q10):** Key statistics for the primary numeric features:

| Feature | Mean | Median | Std Dev | Skewness |
|---|---|---|---|---|
| `TRANSPORTATION_DISTANCE_IN_KM` | ~400 | ~220 | ~450 | Right-skewed (long-haul tail) |
| `Curr_lat` | ~17 | ~13 | ~6 | Bimodal (South + North India clusters) |
| `Curr_lon` | ~78 | ~77 | ~2 | Concentrated (South India corridor) |

**Distribution Insights (Q11):**

![Numeric Distributions](../Assets/02_Numeric_Distributions.png)

- Transportation Distance is heavily right-skewed — most trips are under 500km, but a long tail extends to ~3,000km (inter-state long-haul routes).
- Latitude shows bimodal distribution with clusters around 12-13° (Tamil Nadu/Bangalore) and 18-28° (Maharashtra/North India).

**Outlier Assessment (Q12):**

![Boxplot Outliers](../Assets/03_Boxplot_Outliers.png)

- Using IQR method (1.5×IQR), outliers were found in Transportation Distance (long-haul routes) and coordinates.
- **Decision:** Keep all outliers — in logistics, extreme distances and far-flung locations represent legitimate business operations, not data errors.

### 4.2 Categorical Analysis: Top Categories & Rare Values

**Top Categories (Q13):**

![Categorical Distributions](../Assets/04_Categorical_Distributions.png)

- **GPS Provider:** Top providers by volume (with delay rate implications)
- **Vehicle Type:** 14 distinct vehicle types from small LCVs (Tata Ace) to heavy HCVs (40 FT Trailers)
- **Customer:** L&T dominates at ~60% of total volume ("Larsen & Toubro Limited")
- **Trip Type:** 99.7% Home Delivery, 0.3% Store Pickup (18 records after reclassification)

**Rare Categories (Q14):**
- Several vehicle types appear in <3% of records (specialized vehicles for niche routes)
- Multiple customer accounts have <50 shipments — these were retained as domain-specific categories

### 4.3 Temporal Trends Analysis

A dedicated temporal analysis was conducted examining how shipment volume and delay rates evolved across the 21-month dataset period:

![Temporal Volume and Delay Analysis](../Assets/05_Temporal_Volume_Delay.png)

**Monthly Shipment Volume:**
- Volume varies dramatically month-to-month, ranging from tens to over 1,600 trips
- **August 2020** was the absolute peak month by shipment volume (~1,626 trips)
- Early 2020 (pre-COVID period) shows relatively lower but steady volumes

**Monthly Delay Rate Trend:**
- The delay rate fluctuates **significantly** month-to-month (ranging from ~34% to ~90%+), exposing severe process inconsistency
- August 2020 achieved the **lowest delay rate** despite handling the highest volume — a critical proof of concept
- Some months (particularly monsoon season) show elevated delays across all providers

**Key Temporal Insight:** The lack of correlation between volume and delay rate (August 2020 had BOTH the highest volume and the lowest delay) proves that delays are driven by **process quality, not capacity constraints**.

### 4.4 Bivariate Analysis: Correlations & Scatter Plots

**Correlation Matrix (Q15):**

![Correlation Heatmap](../Assets/06_Correlation_Heatmap.png)

- Top 5 strongest numeric correlations were identified and visualized in a heatmap
- Origin/Destination latitude pairs show moderate correlation (most routes share similar geographic bands)

**Scatter Plots (Q16):**

![Numeric Scatter Plots](../Assets/07_Numeric_Scatter_Plots.png)

- **Distance vs. Latitude by Delay Status:** Longer distances show higher delay density (red cluster), especially above 1,000km
- **Origin vs. Destination Latitude:** Many trips cluster along the y=x diagonal (same-city or short-haul intra-state)

### 4.5 Category → Numeric: GPS Provider Impact on Delays (Q17)

![Delay Rate by GPS Provider](../Assets/08_Delay_Rate_GPS.png)

| GPS Provider | Delay Rate | Trip Count | Rating |
|---|---|---|---|
| VAMOSYS | ~12% | High | ⭐ Best |
| TRIMBLE | ~50% | Medium | ⚠ Average |
| Unknown (no GPS) | ~85% | High | ❌ Worst |
| CONSENT TRACK | ~90% | Medium | ❌ Critical |

**Key Insight:** The GPS Provider is not just a tracking tool — it is a **proxy for operational maturity**. Companies using VAMOSYS likely have better overall fleet management processes.

### 4.6 Category × Category: Vehicle Type vs. Delivery Status (Q18)

![Delay Rate by Vehicle Type (Stacked)](../Assets/09_Delay_Rate_Vehicle_Stacked.png)

A full crosstab (`pd.crosstab`) was generated for `vehicleType × delivery_status`:

- Smaller vehicles (Tata Ace, LCVs) show relatively better on-time rates — used for last-mile, shorter routes
- Heavy Commercial Vehicles (HCVs, multi-axle trailers) show consistently high delay rates — used for long-haul inter-state routes
- The stacked proportional bar chart reveals that vehicle type is partially confounded with distance (heavier vehicles travel farther)

### 4.7 Multivariate Temporal Heatmap: Monthly Delay Risk (Q19)

![Monthly Delay Risk Heatmap](../Assets/10_Monthly_Delay_Heatmap.png)

A heatmap of `GPS Provider × Month-Year → Delay Rate` was generated, revealing:

- **VAMOSYS** maintains consistent green (low delay) across all months
- **CONSENT TRACK** and **manual tracking** show persistent red (high delay) across all months
- **August 2020** shows a notable improvement across multiple providers — suggesting a systemic operational change during that period
- **Seasonal patterns:** Some months (monsoon season) show elevated delays across all providers

### 4.8 Customer & Supplier Deep Dive

![Customer and Supplier Dashboard](../Assets/11_Customer_Supplier_Dashboard.png)

A dedicated analysis of the **top 10 customers and suppliers** by shipment volume was conducted, with delay rates annotated for each:

**Customer Analysis:**
- **Larsen & Toubro (L&T)** dominates with ~57% of total shipment volume — and suffers an approximately **80% delay rate**, making it the single highest-impact intervention point
- Smaller customers show highly variable delay profiles, suggesting route-specific rather than systemic issues
- Daimler India and Lucas TVS are secondary customers with different performance patterns

**Supplier/Transporter Analysis:**
- The top 10 suppliers account for the vast majority of trips
- Some suppliers consistently underperform relative to peers — candidates for SLA renegotiation or replacement
- Supplier performance varies independently of customer — suggesting transporter-specific operational issues

**Business Value:** This analysis enables account-level and supplier-level intervention strategies rather than blanket network-wide changes.

### 4.9 Vehicle Type Performance Dashboard

![Vehicle Type Performance Dashboard](../Assets/12_Vehicle_Performance.png)

A comprehensive vehicle type analysis examined delay rates, average distances, and trip durations for all vehicle categories with >20 trips:

**Key Vehicle Findings:**

| Vehicle Category | Typical Use | Delay Profile | Avg Distance |
|---|---|---|---|
| **40 FT Trailers (HCV)** | Long-haul inter-state | High delay (~70%+) | 800-1200km |
| **32 FT Multi-Axle (HCV)** | Medium/long-haul | High delay (~65%+) | 500-800km |
| **32 FT Single-Axle (HCV)** | Medium-haul | Moderate-high delay | 300-600km |
| **Tata Ace (LCV)** | Last-mile, local | Lower delay | 50-200km |

**Critical Insight:** Vehicle type is **partially confounded with distance** — heavier vehicles travel farther, and distance is the #1 predictor of delay. The key question is whether delays are caused by the vehicle type itself or the routes assigned to those vehicle types. The ML model's feature importance analysis suggests it is primarily the **distance**, not the vehicle type, that drives delays.

---

## 💰 5. Actionable Business Value (V)

*The ultimate goal of Data Mining is to drive revenue and efficiency. These recommendations are backed by data analysis.*

### 5.1 GPS Infrastructure Overhaul

**The Data Evidence:** VAMOSYS tracking achieves an **87.8% on-time rate**, while manual tracking and CONSENT TRACK show **85-90% delay rates** — a nearly inverse relationship.

**The Recommendation:** Migrate the entire fleet tracking infrastructure to VAMOSYS. This is the **single highest-ROI action** available.

**Expected Impact:**
- If all shipments had VAMOSYS-level performance, the network delay rate could drop from 68% to under 20%
- Estimated improvement: ~48 percentage points in on-time delivery
- This is not just a technology change — it requires accompanying process changes in fleet management

### 5.2 Account-Level Strategic Intervention (L&T Case Study)

**The Data Evidence:** Larsen & Toubro accounts for **57%+ of total shipment volume** but suffers an approximately **80% delay rate**.

**The Root Cause Analysis:** Given L&T's scale, the delay issue is likely not a transit problem but a **dwell time problem** — delays in loading/unloading at L&T manufacturing plants and warehouses.

**The Recommendation:** Deploy a dedicated operations task force at key L&T plant locations to:
- Optimize loading bay schedules
- Reduce vehicle idle time at origin hubs
- Implement pre-staging of shipments for scheduled pickups

**Expected Impact:** Improving L&T performance alone could reduce overall network delays by ~30 percentage points due to their volume dominance.

### 5.3 The August 2020 Breakthrough

**The Data Evidence:** Throughout 2020, August stands out as a exceptional month, achieving a **34.6% delay rate** despite handling **1,626 trips** (near-peak volume).

**The Significance:** This proves that the logistics network's assets (vehicles, drivers, hubs) are **fundamentally capable of high performance**. The problem is not capacity — it is **process consistency**.

**The Recommendation:** Conduct a retrospective analysis of August 2020 operations to identify what specific operational changes drove this improvement, and institutionalize those practices year-round.

### 5.4 Machine Learning Model Deployment

**The Recommendation:** Deploy the trained Random Forest model into the live Tracking Management System (TMS) as a real-time risk scoring engine:

1. At booking time, score each new shipment for delay risk based on GPS Provider, Vehicle Type, Distance, etc.
2. Flag "High Risk" shipments (probability > 0.7) for proactive monitoring
3. Trigger automatic alerts to dispatchers for intervention
4. Log predictions vs. actual outcomes for continuous model retraining

---

## 📋 6. Final EDA Summary

### Top 5 Insights (From Distributions & Relationships)

1. **Systemic Delay Crisis:** 68.1% overall delay rate — this is not a marginal problem but a fundamental operational failure.
2. **GPS Provider is the #1 Predictor:** VAMOSYS achieves ~87.8% on-time vs. 10-15% for manual/CONSENT TRACK — confirmed by both statistical analysis and the Random Forest feature importance.
3. **Distance ↔ Delay Correlation:** Trips over 1,000km have significantly higher delay rates, suggesting the need for intermediate hub staging.
4. **L&T Volume Concentration:** A single customer accounts for 57%+ of volume with ~80% delay — any improvement here has outsized network impact.
5. **August 2020 Proof of Concept:** Achieved 34.6% delay under peak load, proving the network infrastructure is capable when processes are aligned.

### Top 5 Problems / Risks

1. **Missing GPS Telemetry (~14%):** Cannot track or optimize what you cannot measure. Every untracked shipment is a blind spot.
2. **1899 Excel Epoch Dates:** Systematic data corruption from poorly configured source systems — requires upstream fix.
3. **High Missing Rate on Operational Fields:** Driver_Name (50%), daily KM target (59%), mobile numbers (61%) — prevents driver-level performance analysis.
4. **Duplicate BookingIDs:** Data integrity risk suggesting write-conflicts or retry logic in the source TMS.
5. **Impossible Trip Durations:** Records where arrival precedes departure — indicates clock synchronization issues between hub systems.

### Next Steps

1. **Migrate all fleet tracking to VAMOSYS** — highest ROI, data-proven impact
2. **Deploy the Random Forest model** into the live TMS for real-time delay risk flagging
3. **Establish Data Governance protocols:** enforce mandatory GPS, fix date formats at source, add validation rules, implement deduplication
4. **Conduct August 2020 retrospective** to identify and institutionalize the operational practices that drove that month's exceptional performance
5. **Launch L&T Optimization Program** with dedicated task force at key plant locations

---

## 🏁 7. Conclusion & 6-Month Strategic Roadmap

This project demonstrates the full power of Data Mining applied to logistics operations — from raw data chaos to predictive intelligence. The transformation involved:

- **Database engineering:** A normalized, relationally-integrated SQL schema with 10 analytical queries
- **Data quality management:** A documented, reproducible 6-stage cleaning pipeline
- **Analytical depth:** All 20 required EDA questions answered across Sections A–E
- **Predictive capability:** A machine learning model that identifies delay risk before departure

### Phased Implementation Target:

| Phase | Timeline | Actions | Expected Impact |
|---|---|---|---|
| **Phase 1** | Month 1-2 | Complete GPS migration to VAMOSYS across all fleet | ~40% delay reduction |
| **Phase 2** | Month 3-4 | Implement L&T loading-bay optimization; deploy dedicated ops team | ~15% additional reduction |
| **Phase 3** | Month 5-6 | Deploy Random Forest delay prediction model into live TMS; establish data governance SLAs | Real-time risk flagging + data quality prevention |

### Final Recommendation

Maintain the data cleaning and normalization standards documented in this project to prevent future "data rot" in the logistics ecosystem. The analytical infrastructure built here — the normalized database, the cleaning pipeline, and the predictive model — is not a one-time deliverable but a **living system** that must be continuously maintained and improved.

---

*End of TQV Report*
