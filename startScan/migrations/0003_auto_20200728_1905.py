# Generated by Django 3.0.7 on 2020-07-28 19:05

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('startScan', '0002_scanvulnerability'),
    ]

    operations = [
        migrations.RenameField(
            model_name='scanvulnerability',
            old_name='scan_of',
            new_name='scan_history',
        ),
    ]
