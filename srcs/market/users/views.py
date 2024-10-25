from django.shortcuts import render
from .models import User


def list_users(request):
    users = User.objects.all()
    return render(request, 'users/list_users.html', {'users': users})

