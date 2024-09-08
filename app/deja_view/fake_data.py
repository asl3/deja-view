from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

@app.route('/get-strings', methods=['GET'])
def get_strings():
    data = ["apple", "banana", "cherry", "date", "elderberry"]
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001)
