import cv2
import numpy as np
import io
from PIL import Image
import tensorflow as tf
import cv2
# import matplotlib.pyplot as plt
# import matplotlib.cm as cm
import time
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image

def remove_background(image_file,file_name):
    # Load the image
    print("Image Received : "+file_name+"✅")
    # buffer = image_file.read()
    time.sleep(15)
    # Read the image from the byte buffer using io.BytesIO
    # image = Image.open(io.BytesIO(buffer))
    # image = np.array(image)
    image = Image.open(image_file)
    # image.resize(480,640)     
    # # Convert the image to RGB mode
    # image = image.convert("RGB")

    # Convert the PIL image to a NumPy array
    image = np.array(image)

    # Create a mask to indicate the probable foreground area
    mask = np.zeros(image.shape[:2], np.uint8)

    # Define the background and foreground model
    background_model = np.zeros((1, 65), np.float64)
    foreground_model = np.zeros((1, 65), np.float64)

    # Define the region of interest (ROI) to focus the segmentation on the leaf
    roi = (50, 50, image.shape[1] - 100, image.shape[0] - 100)

    # Perform GrabCut segmentation
    cv2.grabCut(image, mask, roi, background_model, foreground_model, 50, cv2.GC_INIT_WITH_RECT)

    # Create a mask where the probable foreground and the definite foreground are identified
    mask = np.where((mask == cv2.GC_PR_BGD) | (mask == cv2.GC_BGD), 0, 1).astype('uint8')

    # Find contours in the mask
    contours, _ = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Check if any contours were found
    if len(contours) > 0:
        print("Contours Found Successfully ✅✅")
        # Find the contour with the largest area (assumed to be the leaf)
        leaf_contour = max(contours, key=cv2.contourArea)

        # Create a blank mask for the leaf shape
        leaf_mask = np.zeros_like(mask)

        # Draw the leaf contour on the mask
        cv2.drawContours(leaf_mask, [leaf_contour], 0, 1, thickness=cv2.FILLED)

        # Apply the leaf mask to the original image to extract the leaf
        result = cv2.bitwise_and(image, image, mask=leaf_mask)
        print("Background Removed Successfully ✅✅")
        return result

    # Return None if no leaf contour was found
    print("No Contour Found ❌❌")
    return None

def extractLeaf(image_file,file_name):
    print("Image Received : "+file_name+"✅")
    imag = Image.open(image_file)
    time.sleep(15)
    img = np.array(imag)
    x=image.img_to_array(imag)
    x = cv2.resize(x,(128,128))     # resize image to match model's expected sizing
    x = x.reshape(1,128,128,3)
    print(x.shape,"IMAGEEEE")
    # img = np.zeros((1, 128, 128, 3), dtype=np.uint8)
    loaded_model = load_model('mask.h5')
    # img[0] = cv2.imread('Dataset_80_20/train/Images_128/DS(5).jpg')
    output  = loaded_model.predict([x], verbose=1)
    # cv2.imwrite('v1.jpg', output[0]*255)
    output = output[0]
    preds_test = (output > 0.5).astype(np.uint8)
    # cv2.imwrite('mask.jpg', preds_test*255)
    # mask = cv2.imread('mask.jpg', 0)  # Replace 'mask.jpg' with your actual mask file, use grayscale (0) mode

    # Resize the mask to match the image size
    resized_mask = cv2.resize(preds_test*255, (img.shape[1], img.shape[0]))

    # Apply the mask to the image
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
    closed_mask = cv2.morphologyEx(resized_mask, cv2.MORPH_CLOSE, kernel)
    masked_image = cv2.bitwise_and(img, img, mask=closed_mask)
    # res = Image.fromarray((result * 1).astype(np.uint8)).convert('RGB')
    # cv2.imshow("i",result)
    cv2.imwrite('output.jpg', masked_image)
    return masked_image