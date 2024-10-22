from nexa.gguf import NexaVLMInference
from nexa.gguf import NexaTextInference
from sentence_transformers import SentenceTransformer
import numpy as np
import json

IMAGES_DIR = "data/images"
OUTPUT_FILE = "data/images_with_embeddings.json"

import os
model = SentenceTransformer("Mihaiii/Squirtle")


def get_response_text_from_generator(generator):
	response_text = ""
	try:
		while True:
			# Get the next item from the generator
			response = next(generator)
			
			# Access 'choices' to extract the text delta (assuming it's in 'delta')
			choices = response.get('choices', [])
			
			for choice in choices:
				delta = choice.get('delta', {})
				
				# Extract the text part from 'delta' if it exists
				if 'content' in delta:
					response_text += delta['content']
				
	except StopIteration:
		# End of generator
		pass
	
	return response_text


model_path = "llava-v1.6-vicuna-7b:q4_0"

model_path_text = "gemma-2b:q2_K"

inference = NexaVLMInference(
	
	model_path=model_path,
	local_path=None,
	stop_words=[],
	temperature=0.7,
	max_new_tokens=2048,
	top_k=50,
	top_p=1.0,
	profiling=True
)

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


def get_image_description(image_path):
	description_generator = inference._chat("Please provide a detailed description of this image in 10 sentences, emphasizing the meaning and context. Focus on capturing the key elements and underlying semantics.", image_path)
	description = get_response_text_from_generator(description_generator)
	return description

def get_decriptions_and_embeddings_for_images(image_paths):
	d = {}
	for image_path in image_paths:
		
		description = get_image_description(image_path)
		


		# embedding_result = inference_text.create_embedding(description)
		
		
		# array = np.array(embedding_result["data"][0]['embedding'])
		# average = np.mean(array, axis=0)


		embedding = model.encode(description).tolist()
		d[image_path] = embedding
		
	return d


if __name__ == "__main__":
	  # Generates this JSON structure with key as image path and value as the description of the image
	  # {'/Users/sourabhmadur/Downloads/temp.jpeg': 
	  # ' The image depicts a white, well-lit room with a minimalist interior design. 
	  # There is a single, large window on the left side of the room, which allows natural light to flood into the space. 
	  # The window is dressed with white curtains that are partially drawn back, allowing a view outside. The room itself is empty, with a plain white wall as the background. 
	  # There are no decorative elements or furniture items visible in the room. The overall aesthetic of the room is simple and clean, with a focus on the natural light that enters through the window.'}

	files = os.listdir(IMAGES_DIR)
	print("files ", files)
	print(len(files))

	
	with open(OUTPUT_FILE, 'w') as f:
		
		d = get_decriptions_and_embeddings_for_images(files)
			
		json.dump(d, f, indent=4)  
			

