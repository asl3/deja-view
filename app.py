from flask import Flask, request, jsonify
from nexa.gguf import NexaTextInference
import json
import numpy as np
import os
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
import time

def load_embeddings(json_file='data/images_with_embeddings.json'):
    if os.path.exists(json_file):
        with open(json_file, 'r') as f:
            embeddings = json.load(f)
        # Convert lists back to numpy arrays
        for key, value in embeddings.items():
            embeddings[key] = np.array(value)
        return embeddings
    else:
        return {}

def get_top_k_similar(query_embedding, k, json_file='data/images_with_embeddings.json'):
    embeddings = load_embeddings(json_file)
    
    # Ensure query_embedding is a numpy array
    if not isinstance(query_embedding, np.ndarray):
        query_embedding = np.array(query_embedding)
    
    # Prepare lists for storing similarity scores
    scores = []
    keys = list(embeddings.keys())
    
    # Calculate cosine similarity
    for key in keys:
        sim = cosine_similarity([query_embedding], [embeddings[key]])[0][0]
        scores.append((key, sim))
    
    # Sort scores in descending order
    scores.sort(key=lambda x: x[1], reverse=True)
    
    # Get top k similar embeddings
    top_k = scores[:k]
    
    return top_k

app = Flask(__name__)

def get_similar_images(user_prompt):
    top_k = get_top_k_similar(user_prompt, k=5)

    results = []
    for key, score in top_k:
        print(f"Path: {key}, Cosine Similarity: {score}")
        results.append(key)
    return(results)


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
