# main.py is the main frame of the website
# exposing necessary api for pytesting

from flask import Flask, jsonify, render_template
import os
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)

# Gain setting from enviroment, if fails set development
APP_ENV = os.getenv('APP_ENV', 'development')
APP_VERSION = "v1.0.2"

# Gain Title from env, if fails set My CI/CD App
APP_TITLE = os.getenv('APP_TITLE', 'My CI/CD App') 

# production -> blue, testing -> green, other -> gray
def get_env_config():
    env = os.getenv('APP_ENV', 'development').lower()
    if env == 'production':
        color = "blue"
    elif env == 'testing':
        color = "green"
    else:
        color = "gray"
    return env, color

@app.route('/')
def index():
    env_name, bg_color = get_env_config()
    return render_template('index.html', 
                            title=APP_TITLE, 
                            env=env_name, 
                            color=bg_color)

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
