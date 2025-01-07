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
	
	Если Объект.Предопределенный Или Объект.ЗапретитьРедактированиеПользователем Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Тип.ТолькоПросмотр          = Истина;
		Элементы.ГруппаТипОбщиеДляВсех.ТолькоПросмотр = Объект.ЗапретитьРедактированиеПользователем;
		Элементы.ИдентификаторДляФормул.ТолькоПросмотр = Истина;
	Иначе
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект,, НСтр("ru = 'Разрешить редактирование типа и группы'"));
			
		Иначе
			Элементы.Родитель.ТолькоПросмотр = Истина;
			Элементы.Тип.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВидОснование = Параметры.ЗначениеКопирования;
	СозданКопированием = Не ВидОснование.Пустая();

	Если Объект.Ссылка.Пустая() И НЕ СозданКопированием Тогда
		Объект.ВидРедактирования = "ПолеВводаИДиалог";
	КонецЕсли;
	
	СсылкаРодителя = Объект.Родитель;
	Элементы.ХранитьИсториюИзменений.Доступность         = Объект.ВидРедактирования = "Диалог";
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = НЕ Объект.ХранитьИсториюИзменений;	
	Элементы.ОтображатьВсегда.Доступность = НЕ Объект.ОбязательноеЗаполнение;
	ОбновитьДоступностьЭлементовТелефонаФакса(ЭтотОбъект);
	
	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		Элементы.ВидРедактирования.Доступность                  = Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность    = Ложь;
		Элементы.ГруппаНаименованиеНастройкиПоТипам.Доступность = Ложь;
		Элементы.ХранитьИсториюИзменений.Доступность            = Ложь;
	КонецЕсли;
	
	Если Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес
		ИЛИ НЕ СсылкаРодителя.Пустая()
		ИЛИ СсылкаРодителя.Уровень() = 0 Тогда
		ТабличнаяЧасть = Неопределено;
		
		РеквизитыРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаРодителя, "ИмяПредопределенныхДанных, ИмяПредопределенногоВида");
		ИмяПредопределенногоВида = ?(ЗначениеЗаполнено(РеквизитыРодителя.ИмяПредопределенногоВида),
			РеквизитыРодителя.ИмяПредопределенногоВида, РеквизитыРодителя.ИмяПредопределенныхДанных);
		
		Если СтрНачинаетсяС(ИмяПредопределенногоВида, "Справочник") Тогда
			ИмяОбъекта = Сред(ИмяПредопределенногоВида, СтрДлина("Справочник") + 1);
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Справочники[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		ИначеЕсли СтрНачинаетсяС(ИмяПредопределенногоВида, "Документ") Тогда
			ИмяОбъекта = Сред(ИмяПредопределенногоВида, СтрДлина("Документ") + 1);
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Документы[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		КонецЕсли;
		
		Если ТабличнаяЧасть <> Неопределено Тогда
			Если ТабличнаяЧасть.Реквизиты.Найти("ДействуетС") <> Неопределено Тогда
				ХранитИсториюИзменений = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если (Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон
		Или Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Факс)
		И Объект.ВидРедактирования = "Диалог" Тогда
			Элементы.МаскаПриВводеНомераТелефона.Доступность = Ложь;
	КонецЕсли;
	
	Если Метаданные.Обработки.Найти("РасширенныйВводКонтактнойИнформации") <> Неопределено Тогда
		МодульРасширенныйВводКонтактнойИнформации = ОбщегоНазначения.ОбщийМодуль("Обработки.РасширенныйВводКонтактнойИнформации");
		ДоступныДополнительныеНастройкиАдреса = МодульРасширенныйВводКонтактнойИнформации.ДоступныДополнительныеНастройкиАдреса()
	Иначе 
		ДоступныДополнительныеНастройкиАдреса = Ложь;
	КонецЕсли;
		
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;
	
	Элементы.ЗаполнитьИдентификаторДляФормул.Доступность = НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;
	
	Если УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ДоступныМодулиРаботаСАдресами() Тогда
		МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
		МодульРаботаСАдресами.ЗаполнитьМаскиНомераТелефона(Элементы.ШаблонМаскиНомераТелефона.СписокВыбора);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьОтображениеПриИзмененииТипа();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеВводаСтрокНаРазныхЯзыках"
		И Параметр = ЭтотОбъект Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ОбновитьПредлагаемоеЗначениеИдентификатора();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)   
	
	Если Объект.ТелефонСДобавочнымНомером И Объект.ВводитьНомерПоМаске Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
			"ru = 'Нельзя вводить номер телефона с добавочным номером при установленной настройке ""Вводить номер по маске""'"),
			, "ТелефонСДобавочнымНомером", "Объект", Отказ);
	КонецЕсли;
	
	Если НЕ ПараметрыЗаписи.Свойство("КогдаИдентификаторДляФормулУжеИспользуется")
		И ЗначениеЗаполнено(Объект.ИдентификаторДляФормул) Тогда
		// Заполнение идентификатора для формул
		// и проверка есть ли свойство с тем же наименованием.
		ТекстВопроса = ИдентификаторДляФормулУжеИспользуется(
			Объект.ИдентификаторДляФормул, Объект.Ссылка, Объект.Родитель);
		
		Если ЗначениеЗаполнено(ТекстВопроса) Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("ПродолжитьЗапись",              НСтр("ru = 'Продолжить'"));
			Кнопки.Добавить("ВернутьсяКВводуИдентификатора", НСтр("ru = 'Отмена'"));
			
			Отказ = Истина;
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПослеОтветаНаВопросКогдаИдентификаторДляФормулУжеИспользуется", ЭтотОбъект, ПараметрыЗаписи),
				ТекстВопроса, Кнопки, , "ПродолжитьЗапись");
			
		Иначе
			ПараметрыЗаписи.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ВидКИСТакимНаименованиемУжеСуществует(ТекущийОбъект) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вид контактной информации с наименованием %1 уже существует. Задайте другое наименование.'"),
			Строка(ТекущийОбъект.Наименование));
		
	КонецЕсли;
	
	// Формирование идентификатора для формул дополнительного реквизита (сведения).
	Если Не ЗначениеЗаполнено(ТекущийОбъект.ИдентификаторДляФормул)
		Или ПараметрыЗаписи.Свойство("КогдаИдентификаторДляФормулУжеИспользуется") Тогда
		
		НаименованиеОбъекта = ЗаголовокДляИдентификатора(ТекущийОбъект);
		
		ТекущийОбъект.ИдентификаторДляФормул = Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(
			НаименованиеОбъекта, ТекущийОбъект.Ссылка, ТекущийОбъект.Родитель);
		
		ПараметрыЗаписи.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
	КонецЕсли;
	Если ПараметрыЗаписи.Свойство("ПроверкаИдентификатораДляФормулВыполнена") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.Предопределенный Тогда
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ЗаполнитьИдентификаторДляФормул.Доступность = НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьПредлагаемоеЗначениеИдентификатора();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТипа();
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбязательноеЗаполнениеПриИзменении(Элемент)
	
	Если Объект.ОбязательноеЗаполнение Тогда
		Объект.ОтображатьВсегда = Истина;
		Элементы.ОтображатьВсегда.Доступность = Ложь;
	Иначе
		Элементы.ОтображатьВсегда.Доступность = Истина;
	КонецЕсли; 
	 
