﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	
	Хранилище = РеквизитФормыВЗначение("Запись").СодержимоеОповещения;
	Элементы.СтраницаСодержимое.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Содержимое (размер, байт: %1)'"),
		Строка(Base64Значение(XMLСтрока(Хранилище)).Размер()));
	
	СодержимоеХранилища = Хранилище.Получить();
	Попытка
		СодержимоеОповещения = ОбщегоНазначения.ЗначениеВСтрокуXML(СодержимоеХранилища);
	Исключение
		СодержимоеОповещения = ЗначениеВСтрокуВнутр(СодержимоеХранилища);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти
