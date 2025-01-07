﻿
&НаКлиенте
Процедура ПодключитьКомпоненту(Команда)
	ПодключитьКомпонентуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодключитьКомпонентуНаСервере()
	
	АдресВоВременномХранилище = ПолучитьАдресМакетаКомпановкиНаСервере(ЭтаФорма.УникальныйИдентификатор);
	КомпонентаПодключена = ПодключитьВнешнююКомпоненту(
			АдресВоВременномХранилище,
			"BITERP",
			ТипВнешнейКомпоненты.Native);
	Сообщить(НСтр("ru = 'Компонента подключена!'"));

КонецПроцедуры


&НаСервере
Функция ПолучитьАдресМакетаКомпановкиНаСервере(УникальныйИдентификатор)
	
	МакетВнешнейКомпоненты    = Справочники.НастройкиОбменаСообщениями.ПолучитьМакет("ВнешняяКомпонента");
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(МакетВнешнейКомпоненты, УникальныйИдентификатор);
	
	Возврат АдресВоВременномХранилище;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьСообщения(Команда)
	ОбработатьСообщенияНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьСообщенияНаСервере()
	
	 Справочники.ИсходящиеСообщения.ОтправитьСообщения();
	
КонецПроцедуры
