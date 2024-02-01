from rest_framework import serializers
from server.models import CropDatasetCategory

class CropDatasetSerializer(serializers.HyperlinkedModelSerializer):
    uid=serializers.ReadOnlyField()
    class Meta:
        model= CropDatasetCategory
        fields = '__all__'