from django.db import models
from datetime import datetime    

class CropDatasetCategory(models.Model):
    uid = models.AutoField(primary_key=True)
    crop_name = models.CharField(max_length=20)
    crop_description = models.CharField(max_length=100)
    crop_type = models.CharField(max_length=20)
    latitude = models.FloatField()
    longitude = models.FloatField()

class UserData(models.Model):
    name = models.CharField(max_length=200,default="None")
    email = models.CharField(max_length=200,default="None")
    contact = models.IntegerField(max_length=10,default="None")
    role = models.CharField(max_length=20,default="None")
    password = models.CharField(max_length=10,default="None")

    def __str__(self) :
        return self.name
    
class DataSet(models.Model):
    crop = models.CharField(max_length=200,default="None")
    qr = models.CharField(max_length=200,default="None")
    leaf = models.CharField(max_length=200,default="None")
    trap = models.CharField(max_length=200,default="None")
    pest_detected = models.CharField(max_length=200,default="None")
    useremail = models.CharField(max_length=200,default="None")
    longitude = models.FloatField(default=0.0)
    latitude = models.FloatField(default=0.0)
    datetime = models.DateTimeField(default=datetime.now, blank=True)

    def __str__(self) :
        return self.qr
