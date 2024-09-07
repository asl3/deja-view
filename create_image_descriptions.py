from nexa.gguf import NexaVLMInference

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

def get_image_description(image_path):
	description_generator = inference._chat("describe this image", image_path)
	description = get_response_text_from_generator(description_generator)
	return description

def get_decriptions_for_images(image_paths):
	image_descriptions = {}
	for image_path in image_paths:
		description = get_image_description(image_path)
		image_descriptions[image_path] = description

	return image_descriptions


if __name__ == "__main__":
	print(get_decriptions_for_images(["/Users/sourabhmadur/Downloads/temp.jpeg"]))
