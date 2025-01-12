﻿#language: ru

@tree

Функционал: 5. Выдача распоряжения на Отгрузку

Как Менеджер по продажам я хочу
выдать распоряжение на отгрузку 
чтобы склад отгрузил ТМЦ   

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Выдача распоряжения на Отгрузку

	* Подготовка
		И я закрываю все окна клиентского приложения
		И я откатываю изменения инициатора данных
		И НСИ.Подготовка данных
		И Остатки.Приобретение товаров
		И Я запоминаю значение выражения 'ТекущаяДата()' в переменную "ДатаДокумента"

		* Создание Заказа
			
			Когда Я нахожу или создаю объект "Документы.ЗаказКлиента" с именем "ЗаказКлиента" на дату "$ДатаДокумента$"
			Тогда я заполняю реквизиты объекта "ЗаказКлиента" по таблице: 
				| 'Имя'        | 'Значение'     | 'КакИскать' |
				| 'Контрагент' | "Покупатель 1" | ''          |
				| 'Склад'      | "Основной"     | ''          |
			И я заполняю табличную часть "Товары" объекта "ЗаказКлиента" по таблице:
				| "Номенклатура" | "Цена"  | "Количество" | "Сумма"   |
				| "Товар 1"      | "10,00" | "100,00"     | "1000,00" |
									
		* Проведение Заказа
		
			Когда я записываю документ "ЗаказКлиента" в режиме "Проведение"
			Тогда я выполняю код встроенного языка на сервере без контекста с передачей переменных
			"""bsl
				Контекст.Вставить("НомерДокумента", Строка(Контекст.ЗаказКлиента.Номер));
			"""
			

	* Открыть форму списка заказов клиента
		
		Когда В командном интерфейсе я выбираю "Продажи" "Заказ клиента"

	* Открыть форму документа заказ клиента
		
		Тогда в таблице 'Список' я перехожу к строке:
				| "Номер"     |
				| "$НомерДокумента$" |
		И в таблице 'Список' я выбираю текущую строку

	* Проверить доступность команды "К отгрузке"

		Когда открылось окно "Заказ клиента $НомерДокумента$ от *"
		Тогда я активизирую поле 'К отгрузке'		
		//И я жду доступности элемента "ТоварыКСборке" в течение 2 секунд

	* Выполнить команду "К отгрузке"
		
		Когда открылось окно "Заказ клиента $НомерДокумента$ от *"
		Тогда я нажимаю на кнопку с именем 'ТоварыКотгрузке'
		И Пауза 2
					
	* Статус документа равен "К отгрузке"
		
		Когда открылось окно "Заказ клиента $НомерДокумента$ от *"
		Тогда элемент формы с именем 'Статус' стал равен "Отгрузить"

	* Очистка 
		И я закрываю все окна клиентского приложения
		И я откатываю изменения