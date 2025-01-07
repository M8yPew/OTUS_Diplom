﻿#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьСообщениеДляОтправки(Объект) Экспорт
	
	СтруктураСообщенияДляОтправки = СтруктураСообщенияДляОтправки();
	ПолноеИмяОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект)).ПолноеИмя();
		
	НастройкиОбменаСообщениями = Справочники.НастройкиОбменаСообщениями.НастройкиПодключенияПоПолномуИмени(ПолноеИмяОбъекта);
	//ЗаполнитьЗначенияСвойств(СтруктураСообщенияДляОтправки, НастройкиОбменаСообщениями);
	ОбменСообщениямиПодготовкаСообщенияСервер.ПодготовитьСообщение(Объект, СтруктураСообщенияДляОтправки, НастройкиОбменаСообщениями);
	
	Если СтруктураСообщенияДляОтправки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Получатель Из НастройкиОбменаСообщениями.Получатели Цикл
		
		ИсходящееСообщение 						= Справочники.ИсходящиеСообщения.СоздатьЭлемент();
		ИсходящееСообщение.КлючМаршрутизации   	= ПолноеИмяОбъекта + "." + Получатель.КлючМаршрутизации;
		ИсходящееСообщение.ТекстСообщения       = СтруктураСообщенияДляОтправки.ТекстСообщения; 
		ИсходящееСообщение.ИмяОчереди           = Получатель.ИмяОчереди;
		ИсходящееСообщение.ТочкаОбмена          = Получатель.ТочкаОбмена;
		ИсходящееСообщение.ДатаФормированияВмилисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ИсходящееСообщение.Записать();
		
	КонецЦикла;
	
КонецПроцедуры 

Процедура ОтправитьСообщения() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 5
	|	ИсходящиеСообщения.Ссылка КАК Ссылка,
	|	ИсходящиеСообщения.КлючМаршрутизации КАК КлючМаршрутизации,
	|	ИсходящиеСообщения.ТекстСообщения КАК ТекстСообщения,
	|	ИсходящиеСообщения.Отправлено КАК Отправлено,
	|	ИсходящиеСообщения.ТочкаОбмена КАК ТочкаОбмена,
	|	ИсходящиеСообщения.ИмяОчереди КАК ИмяОчереди
	|ИЗ
	|	Справочник.ИсходящиеСообщения КАК ИсходящиеСообщения
	|ГДЕ
	|	ИсходящиеСообщения.Отправлено = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИсходящиеСообщения.Код,
	|	ИсходящиеСообщения.ДатаФормированияВмилисекундах";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		КлиентКомпоненты = Справочники.НастройкиОбменаСообщениями.ПолучитьКомпонентуСервер();
		НастройкиПодключенияПоУмолчанию = Справочники.НастройкиОбменаСообщениями.НастройкиПодключенияПоУмолчанию();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОтправитьСообщение(КлиентКомпоненты, НастройкиПодключенияПоУмолчанию, ВыборкаДетальныеЗаписи);	
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьСообщение(КлиентКомпоненты, НастройкиПодключения, ДанныеСообщения) Экспорт
	
	Попытка
		КлиентКомпоненты.Connect(
			НастройкиПодключения.Адрес,
			НастройкиПодключения.Порт,
			НастройкиПодключения.Логин,
			НастройкиПодключения.Пароль,
			НастройкиПодключения.ВиртуальныйХост);
		
		ТочкаОбмена    = ДанныеСообщения.ТочкаОбмена;
		ИмяОчереди     = ДанныеСообщения.ИмяОчереди;
		ТекстСообщения = ДанныеСообщения.ТекстСообщения;
		КлючМаршрутизации = ДанныеСообщения.КлючМаршрутизации;
		
		КлиентКомпоненты.BasicPublish(
		ТочкаОбмена,
		КлючМаршрутизации,
		ТекстСообщения,
		1,
		Ложь);  
		
		Сообщение = ДанныеСообщения.Ссылка.ПолучитьОбъект();
		Сообщение.Отправлено = Истина;
		Сообщение.Записать();
	Исключение
		СистемнаяОшибка = ОписаниеОшибки();
		СистемнаяОшибка = КлиентКомпоненты.GetLastError();
		ТекстСообщения = "Ошибка отправки сообщения!%СистемнаяОшибка%";
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СистемнаяОшибка%", СистемнаяОшибка);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураСообщенияДляОтправки()
	
	СтруктураСообщения = Новый Структура();
	СтруктураСообщения.Вставить("КлючМаршрутизации");
	СтруктураСообщения.Вставить("ТекстСообщения");
	СтруктураСообщения.Вставить("ИмяОчереди");
	СтруктураСообщения.Вставить("ТочкаОбмена");
	СтруктураСообщения.Вставить("Источник");
	Возврат СтруктураСообщения;	
	
КонецФункции

#КонецОбласти

