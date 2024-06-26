#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Предотвращает недопустимое изменение идентификаторов объектов метаданных.
// Выполняет обработку дублей подчиненного узла распределенной информационной базы.
//
Процедура ПередЗаписью(Отказ)
	
	СтандартныеПодсистемыПовтИсп.СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// Регистрация объекта на всех узлах РИБ.
	Для Каждого ПланОбмена Из СтандартныеПодсистемыПовтИсп.ПланыОбменаРИБ() Цикл
		СтандартныеПодсистемыСервер.ЗарегистрироватьОбъектНаВсехУзлах(ЭтотОбъект, ПланОбмена);
	КонецЦикла;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверитьОбъектПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

// Предотвращает удаление идентификаторов объектов метаданных не помеченных на удаление.
Процедура ПередУдалением(Отказ)
	
	СтандартныеПодсистемыПовтИсп.СправочникИдентификаторыОбъектовМетаданныхПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	// Ссылки идентификаторов удаляются независимо во всех узлах
	// через механизм пометки удаления и удаления помеченных объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ВызватьИсключениеПоОшибке(
			НСтр("ru = 'Удаление идентификаторов объектов метаданных, у которых значение
			           |реквизита ""Пометка удаления"" установлено Ложь недопустимо.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
