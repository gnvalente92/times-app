from flask import Flask, jsonify
import datetime
import pytz

app = Flask(__name__)

@app.route('/')
def get_time():
    # Get local times in New York, Berlin, and Tokyo
    ny_time = datetime.datetime.now(pytz.timezone('America/New_York')).strftime('%Y-%m-%d %H:%M:%S')
    berlin_time = datetime.datetime.now(pytz.timezone('Europe/Berlin')).strftime('%Y-%m-%d %H:%M:%S')
    tokyo_time = datetime.datetime.now(pytz.timezone('Asia/Tokyo')).strftime('%Y-%m-%d %H:%M:%S')

    # Create an HTML response
    html_response = f"""
    <!DOCTYPE html>
    <html>
    <body>
        <h1>Local Time</h1>
        <p>New York: {ny_time}</p>
        <p>Berlin: {berlin_time}</p>
        <p>Tokyo: {tokyo_time}</p>
    </body>
    </html>
    """

    return html_response

@app.route('/health')
def health_check():
    # Create a JSON response for health check
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
