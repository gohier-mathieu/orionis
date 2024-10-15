from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenRefreshView
from authentication.views import RegisterView, LoginView, check_username_email
from api.views import HomePageView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('home/', HomePageView.as_view(), name='home'),
    path('api/check_username_email/', check_username_email, name='check_username_email'),
]
