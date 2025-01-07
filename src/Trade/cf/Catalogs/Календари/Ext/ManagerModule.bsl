﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГрафикиРаботы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Календари КАК ГрафикиРаботы
		|ГДЕ
		|	НЕ ГрафикиРаботы.ЭтоГруппа";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, Метаданные.Справочники.Календари.ПолноеИмя());
	
	Обработано = 0;
	Проблемных = 0;

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Календари");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		ПредставлениеСсылки = Строка(Выборка.Ссылка);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			ГрафикОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ГрафикОбъект.УчитыватьНерабочиеПериоды = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ГрафикОбъект);
			Обработано = Обработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			Проблемных = Проблемных + 1;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать график работы ""%1"" по причине:
                      |%2'"), 
				ПредставлениеСсылки, 
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.Календари, , 
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, Метаданные.Справочники.Календари.ПолноеИмя()) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	ИмяПроцедуры = "Справочник.Календари.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре %1 не удалось обработать некоторые записи (пропущены): %2'"), 
			ИмяПроцедуры,
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Информация, , ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура %1 обработала очередную порцию записей: %2'"),
			ИмяПроцедуры,
			Обработано));
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли