﻿#Область Брокер

Функция ДанныеОбъектаКВыгрузке(Объект) Экспорт
	
	// Упрощено чтоб не изобредать КД или БитАдаптер
	
	ПолноеИмя = Объект.Метаданные().ПолноеИмя();
	ДанныеОбъекта = ОбменСообщениямиПодготовкаСообщенияСервер.ШаблонСообщенияДляПреобразованияОбъектаВJSON();
	ДанныеОбъекта.ПолноеИмяОбъектаМетаданных = ПолноеИмя;
	
	ИндексЗначения = Перечисления.СтатусыЗаказовКлиента.Индекс(Объект);
	Имя = Метаданные.Перечисления.СтатусыЗаказовКлиента.ЗначенияПеречисления[ИндексЗначения].Имя;	
	
	Реквизиты = Новый Структура("Имя", Имя);
	
	ДанныеОбъекта.Реквизиты = Реквизиты;
	
	Возврат ДанныеОбъекта;		
	
КонецФункции

Функция ВыгружаемыеСтатусы() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить(Перечисления.СтатусыЗаказовКлиента.КСборке);
	Результат.Добавить(Перечисления.СтатусыЗаказовКлиента.Отгрузить);
		
	Возврат Результат;	
	
КонецФункции


#КонецОбласти
