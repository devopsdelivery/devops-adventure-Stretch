from django.shortcuts import render
from .models import Order
from users.models import User


def user_orders(request, user_id):
    user = get_object_or_404(User, pk=user_id)
    orders = Order.objects.filter(user=user)
    return render(request, 'orders/user_orders.html', {'user': user, 'orders': orders})
