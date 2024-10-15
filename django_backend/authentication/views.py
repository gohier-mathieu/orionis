from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User
from .models import CustomUser
from .serializers import UserSerializer
from django.utils.translation import gettext_lazy as _
from django.http import JsonResponse
from django.contrib.auth import get_user_model
from rest_framework.decorators import api_view

User = get_user_model()

@api_view(['GET'])
def check_username_email(request):
    username = request.GET.get('username')
    email = request.GET.get('email')

    # Remplacez ceci par votre logique de vérification
    username_exists = User.objects.filter(username=username).exists()
    email_exists = User.objects.filter(email=email).exists()

    available = not (username_exists or email_exists)

    return Response({'available': available})

class RegisterView(APIView):
    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        first_name = request.data.get('first_name')
        last_name = request.data.get('last_name')
        country = request.data.get('country')
        password = request.data.get('password')

        # Vérifier si le nom d'utilisateur existe déjà
        if CustomUser.objects.filter(username=username).exists():
            return Response({'error': _("Username already taken.")}, status=status.HTTP_400_BAD_REQUEST)

        # Utiliser le sérialiseur pour créer l'utilisateur
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()  # Sauvegarde de l'utilisateur
            user.set_password(password)  # Hachage du mot de passe
            user.save()  # Sauvegarde avec le mot de passe haché
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }, status=status.HTTP_201_CREATED)

        # Afficher les erreurs détaillées
        return Response({'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        user = CustomUser.objects.filter(username=username).first()
        if user and user.check_password(password):
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'username': user.username
            })
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)