КонецПроцедуры

&НаКлиенте
Процедура ВидРедактированияПриИзменении(Элемент)
	
	Если Объект.ВидРедактирования = "Диалог" Тогда
		Элементы.ХранитьИсториюИзменений.Доступность     = Истина;
		Объект.ВводитьНомерПоМаске                       = Ложь;
	Иначе
		Элементы.ХранитьИсториюИзменений.Доступность     = Ложь;
		Объект.ХранитьИсториюИзменений                   = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементовТелефонаФакса(ЭтотОбъект);
	
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = НЕ Объект.ХранитьИсториюИзменений;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранитьИсториюИзмененийПриИзменении(Элемент)
	
	Если Объект.ХранитьИсториюИзменений Тогда
		Объект.РазрешитьВводНесколькихЗначений = Ложь;
	КонецЕсли;
	
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = Не Объект.ХранитьИсториюИзменений;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВводНесколькихЗначенийПриИзменении(Элемент)
	
	Если Объект.РазрешитьВводНесколькихЗначений Тогда
		Объект.ХранитьИсториюИзменений = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура МеждународныйФорматАдресаПриИзменении(Элемент)
	
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонСДобавочнымНомеромПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовТелефонаФакса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МаскаПриВводеНомераТелефонаПриИзменении(Элемент)

	ОбновитьДоступностьЭлементовТелефонаФакса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиент");
		МодульМультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Предопределенный Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
			Оповещение = Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
			МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект, Оповещение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = Неопределено Тогда
		Элементы.ЗаполнитьИдентификаторДляФормул.Доступность = НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеНастройкиАдреса(Команда)
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыНастроекАдреса", ЭтотОбъект);
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Объект", Объект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ИмяФормыНастройкиАдреса = "Обработка.РасширенныйВводКонтактнойИнформации.Форма.НастройкиАдреса";
	ОткрытьФорму(ИмяФормыНастройкиАдреса, ПараметрыФормы,,,,, ОповещениеОЗакрытие);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИдентификаторДляФормул(Команда)
	ЗаполнитьИдентификаторДляФормулНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Адрес;
		Элементы.ВидРедактирования.Доступность  = Объект.МожноИзменятьСпособРедактирования;
		Элементы.ДополнительныеНастройкиАдреса.Видимость   = ДоступныДополнительныеНастройкиАдреса;
		Элементы.ДополнительныеНастройкиАдреса.Доступность = Не Объект.МеждународныйФорматАдреса;
		Элементы.ВидРедактирования.Видимость = Истина;
		Элементы.ГруппаХранитьИсториюИзменений.Видимость = ХранитИсториюИзменений;
		
		ДоступностьПолейДляАдреса();
		
	Иначе
		
		Элементы.ДополнительныеНастройкиАдреса.Видимость = Ложь;
		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.АдресЭлектроннойПочты;
			Элементы.ВидРедактирования.Видимость = Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Skype;
			Элементы.ВидРедактирования.Видимость = Ложь;
			Элементы.РазрешитьВводНесколькихЗначений.Доступность = Истина;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
			Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Телефон;
			Элементы.ВидРедактирования.Доступность = Объект.МожноИзменятьСпособРедактирования;
			Элементы.ВидРедактирования.Видимость = Истина;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = ХранитИсториюИзменений;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Другое;
			Элементы.ВидРедактирования.Доступность = Ложь;
			Элементы.ВидРедактирования.Видимость = Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.ВидРедактирования.Видимость = Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		Иначе
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.ВидРедактирования.Доступность = Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьПолейДляАдреса()
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидРедактирования = "ПолеВвода" Тогда
		Объект.ВключатьСтрануВПредставление = Ложь;
		Элементы.ВключатьСтрануВПредставление.Доступность = Ложь;
	Иначе
		Элементы.ВключатьСтрануВПредставление.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.ХранитьИсториюИзменений.Доступность = Объект.ВидРедактирования = "Диалог";
	Иначе
		
		ФлагХранитьИсториюИзменений             = Ложь;
		ДоступностьФлагаХранитьИсториюИзменений = Ложь;
		
		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Объект.ВидРедактирования = "ПолеВвода";
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
			Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			ФлагХранитьИсториюИзменений             = Объект.ХранитьИсториюИзменений;
			ДоступностьФлагаХранитьИсториюИзменений = Объект.ВидРедактирования = "Диалог";
		Иначе
			Объект.ВидРедактирования = "ПолеВводаИДиалог";
		КонецЕсли;
		Объект.ХранитьИсториюИзменений               = ФлагХранитьИсториюИзменений;
		Элементы.ХранитьИсториюИзменений.Доступность = ДоступностьФлагаХранитьИсториюИзменений;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыНастроекАдреса(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЭлементовТелефонаФакса(Форма)

	Форма.Элементы.ШаблонМаскиНомераТелефона.Доступность = Форма.Объект.ВводитьНомерПоМаске;
	Форма.Элементы.ШаблонМаскиНомераТелефона.АвтоОтметкаНезаполненного  = Форма.Объект.ВводитьНомерПоМаске;  
	Форма.Элементы.МаскаПриВводеНомераТелефона.Доступность = (НЕ Форма.Объект.ТелефонСДобавочнымНомером И НЕ Форма.Объект.ВидРедактирования = "Диалог") ИЛИ Форма.Объект.ВводитьНомерПоМаске;
    Форма.Элементы.ТелефонСДобавочнымНомером.Доступность = НЕ Форма.Объект.ВводитьНомерПоМаске ИЛИ Форма.Объект.ТелефонСДобавочнымНомером;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредлагаемоеЗначениеИдентификатора()
	
	ПредлагаемыйИдентификатор = "";
	Если Не Элементы.ИдентификаторДляФормул.ТолькоПросмотр Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
			МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
			СуффиксТекущегоЯзыка = МодульМультиязычностьСервер.СуффиксТекущегоЯзыка();
			Представление = ?(ЗначениеЗаполнено(СуффиксТекущегоЯзыка),
				Объект["Наименование"+ СуффиксТекущегоЯзыка],
				Объект.Наименование);
		Иначе
			Представление = Объект.Наименование;
		КонецЕсли;
		
		ПредлагаемыйИдентификатор = Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(
			Представление, Объект.Ссылка, Объект.Родитель);
		Если ПредлагаемыйИдентификатор <> Объект.ИдентификаторДляФормул Тогда
			Объект.ИдентификаторДляФормул = ПредлагаемыйИдентификатор;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИдентификаторДляФормулНаСервере()
	
	ЗаголовокДляИдентификатора = ЗаголовокДляИдентификатора(Объект);
	
	Объект.ИдентификаторДляФормул = Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(
		ЗаголовокДляИдентификатора, Объект.Ссылка, Объект.Родитель);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаголовокДляИдентификатора(ТекущийОбъект)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		СуффиксТекущегоЯзыка = МодульМультиязычностьСервер.СуффиксТекущегоЯзыка();
		ЗаголовокДляИдентификатора = ?(ЗначениеЗаполнено(СуффиксТекущегоЯзыка),
			ТекущийОбъект["Наименование"+ СуффиксТекущегоЯзыка],
			ТекущийОбъект.Наименование);
	Иначе
		ЗаголовокДляИдентификатора = ТекущийОбъект.Наименование;
	КонецЕсли;
	
	Возврат ЗаголовокДляИдентификатора;
	
КонецФункции

&НаКлиенте
Процедура ПослеОтветаНаВопросКогдаИдентификаторДляФормулУжеИспользуется(Ответ, ПараметрыЗаписи) Экспорт
	
	Если Ответ <> "ПродолжитьЗапись" Тогда
		Если ПараметрыЗаписи.Свойство("ОбработкаПродолжения") Тогда
			ВыполнитьОбработкуОповещения(
				Новый ОписаниеОповещения(ПараметрыЗаписи.ОбработкаПродолжения.ИмяПроцедуры,
					ЭтотОбъект, ПараметрыЗаписи.ОбработкаПродолжения.Параметры),
				Истина);
		КонецЕсли;
	Иначе
		ПараметрыЗаписи.Вставить("КогдаИдентификаторДляФормулУжеИспользуется");
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидКИСТакимНаименованиемУжеСуществует(ТекущийОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Наименование = &Наименование
		|	И ВидыКонтактнойИнформации.Родитель = &Родитель
		|	И ВидыКонтактнойИнформации.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", ТекущийОбъект.Наименование);
	Запрос.УстановитьПараметр("Родитель",     ТекущийОбъект.Родитель);
	Запрос.УстановитьПараметр("Ссылка",       ТекущийОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция ИдентификаторДляФормулУжеИспользуется(Знач ИдентификаторДляФормул, Знач ТекущийВидКонтактнойИнформации, Знач Родитель)
	
	ПроверочныйИдентификатор = Справочники.ВидыКонтактнойИнформации.ИдентификаторДляФормул(ИдентификаторДляФормул);
	Если ВРег(ИдентификаторДляФормул) <> ВРег(ПроверочныйИдентификатор) Тогда
		ТекстВопроса = НСтр("ru = 'Идентификатор ""%1"" не соответствует правилам именования переменных.
		                          |Идентификатор не должен содержать пробелов и специальных символов.
		                          |
		                          |Создать новый идентификатор для формул и продолжить запись?'");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстВопроса,
			ИдентификаторДляФормул);
		Возврат ТекстВопроса;
	КонецЕсли;
	
	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКонтактнойИнформации.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул = &ИдентификаторДляФормул
	|	И ВидыКонтактнойИнформации.Ссылка <> &Ссылка
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&Родитель)";
	
	Запрос.УстановитьПараметр("Ссылка", ТекущийВидКонтактнойИнформации);
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", ИдентификаторДляФормул);
	Запрос.УстановитьПараметр("Родитель", РодительВерхнегоУровня);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Существует вид контактной информации с идентификатором для формул
	                          |""%1"".
	                          |
	                          |Рекомендуется использовать другой идентификатор для формул,
	                          |иначе программа может работать некорректно.
	                          |
	                          |Создать новый идентификатор для формул и продолжить запись?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстВопроса,
		ИдентификаторДляФормул);
	
	Возврат ТекстВопроса;
	
КонецФункции

#КонецОбласти

