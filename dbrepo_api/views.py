from django.shortcuts import render
from rest_framework import generics
from . import models
from . import serializers


class GetCategories(generics.ListAPIView):
    queryset = models.Category.objects.all()
    serializer_class = serializers.CategorySerializer


class GetPostItems(generics.ListCreateAPIView):
    queryset = models.Item.objects.all()
    serializer_class = serializers.ItemSerializer


class GetPostOrders(generics.ListCreateAPIView):
    queryset = models.Order.objects.all()
    serializer_class = serializers.OrderSerializer
