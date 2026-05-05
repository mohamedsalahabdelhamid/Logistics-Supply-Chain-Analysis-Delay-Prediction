# 🚚 Logistics & Supply Chain: Delay Prediction & Network Optimization

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:36D1DC,50:5B86E5,100:232526&height=240&section=header&text=Logistics%20Network%20Analytics&fontSize=42&fontColor=ffffff&animation=fadeIn" alt="Header"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white" alt="SQL"/>
  <img src="https://img.shields.io/badge/Machine%20Learning-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white" alt="ML"/>
  <img src="https://img.shields.io/badge/EDA-2E7D32?style=for-the-badge&logo=google-colab&logoColor=white" alt="EDA"/>
</p>

---

## 📈 Performance Summary
<p align="center">
  <img src="https://img.shields.io/badge/Total_Records-6,880-blue?style=for-the-badge" alt="Total Records"/>
  <img src="https://img.shields.io/badge/Delay_Rate-68.1%25-red?style=for-the-badge" alt="Delay Rate"/>
  <img src="https://img.shields.io/badge/Model_Accuracy-Random_Forest-green?style=for-the-badge" alt="Model"/>
</p>

---

## 📄 Project Narrative
This project presents a high-level technical and operational evaluation of a **21-month logistics dataset** (March 2019 – December 2020). By implementing a normalized SQL database and a predictive Random Forest model, this project identifies a data-driven path to reducing delays and optimizing supply chain reliability.

### 🔄 Data Lifecycle Workflow
```mermaid
graph TD
    A[Raw Logistics Data] --> B[SQL Normalization]
    B --> C[ETL & Cleaning Pipeline]
    C --> D[Exploratory Data Analysis]
    D --> E[Feature Engineering]
    E --> F[Random Forest ML Model]
    F --> G[Strategic Insights & Recommendations]
```

---

## 🛠️ The Technical Core

<details>
<summary><b>1. Database Engineering (SQL)</b></summary>
<br>
Designed a 4-layer architecture with 7 major foreign key constraints.
<ul>
  <li><b>Reference Layer:</b> Status codes and reference types.</li>
  <li><b>Core Entities:</b> Hubs, Customers, and Products.</li>
  <li><b>Fleet Layer:</b> Staff and Vehicle tracking.</li>
  <li><b>Transactional Layer:</b> Normalized shipment records.</li>
</ul>
</details>

<details>
<summary><b>2. Machine Learning Pipeline (Python)</b></summary>
<br>
Built a rigorous 6-stage transformation pipeline.
<ul>
  <li><b>Feature Selection:</b> Correlation analysis to find key delay predictors.</li>
  <li><b>Modeling:</b> Random Forest Classifier for robust prediction.</li>
  <li><b>Validation:</b> Confusion matrix and ROC-AUC for performance tracking.</li>
</ul>
</details>

---

## 📊 Visual Insights & Data Discovery

### 🗺️ Network Delay Heatmap
Analysis of "Origin Hub" bottlenecks shows critical delays in specific geographic clusters.
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_1.png" width="800" alt="Delay Plot 1"/>
</p>

### 📈 Temporal Volume vs. Reliability
Correlation matrices uncovering the relationship between GPS providers and delivery status.
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_13.png" width="400" alt="Plot 13"/>
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_5.png" width="400" alt="Plot 5"/>
</p>

---

## 🚀 Strategic Roadmap
1.  **Infrastructural Fix:** Replace underperforming GPS providers identified in `plot_13`.
2.  **Hub Optimization:** Prioritize resource allocation to high-delay hubs identified in EDA.
3.  **Predictive Guard:** Deploy the Random Forest model to flag "At-Risk" shipments before they leave the origin.

---

## 👤 Author
**Mohamed Salah Abdelhamid**
*   LinkedIn: [mohamedsalah-abdelhamid](https://www.linkedin.com/in/mohamedsalah-abdelhamid/)
*   GitHub: [@mohamedsalahabdelhamid](https://github.com/mohamedsalahabdelhamid)

---
<div align="center">
  <sub>Transforming Logistics through Data Science & Engineering 🚛</sub>
</div>
