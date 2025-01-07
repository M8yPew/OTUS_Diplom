﻿#language: ru
@tree
@ExportScenarios

Функционал: Подготовка НСИ

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: НСИ.Подготовка данных

	// Справочник.Контрагенты

	И я проверяю или создаю для справочника "Контрагенты" объекты:
		| 'Ссылка'                                                                 | 'ПометкаУдаления' | 'Код'       | 'Наименование' |
		| 'e1cib/data/Справочник.Контрагенты?ref=8cbfd8c0a6239dd611efc92059a9291f' | 'False'           | '000000001' | 'Покупатель 1' |

	// Справочник.Номенклатура

	И я проверяю или создаю для справочника "Номенклатура" объекты:
		| 'Ссылка'                                                                  | 'ПометкаУдаления' | 'Код'       | 'Наименование' |
		| 'e1cib/data/Справочник.Номенклатура?ref=8cbfd8c0a6239dd611efc92059a92921' | 'False'           | '000000001' | 'Товар 1'      |

	// Справочник.Склады

	И я проверяю или создаю для справочника "Склады" объекты:
		| 'Ссылка'                                                            | 'ПометкаУдаления' | 'Код'       | 'Наименование' |
		| 'e1cib/data/Справочник.Склады?ref=8cbfd8c0a6239dd611efc92059a92920' | 'False'           | '000000001' | 'Основной'     |

