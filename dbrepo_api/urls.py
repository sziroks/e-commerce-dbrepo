from django.urls import path
from . import views

urlpatterns = [
    path("categories/", views.GetCategories.as_view()),
    path("items/", views.GetPostItems.as_view()),
    path("order/", views.GetPostOrders.as_view()),
]
