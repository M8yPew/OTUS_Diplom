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

	УстановитьУсловноеОформление();
	
	ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию();
	ОтборЖурналаРегистрации = ОбщегоНазначения.СкопироватьРекурсивно(ОтборЖурналаРегистрацииПоУмолчанию);
	
	КоличествоПоказываемыхСобытий = 200;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПросмотрЗарегистрированныхСобытий",
			"ОтображатьЗаголовок", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОтбора", "Группировка",
			ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КоличествоПоказываемыхСобытий",
			"Заголовок", НСтр("ru = 'Показывать'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КомандыОтбора", "Отображение",
			ОтображениеГруппыКнопок.Компактное);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КомандыПоиска", "Отображение",
			ОтображениеГруппыКнопок.Компактное);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаНайти", "Отображение",
			ОтображениеКнопки.Картинка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтменитьПоиск", "Отображение",
			ОтображениеКнопки.Картинка);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПросмотрТекущегоСобытияВОтдельномОкне",
			"ТолькоВоВсехДействиях", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбновитьТекущийСписок",
			"ТолькоВоВсехДействиях", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтменитьПоиск",
			"ТолькоВоВсехДействиях", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Справка", "ТолькоВоВсехДействиях",
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьТекущийСписок", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ТекущиеДанные", Элементы.Журнал.ТекущиеДанные);
	ПараметрыВыбора.Вставить("Поле", Поле);
	ПараметрыВыбора.Вставить("ИнтервалДат", ИнтервалДат);
	ПараметрыВыбора.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ПараметрыВыбора.Вставить("ХранилищеДанных", ХранилищеДанных);
	
	ЖурналРегистрацииКлиент.СобытияВыбор(ПараметрыВыбора);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	
#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	КоличествоПоказываемыхСобытий = ?(КоличествоПоказываемыхСобытий > 1000, 1000, КоличествоПоказываемыхСобытий);
#КонецЕсли
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьТекущийСписок() 
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	РезультатВыполнения = ПрочитатьЖурнал(ОтборЖурналаРегистрации);
	
	Если РезультатВыполнения.Статус <> "Выполняется" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций,
		"ФормированиеОтчета");
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьТекущийСписокЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	
	ОтборЖурналаРегистрации = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ОтборЖурналаРегистрацииПоУмолчанию);
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	
	ЖурналРегистрацииКлиент.ПросмотрТекущегоСобытияВОтдельномОкне(Элементы.Журнал.ТекущиеДанные, ХранилищеДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект);
	ЖурналРегистрацииКлиент.УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации, Оповещение)
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЗначениюВТекущейКолонке()
	
	// Для установки отбора по значению в текущей колонке, 
	// отбор по умолчанию сначала отключается, а затем восстанавливается.
	
	УдалитьИзОтбораЗначенияПоУмолчанию();
	
	КолонкиИсключения = Новый Массив;
	КолонкиИсключения.Добавить("Дата");
	КолонкиИсключения.Добавить("СведенияОСобытии");
	
	ОбновлятьСписок = ЖурналРегистрацииКлиент.УстановитьОтборПоЗначениюВТекущейКолонке(Элементы.Журнал.ТекущиеДанные,
		Элементы.Журнал.ТекущийЭлемент, ОтборЖурналаРегистрации, КолонкиИсключения);
	
	ДополнитьОтборЗначениямиПоУмолчанию();
	
	Если ОбновлятьСписок Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Журнал.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал.Событие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить("_$Session$_.AuthenticationError");
	СписокЗначений.Добавить("_$Access$_.AccessDenied");
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.СобытиеОтказ);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(ИнтервалУстановлен, ДополнительныеПараметры) Экспорт
	
	Если ИнтервалУстановлен Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОтчета(ОтборЖурналаНаКлиенте)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Журнал", РеквизитФормыВЗначение("Журнал"));
	ПараметрыОтчета.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаНаКлиенте);
	ПараметрыОтчета.Вставить("КоличествоПоказываемыхСобытий", КоличествоПоказываемыхСобытий);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("МенеджерВладельца", Обработки.ЗащитаПерсональныхДанных);
	ПараметрыОтчета.Вставить("ДобавлятьДополнительныеКолонки", Истина);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию()
	
	ОтборЖурналаРегистрацииПоУмолчанию = Новый Структура;
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("Событие", СписокКонтролируемыхСобытий152ФЗ());
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("ИмяПриложения", СписокКонтролируемыхПриложений152ФЗ());
	
