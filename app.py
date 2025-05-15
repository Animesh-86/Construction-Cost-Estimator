from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)
model = joblib.load('C:\\CipherVault\\Programming\\Python\\Projects\\Construction Cost Estimator\\UI\\constrution_cost_estimator\\lib\\Model\\cost_model.pkl')  # Load your trained model

@app.route('/predict', methods=['POST'])  # ✅ MUST be POST
def predict():
    data = request.get_json()
    features = np.array([[data['area'], data['cement_kg'], data['steel_kg'], data['labor_hours'], data['location_index']]])
    prediction = model.predict(features)[0]
    return jsonify({'predicted_cost': prediction})

if __name__ == '__main__':
    app.run(debug=True)
