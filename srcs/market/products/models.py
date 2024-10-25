from django.db import models

class Product(models.Model):
	product_id = models.AutoField(primary_key=True)
	product_name = models.CharField(max_length=100)
	price = models.DecimalField(max_digits=10, decimal_places=2)
