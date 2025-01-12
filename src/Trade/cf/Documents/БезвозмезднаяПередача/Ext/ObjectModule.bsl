﻿
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ТоварыОрганизаций.Очистить();
	Движения.ТоварыОрганизаций.Записать(); 
	
	Движения.ТоварыОрганизаций.Записывать = Истина;
	Движения.ПереданныеОбразцы.Записывать = Истина;
	
	Для Каждого Товар Из Товары Цикл
		Движение = Движения.ПереданныеОбразцы.Добавить();
		Движение.Период = Дата;
		Движение.Регистратор = Ссылка;
		Движение.ДокументПередачи = Ссылка;
		Движение.Номенклатура = Товар.Номенклатура;
		Движение.Количество = Товар.Количество;
		Движение.Получатель = Контрагент;	
	КонецЦикла;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ТоварыОрганизаций");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный; 
	ЭлементБлокировки.УстановитьЗначение("Склад", Склад);
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();	
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.БезвозмезднаяПередача.ТекстЗапросаТоварыОрганизаций();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоменТВремени", Ссылка.МоментВремени());
	
	РеультатЗапроса = Запрос.Выполнить();
	
	Выборка = РеультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество > Выборка.КоличествоОстаток Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Недостаточно товара %1 на складе %2", Выборка.НоменклатураПредставление, Выборка.СкладПредставление);
		    Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.ТоварыОрганизаций.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Количество = Выборка.Количество;
		Движение.Склад = Склад;
		Если Выборка.Количество = Выборка.КоличествоОстаток Тогда
			Движение.Сумма = Выборка.СуммаОстаток;	
		Иначе
			Движение.Сумма = (Выборка.СуммаОстаток / Выборка.КоличествоОстаток) * Выборка.Количество;
		КонецЕсли;
				
	КонецЦикла;
	
	Если Не Отказ Тогда
		Движения.ТоварыОрганизаций.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		Основание = ДанныеЗаполнения;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказКлиента.Контрагент КАК Контрагент,
		|	ЗаказКлиента.Склад КАК Склад,
		|	ЗаказКлиента.Товары.(
		|		Ссылка КАК Ссылка,
		|		Номенклатура КАК Номенклатура,
		|		СУММА(Количество) КАК Количество
		|	) КАК Товары
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Товары.(Номенклатура,
		|	Ссылка)";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаШапка = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаШапка.Следующий() Цикл
			
			Контрагент = ВыборкаШапка.Контрагент;
			Склад = ВыборкаШапка.Склад;
			Дата = ТекущаяДатаСеанса();
			
			ВыборкаТовары = ВыборкаШапка.Товары.Выбрать();
			
			Пока ВыборкаТовары.Следующий() Цикл
				
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Номенклатура = ВыборкаТовары.Номенклатура;
				НоваяСтрока.Количество = ВыборкаТовары.Количество;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти