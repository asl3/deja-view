from nexa.gguf import NexaTextInference
import json



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

EMBEDDINGS_FILE = "image_description_embeddings.json"


def get_similar_images(user_prompt):
	"""returns a list of image file paths closest to the prompt"""
	pass

if __name__ == "__main__":

	  get_similar_images("image_path.jpeg")
