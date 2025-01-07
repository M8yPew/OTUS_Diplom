﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыВнешнихПользователей; // Состав внешних пользователей группы внешних
                                              // пользователей до изменения для использования
                                              // в обработчике события ПриЗаписи.

Перем СтарыйСоставРолейГруппыВнешнихПользователей; // Состав ролей группы внешних пользователей
                                                   // до изменения для использования в обработчике
                                                   // события ПриЗаписи.

Перем СтароеЗначениеВсеОбъектыАвторизации; // Значение реквизита ВсеОбъектыАвторизации
                                           // до изменения для использования в обработчике
                                           // события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ПроверенныеРеквизитыОбъекта = ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта;
	Иначе
		ПроверенныеРеквизитыОбъекта = Новый Массив;
	КонецЕсли;
	
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	ТекстОшибки = ТекстОшибкиПроверкиРодителя();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель", ТекстОшибки, "");
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся внешних пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.ВнешнийПользователь");
	
	// Проверка назначения группы.
	ТекстОшибки = ТекстОшибкиПроверкиНазначения();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Назначение", ТекстОшибки, "");
	КонецЕсли;
	ПроверенныеРеквизитыОбъекта.Добавить("Назначение");
	
	Для каждого ТекущаяСтрока Из Состав Цикл
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВнешнийПользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru = 'Внешний пользователь не выбран.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Внешний пользователь в строке %1 не выбран.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("ВнешнийПользователь", ТекущаяСтрока.ВнешнийПользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				НСтр("ru = 'Внешний пользователь повторяется.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Внешний пользователь в строке %1 повторяется.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после блокировки регистра.
	// Блокировка всего регистра используется вместо установки разделяемой блокировки на справочник,
	// которая приводит к взаимоблокировке при иерархическом обновлении составов групп пользователей,
	// а также вместо последовательной исключительной блокировки регистра в разрезе групп,
	// которая также приводит к взаимоблокировке в ряде случаев.
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("РегистрСведений.СоставыГруппПользователей");
	Блокировка.Заблокировать();
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Роли");
		Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
			СтарыйСоставРолейГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
		Иначе
			СтарыйСоставРолейГруппыВнешнихПользователей = Роли.Выгрузить(Новый Массив);
		КонецЕсли;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		ЗаполнитьНазначениеВсемиТипамиВнешнихПользователей();
		ВсеОбъектыАвторизации  = Ложь;
	КонецЕсли;
	
	ТекстОшибки = ТекстОшибкиПроверкиРодителя();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение
				НСтр("ru = 'Добавление участников в предопределенную группу ""Все внешние пользователи"" запрещено.'");
		КонецЕсли;
	Иначе
		ТекстОшибки = ТекстОшибкиПроверкиНазначения();
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Ссылка, "ВсеОбъектыАвторизации, Родитель");
		
		СтарыйРодитель                      = СтарыеЗначения.Родитель;
		СтароеЗначениеВсеОбъектыАвторизации = СтарыеЗначения.ВсеОбъектыАвторизации;
		
		Если ЗначениеЗаполнено(Ссылка)
		   И Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			
			РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Состав");
			Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
				СтарыйСоставГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
			Иначе
				СтарыйСоставГруппыВнешнихПользователей = Состав.Выгрузить(Новый Массив);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		ИзменилсяСоставРолейГруппыВнешнихПользователей = Ложь;
		
	Иначе
		ИзменилсяСоставРолейГруппыВнешнихПользователей =
			ПользователиСлужебный.РазличияЗначенийКолонки(
				"Роль",
				Роли.Выгрузить(),
				СтарыйСоставРолейГруппыВнешнихПользователей).Количество() <> 0;
	КонецЕсли;
	
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	Если Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		
		Если ВсеОбъектыАвторизации
		 ИЛИ СтароеЗначениеВсеОбъектыАвторизации = Истина Тогда
			
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Ссылка, , УчастникиИзменений, ИзмененныеГруппы);
		Иначе
			ИзмененияСостава = ПользователиСлужебный.РазличияЗначенийКолонки(
				"ВнешнийПользователь",
				Состав.Выгрузить(),
				СтарыйСоставГруппыВнешнихПользователей);
			
			ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
				Ссылка, ИзмененияСостава, УчастникиИзменений, ИзмененныеГруппы);
			
			Если СтарыйРодитель <> Родитель Тогда
				
				Если ЗначениеЗаполнено(Родитель) Тогда
					ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
						Родитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтарыйРодитель) Тогда
					ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
						СтарыйРодитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
			Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;
	
	Если ИзменилсяСоставРолейГруппыВнешнихПользователей Тогда
		ПользователиСлужебный.ОбновитьРолиВнешнихПользователей(Ссылка);
	КонецЕсли;
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппВнешнихПользователей(
		УчастникиИзменений, ИзмененныеГруппы);
	
	ИнтеграцияПодсистемБСП.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНазначениеВсемиТипамиВнешнихПользователей()
	
	Назначение.Очистить();
	
	ПустыеСсылки = ПользователиСлужебныйПовтИсп.ПустыеСсылкиТиповОбъектовАвторизации();
	Для Каждого ПустаяСсылка Из ПустыеСсылки Цикл
		НоваяСтрока = Назначение.Добавить();
		НоваяСтрока.ТипПользователей = ПустаяСсылка;
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстОшибкиПроверкиРодителя()
	
	Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Возврат
			НСтр("ru = 'Предопределенная группа ""Все внешние пользователи"" не может быть родителем.'");
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Если Не Родитель.Пустая() Тогда
			Возврат
				НСтр("ru = 'Предопределенная группа ""Все внешние пользователи"" не может быть перемещена.'");
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			Возврат
				НСтр("ru = 'Невозможно добавить подгруппу к предопределенной группе ""Все внешние пользователи"".'");
			
		ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ВсеОбъектыАвторизации") = Истина Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно добавить подгруппу к группе ""%1"",
				           |так как в число ее участников входят все пользователи.'"), Родитель);
		КонецЕсли;
		
		Если ВсеОбъектыАвторизации И ЗначениеЗаполнено(Родитель) Тогда
			Возврат
				НСтр("ru = 'Невозможно переместить группу, в число участников которой входят все пользователи.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ТекстОшибкиПроверкиНазначения()
	
	// Проверка заполнения назначения группы.
	Если Назначение.Количество() = 0 Тогда
		Возврат НСтр("ru = 'Не указан вид участников группы.'");
	КонецЕсли;
	
	// Проверка уникальности группы всех объектов авторизации заданного типа.
	Если ВсеОбъектыАвторизации Тогда
		
		// Проверка что назначение не совпадает с группой все внешние пользователи.
		ГруппаВсеВнешниеПользователи = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		НазначениеВсеВнешниеПользователи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ГруппаВсеВнешниеПользователи, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
		МассивНазначения = Назначение.ВыгрузитьКолонку("ТипПользователей");
		
		Если ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(НазначениеВсеВнешниеПользователи, МассивНазначения) Тогда
			Возврат
				НСтр("ru = 'Невозможно создать группу, совпадающую по назначению
				           |с предопределенной группой ""Все внешние пользователи"".'");
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ТипыПользователей", Назначение.Выгрузить());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТипыПользователей.ТипПользователей
		|ПОМЕСТИТЬ ТипыПользователей
		|ИЗ
		|	&ТипыПользователей КАК ТипыПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
		|ИЗ
		|	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователей
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				ТипыПользователей КАК ТипыПользователей
		|			ГДЕ
		|				ГруппыВнешнихПользователей.Ссылка <> &Ссылка
		|				И ГруппыВнешнихПользователей.Ссылка.ВсеОбъектыАвторизации
		|				И ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей) = ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователей.ТипПользователей))";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
		
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Уже существует группа ""%1"",
				           |в число участников которой входят все пользователи указанных видов.'"),
				Выборка.СсылкаПредставление);
		КонецЕсли;
	КонецЕсли;
	
	// Проверка совпадения типа объектов авторизации с родителем
	// (допустимо, если тип у родителя не задан).
	Если ЗначениеЗаполнено(Родитель) Тогда
		
		ТипПользователейРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Родитель, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
		ТипПользователей = Назначение.ВыгрузитьКолонку("ТипПользователей");
		
		Для Каждого ТипПользователя Из ТипПользователей Цикл
			Если ТипПользователейРодителя.Найти(ТипПользователя) = Неопределено Тогда
				Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Вид участников группы должен быть как у вышестоящей
					           |группы внешних пользователей ""%1"".'"), Родитель);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Если группе внешних пользователей устанавливается тип участников "Все пользователи заданного типа",
	// проверяем наличие подчиненных групп.
	Если ВсеОбъектыАвторизации
		И ЗначениеЗаполнено(Ссылка) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
		|ИЗ
		|	Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
		|ГДЕ
		|	ГруппыВнешнихПользователей.Родитель = &Ссылка";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Возврат
				НСтр("ru = 'Невозможно изменить вид участников группы,
				           |так как у нее имеются подгруппы.'");
		КонецЕсли;
	КонецЕсли;
	
	// Проверка, что при изменении типа объектов авторизации
	// нет подчиненных элементов другого типа (очистка типа допустима).
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ТипыПользователей", Назначение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТипыПользователей.ТипПользователей
		|ПОМЕСТИТЬ ТипыПользователей
		|ИЗ
		|	&ТипыПользователей КАК ТипыПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователейНазначение.Ссылка) КАК СсылкаПредставление
		|ИЗ
		|	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователейНазначение
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				ТипыПользователей КАК ТипыПользователей
		|			ГДЕ
		|				ГруппыВнешнихПользователейНазначение.Ссылка.Родитель = &Ссылка
		|				И ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователейНазначение.ТипПользователей) <> ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей))";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно изменить вид участников группы,
				           |так как у нее имеется подгруппа ""%1"" с другим назначением участников.'"),
				Выборка.СсылкаПредставление);
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли