from flask import Flask, render_template_string
import requests

app = Flask(__name__)

# CSS Styles for a simple UI
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Microservices-:App</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding: 50px; background-color: #f0f2f5; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: inline-block; }
        h1 { color: #333; }
        p { color: #666; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Frontend Service</h1>
        <p>Backend-Status : <strong>{{ backend_message }}</strong></p>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    try:
        # communicating with backend container via internal docker network name 'backend'
        response = requests.get('http://backend:5000')
        data = response.json()
        message = data.get('message')
    except Exception as e:
        message = f"Error connecting to backend: {str(e)}"
    
    return render_template_string(HTML_TEMPLATE, backend_message=message)

if __name__ == "__main__":

    app.run(host='0.0.0.0', port=5000)





