# Generated by Django 4.2.1 on 2024-01-29 13:35

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0005_dataset_latitude_dataset_longitude'),
    ]

    operations = [
        migrations.AddField(
            model_name='dataset',
            name='datetime',
            field=models.DateTimeField(blank=True, default=datetime.datetime.now),
        ),
    ]
