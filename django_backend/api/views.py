# api/views.py
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from authentication.serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

User = get_user_model()

class HomePageView(APIView):
    permission_classes = [IsAuthenticated]  # Assurez-vous que l'utilisateur est authentifié

    def get(self, request):
        user = request.user  # Récupérer l'utilisateur authentifié
        data = {
            'username': user.username,
            'email': user.email,
            # Ajoutez d'autres données nécessaires ici
        }
        return Response(data)

