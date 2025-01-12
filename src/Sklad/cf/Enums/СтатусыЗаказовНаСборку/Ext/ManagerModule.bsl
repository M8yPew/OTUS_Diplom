﻿#Область Брокер

Функция ВыгружаемыеСтатусы() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить(Перечисления.СтатусыЗаказовНаСборку.ГотовКОтгрузке);
	Результат.Добавить(Перечисления.СтатусыЗаказовНаСборку.Отгружено);
		
	Возврат Результат;	
	
КонецФункции  

Функция ДанныеОбъектаКВыгрузке(Объект) Экспорт
	
	// Упрощено чтоб не изобредать КД или БитАдаптер
	
	ПолноеИмя = Объект.Метаданные().ПолноеИмя();
	ДанныеОбъекта = ОбменСообщениямиПодготовкаСообщенияСервер.ШаблонСообщенияДляПреобразованияОбъектаВJSON();
    ДанныеОбъекта.ПолноеИмяОбъектаМетаданных = ПолноеИмя;
	
	ИндексЗначения = Перечисления.СтатусыЗаказовНаСборку.Индекс(Объект);
	Имя = Метаданные.Перечисления.СтатусыЗаказовНаСборку.ЗначенияПеречисления[ИндексЗначения].Имя;	
	
	Реквизиты = Новый Структура("Имя", Имя);
	
	ДанныеОбъекта.Реквизиты = Реквизиты;
	
	Возврат ДанныеОбъекта;	
	
КонецФункции 

#КонецОбласти

