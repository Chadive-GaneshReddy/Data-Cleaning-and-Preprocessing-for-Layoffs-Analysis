# Data-Cleaning-and-Preprocessing-for-Layoffs-Analysis
# 🚀 Layoffs Data Cleaning Using SQL

This project focuses on **cleaning and standardizing layoffs data** using SQL to ensure data accuracy, consistency, and readiness for analysis. The dataset contains information on layoffs across various companies, industries, and locations, including total layoffs, percentages, and funding details.

> **This project was completed under the guidance of [Alex The Analyst](https://www.youtube.com/c/AlexTheAnalyst).**  

## 📌 Key Objectives
- Remove duplicate records to maintain data integrity.
- Standardize company names, industry classifications, and country names.
- Convert date formats to ensure consistency.
- Handle missing values in key fields.
- Optimize the dataset for further analysis and visualization.

## 📂 Dataset Overview
The dataset consists of the following columns:
- `company` - Name of the company where layoffs occurred.
- `location` - Company location.
- `industry` - Industry the company belongs to.
- `total_laid_off` - Number of employees laid off.
- `percentage_laid_off` - Percentage of workforce affected.
- `date` - Date of layoffs (originally in string format).
- `stage` - Business stage of the company (e.g., Startup, Growth, Public).
- `country` - Country where layoffs occurred.
- `funds_raised_millions` - Funds raised by the company in millions.

## 🛠 SQL Data Cleaning Steps
1. **Creating a Backup**: Duplicating the original dataset to avoid accidental modifications.
2. **Removing Duplicates**: Using `ROW_NUMBER()` to detect and delete duplicate records.
3. **Standardizing Data**:
   - Trimming extra spaces in company names.
   - Merging industry names with slight variations (e.g., "Crypto" and "Crypto currency").
   - Cleaning country names by removing unnecessary characters.
4. **Fixing Date Formats**: Converting string-based dates into `DATE` format.
5. **Handling Missing Values**:
   - Filling missing industry names using available company data.
   - Removing records where both `total_laid_off` and `percentage_laid_off` are `NULL`.
6. **Final Cleanup**: Removing unnecessary columns (`row_num`) after deduplication.

## 🏗 Tech Stack
- **Database**: MySQL / SQL-based databases
- **Query Language**: SQL
- **Tools Used**: MySQL Workbench / Any SQL Client

## 📊 Expected Outcome
After cleaning, the dataset is:
✅ Free of duplicates  
✅ Standardized for accurate analysis  
✅ Ready for further visualization using **Power BI, Tableau, or Python**  

🤝 Contributing
Feel free to contribute by reporting issues, suggesting improvements, or adding new features! Create a pull request or open an issue to discuss changes.

📜 License
This project is open-source and available under the MIT License.

🔗 Connect with Me
📧 Email: ganeshreddycrsr@gmail.com
💼 LinkedIn: www.linkedin.com/in/chadive-ganesh-reddy-5004a424a
🚀 GitHub: https://github.com/Chadive-GaneshReddy

Happy Coding! 🎯
This version **credits Alex The Analyst** while keeping it **professional and detailed**. Let me know if you'd like any other changes! 🚀
