from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, IngredientViewSet, StorageViewSet, InvoiceViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'ingredients', IngredientViewSet)
router.register(r'storages', StorageViewSet)
router.register(r'invoices', InvoiceViewSet)

urlpatterns = [
    path('', include(router.urls))
]