﻿#language: ru

@tree
@ExportScenarios

Функционал: Приобретение товаров

Как менеджер по закупкам я хочу
ввести документ поступление товаров
чтобы отразить поступление ТМЦ   

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Остатки.Приобретение товаров

	// Документ.ПоступлениеТоваров

	* Подготовка	
		И я закрываю все окна клиентского приложения
		И я откатываю изменения инициатора данных
		И Я запоминаю значение выражения 'ТекущаяДата()' в переменную "ДатаДокумента"
		И НСИ.Подготовка данных
	* Создание накладной
		Когда Я нахожу или создаю объект "Документы.ПоступлениеТоваров" с именем "ПоступлениеТоваров" на дату "$ДатаДокумента$"
		Тогда я заполняю реквизиты объекта "ПоступлениеТоваров" по таблице: 
			| 'Имя'        | 'Значение'     | 'КакИскать' |
			| 'Контрагент' | "Покупатель 1" | ''          |
			| 'Склад'      | "Основной"     | ''          |
		И я заполняю табличную часть "Товары" объекта "ПоступлениеТоваров" по таблице:
			| "Номенклатура" | "Цена"  | "Количество" | "Сумма"   |
			| "Товар 1"      | "10,00" | "100,00"     | "1000,00" |
									
	* Проведение
		
		Когда я записываю документ "ПоступлениеТоваров" в режиме "Проведение"

	* Проверка результатов проведения	

		Тогда Я проверяю, что движения документа "ПоступлениеТоваров" по регистру "ТоварыОрганизаций" идентичны таблице:
			| 'Период'          | 'Регистратор'          | 'НомерСтроки' | 'Склад'    | 'Номенклатура' | 'Количество' | 'Сумма'    |
			| "$ДатаДокумента$" | "$ПоступлениеТоваров$" | '1'           | 'Основной' | 'Товар 1'      | '100,00'     | '1 000,00' |
		
			
		