from django.db import models

class Order(models.Model):
    order_id = models.AutoField(primary_key=True)
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)  
    product = models.ForeignKey('products.Product', on_delete=models.CASCADE)  
    quantity = models.IntegerField()
    order_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Order {self.order_id} - {self.user.name} comprou {self.quantity} {self.product.name}(s)"
