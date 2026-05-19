from flask import Flask, jsonify
import os

app = Flask(__name__)

# Gain setting from enviroment, if fails set development
APP_ENV = os.getenv('APP_ENV', 'development')
APP_VERSION = "v1.0.0"

@app.route('/')
def home():
    return f"""
    <h1>Container CI/CD Demo</h1>
    <p><b>Status:</b> Running</p>
    <p><b>Version:</b> {APP_VERSION}</p>
    <p><b>Environment:</b> <span style="color: red; font-weight: bold;">{APP_ENV}</span></p>
    <hr>
    <p>Managed by Jenkins & Docker</p>
    """

@app.route('/health')
def health():
    # Interface for checking health
    return jsonify({"status": "ok", "env": APP_ENV}), 200

@app.route('/version')
def version():
    # Interface for checking version
    return jsonify({"version": APP_VERSION}), 200

if __name__ == '__main__':
    # supervise 0.0.0.0 ensuring container is accessible
    app.run(host='0.0.0.0', port=5000)