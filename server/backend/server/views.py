import datetime
import math
from django.views.decorators.csrf import csrf_exempt
import time
from    server.models import CropDatasetCategory
# from django.core.files.storage import default_storage

# from .models import CropDatasetCategory
from .serializers import CropDatasetSerializer
from .utils import remove_background ,extractLeaf
from PIL import Image
import os
from django.http import HttpResponse ,JsonResponse
from rest_framework import viewsets
import zipfile
import shutil
from .models import *
import json
from django.core import serializers
import numpy as np

from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import cv2
# load model
loaded_model = load_model('NewResNetV2.h5')


def getDataSetJson(request):
    data = DataSet.objects.all()
    python_list = []
    for i in data:
        print(i.crop)
        python_list.append({
            "crop":i.crop,
            "qr":i.qr,
            "pest_detected":i.pest_detected,
            "trap":i.trap,
            "leaf":i.leaf
        })
    print(python_list)

    return JsonResponse({"data":python_list})

@csrf_exempt
def AddSample(request):
    if request.method == "POST":
        data = request.POST
        qr = data.get("qr")
        crop = data.get("crop")
        # pest_detected = data.get("pest_detected")
        leaf = request.FILES["leaf"]
        trap = request.FILES["trap"]
        # leaf_name = default_storage.save(leaf.name,leaf)
        # trap_name = default_storage.save(trap.name,leaf)
        # leaf_url = default_storage.path("pestserver/dataset/"+str(qr)+"/"+leaf_name)
        rleaf = remove_background(leaf,leaf.name)
        rtrap = remove_background(trap,trap.name)
        loaded_model.summary()
        # imag = Image.open(rtrap)
        # img=image.load_img(imag,target_size=(224,224))
        # x=image.img_to_array(rtrap)
        x = cv2.resize(rleaf,(224,224))     # resize image to match model's expected sizing
        x = x.reshape(1,224,224,3)
        x.shape
        x=x/255
        a=np.argmax(loaded_model.predict(x), axis=1)
        classes = ['Pepper bell Bacterial spot','Pepper bell Healthy','ScirtothripsDorsalis']
        pest_detected = classes[a[0]]
        pest_detected = 'Pepper bell Bacterial spot'

        #FOR API TESTIN PURPOSE ##DELETE AFTERWARDS
        # pest_detected = "Mites"
        # if crop == "Crop A" or crop == "Crop E":
        #     pest_detected = "ScirtothripsDorsalis"



        print(pest_detected)
        
        # summarize model.
        # loaded_model.summary()
        # seed = 42
        # np.random.seed = seed
        # import cv2
        # IMG_WIDTH = 224
        # IMG_HEIGHT = 224
        # IMG_CHANNELS = 3
        # img = np.zeros((1, IMG_HEIGHT, IMG_WIDTH, IMG_CHANNELS), dtype=np.uint8)
        # # img[0] = cv2.imread(trap)
        # image = Image.open(trap)
        # newsize = (224, 224)
        # image = image.resize(newsize)
        # image = np.array(image)
        # output  = loaded_model.predict([image], verbose=1)
        # # mask = output.astype(np.uint8)
        # # imshow(output[0])
        # cv2.imwrite('keras.jpg',(output[0]*255))
        print(crop)
        try:
            if rtrap == None or rleaf == None:
                return JsonResponse({"success":0})
        except:
            current_datetime = datetime.now().strftime("%Y%m%d%H%M%S")
            
            pictureleaf = Image.fromarray(rleaf)  
            picturetrap = Image.fromarray(rtrap)
            try :  
                image_path_leaf = f"./dataset/{qr}/leaf/"
                os.makedirs(image_path_leaf,exist_ok=True)
                # pictureleaf.resize(480,640)
                pictureleaf.save(image_path_leaf+f"/{qr}{current_datetime}.jpg","JPEG")
                leafpath = image_path_leaf+f"/{qr}{current_datetime}.jpg"
                print(leafpath)
                # leaf.save(image_path_leaf+"/test.jpg","JPEG")
                image_path_trap = f"./dataset/{qr}/trap/"
                os.makedirs(image_path_trap,exist_ok=True)
                # picturetrap.resize(480,640)
                picturetrap.save(image_path_trap+f"/{qr}{current_datetime}.jpg","JPEG")
                trappath = image_path_trap+f"/{qr}{current_datetime}.jpg"
                print(trappath)

                print(data.get("user"))

                dataToSave = DataSet(
                    qr = str(qr),
                    crop = str(crop),
                    pest_detected = str(pest_detected),
                    leaf = str(leafpath),
                    trap = str(trappath),
                    useremail = str(data.get("user")),
                    latitude = float(data.get("latitude")),
                    longitude = float(data.get("longitude"))
                )
                dataToSave.save()
                print("Extracted")

            except:
                print("Some error happened ❗❗❗❗")
                return JsonResponse({"success":0})
            # trap_name = default_storage.save(trap.name,trap)
            # trap_url = default_storage.path("pestserver/dataset/"+str(qr)+"/"+trap_name)
            # print(trap_url)

            #save data to database
            


            return JsonResponse(
                {
                "success":1,
                "Pest": pest_detected
                })

    
def add_folder_to_zip(zip_file, folder_path, parent_folder=''):
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isfile(item_path):
            zip_file.write(item_path, os.path.join(parent_folder, item))
        elif os.path.isdir(item_path):
            add_folder_to_zip(zip_file, item_path, os.path.join(parent_folder, item))


def generate_zip_and_send(request):
    # Path to the folder you want to zip
    folder_path = './dataset/'

    # Create a temporary directory to store the zip file
    temp_dir = './temp/'
    os.makedirs(temp_dir, exist_ok=True)

    # Path to the temporary zip file
    zip_file_path = os.path.join(temp_dir, 'dataset.zip')

    # Create the zip file
    with zipfile.ZipFile(zip_file_path, 'w') as zip_file:
        # Add the entire folder to the zip
        # shutil.make_archive(folder_path, 'zip', folder_path)
        add_folder_to_zip(zip_file, folder_path)

    # Prepare the response
    with open(zip_file_path, 'rb') as f:
        response = HttpResponse(f.read(), content_type='application/zip')
        response['Content-Disposition'] = 'attachment; filename=dataset.zip'

    # Remove the temporary directory and zip file
    shutil.rmtree(temp_dir)

    return response

def AddCropCategory(request):
    if request.method == "POST":
        pass

class CropDatasetViewSet(viewsets.ModelViewSet):
    queryset = CropDatasetCategory.objects.all()
    serializer_class = CropDatasetSerializer

@csrf_exempt
def AddUser(request):
    if request.method == "POST":
        print("POSTTTTTTTTTTTT")
        name = request.POST.get("name")
        email = request.POST.get("email")
        contact = request.POST.get("contact")
        role = request.POST.get("role")
        password = request.POST.get("password")
        print(name,email,contact,role,password)

        usr = UserData(
            name = name,
            email = email,
            contact = contact,
            role = role,
            password = password,
        )

        usr.save()
    #     print(name,email,contact,role,password)

        return JsonResponse({
            "status":1
        })
    return HttpResponse ("TRY DOING POST REQUEST")

@csrf_exempt
def LogIn(request):
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        usr = UserData.objects.filter(email=email)
        if len(usr)<1:
            return JsonResponse({
                "status":0,
                "desc":"Email Not Found"
            })
        if password == usr[0].password:
            return JsonResponse({
                "status":1,
                "desc":"Success"
            })
        else :
            return JsonResponse({
                "status":0,
                "desc":"Password Wrong"
            })