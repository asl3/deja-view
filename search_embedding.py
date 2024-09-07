import json
import numpy as np
import os
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
import time

def load_embeddings(json_file='embeddings.json'):
    if os.path.exists(json_file):
        with open(json_file, 'r') as f:
            embeddings = json.load(f)
        # Convert lists back to numpy arrays
        for key, value in embeddings.items():
            embeddings[key] = np.array(value)
        return embeddings
    else:
        return {}

def get_top_k_similar(query_embedding, k, json_file='embeddings.json'):
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

# Example usage
if __name__ == "__main__":
    start_time = time.time()
    query = "image with a cat"
    model = SentenceTransformer("Mihaiii/Squirtle")
    model_time = time.time() 
    print(f"Loading Model time: {model_time - start_time} seconds")

    query_embedding = model.encode(query)
    query_time = time.time()
    print(f"Query Generation: {query_time - model_time} seconds")

    top_k = get_top_k_similar(query_embedding, k=5)
    
    print("Top k similar embeddings:")
    for key, score in top_k:
        print(f"Path: {key}, Cosine Similarity: {score}")
