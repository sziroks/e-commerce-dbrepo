from django.db import models


# core DB
class Category(models.Model):
    id_category = models.AutoField(primary_key=True, null=False)
    name = models.CharField(max_length=100, null=False, blank=False)

    class Meta:
        managed = False
        db_table = "category"


class OrderStatus(models.Model):
    id_order_status = models.AutoField(primary_key=True, null=False)
    name = models.CharField(max_length=100, null=False, blank=False)

    class Meta:
        managed = False
        db_table = "order_status"


class Item(models.Model):
    id_item = models.AutoField(primary_key=True, null=False)
    id_user = models.IntegerField()
    name = models.CharField(max_length=100, null=False)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    id_category = models.ForeignKey(
        Category, on_delete=models.SET_NULL, null=True, db_column="id_category"
    )
    created_at = models.DateTimeField(auto_now_add=True)
    active = models.BooleanField(null=False)

    class Meta:
        managed = False
        db_table = "item"


class ItemGroup(models.Model):
    id_item_group = models.IntegerField(primary_key=True, null=False)
    id_item = models.ForeignKey(
        Item, on_delete=models.SET_NULL, null=True, db_column="id_item"
    )

    class Meta:
        managed = False
        db_table = "item_group"


class Order(models.Model):
    id_order = models.AutoField(primary_key=True, null=False)
    id_user = models.IntegerField()
    id_item_group = models.ForeignKey(
        ItemGroup, on_delete=models.SET_NULL, null=True, db_column="id_item_group"
    )
    id_order_status = models.ForeignKey(
        OrderStatus, on_delete=models.SET_NULL, null=True, db_column="id_order_status"
    )
    total = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = "order"