КонецПроцедуры

// Функция определяет перечень событий журнала регистрации в соответствии с требованиями 152-ФЗ.
// 
// Возвращаемое значение:
//  СписокЗначений из Строка
&НаСервере
Функция СписокКонтролируемыхСобытий152ФЗ()

	СписокСобытий = Новый СписокЗначений;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСписок(СписокСобытий,
		ЗащитаПерсональныхДанных.КонтролируемыеСобытияДоступа());
		
	ОбщегоНазначенияКлиентСервер.ДополнитьСписок(СписокСобытий,
		ЗащитаПерсональныхДанных.КонтролируемыеСобытияАутентификации());
	
	Возврат СписокСобытий;
	
КонецФункции

// Функция определяет перечень контролируемых приложений системы в соответствии с требованиями 152-ФЗ.
//  
// Возвращаемое значение:
//  Массив - см. ЗащитаПерсональныхДанных.КонтролируемыеПриложенияДоступа
&НаСервере
Функция СписокКонтролируемыхПриложений152ФЗ()
	
	Возврат ЗащитаПерсональныхДанных.КонтролируемыеПриложенияДоступа();
	
КонецФункции

&НаСервере
Функция ПрочитатьЖурнал(ОтборЖурналаНаКлиенте)
	
	ПараметрыОтчета = ПараметрыОтчета(ОтборЖурналаНаКлиенте);
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("Статус", "Выполнено");
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций,
		"НеИспользовать");
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Защита персональных данных'");
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ЗащитаПерсональныхДанных.ПрочитатьСобытияДоступаКПерсональнымДанным", ПараметрыОтчета, ПараметрыВыполнения);
		
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	Если РезультатВыполнения.Статус = "Ошибка" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ВызватьИсключение РезультатВыполнения.КраткоеПредставлениеОшибки; 
	КонецЕсли;
	ЖурналРегистрации.СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаНаКлиенте,
		ОтборЖурналаРегистрацииПоУмолчанию);
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные(РезультатВыполнения.АдресРезультата);
	КонецЕсли;

	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ДополнитьОтборЗначениямиПоУмолчанию()
	
	Для Каждого ЭлементОтбора Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбораПоУмолчанию = ЭлементОтбора.Значение;
		Если НЕ ОтборЖурналаРегистрации.Свойство(ЭлементОтбора.Ключ) Тогда
			// Отбор не был установлен
			Если ТипЗнч(ЗначениеОтбораПоУмолчанию) = Тип("СписокЗначений") Тогда
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию.Скопировать());
			Иначе
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзОтбораЗначенияПоУмолчанию()
	
	Для Каждого ЭлементОтбораПоУмолчанию Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбора = "";
		Если ОтборЖурналаРегистрации.Свойство(ЭлементОтбораПоУмолчанию.Ключ, ЗначениеОтбора) Тогда
			// Отбор удаляется только в случае, если он в точности соответствует значению отбора по умолчанию.
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				УдалятьОтбор = ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ЗначениеОтбора,
					ЭлементОтбораПоУмолчанию.Значение);
			Иначе
				УдалятьОтбор = ЭлементОтбораПоУмолчанию.Значение = ЗначениеОтбора;
			КонецЕсли;
			Если УдалятьОтбор Тогда
				ОтборЖурналаРегистрации.Удалить(ЭлементОтбораПоУмолчанию.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(АдресХранилища)
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	СобытияЖурнала = РезультатВыполнения.СобытияЖурнала;
	
	Если ХранилищеДанных = Неопределено Тогда
		Адрес = УникальныйИдентификатор;
	Иначе
		Адрес = ХранилищеДанных;
	КонецЕсли;
	ХранилищеДанных = ПоместитьВоВременноеХранилище(Новый Соответствие, Адрес); 
	
	Если ЗначениеЗаполнено(СобытияЖурнала) Тогда
		ЖурналРегистрации.ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, ХранилищеДанных);
		ЗначениеВДанныеФормы(СобытияЖурнала, Журнал);
	Иначе
		Журнал.Очистить();
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийСписокЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций,
			"НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные(Результат.АдресРезультата);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций,
		"НеИспользовать");
	Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
	ПозиционированиеВКонецСписка();
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПозиционированиеВКонецСписка()
	Если Журнал.Количество() > 0 Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры 

#КонецОбласти
