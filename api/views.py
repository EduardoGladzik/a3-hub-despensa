import easyocr
from django.shortcuts import render
from rest_framework import viewsets
from .models import User, Ingredient, Storage, Invoice
from .serializers import UserSerializer, IngredientSerializer, StorageSerializer, InvoiceSerializer

leider = easyocr.Reader(['pt', 'en'], gpu=False)

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
        invoice = serializer.save()

        try:
            img_path = invoice.img_captured.path
            result = leider.readtext(img_path, detail=0)
            complete_text = '\n'.join(result)
            invoice.extracted_text = complete_text

            if complete_text.strip():
                invoice.legibility_score = True

            invoice.save()

            print(f"Extracted text for invoice {invoice.id}: {complete_text}")
            print(f"Legibility score for invoice {invoice.id}: {invoice.legibility_score}")
        except Exception as e:
            print(f"Error processing invoice {invoice.id}: {str(e)}")