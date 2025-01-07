﻿#Область ПрограммныйИнтерфейс

#Область Проведение

#КонецОбласти

#КонецОбласти 


#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
		
КонецПроцедуры

// Добавляет команду создания документа.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю.
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
	КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.БезвозмезднаяПередача.ПолноеИмя();
	КомандаСоздатьНаОсновании.Представление = Метаданные.Документы.БезвозмезднаяПередача.ПолноеИмя();
	КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
	КомандаСоздатьНаОсновании.Порядок = 0;
	
	Возврат КомандаСоздатьНаОсновании;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	

КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьТранспортнойНакладной";
	КомандаПечати.Представление = НСтр("ru = 'Какая-то транспортная накладная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьТранспортнойНакладной") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПечатьТранспортнойНакладной",
			НСтр("ru = 'Какая-то транспортная накладная'"),
			СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов));
		
	КонецЕсли;
		
КонецПроцедуры

Функция ДополнительныеДокументыПечати(МассивДокументов) Экспорт
	
	Возврат МассивДокументов;
	
КонецФункции

#КонецОбласти 

#Область ТекстыЗапросов

Функция ТекстЗапросаТоварыОрганизаций() Экспорт
		
	ТекстЗапроса = "ВЫБРАТЬ
	|	БезвозмезднаяПередачаТовары.Номенклатура КАК Номенклатура,
	|	БезвозмезднаяПередачаТовары.Количество КАК Количество,
	|	БезвозмезднаяПередачаТовары.Ссылка.Склад КАК Склад
	|ПОМЕСТИТЬ ВТДанныеДкоумента
	|ИЗ
	|	Документ.БезвозмезднаяПередача.Товары КАК БезвозмезднаяПередачаТовары
	|ГДЕ
	|	БезвозмезднаяПередачаТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОрганизацийОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыОрганизацийОстатки.Склад КАК Склад,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	ТоварыОрганизацийОстатки.СуммаОстаток КАК СуммаОстаток
	|ПОМЕСТИТЬ ВТОстатки
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|			&МоментВремени,
	|			(Номенклатура, Склад) В
	|				(ВЫБРАТЬ
	|					ВТДанныеДкоумента.Номенклатура КАК Номенклатура,
	|					ВТДанныеДкоумента.Склад КАК Склад
	|				ИЗ
	|					ВТДанныеДкоумента КАК ВТДанныеДкоумента)) КАК ТоварыОрганизацийОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДанныеДкоумента.Номенклатура КАК Номенклатура,
	|	ВТДанныеДкоумента.Количество КАК Количество,
	|	ВТДанныеДкоумента.Склад КАК Склад,
	|	ЕСТЬNULL(ВТОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(ВТОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|	ВТДанныеДкоумента.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ВТДанныеДкоумента.Склад.Представление КАК СкладПредставление
	|ИЗ
	|	ВТДанныеДкоумента КАК ВТДанныеДкоумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОстатки КАК ВТОстатки
	|		ПО ВТДанныеДкоумента.Номенклатура = ВТОстатки.Номенклатура
	|			И ВТДанныеДкоумента.Склад = ВТОстатки.Склад";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов) 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = Документы.БезвозмезднаяПередача.ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БезвозмезднаяПередача.Дата КАК Дата,
	|	БезвозмезднаяПередача.Контрагент КАК Контрагент,
	|	БезвозмезднаяПередача.Номер КАК Номер,
	|	БезвозмезднаяПередача.Склад КАК Склад,
	|	БезвозмезднаяПередача.Товары.(
	|		Номенклатура КАК Номенклатура,
	|		Количество КАК Количество
	|	) КАК Товары,
	|	БезвозмезднаяПередача.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.БезвозмезднаяПередача КАК БезвозмезднаяПередача
	|ГДЕ
	|	БезвозмезднаяПередача.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТоварыШапка = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьТовары = Макет.ПолучитьОбласть("СтрокаТовары");
	ТабличныйДокумент.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		Шапка.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(Шапка, Выборка.Уровень());

		ТабличныйДокумент.Вывести(ОбластьТоварыШапка);
		ВыборкаТовары = Выборка.Товары.Выбрать();
		Пока ВыборкаТовары.Следующий() Цикл
			ОбластьТовары.Параметры.Заполнить(ВыборкаТовары);
			ТабличныйДокумент.Вывести(ОбластьТовары, ВыборкаТовары.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти


