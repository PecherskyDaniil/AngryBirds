extends Node


# Здесь хранится прогресс по всем уровнм и путь к ним. Сюда добавлять уровни, и их порядковый номер (далее номер уровня) будет использоваться при вызове
var progress:Array=[[0,"res://scenes/level_1.tscn"],[0,"res://scenes/level_2.tscn"],[0,"res://scenes/level_3.tscn"]]


func pause():
	#Функция для паузы всего
	get_tree().set_pause(true)

func resume():
	#Функция для unпаузы всего
	get_tree().set_pause(false)
