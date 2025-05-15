import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
import numpy as np
import joblib

df = pd.read_csv('C:\\CipherVault\\Programming\\Python\\Projects\\Construction Cost Estimator\\UI\\constrution_cost_estimator\\lib\\Model\\construction_cost.csv')

print("Columns in the dataset:")
print(df.columns)
df.head()

X = df[['area', 'cement_kg', 'steel_kg', 'labor_hours', 'location_index']]
y = df['total_cost']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
model = RandomForestRegressor()
model.fit(X_train, y_train)

print("\nConstruction Cost Estimator: ")
area = float(input("Enter Area (sq.ft): "))
cement_kg = float(input("Enter Cement Quantity (kg): "))
steel_kg = float(input("Enter Steel Quantity (kg): "))
labor_hours = float(input("Enter Total Labor Hours: "))
location_index = int(input("Enter Location Index (0=Rural, 1=Urban, 2=Metro): "))

features = np.array([[area, cement_kg, steel_kg, labor_hours, location_index]])
predicted_cost = model.predict(features)[0]

print(f"\nEstimated Construction Cost: ₹{predicted_cost:,.2f}")

joblib.dump(model, 'construction_cost_model.pkl')