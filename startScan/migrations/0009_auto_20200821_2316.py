# Generated by Django 3.0.7 on 2020-08-21 23:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('startScan', '0008_scanhistory_scan_task_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='scanhistory',
            name='scan_task_id',
            field=models.CharField(default='--', max_length=1500),
        ),
    ]
