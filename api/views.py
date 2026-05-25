import threading
from rest_framework import viewsets
from .models import User, Ingredient, Storage, Invoice
from .serializers import UserSerializer, IngredientSerializer, StorageSerializer, InvoiceSerializer
from .services import process_invoice

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class IngredientViewSet(viewsets.ModelViewSet):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer


class StorageViewSet(viewsets.ModelViewSet):
    queryset = Storage.objects.all()
    serializer_class = StorageSerializer


class InvoiceViewSet(viewsets.ModelViewSet):
    queryset = Invoice.objects.all()
    serializer_class = InvoiceSerializer
    
    def perform_create(self, serializer):
        # salva nota fiscal
        invoice = serializer.save()

        # processa a nota fiscal em uma thread separada
        thread = threading.Thread(target=process_invoice, args=(invoice,))
        thread.start()