from django.db import models
from django.contrib.auth.models import AbstractBaseUser

class User(AbstractBaseUser):
    username = models.CharField(max_length=255)
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.username

class Ingredient(models.Model):

    STORAGE_CATEGORY = [
        ('fridge', 'Fridge'),
        ('freezer', 'Freezer'),
        ('pantry', 'Pantry'),
    ]

    UNIT_CATEGORY = [
        ('kg', 'Kilograms'),
        ('g', 'Grams'),
        ('l', 'Liters'),
        ('ml', 'Milliliters'),
        ('unit', 'Units'),
        ('other', 'Other'),
    ]

    name = models.CharField(max_length=255)
    measure_unit = models.CharField(max_length=100, choices=UNIT_CATEGORY)
    category = models.CharField(max_length=100, choices=STORAGE_CATEGORY)

    def __str__(self):
        return f"{self.name} ({self.quantity} {self.measure_unit}) in {self.category}"

class Storage(models.Model):
    name = models.CharField(max_length=255)
    owner = models.ManyToManyField(User, related_name='storages')

    def __str__(self):
        return self.name
    
class StorageIngredient(models.Model):
    storage = models.ForeignKey(Storage, on_delete=models.CASCADE, related_name='storage_ingredients')
    ingredient = models.ForeignKey(Ingredient, on_delete=models.CASCADE, related_name='ingredient_storages')
    current_quantity = models.FloatField()
    expiration_date = models.DateField()

    def __str__(self):
        return f"{self.current_quantity} of {self.ingredient.name} in {self.storage.name}"
    
class Invoice(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='invoices')
    destined_storage = models.ForeignKey(Storage, on_delete=models.CASCADE, related_name='invoices')

    img_captured = models.ImageField(upload_to='invoices/')
    extracted_text = models.TextField(blank=True, null=True)
    legibility_score = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)