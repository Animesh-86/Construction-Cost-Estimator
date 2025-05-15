# 🏗️ Construction Cost Estimator
==============================

This is a simple machine learning project that estimates 🧮 the total construction cost based on area, material quantities, labor hours, and location using a Random Forest Regressor from scikit-learn.

# 📂 Dataset
----------

The model is trained on a CSV file: `construction_cost.csv`

📊 Columns in the dataset:
- 📐 area: Area of construction in square feet
- 🧱 cement_kg: Quantity of cement used (in kg)
- 🏗️ steel_kg: Quantity of steel used (in kg)
- 👷 labor_hours: Total labor hours
- 🌍 location_index:
  - 0️⃣ = Rural
  - 1️⃣ = Urban
  - 2️⃣ = Metro
- 💰 total_cost: Total construction cost in INR (target value)

# 🧠 Model Used
-------------

- 🤖 Algorithm: Random Forest Regressor
- 🛠️ Library: scikit-learn
- 📈 Train-Test Split: 80% training, 20% testing

# 🚀 How It Works
---------------

1. Loads the dataset
2. Trains the Random Forest model using selected features
3. Takes user input for construction parameters
4. Predicts and displays the estimated construction cost 💸

# 📦 Requirements
---------------

Install dependencies with:

pip install pandas, scikit-learn, numpy

# 🖥️ Usage

1. Run the script: python construction_estimator.py

2. Provide the required input values when prompted: 

    -Enter Area (sq.ft): 1200
    -Enter Cement Quantity (kg): 120
    -Enter Steel Quantity (kg): 120
    -Enter Total Labor Hours: 200
    -Enter Location Index (0=Rural, 1=Urban, 2=Metro): 1

    -Estimated Construction Cost: ₹1,167,633.77  

# 🌱 Future Improvements

1. 🌐 Add web or mobile UI using Flask, Streamlit, or Flutter

2. 📏 Include data preprocessing and scaling

3. 📉 Add evaluation metrics (MAE, RMSE, R²)

4. 💾 Save the trained model using joblib or pickle
