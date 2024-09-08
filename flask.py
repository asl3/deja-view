from flask import Flask, request, jsonify
from nexa.gguf import NexaTextInference
import json

app = Flask(__name__)

def get_similar_images(user_prompt):
	pass


# This function runs when the app starts
def startup_code():
    model_path_text = "gemma-2b:q2_K"

    inference_text = NexaTextInference(
	model_path=model_path_text,
	local_path=None,
	stop_words=[],
	temperature=0.7,
	max_new_tokens=512,
	top_k=50,
	top_p=0.9,
	profiling=True,
	embedding=True
    )

# Register the startup code to run when the app starts
@app.before_first_request
def before_first_request():
    startup_code()

@app.route('/')
def index():
    return jsonify(message="Hello, World!")

@app.route('/search', methods=['GET'])
def search():
    filepath = get_similar_images(request.args.get('prompt'))
    return jsonify(filepath=filepath)
if __name__ == '__main__':
    app.run(debug=True)
