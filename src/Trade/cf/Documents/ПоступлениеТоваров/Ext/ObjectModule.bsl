﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ТоварыОрганизаций.Очистить();
	Движения.ТоварыОрганизаций.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеТоваровТовары.Ссылка.Склад КАК Склад,
	|	ПоступлениеТоваровТовары.Номенклатура КАК Номенклатура,
	|	ПоступлениеТоваровТовары.Количество КАК Количество,
	|	ПоступлениеТоваровТовары.Сумма КАК Сумма,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДВиженияНакопления.Приход) КАК ВидДвижения
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК ПоступлениеТоваровТовары
	|ГДЕ
	|	ПоступлениеТоваровТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Результат = РезультатЗапроса.Выгрузить();
		
		Движения.ТоварыОрганизаций.Загрузить(Результат);
		
	КонецЕсли;
	
	Движения.Записать();
	
КонецПроцедуры


#КонецОбласти