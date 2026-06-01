from django.contrib import admin
from .models import *

admin.site.register(Ingredient)
admin.site.register(StorageIngredient)
admin.site.register(Invoice)
admin.site.register(User)
admin.site.register(Storage)