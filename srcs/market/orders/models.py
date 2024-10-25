from django.db import models

class Order(models.Model):
	order_id = models.AutoField(primary_key=True)
	user_id = models.IntegerField(foreign_key=True)
	product_id = models.IntegerField(foreign_key=True)
	quantity = models.IntegerField()
	order_date = models.DateTimeField(auto_now_add=True)