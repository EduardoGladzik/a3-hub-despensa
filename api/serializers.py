from rest_framework import serializers
from .models import User, Ingredient, Storage, StorageIngredient, Invoice


class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = '__all__'


class StorageIngredientSerializer(serializers.ModelSerializer):
    ingredient = IngredientSerializer(read_only=True)

    class Meta:
        model = StorageIngredient
        fields = ['id', 'ingredient', 'current_quantity', 'expiration_date']


class StorageSerializer(serializers.ModelSerializer):
    storage_ingredients = StorageIngredientSerializer(many=True, read_only=True)

    class Meta:
        model = Storage
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'


class InvoiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Invoice
        fields = '__all__'

        read_only_fields = ['extracted_text', 'legibility_score', 'created_at']