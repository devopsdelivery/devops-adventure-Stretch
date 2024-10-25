from django.shortcuts import render
from .models import User


def create_user(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        User.objects.create(name=name, email=email)
        return redirect('list_users') 
    return render(request, 'users/create_user.html')

def list_users(request):
    users = User.objects.all()
    return render(request, 'users/list_users.html', {'users': users})

