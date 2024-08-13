from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/start_game', methods=['POST'])
def start_game():
    water = request.json.get('water', '10')  # Default value is 10 if not provided
    result = subprocess.run(['python3', 'gui.py', '--water', water], capture_output=True, text=True)
    return jsonify({'output': result.stdout})

if __name__ == '__main__':
    app.run(debug=True)