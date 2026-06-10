import threading
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import viewsets
from .models import User, Ingredient, Storage, Invoice, StorageIngredient
from .serializers import UserSerializer, IngredientSerializer, StorageSerializer, InvoiceSerializer, StorageIngredientSerializer
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

    @action(detail=True, methods=['get'])
    def ingredients(self, request, pk=None):
        """
        Retorna lista de itens de uma despensa específica.
        Rota gerada dinâmicamente.
        """
        storage = self.get_object()
        storage_items = StorageIngredient.objects.filter(storage=storage)
        serializer = StorageIngredientSerialzer(storage_items, many=True)
        return Response(serializer.data)

class InvoiceViewSet(viewsets.ModelViewSet):
    queryset = Invoice.objects.all()
    serializer_class = InvoiceSerializer
    
    def perform_create(self, serializer):
        """
        Sobrescreve o método de criação para processar a nota fiscal em uma thread separada."""
        # salva nota fiscal
        invoice = serializer.save()

        # processa a nota fiscal em uma thread separada
        thread = threading.Thread(target=process_invoice, args=(invoice.id,))
        thread.start()