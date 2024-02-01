from django.contrib import admin
from django.urls import path,include
from server.views import AddSample,CropDatasetViewSet
from rest_framework import routers
from .views import *

router = routers.DefaultRouter()
router.register(r'addcategory',CropDatasetViewSet)
# router.register(r'uploadimagesofcrops',cropimages)


urlpatterns = [
    path('',include(router.urls)),
    path('addsample/',AddSample),
    path('register/',AddUser),
    path('login/',LogIn),
    path('dl/',generate_zip_and_send),
    path('getData/',getDataSetJson),
]
