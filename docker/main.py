# import os
# if __name__ == "__main__":
#     with open("/mnt/efs/data/rj.txt" , 'w') as fp:
#         fp.writelines("THIS IS AMAZINGGGGGGG!!!!!!!!!!")
#     print("THIS IS WORKING")
# # print(os.listdir())



# import os

# if __name__ == "__main__":
#     os.makedirs('/app/data', exist_ok=True)  # Ensure the directory exists
#     with open("/app/data/rj.txt", 'w') as fp:
#         fp.writelines("THIS IS AMAZINGGGGGGG!!!!!!!!!!")
#     print("THIS IS WORKING")

import os

# Define base paths for text and pdf files
text_base_path = "/mnt/efs/data/text"
pdf_base_path = "/mnt/efs/data/data"

def save_file(filename, content, base_path):
    # Ensure the directory exists
    os.makedirs(base_path, exist_ok=True)
    
    # Construct the full file path
    file_path = os.path.join(base_path, filename)
    
    # Write the content to the file
    with open(file_path, 'w') as file:
        file.writelines(content)

if __name__ == "__main__":
    # Example usage
    save_file("rj.txt", "THIS IS Awesome!!!!!!!!!!", text_base_path)
    save_file("document.txt", "%This adds another", pdf_base_path)

    print("Files saved successfully")