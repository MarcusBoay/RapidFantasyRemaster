class_name PlayerInventory
extends Resource

var attacks: Dictionary[PlayerAttack, int] # second param is unused (crude way of making a set)
var items: Dictionary[Item, int] # item, quantity
