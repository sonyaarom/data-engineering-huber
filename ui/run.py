import sys
import os

# Add the project root to the Python path
sys.path.insert(0, os.path.abspath(os.path.dirname(os.path.dirname(__file__))))

from ui.app import app, socketio

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=1234, debug=True)