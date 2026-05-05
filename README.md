# 🚚 Logistics & Supply Chain: Comprehensive Delay Prediction & Network Optimization

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

## 📊 Comprehensive Visual Analysis (EDA)
This project includes an exhaustive exploratory data analysis covering all aspects of the supply chain network.

### 🔍 1. Data Distribution & Correlation
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_1.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_2.png" width="400" />
</p>
<p align="center">
  <i>Fig 1 & 2: Correlation Heatmap and Feature Distribution.</i>
</p>

### 🚛 2. Shipment & Hub Performance
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_3.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_4.png" width="400" />
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_5.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_6.png" width="400" />
</p>

### 🗺️ 3. Regional Delay Bottienecks
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_7.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_8.png" width="400" />
</p>

### ⏲️ 4. Temporal Trends & Fleet Efficiency
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_9.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_10.png" width="400" />
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_11.png" width="400" />
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_12.png" width="400" />
</p>

### 🛰️ 5. GPS Provider Reliability
<p align="center">
  <img src="https://raw.githubusercontent.com/mohamedsalahabdelhamid/Logistics-Supply-Chain-Analysis-Delay-Prediction/main/plots/plot_13.png" width="600" />
</p>
<p align="center">
  <i>Fig 13: Comparative analysis of GPS downtime across different providers.</i>
</p>

---

## 🛠️ Technical Implementation

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

### 🧠 Model Architecture (Random Forest)
*   **Preprocessing:** Handled high cardinality in `Origin Hub` and `Vehicle Type`.
*   **Feature Selection:** Prioritized `Distance`, `Planned Travel Time`, and `Vehicle Age`.
*   **Evaluation:** Used Confusion Matrix and ROC-AUC to ensure high precision in predicting delayed status.

---

## 🚀 Strategic Roadmap
1.  **Infrastructural Fix:** Replace underperforming GPS providers identified in the comparative analysis.
2.  **Hub Optimization:** Prioritize resource allocation to high-delay hubs identified in regional analysis.
3.  **Predictive Guard:** Deploy the Random Forest model to flag "At-Risk" shipments before they leave the origin.

---

## 👤 Author
**Mohamed Salah Abdelhamid**
*   LinkedIn: [mohamedsalah-abdelhamid](https://www.linkedin.com/in/mohamedsalah-abdelhamid/)
*   GitHub: [@mohamedsalahabdelhamid](https://github.com/mohamedsalahabdelhamid)

---
<div align="center">
  <sub>Optimizing Supply Chain Reliability through Predictive Analytics 🚚</sub>
</div>
